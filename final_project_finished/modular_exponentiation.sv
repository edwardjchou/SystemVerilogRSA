module modular_exponentiation(input clk, reset_n, modexp_ready,
										input [31:0] base, power, e, denominator,
										output logic modexp_done,
										output logic [31:0] result);
	
	logic [31:0] counter;
	logic [31:0] product, modulo_result;
	logic modular_ready, modular_done; 
	logic mult_ready, mult_done;
	
	logic multiplier_reset;
	logic modulo_reset;
	
	logic [31:0] C, M, n;
	// so base starts at 1, M is base, e is power, n is denom
	//.base(Cin), .e(e), .power(M), .denominator(n),
	/*
	for(i = 0; i < e; i++){
        C = (C*M)%n;
    }
	*/
	//
	modular modular0(.clk(clk), .reset_n(modulo_reset), .modular_ready(modular_ready), .numerator(product), .denominator(n), .modular_done(modular_done), .result(modulo_result));
	multiplier_sm mult0(.clk(clk), .reset_n(multiplier_reset), .mult_ready(mult_ready), .in1(C), .in2(M), .mult_done(mult_done), .out(product));
	//				output logic [31:0] result);					
	//assign result = power * base;
	//assign result = ((power * base) % denominator);	
		enum logic [2:0] {	RESET, WAIT, INIT_RESET_0, INIT_RESET_1, MULTIPLY, MODULO, CHECK_COUNTER, MODEXP_DONE
							}
							state, next_state;

		always_ff @ (posedge clk, negedge reset_n) begin
			if (reset_n == 1'b0) begin
				state = RESET;
				counter = 32'd0;
			end 
			else begin
				state = next_state;
				if(state == CHECK_COUNTER)
					counter = counter + 1'b1;
			end
		end
	
	always_comb begin
		next_state = state;
			unique case (state)
				RESET: begin
					next_state = WAIT;
				end
				
				WAIT: begin
					if (modexp_ready == 1'b1)
						next_state = INIT_RESET_0;
				end
				
				INIT_RESET_0:
				begin
					next_state = INIT_RESET_1;
				end
				
				INIT_RESET_1:
				begin
					next_state = MULTIPLY;
				end
				
				MULTIPLY: begin
					if(mult_done == 1'b1)
						next_state = MODULO;
				end
				
				MODULO: begin
					if(modular_done == 1'b1)
						next_state = CHECK_COUNTER;
				end
				
				CHECK_COUNTER:
				begin
					if(counter < e)
						next_state = INIT_RESET_0;
					else if(counter >= e)
						next_state = MODEXP_DONE;
				end
				
				MODEXP_DONE: begin
					if(modexp_ready == 1'b0)
						next_state = WAIT;
				end
				default: ;
			endcase
		end
		always_ff @(posedge clk) begin
			unique case (state)
				RESET: begin
					multiplier_reset <= 1'b0; //all resets are swapped!  active low! //has to be on top for some reason?
					modulo_reset <= 1'b0;
					result <= 32'd0;
					mult_ready <= 1'b0;
					modexp_done <= 1'b0;
					modular_ready <= 1'b0;
					C <= 32'd0;
					M <= 32'd0;
					n <= 32'd0;
				end
				
				WAIT: begin
					C <= base;
					M <= power;
					n <= denominator;
					multiplier_reset <= 1'b1; //turn off reset
					modulo_reset <= 1'b1;
				end
				
				INIT_RESET_0: begin
					multiplier_reset <= 1'b0; //reset
					modulo_reset <= 1'b0; //reset
				end
				
				INIT_RESET_1: begin
					multiplier_reset <= 1'b1;
					modulo_reset <= 1'b1; //ok
				end
				
				MULTIPLY: begin
					mult_ready <= 1'b1;
				end
				
				MODULO: begin
					mult_ready = 1'b0;
					modular_ready = 1'b1;
				end
				
				CHECK_COUNTER: begin
					modular_ready = 1'b0;
					C = modulo_result;
				end
				
				MODEXP_DONE: begin
					result = C;
					modexp_done = 1'b1;
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