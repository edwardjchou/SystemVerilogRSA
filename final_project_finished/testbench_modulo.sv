module testbench_modulo();

timeunit 10ns;

timeprecision 1ns;

logic clk = 0;
logic reset_n = 0;
logic modular_ready = 0;
logic [31:0] numerator, denominator, result;
logic modular_done;

modular modular0(.clk(clk), .reset_n(reset_n), .modular_ready(modular_ready),
					.numerator(numerator), .denominator(denominator),
					.modular_done(modular_done),
					.result(result));
								
always begin : CLOCK_GENERATION
#1 clk = ~clk;

end

initial begin: CLOCK_INITIALIZATION
	clk = 0;
end
//556 mod 27 = 16
//234328 mod 273 = 94

initial begin: TEST_VECTORS
#10 reset_n = 1'b0;
#10 reset_n = 1'b1;

#10 numerator = 32'd234328;
#10 denominator = 32'd273;
#10 modular_ready = 1'b1;


end					
					
					
				
endmodule