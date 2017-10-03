# SDAccel RTL Kernel Tutorial

This tutorial explains the procedure for creating a RTL Kernel using SDAccel Flow. 

The steps for creating an RTL Kernel are:
1. Design Overiew 
2. Specifying the design units to RTL Kernel Wizard.  
3. Integrating the DUT with the AXI, FIFO Interface.
4. Creating testbench. 

This tutorial uses the aes128 crypto core example from the opensource. 

## Downloading the design files 
Downlaod the design files from this link http://opencores.org/project,systemcaes  

Execute the following commands on your local machine for starting a new SDaccel project:
```
    $ mkdir crypto_core
    $ cd crypto_core                                      
    $ cp -r ~/Downlaod ./
	$ sdx_171
```
# 1. Desing Overiew

The process for capturing an arbitrary RTL design as a Xilinx object file is as follows:
