# SDAccel RTL Kernel Tutorial

SDAccel RTL kernel tutorial explains the procedure for integrating an exsiting RTL with the SDAccel Flow. 

The tutorial is divided into 5 Segments
 1. AES128 Design Overiew 
 2. RTL Kernel Wizard 
  2.1 Launching RTL kernel Wizard
  2.2 What RTL gets generated
     2.2.1 AXI4 Lite Slave Interface
     2.2.2 AXIMM Interface
     2.2.3 Testbench 
 3. Integrating Your Kernel with SDAccel Flow
   3.1 Kernel with(out) AXIMM Interface
   3.2 Testbench 
 4. Integrating AES128 Core with the RTL Kernel Flow
 5. Generating XO file and packaging the RTL Kernel


1. AES128 Design Overview
Download the Design files from the this link https://opencores.org/project,systemcaes
The Hierarchy of the design files is as follows. 

[hierarchy](https://user-images.githubusercontent.com/32319498/31956578-abacabe6-b8a0-11e7-8dec-ab22b29898cf.PNG)

In This tutorail we will use the AES128 core two times
	1. First we encrypt the Input data
	2. Second we decrypt the same data and output it to the testbench

![image](https://user-images.githubusercontent.com/32319498/31142684-e1b2e09c-a82f-11e7-9741-ce0f1c4ce054.png)

The design Interface is as follows 
	1. CLK - Clock 
	2. RST - Reset
	3. Load - Load Singal
	4. DECRYPT - 
	5. DATA_IN - Input Data
	6. Key - Key 
	7. DATA_OUT - Cipher
The Design files contain a Testbecnh which has a checker module to verify the input and output data.
		
Today, we will use the aes128lowarea design and integrate it with the SDAccel Flow.

2. RTL Kernel Tutaoril
 
 2.1 Launching the RTL Kernel Wizard
	The RTL Kernel Wizard can be launched with two different methods: from the SDx™ Development Environment or from the Vivado® IDE. 	 The SDx Development Environment provides a more seemless experience, but IP management is limited. The Vivado IDE is recommended 	  if multiple kernels are going to be generated and allows for better re-entrant workflows.
To launch the RTL Kernel Wizard from the SDx Development Environment, do the following
   1. Launch SDx Development Environment(SDX 2017.1).
   2. Create a SDx Project.
   3. Click Xilinx > Create RTL Kernel....

   The wizard is organized into pages that break down the process of creating a kernel into smaller steps. To navigate between pages,    use the Next and Back buttons. To finalize the kernel and build a project based on the wizards inputs, click the OK button. Each of the following sections describes each page and its input options.
 
1. Welcome to SDx Kernel Wizard
	This page gives an abbreviated version of the workflow and the steps for following the wizard.
  RTL Kernel Wizard General Settings
    1. Kernel Identification
    2. Kernel Options
    3. Clocking Options
2. Scalar Arguments 
  Scalar arguments are used to pass control type of information to the kernels. Scalar arguments can not be read back from the host. For each argument that is specified a corresponding control register is created to facilitate passing the argument from software to hardware.

Please refer to ug1023 Page 91 for more information

3. Global Memory 
   Global memory is accessed by the kernel through AXI4 master interfaces. Each AXI4 interface operates independently of each other. Each AXI4 interface can be connected to one or more memory controllers to off-chip memory such as DDR4. Global memory is primarily used to pass large data sets to and from the kernel from the host. It can also be used to pass data between kernels.

Please refer to ug1023 Page 91 for more information

4. Summary 
This page gives a summary of the VLNV, software function prototype and hardware control registers created from options selected in the previous pages. The function prototype conveys what a kernel call would like if it was a C function. See the host code generated example of how to set the kernel arguments for the kernel call. The register map shows the relationship between host software ID, argument name, hardware register offset, type, and associated interface. Review this page to for correctness before proceeding to generating the kernel.

5. Finalizing and Generating the Kernel from the RTL Wizard
If the RTL Kernel Wizard was launched from SDx, after clicking OK, the example Vivado project opens

2.2 Vivado - RTL Kernel 

