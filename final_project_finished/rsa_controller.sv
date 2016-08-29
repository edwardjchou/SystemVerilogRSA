module rsa_controller(
				input			 		clk,
				input					reset_n,
				input	[31:0]			msg_en,
				input	[31:0]			key,
				output  [31:0]			msg_de,
				input					io_ready,
				output					aes_ready
			    );

enum logic [1:0] {WAIT, COMPUTE, READY} state, next_state;
logic [15:0] counter;

logic rsa_done;


//rsa_encrypt rsa_encrypt0(.Ciphertext(msg_en), .Cipherkey(key), .Clk(clk), .Reset(reset_n), .Run(aes_ready), .Plaintext(msg_de), .Ready(aes_done)); 
//rsa_encrypt rsa_encrypt0(clk(clk), reset_n(reset_n), compute(),
						//input [31:0] M, e, n,
						//output logic [31:0] C);
						
						
always_ff @ (posedge clk, negedge reset_n) begin
	if (reset_n == 1'b0) begin
		state <= WAIT;
		counter <= 16'd0;
	end else begin
		state <= next_state;
		if (state == COMPUTE)
			counter <= counter + 1'b1;
	end
end

always_comb begin
	next_state = state;
	case (state)
		WAIT: begin
			if (io_ready)
				next_state = COMPUTE;
		end
		
		COMPUTE: begin
			if (counter == 16'd65535)
				next_state = READY;
		end
		
		READY: begin
			if(aes_done == 1'b1)
				next_state = WAIT;
		end
	endcase
end

always_comb begin
	aes_ready = 1'b0;
	case (state)
		WAIT: begin
			aes_ready = 1'b0;
		end
		
		COMPUTE: begin
			aes_ready = 1'b1;
		end
		
		READY: begin
			aes_ready = 1'b0;
		end
	endcase
end
			  
endmodule