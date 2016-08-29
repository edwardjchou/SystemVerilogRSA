module rsa_decrypt(input clk, reset_n, compute,
						input [31:0] C, d, n,
						output logic [31:0] M,
						output logic decrypt_done);
						
						
	
	enum logic [2:0] {	RESET, WAIT, MOD_EXP_LOOP, MODULAR, FINISHED
							}
							state, next_state;
						
	logic [31:0] counter;
	
	logic [31:0] Mout, Min, M_mod_in, Mfinal;
	
	modular_exponentiation me0(.base(Min), .power(C), .denominator(n), .result(Mout));
	modular m0(.numerator(M_mod_in), .denominator(n), .result(Mfinal));
 	
	always_ff @ (posedge clk, negedge reset_n) begin
		if (reset_n == 1'b0) begin
			state <= RESET;
			counter <= 32'd0;
		end 
		else begin
			state <= next_state;
			if (state == MOD_EXP_LOOP)
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
				if (compute == 1'b1)
					next_state = MOD_EXP_LOOP;
			end
			
			MOD_EXP_LOOP: begin
				if(counter == d)
					next_state = MODULAR;
				else if(counter < d)
					next_state = MOD_EXP_LOOP;
			end
			
			MODULAR: begin
				next_state = FINISHED;
			end
			
			FINISHED: begin
				if(compute == 1'b0)
					next_state = WAIT;
				else
					next_state = FINISHED;
			end
		endcase
	end
			
	always_ff @(posedge clk) begin
		unique case (state)
			RESET: begin
				Min = 32'd1;
				//Mout <= 16'd1;
				M_mod_in = 32'd1;
				//Mfinal <= 16'd1;
			end
			
			WAIT: begin
			end
			
			MOD_EXP_LOOP: begin
				Min = Mout;
			end
			
			MODULAR: begin
				M_mod_in = Min; // originally was mout
			end
			
			FINISHED: begin
				M = Mfinal;
				decrypt_done = 1'b1;
			end
		endcase
	end

endmodule
