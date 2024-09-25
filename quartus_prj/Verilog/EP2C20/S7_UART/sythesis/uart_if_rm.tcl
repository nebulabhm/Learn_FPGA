if {[cmp get_assignment_value "" "" "" ROOT] != ""} {
  cmp remove_assignment "" "" "" ROOT ""
}
if {[cmp get_assignment_value "" "" "" FAMILY] !=  ""} {
  cmp remove_assignment "" "" "" FAMILY ""
}
if {[cmp get_assignment_value "uart_if" "" "" DEVICE] !=  ""} {
  cmp remove_assignment "uart_if" "" "" DEVICE ""
}
if {[project get_assignment_value "" "|cnt3_setting" "" "" "DUTY_CYCLE"] != ""} {
  project remove_assignment "" "|cnt3_setting" "" "" "DUTY_CYCLE" ""
}
if {[project get_assignment_value "uart_if" "" "" "|cnt\[3\]" "GLOBAL_SIGNAL"] !=  ""} {
  project remove_assignment "uart_if" "" "" "|cnt\[3\]" "GLOBAL_SIGNAL" ""
}
if {[project get_assignment_value "uart_if" "" "" "|cnt3" "USE_CLOCK_SETTINGS"] != ""} {
  project remove_assignment "uart_if" "" "" "|cnt3" "USE_CLOCK_SETTINGS" ""
}
if {[project get_assignment_value "" "|cnt3_setting" "" "" "FMAX_REQUIREMENT"] != ""} {
  project remove_assignment "" "|cnt3_setting" "" "" "FMAX_REQUIREMENT" ""
}
if {[project get_assignment_value "" "|wrn_setting" "" "" "DUTY_CYCLE"] != ""} {
  project remove_assignment "" "|wrn_setting" "" "" "DUTY_CYCLE" ""
}
if {[project get_assignment_value "uart_if" "" "" "|wrn_i_1" "GLOBAL_SIGNAL"] !=  ""} {
  project remove_assignment "uart_if" "" "" "|wrn_i_1" "GLOBAL_SIGNAL" ""
}
if {[project get_assignment_value "uart_if" "" "" "|wrn" "USE_CLOCK_SETTINGS"] != ""} {
  project remove_assignment "uart_if" "" "" "|wrn" "USE_CLOCK_SETTINGS" ""
}
if {[project get_assignment_value "" "|wrn_setting" "" "" "FMAX_REQUIREMENT"] != ""} {
  project remove_assignment "" "|wrn_setting" "" "" "FMAX_REQUIREMENT" ""
}
if {[project get_assignment_value "" "|uart:U1|txmit:u2|U1_u2_clkdiv3_setting" "" "" "DUTY_CYCLE"] != ""} {
  project remove_assignment "" "|uart:U1|txmit:u2|U1_u2_clkdiv3_setting" "" "" "DUTY_CYCLE" ""
}
if {[project get_assignment_value "uart_if" "" "" "|uart:U1|txmit:u2|U1_u2_clkdiv\[3\]" "GLOBAL_SIGNAL"] !=  ""} {
  project remove_assignment "uart_if" "" "" "|uart:U1|txmit:u2|U1_u2_clkdiv\[3\]" "GLOBAL_SIGNAL" ""
}
if {[project get_assignment_value "uart_if" "" "" "|uart:U1|txmit:u2|U1_u2_clkdiv3" "USE_CLOCK_SETTINGS"] != ""} {
  project remove_assignment "uart_if" "" "" "|uart:U1|txmit:u2|U1_u2_clkdiv3" "USE_CLOCK_SETTINGS" ""
}
if {[project get_assignment_value "" "|uart:U1|txmit:u2|U1_u2_clkdiv3_setting" "" "" "FMAX_REQUIREMENT"] != ""} {
  project remove_assignment "" "|uart:U1|txmit:u2|U1_u2_clkdiv3_setting" "" "" "FMAX_REQUIREMENT" ""
}
if {[project get_assignment_value "" "|uart:U1|rcvr:u1|U1_u1_clkdiv3_setting" "" "" "DUTY_CYCLE"] != ""} {
  project remove_assignment "" "|uart:U1|rcvr:u1|U1_u1_clkdiv3_setting" "" "" "DUTY_CYCLE" ""
}
if {[project get_assignment_value "uart_if" "" "" "|uart:U1|rcvr:u1|U1_u1_clkdiv\[3\]" "GLOBAL_SIGNAL"] !=  ""} {
  project remove_assignment "uart_if" "" "" "|uart:U1|rcvr:u1|U1_u1_clkdiv\[3\]" "GLOBAL_SIGNAL" ""
}
if {[project get_assignment_value "uart_if" "" "" "|uart:U1|rcvr:u1|U1_u1_clkdiv3" "USE_CLOCK_SETTINGS"] != ""} {
  project remove_assignment "uart_if" "" "" "|uart:U1|rcvr:u1|U1_u1_clkdiv3" "USE_CLOCK_SETTINGS" ""
}
if {[project get_assignment_value "" "|uart:U1|rcvr:u1|U1_u1_clkdiv3_setting" "" "" "FMAX_REQUIREMENT"] != ""} {
  project remove_assignment "" "|uart:U1|rcvr:u1|U1_u1_clkdiv3_setting" "" "" "FMAX_REQUIREMENT" ""
}
if {[project get_assignment_value "" "clk_setting" "" "" "DUTY_CYCLE"] != ""} {
  project remove_assignment "" "clk_setting" "" "" "DUTY_CYCLE" ""
}
if {[project get_assignment_value "uart_if" "" "" "clk" "GLOBAL_SIGNAL"] !=  ""} {
  project remove_assignment "uart_if" "" "" "clk" "GLOBAL_SIGNAL" ""
}
if {[project get_assignment_value "uart_if" "" "" "clk" "USE_CLOCK_SETTINGS"] != ""} {
  project remove_assignment "uart_if" "" "" "clk" "USE_CLOCK_SETTINGS" ""
}
if {[project get_assignment_value "" "clk_setting" "" "" "FMAX_REQUIREMENT"] != ""} {
  project remove_assignment "" "clk_setting" "" "" "FMAX_REQUIREMENT" ""
}
if {[project get_assignment_value "" "" "" "TAO_FILE" "myresults.tao"] != ""} {
  project remove_assignment "" "" "" "TAO_FILE" "myresults.tao" ""
}
if {[project get_assignment_value "" "" "" "SOURCES_PER_DESTINATION_INCLUDE_COUNT" "1000"] != ""} {
  project remove_assignment "" "" "" "SOURCES_PER_DESTINATION_INCLUDE_COUNT" "1000" ""
}
if {[project get_assignment_value "" "" "" "ROUTER_REGISTER_DUPLICATION" "ON"] != ""} {
  project remove_assignment "" "" "" "ROUTER_REGISTER_DUPLICATION" "ON" ""
}
