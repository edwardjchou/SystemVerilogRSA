module phi_gen (input clk, reset_n, phi_ready, 
					 input [31:0] in1, in2,
						 output logic [31:0] out,
						 output logic phi_done);
	
	enum logic [2:0] {	RESET, WAIT, COMPUTE, FINISHED
							} state, next_state;	
							
	logic mult_ready, mult_done;
	logic [31:0] phi_in1, phi_in2, mult_out;
							
	multiplier_sm phi_multiplier(.clk(clk), .reset_n(reset_n), .mult_ready(mult_ready), .in1(phi_in1), .in2(phi_in2), .out(mult_out), .mult_done(mult_done));
		
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
				if (phi_ready == 1'b1)
					next_state = COMPUTE;
			end
			
			COMPUTE: begin
				if(mult_done == 1'b1)
					next_state = FINISHED;
				else if(mult_done == 1'b0)
					next_state = COMPUTE;
			end
					
			FINISHED: begin
				if(phi_ready == 1'b0)
					next_state = WAIT;
				else
					next_state = FINISHED;
			end
		endcase
	end
			
	always_ff @(posedge clk) begin
		unique case (state)
			RESET: begin
				mult_ready = 1'b0;
				phi_in1 = 32'd0;
				phi_in2 = 32'd0;
				phi_done = 1'b0;
				out = 32'd0;
			end
			
			WAIT: begin
			end
			
			COMPUTE: begin
				phi_in1 = in1 - 1'b1;
				phi_in2 = in2 - 1'b1;
				mult_ready = 1'b1;
				//out = (in1 - 1'b1) * (in2 - 1'b1);
			end
			
			FINISHED: begin
				out = mult_out;
				phi_done = 1'b1;
			end
		endcase
	end

		
		

endmodule	