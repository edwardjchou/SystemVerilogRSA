module testbench_gend();

timeunit 10ns;

timeprecision 1ns;

logic clk = 0;
logic reset_n = 0;
logic compute = 0;
logic [31:0] e, phi;
logic [31:0] d;
logic generated_done;

generate_d generate_d0(.clk(clk), 
				.reset_n(reset_n), 
				.compute(compute),
				.e(e), 
				.phi(phi),
				.d(d),
				.generated_done(generated_done));

								
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

/*
p1 - 103
p2 - 79
phi - 7956
n - 8137
e - 173
d - 4001 
*/

/*
p1 - 7
p2 - 13
phi - 72
n - 91
e - 7
d - 31
*/

/*
p1 - 11
p2 - 29
phi - 264
n - 299
e - 239
d - 95
*/
#10 e = 32'd71;
#10 phi = 32'd288;
#10 compute = 1'b1;


end					
					
					
				
endmodule