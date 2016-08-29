module generate_d(input clk, reset_n, compute,
						input [31:0] e, phi,
						output logic [31:0] d,
						output logic generated_done);

	enum logic [3:0] {	RESET, WAIT, INIT_MODMULT, INIT_DONE, INIT_RESET, INIT_RESET_DONE, MODMULT_LOOP_0, MODMULT_LOOP_1, COMPARE, DECREMENT, FINISHED
							}
							state, next_state;
	
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

	logic [31:0] s, s_holder, dholder;
	logic modmult_ready, modmult_done, modmult_reset;
	
	modular_multiplication mm0(.clk(clk), .reset_n(modmult_reset), .modmult_ready(modmult_ready),
										.base(e), .power(dholder), .denominator(phi),
										.modmult_done(modmult_done),
										.result(s)); // not d, dholder //OR D_HOLDER EITHER
	
	//.base(dholder), .power(e), .denominator(phi), .result(s));
	
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
				if (compute == 1'b1)
					next_state = INIT_MODMULT;
			end
			
			INIT_MODMULT: begin
				if(modmult_done == 1'b1)
					next_state = INIT_DONE;
			end
			
			INIT_DONE: begin
					next_state = INIT_RESET;
			end
			
			INIT_RESET: begin
				next_state = INIT_RESET_DONE;
			end
			
			INIT_RESET_DONE: begin
				next_state = MODMULT_LOOP_0;
			end
			
			MODMULT_LOOP_0: begin
				if(modmult_done == 1'b1)
					next_state = MODMULT_LOOP_1;
			end
			
			MODMULT_LOOP_1: begin
				next_state = COMPARE;
			end
			
			COMPARE: begin
				if(s_holder != 32'd1) //let's change these from d to b // wait, lets change it to 32'd1
					next_state = INIT_RESET;
				else if(s_holder == 32'd1)
					next_state = DECREMENT;
			end
			
			DECREMENT: begin
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
				modmult_reset <= 1'b0; //from 32'd0 to 1'b0
				modmult_ready <= 1'b0; // forgot this
				generated_done <= 1'b0; // and this // change to 1 for test
				dholder <= 32'd1;
				d <= 32'd5;
				s_holder <= 32'd0;
			end
			
			WAIT: begin
				modmult_reset <= 1'b1;
			end
			
			INIT_MODMULT: begin
				modmult_ready = 1'b1;
			end
			INIT_DONE: begin
				modmult_ready = 1'b0;
				s_holder = s;
			end
			
			INIT_RESET: begin
				modmult_reset = 1'b0;
			end
			
			INIT_RESET_DONE: begin
				modmult_reset = 1'b1;
			end
			
			MODMULT_LOOP_0: begin
				modmult_ready = 1'b1;
			end
			
			MODMULT_LOOP_1: begin
				modmult_ready <= 1'b0; //this should be fine
				//modmult_reset = 32'd0;
				s_holder <= s; //move this from modmult_loop_0, finally got everything working
				dholder <= dholder + 1'b1; //moved from loop 0
			end
			
			COMPARE: begin
			
			end
			
			DECREMENT: begin
				d = dholder - 1'b1;
			end
			
			FINISHED: begin
				generated_done = 1'b1;
			end
		endcase
	end

endmodule
