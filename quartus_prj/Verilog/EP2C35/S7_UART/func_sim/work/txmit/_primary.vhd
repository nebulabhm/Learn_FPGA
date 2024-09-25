library verilog;
use verilog.vl_types.all;
entity txmit is
    port(
        din             : in     vl_logic_vector(7 downto 0);
        tbre            : out    vl_logic;
        tsre            : out    vl_logic;
        rst             : in     vl_logic;
        clk16x          : in     vl_logic;
        wrn             : in     vl_logic;
        sdo             : out    vl_logic
    );
end txmit;
