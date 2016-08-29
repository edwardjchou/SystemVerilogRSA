module testbench_modmult();

timeunit 10ns;

timeprecision 1ns;

logic clk = 0;
logic reset_n = 0;
logic modmult_ready = 0;
logic [31:0] base, power, denominator, result;
logic modmult_done;

modular_multiplication modmult0(.*);
								
always begin : CLOCK_GENERATION
#1 clk = ~clk;

end

initial begin: CLOCK_INITIALIZATION
	clk = 0;
end

//524 * 326 
//170824 mod 31 = 14
initial begin: TEST_VECTORS
#10 reset_n = 1'b0;
#10 reset_n = 1'b1;

#10 base = 32'd524;
#10 power = 32'd326;
#10 denominator = 32'd31;
#10 modmult_ready = 1'b1;


end					
					
					
				
endmodule