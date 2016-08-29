module modular_multiplication(input clk, reset_n, modmult_ready,
										input [31:0] base, power, denominator,
										output logic modmult_done,
										output logic [31:0] result);
	
	logic [31:0] product, modulo_result;
	logic modular_ready, modular_done; 
	logic mult_ready, mult_done;
	
	
	logic [31:0] d, e, phi;
	// so base starts at 1, M is base, e is power, n is denom
	//.base(Cin), .e(e), .power(M), .denominator(n),
	/*
	d = 1;
    s = (d * e) % phi;
    while(s != 1){
        s = (d * e) % phi;
        d++;
    }
    d--;
	 */
	//
	modular modular0(.clk(clk), .reset_n(reset_n), .modular_ready(modular_ready), .numerator(product), .denominator(phi), .modular_done(modular_done), .result(modulo_result));
	multiplier_sm mult0(.clk(clk), .reset_n(reset_n), .mult_ready(mult_ready), .in1(d), .in2(e), .mult_done(mult_done), .out(product));
	//				output logic [31:0] result);					
	//assign result = power * base;
	//assign result = ((power * base) % denominator);	
		enum logic [2:0] {	RESET, WAIT, MULTIPLY, MULTIPLY_DONE, MODULO, MODULO_DONE, MODMULT_DONE
							}
							state, next_state;

		always_ff @ (posedge clk, negedge reset_n) begin
			if (reset_n == 1'b0) begin
				state = RESET;
			end 
			else begin
				state = next_state;
			end
		end
	
	always_comb begin
		next_state = state;
			unique case (state)
				RESET: begin
					next_state = WAIT;
				end
				
				WAIT: begin
					if (modmult_ready == 1'b1)
						next_state = MULTIPLY;
				end
				
				
				MULTIPLY: begin
					if(mult_done == 1'b1)
						next_state = MULTIPLY_DONE;
				end
				
				MULTIPLY_DONE: begin
					next_state = MODULO;
				end
				
				MODULO: begin
					if(modular_done == 1'b1)
						next_state = MODULO_DONE;
				end
				
				MODULO_DONE: begin
					next_state = MODMULT_DONE;
				end
				
				MODMULT_DONE: begin
					if(modmult_ready == 1'b0)
						next_state = WAIT;
				end
				default: ;
			endcase
		end
		
		always_ff @(posedge clk) begin
			unique case (state)
				RESET: begin
					result <= 32'd0;
					mult_ready <= 1'b0;
					modular_ready <= 1'b0;
					modmult_done <= 1'b0;
					d <= 32'd0;
					e <= 32'd0;
					phi <= 32'd0;
				end
				
				WAIT: begin
					d <= base;
					e <= power;
					phi <= denominator;
				end
				
				MULTIPLY: begin
					mult_ready <= 1'b1;
				end
				
				MULTIPLY_DONE: begin
					mult_ready = 1'b0;
				end
				
				MODULO: begin
					modular_ready = 1'b1;
				end
				
				MODULO_DONE: begin
					modular_ready = 1'b0;
					result = modulo_result;
				end
				
				MODMULT_DONE: begin
					modmult_done = 1'b1;
				end
				default: ;
			endcase
		end
	/*
	always_comb
	begin
		modexp_done = 1'b0;
		if(modular_done == 1'b1)
			modexp_done = 1'b1;
	end
*/
endmodule 