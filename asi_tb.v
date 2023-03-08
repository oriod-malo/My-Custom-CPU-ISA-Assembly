// half_adder_tb.v

`timescale 1 ps/1 ps  // time-unit = 1 ns, precision = 10 ps

module asi_tb;
	reg we; //write_enable,
	reg ck; //clock,
	reg rs; //reset,
	reg [31:0] i;   //instruction
	wire [31:0] dt1;
	wire [31:0] dt2;
	wire [31:0] drd;
	wire [31:0] pc;
	wire [31:0] ra;
	wire [31:0] dummyR;
	
	//wire [31:0] emptyVal = 'b00000000000000000000000000000000;
    localparam period = 100;  
	
    asi UUT (.write_enable(we), .clock(ck), .reset(rs), .instruction(i), .data1(dt1), .data2(dt2), .dataRD(drd), .pc(pc), .ra(ra), .dummyReg(dummyR));
	
	initial
	begin
		ck = 0; 
		we = 0;
		rs = 0;
	//	p_c = 'b00000000_00000000_00000000_00000000;
	//	r_a = 'b00000000_00000000_00000000_00000000;
	//	dummyR = 'b00000000_00000000_00000000_00000000;
	end
	

	always 
	begin
		ck = 1'b1; 
		#10;
		ck = 1'b0;
		#10;
	end

	initial
	begin
		// values for a and b
		// ANDR
		#100	i = 'b00000101000000110000001000000001;
		#100	we = 1;
		$display("%b\t%b,\t%b, COMMAND:\t ANDR Rs3,Rs2,Rs1",dt1,dt2,drd); 
		// ORR
		#100	we = 0; i = 'b00000110000001100000010100000100;
		#100	we = 1;
		$display("%b\t%b,\t%b, COMMAND:\t ORR Rs6,Rs5,RS4",dt1,dt2,drd); 
		// XORR
		#100	we = 0; i = 'b00000111000010010000100000000111;
		#100	we = 1;
		$display("%b\t%b,\t%b, COMMAND:\t XORR Rs9,Rs8,Rs7",dt1,dt2,drd); 
		// ADDR
		#100	we = 0; i = 'b00001000000011000000101100001010;
		#100	we = 1;
		$display("%d\t%d,\t%d, COMMAND:\t ADDR Rs12,Rs11,Rs10",dt1,dt2,drd); 
		// SUBR
		#100	we = 0; i = 'b00001001000011110000111000001101;
		#100	we = 1;
		$display("%d\t%d,\t%d, COMMAND:\t SUBR Rs15,Rs14,Rs13",dt1,dt2,drd); 
		// MPLR
		#100	we = 0; i = 'b00001010000100100001000100010000;
		#100	we = 1;
		$display("%d\t%d,\t%d, COMMAND:\t MPLR RS18,RS17,RS16",dt1,dt2,drd); 
		// ANDI
		#100	we = 0;   i = 'b01000101_00010011_1100110011001100; 
		#100	we = 1;
		$display("%b\t%b,\t%b, COMMAND:\t ANDI RS19, Immediate",i[15:0],dt2,drd); 
		// ORI
		#100	we = 0;   i = 'b01000110_00010100_1100110011001100; 
		#100	we = 1;
		$display("%b\t%b,\t%b, COMMAND:\t ORI RS20, Immediate",i[15:0],dt2,drd); 
		// XORI
		#100	we = 0;   i = 'b01000111_00010101_1100110011001100; 
		#100	we = 1;
		$display("%b\t%b,\t%b, COMMAND:\t XORI RS21, Immediate",i[15:0],dt2,drd); 
		// ADDI
		#100	we = 0;    i = 'b01001010_00010110_0000000001100100; 
		#100	we = 1;
		$display("%b\t%d,\t%d, COMMAND:\t ADDI RS22, Immediate | Should be (300+100=400)",i[15:0],dt2,drd); 
		// SUBI
		#100	we = 0;    i = 'b01001011_00010111_0000000001100100; 
		#100	we = 1;
		$display("%b\t%d,\t%d, COMMAND:\t SUBI RS23, Immediate | Should be (300-100=200)",i[15:0],dt2,drd); 
		// MPLI
		#100	we = 0;    i = 'b01001100_00011000_0000000001100100;
		#100	we = 1;
		$display("%b\t%d,\t%d, COMMAND:\t MPLI RS24, Immediate | Should be (300*100=30000)",i[15:0],dt2,drd); 
		// SLLI
		#100	we = 0;     i = 'b01001000000110100001100100001010;
		#100	we = 1;
		$display("%b\t%b,\t%b, COMMAND:\t SLLI Rs26, Rs25, K | Rd <= Rd << K",dt1,dt2,drd); 
		// SRLI
		#100	we = 0;     i = 'b01001001000111000001101100001010;
		#100	we = 1;
		$display("%b\t%b,\t%b, COMMAND:\t SRLI Rs28, Rs27, K | Rd <= Rd >> K",dt1,dt2,drd); 
		
		//----------------------------------- BEQR 1 Taken
		#100	we = 0;     i = 'b01000001_00011101_00011110_00001010;
		#100	we = 1;
		if(dt1==dt2)begin
			$display($time,"\t BEQR 1 (registers 29 and 30) Branch Taken because two data are equal"); 
		end else begin
			$display($time,"\t BEQR 1 (registers 29 and 30) Branch NOT Taken because two data are NOT equal"); 
		end
		
		//----------------------------------- BEQR 2 Not Taken
		#100	we = 0;     i = 'b01000001_00011111_00100000_00001010;
		#100	we = 1;
		if(dt1==dt2)begin
			$display($time,"\t BEQR 2 (registers 31 and 32) Branch Taken because two data are equal");
		end else begin
			$display($time,"\t BEQR 2 (registers 31 and 32) Branch NOT Taken because two data are NOT equal"); 
		end
		#100	we = 0; 

		//----------------------------------- BNER 1 NOT Taken
		#100	we = 0;     i = 'b01000010_00011101_00011110_00001000;
		#100	we = 1;
		if(dt1==dt2)begin
			$display($time,"\t BNER 1 (registers 29 and 30) Branch NOT Taken because two data are equal"); 
		end else begin
			$display($time,"\t BNER 1 (registers 29 and 30) Branch Taken because two data are NOT equal"); 
		end
		
		//----------------------------------- BNER 2 Taken
		#100	we = 0;     i = 'b01000010_00011111_00100000_00001000;
		#100	we = 1;
		if(dt1==dt2)begin
			$display($time,"\t BNER 2 (registers 31 and 32) Branch NOT Taken because two data are equal");
		end else begin
			$display($time,"\t BNER 2 (registers 31 and 32) Branch Taken because two data are NOT equal"); 
		end

		//----------------------------------- BEQI 1 Taken
		#100	we = 0;     i = 'b01000011_00100101_1111111111111111;
		#100	we = 1;

		//----------------------------------- BEQI 2 Not Taken
		#100	we = 0;     i = 'b01000011_00100110_1111111111111111;
		#100	we = 1;


		//----------------------------------- BNEI 1 NOT Taken
		#100	we = 0;     i = 'b01000100_00100110_1010101010101010;
		#100	we = 1;

		
		//----------------------------------- BNEI 2 Taken
		#100	we = 0;     i = 'b01000100_00100101_1010101010101010;
		#100	we = 1;

		//----------------------------------- Jump
		#100	we = 0;     i = 'b00000001_000011110000111100001111;
		#100	we = 1;

		//----------------------------------- Jump-and-Link
		#100	we = 0;     i = 'b00000010_111100001111000011110000;
		#100	we = 1;
		//----------------------------------- LOADI
		#100	we = 0;     i = 'b10000001_000011110000111100001111 ;
		#100	we = 1;
		
		//----------------------------------- LOADR
		#100	we = 0;     i = 'b10000010_00001100_0000000000000000;
		#100	we = 1;
		//----------------------------------- STORE
		#100	we = 0;     i = 'b10000011_01100100_0000000000000000;
		#100	we = 1;


		// Extra 300ps for readability in Modelsim Waveform (long bit vectors can't be read easily)
		#300	we = 0; 

		
		$stop;   // end of simulation
	end
	
//	initial 
//	begin
//		$display("\t\ttime,\tclk,\treset,\tenable,\tcount"); 
//		$monitor("%d,\t%d,\t%d,\t%d,\t%d",$time, ck,dt1,dt2,drd); 
//	end 
 
	initial 
	#5900  $stop;  //300ps for each instruction 

endmodule
