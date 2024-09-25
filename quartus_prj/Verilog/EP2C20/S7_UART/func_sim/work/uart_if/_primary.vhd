library verilog;
use verilog.vl_types.all;
entity uart_if is
    port(
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        txd             : out    vl_logic;
        rxd             : in     vl_logic;
        rom_addr        : out    vl_logic_vector(7 downto 0);
        rom_data        : in     vl_logic_vector(7 downto 0)
    );
end uart_if;
