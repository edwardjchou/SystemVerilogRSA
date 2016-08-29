
module final_project_soc (
	clk_clk,
	led_wire_export,
	reset_reset_n,
	sdram_wire_addr,
	sdram_wire_ba,
	sdram_wire_cas_n,
	sdram_wire_cke,
	sdram_wire_cs_n,
	sdram_wire_dq,
	sdram_wire_dqm,
	sdram_wire_ras_n,
	sdram_wire_we_n,
	to_hw_port_export,
	to_hw_sig_export,
	to_sw_port_export,
	to_sw_sig_export,
	sdram_clk_clk);	

	input		clk_clk;
	output	[7:0]	led_wire_export;
	input		reset_reset_n;
	output	[12:0]	sdram_wire_addr;
	output		sdram_wire_ba;
	output		sdram_wire_cas_n;
	output		sdram_wire_cke;
	output		sdram_wire_cs_n;
	inout	[15:0]	sdram_wire_dq;
	output	[1:0]	sdram_wire_dqm;
	output		sdram_wire_ras_n;
	output		sdram_wire_we_n;
	output	[31:0]	to_hw_port_export;
	output	[3:0]	to_hw_sig_export;
	input	[31:0]	to_sw_port_export;
	input	[3:0]	to_sw_sig_export;
	output		sdram_clk_clk;
endmodule
