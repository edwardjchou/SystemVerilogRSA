module rsa_encrypt(input clk, reset_n, compute,
						input [31:0] M, e, n,
						output logic [31:0] C,
						output logic encrypt_done);
						
						
	
	enum logic [2:0] {	RESET, WAIT, MOD_EXP_LOOP, MODULAR, FINISHED
							}
							state, next_state;
						
	//logic [31:0] counter;
	
	logic [31:0] Cout, Cin, Cfinal;
	
	//logic [31:0] Cout_temp;
	
	logic modular_ready, modular_done, modexp_done, modexp_ready;
	
	modular_exponentiation me0(.clk(clk), .reset_n(reset_n), .modexp_ready(modexp_ready), .base(Cin), .e(e), .power(M), .denominator(n), .modexp_done(modexp_done), .result(Cout));
	
	modular mod0(.clk(clk), .reset_n(reset_n), .modular_ready(modular_ready), .numerator(Cout), .denominator(n), .modular_done(modular_done), .result(Cfinal));
 	
	always_ff @ (posedge clk, negedge reset_n) begin
		if (reset_n == 1'b0) begin
			state <= RESET;
		end 
		else 
		begin
				state <= next_state;
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
				if(modexp_done == 1'b1)
					next_state = MODULAR;
			end
			
			MODULAR: begin
				if(modular_done == 1'b1)
					next_state = FINISHED;
			end
			
			FINISHED: begin
				if(compute == 1'b0)
					next_state = WAIT;
				else
					next_state = FINISHED;
			end
			default: ;
		endcase
	end
			
	always_ff @(posedge clk) begin
	
		unique case (state)
			RESET: begin
				Cin <= 32'd1;
				//Cout <= 16'd1;
				//C_mod_in = 32'd1;
				//Cfinal <= 16'd1;
				//Cout_temp = 32'd0;
				C <= 32'd0;
				modexp_ready <= 1'b0;
				modular_ready <= 1'b0;
				encrypt_done <= 1'b0; //missing this line...
			end
			
			WAIT: begin
			end
			
			MOD_EXP_LOOP: begin
				modexp_ready = 1'b1;
			end
			
			MODULAR: begin
				modexp_ready = 1'b0;
				modular_ready = 1'b1;
				//if(modular_done == 1'b1)
				//	C_mod_in = C; //32'd691857447; //what Cin was// Cin;//Cin; //originally was Cout_temp // 32'd6023; this works
			end
			
			FINISHED: begin
				modular_ready = 1'b0;
				C = Cfinal;
				encrypt_done = 1'b1;
			end
			default: ;
		endcase
	end

endmodule
