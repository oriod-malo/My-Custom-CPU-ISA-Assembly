`timescale 1 ps/1 ps  // time-unit = 1 ns, precision = 10 ps

module core(
	input clk,
	input rst,
	input [31:0] instr,
	input [31:0] data_rs1,
	input [31:0] data_rs2,
	
	output reg [7:0] addr_rs1,
	output reg [7:0] addr_rs2,
	output reg [7:0] addr_rd,
	output reg [31:0] data_rd,
	output reg [31:0] programCounter,
	output reg [31:0] addressReg,
	output reg [31:0] dummyReg

);

//defparam width_instruction = 32;
//defparam width_opcode = 8;
//defparam width_data = 32;
//defparam width_address = 8;
//defparam pc_address = 'b00000000;
//defparam ra_address = 'b11111111;
//defparam base_address = 'b00000001;
//defparam ANDR = 'b00000101;
//defparam ORR = 'b00000110;
//defparam XORR = 'b00000111;
//defparam ADDR = 'b00001000;
//defparam SUBR = 'b00001001;
//defparam MPLR = 'b00001010;
//defparam DIVR = 'b00001011;

//defparam JP = 'b00000001;
//defparam JAL = 'b00000011;

// defparam LOADI = 'b10000001;
// defparam LOADR = 'b10000010;
// defparam STORE = 'b10000011;

// ----------------------- Type I Instructions -------------------------//

// BEQR	= 8'b0100_0001,
// BNER	= 8'b0100_0010,
// BEQI	= 8'b0100_0011,
// BNEI	= 8'b0100_0100,

// SLLI = 8'b0100_1000,
// SRLI = 8'b0100_1001,

// ANDI	= 8'b0100_0101,
// ORI	= 8'b0100_0110,
// XORI = 8'b0100_0111,

// ADDI = 8'b0100_1010,
// SUBI = 8'b0100_1011,
// MPLI = 8'b0100_1100,
// DIVI = 8'b0100_1101

wire [7:0] opcode;
reg [31:0] tempData;
reg [31:0] tempPC = 'b0000000000000000_0000000000000000;
reg [31:0] tempRA = 'b0000000000000000_0000000000000000;
reg [31:0] tempDummy = 'b0000000000000000_0000000000000000;

integer intData;
always @ (rst, instr, data_rs1, tempPC, data_rs2) begin

//assign opcode = instr[31:24];

case(instr[31:24])
		'b0000_0101: begin // AND Register Content
			addr_rd <= instr[23:16];
			addr_rs1 <= instr[15:8];
			addr_rs2 <= instr[7:0];
		
			data_rd = data_rs1 & data_rs2;
		end
		'b0000_0110: begin // OR Register Content
			addr_rd <= instr[23:16];
			addr_rs1 <= instr[15:8];
			addr_rs2 <= instr[7:0];
		
			data_rd = data_rs1 | data_rs2;
		end
		'b0000_0111: begin // XOR Register Content
			addr_rd <= instr[23:16];
			addr_rs1 <= instr[15:8];
			addr_rs2 <= instr[7:0];
		
			data_rd = data_rs1 ^ data_rs2;
		end
		'b0000_1000: begin //Add Register content
			addr_rd <= instr[23:16];
			addr_rs1 <= instr[15:8];
			addr_rs2 <= instr[7:0];
		
			data_rd = data_rs1 + data_rs2;
		end
		'b0000_1001: begin // Subtract Register content
			addr_rd <= instr[23:16];
			addr_rs1 <= instr[15:8];
			addr_rs2 <= instr[7:0];
		
			data_rd = ~(data_rs1 - data_rs2)+'b0000_0000_0000_0001;
		end
		'b0000_1010: begin // Multiply Register content
			addr_rd <= instr[23:16];
			addr_rs1 <= instr[15:8];
			addr_rs2 <= instr[7:0];
		
			data_rd = data_rs1[15:0] * data_rs2[15:0];
		end
		'b0100_0101: begin // AND Immediate
			addr_rs1 = instr[23:16];
			tempData = data_rs1[31:0];
			addr_rd = instr[23:16];
			data_rd = tempData[31:0] & {16'b0000_0000_0000_0000,instr[15:0]};
		
		end
		'b0100_0110: begin // OR Immediate
			addr_rs1 = instr[23:16];
			tempData = data_rs1[31:0];
			addr_rd = instr[23:16];
			data_rd = tempData[31:0] | {16'b0000_0000_0000_0000,instr[15:0]};
		
		end
		'b0100_0111: begin // XOR Immediate
			addr_rs1 = instr[23:16];
			tempData = data_rs1[31:0];
			addr_rd = instr[23:16];
			data_rd = tempData[31:0] ^ {16'b0000_0000_0000_0000,instr[15:0]};
		
		end
		'b0100_1010: begin // ADD Immediate
			addr_rs1 = instr[23:16];
			tempData = data_rs1[31:0];
			addr_rd = instr[23:16];
			data_rd = tempData[31:0] + instr[15:0];
		
		end
		'b0100_1011: begin // Subtract Immediate
			addr_rs1 = instr[23:16];
			tempData = data_rs1[31:0];
			addr_rd = instr[23:16];
			data_rd = ~(tempData[31:0] - instr[15:0])+'b0000_0000_0000_0001;
			data_rd = ~data_rd + 'b0000_0000_0000_0000_0000_0000_0000_0001;
		end
		'b0100_1100: begin // MULTIPLY Immediate
			addr_rs1 = instr[23:16];
			tempData = data_rs1[31:0];
			addr_rd = instr[23:16];
			data_rd = tempData[15:0] * instr[15:0];
		end
		'b0100_1000: begin // SLLI Rd, RS1, K | Rd <= Rd << K
			addr_rd <= instr[23:16];
			addr_rs1 <= instr[15:8];
			intData <= instr[7:0];
			data_rd = data_rs1<<intData;
		end		
		'b0100_1001: begin // SLLI Rd, RS1, K | Rd <= Rd >> K
			addr_rd <= instr[23:16];
			addr_rs1 <= instr[15:8];
			intData <= instr[7:0];
			data_rd = data_rs1>>intData;
		end
		
		// JUMP INSTRUCTIONS (J FORMAT)
		'b00000001: begin // JP
			tempPC[31:0] = 'b00000000 +  instr[23:0];
			$display($time,"\t Jumping to address: %b", {8'b0000_0000,instr[23:0]});
		end
		
		'b00000010: begin // JAL
			tempRA = programCounter[31:0];
			$display($time,"\t Current addr: %b\t saved in the Address Register for Jump-and-Link", tempRA);
			tempPC[31:0] = 'b00000000 +  instr[23:0];
			$display($time,"\t Jumping to address: %b", {8'b0000_0000,instr[23:0]});
		end
		
		// Branch Instructions
		'b0100_0001: begin				// BEQR	= 8'b0100_0001,
			addr_rs1 = instr[23:16];
			addr_rs2 = instr[15:8];
			#100
			if(data_rs1 == data_rs2) begin
				tempPC[31:0] = 'b0000000000000000_0000000000000000 +  instr[7:0];
			end
			else begin
				tempPC[31:0] = programCounter[31:0];
			end
		end
		
		
		'b0100_0010: begin				// BNER	= 8'b0100_0010,
			addr_rs1 = instr[23:16];
			addr_rs2 = instr[15:8];
			#100
			if(data_rs1 != data_rs2) begin
				tempPC[31:0] = 'b0000000000000000_0000000000000000 +  instr[7:0];
			end
			else begin
				tempPC[31:0] = programCounter[31:0];
			end
		end
		
		'b0100_0011: begin				// BEQI,
			addr_rs1 = instr[23:16];
			#100
			if(data_rs1 == {16'b0000_0000_0000_0000,instr[15:0]}) begin
				tempPC[31:0] = 'b0000000000000000_0000000000000000 +  instr[15:0];
				$display($time,"\t BEQI %b\t, %b\t, Branch Taken",data_rs1,{16'b0000_0000_0000_0000,instr[15:0]}); 
			end
			else begin
				tempPC[31:0] = programCounter[31:0];
				$display($time,"\t BEQI %b\t, %b\t, Branch Not Taken",data_rs1,{16'b0000_0000_0000_0000,instr[15:0]}); 
			end
		end
		
		'b0100_0100: begin				// BNEI,
			addr_rs1 = instr[23:16];
			#100
			if(data_rs1 != {16'b0000_0000_0000_0000,instr[15:0]}) begin
				tempPC[31:0] = 'b0000000000000000_0000000000000000 +  instr[15:0];
				$display($time,"\t BNEI %b\t, %b\t, Branch Taken",data_rs1,{16'b0000_0000_0000_0000,instr[15:0]}); 
			end
			else begin
				tempPC[31:0] = programCounter[31:0];
				$display($time,"\t BNEI %b\t, %b\t, Branch NOT Taken",data_rs1,{16'b0000_0000_0000_0000,instr[15:0]}); 
			end
		end
		'b10000001: begin // LOADI opcode, immediate[23..0]
				tempDummy = {8'b0000_0000,instr[23:0]};
				$display($time,"\t Loading on dummy register the value %b",{8'b0000_0000,instr[23:0]});
		end
		'b10000010: begin // LOADR opcode, address[23:16]... offset[15..0](offset unused)
				addr_rs1 = instr[23:16];
				tempDummy = data_rs1;
				#100
				$display($time,"\t Loading on dummy register the value %d\t from memory address %d",data_rs1,addr_rs1);
		end
		'b10000011: begin // STORE opcode, address[23:16]... offset[15..0](offset unused)
				addr_rd = instr[23:16];
				data_rd = dummyReg;
				$display($time,"\t Storing on memory address %d the value %d that's in the dummy register",addr_rd,data_rd);
		end
		
//defparam JP = 'b00000001;
//defparam JALR = 'b00000011;
// BEQR	= 8'b0100_0001,
// BNER	= 8'b0100_0010,
// BEQI	= 8'b0100_0011,
// BNEI	= 8'b0100_0100,

	endcase
	addressReg <= tempRA;
	programCounter <= tempPC;
	dummyReg <= tempDummy;
end

endmodule