library verilog;
use verilog.vl_types.all;
entity final_project_soc_sdram_pll_dffpipe_l2c is
    port(
        clock           : in     vl_logic;
        clrn            : in     vl_logic;
        d               : in     vl_logic_vector(0 downto 0);
        q               : out    vl_logic_vector(0 downto 0)
    );
end final_project_soc_sdram_pll_dffpipe_l2c;
