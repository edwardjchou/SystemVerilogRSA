module testbench_decrypt();

timeunit 10ns;

timeprecision 1ns;

logic clk = 0;
logic reset_n = 0;
logic compute = 0;
logic [31:0] C, d, n;
logic [31:0] M;

logic [10:0]i;

rsa_decrypt rsa_decrypt0(.clk(clk), 
								.reset_n(reset_n),
								.compute(compute),
								.C(C), 
								.d(d), 
								.n(n),
								.M(M));
								
always begin : CLOCK_GENERATION
#1 clk = ~clk;

end

initial begin: CLOCK_INITIALIZATION
	clk = 0;
end


initial begin: TEST_VECTORS
#10 reset_n = 1'b0;
#10 reset_n = 1'b1;

#10 C = 32'd12524;
#10 d = 32'd6851;
#10 n = 32'd23213; //139 * 167
#10 compute = 1'b1;


end					
					
					
				
endmodule