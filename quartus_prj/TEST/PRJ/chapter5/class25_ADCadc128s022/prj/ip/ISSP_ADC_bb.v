// megafunction wizard: %In-System Sources and Probes%VBB%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: altsource_probe 

// ============================================================
// File Name: ISSP_ADC.v
// Megafunction Name(s):
// 			altsource_probe
//
// Simulation Library Files(s):
// 			altera_mf
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 13.0.0 Build 156 04/24/2013 SJ Full Version
// ************************************************************

//Copyright (C) 1991-2013 Altera Corporation
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, Altera MegaCore Function License 
//Agreement, or other applicable license agreement, including, 
//without limitation, that your use is for the sole purpose of 
//programming logic devices manufactured by Altera and sold by 
//Altera or its authorized distributors.  Please refer to the 
//applicable agreement for further details.

module ISSP_ADC (
	probe,
	source);

	input	[11:0]  probe;
	output	[2:0]  source;

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV E"
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: CONSTANT: ENABLE_METASTABILITY STRING "NO"
// Retrieval info: CONSTANT: INSTANCE_ID STRING "NONE"
// Retrieval info: CONSTANT: PROBE_WIDTH NUMERIC "12"
// Retrieval info: CONSTANT: SLD_AUTO_INSTANCE_INDEX STRING "YES"
// Retrieval info: CONSTANT: SLD_INSTANCE_INDEX NUMERIC "0"
// Retrieval info: CONSTANT: SOURCE_INITIAL_VALUE STRING " 0"
// Retrieval info: CONSTANT: SOURCE_WIDTH NUMERIC "3"
// Retrieval info: USED_PORT: probe 0 0 12 0 INPUT NODEFVAL "probe[11..0]"
// Retrieval info: USED_PORT: source 0 0 3 0 OUTPUT NODEFVAL "source[2..0]"
// Retrieval info: CONNECT: @probe 0 0 12 0 probe 0 0 12 0
// Retrieval info: CONNECT: source 0 0 3 0 @source 0 0 3 0
// Retrieval info: GEN_FILE: TYPE_NORMAL ISSP_ADC.v TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL ISSP_ADC.inc FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL ISSP_ADC.cmp FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL ISSP_ADC.bsf FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL ISSP_ADC_inst.v FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL ISSP_ADC_bb.v TRUE
// Retrieval info: LIB_FILE: altera_mf
