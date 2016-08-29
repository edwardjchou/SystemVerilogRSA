library verilog;
use verilog.vl_types.all;
entity final_project_soc_nios2_qsys_0_nios2_oci_dtrace is
    port(
        clk             : in     vl_logic;
        cpu_d_address   : in     vl_logic_vector(25 downto 0);
        cpu_d_read      : in     vl_logic;
        cpu_d_readdata  : in     vl_logic_vector(31 downto 0);
        cpu_d_wait      : in     vl_logic;
        cpu_d_write     : in     vl_logic;
        cpu_d_writedata : in     vl_logic_vector(31 downto 0);
        jrst_n          : in     vl_logic;
        trc_ctrl        : in     vl_logic_vector(15 downto 0);
        atm             : out    vl_logic_vector(35 downto 0);
        dtm             : out    vl_logic_vector(35 downto 0)
    );
end final_project_soc_nios2_qsys_0_nios2_oci_dtrace;
