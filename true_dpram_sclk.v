module true_dpram_sclk
(
	input [31:0] data_in,
	input [7:0] addr_a, addr_b, addr_d,
	input we, clk,
	output reg [31:0] q_a, q_b
);
	// Declare the RAM variable
	reg [31:0] ram[255:0]; // reg [dw-1:0] ram [2**addrw-1:0]; dw=32, addrw=8, 2**addrw=256
    initial begin
        $display("Loading RAM.");
        $readmemh("test_ram_before.txt", ram);
        $writememh("test_ram_after.txt", ram);
    end

	// Port A
	always @ (posedge clk)
	begin
		if (we) 
		begin
			ram[addr_d] <= data_in;
		end
		else 
		begin
			q_a <= ram[addr_a];
			q_b <= ram[addr_b];
		end
	end
	
	// Port B
//	always @ (posedge clk)
//	begin
//		if (we_b)
//		begin
//			ram[addr_b] <= data_b;
//			q_b <= data_b;
//		end
//		else
//		begin
//			q_b <= ram[addr_b];
//		end
//	end
	
endmodule
