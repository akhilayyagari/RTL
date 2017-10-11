# SDAccel RTL Kernel Tutorial

This tutorial explains the procedure for creating a RTL Kernel using SDAccel Flow. 

Steps for creating a RTL Kernel are:
1. Design Overiew 
2. Launching the RTL Kernel Wizard.  
3. Integrating the DUT with the FIFO Interface.
4. Debug and Verification of RTL Kernel. 
5. Generating XO file and packaging RTL kernel 
6. SDAccel program on AWS F1
7. References

This tutorial uses aes128 crypto core example from the opensource.org  

## Design files 
Downlaod the design files from this link http://opencores.org/project,systemcaes  

# 1. Desing Overiew

## AES128 Encrypter and Decrpyter design overivew
   The DUT is instantiated in the design two times. The first instance takes in data, key and generates a cipher. The second module uses the cypher, key and decrypt the cypher to give back the original message.
   
   ![image](https://user-images.githubusercontent.com/32319498/31142684-e1b2e09c-a82f-11e7-9741-ce0f1c4ce054.png)
		

## AES128 Encrypter and Decrpyter RTL KERNEL
   A kernel can be implemented in RTL and developed using the Vivado® IDE tool suite. RTL kernels offer potentially higher performance with lower area and power but require development using RTL coding, tools, and verification methodologies. The tool generates the basic template of AXI Read/write, FIFO Interface for the user, the user has to add custom logic to talk to this interface. 
   
![image](https://user-images.githubusercontent.com/32319498/31147244-1b121048-a83e-11e7-83e6-a3f534f62ade.png)
		
# 2. Launching RTL Kernel Wizard
The RTL Kernel Wizard can be launched with two different methods: from the SDx™ Development Environment or from the Vivado® IDE. The SDx Development Environment provides a more seemless experience, but IP management is limited. The Vivado IDE is recommended if multiple kernels are going to be generated and allows for better re-entrant workflows.
1. Launch SDx Development Environment.
2. Create Project (SDAccel Product Type).
3. Click Xilinx > Create RTL Kernel....			
4. Then you will be prompted with the Create RTL Kernel window, click next. 
5. In the general settings window select the number of clocks the design needs and click next.
6. The scalar window asks for number of scalar arguments in the design.Scalar arguments are used to pass control type of information to the kernels. Scalar arguments can not be read back from the host. 

_This design doesn't have any constants as inputs, so we will keep the number of scalar arguments to default '1'and click next_.

![scalar](https://user-images.githubusercontent.com/32319498/31472131-aba90efe-aea1-11e7-9892-721ef5501b52.PNG)

7. Global memory is accessed by the kernel through AXI4 master interfaces. Each AXI4 interface operates independently of each other. Each AXI4 interface may be connected to one or more memory controllers to off chip memory such as DDR4. Global memory is primarily used to pass large data sets to and from the kernel from the host. It can also be used to pass data between kernels. 

_This current design uses one AXI Master port and four arguments associated with it, once selected click Next_.

![master_or](https://user-images.githubusercontent.com/32319498/31472114-83e8981c-aea1-11e7-9e60-959aa3c37392.PNG)

8. This page gives a summary of the VLNV, software function prototype and hardware control registers created from options selected in the previous pages. The function prototype conveys what a kernel call would like if it was a C function.

![master](https://user-images.githubusercontent.com/32319498/31472098-6c37e25e-aea1-11e7-8b4d-205ec9b5b115.PNG)


After clicking OK in the summary page, flow will be directed to Vivado. 

# 3.Integrating DUT with FIFO Interface
 Xilinx has already developed the interface logic for the user. The responsibility of the user is to integrate the DUT with the interface logic.
 
### Steps for Integrating the DUT
Once the Vivado opens
1. Click the add files option in the source tab and import all aes128 verilog files.
2.1 The repository contains a **sdx_kernel_wizard_0_example_vadd.sv** which contains the custom logic for interfacing with the FIFO.
2.2 Copy this file contents and paste in the sdx_kernel_wizard_0_example_vadd.sv

After doing these steps, the hirearchy structure should look like this.
![hirearchy](https://user-images.githubusercontent.com/32319498/31472066-3ba660ac-aea1-11e7-831a-6b67a148cef3.PNG)



# 4. Debug and Verification of RTL Kernel
1. RTL kernels should be verified in their own test bench using advanced verification techniques including Verification components, randomization, and protocol checkers. The AXI Verification IP (AXI VIP) is available in the Vivado® IP catalog and can help with verification of AXI interfaces. The RTL kernel example designs contain an AXI VIP based test bench with sample
stimulus files. 
2. The hardware emulation flow should not be used for functional verification because it does not accurately represent the range of possible protocol signalling conditions that real AXI traffic in hardware may incur. Hardware emulation should be used to test the host code software integration or to view the interaction between multiple kernels.
## 4.1. VIP for RTL Kernel 
   If you expand the simulation sources in the sources tab, you will see the AXI VIP module as **sdx_kernel_wizard_0_exdes_tb_basic**. Xilinx has provided a basic framework for the testbench, if the user needs to have a more complex testbench it should be changed depending upon the user specifications(Please refer to the references for working with Xilinx AXI VIP). The repository contains a testbench file with the name sdx_kernel_wizard_0_exdes_tb_basic. Copy the contents of the file and paste in the file which shows in the source tab. 

**NOTE : The mem_rd_addr and mem_wr_addr has to be changed(easy way of finding this is to simulate the design and note down the m00-wr_addr)**

Click on the run simulation button in the flow navigator(Change the simualtion time to 1000ms, by default it will be set to 1us). The testbench has a scoreboard logic, it uses backdoor memory read API calls and verifies it with golden data.
# 5. Generating XO file and packaging RTL kernel
 1. Click on the Generate RTL Kernal. This creates an Xxo file
 2. Go to Tools option and select Create and Pckage New IP.
 3. Select Package your current project and click next, finish. A new window will open "Package IP", go to review and package and select Package IP. This packages the your current project.
 
# 6. SDAccel program on AWS F1
Go to the below link and follow from Step 3 .

https://github.com/Xilinx/SDAccel_Examples/wiki/Run-your-first-SDAccel-program-on-AWS-F1

# 7. Referneces
1. https://www.xilinx.com/support/documentation/ip_documentation/axi_vip/v1_0/pg267-axi-vip.pdf
