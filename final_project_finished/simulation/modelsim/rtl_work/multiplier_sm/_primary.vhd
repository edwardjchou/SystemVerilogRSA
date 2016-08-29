library verilog;
use verilog.vl_types.all;
entity multiplier_sm is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        mult_ready      : in     vl_logic;
        in1             : in     vl_logic_vector(31 downto 0);
        in2             : in     vl_logic_vector(31 downto 0);
        mult_done       : out    vl_logic;
        \out\           : out    vl_logic_vector(31 downto 0)
    );
end multiplier_sm;
