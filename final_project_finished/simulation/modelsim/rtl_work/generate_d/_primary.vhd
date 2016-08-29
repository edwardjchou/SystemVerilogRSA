library verilog;
use verilog.vl_types.all;
entity generate_d is
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        compute         : in     vl_logic;
        e               : in     vl_logic_vector(31 downto 0);
        phi             : in     vl_logic_vector(31 downto 0);
        d               : out    vl_logic_vector(31 downto 0);
        generated_done  : out    vl_logic
    );
end generate_d;
