
cmp start_batch

project start_batch

project start_batch uart_if
cmp add_assignment "" "" "" ROOT "|uart_if"
cmp add_assignment "" "" "" FAMILY "CYCLONE"
cmp add_assignment "uart_if" "" "" DEVICE "EP1C12Q240C8"
project add_assignment "" "uart_if" "" "" "EDA_DESIGN_ENTRY_SYNTHESIS_TOOL" "SYNPLIFY"
project add_assignment "" "eda_design_synthesis" "" "" "EDA_USE_LMF" "synplcty.lmf"
project add_assignment "" "|cnt3_setting" "" "" "DUTY_CYCLE" "50"
project add_assignment "uart_if" "" "" "|cnt\[3\]" "GLOBAL_SIGNAL" "ON"
project add_assignment "uart_if" "" "" "|cnt\[3\]" "USE_CLOCK_SETTINGS" "|cnt3_setting"
project add_assignment "" "|cnt3_setting" "" "" "FMAX_REQUIREMENT" "1.0MHZ"
project add_assignment "" "|wrn_setting" "" "" "DUTY_CYCLE" "50"
project add_assignment "uart_if" "" "" "|wrn_i_1" "GLOBAL_SIGNAL" "ON"
project add_assignment "uart_if" "" "" "|wrn_i_1" "USE_CLOCK_SETTINGS" "|wrn_setting"
project add_assignment "" "|wrn_setting" "" "" "FMAX_REQUIREMENT" "1.0MHZ"
project add_assignment "" "|uart:U1|txmit:u2|U1_u2_clkdiv3_setting" "" "" "DUTY_CYCLE" "50"
project add_assignment "uart_if" "" "" "|uart:U1|txmit:u2|U1_u2_clkdiv\[3\]" "GLOBAL_SIGNAL" "ON"
project add_assignment "uart_if" "" "" "|uart:U1|txmit:u2|U1_u2_clkdiv\[3\]" "USE_CLOCK_SETTINGS" "|uart:U1|txmit:u2|U1_u2_clkdiv3_setting"
project add_assignment "" "|uart:U1|txmit:u2|U1_u2_clkdiv3_setting" "" "" "FMAX_REQUIREMENT" "1.0MHZ"
project add_assignment "" "|uart:U1|rcvr:u1|U1_u1_clkdiv3_setting" "" "" "DUTY_CYCLE" "50"
project add_assignment "uart_if" "" "" "|uart:U1|rcvr:u1|U1_u1_clkdiv\[3\]" "GLOBAL_SIGNAL" "ON"
project add_assignment "uart_if" "" "" "|uart:U1|rcvr:u1|U1_u1_clkdiv\[3\]" "USE_CLOCK_SETTINGS" "|uart:U1|rcvr:u1|U1_u1_clkdiv3_setting"
project add_assignment "" "|uart:U1|rcvr:u1|U1_u1_clkdiv3_setting" "" "" "FMAX_REQUIREMENT" "1.0MHZ"
project add_assignment "" "clk_setting" "" "" "DUTY_CYCLE" "50"
project add_assignment "uart_if" "" "" "clk" "GLOBAL_SIGNAL" "ON"
project add_assignment "uart_if" "" "" "clk" "USE_CLOCK_SETTINGS" "clk_setting"
project add_assignment "" "clk_setting" "" "" "FMAX_REQUIREMENT" "1.0MHZ"
project add_assignment "" "" "" "" "TAO_FILE" "myresults.tao"
project add_assignment "" "" "" "" "SOURCES_PER_DESTINATION_INCLUDE_COUNT" "1000"
project add_assignment "" "" "" "" "ROUTER_REGISTER_DUPLICATION" "ON"

# False path constraints 

# Multicycle constraints 

# Path delay constraints 

project end_batch uart_if

project end_batch

cmp end_batch
