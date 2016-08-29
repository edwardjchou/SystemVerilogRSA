module modular_exponentiation_nosm(input [31:0] base, power, denominator,
										output logic modexp_done,
										output logic [31:0] result);

	logic [31:0] product;
	logic [31:0] modular_done;
	multiplier mult0(.in1(power), .in2(base), .out(product));
	modular_nosm modular0(.numerator(product), .denominator(denominator), .modular_done(modular_done), .result(result));
	always_comb
	begin
		modexp_done = 1'b0;
		if(modular_done == 1'b1)
			modexp_done = 1'b1;
	end

endmodule 