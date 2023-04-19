#include "xparameters.h"
#include "xil_io.h"
#include "xbasic_types.h"
#include "sleep.h"

int main()
{	xil_printf("\n");
	xil_printf("Start of BAS\n\n");

	u32 clk_cnt, xo, yo, fo;
	u8 done;
	//Provide input to bas
	xil_printf("Initial Conditions Considered (Inputs to BAS)\n\n");

	xil_printf("-----------------------Initial values------------------------\n\n");
	xil_printf(" Seed1:   0b000100001\n");
	xil_printf(" Seed2:   0b000100001\n");
	xil_printf(" Number of iterations:    255\n");
	xil_printf(" x (initial):    65\n");
	xil_printf(" y (initial):    -127\n");
	xil_printf(" Sensing Distance:    5\n");
	xil_printf(" Flight Distance:     5\n");
	xil_printf(" Objective Function f (Initial):    38420\n\n\n");


	Xil_Out32(XPAR_MYIP_BAS_BF16_0_S00_AXI_BASEADDR, 0x000002ff);
	Xil_Out32(XPAR_MYIP_BAS_BF16_0_S00_AXI_BASEADDR+4, 0x00029c21);
	Xil_Out32(XPAR_MYIP_BAS_BF16_0_S00_AXI_BASEADDR+8, 0xc2fe4282);
	Xil_Out32(XPAR_MYIP_BAS_BF16_0_S00_AXI_BASEADDR+12, 0x40a040a0);

	//Removing reset signal
	sleep(1);
	Xil_Out32(XPAR_MYIP_BAS_BF16_0_S00_AXI_BASEADDR, 0x000000ff);

	for(;;)
	{
		sleep(1);
		xo = Xil_In32(XPAR_MYIP_BAS_BF16_0_S00_AXI_BASEADDR+16);
		yo = Xil_In32(XPAR_MYIP_BAS_BF16_0_S00_AXI_BASEADDR+20);
		fo = Xil_In32(XPAR_MYIP_BAS_BF16_0_S00_AXI_BASEADDR+24);
		clk_cnt = Xil_In32(XPAR_MYIP_BAS_BF16_0_S00_AXI_BASEADDR+28);
		done = fo>>16;
		if(done)
		{
			break;
		}
	}

	xil_printf("-----------------------After Optimization------------------------\n\n");
	xil_printf(" x (After Optimization):    %4x (BF16)\n", xo>>16);
	xil_printf(" y (After Optimization):    %4x (BF16)\n", yo>>16);
	xil_printf(" Objective Function f (After Optimization):    %4x (BF16)\n", (fo<<16)>>16);
	xil_printf(" Number of Clock Pulses required (8.5MHz):    %d", clk_cnt);
	return 0;
}
