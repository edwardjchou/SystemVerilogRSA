module modular(input clk, reset_n, modular_ready,
					input [31:0] numerator, denominator,
					output logic modular_done,
					output logic [31:0] result);
					
		enum logic [2:0] {	RESET, WAIT, MOD_INIT, MOD_ASSIGN, MOD_DONE
						}
						state, next_state;
					
		//assign result = numerator % denominator;
		
		logic [31:0] sub_hold, numerator_hold, denominator_hold;

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
					if (modular_ready == 1'b1)
						next_state = MOD_INIT;
				end
				
				MOD_INIT: begin
					if(numerator_hold < denominator_hold)
						next_state = MOD_DONE;
					else
						next_state = MOD_ASSIGN;
				end
				
				MOD_ASSIGN: begin
						next_state = MOD_INIT;
				end
				
				MOD_DONE: begin
					if(modular_ready == 1'b0)
						next_state = WAIT;
				end
				default: ;
			endcase
		end
		
		always_ff @(posedge clk) begin
			unique case (state)
				RESET: begin
					result <= 32'd0;
					sub_hold <= 32'd0;
					numerator_hold <= 32'd0;
					denominator_hold <= 32'd0;
					modular_done <= 1'b0;
				end
				
				WAIT: begin
					numerator_hold <= numerator;
					denominator_hold <= denominator;
				end
				
				MOD_INIT: begin
					sub_hold = numerator_hold - denominator_hold;
				end
				
				MOD_ASSIGN: begin
					numerator_hold = sub_hold;
				end
				
				MOD_DONE: begin
					result = numerator_hold;
					modular_done = 1'b1;
				end
				default: ;
			endcase
		end
		
		/*
		always_comb
		begin
			result = numerator % denominator;
			modular_done = 1'b0;
			if(result < denominator)
				modular_done = 1'b1;		
		end
	*/
endmodule 