# BAS(Beetle Antennae Search)
Beetle antennae search (BAS) is a newly developed meta-heuristic algorithm which is effectively used for optimizing objective functions of complex forms or even unknown forms. The common practice for implementing meta-heuristic algorithms including the BAS largely relies on programming in a high-level language and executing the code on a computer platform. However, the high-level implementation of the BAS algorithm hinders it from being used in an embedding system, where real-time operations are
normally required. To address this limitation, we present an approach to implementing the BAS algorithm ona field-programmable gate array (FPGA). Specially, we program the BAS function in the Verilog hardware description language (HDL), which provides a tractable vehicle for implementing the BAS algorithm at the gate level on the FPGA chip. We simulate our Verilog HDL based BAS module with the Xilinx Vivado. Simulation results validate the feasibility of our proposed Verilog HDL implementation of the
BAS.

## Introduction
The beetle antennae search (BAS) algorithm is developed in terms of simulating a beetle's behavioral trajectory for foraging food. In a strange environment, the beetle uses the two antennae on its head to conduct a series of flying and landing behaviors for the foraging. In the initial stage of the foraging, the beetle does not know where the food source is, and its two antennae are oriented randomly. It guesses the direction of the food through the odorants received by the antennae. The beetle judges which antenna receives the stronger odor, and accordingly uses its orientation as the estimated direction of the food source. Then the beetle flies along the estimated direction for a certain distance and lands with the two antennae oriented randomly. One cycle of the beetle antennae search consists of a directional flying procedure and a randoml directional landing procedure. The cycle is repeated until the final food source is located. Such repetitivee procedures are illustrated the Figure1.

![image](https://user-images.githubusercontent.com/44607144/233145753-4acb3e5d-90f4-4f23-a785-64d0eb826ed9.png)
                                       
                                       
# Contributors
* Tejas BN 
* Rakshit Bhatia
* Himanshu Rai
* Aman Prajapati

# Refrences
[ Z. Yue, G. Li, X. Jiang, S. Li, J. Cheng and P. Ren, "A Hardware Descriptive Approach to Beetle Antennae Search," in IEEE Access, vol. 8, pp. 89059-89070, 2020, doi: 10.1109/ACCESS.2020.2993600 ]




