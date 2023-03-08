// Copyright (C) 2016  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Intel and sold by Intel or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 16.1.0 Build 196 10/24/2016 SJ Lite Edition"
// CREATED		"Sun Mar 05 13:12:39 2023"

module asi(
	write_enable,
	clock,
	reset,
	instruction,
	data1,
	data2,
	dataRD,
	pc,
	ra,
	dummyReg
);


input wire	write_enable;
input wire	clock;
input wire	reset;
input wire	[31:0] instruction;

output wire	[31:0] data1;
output wire	[31:0] data2;
output wire	[31:0] dataRD;
output wire	[31:0] pc;
output wire	[31:0] ra;
output wire	[31:0] dummyReg;

wire	[7:0] Rd;
wire	[7:0] RS1;
wire	[7:0] RS2;





core	b2v_inst1(
	.clk(clock),
	.rst(reset),
	.data_rs1(data2),
	.data_rs2(data1),
	.instr(instruction),
	.addr_rd(Rd),
	.addr_rs1(RS1),
	.addr_rs2(RS2),
	.data_rd(dataRD),
	.programCounter(pc),
	.addressReg(ra),
	.dummyReg(dummyReg)
	);


true_dpram_sclk	b2v_inst2(
	.we(write_enable),
	.clk(clock),
	.addr_a(RS1),
	.addr_b(RS2),
	.addr_d(Rd),
	.data_in(dataRD),
	.q_a(data2),
	.q_b(data1));


endmodule
