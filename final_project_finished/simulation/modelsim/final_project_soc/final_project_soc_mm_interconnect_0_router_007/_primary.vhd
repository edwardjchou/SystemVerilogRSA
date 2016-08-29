library verilog;
use verilog.vl_types.all;
entity final_project_soc_mm_interconnect_0_router_007 is
    port(
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        sink_valid      : in     vl_logic;
        sink_data       : in     vl_logic_vector(85 downto 0);
        sink_startofpacket: in     vl_logic;
        sink_endofpacket: in     vl_logic;
        sink_ready      : out    vl_logic;
        src_valid       : out    vl_logic;
        src_data        : out    vl_logic_vector(85 downto 0);
        src_channel     : out    vl_logic_vector(10 downto 0);
        src_startofpacket: out    vl_logic;
        src_endofpacket : out    vl_logic;
        src_ready       : in     vl_logic
    );
end final_project_soc_mm_interconnect_0_router_007;
