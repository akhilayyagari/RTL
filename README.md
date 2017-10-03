# SDAccel RTL Kernel Tutorial

This tutorial explains the procedure for creating a RTL Kernel using SDAccel Flow. 

The steps for creating an RTL Kernel are:
1. Summary of Design Overiew 
2. Launching RTL Kernel Wizard.  
3. Integrating the DUT with the AXI, FIFO Interface.
4. Creating testbench. 

This tutorial uses the aes128 crypto core example from the opensource. 

## Downloading the design files 
Downlaod the design files from this link http://opencores.org/project,systemcaes  

# 1. Summary of Desing Overiew

## AES128 Encrypter and Decrpyter design overivew
   The first AES128 module takes in Data and Key as inputs and outputs a cipher, the second module uses the cypher from the first module and key from the testbench and decrypt the cypher to give back the original message.
   
   ![image](https://user-images.githubusercontent.com/32319498/31142684-e1b2e09c-a82f-11e7-9741-ce0f1c4ce054.png)
		

## AES128 Encrypter and Decrpyter RTL KERNEL
   A kernel can be implemented in RTL and developed using the Vivado® IDE tool suite. RTL kernels offer potentially higher performance with lower area and power but require development using RTL coding, tools, and verification methodologies. The tool generates the basic template of AXI Read/write, FIFO Interface for the user, the user has to add custom logic to talk to this interface. 
   
   ![image](https://user-images.githubusercontent.com/32319498/31147244-1b121048-a83e-11e7-83e6-a3f534f62ade.png)
		
# 2. Launching RTL Kernel Wizard
The RTL Kernel Wizard can be launched with two different methods: from the SDx™ Development Environment or from the Vivado® IDE. The SDx Development Environment provides a more seemless experience, but IP management is limited. The Vivado IDE is recommended if multiple kernels are going to be generated and allows for better re-entrant workflows
1. Launch SDx Development Environment.
2. Create Project (SDAccel Product Type).
3. Click Xilinx > Create RTL Kernel....			
4. Then you will be prompted with the Create RTL Kernel window, click next. 
5. In the general settings window select the number of clocks the design needs and click next.
6. The scalar window asks for number of scalar arguments in the design.Scalar arguments are used to pass control type of information to the kernels. Scalar arguments can not be read back from the host.  

### Scalar Input Argument Definition
#### Argument name 
  The argument name is used in the generated Verilog control register module as an output signal. Each argument is assigned an ID value. This ID value is used to access the argument from the host software. The ID value assignments can be found on the summary page of this wizard. To ensure maximum compatibility, the argument name follows the same identifier rules as the Kernel name.
#### Argument type
Specifies the the data type of the argument. This will affect the width of the control register in the generated Verilog module. The data types available are limited to the ones specified by the OpenCL version 2.0 specification. Data types that represent a bit
width greater than 32 bits will require two write operations to the control registers.

   ![image](https://user-images.githubusercontent.com/32319498/31148005-5f33d7f0-a840-11e7-8d35-e5e4137240e0.png)

Select the number of scalar arguments for the design and click next.

7. Global memory is accessed by the kernel through AXI4 master interfaces. Each AXI4 interface operates independently of each other. Each AXI4 interface may be connected to one or more memory controllers to off chip memory such as DDR4. Global memory is primarily used to pass large data sets to and from the kernel from the host. It can also be used to pass data between kernels.

### AXI Master Definition (table columns)
#### Interface Name
Specifies the name of the interface. To ensure maximum compatibility, the argument name follows the same identifier rules as the Kernel name
#### Width (bytes)
Specifies the data width of the AXI data channels. It is recommended this ismatched to the native data width of the memory controller AXI4 slave interface. The memory controller slave interface is typically 64 bytes (512 bits) wide.
#### Number of Arguments
Specifies the number of arguments to associate with this interface.Each argument represents a data pointer to global memory that the kernel can access.

### Argument Definition
#### Interface 
Specifies the name of the AXI Interface that the corresponding columns in the current row are associated to. This value is not directly modifiable, it is copied from the interface name defined in the previous table.
#### Argument name 
The argument name is used in the generated Verilog control register module as an output signal. Each argument is assigned an ID value. This ID value is used to access the argument from the host software. The ID value assignments can be found on the summary page
of this wizard. To ensure maximum compatibility, the argument name follows the same identifier rules as the Kernel name.



This project has one AXI Master port and four arguments are associated with it, open select click Next.

