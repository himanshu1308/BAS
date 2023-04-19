#include "xparameters.h"
#include "xil_io.h"
#include "xbasic_types.h"
#include "sleep.h"


unsigned char lfsr= 0xFEu;
unsigned bit;

unsigned rand1()
{
	bit = ((lfsr >> 0) ^ (lfsr >> 2) ^ (lfsr >> 3) ^ (lfsr >> 5) ) & 1;
	return lfsr = (lfsr >> 1) | (bit << 7);
}

float findSqrt(float x)
{
    float y = x;
    float z = (y + (x / y)) / 2;

    while ((y - z) >= 0.00001 || (z-y) >= 0.00001) {
        y = z;
        z = (y + (x / y)) / 2;
    }
    return z;
}

float func(float xax, float xay)
{
	return ((xax+2*xay-7)*(xax+2*xay-7)+(2*xax+xay-5)*(2*xax+xay-5));
}

int main()
{
		float dirx, diry, norm;
		float xrx, xry, xlx, xly, xx, xy, p, dfx, dfy, eta, xx_temp, xy_temp, f, f_temp;
		u32 clk_cnt;

		p = 80;
		eta = 80;
		xx = 65;
		xy = -127;

		f = func(xx, xy);

		xil_printf("-----------------------Initial values------------------------\n\n");
		xil_printf(" Number of iterations:    255\n");
		xil_printf(" x (initial):    65\n");
		xil_printf(" y (initial):    -127\n");
		xil_printf(" Sensing Distance:    5\n");
		xil_printf(" Flight Distance:     5\n");
		printf(" Objective Function f (Initial):    %f\n\n", f);

		Xil_Out32(XPAR_MYIP_CLKCOUNTER_0_S00_AXI_BASEADDR, 0x00000001);
		sleep(1);
		Xil_Out32(XPAR_MYIP_CLKCOUNTER_0_S00_AXI_BASEADDR, 0x00000000);

		f = func(xx, xy);
		for(int t = 0; t < 255; t++)
		{
			//Step 1
			dirx = rand1();
			diry = rand1();
			norm = findSqrt(dirx*dirx+diry*diry);
			dirx = dirx/norm;
			diry = diry/norm;

			//Step 2
			xrx = xx + p*dirx;
			xry = xy + p*diry;
			xlx = xx - p*dirx;
			xly = xy - p*diry;

			//Step 3
			if(func(xrx, xry) < func(xlx, xly))
			{
				dfx = dirx; dfy = diry;
			}
			else
			{
				dfx = -1*dirx; dfy = -1*diry;
			}

			//Step = 4
			xx_temp = xx + dfx*eta;
			xy_temp = xy + dfy*eta;
			f_temp = func(xx_temp, xy_temp);

			if(f_temp < f)
			{
				xx = xx_temp;
				xy = xy_temp;
				f = f_temp;
			}

			//Step - 5
			p = 0.95*p+0.01;
			eta = eta*0.95;
		}

		clk_cnt = Xil_In32(XPAR_MYIP_CLKCOUNTER_0_S00_AXI_BASEADDR+4);
		xil_printf("-----------------------After Optimization------------------------\n\n");
		printf(" x (After Optimization):    %f\n", xx);
		printf(" y (After Optimization):    %f\n", xy);
		printf(" Objective Function f (After Optimization):    %f\n", f);
		printf(" Number of Clock Pulses required (100MHz):    %ld\n", clk_cnt);

		return 0;
}
