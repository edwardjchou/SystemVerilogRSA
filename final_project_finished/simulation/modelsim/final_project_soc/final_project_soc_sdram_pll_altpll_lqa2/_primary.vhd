library verilog;
use verilog.vl_types.all;
entity final_project_soc_sdram_pll_altpll_lqa2 is
    port(
        areset          : in     vl_logic;
        clk             : out    vl_logic_vector(4 downto 0);
        inclk           : in     vl_logic_vector(1 downto 0);
        locked          : out    vl_logic
    );
end final_project_soc_sdram_pll_altpll_lqa2;
