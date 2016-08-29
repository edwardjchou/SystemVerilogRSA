library verilog;
use verilog.vl_types.all;
entity final_project_soc is
    port(
        clk_clk         : in     vl_logic;
        led_wire_export : out    vl_logic_vector(7 downto 0);
        reset_reset_n   : in     vl_logic;
        sdram_wire_addr : out    vl_logic_vector(12 downto 0);
        sdram_wire_ba   : out    vl_logic;
        sdram_wire_cas_n: out    vl_logic;
        sdram_wire_cke  : out    vl_logic;
        sdram_wire_cs_n : out    vl_logic;
        sdram_wire_dq   : inout  vl_logic_vector(15 downto 0);
        sdram_wire_dqm  : out    vl_logic_vector(1 downto 0);
        sdram_wire_ras_n: out    vl_logic;
        sdram_wire_we_n : out    vl_logic;
        to_hw_port_export: out    vl_logic_vector(31 downto 0);
        to_hw_sig_export: out    vl_logic_vector(2 downto 0);
        to_sw_port_export: in     vl_logic_vector(31 downto 0);
        to_sw_sig_export: in     vl_logic_vector(2 downto 0);
        sdram_clk_clk   : out    vl_logic
    );
end final_project_soc;
