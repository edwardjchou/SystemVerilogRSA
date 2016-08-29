module modular_nosm(input [31:0] numerator, denominator,
					output logic modular_done,
					output logic [31:0] result);
					
		
		always_comb
		begin
			result = numerator % denominator;
			modular_done = 1'b0;
			if(result < denominator)
				modular_done = 1'b1;		
		end
		
endmodule 