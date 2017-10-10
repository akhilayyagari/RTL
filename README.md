# SDAccel RTL Kernel Tutorial

This tutorial explains the procedure for creating a RTL Kernel using SDAccel Flow. 

The steps for creating an RTL Kernel are:
1. Summary of Design Overiew 
2. Launching RTL Kernel Wizard.  
3. Integrating the DUT with the FIFO Interface.
4. Debug and Verification of RTL Kernel. 
5. References

This tutorial uses the aes128 crypto core example from the opensource. 

## Design files 
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
6. The scalar window asks for number of scalar arguments in the design.Scalar arguments are used to pass control type of information to the kernels. Scalar arguments can not be read back from the host. This design doesn't have any constants, so we will keep the number of scalar arguments to default '1'and click next.

### Scalar Input Argument Definition
#### Argument name 
  The argument name is used in the generated Verilog control register module as an output signal. Each argument is assigned an ID value. This ID value is used to access the argument from the host software. The ID value assignments can be found on the summary page of this wizard. To ensure maximum compatibility, the argument name follows the same identifier rules as the Kernel name.
#### Argument type
Specifies the the data type of the argument. This will affect the width of the control register in the generated Verilog module. The data types available are limited to the ones specified by the OpenCL version 2.0 specification. Data types that represent a bit
width greater than 32 bits will require two write operations to the control registers.

   ![image](https://user-images.githubusercontent.com/32319498/31148005-5f33d7f0-a840-11e7-8d35-e5e4137240e0.png)


7. Global memory is accessed by the kernel through AXI4 master interfaces. Each AXI4 interface operates independently of each other. Each AXI4 interface may be connected to one or more memory controllers to off chip memory such as DDR4. Global memory is primarily used to pass large data sets to and from the kernel from the host. It can also be used to pass data between kernels. This design has one AXI Master port and four arguments associated with it, once selected click Next.

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

   ![image](https://user-images.githubusercontent.com/32319498/31148998-4a390d4a-a843-11e7-9d42-c791d78e6bdb.png)


8. This page gives a summary of the VLNV, software function prototype and hardware control registers created from options selected in the previous pages. The function prototype conveys what a kernel call would like if it was a C function.

   ![image](https://user-images.githubusercontent.com/32319498/31149215-036fc132-a844-11e7-96fd-83bb64cef1db.png)  

After clicking OK in the summary page, flow will be directed to Vivado. 

# 3.Integrating DUT with FIFO Interface
 Xilinx has already developed a custom logic for interfacing the aes design with the FIFO Interface. The hirearchy should like this excluding the DUT. Steps to Integrate the DUT.

1. Click the add files option and import all aes128 verilog files.
2.1 The repository contains a **sdx_kernel_wizard_0_example_vadd.sv** which contains the custom logic for interfacing with the FIFO.
2.2 Copy this file contents and paste in the sdx_kernel_wizard_0_example_vadd.sv

After doing these steps, the hirearchy structure should look like this.
   ![image](https://user-images.githubusercontent.com/32319498/31149404-abaf5682-a844-11e7-9e89-62af7aedf5ec.png)


# 4. Debug and Verification of RTL Kernel
1. RTL kernels should be verified in their own test bench using advanced verification techniques including Verification components, randomization, and protocol checkers. The AXI Verification IP (AXI VIP) is available in the Vivado® IP catalog and can help with verification of AXI interfaces. The RTL kernel example designs contain an AXI VIP based test bench with sample
stimulus files. 
2. The hardware emulation flow should not be used for functional verification because it does not accurately represent the range of possible protocol signalling conditions that real AXI traffic in hardware may incur. Hardware emulation should be used to test the host code software integration or to view the interaction between multiple kernels.
## 4.1 
If you expand the simulation sources in the sources tab, you will see the AXI VIP module as sdx_kernel_wizard_0_exdes_tb_basic. The testbench should be changed depending upon the user specifications. This example needs initial data to be set in a memory so a slave memory model is used in the testbench, by using backdoor memory write it is filled with initial data. Now, the design and testbench are ready for simulation (increase the simulation time, default set to 1us). 



# 5. Referneces
1. https://www.xilinx.com/support/documentation/ip_documentation/axi_vip/v1_0/pg267-axi-vip.pdf
