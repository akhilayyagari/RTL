# SDAccel RTL Kernel Tutorial

SDAccel RTL kernel tutorial explains the procedure for integrating an exsiting RTL with the SDAccel Flow. 

Thsi tutorial is divided into 5 Segments
 1. AES128 Design Overiew 
 
 2. RTL Kernel Wizard 

  	 2.1 Launching RTL kernel Wizard
	 
	 2.2 What RTL gets generated

 3. Integrating Your Kernel with SDAccel Flow
 	  
	  3.1 Kernel with(out) AXIMM Interface
 	 
 4. Integrating AES128 Core with the RTL Kernel Flow
 
 5. Generating XO file and packaging the RTL Kernel


# 1. AES128 Design Overview
Download the Design files from the this link https://opencores.org/project,systemcaes

The Hierarchy of the design files is as shown below. 

![image](https://user-images.githubusercontent.com/32319498/38529264-abcea81c-3c18-11e8-9500-ca1cdc150b91.png)

In This tutorail we will use the AES128 core two times

1. First we encrypt the Input data
2. Second we decrypt the same data and output it to the testbench

 ![image](https://user-images.githubusercontent.com/32319498/31142684-e1b2e09c-a82f-11e7-9741-ce0f1c4ce054.png)
	

 The Design files contain a Testbench which has a checker module to verify the input and output data.
		
Today, we will use this aes128lowarea design and integrate it with the SDAccel Flow.

# 2. RTL Kernel Tutaoril
 
## 2.1 Launching the RTL Kernel Wizard
 The RTL Kernel Wizard can be launched with two different methods: from the SDx™ Development Environment or from the Vivado® IDE. 	 The SDx Development Environment provides a more seemless experience, but IP management is limited. The Vivado IDE is recommended 	  if multiple kernels are going to be generated and allows for better re-entrant workflows.

To launch the RTL Kernel Wizard from the SDx Development Environment, do the following
   
   1. Launch SDx Development Environment(SDX 2017.1).
   
   2. Create a SDx Project.
   
   3. Click Xilinx > Create RTL Kernel....

   The wizard is organized into pages that break down the process of creating a kernel into smaller steps. To navigate between pages,    use the Next and Back buttons. To finalize the kernel and build a project based on the wizards inputs, click the OK button. Each of the following sections describes each page and its input options.
 
####   1. Welcome to SDx Kernel Wizard
   This page gives an abbreviated version of the workflow and the steps for following the wizard.
  	RTL Kernel Wizard General Settings
	
   1. Kernel Identification
   	1.1 Name of the Kernel - sdx_kernel_wizard.
	  This will be the name of the RTL IP. This name is also used in the host code.
	1.2 Kernel vendor 
	   Xilinx.com
   
   2. Kernel Options
   	2.1 kernel Type - At present RTL and Block Design .A RTL kernel type consists of a Verilog RTL top level module with a Verilog control register module and a Verilog kernel example inside the top. Block Design kernel type also delivers a Verilog RTL top level module, but instead it instantiates an IP integrator Block Diagram inside of a verilog RTL top level module (see UG1023 for more information). This Lab uses RTL Kernel.
   	
   3. Clocking Options - RTL Kernel Supports 2 Clocking options
   
####   2. Scalar Arguments 
   Scalar arguments are used to pass control type of information to the kernels. Scalar arguments can not be read back from the host. For each argument that is specified a corresponding control register is created to facilitate passing the argument from software to hardware.

Please refer to ug1023 Page 91 for more information

#### 3. Global Memory 
   Global memory is accessed by the kernel through AXI4 master interfaces. Each AXI4 interface operates independently of each other. Each AXI4 interface can be connected to one or more memory controllers to off-chip memory such as DDR4. Global memory is primarily used to pass large data sets to and from the kernel from the host. It can also be used to pass data between kernels.

Please refer to ug1023 for more information

#### 4. Summary 
This page gives a summary of the VLNV, software function prototype and hardware control registers created from options selected in the previous pages. The function prototype conveys what a kernel call would like if it was a C function. See the host code generated example of how to set the kernel arguments for the kernel call. The register map shows the relationship between host software ID, argument name, hardware register offset, type, and associated interface. Review this page to for correctness before proceeding to generating the kernel.

#### 5. Finalizing and Generating the Kernel from the RTL Wizard
If the RTL Kernel Wizard was launched from SDx, after clicking OK, the example Vivado project opens

## 2.2 Vivado - RTL Kernel 

The Wizard generates an RTL which has an interface of 

   1. One AXI4 Slave Lite Interface
   2. One or more AXI4 FUll Interface
	
![image](https://user-images.githubusercontent.com/32319498/38528947-e14ac5a4-3c16-11e8-8ae9-eb2c7a9e8770.png)


### 1. Operation of the Kernel 
   As shown in the above figure, the operation of the Kernel is divided into 7 steps.
   
  1.The Host will start the kernel by writing into the control register throught the AXI4 Slave Lite Interface. Along with the control 		data it will also write Read/Write Address, Values of the Scalare arguments. 
  
  2. This Read/Write address are fed to the AXIMM Full Read and AXIMM Full write modules. 
  
  3. The AXIMM Read will read the data from the global memory and write it to the internal Read FIFO.
  
  4. The VADD example has a control logic which monitors the FIFO full/empty signals.
  
  5. The VADD module will read from the FIFO process the data and writes it to the Write FIFO.
  
  6. Once the write FIFO has data, The AXIMM Write will write it back to the Global Memory.
  
  7. Once the write is done, the kernel will assert a ap_done signal. 
  
  8. The host will monitor this signal and when it is high, it reads the data from the global memory. 

# 3. Integration of your kernel with SDAccel Flow
The custom IP can have 2 different types of interfaces

1. It can be have a AXIMM Interface

   If the exsisting design has an AXIMM Interface, we still need to define the number of AXIMM interface in thw Wizard. 		

2. It is not a AXIMM Interface

    If the exsisting design is not a AXIMM Interface then we can leverage the exsisting FIFO interface by writing a control 		logic which takes the data from the write FIFO, generates the control signals and gives it to the DUT. 

# 4. Integrating the AES128 Core with SDAccel Flow.

1. Selection of % Scalar arguments and % Master Interfaces in the Wizard
  
  1.1 - number of scalar arguments - 1  
  1.2 - Number of AXIMM interface  - 1 
  
 As shown in the below figure replace the vADD module with the custom IP. In the repository, there is a file with the name "sdx_kernel_wizard_vadd.v", in this file from line 271 to 339 is the custom logic which handles the transactions.

![image](https://user-images.githubusercontent.com/32319498/38529095-b8af1dba-3c17-11e8-9813-019fd7be2839.png)

# 5. Generating the XO File and Packaginig RTL Kernel 
The final step in creating an SDx kernel is to package the generated vivado project into an xo file. 

In vivado, click on the `Generate RTL Kernel` button in the GUI to create the kernel. 

![image](https://user-images.githubusercontent.com/32319498/31957392-7ddac1dc-b8a3-11e7-9b56-8c8aaaf76226.png)

This will package the project as an IP, and then package the IP as a kernel xo file. The IP will be available in the directory <Kernel name>_v1_0. The xo ile wil be called <Kernel name>.xo. Import the kernel xo file into the SDx project to use the kernel in the SDx project.
 
