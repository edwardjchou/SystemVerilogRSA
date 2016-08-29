library verilog;
use verilog.vl_types.all;
entity modular is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        modular_ready   : in     vl_logic;
        numerator       : in     vl_logic_vector(31 downto 0);
        denominator     : in     vl_logic_vector(31 downto 0);
        modular_done    : out    vl_logic;
        result          : out    vl_logic_vector(31 downto 0)
    );
end modular;
