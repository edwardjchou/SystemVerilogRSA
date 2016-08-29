library verilog;
use verilog.vl_types.all;
entity final_project_soc_to_sw_sig is
    port(
        address         : in     vl_logic_vector(1 downto 0);
        clk             : in     vl_logic;
        in_port         : in     vl_logic_vector(2 downto 0);
        reset_n         : in     vl_logic;
        readdata        : out    vl_logic_vector(31 downto 0)
    );
end final_project_soc_to_sw_sig;
