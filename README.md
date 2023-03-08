# My-Custom-CPU / ISA

## Description

After getting familiar with VHDL/Verilog and CPU systems I wanted to design my own CPU Core / Instruction Set Architecture capable of "running" its own assembly code.<br>
I took inspiration from the ALU implementations in Verilog in order to make something bigger, capable of executing the most common Assembly commands.<br>
This includes 3 Logical Operations, And Or and Xor, 3 arithmetic ones Add, Subtract, Multiply, Branch if Equal and If Not equal for both between register and register as well as register content & immediate. <br>
With exception of this it can also handle the shifting of register content left or right as well as Jump/Jump-and-Link, Load and Store between Memory and a Single dummy register.<br>

## Notes
* Most instructions have "two versions". For example, ADDR sums the contents of two registers and saves that to a third one. ADDI sums the content of a register and an immediate and saves that to the same address.
* While most ISAs deal in few standard source registers and access the memory with Load and Store operations, I wanted my architecture to be easier to view/simulate (since it's my first one) thus it has only 1 dummy register and everything else is done directly in the test memory.
* In order to simulate the functionality of Load and Store commands i added a dummy register.
* The Address Register is added to enable the Jump-and-Link type of commands.
* I have made extensive use of "$display" command to monitor the testbench and preview how things might look if such instructions were interpreted in usable Assembly given a concrete interpreting unit. Sometimes in bits sometimes in words it's made on-purpose like that to better visualize both machine/binary language and possible Assembly syntax.

## Simulation Guide (in ModelSim)
1. When simulating the project, choose to simulate "asi_tb.v"
2. Drag-and-drop all the "objects" into the Wave simulator
3. Go to the memory tab, grab the only file that's there and put it to the Wave tab too
4. Go to "Simulate" -> "Run" -> "Run -All"
5. The testbench will print in detail everything in the "Transcript window" in machine code and pseudo-assembly. It's verifiable that the instructions function correctly. 

## Simulation Guide Screenshoots
![Step1](https://user-images.githubusercontent.com/123891760/223788167-e85cce60-a5f5-4ad9-bb20-e8224bd6f172.jpg)
![Step2](https://user-images.githubusercontent.com/123891760/223788178-0f263d3c-c113-49b5-8ac3-be3075cd1754.jpg)
![Step3](https://user-images.githubusercontent.com/123891760/223788190-a780dc79-8861-4c4b-9c01-f76bff9af7ef.jpg)
![Step4](https://user-images.githubusercontent.com/123891760/223788197-85bb651f-838e-46b2-8439-ee220a9c017a.jpg)
![Step5](https://user-images.githubusercontent.com/123891760/223792268-e4955a1a-8f12-4c4c-91a7-13e71b3cee4e.jpg)
