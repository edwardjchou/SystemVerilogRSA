module testbench_rsa();

timeunit 10ns;

timeprecision 1ns;

logic clk = 0;
logic reset_n = 0;
logic compute = 0;
logic [31:0] M, e, n;
logic [31:0] C;
logic [31:0] encrypt_done;

logic [10:0]i;

/*
assign n_in[31:0] = n[31:0]; //32'd323;
				assign e_in[31:0] = e[31:0]; //32'd71;
				assign plaintext_in[31:0] = plaintext[31:0]; //32'd67;
*/

/*
P1 = 173
P2 = 97
e = 37
ptx = 65
n = 16781
phi = 16512
ctx = 16030
*/
rsa_encrypt rsa_encrypt0(.clk(clk), 
								.reset_n(reset_n),
								.compute(compute),
								.M(M), 
								.e(e), 
								.n(n),
								.C(C),
								.encrypt_done(encrypt_done));
								
always begin : CLOCK_GENERATION
#1 clk = ~clk;

end

initial begin: CLOCK_INITIALIZATION
	clk = 0;
end


initial begin: TEST_VECTORS
#10 reset_n = 1'b0;
#10 reset_n = 1'b1;
/*
#10 i = 11'b00000101111;
#10 i = 11'b00001100101;
#10 i = 11'b00110011001;
#10 i = 11'b00110011000;
#10 i = 11'd23;
#10 i = 11'd26;
*/
#10 M = 32'd65;
#10 e = 32'd37;
#10 n = 32'd16781;
#10 compute = 1'b1;


end					
					
					
				
endmodule


