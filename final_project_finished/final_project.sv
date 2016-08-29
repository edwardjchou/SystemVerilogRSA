/*---------------------------------------------------------------------------
  --      lab7.sv                                                          --
  --      Christine Chen                                                   --
  --      10/23/2013                                                       --
  --      modified by Zuofu Cheng                                          --
  --      For use with ECE 385                                             --
  --      UIUC ECE Department                                              --
  ---------------------------------------------------------------------------*/
// Top-level module that integrates the Nios II system with the rest of the hardware

module final_project(  	  input	       CLOCK_50, 
					  input  [1:0]  KEY,
					  //input	[7:0]	 SW,
					  output [17:0] LEDR,
					  output [7:0]  LEDG, 
					  output [12:0] DRAM_ADDR,
					  output [1:0]  DRAM_BA,
					  output        DRAM_CAS_N,
					  output		    DRAM_CKE,
					  output		    DRAM_CS_N,
					  inout  [31:0] DRAM_DQ,
					  output  [3:0] DRAM_DQM,
					  output		    DRAM_RAS_N,
					  output		    DRAM_WE_N,
					  output		    DRAM_CLK,
					  output [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7
					  );
					  
				  logic  [3:0] to_sw_sig;	//[3:0] .......omgggg.....
				  logic  [3:0] to_hw_sig; //[3:0]
				  logic  [31:0] to_sw_port;		
				  logic  [31:0] to_hw_port;
				  
				  logic  [31:0] prime1; 
				  logic  [31:0] prime2; 
				  logic  [31:0] plaintext;
				  logic [31:0] encrypted;
				  logic [31:0] decrypted;
				  logic  [31:0] ciphertext;
				  logic    		generated_ready;
				  logic 		    encrypt_ready;
				  logic			decyprt_ready;
				  logic 			prime_checker_ready1;
				  logic 			prime_checker_ready2;
				  logic			 encrypt_done;
				  logic			decrypt_done;
				  logic 			generated_done;
				  logic   		phi_done;
				  logic			n_done;
				  logic			phi_ready;
				  logic			n_ready;
				  logic 			prime_checker_done1;
				  logic 			isprime1;
				  logic			isprime2;
				  logic			prime_checker_done2;
				  
				  logic [31:0] n, e, phi, d, n_hold;
				//n is the product of two prime numbers
				//e is the public key
				//d is the private key
				//M is the message
				//phi is (prime1 − 1)*(prime2 − 1)

				  
				  assign LEDR[15:0] = {to_hw_port[15:0]};//for debugging
				  assign LEDG[5:0] = {to_sw_sig, to_hw_sig};
				  assign LEDR[16] = generated_done;
				  assign LEDR[17] = generated_ready;
				  
				  final_project_soc NiosII (.clk_clk(CLOCK_50),
											 .reset_reset_n(KEY[0]), 
											 //.led_wire_export(LEDG),
											 .sdram_wire_addr(DRAM_ADDR),    //  sdram_wire.addr
											 .sdram_wire_ba(DRAM_BA),      	//  .ba
											 .sdram_wire_cas_n(DRAM_CAS_N),    //  .cas_n
											 .sdram_wire_cke(DRAM_CKE),     	//  .cke
											 .sdram_wire_cs_n(DRAM_CS_N),      //  .cs_n
											 .sdram_wire_dq(DRAM_DQ),      	//  .dq
											 .sdram_wire_dqm(DRAM_DQM),     	//  .dqm
											 .sdram_wire_ras_n(DRAM_RAS_N),    //  .ras_n
											 .sdram_wire_we_n(DRAM_WE_N),      //  .we_n
											 .sdram_clk_clk(DRAM_CLK),		//  clock out to SDRAM from other PLL port
											 .to_sw_sig_export(to_sw_sig), 
											 .to_hw_sig_export(to_hw_sig),
											 .to_sw_port_export(to_sw_port),
											 .to_hw_port_export(to_hw_port)
											 //.switches_wire_export(SW),
											 //.buttons_wire_export(KEY)
											 );
											 
				io_module io_module0 (.clk(CLOCK_50),
										.reset_n(KEY[1]),
										.to_sw_sig(to_sw_sig),
										.to_sw_port(to_sw_port),
										.to_hw_sig(to_hw_sig),
										.to_hw_port(to_hw_port),
										.prime1(prime1),
										.prime2(prime2),
										.phi(phi),
										.e(e),
										.n(n),
										.n_hold(n_hold),
										.d(d),
										.plaintext(plaintext),
										.encrypted(encrypted),
										.ciphertext(ciphertext),
										.decrypted(decrypted),
										.encrypt_ready(encrypt_ready),
										.encrypt_done(encrypt_done),
										.decrypt_ready(decrypt_ready),
										.decrypt_done(decrypt_done),
										.phi_ready(phi_ready),
										.n_ready(n_ready),
										.generated_ready(generated_ready),
										.phi_done(phi_done),
										.n_done(n_done),
										.generated_done(generated_done),
										.prime_checker_ready1(prime_checker_ready1),
										.prime_checker_done1(prime_checker_done1),
										.isprime1(isprime1),
										.prime_checker_ready2(prime_checker_ready2),
										.prime_checker_done2(prime_checker_done2),
										.isprime2(isprime2)
					);
					
				//multiplier multiplier0(.in1(prime1), .in2(prime2),
				//		 .out()); //out is n
						 
				//p1 = 17, p2 = 19
				logic [31:0] n_in, e_in, plaintext_in;
				assign n_in[31:0] = n[31:0]; //32'd323;
				assign e_in[31:0] = e[31:0]; //32'd71;
				assign plaintext_in[31:0] = plaintext[31:0]; //32'd67;
				
				//use same n
				logic [31:0] d_in, ciphertext_in;
				assign ciphertext_in[31:0] = encrypted[31:0]; //will go where plaintext goes //not ciphertext, no input yet
				assign d_in[31:0] = d[31:0]; //will go where e goes
						 
				prime_checker_sv prime_checker_sv0(.candidate(prime1), 
								.prime_checker_ready(prime_checker_ready1), .reset_n(KEY[1]), .clk(CLOCK_50),
							.isprime(isprime1), .prime_checker_done(prime_checker_done1));
				prime_checker_sv prime_checker_sv1(.candidate(prime2), 
								.prime_checker_ready(prime_checker_ready2), .reset_n(KEY[1]), .clk(CLOCK_50),
							.isprime(isprime2), .prime_checker_done(prime_checker_done2));
				
				phi_gen phi_gen0(.in1(prime1), .in2(prime2), .clk(CLOCK_50), .reset_n(KEY[1]), .phi_ready(phi_ready)
				,.out(phi), .phi_done(phi_done));
				
				n_gen n_gen0(.in1(prime1), .in2(prime2), .clk(CLOCK_50), .reset_n(KEY[1]), .n_ready(n_ready)
				,.out(n), .n_done(n_done)); //remember to assign out as n!
				
				generate_d generate_d0(.clk(CLOCK_50), .reset_n(KEY[1]), .compute(generated_ready),
						.e(e), .phi(phi),
						.d(d), .generated_done(generated_done));
				
				rsa_encrypt rsa_encrypt0(.clk(CLOCK_50), .reset_n(KEY[1]), .compute(encrypt_ready),
						.M(plaintext_in), .e(e_in), .n(n_in),
						.C(encrypted), .encrypt_done(encrypt_done));
						
				//actually is same module, let's just use same module
				rsa_encrypt rsa_decrypt0(.clk(CLOCK_50), .reset_n(KEY[1]), .compute(decrypt_ready),
						.M(ciphertext_in), .e(d_in), .n(n_in),
						.C(decrypted), .encrypt_done(decrypt_done));
					
			/*	
				rsa_encrypt_nosm rsa_encrypt0(.clk(CLOCK_50), .reset_n(KEY[1]), .compute(encrypt_ready),
						.M(plaintext_in), .e(e_in), .n(n_in),
						.C(encrypted), .encrypt_done(encrypt_done));
				*/	
			/*	
				rsa_decrypt rsa_decrypt0(.clk(CLOCK_50), .reset_n(KEY[1]), .compute(decrypt_ready),
						.C(ciphertext), .d(d), .n(n),
						.M(decrypted), .decrypt_done(decrypt_done));
				*/		
						
					
					
					
					HexDriver        Hex0 (.In0(prime1[3:0]),
											     .Out0(HEX0) );
					HexDriver        Hex1 (.In0(prime1[7:4]),
											     .Out0(HEX1) );
					HexDriver        Hex2 (.In0(prime2[3:0]),
											     .Out0(HEX2) );
					HexDriver        Hex3 (.In0(prime2[7:4]),
											     .Out0(HEX3) );
					HexDriver        Hex4 (.In0(e[3:0]),
											     .Out0(HEX4) );
					HexDriver        Hex5 (.In0(e[7:4]),
											     .Out0(HEX5) );
					HexDriver        Hex6 (.In0(decrypted[3:0]), //from plaintext
											     .Out0(HEX6) );
					HexDriver        Hex7 (.In0(decrypted[7:4]),
											     .Out0(HEX7) );		
endmodule