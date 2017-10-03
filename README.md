# SDAccel RTL Kernel Tutorial

This tutorial explains the procedure for creating a RTL Kernel using SDAccel Flow. 

The steps for creating an RTL Kernel are:
1. Summary of Design Overiew 
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
# 1. Summary of Desing Overiew

## AES128 Encrypter and Decrpyter design overivew
The first AES128 module takes in Data and Key as inputs and outputs a cipher, the second module uses the cypher from the first module and key from the testbench and decrypt the cypher to give back the original message.    
		![image](https://user-images.githubusercontent.com/32319498/31142684-e1b2e09c-a82f-11e7-9741-ce0f1c4ce054.png)

	
