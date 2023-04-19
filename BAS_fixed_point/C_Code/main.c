#include "xparameters.h"
#include "xil_io.h"
#include "xbasic_types.h"
#include "sleep.h"

int main()
{	xil_printf("\n");
	xil_printf("Start of BAS\n\n");

	u32 done, xo, yo, fo, temp;
	temp = 0x0000ffff;

	xil_printf("-----------------------Initial values------------------------\n\n");
	xil_printf(" Seed1:   0b010101010\n");
	xil_printf(" Seed2:   0b001100111\n");
	xil_printf(" Number of iterations:    255\n");
	xil_printf(" x (initial):    65\n");
	xil_printf(" y (initial):    -127\n");
	xil_printf(" Sensing Distance:    21\n");
	xil_printf(" Flight Distance:     21\n");
	xil_printf(" Objective Function f (Initial):    38420\n\n\n");

	Xil_Out32(XPAR_MYIP_BAS_FIXED_0_S00_AXI_BASEADDR, 0x000002ff);
	Xil_Out32(XPAR_MYIP_BAS_FIXED_0_S00_AXI_BASEADDR+4, 0x0000ceaa);
	Xil_Out32(XPAR_MYIP_BAS_FIXED_0_S00_AXI_BASEADDR+8, 0x81004100);
	Xil_Out32(XPAR_MYIP_BAS_FIXED_0_S00_AXI_BASEADDR+12, 0x00014005);

	Xil_Out32(XPAR_MYIP_BAS_FIXED_0_S00_AXI_BASEADDR, 0x000000ff);
	sleep(1);
	Xil_Out32(XPAR_MYIP_BAS_FIXED_0_S00_AXI_BASEADDR, 0x000002ff);
	sleep(1);
	Xil_Out32(XPAR_MYIP_BAS_FIXED_0_S00_AXI_BASEADDR, 0x000001ff);
	sleep(2);
	Xil_Out32(XPAR_MYIP_BAS_FIXED_0_S00_AXI_BASEADDR, 0x000000ff);

	for(;;)
	{
		sleep(1);
		done = Xil_In32(XPAR_MYIP_BAS_FIXED_0_S00_AXI_BASEADDR+24);
		if(done)
		{
			break;
		}
	}

	xo = Xil_In32(XPAR_MYIP_BAS_FIXED_0_S00_AXI_BASEADDR+16);
	yo = Xil_In32(XPAR_MYIP_BAS_FIXED_0_S00_AXI_BASEADDR+16);
	fo = Xil_In32(XPAR_MYIP_BAS_FIXED_0_S00_AXI_BASEADDR+20);

	yo = yo>>16;
	xo = xo&temp;

	xil_printf("-----------------------After Optimization------------------------\n\n");
	xil_printf(" x (After Optimization):    00%x (fixed hexadecimal)\n", xo);
	xil_printf(" y (After Optimization):    00%x (fixed hexadecimal)\n", yo);
	xil_printf(" Objective Function f (After Optimization):    0000%x (fixed hexadecimal)\n", fo);
	xil_printf(" Number of Clock Pulses required (40MHz):    255");
	return 0;
}
