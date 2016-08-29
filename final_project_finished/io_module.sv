module io_module (		input			 		clk,
						input			 		reset_n,
						output logic [3:0]  	to_sw_sig,
						output logic [31:0]  	to_sw_port,
						input [3:0]  			to_hw_sig,
						input [31:0]  			to_hw_port,
						output logic [31:0] 	prime1,
						output logic [31:0] 	prime2,
						input [31:0]  phi, //(p1-1) * (p2-2), generate in hardware, need to send back to user
						input [31:0]  n, //prime number 1 * prime number 2, same
						output logic [31:0] n_hold,
						input [31:0]  d, //public key, same
 						//output logic [31:0] 	public_key,
						output logic [31:0] 	plaintext,
						input [31:0] encrypted,
						output logic [31:0] 	ciphertext,
						input [31:0] decrypted,
						output logic [31:0]	e,  // e is the public_key
						output logic					encrypt_ready,
						output logic					decrypt_ready,
						output logic 					phi_ready,
						output logic					n_ready,
						output logic					generated_ready,
						output logic 					prime_checker_ready1,
						output logic 					prime_checker_ready2,
						input					encrypt_done,
						input					decrypt_done,
						input 				phi_done,
						input					n_done,
						input					generated_done,
						input 				prime_checker_done1,
						input 				prime_checker_done2,
						input					isprime1,
						input					isprime2
						);
						
		enum logic [6:0] {	RESET, WAIT,
							READ_PRM1,
							ACK_PRM1, 
							
							SEND_TO_PRIME_CHECKER_1,
							GET_FROM_PRIME_CHECKER_1,
							SEND_BACK_PRIME_1,
							GOT_ACK_PRIME_1,
							
							READ_PRM2,
							ACK_PRM2,
							
							SEND_TO_PRIME_CHECKER_2,
							GET_FROM_PRIME_CHECKER_2,
							SEND_BACK_PRIME_2,
							GOT_ACK_PRIME_2,
							
							SEND_TO_RSA_PHI,
							GET_FROM_RSA_PHI,
							SEND_BACK_PHI,
							GOT_ACK_PHI,
							
							SEND_TO_RSA_N,
							GET_FROM_RSA_N,
							SEND_BACK_N,
							GOT_ACK_N,
							
							READ_E,
							ACK_E,
							
							READ_PLAINTEXT,
							ACK_PLAINTEXT,
							
							SEND_TO_RSA_GEND,
							GET_FROM_RSA_GEND,
							SEND_BACK_GEND,
							GOT_ACK_GEND,
							
							SEND_TO_RSA_ENCRYPT, 
							GET_FROM_RSA_ENCRYPT,
							SEND_BACK_ENCRYPTED,
							GOT_ACK_ENCRYPTED,
							
							SEND_TO_RSA_DECRYPT, 
							GET_FROM_RSA_DECRYPT,
							SEND_BACK_DECRYPTED,
							GOT_ACK_DECRYPTED}
							state, next_state;
						
	always @ (posedge clk, negedge reset_n) begin
			if (reset_n == 1'b0) begin
				state <= RESET;
				prime1 <= 32'd0;
				prime2 <= 32'd0;
				//public_key <= 32'd0;
				plaintext <= 32'd0;
				to_sw_port <= 32'd0;
				e <= 32'd0;
				//phi <= 32'd0;
				ciphertext <= 32'd0;
				n_hold <= 32'd0;
			end 
			else 
			begin
				state <= next_state;
				case (state)
					READ_PRM1: begin
						prime1[31:0] <= to_hw_port[31:0];
					end
					
					SEND_BACK_PRIME_1: begin
						to_sw_port[31:0] <= {31'b0, isprime1};
					end
					
					SEND_BACK_PRIME_2: begin
						to_sw_port[31:0] <= {31'b0, isprime2};
					end
					//READ_PRM2
					READ_PRM2: begin
						prime2[31:0] <= to_hw_port[31:0];
					end
					

					
					SEND_BACK_PHI: begin
						to_sw_port[31:0] <= phi[31:0];
					end
					
					SEND_BACK_N: begin
						to_sw_port[31:0] <= n[31:0];
						n_hold <= n[31:0];
					end
					
					//READ_E
					READ_E: begin
						e[31:0]<= to_hw_port[31:0];
					end

					//READ_PLAINTEXT
					READ_PLAINTEXT: begin
						plaintext[31:0]<= to_hw_port[31:0];
					end
					
					SEND_BACK_GEND: begin
						to_sw_port[31:0] <= d[31:0];
					end
					
					//SEND_BACK
					SEND_BACK_ENCRYPTED: begin
						to_sw_port[31:0] <= encrypted[31:0]; //ciphertext[31:0];
					end
					
					SEND_BACK_DECRYPTED: begin
						to_sw_port[31:0] <= decrypted[31:0]; //plaintext[31:0];
					end
					
				endcase
			end
		end
		
		always_comb begin
			next_state = state;
			unique case (state)
				RESET: begin
					if(to_hw_sig == 4'd8)
						next_state = WAIT;
				end
				
				WAIT: begin
					if(to_hw_sig == 4'd8)
						next_state = WAIT;
					else if (to_hw_sig == 4'd1)
						next_state = READ_PRM1;
					else if (to_hw_sig == 4'd2)
						next_state = READ_PRM2;
					else if (to_hw_sig == 4'd11)//prime checker
						next_state = SEND_TO_PRIME_CHECKER_1;
					else if (to_hw_sig == 4'd12)//prime checker2
						next_state = SEND_TO_PRIME_CHECKER_2;
					else if (to_hw_sig == 4'd3)
						next_state = SEND_TO_RSA_PHI;
					else if (to_hw_sig == 4'd9)
						next_state = SEND_TO_RSA_N;
					else if (to_hw_sig == 4'd4)
						next_state = READ_E;
					else if (to_hw_sig == 4'd10)
						next_state = SEND_TO_RSA_GEND;
					else if (to_hw_sig == 4'd5)
						next_state = READ_PLAINTEXT;
					else if (to_hw_sig == 4'd6)
						next_state = SEND_TO_RSA_ENCRYPT;
					else if (to_hw_sig == 4'd7)
						next_state = SEND_TO_RSA_DECRYPT;
				end
				
				//READ_PRM1
				READ_PRM1: begin
					if (to_hw_sig == 4'd0)//if to_hw_sig is 0, go to acknowledge
						next_state = ACK_PRM1;
				end			
				ACK_PRM1: begin
					if (to_hw_sig == 4'd8)// if to_hw_sig is 1, go back to wait state
						next_state = WAIT;
					else if(to_hw_sig == 4'd2)
						next_state = WAIT;
				end

				//READ_PRM2
				READ_PRM2: begin
					if (to_hw_sig == 4'd0)//if to_hw_sig is 0, go to acknowledge
						next_state = ACK_PRM2;
				end			
				ACK_PRM2: begin
					if (to_hw_sig == 4'd8)// if to_hw_sig is 1, go back to wait state
						next_state = WAIT;
				end
				
				
				//SEND_BACK_PRIME_CHECKER
				SEND_TO_PRIME_CHECKER_1:begin
					if(prime_checker_done1 == 1'd1)
					next_state = GET_FROM_PRIME_CHECKER_1;
					end
				GET_FROM_PRIME_CHECKER_1:begin
					if (to_hw_sig == 4'd1) 
					next_state = SEND_BACK_PRIME_1;
					end
				SEND_BACK_PRIME_1: begin
					if (to_hw_sig == 4'd2)  
						next_state = GOT_ACK_PRIME_1;
					end
				GOT_ACK_PRIME_1: begin
					if (to_hw_sig == 4'd8)
						next_state = WAIT;
					end
				
				//SEND_BACK_PRIME_CHECKER2
				SEND_TO_PRIME_CHECKER_2:begin
					if(prime_checker_done2 == 1'd1)
					next_state = GET_FROM_PRIME_CHECKER_2;
					end
				GET_FROM_PRIME_CHECKER_2:begin
					if (to_hw_sig == 4'd1) 
					next_state = SEND_BACK_PRIME_2;
					end
				SEND_BACK_PRIME_2: begin
					if (to_hw_sig == 4'd2)  
						next_state = GOT_ACK_PRIME_2;
					end
				GOT_ACK_PRIME_2: begin
					if (to_hw_sig == 4'd8)
						next_state = WAIT;
				end
					
					
				//SEND_BACK_PHI
				SEND_TO_RSA_PHI:begin
					if(phi_done == 1'd1)
					next_state = GET_FROM_RSA_PHI;
					end
				GET_FROM_RSA_PHI:begin
					if (to_hw_sig == 4'd1) 
					next_state = SEND_BACK_PHI;
					end
				SEND_BACK_PHI: begin
					if (to_hw_sig == 4'd2)  
						next_state = GOT_ACK_PHI;
					end
				GOT_ACK_PHI: begin
					if (to_hw_sig == 4'd8)
						next_state = WAIT;
					end
					
				SEND_TO_RSA_N:begin
					if(n_done == 1'd1)
					next_state = GET_FROM_RSA_N;
					end
				GET_FROM_RSA_N:begin
					if (to_hw_sig == 4'd1) 
					next_state = SEND_BACK_N;
					end
				SEND_BACK_N: begin
					if (to_hw_sig == 4'd2)  
						next_state = GOT_ACK_N;
					end
				GOT_ACK_N: begin
					if (to_hw_sig == 4'd8)
						next_state = WAIT;
					end
					
				
				//READ_E
				READ_E: begin
					if (to_hw_sig == 4'd0)//if to_hw_sig is 0, go to acknowledge
						next_state = ACK_E;
				end			
				ACK_E: begin
					if (to_hw_sig == 4'd8)// if to_hw_sig is 1, go back to wait state
						next_state = WAIT;
				end
				
				//GEND
				SEND_TO_RSA_GEND:begin
					if(generated_done == 1'd1)
					next_state = GET_FROM_RSA_GEND;
					end
				GET_FROM_RSA_GEND:begin
					if (to_hw_sig == 4'd1) 
					next_state = SEND_BACK_GEND;
					end
				SEND_BACK_GEND: begin
					if (to_hw_sig == 4'd2)  
						next_state = GOT_ACK_GEND;
					end
				GOT_ACK_GEND: begin
					if (to_hw_sig == 4'd8)
						next_state = WAIT;
					end
				
				//READ_PLAINTEXT
				READ_PLAINTEXT: begin
					if (to_hw_sig == 4'd0)//if to_hw_sig is 0, go to acknowledge
						next_state = ACK_PLAINTEXT;
				end			
				ACK_PLAINTEXT: begin
					if (to_hw_sig == 4'd8)// if to_hw_sig is 1, go back to wait state
						next_state = WAIT;
				end
				
				
				//SEND_BACK_STATE_LOOP
				SEND_TO_RSA_ENCRYPT: begin
					if (encrypt_done == 1'd1)
						next_state = GET_FROM_RSA_ENCRYPT;
				end
				GET_FROM_RSA_ENCRYPT: begin
					if (to_hw_sig == 4'd1) 
						next_state = SEND_BACK_ENCRYPTED;
				end
				SEND_BACK_ENCRYPTED: begin
					if (to_hw_sig == 4'd2)
						next_state = GOT_ACK_ENCRYPTED;
				end
				GOT_ACK_ENCRYPTED: begin
					if (to_hw_sig == 4'd8)
						next_state = WAIT;
				end
				
				
				//SEND_BACK_DECRYPTED
				SEND_TO_RSA_DECRYPT: begin
					if (decrypt_done == 1'd1)
						next_state = GET_FROM_RSA_DECRYPT;
				end
				GET_FROM_RSA_DECRYPT: begin
					if (to_hw_sig == 4'd1) 
						next_state = SEND_BACK_DECRYPTED;
				end
				SEND_BACK_DECRYPTED: begin
					if (to_hw_sig == 4'd2)
						next_state = GOT_ACK_DECRYPTED;
				end
				GOT_ACK_DECRYPTED: begin
					if (to_hw_sig == 4'd8)
						next_state = WAIT;
				end
							
			endcase
		end						
						
		//always_comb begin     WHY NOT ALWAYS_COMB?????????
			always_ff @(posedge clk) begin
			//to_sw_sig = 4'd0; //THIS LINE SUCKS
			//encrypt_ready = 1'b0;
			//decrypt_ready = 1'b0;
			//phi_ready = 1'b0;
			//n_ready = 1'b0;
			unique case (state)
				RESET: begin
					encrypt_ready = 1'b0;
					decrypt_ready = 1'b0;
					phi_ready = 1'b0;
					n_ready = 1'b0;
					to_sw_sig = 4'd3;
				end
			
				WAIT: begin
					to_sw_sig = 4'd7;
				end
				
				//READ_PRM1_OUTPUT_LOOP
				READ_PRM1: begin
					to_sw_sig = 4'd1;
				end		
				ACK_PRM1: begin
					to_sw_sig = 4'd2; //should be 0
				end
				
				SEND_TO_PRIME_CHECKER_1: begin
					to_sw_sig = 4'd3;
					prime_checker_ready1 = 1'b1;
				end
				
				GET_FROM_PRIME_CHECKER_1: begin
					prime_checker_ready1 = 1'b0;
					to_sw_sig = 4'd2;
				end
				SEND_BACK_PRIME_1:begin
					to_sw_sig = 4'd1;
				end
				GOT_ACK_PRIME_1: begin
					to_sw_sig = 4'd0;
				end
				
				SEND_TO_PRIME_CHECKER_2: begin
					to_sw_sig = 4'd3;
					prime_checker_ready2 = 1'b1;
				end
				
				GET_FROM_PRIME_CHECKER_2: begin
					prime_checker_ready2 = 1'b0;
					to_sw_sig = 4'd2;
				end
				SEND_BACK_PRIME_2:begin
					to_sw_sig = 4'd1;
				end
				GOT_ACK_PRIME_2: begin
					to_sw_sig = 4'd0;
				end
				//READ_PRM2_OUTPUT_LOOP
				READ_PRM2: begin
					to_sw_sig = 4'd1;
				end		
				ACK_PRM2: begin
					to_sw_sig = 4'd0;
				end
				
				//SEND_TO_PHI
				SEND_TO_RSA_PHI: begin
					to_sw_sig = 4'd3;
					phi_ready = 1'b1;
					//n_ready = 1'b1; // we parallel generate n
				end
				
				//GET_FROM_RSA_PHI
				GET_FROM_RSA_PHI: begin
					phi_ready = 1'b0;
					to_sw_sig = 4'd2;
				end
				SEND_BACK_PHI: begin
					to_sw_sig = 4'd1;
				end
				
				GOT_ACK_PHI: begin
					to_sw_sig = 4'd0;
				end
				
				//SEND_TO_N
				SEND_TO_RSA_N: begin
					to_sw_sig = 4'd3;
					n_ready = 1'b1;
				end
				
				//GET_FROM_RSA_N
				GET_FROM_RSA_N: begin
					n_ready = 1'b0;
					to_sw_sig = 4'd2;
				end
				SEND_BACK_N: begin
					to_sw_sig = 4'd1;
				end
				
				GOT_ACK_N: begin
					to_sw_sig = 4'd0;
				end
				
				//READ_E_OUTPUT_LOOP
				READ_E: begin
					to_sw_sig = 4'd1;
				end		
				ACK_E: begin
					to_sw_sig = 4'd0;
				end
				
				//GEND
				SEND_TO_RSA_GEND: begin
					to_sw_sig = 4'd3;
					if(to_hw_sig == 4'd5)
						begin
						to_sw_sig = 4'd4;
						generated_ready = 1'b1;
						end
				end
				GET_FROM_RSA_GEND: begin
					generated_ready = 1'b0;
					to_sw_sig = 4'd2;
				end
				SEND_BACK_GEND: begin
					to_sw_sig = 4'd1;
				end
				
				GOT_ACK_GEND: begin
					to_sw_sig = 4'd0;
				end
				
				//READ_PLAINTEXT_OUTPUT_LOOP
				READ_PLAINTEXT: begin
					to_sw_sig = 4'd1;
				end		
				ACK_PLAINTEXT: begin
					to_sw_sig = 4'd0;
					//encrypt_ready = 1'b1;
				end

				
				//SEND_BACK_ENCRYPTED
				SEND_TO_RSA_ENCRYPT: begin
					to_sw_sig = 4'd3;
					if(to_hw_sig == 4'd5)
						encrypt_ready = 1'b1;
				end
				
				GET_FROM_RSA_ENCRYPT: begin
					to_sw_sig = 4'd2;
					encrypt_ready = 1'b0;
				end
				SEND_BACK_ENCRYPTED: begin
					to_sw_sig = 4'd1;
				end
				
				GOT_ACK_ENCRYPTED: begin
					to_sw_sig = 4'd0;
				end
				
				//SEND_BACK_DECRYPTED
				SEND_TO_RSA_DECRYPT: begin
					to_sw_sig = 4'd3;
					if(to_hw_sig == 4'd5)
						decrypt_ready = 1'b1;
				end
				
				GET_FROM_RSA_DECRYPT: begin
					to_sw_sig = 4'd2;
					decrypt_ready = 1'b0;
				end
				SEND_BACK_DECRYPTED: begin
					to_sw_sig = 4'd1;
				end
				
				GOT_ACK_DECRYPTED: begin
					to_sw_sig = 4'd0;
				end
			endcase
		end						
						
						
						
						
											
endmodule
