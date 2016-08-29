module testbench_modexp();

timeunit 10ns;

timeprecision 1ns;

logic clk = 0;
logic reset_n = 0;
logic modexp_ready = 0;
logic [31:0] base, e, power, denominator, result;
logic modexp_done;

modular_exponentiation modexp0(.*);
								
always begin : CLOCK_GENERATION
#1 clk = ~clk;

end

initial begin: CLOCK_INITIALIZATION
	clk = 0;
end
//22^5 = 5153632
//5153632 mod 273 = 211

//31^6
//887503681 mod 273 = 64

//.base(Cin), .e(e), .power(M), .denominator(n),
	/*
	for(i = 0; i < e; i++){
        C = (C*M)%n;
    }
	*/
//11^13 mod 53 ≡ 52
initial begin: TEST_VECTORS
#10 reset_n = 1'b0;
#10 reset_n = 1'b1;

#10 base = 32'd1;
#10 e = 32'd13;
#10 power = 32'd11;
#10 denominator = 32'd53;
#10 modexp_ready = 1'b1;


end					
					
					
				
endmodule