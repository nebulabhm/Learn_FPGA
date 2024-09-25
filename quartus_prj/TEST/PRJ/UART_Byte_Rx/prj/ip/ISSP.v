// megafunction wizard: %In-System Sources and Probes%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: altsource_probe 

// ============================================================
// File Name: ISSP.v
// Megafunction Name(s):
// 			altsource_probe
//
// Simulation Library Files(s):
// 			
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 18.0.0 Build 614 04/24/2018 SJ Standard Edition
// ************************************************************


//Copyright (C) 2018  Intel Corporation. All rights reserved.
//Your use of Intel Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Intel Program License 
//Subscription Agreement, the Intel Quartus Prime License Agreement,
//the Intel FPGA IP License Agreement, or other applicable license
//agreement, including, without limitation, that your use is for
//the sole purpose of programming logic devices manufactured by
//Intel and sold by Intel or its authorized distributors.  Please
//refer to the applicable agreement for further details.


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module ISSP (
	probe,
	source);

	input	[7:0]  probe;
	output	  source;

	wire  sub_wire0;
	wire  source = sub_wire0;

	altsource_probe	altsource_probe_component (
				.probe (probe),
				.source (sub_wire0)
				// synopsys translate_off
				,
				.clr (),
				.ena (),
				.ir_in (),
				.ir_out (),
				.jtag_state_cdr (),
				.jtag_state_cir (),
				.jtag_state_e1dr (),
				.jtag_state_sdr (),
				.jtag_state_tlr (),
				.jtag_state_udr (),
				.jtag_state_uir (),
				.raw_tck (),
				.source_clk (),
				.source_ena (),
				.tdi (),
				.tdo (),
				.usr1 ()
				// synopsys translate_on
				);
	defparam
		altsource_probe_component.enable_metastability = "NO",
		altsource_probe_component.instance_id = "NONE",
		altsource_probe_component.probe_width = 8,
		altsource_probe_component.sld_auto_instance_index = "YES",
		altsource_probe_component.sld_instance_index = 0,
		altsource_probe_component.source_initial_value = " 0",
		altsource_probe_component.source_width = 0;


endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: CONSTANT: ENABLE_METASTABILITY STRING "NO"
// Retrieval info: CONSTANT: INSTANCE_ID STRING "NONE"
// Retrieval info: CONSTANT: PROBE_WIDTH NUMERIC "8"
// Retrieval info: CONSTANT: SLD_AUTO_INSTANCE_INDEX STRING "YES"
// Retrieval info: CONSTANT: SLD_INSTANCE_INDEX NUMERIC "0"
// Retrieval info: CONSTANT: SOURCE_INITIAL_VALUE STRING " 0"
// Retrieval info: CONSTANT: SOURCE_WIDTH NUMERIC "0"
// Retrieval info: USED_PORT: probe 0 0 8 0 INPUT NODEFVAL "probe[7..0]"
// Retrieval info: USED_PORT: source 0 0 0 0 OUTPUT NODEFVAL "source"
// Retrieval info: CONNECT: @probe 0 0 8 0 probe 0 0 8 0
// Retrieval info: CONNECT: source 0 0 0 0 @source 0 0 0 0
// Retrieval info: GEN_FILE: TYPE_NORMAL ISSP.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL ISSP.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL ISSP.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL ISSP.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL ISSP_inst.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL ISSP_bb.v TRUE
