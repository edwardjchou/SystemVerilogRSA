module testbench();

timeunit 10ns;

timeprecision 1ns;

logic clk =0;
logic [31:0]i;
logic ready;
logic reset_n;
logic isprime;
logic done;

prime_checker_sv prime(.clk(clk), .reset_n(reset_n), .candidate(i), 
								.prime_checker_ready(ready),
							.isprime(isprime), .prime_checker_done(done)); 

always begin : CLOK_GENERATION
#1 clk = ~clk;

end


initial begin: TEST_VECTORS
#10 reset_n = 1'b0;
#10 reset_n = 1'b1;
#10 i = 32'b00000101001;
#10 ready = 1'b1;
#10 i = 32'b00000101111;
#10 i = 32'b00001100101;
#10 i = 32'b00110011001;
#10 i = 32'b00110011000;
#10 i = 32'd23;
#10 i = 32'd26;
end

/*io_module io_module0 (.clk(CLOCK_50),
										.reset_n(reset_n),
										.to_sw_sig(to_sw_sig),
										.to_sw_port(to_sw_port),
										.to_hw_sig(to_hw_sig),
										.to_hw_port(to_hw_port),
										.prime1(prime1),
										.prime2(prime2),
										.public_key(public_key),
										.plaintext(plaintext),
										.ciphertext(ciphertext),
										.io_ready(io_ready),
										.rsa_ready(rsa_ready)
					);

always begin : CLOK_GENERATION
#1 clk = ~clk;

end*/

	
				
					
				
endmodule


