module prime_checker_sv(input[31:0] candidate, 
								input prime_checker_ready, reset_n, clk,
							output logic isprime, prime_checker_done);
		
		
	enum logic [2:0] {	RESET, WAIT, COMPUTE, FINISHED
							} state, next_state;	

	
	always_ff @ (posedge clk, negedge reset_n) begin
		if (reset_n == 1'b0) begin
			state <= RESET;
		end 
		else begin
			state <= next_state;
		end
	end	

	always_comb begin
		next_state = state;
		unique case (state)
			RESET: begin
				next_state <= WAIT;
			end
			
			WAIT: begin
				if (prime_checker_ready == 1'b1)
					next_state <= COMPUTE;
			end
			
			COMPUTE: begin
				next_state = FINISHED;
			end
					
			FINISHED: begin
				next_state <= WAIT;
			end
		endcase
	end
			
	always_ff @(posedge clk) begin
		unique case (state)
			RESET: begin
				 isprime = 1'd0;
				 prime_checker_done = 1'd0;
			end
			
			WAIT: begin
			end
			
			COMPUTE: begin
				if(candidate[0] == 1'b0)
					begin 
					isprime = 1'b0;
					end
				else if (candidate == 32'd3 | candidate == 32'd5 | candidate == 32'd7 | candidate == 32'd11 | candidate == 32'd13 | 
				candidate == 32'd17 | candidate == 32'd19) 
					begin
					isprime = 1'b1;
					end
				else if (candidate%3==0 | candidate%5==0 | candidate%7==0 | candidate%11==0 | candidate%13==0 | candidate%17==0 | candidate%19==0)
					begin 
					isprime = 1'b0;
					end
				else if (candidate == 32'b00 | 32'b00000000000000000000000000000010)
					begin
					isprime = 1'b1;
					end
			end
			
			FINISHED: begin
				prime_checker_done = 1'b1;
			end
		endcase
	end

	
	
	
	
	/*						
	 logic [15:0] k;
	 logic o;
    always @(i)
    begin
    k=i;
    if(i[0]==1'b0)
       begin   o=1'b0; $display("not prime");  end
       else 
       begin
       if(k==3 | k==5 | k==7 | k==11 | k==13 | k==17 | k==19)
       begin  o=1'b1; $display("prime"); end
       else if(k%3==0 | k%5==0 | k%7==0 | k%11==0 | k%13==0 | k%17==0 | k%19==0)
       begin   o=1'b0;  $display("not prime");    end 
       else
       begin   o=1'b1;  $display("prime");        end
       end
        if(i==10'b00 | i==10'b010)
        begin o=1'b1; $display("prime");  end
     end
	 */
 endmodule
 