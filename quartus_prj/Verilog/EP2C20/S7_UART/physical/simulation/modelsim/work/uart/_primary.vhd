library verilog;
use verilog.vl_types.all;
entity uart is
    port(
        dout            : out    vl_logic_vector(7 downto 0);
        data_ready      : out    vl_logic;
        framing_error   : out    vl_logic;
        parity_error    : out    vl_logic;
        rxd             : in     vl_logic;
        clk16x          : in     vl_logic;
        rst             : in     vl_logic;
        rdn             : in     vl_logic;
        din             : in     vl_logic_vector(7 downto 0);
        tbre            : out    vl_logic;
        tsre            : out    vl_logic;
        wrn             : in     vl_logic;
        sdo             : out    vl_logic
    );
end uart;
