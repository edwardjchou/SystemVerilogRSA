library verilog;
use verilog.vl_types.all;
entity final_project_soc_nios2_qsys_0_nios2_oci_fifo_wrptr_inc is
    port(
        ge2_free        : in     vl_logic;
        ge3_free        : in     vl_logic;
        input_tm_cnt    : in     vl_logic_vector(1 downto 0);
        fifo_wrptr_inc  : out    vl_logic_vector(3 downto 0)
    );
end final_project_soc_nios2_qsys_0_nios2_oci_fifo_wrptr_inc;
