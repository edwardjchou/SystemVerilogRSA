library verilog;
use verilog.vl_types.all;
entity modular_multiplication is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        modmult_ready   : in     vl_logic;
        base            : in     vl_logic_vector(31 downto 0);
        power           : in     vl_logic_vector(31 downto 0);
        denominator     : in     vl_logic_vector(31 downto 0);
        modmult_done    : out    vl_logic;
        result          : out    vl_logic_vector(31 downto 0)
    );
end modular_multiplication;
