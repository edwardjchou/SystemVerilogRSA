module multiplier_sm (input clk, reset_n, mult_ready,
							input [31:0] in1,in2,
							output logic mult_done,
						 output logic [31:0] out);
		

		logic [31:0] counter;
		logic [31:0] temp_sum;
		
		enum logic [2:0] {	RESET, WAIT, MULTIPLY_LOOP_0, MULTIPLY_LOOP_1, MULTIPLY_DONE
							}
							state, next_state;
	
		always_ff @ (posedge clk, negedge reset_n) begin
			if (reset_n == 1'b0) begin
				state <= RESET;
				counter <= 32'd0;
			end 
			else begin
				state = next_state;
				if (state == MULTIPLY_LOOP_0)
					counter <= counter + 1'b1;
			end
		end
		
		always_comb begin
			next_state = state;
			unique case (state)
				RESET: begin
					next_state = WAIT;
				end
				
				WAIT: begin
					if (mult_ready == 1'b1)
						next_state = MULTIPLY_LOOP_0;
				end
				
				MULTIPLY_LOOP_0: begin
					if(counter == (in2 + 1'b1))
						next_state = MULTIPLY_DONE;
					else if(counter < (in2 + 1'b1))
						next_state = MULTIPLY_LOOP_1;
				end
				
				MULTIPLY_LOOP_1: begin
						next_state = MULTIPLY_LOOP_0;
				end
				
				MULTIPLY_DONE: begin
					if(mult_ready == 1'b0)
						next_state = WAIT;
				end
				default: ;
			endcase
		end
		
		
		always_ff @(posedge clk) begin
			unique case (state)
				RESET: begin
					out <= 32'd0;
					temp_sum <= 32'd0;
					mult_done <= 1'b0;
				end
				
				WAIT: begin
				end
				
				MULTIPLY_LOOP_0: begin
					temp_sum = out + in1;
				end
				
				MULTIPLY_LOOP_1: begin
					out = temp_sum;
				end
				
				MULTIPLY_DONE: begin
					mult_done = 1'b1;
				end
				default: ;
			endcase
		end
		
	//assign out = in1 * in2;

endmodule	