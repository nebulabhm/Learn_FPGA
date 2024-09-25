library verilog;
use verilog.vl_types.all;
entity uart_if is
    port(
        rxd             : in     vl_logic;
        clk             : in     vl_logic;
        rst_n           : in     vl_logic;
        txd             : out    vl_logic
    );
end uart_if;
