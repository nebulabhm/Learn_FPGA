// Copyright (C) 1988-2004 Altera Corporation
// Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
// support information,  device programming or simulation file,  and any other
// associated  documentation or information  provided by  Altera  or a partner
// under  Altera's   Megafunction   Partnership   Program  may  be  used  only
// to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any
// other  use  of such  megafunction  design,  netlist,  support  information,
// device programming or simulation file,  or any other  related documentation
// or information  is prohibited  for  any  other purpose,  including, but not
// limited to  modification,  reverse engineering,  de-compiling, or use  with
// any other  silicon devices,  unless such use is  explicitly  licensed under
// a separate agreement with  Altera  or a megafunction partner.  Title to the
// intellectual property,  including patents,  copyrights,  trademarks,  trade
// secrets,  or maskworks,  embodied in any such megafunction design, netlist,
// support  information,  device programming or simulation file,  or any other
// related documentation or information provided by  Altera  or a megafunction
// partner, remains with Altera, the megafunction partner, or their respective
// licensors. No other licenses, including any licenses needed under any third
// party's intellectual property, are provided herein.


// Quartus II 4.0 Build 190 1/28/2004


// ********** PRIMITIVE DEFINITIONS **********

`timescale 1 ps/1 ps

// ***** DFFE

primitive PRIM_DFFE (Q, ENA, D, CLK, CLRN, PRN, notifier);
   input D;   
   input CLRN;
   input PRN;
   input CLK;
   input ENA;
   input notifier;
   output Q; reg Q;

   initial Q = 1'b0;

    table

    //  ENA  D   CLK   CLRN  PRN  notifier  :   Qt  :   Qt+1

        (??) ?    ?      1    1      ?      :   ?   :   -;  // pessimism
         x   ?    ?      1    1      ?      :   ?   :   -;  // pessimism
         1   1   (01)    1    1      ?      :   ?   :   1;  // clocked data
         1   1   (01)    1    x      ?      :   ?   :   1;  // pessimism
 
         1   1    ?      1    x      ?      :   1   :   1;  // pessimism
 
         1   0    0      1    x      ?      :   1   :   1;  // pessimism
         1   0    x      1  (?x)     ?      :   1   :   1;  // pessimism
         1   0    1      1  (?x)     ?      :   1   :   1;  // pessimism
 
         1   x    0      1    x      ?      :   1   :   1;  // pessimism
         1   x    x      1  (?x)     ?      :   1   :   1;  // pessimism
         1   x    1      1  (?x)     ?      :   1   :   1;  // pessimism
 
         1   0   (01)    1    1      ?      :   ?   :   0;  // clocked data

         1   0   (01)    x    1      ?      :   ?   :   0;  // pessimism

         1   0    ?      x    1      ?      :   0   :   0;  // pessimism
         0   ?    ?      x    1      ?      :   ?   :   -;

         1   1    0      x    1      ?      :   0   :   0;  // pessimism
         1   1    x    (?x)   1      ?      :   0   :   0;  // pessimism
         1   1    1    (?x)   1      ?      :   0   :   0;  // pessimism

         1   x    0      x    1      ?      :   0   :   0;  // pessimism
         1   x    x    (?x)   1      ?      :   0   :   0;  // pessimism
         1   x    1    (?x)   1      ?      :   0   :   0;  // pessimism

//       1   1   (x1)    1    1      ?      :   1   :   1;  // reducing pessimism
//       1   0   (x1)    1    1      ?      :   0   :   0;
         1   ?   (x1)    1    1      ?      :   ?   :   -;  // spr 80166-ignore
                                                            // x->1 edge
         1   1   (0x)    1    1      ?      :   1   :   1;
         1   0   (0x)    1    1      ?      :   0   :   0;

         ?   ?   ?       0    1      ?      :   ?   :   0;  // asynch clear

         ?   ?   ?       1    0      ?      :   ?   :   1;  // asynch set

         1   ?   (?0)    1    1      ?      :   ?   :   -;  // ignore falling clock
         1   ?   (1x)    1    1      ?      :   ?   :   -;  // ignore falling clock
         1   *    ?      ?    ?      ?      :   ?   :   -; // ignore data edges

         1   ?   ?     (?1)   ?      ?      :   ?   :   -;  // ignore edges on
         1   ?   ?       ?  (?1)     ?      :   ?   :   -;  //  set and clear

         0   ?   ?       1    1      ?      :   ?   :   -;  //  set and clear

	 ?   ?   ?       1    1      *      :   ?   :   x; // spr 36954 - at any
							   // notifier event,
							   // output 'x'
    endtable

endprimitive

module dffe ( Q, CLK, ENA, D, CLRN, PRN );
   input D;
   input CLK;
   input CLRN;
   input PRN;
   input ENA;
   output Q;
   
   buf (D_ipd, D);
   buf (ENA_ipd, ENA);
   buf (CLK_ipd, CLK);
   buf (PRN_ipd, PRN);
   buf (CLRN_ipd, CLRN);
   
   wire   legal;
   reg 	  viol_notifier;
   
   PRIM_DFFE ( Q, ENA_ipd, D_ipd, CLK_ipd, CLRN_ipd, PRN_ipd, viol_notifier );
   
   and(legal, ENA_ipd, CLRN_ipd, PRN_ipd);
   specify
      
      specparam TREG = 0;
      specparam TREN = 0;
      specparam TRSU = 0;
      specparam TRH  = 0;
      specparam TRPR = 0;
      specparam TRCL = 0;
      
      $setup  (  D, posedge CLK &&& legal, TRSU, viol_notifier  ) ;
      $hold   (  posedge CLK &&& legal, D, TRH, viol_notifier   ) ;
      $setup  (  ENA, posedge CLK &&& legal, TREN, viol_notifier  ) ;
      $hold   (  posedge CLK &&& legal, ENA, 0, viol_notifier   ) ;
 
      ( negedge CLRN => (Q  +: 1'b0)) = ( TRCL, TRCL) ;
      ( negedge PRN  => (Q  +: 1'b1)) = ( TRPR, TRPR) ;
      ( posedge CLK  => (Q  +: D)) = ( TREG, TREG) ;
      
   endspecify
endmodule     

// ***** LATCH

module latch(D, ENA, PRE, CLR, Q);
   
   input D;
   input ENA, PRE, CLR;
   output Q;
   
   reg 	  q_out;
   
   specify
      $setup (D, posedge ENA, 0) ;
      $hold (negedge ENA, D, 0) ;
      
      (D => Q) = (0, 0);
      (posedge ENA => (Q +: q_out)) = (0, 0);
      (negedge PRE => (Q +: q_out)) = (0, 0);
      (negedge CLR => (Q +: q_out)) = (0, 0);
   endspecify
   
   buf (D_in, D);
   buf (ENA_in, ENA);
   buf (PRE_in, PRE);
   buf (CLR_in, CLR);
   
   initial
      begin
	 q_out = 1'b0;
      end
   
   always @(D_in or ENA_in or PRE_in or CLR_in)
      begin
	 if (PRE_in == 1'b0)
	    begin
	       // latch being preset, preset is active low
	       q_out = 1'b1;
	    end
	 else if (CLR_in == 1'b0)
	    begin
	       // latch being cleared, clear is active low
	       q_out = 1'b0;
	    end
	      else if (ENA_in == 1'b1)
		 begin
		    // latch is transparent
		    q_out = D_in;
		 end
      end
   
   and (Q, q_out, 1'b1);
   
endmodule

// ***** MUX21

module mux21 (MO, A, B, S);
   input A, B, S;
   output MO;
   
   buf(A_in, A);
   buf(B_in, B);
   buf(S_in, S);

   wire   tmp_MO;
   
   specify
      (A => MO) = (0, 0);
      (B => MO) = (0, 0);
      (S => MO) = (0, 0);
   endspecify

   assign tmp_MO = (S_in == 1) ? B_in : A_in;
   
   buf (MO, tmp_MO);
endmodule

// ***** MUX41

module mux41 (MO, IN0, IN1, IN2, IN3, S);
   input IN0;
   input IN1;
   input IN2;
   input IN3;
   input [1:0] S;
   output MO;
   
   buf(IN0_in, IN0);
   buf(IN1_in, IN1);
   buf(IN2_in, IN2);
   buf(IN3_in, IN3);
   buf(S1_in, S[1]);
   buf(S0_in, S[0]);

   wire   tmp_MO;
   
   specify
      (IN0 => MO) = (0, 0);
      (IN1 => MO) = (0, 0);
      (IN2 => MO) = (0, 0);
      (IN3 => MO) = (0, 0);
      (S[1] => MO) = (0, 0);
      (S[0] => MO) = (0, 0);
   endspecify

   assign tmp_MO = S1_in ? (S0_in ? IN3_in : IN2_in) : (S0_in ? IN1_in : IN0_in);

   buf (MO, tmp_MO);

endmodule

// ***** AND1

module and1 (Y, IN1);
   input IN1;
   output Y;
   
   specify
      (IN1 => Y) = (0, 0);
   endspecify
   
   buf (Y, IN1);
endmodule

// ***** AND16

module and16 (Y, IN1);
   input [15:0] IN1;
   output [15:0] Y;
   
   specify
      (IN1 => Y) = (0, 0);
   endspecify
   
   buf (Y[0], IN1[0]);
   buf (Y[1], IN1[1]);
   buf (Y[2], IN1[2]);
   buf (Y[3], IN1[3]);
   buf (Y[4], IN1[4]);
   buf (Y[5], IN1[5]);
   buf (Y[6], IN1[6]);
   buf (Y[7], IN1[7]);
   buf (Y[8], IN1[8]);
   buf (Y[9], IN1[9]);
   buf (Y[10], IN1[10]);
   buf (Y[11], IN1[11]);
   buf (Y[12], IN1[12]);
   buf (Y[13], IN1[13]);
   buf (Y[14], IN1[14]);
   buf (Y[15], IN1[15]);
   
endmodule

// ***** BMUX21

module bmux21 (MO, A, B, S);
   input [15:0] A, B;
   input 	S;
   output [15:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** B17MUX21

module b17mux21 (MO, A, B, S);
   input [16:0] A, B;
   input 	S;
   output [16:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ***** NMUX21

module nmux21 (MO, A, B, S);
   input A, B, S; 
   output MO; 
   
   assign MO = (S == 1) ? ~B : ~A; 
   
endmodule

// ***** B5MUX21

module b5mux21 (MO, A, B, S);
   input [4:0] A, B;
   input       S;
   output [4:0] MO; 
   
   assign MO = (S == 1) ? B : A; 
   
endmodule

// ********** END PRIMITIVE DEFINITIONS **********


///////////////////////////////////////////////////////////////////////////////
//
//              	CYCLONE LCELL ATOM 
//  
//  Supports lut_mask, does not support equations. Support normal, arithmetic, 
//  updown counter and iclrable counter mode.  Parameter output_mode is 
//  informational only and has no simulation function.  No checking is done 
//  for validation of parameters passed from top level.  Input default values 
//  are implemented using tri1 and tri0 net. 
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module cyclone_asynch_lcell (
                             dataa, 
                             datab, 
                             datac, 
                             datad,
                             cin,
                             cin0,
                             cin1,
                             inverta,
                             qfbkin,
                             regin,
                             combout,
                             cout,
                             cout0,
                             cout1
                            );
   
input dataa;
input datab;
input datac;
input datad ;
input cin;
input cin0;
input cin1;
input inverta;
input qfbkin;

output combout;
output cout;
output cout0;
output cout1;
output regin;

parameter operation_mode = "normal" ;
parameter sum_lutc_input = "datac";
parameter lut_mask = "ffff" ;
parameter cin_used = "false";
parameter cin0_used = "false";
parameter cin1_used = "false";
   
reg icout;
reg icout0;
reg icout1;
reg data;
reg lut_data;
reg inverta_dataa;
reg [15:0] bin_mask;

reg iop_mode;
reg [1:0] isum_lutc_input;
reg icin_used;
reg icin0_used;
reg icin1_used;
   
wire qfbk_mode;

buf (idataa, dataa);
buf (idatab, datab);
buf (idatac, datac);
buf (idatad, datad);
buf (icin, cin);
buf (icin0, cin0);
buf (icin1, cin1);
buf (iinverta, inverta);
   
assign qfbk_mode = (sum_lutc_input == "qfbk") ? 1'b1 : 1'b0;

    specify
      
        (dataa => combout) = (0, 0) ;
        (datab => combout) = (0, 0) ;
        (datac => combout) = (0, 0) ;
        (datad => combout) = (0, 0) ;
        (cin => combout) = (0, 0) ;
        (cin0 => combout) = (0, 0) ;
        (cin1 => combout) = (0, 0) ;
        (inverta => combout) = (0, 0) ;
        if (qfbk_mode == 1'b1)
            (qfbkin => combout) = (0, 0) ;
              
        (dataa => cout) = (0, 0);
        (datab => cout) = (0, 0);
        (cin => cout) = (0, 0) ;
        (cin0 => cout) = (0, 0) ;
        (cin1 => cout) = (0, 0) ;
        (inverta => cout) = (0, 0);
              
        (dataa => cout0) = (0, 0);
        (datab => cout0) = (0, 0);
        (cin0 => cout0) = (0, 0) ;
        (inverta => cout0) = (0, 0);
              
        (dataa => cout1) = (0, 0);
        (datab => cout1) = (0, 0);
        (cin1 => cout1) = (0, 0) ;
        (inverta => cout1) = (0, 0);
              
        (dataa => regin) = (0, 0) ;
        (datab => regin) = (0, 0) ;
        (datac => regin) = (0, 0) ;
        (datad => regin) = (0, 0) ;
        (cin => regin) = (0, 0) ;
        (cin0 => regin) = (0, 0) ;
        (cin1 => regin) = (0, 0) ;
        (inverta => regin) = (0, 0) ;
        if (qfbk_mode == 1'b1)
            (qfbkin => regin) = (0, 0) ;
    endspecify
   
    function [16:1] str_to_bin ;
        input [8*4:1] s;
        reg [8*4:1]   reg_s;
        reg [4:1]     digit [8:1];
        reg [8:1]     tmp;
        integer 	    m , ivalue ;
        begin
            ivalue = 0;
            reg_s = s;
            for (m=1; m<=4; m= m+1 )
            begin
                tmp = reg_s[32:25];
                digit[m] = tmp & 8'b00001111;
                reg_s = reg_s << 8;
                if (tmp[7] == 'b1)
                    digit[m] = digit[m] + 9;
            end
            str_to_bin = {digit[1], digit[2], digit[3], digit[4]};
        end   
    endfunction
   
    function lut4 ;
        input [15:0] mask ;
        input dataa, datab, datac, datad ;
        reg prev_lut4;
        reg dataa_new;
        reg datab_new;
        reg datac_new;
        reg datad_new;
        integer h;
        integer i;
        integer j;
        integer k;
        integer hn;
        integer in;
        integer jn;
        integer kn;
        integer exitloop;
        integer check_prev;
           
        begin
            lut4 = mask[{datad, datac, datab, dataa}];
            if (lut4 === 1'bx)
            begin
                if ((datad === 1'bx) || (datad === 1'bz))
                begin
                    datad_new = 1'b0;
                    hn = 2;
                end
                else
                begin
                    datad_new = datad;
                    hn = 1;
                end
                check_prev = 0;
                exitloop = 0;
                h = 1;
                while ((h <= hn) && (exitloop == 0))
                begin
                    if ((datac === 1'bx) || (datac === 1'bz))
                    begin
                        datac_new = 1'b0;
                        in = 2;
                    end
                    else
                    begin
                        datac_new = datac;
                        in = 1;
                    end
                    i = 1;
                    while ((i <= in) && (exitloop ==0))
                    begin
                        if ((datab === 1'bx) || (datab === 1'bz))
                        begin
                            datab_new = 1'b0;
                            jn = 2;
                        end
                        else
                        begin
                            datab_new = datab;
                            jn = 1;
                        end
                        j = 1;
                        while ((j <= jn) && (exitloop ==0))
                        begin
                            if ((dataa === 1'bx) || (dataa === 1'bz))
                            begin
                                dataa_new = 1'b0;
                                kn = 2;
                            end
                            else
                            begin
                                dataa_new = dataa;
                                kn = 1;
                            end
                            k = 1;
                            while ((k <= kn) && (exitloop ==0))
                            begin
                                lut4 = mask[{datad_new, datac_new, datab_new, dataa_new}];
                                if ((check_prev == 1) && (prev_lut4 !==lut4))
                                begin
                                    lut4 = 1'bx;
                                    exitloop = 1;
                                end
                                else
                                begin
                                    check_prev = 1;
                                    prev_lut4 = lut4;
                                end
                                k = k + 1;
                                dataa_new = 1'b1;
                            end // loop a
                            j = j + 1;
                            datab_new = 1'b1;
                        end // loop b
                        i = i + 1;
                        datac_new = 1'b1;
                    end // loop c
                    h = h + 1;
                    datad_new = 1'b1;
                end // loop d
            end
        end
    endfunction

    initial
    begin
        bin_mask = str_to_bin(lut_mask);

        if (operation_mode == "normal") 
            iop_mode = 0;	// normal mode
        else if (operation_mode == "arithmetic") 
            iop_mode = 1;	// arithmetic mode
        else
        begin
            $display ("Error: Invalid operation_mode specified\n");
            iop_mode = 2;
        end

	     if (sum_lutc_input == "datac") 
            isum_lutc_input = 0;
	     else if (sum_lutc_input == "cin") 
            isum_lutc_input = 1;
	     else if (sum_lutc_input == "qfbk") 
            isum_lutc_input = 2;
        else
        begin
            $display ("Error: Invalid sum_lutc_input specified\n");
            isum_lutc_input = 3;
        end
        
	     if (cin_used == "true") 
            icin_used = 1;
	     else if (cin_used == "false") 
            icin_used = 0;
        
	     if (cin0_used == "true") 
            icin0_used = 1;
	     else if (cin0_used == "false") 
            icin0_used = 0;
        
	     if (cin1_used == "true") 
            icin1_used = 1;
	     else if (cin1_used == "false") 
            icin1_used = 0;

    end

    always @(idatad or idatac or idatab or idataa or icin or 
             icin0 or icin1 or iinverta or qfbkin)
    begin
	
        if (iinverta === 'b1) //invert dataa
            inverta_dataa = !idataa;
        else
            inverta_dataa = idataa;
    	
        if (iop_mode == 0) // normal mode
        begin
            if (isum_lutc_input == 0) // datac 
            begin
                data = lut4(bin_mask, inverta_dataa, idatab, 
                            idatac, idatad);
            end
            else if (isum_lutc_input == 1) // cin
            begin
                if (icin0_used == 1 || icin1_used == 1)
                begin
                    if (icin_used == 1)
                        data = (icin === 'b0) ? 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin0, 
                                idatad) : 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin1, 
                                idatad);
                    else   // if cin is not used then inverta 
                           // should be used in place of cin
                        data = (iinverta === 'b0) ? 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin0, 
                                idatad) : 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin1, 
                                idatad);
                    end
                else
                    data = lut4(bin_mask, inverta_dataa, idatab, 
                                icin, idatad);
            end
            else if(isum_lutc_input == 2) // qfbk
            begin
                data = lut4(bin_mask, inverta_dataa, idatab, 
                            qfbkin, idatad);
            end
        end
        else if (iop_mode == 1) // arithmetic mode
        begin
            // sum LUT
            if (isum_lutc_input == 0) // datac 
            begin
                data = lut4(bin_mask, inverta_dataa, idatab, 
                            idatac, 'b1);
            end
            else if (isum_lutc_input == 1) // cin
            begin
                if (icin0_used == 1 || icin1_used == 1)
                begin
                    if (icin_used == 1)
                        data = (icin === 'b0) ? 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin0, 
                                'b1) : 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin1, 
                                'b1);
                    else   // if cin is not used then inverta 
                           // should be used in place of cin
                        data = (iinverta === 'b0) ? 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin0, 
                                'b1) : 
                                lut4(bin_mask, 
                                inverta_dataa, 
                                idatab, 
                                icin1, 
                                'b1);
                end
                else if (icin_used == 1)
                    data = lut4(bin_mask, inverta_dataa, idatab, 
                                icin, 'b1);
                else  // cin is not used, inverta is used as cin
                    data = lut4(bin_mask, inverta_dataa, idatab, 
                                iinverta, 'b1);
            end
            else if(isum_lutc_input == 2) // qfbk
            begin
                data = lut4(bin_mask, inverta_dataa, idatab, 
                            qfbkin, 'b1);
            end
            	 
            // carry LUT
            icout0 = lut4(bin_mask, inverta_dataa, idatab, icin0, 'b0);
            icout1 = lut4(bin_mask, inverta_dataa, idatab, icin1, 'b0);
            	 
            if (icin_used == 1)
            begin
                if (icin0_used == 1 || icin1_used == 1)
                icout = (icin === 'b0) ? icout0 : icout1;
                else
                icout = lut4(bin_mask, inverta_dataa, idatab, 
                             icin, 'b0);
            end
            else  // inverta is used in place of cin
            begin
                if (icin0_used == 1 || icin1_used == 1)
                    icout = (iinverta === 'b0) ? icout0 : icout1; 
                else
                    icout = lut4(bin_mask, inverta_dataa, idatab, 
                                 iinverta, 'b0);
            end
        end
    end

    and (combout, data, 1'b1) ;
    and (cout, icout, 1'b1) ;
    and (cout0, icout0, 1'b1) ;
    and (cout1, icout1, 1'b1) ;
    and (regin, data, 1'b1) ;
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                              CYCLONE_LCELL_REGISTER
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
  
module cyclone_lcell_register (
                               clk, 
                               aclr, 
                               aload, 
                               sclr, 
                               sload, 
                               ena, 
                               datain,
                               datac, 
                               regcascin, 
                               devclrn, 
                               devpor, 
                               regout, 
                               qfbkout
                              );
input clk;
input ena;
input aclr;
input aload;
input sclr;
input sload;
input datain;
input datac;
input regcascin;
input devclrn;
input devpor ;

output regout;
output qfbkout;

parameter synch_mode = "off";
parameter register_cascade_mode = "off";
parameter power_up = "low";
parameter x_on_violation = "on";
   
reg iregout;
wire reset;
wire nosload;
   
reg regcascin_viol;
reg datain_viol, datac_viol;
reg sclr_viol, sload_viol;
reg ena_viol, clk_per_viol;
reg violation;
reg clk_last_value;
   
reg ipower_up;
reg icascade_mode;
reg isynch_mode;
reg ix_on_violation;

buf (clk_in, clk);
buf (iaclr, aclr);
buf (iaload, aload);
buf (isclr, sclr);
buf (isload, sload);
buf (iena, ena);
   
buf (idatac, datac);
buf (iregcascin, regcascin);
buf (idatain, datain);
   
    assign reset = devpor && devclrn && (!iaclr) && (iena);
    assign nosload = reset && (!sload);
   
    specify
        $setuphold (posedge clk &&& reset, regcascin, 0, 0, regcascin_viol) ;
        $setuphold (posedge clk &&& nosload, datain, 0, 0, datain_viol) ;
        $setuphold (posedge clk &&& reset, datac, 0, 0, datac_viol) ;
        $setuphold (posedge clk &&& reset, sclr, 0, 0, sclr_viol) ;
        $setuphold (posedge clk &&& reset, sload, 0, 0, sload_viol) ;
        $setuphold (posedge clk &&& reset, ena, 0, 0, ena_viol) ;
        
        (posedge clk => (regout +: iregout)) = 0 ;
        (posedge aclr => (regout +: 1'b0)) = (0, 0) ;
        (posedge aload => (regout +: iregout)) = (0, 0) ;
        (datac => regout) = (0, 0) ;
        (posedge clk => (qfbkout +: iregout)) = 0 ;
        (posedge aclr => (qfbkout +: 1'b0)) = (0, 0) ;
        (posedge aload => (qfbkout +: iregout)) = (0, 0) ;
        (datac => qfbkout) = (0, 0) ;
    
    endspecify
   
    initial
    begin
        violation = 0;
        clk_last_value = 'b0;
        if (power_up == "low")
        begin
            iregout <= 'b0;
            ipower_up = 0;
        end
        else if (power_up == "high")
        begin
            iregout <= 'b1;
            ipower_up = 1;
        end

        if (register_cascade_mode == "on")
            icascade_mode = 1;
        else
            icascade_mode = 0;

        if (synch_mode == "on" )
            isynch_mode = 1;
        else
            isynch_mode = 0;

        if (x_on_violation == "on")
            ix_on_violation = 1;
        else
            ix_on_violation = 0;
    end
   
    always @ (regcascin_viol or datain_viol or datac_viol or sclr_viol 
              or sload_viol or ena_viol or clk_per_viol)
    begin
        if (ix_on_violation == 1)
        violation = 1;
    end
   
    always @ (clk_in or idatac or iaclr or posedge iaload 
              or negedge devclrn or negedge devpor or posedge violation)
    begin
        if (violation == 1'b1)
        begin
            violation = 0;
            iregout <= 'bx;
        end
        else
        begin
            if (devpor == 'b0)
            begin
                if (ipower_up == 0) // "low"
                    iregout <= 'b0;
                else if (ipower_up == 1) // "high"
                    iregout <= 'b1;
            end
            else if (devclrn == 'b0)
                iregout <= 'b0;
            else if (iaclr === 'b1) 
                iregout <= 'b0 ;
            else if (iaload === 'b1) 
                iregout <= idatac;
            else if (iena === 'b1 && clk_in === 'b1 && 
                     clk_last_value === 'b0)
            begin
                if (isynch_mode == 1)
                begin
                    if (isclr === 'b1)
                        iregout <= 'b0 ;
                    else if (isload === 'b1)
                        iregout <= idatac;
                    else if (icascade_mode == 1)
                        iregout <= iregcascin;
                    else
                        iregout <= idatain;
                end
                else if (icascade_mode == 1)
                    iregout <= iregcascin;
                else 
                    iregout <= idatain;
            end
        end
        clk_last_value = clk_in;
    end
       
    and (regout, iregout, 1'b1);
    and (qfbkout, iregout, 1'b1);
   
endmodule

///////////////////////////////////////////////////////////////////////////////
//
//                                CYCLONE_LCELL
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module cyclone_lcell (
                      clk, 
                      dataa, 
                      datab, 
                      datac, 
                      datad, 
                      aclr, 
                      aload, 
                      sclr,
                      sload,
                      ena,
                      cin,
                      cin0,
                      cin1,
                      inverta,
                      regcascin,
                      devclrn,
                      devpor,
                      combout,
                      regout,
                      cout, 
                      cout0,
                      cout1
                     );

input dataa;
input datab;
input datac;
input datad;
input clk; 
input aclr; 
input aload; 
input sclr; 
input sload; 
input ena; 
input cin;
input cin0;
input cin1;
input inverta;
input regcascin;
input devclrn;
input devpor ;

output combout;
output regout;
output cout;
output cout0;
output cout1;

parameter operation_mode = "normal" ;
parameter synch_mode = "off";
parameter register_cascade_mode = "off";
parameter sum_lutc_input = "datac";
parameter lut_mask = "ffff" ;
parameter power_up = "low";
parameter cin_used = "false";
parameter cin0_used = "false";
parameter cin1_used = "false";
parameter output_mode = "comb_only";
parameter lpm_type = "cyclone_lcell";
parameter x_on_violation = "on";
   
wire dffin, qfbkin;
   
cyclone_asynch_lcell lecomb (
                             .dataa(dataa),
                             .datab(datab), 
                             .datac(datac),
                             .datad(datad),
                             .cin(cin),
                             .cin0(cin0),
                             .cin1(cin1), 
                             .inverta(inverta),
                             .qfbkin(qfbkin),
                             .regin(dffin),
                             .combout(combout),
                             .cout(cout),
                             .cout0(cout0),
                             .cout1(cout1)
                            );
    defparam lecomb.operation_mode = operation_mode;
    defparam lecomb.sum_lutc_input = sum_lutc_input;
    defparam lecomb.cin_used = cin_used;
    defparam lecomb.cin0_used = cin0_used;
    defparam lecomb.cin1_used = cin1_used;
    defparam lecomb.lut_mask = lut_mask;
   
cyclone_lcell_register lereg (
                              .clk(clk),
                              .aclr(aclr),
                              .aload(aload),
                              .sclr(sclr),
                              .sload(sload),
                              .ena(ena), 
                              .datain(dffin), 
                              .datac(datac),
                              .regcascin(regcascin),
                              .devclrn(devclrn),
                              .devpor(devpor), 
                              .regout(regout),
                              .qfbkout(qfbkin)
                             );
    defparam lereg.synch_mode = synch_mode;
    defparam lereg.register_cascade_mode = register_cascade_mode;
    defparam lereg.power_up = power_up;
    defparam lereg.x_on_violation = x_on_violation;
   
endmodule



///////////////////////////////////////////////////////////////////////////////
//
//                            CYCLONE_RAM_REGISTER
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
  module cyclone_ram_register 
    (
     data, 
     clk, 
     aclr, 
     ena, 
     ifclk, 
     ifaclr, 
     ifena, 
     devclrn, 
     devpor, 
     powerup,
     dataout, 
     aclrout,
     clkout,
     done
     );
   
   parameter data_width = 144;
   parameter sclr = "true";
   parameter preset = "false";
   
   input [143:0] data;
   input 	 clk;
   input 	 aclr;
   input 	 ena;
   input 	 ifclk;
   input 	 ifaclr;
   input 	 ifena;
   input 	 devclrn;
   input 	 devpor;
   input 	 powerup;
   
   output [143:0] dataout;
   output 	  aclrout;
   output 	  clkout;
   output 	  done;
   
   wire [143:0]   data_ipd;
   wire 	  clk_ipd;
   wire 	  aclr_ipd;
   wire 	  ena_ipd;
   wire [143:0]   dataout_tmp;
   wire [143:0]   dataout_tbuf;
   wire 	  done_tbuf; 
   reg            aclrout_reg; 		  
   reg 		  done_reg;
   reg 		  clk_dly;
   reg 		  done_delta;
   reg [143:0] 	  dataout_reg;
   reg [143:0] 	  dataout_sreg;
   reg 		  viol_notifier; 
   
   tri1 	  ena;
   
   buf data_buf0 (data_ipd[0], data[0]);
   buf data_buf1 (data_ipd[1], data[1]);
   buf data_buf2 (data_ipd[2], data[2]);
   buf data_buf3 (data_ipd[3], data[3]);
   buf data_buf4 (data_ipd[4], data[4]);
   buf data_buf5 (data_ipd[5], data[5]);
   buf data_buf6 (data_ipd[6], data[6]);
   buf data_buf7 (data_ipd[7], data[7]);
   buf data_buf8 (data_ipd[8], data[8]);
   buf data_buf9 (data_ipd[9], data[9]);
   buf data_buf10 (data_ipd[10], data[10]);
   buf data_buf11 (data_ipd[11], data[11]);
   buf data_buf12 (data_ipd[12], data[12]);
   buf data_buf13 (data_ipd[13], data[13]);
   buf data_buf14 (data_ipd[14], data[14]);
   buf data_buf15 (data_ipd[15], data[15]);
   buf data_buf16 (data_ipd[16], data[16]);
   buf data_buf17 (data_ipd[17], data[17]);
   buf data_buf18 (data_ipd[18], data[18]);
   buf data_buf19 (data_ipd[19], data[19]);
   buf data_buf20 (data_ipd[20], data[20]);
   buf data_buf21 (data_ipd[21], data[21]);
   buf data_buf22 (data_ipd[22], data[22]);
   buf data_buf23 (data_ipd[23], data[23]);
   buf data_buf24 (data_ipd[24], data[24]);
   buf data_buf25 (data_ipd[25], data[25]);
   buf data_buf26 (data_ipd[26], data[26]);
   buf data_buf27 (data_ipd[27], data[27]);
   buf data_buf28 (data_ipd[28], data[28]);
   buf data_buf29 (data_ipd[29], data[29]);
   buf data_buf30 (data_ipd[30], data[30]);
   buf data_buf31 (data_ipd[31], data[31]);
   buf data_buf32 (data_ipd[32], data[32]);
   buf data_buf33 (data_ipd[33], data[33]);
   buf data_buf34 (data_ipd[34], data[34]);
   buf data_buf35 (data_ipd[35], data[35]);
   buf data_buf36 (data_ipd[36], data[36]);
   buf data_buf37 (data_ipd[37], data[37]);
   buf data_buf38 (data_ipd[38], data[38]);
   buf data_buf39 (data_ipd[39], data[39]);
   buf data_buf40 (data_ipd[40], data[40]);
   buf data_buf41 (data_ipd[41], data[41]);
   buf data_buf42 (data_ipd[42], data[42]);
   buf data_buf43 (data_ipd[43], data[43]);
   buf data_buf44 (data_ipd[44], data[44]);
   buf data_buf45 (data_ipd[45], data[45]);
   buf data_buf46 (data_ipd[46], data[46]);
   buf data_buf47 (data_ipd[47], data[47]);
   buf data_buf48 (data_ipd[48], data[48]);
   buf data_buf49 (data_ipd[49], data[49]);
   buf data_buf50 (data_ipd[50], data[50]);
   buf data_buf51 (data_ipd[51], data[51]);
   buf data_buf52 (data_ipd[52], data[52]);
   buf data_buf53 (data_ipd[53], data[53]);
   buf data_buf54 (data_ipd[54], data[54]);
   buf data_buf55 (data_ipd[55], data[55]);
   buf data_buf56 (data_ipd[56], data[56]);
   buf data_buf57 (data_ipd[57], data[57]);
   buf data_buf58 (data_ipd[58], data[58]);
   buf data_buf59 (data_ipd[59], data[59]);
   buf data_buf60 (data_ipd[60], data[60]);
   buf data_buf61 (data_ipd[61], data[61]);
   buf data_buf62 (data_ipd[62], data[62]);
   buf data_buf63 (data_ipd[63], data[63]);
   buf data_buf64 (data_ipd[64], data[64]);
   buf data_buf65 (data_ipd[65], data[65]);
   buf data_buf66 (data_ipd[66], data[66]);
   buf data_buf67 (data_ipd[67], data[67]);
   buf data_buf68 (data_ipd[68], data[68]);
   buf data_buf69 (data_ipd[69], data[69]);
   buf data_buf70 (data_ipd[70], data[70]);
   buf data_buf71 (data_ipd[71], data[71]);
   buf data_buf72 (data_ipd[72], data[72]);
   buf data_buf73 (data_ipd[73], data[73]);
   buf data_buf74 (data_ipd[74], data[74]);
   buf data_buf75 (data_ipd[75], data[75]);
   buf data_buf76 (data_ipd[76], data[76]);
   buf data_buf77 (data_ipd[77], data[77]);
   buf data_buf78 (data_ipd[78], data[78]);
   buf data_buf79 (data_ipd[79], data[79]);
   buf data_buf80 (data_ipd[80], data[80]);
   buf data_buf81 (data_ipd[81], data[81]);
   buf data_buf82 (data_ipd[82], data[82]);
   buf data_buf83 (data_ipd[83], data[83]);
   buf data_buf84 (data_ipd[84], data[84]);
   buf data_buf85 (data_ipd[85], data[85]);
   buf data_buf86 (data_ipd[86], data[86]);
   buf data_buf87 (data_ipd[87], data[87]);
   buf data_buf88 (data_ipd[88], data[88]);
   buf data_buf89 (data_ipd[89], data[89]);
   buf data_buf90 (data_ipd[90], data[90]);
   buf data_buf91 (data_ipd[91], data[91]);
   buf data_buf92 (data_ipd[92], data[92]);
   buf data_buf93 (data_ipd[93], data[93]);
   buf data_buf94 (data_ipd[94], data[94]);
   buf data_buf95 (data_ipd[95], data[95]);
   buf data_buf96 (data_ipd[96], data[96]);
   buf data_buf97 (data_ipd[97], data[97]);
   buf data_buf98 (data_ipd[98], data[98]);
   buf data_buf99 (data_ipd[99], data[99]);
   buf data_buf100 (data_ipd[100], data[100]);
   buf data_buf101 (data_ipd[101], data[101]);
   buf data_buf102 (data_ipd[102], data[102]);
   buf data_buf103 (data_ipd[103], data[103]);
   buf data_buf104 (data_ipd[104], data[104]);
   buf data_buf105 (data_ipd[105], data[105]);
   buf data_buf106 (data_ipd[106], data[106]);
   buf data_buf107 (data_ipd[107], data[107]);
   buf data_buf108 (data_ipd[108], data[108]);
   buf data_buf109 (data_ipd[109], data[109]);
   buf data_buf110 (data_ipd[110], data[110]);
   buf data_buf111 (data_ipd[111], data[111]);
   buf data_buf112 (data_ipd[112], data[112]);
   buf data_buf113 (data_ipd[113], data[113]);
   buf data_buf114 (data_ipd[114], data[114]);
   buf data_buf115 (data_ipd[115], data[115]);
   buf data_buf116 (data_ipd[116], data[116]);
   buf data_buf117 (data_ipd[117], data[117]);
   buf data_buf118 (data_ipd[118], data[118]);
   buf data_buf119 (data_ipd[119], data[119]);
   buf data_buf120 (data_ipd[120], data[120]);
   buf data_buf121 (data_ipd[121], data[121]);
   buf data_buf122 (data_ipd[122], data[122]);
   buf data_buf123 (data_ipd[123], data[123]);
   buf data_buf124 (data_ipd[124], data[124]);
   buf data_buf125 (data_ipd[125], data[125]);
   buf data_buf126 (data_ipd[126], data[126]);
   buf data_buf127 (data_ipd[127], data[127]);
   buf data_buf128 (data_ipd[128], data[128]);
   buf data_buf129 (data_ipd[129], data[129]);
   buf data_buf130 (data_ipd[130], data[130]);
   buf data_buf131 (data_ipd[131], data[131]);
   buf data_buf132 (data_ipd[132], data[132]);
   buf data_buf133 (data_ipd[133], data[133]);
   buf data_buf134 (data_ipd[134], data[134]);
   buf data_buf135 (data_ipd[135], data[135]);
   buf data_buf136 (data_ipd[136], data[136]);
   buf data_buf137 (data_ipd[137], data[137]);
   buf data_buf138 (data_ipd[138], data[138]);
   buf data_buf139 (data_ipd[139], data[139]);
   buf data_buf140 (data_ipd[140], data[140]);
   buf data_buf141 (data_ipd[141], data[141]);
   buf data_buf142 (data_ipd[142], data[142]);
   buf data_buf143 (data_ipd[143], data[143]);

   buf dataout_buf0 (dataout[0], dataout_tbuf[0]);
   buf dataout_buf1 (dataout[1], dataout_tbuf[1]);
   buf dataout_buf2 (dataout[2], dataout_tbuf[2]);
   buf dataout_buf3 (dataout[3], dataout_tbuf[3]);
   buf dataout_buf4 (dataout[4], dataout_tbuf[4]);
   buf dataout_buf5 (dataout[5], dataout_tbuf[5]);
   buf dataout_buf6 (dataout[6], dataout_tbuf[6]);
   buf dataout_buf7 (dataout[7], dataout_tbuf[7]);
   buf dataout_buf8 (dataout[8], dataout_tbuf[8]);
   buf dataout_buf9 (dataout[9], dataout_tbuf[9]);
   buf dataout_buf10 (dataout[10], dataout_tbuf[10]);
   buf dataout_buf11 (dataout[11], dataout_tbuf[11]);
   buf dataout_buf12 (dataout[12], dataout_tbuf[12]);
   buf dataout_buf13 (dataout[13], dataout_tbuf[13]);
   buf dataout_buf14 (dataout[14], dataout_tbuf[14]);
   buf dataout_buf15 (dataout[15], dataout_tbuf[15]);
   buf dataout_buf16 (dataout[16], dataout_tbuf[16]);
   buf dataout_buf17 (dataout[17], dataout_tbuf[17]);
   buf dataout_buf18 (dataout[18], dataout_tbuf[18]);
   buf dataout_buf19 (dataout[19], dataout_tbuf[19]);
   buf dataout_buf20 (dataout[20], dataout_tbuf[20]);
   buf dataout_buf21 (dataout[21], dataout_tbuf[21]);
   buf dataout_buf22 (dataout[22], dataout_tbuf[22]);
   buf dataout_buf23 (dataout[23], dataout_tbuf[23]);
   buf dataout_buf24 (dataout[24], dataout_tbuf[24]);
   buf dataout_buf25 (dataout[25], dataout_tbuf[25]);
   buf dataout_buf26 (dataout[26], dataout_tbuf[26]);
   buf dataout_buf27 (dataout[27], dataout_tbuf[27]);
   buf dataout_buf28 (dataout[28], dataout_tbuf[28]);
   buf dataout_buf29 (dataout[29], dataout_tbuf[29]);
   buf dataout_buf30 (dataout[30], dataout_tbuf[30]);
   buf dataout_buf31 (dataout[31], dataout_tbuf[31]);
   buf dataout_buf32 (dataout[32], dataout_tbuf[32]);
   buf dataout_buf33 (dataout[33], dataout_tbuf[33]);
   buf dataout_buf34 (dataout[34], dataout_tbuf[34]);
   buf dataout_buf35 (dataout[35], dataout_tbuf[35]);
   buf dataout_buf36 (dataout[36], dataout_tbuf[36]);
   buf dataout_buf37 (dataout[37], dataout_tbuf[37]);
   buf dataout_buf38 (dataout[38], dataout_tbuf[38]);
   buf dataout_buf39 (dataout[39], dataout_tbuf[39]);
   buf dataout_buf40 (dataout[40], dataout_tbuf[40]);
   buf dataout_buf41 (dataout[41], dataout_tbuf[41]);
   buf dataout_buf42 (dataout[42], dataout_tbuf[42]);
   buf dataout_buf43 (dataout[43], dataout_tbuf[43]);
   buf dataout_buf44 (dataout[44], dataout_tbuf[44]);
   buf dataout_buf45 (dataout[45], dataout_tbuf[45]);
   buf dataout_buf46 (dataout[46], dataout_tbuf[46]);
   buf dataout_buf47 (dataout[47], dataout_tbuf[47]);
   buf dataout_buf48 (dataout[48], dataout_tbuf[48]);
   buf dataout_buf49 (dataout[49], dataout_tbuf[49]);
   buf dataout_buf50 (dataout[50], dataout_tbuf[50]);
   buf dataout_buf51 (dataout[51], dataout_tbuf[51]);
   buf dataout_buf52 (dataout[52], dataout_tbuf[52]);
   buf dataout_buf53 (dataout[53], dataout_tbuf[53]);
   buf dataout_buf54 (dataout[54], dataout_tbuf[54]);
   buf dataout_buf55 (dataout[55], dataout_tbuf[55]);
   buf dataout_buf56 (dataout[56], dataout_tbuf[56]);
   buf dataout_buf57 (dataout[57], dataout_tbuf[57]);
   buf dataout_buf58 (dataout[58], dataout_tbuf[58]);
   buf dataout_buf59 (dataout[59], dataout_tbuf[59]);
   buf dataout_buf60 (dataout[60], dataout_tbuf[60]);
   buf dataout_buf61 (dataout[61], dataout_tbuf[61]);
   buf dataout_buf62 (dataout[62], dataout_tbuf[62]);
   buf dataout_buf63 (dataout[63], dataout_tbuf[63]);
   buf dataout_buf64 (dataout[64], dataout_tbuf[64]);
   buf dataout_buf65 (dataout[65], dataout_tbuf[65]);
   buf dataout_buf66 (dataout[66], dataout_tbuf[66]);
   buf dataout_buf67 (dataout[67], dataout_tbuf[67]);
   buf dataout_buf68 (dataout[68], dataout_tbuf[68]);
   buf dataout_buf69 (dataout[69], dataout_tbuf[69]);
   buf dataout_buf70 (dataout[70], dataout_tbuf[70]);
   buf dataout_buf71 (dataout[71], dataout_tbuf[71]);
   buf dataout_buf72 (dataout[72], dataout_tbuf[72]);
   buf dataout_buf73 (dataout[73], dataout_tbuf[73]);
   buf dataout_buf74 (dataout[74], dataout_tbuf[74]);
   buf dataout_buf75 (dataout[75], dataout_tbuf[75]);
   buf dataout_buf76 (dataout[76], dataout_tbuf[76]);
   buf dataout_buf77 (dataout[77], dataout_tbuf[77]);
   buf dataout_buf78 (dataout[78], dataout_tbuf[78]);
   buf dataout_buf79 (dataout[79], dataout_tbuf[79]);
   buf dataout_buf80 (dataout[80], dataout_tbuf[80]);
   buf dataout_buf81 (dataout[81], dataout_tbuf[81]);
   buf dataout_buf82 (dataout[82], dataout_tbuf[82]);
   buf dataout_buf83 (dataout[83], dataout_tbuf[83]);
   buf dataout_buf84 (dataout[84], dataout_tbuf[84]);
   buf dataout_buf85 (dataout[85], dataout_tbuf[85]);
   buf dataout_buf86 (dataout[86], dataout_tbuf[86]);
   buf dataout_buf87 (dataout[87], dataout_tbuf[87]);
   buf dataout_buf88 (dataout[88], dataout_tbuf[88]);
   buf dataout_buf89 (dataout[89], dataout_tbuf[89]);
   buf dataout_buf90 (dataout[90], dataout_tbuf[90]);
   buf dataout_buf91 (dataout[91], dataout_tbuf[91]);
   buf dataout_buf92 (dataout[92], dataout_tbuf[92]);
   buf dataout_buf93 (dataout[93], dataout_tbuf[93]);
   buf dataout_buf94 (dataout[94], dataout_tbuf[94]);
   buf dataout_buf95 (dataout[95], dataout_tbuf[95]);
   buf dataout_buf96 (dataout[96], dataout_tbuf[96]);
   buf dataout_buf97 (dataout[97], dataout_tbuf[97]);
   buf dataout_buf98 (dataout[98], dataout_tbuf[98]);
   buf dataout_buf99 (dataout[99], dataout_tbuf[99]);
   buf dataout_buf100 (dataout[100], dataout_tbuf[100]);
   buf dataout_buf101 (dataout[101], dataout_tbuf[101]);
   buf dataout_buf102 (dataout[102], dataout_tbuf[102]);
   buf dataout_buf103 (dataout[103], dataout_tbuf[103]);
   buf dataout_buf104 (dataout[104], dataout_tbuf[104]);
   buf dataout_buf105 (dataout[105], dataout_tbuf[105]);
   buf dataout_buf106 (dataout[106], dataout_tbuf[106]);
   buf dataout_buf107 (dataout[107], dataout_tbuf[107]);
   buf dataout_buf108 (dataout[108], dataout_tbuf[108]);
   buf dataout_buf109 (dataout[109], dataout_tbuf[109]);
   buf dataout_buf110 (dataout[110], dataout_tbuf[110]);
   buf dataout_buf111 (dataout[111], dataout_tbuf[111]);
   buf dataout_buf112 (dataout[112], dataout_tbuf[112]);
   buf dataout_buf113 (dataout[113], dataout_tbuf[113]);
   buf dataout_buf114 (dataout[114], dataout_tbuf[114]);
   buf dataout_buf115 (dataout[115], dataout_tbuf[115]);
   buf dataout_buf116 (dataout[116], dataout_tbuf[116]);
   buf dataout_buf117 (dataout[117], dataout_tbuf[117]);
   buf dataout_buf118 (dataout[118], dataout_tbuf[118]);
   buf dataout_buf119 (dataout[119], dataout_tbuf[119]);
   buf dataout_buf120 (dataout[120], dataout_tbuf[120]);
   buf dataout_buf121 (dataout[121], dataout_tbuf[121]);
   buf dataout_buf122 (dataout[122], dataout_tbuf[122]);
   buf dataout_buf123 (dataout[123], dataout_tbuf[123]);
   buf dataout_buf124 (dataout[124], dataout_tbuf[124]);
   buf dataout_buf125 (dataout[125], dataout_tbuf[125]);
   buf dataout_buf126 (dataout[126], dataout_tbuf[126]);
   buf dataout_buf127 (dataout[127], dataout_tbuf[127]);
   buf dataout_buf128 (dataout[128], dataout_tbuf[128]);
   buf dataout_buf129 (dataout[129], dataout_tbuf[129]);
   buf dataout_buf130 (dataout[130], dataout_tbuf[130]);
   buf dataout_buf131 (dataout[131], dataout_tbuf[131]);
   buf dataout_buf132 (dataout[132], dataout_tbuf[132]);
   buf dataout_buf133 (dataout[133], dataout_tbuf[133]);
   buf dataout_buf134 (dataout[134], dataout_tbuf[134]);
   buf dataout_buf135 (dataout[135], dataout_tbuf[135]);
   buf dataout_buf136 (dataout[136], dataout_tbuf[136]);
   buf dataout_buf137 (dataout[137], dataout_tbuf[137]);
   buf dataout_buf138 (dataout[138], dataout_tbuf[138]);
   buf dataout_buf139 (dataout[139], dataout_tbuf[139]);
   buf dataout_buf140 (dataout[140], dataout_tbuf[140]);
   buf dataout_buf141 (dataout[141], dataout_tbuf[141]);
   buf dataout_buf142 (dataout[142], dataout_tbuf[142]);
   buf dataout_buf143 (dataout[143], dataout_tbuf[143]);
   buf done_buf (done, done_tbuf);

   buf (clk_ipd, clk);
   buf (aclr_ipd, aclr);
   buf (ena_ipd, ena);
   
   specify
      
      specparam TSU = 0;        // Set up time 
      specparam TH  = 0;        // Hold time
      specparam TCO = 0;        // Clock to Output time
      specparam TCLR = 0;       // Clear time
      specparam TCLR_MIN_PW = 0;// Minimum pulse width of clear
      specparam TPRE = 0; 	// Preset time
      specparam TPRE_MIN_PW = 0;// Minimum pulse width of preset
      specparam TCLK_MIN_PW = 0;// Minimum pulse width of clock
      specparam TCE_MIN_PW = 0; // Minimum pulse width of clock enable
      specparam TCLKL = 0; 	// Minimum clock low time
      specparam TCLKH = 0; 	// Minimum clock high time
      
      $setup  (data, posedge clk, 0, viol_notifier);
      $setup  (aclr, posedge clk, 0, viol_notifier); 
      $setup  (ena, posedge clk, 0, viol_notifier );
      $hold   (posedge clk, data, 0, viol_notifier);
      $hold   (posedge clk, aclr, 0, viol_notifier);
      $hold   (posedge clk, ena, 0, viol_notifier );
      
      (posedge aclr => (dataout  +: 'b0))         = (0,0);
      (posedge clk  => (dataout  +: dataout_tmp)) = (0,0); 
      (posedge clk  => (done     +: done_tbuf))   = (0,0);   
      
   endspecify

   initial 
     begin
	if(powerup == 1'b1)
	  begin
	     dataout_reg = ~(143'b0);
	     dataout_sreg = ~(143'b0);
	  end
	else
	  begin
	     dataout_reg = 'b0;
	     dataout_sreg = 'b0;
	  end
     end

   always @ (aclr_ipd)
     begin
	if(aclr_ipd && ena_ipd)	
	  aclrout_reg <= 1'b1;
	else
	  aclrout_reg <= 1'b0;
     end
   
   assign aclrout = (ifaclr == 1'b1) ? aclrout_reg : 1'b0;
   
   // SYNCHRONOUS RESET - REGISTER CONFIGURATION
   always @ (posedge clk_ipd or negedge devclrn or negedge devpor)
     begin
	if ((ifaclr && aclr_ipd) || ~devclrn || ~devpor)
	  begin
	     if((preset == "true") && (powerup == 1'b1))
		    dataout_sreg <= ~(143'b0);
		  else
		    dataout_sreg <= 'b0;
	       end
	else if (ifclk && clk_ipd && ifena && ena_ipd)	
	  begin
	     dataout_sreg <= data_ipd;
	  end
	else
	  begin
	     dataout_sreg <= dataout_sreg;
	  end
     end 
   
   // ASYNCHRONOUS RESET - REGISTER CONFIGURATION
   always @ (posedge clk_ipd or posedge aclr_ipd or 
	     negedge devclrn or negedge devpor)
      begin
	 if ((ifaclr && aclr_ipd) || ~devclrn || ~devpor)
	  begin
	     if((preset == "true") && (powerup == 1'b1))
		    dataout_reg <= ~(143'b0);
		  else
		    dataout_reg <= 'b0;
	       end
	 else if (ifclk && clk_ipd && ifena && ena_ipd)	 
	   begin
	      dataout_reg <= data_ipd;
	   end
	 else
	   begin
	      dataout_reg <= dataout_reg;
	   end
      end
   
   // DONE REGISTER
   always @ (clk_ipd)
     begin
	if(clk_ipd && ena_ipd)	  
	  done_reg <= 1'b1;
	else
	  done_reg <= 1'b0;
	if(clk_ipd)
	  clk_dly <= 1'b1;
	else
	  clk_dly <= 1'b0;
     end
   
   assign clkout = clk_dly;
   
   // DONE DELTA TICK
   always @ (done_reg)
     begin
	done_delta <= done_reg;
     end
   
   assign dataout_tmp  = (ifclk ? ((sclr == "true") ? 
				    dataout_sreg : dataout_reg) : data_ipd);
   assign dataout_tbuf = dataout_tmp;
   assign done_tbuf    = done_delta;	  
   
endmodule // cyclone_ram_register

///////////////////////////////////////////////////////////////////////////////
//
//                            CYCLONE_RAM_CLEAR
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
  module cyclone_ram_clear 
    (
     aclr, 
     d, 
     clk,
     ena,
     edg,
     q
     );
   
   input d;
   input aclr;
   input clk;
   input ena;
   input edg;
   output q;
   
   reg 	  q_tmp;
   reg 	  valid;
      
   always @ (clk or ena)
     begin
	if(edg == 1'b0)
	  begin
	     if (~clk && d && ena)
	       valid <= 1'b1;
	     else
	       valid <= 1'b0;
	  end
	else
	  begin
	     if (clk && d)
	       valid <= 1'b1;
	     else
	       valid <= 1'b0;
	  end	
     end
   
   always @ (valid or aclr)
     begin
	if(valid && aclr)
	  q_tmp <= 1'b1;
	else
	  q_tmp <= 1'b0;
     end
   
   assign q = q_tmp;
   
endmodule 

///////////////////////////////////////////////////////////////////////////////
//
//                             CYCLONE_RAM_INTERNAL
//
///////////////////////////////////////////////////////////////////////////////

  module cyclone_ram_internal
    (
     portawriteenable, 
     portbwriteenable,
     cleara,
     clearb,
     portadatain, 
     portbdatain,
     portaaddress, 
     portbaddress,
     portabyteenamask, 
     portbbyteenamask,
     portbreadenable,
     portaclock,
     portbclock,
     sameclock,
     portadataout, 
     portbdataout
     );
   
   parameter operation_mode = "single_port";
   parameter ram_block_type = "M512";
   parameter mixed_port_feed_through_mode = "dont_care";
   parameter port_a_data_width = 16;
   parameter port_b_data_width = 16;
   parameter port_a_address_width = 16;
   parameter port_b_address_width = 16;
   parameter port_a_byte_enable_mask_width = 16;
   parameter port_b_byte_enable_mask_width = 16;
   parameter init_file_layout = "none";
   parameter port_a_first_address = 0;
   parameter port_a_last_address = 4096;
   parameter port_b_first_address = 0;
   parameter port_b_last_address = 4096;
   parameter port_a_address_clear = "none";
   parameter port_b_address_clear = "none";
   parameter mem1 = 512'b0;
   parameter mem2 = 512'b0;
   parameter mem3 = 512'b0;
   parameter mem4 = 512'b0;
   parameter mem5 = 512'b0;
   parameter mem6 = 512'b0;
   parameter mem7 = 512'b0;
   parameter mem8 = 512'b0;
   parameter mem9 = 512'b0;
   
   input     portawriteenable;
   input     portbwriteenable;
   input     cleara;
   input     clearb;
   input [143:0] portadatain;
   input [143:0] portbdatain;
   input [15:0]  portaaddress;
   input [15:0]  portbaddress;
   input [15:0]  portabyteenamask;
   input [15:0]  portbbyteenamask;
   input 	 portbreadenable;
   input 	 portaclock;
   input 	 portbclock;
   input 	 sameclock;
   output [143:0] portadataout;
   output [143:0] portbdataout;
   reg [143:0] 	  portadataout_tmp;
   reg [143:0] 	  portbdataout_tmp;
   reg [589823:0] tmp_mem;
   reg [589823:0] mem;
   reg 		  wr_a;
   reg 		  wr_b;
   wire [143:0]   portadataout_tbuf;
   wire [143:0]   portbdataout_tbuf;
   
   integer 	  i,l,j,k;
   integer 	  depth;
   integer 	  index;
   
   specify
      (portawriteenable *> portadataout) = (0,0);
      (portbwriteenable *> portbdataout) = (0,0);
      (portadatain *> portadataout) = (0,0);
      (portbdatain *> portbdataout) = (0,0); 
      (portaaddress *> portadataout) = (0,0);
      (portbaddress *> portbdataout) = (0,0);
      (portabyteenamask *> portadataout) = (0,0);
      (portbbyteenamask *> portbdataout) = (0,0);
      (portbreadenable *> portbdataout) = (0,0);
   endspecify
   
   buf portadataout_buf0 (portadataout[0], portadataout_tbuf[0]);
   buf portadataout_buf1 (portadataout[1], portadataout_tbuf[1]);
   buf portadataout_buf2 (portadataout[2], portadataout_tbuf[2]);
   buf portadataout_buf3 (portadataout[3], portadataout_tbuf[3]);
   buf portadataout_buf4 (portadataout[4], portadataout_tbuf[4]);
   buf portadataout_buf5 (portadataout[5], portadataout_tbuf[5]);
   buf portadataout_buf6 (portadataout[6], portadataout_tbuf[6]);
   buf portadataout_buf7 (portadataout[7], portadataout_tbuf[7]);
   buf portadataout_buf8 (portadataout[8], portadataout_tbuf[8]);
   buf portadataout_buf9 (portadataout[9], portadataout_tbuf[9]);
   buf portadataout_buf10 (portadataout[10], portadataout_tbuf[10]);
   buf portadataout_buf11 (portadataout[11], portadataout_tbuf[11]);
   buf portadataout_buf12 (portadataout[12], portadataout_tbuf[12]);
   buf portadataout_buf13 (portadataout[13], portadataout_tbuf[13]);
   buf portadataout_buf14 (portadataout[14], portadataout_tbuf[14]);
   buf portadataout_buf15 (portadataout[15], portadataout_tbuf[15]);
   buf portadataout_buf16 (portadataout[16], portadataout_tbuf[16]);
   buf portadataout_buf17 (portadataout[17], portadataout_tbuf[17]);
   buf portadataout_buf18 (portadataout[18], portadataout_tbuf[18]);
   buf portadataout_buf19 (portadataout[19], portadataout_tbuf[19]);
   buf portadataout_buf20 (portadataout[20], portadataout_tbuf[20]);
   buf portadataout_buf21 (portadataout[21], portadataout_tbuf[21]);
   buf portadataout_buf22 (portadataout[22], portadataout_tbuf[22]);
   buf portadataout_buf23 (portadataout[23], portadataout_tbuf[23]);
   buf portadataout_buf24 (portadataout[24], portadataout_tbuf[24]);
   buf portadataout_buf25 (portadataout[25], portadataout_tbuf[25]);
   buf portadataout_buf26 (portadataout[26], portadataout_tbuf[26]);
   buf portadataout_buf27 (portadataout[27], portadataout_tbuf[27]);
   buf portadataout_buf28 (portadataout[28], portadataout_tbuf[28]);
   buf portadataout_buf29 (portadataout[29], portadataout_tbuf[29]);
   buf portadataout_buf30 (portadataout[30], portadataout_tbuf[30]);
   buf portadataout_buf31 (portadataout[31], portadataout_tbuf[31]);
   buf portadataout_buf32 (portadataout[32], portadataout_tbuf[32]);
   buf portadataout_buf33 (portadataout[33], portadataout_tbuf[33]);
   buf portadataout_buf34 (portadataout[34], portadataout_tbuf[34]);
   buf portadataout_buf35 (portadataout[35], portadataout_tbuf[35]);
   buf portadataout_buf36 (portadataout[36], portadataout_tbuf[36]);
   buf portadataout_buf37 (portadataout[37], portadataout_tbuf[37]);
   buf portadataout_buf38 (portadataout[38], portadataout_tbuf[38]);
   buf portadataout_buf39 (portadataout[39], portadataout_tbuf[39]);
   buf portadataout_buf40 (portadataout[40], portadataout_tbuf[40]);
   buf portadataout_buf41 (portadataout[41], portadataout_tbuf[41]);
   buf portadataout_buf42 (portadataout[42], portadataout_tbuf[42]);
   buf portadataout_buf43 (portadataout[43], portadataout_tbuf[43]);
   buf portadataout_buf44 (portadataout[44], portadataout_tbuf[44]);
   buf portadataout_buf45 (portadataout[45], portadataout_tbuf[45]);
   buf portadataout_buf46 (portadataout[46], portadataout_tbuf[46]);
   buf portadataout_buf47 (portadataout[47], portadataout_tbuf[47]);
   buf portadataout_buf48 (portadataout[48], portadataout_tbuf[48]);
   buf portadataout_buf49 (portadataout[49], portadataout_tbuf[49]);
   buf portadataout_buf50 (portadataout[50], portadataout_tbuf[50]);
   buf portadataout_buf51 (portadataout[51], portadataout_tbuf[51]);
   buf portadataout_buf52 (portadataout[52], portadataout_tbuf[52]);
   buf portadataout_buf53 (portadataout[53], portadataout_tbuf[53]);
   buf portadataout_buf54 (portadataout[54], portadataout_tbuf[54]);
   buf portadataout_buf55 (portadataout[55], portadataout_tbuf[55]);
   buf portadataout_buf56 (portadataout[56], portadataout_tbuf[56]);
   buf portadataout_buf57 (portadataout[57], portadataout_tbuf[57]);
   buf portadataout_buf58 (portadataout[58], portadataout_tbuf[58]);
   buf portadataout_buf59 (portadataout[59], portadataout_tbuf[59]);
   buf portadataout_buf60 (portadataout[60], portadataout_tbuf[60]);
   buf portadataout_buf61 (portadataout[61], portadataout_tbuf[61]);
   buf portadataout_buf62 (portadataout[62], portadataout_tbuf[62]);
   buf portadataout_buf63 (portadataout[63], portadataout_tbuf[63]);
   buf portadataout_buf64 (portadataout[64], portadataout_tbuf[64]);
   buf portadataout_buf65 (portadataout[65], portadataout_tbuf[65]);
   buf portadataout_buf66 (portadataout[66], portadataout_tbuf[66]);
   buf portadataout_buf67 (portadataout[67], portadataout_tbuf[67]);
   buf portadataout_buf68 (portadataout[68], portadataout_tbuf[68]);
   buf portadataout_buf69 (portadataout[69], portadataout_tbuf[69]);
   buf portadataout_buf70 (portadataout[70], portadataout_tbuf[70]);
   buf portadataout_buf71 (portadataout[71], portadataout_tbuf[71]);
   buf portadataout_buf72 (portadataout[72], portadataout_tbuf[72]);
   buf portadataout_buf73 (portadataout[73], portadataout_tbuf[73]);
   buf portadataout_buf74 (portadataout[74], portadataout_tbuf[74]);
   buf portadataout_buf75 (portadataout[75], portadataout_tbuf[75]);
   buf portadataout_buf76 (portadataout[76], portadataout_tbuf[76]);
   buf portadataout_buf77 (portadataout[77], portadataout_tbuf[77]);
   buf portadataout_buf78 (portadataout[78], portadataout_tbuf[78]);
   buf portadataout_buf79 (portadataout[79], portadataout_tbuf[79]);
   buf portadataout_buf80 (portadataout[80], portadataout_tbuf[80]);
   buf portadataout_buf81 (portadataout[81], portadataout_tbuf[81]);
   buf portadataout_buf82 (portadataout[82], portadataout_tbuf[82]);
   buf portadataout_buf83 (portadataout[83], portadataout_tbuf[83]);
   buf portadataout_buf84 (portadataout[84], portadataout_tbuf[84]);
   buf portadataout_buf85 (portadataout[85], portadataout_tbuf[85]);
   buf portadataout_buf86 (portadataout[86], portadataout_tbuf[86]);
   buf portadataout_buf87 (portadataout[87], portadataout_tbuf[87]);
   buf portadataout_buf88 (portadataout[88], portadataout_tbuf[88]);
   buf portadataout_buf89 (portadataout[89], portadataout_tbuf[89]);
   buf portadataout_buf90 (portadataout[90], portadataout_tbuf[90]);
   buf portadataout_buf91 (portadataout[91], portadataout_tbuf[91]);
   buf portadataout_buf92 (portadataout[92], portadataout_tbuf[92]);
   buf portadataout_buf93 (portadataout[93], portadataout_tbuf[93]);
   buf portadataout_buf94 (portadataout[94], portadataout_tbuf[94]);
   buf portadataout_buf95 (portadataout[95], portadataout_tbuf[95]);
   buf portadataout_buf96 (portadataout[96], portadataout_tbuf[96]);
   buf portadataout_buf97 (portadataout[97], portadataout_tbuf[97]);
   buf portadataout_buf98 (portadataout[98], portadataout_tbuf[98]);
   buf portadataout_buf99 (portadataout[99], portadataout_tbuf[99]);
   buf portadataout_buf100 (portadataout[100], portadataout_tbuf[100]);
   buf portadataout_buf101 (portadataout[101], portadataout_tbuf[101]);
   buf portadataout_buf102 (portadataout[102], portadataout_tbuf[102]);
   buf portadataout_buf103 (portadataout[103], portadataout_tbuf[103]);
   buf portadataout_buf104 (portadataout[104], portadataout_tbuf[104]);
   buf portadataout_buf105 (portadataout[105], portadataout_tbuf[105]);
   buf portadataout_buf106 (portadataout[106], portadataout_tbuf[106]);
   buf portadataout_buf107 (portadataout[107], portadataout_tbuf[107]);
   buf portadataout_buf108 (portadataout[108], portadataout_tbuf[108]);
   buf portadataout_buf109 (portadataout[109], portadataout_tbuf[109]);
   buf portadataout_buf110 (portadataout[110], portadataout_tbuf[110]);
   buf portadataout_buf111 (portadataout[111], portadataout_tbuf[111]);
   buf portadataout_buf112 (portadataout[112], portadataout_tbuf[112]);
   buf portadataout_buf113 (portadataout[113], portadataout_tbuf[113]);
   buf portadataout_buf114 (portadataout[114], portadataout_tbuf[114]);
   buf portadataout_buf115 (portadataout[115], portadataout_tbuf[115]);
   buf portadataout_buf116 (portadataout[116], portadataout_tbuf[116]);
   buf portadataout_buf117 (portadataout[117], portadataout_tbuf[117]);
   buf portadataout_buf118 (portadataout[118], portadataout_tbuf[118]);
   buf portadataout_buf119 (portadataout[119], portadataout_tbuf[119]);
   buf portadataout_buf120 (portadataout[120], portadataout_tbuf[120]);
   buf portadataout_buf121 (portadataout[121], portadataout_tbuf[121]);
   buf portadataout_buf122 (portadataout[122], portadataout_tbuf[122]);
   buf portadataout_buf123 (portadataout[123], portadataout_tbuf[123]);
   buf portadataout_buf124 (portadataout[124], portadataout_tbuf[124]);
   buf portadataout_buf125 (portadataout[125], portadataout_tbuf[125]);
   buf portadataout_buf126 (portadataout[126], portadataout_tbuf[126]);
   buf portadataout_buf127 (portadataout[127], portadataout_tbuf[127]);
   buf portadataout_buf128 (portadataout[128], portadataout_tbuf[128]);
   buf portadataout_buf129 (portadataout[129], portadataout_tbuf[129]);
   buf portadataout_buf130 (portadataout[130], portadataout_tbuf[130]);
   buf portadataout_buf131 (portadataout[131], portadataout_tbuf[131]);
   buf portadataout_buf132 (portadataout[132], portadataout_tbuf[132]);
   buf portadataout_buf133 (portadataout[133], portadataout_tbuf[133]);
   buf portadataout_buf134 (portadataout[134], portadataout_tbuf[134]);
   buf portadataout_buf135 (portadataout[135], portadataout_tbuf[135]);
   buf portadataout_buf136 (portadataout[136], portadataout_tbuf[136]);
   buf portadataout_buf137 (portadataout[137], portadataout_tbuf[137]);
   buf portadataout_buf138 (portadataout[138], portadataout_tbuf[138]);
   buf portadataout_buf139 (portadataout[139], portadataout_tbuf[139]);
   buf portadataout_buf140 (portadataout[140], portadataout_tbuf[140]);
   buf portadataout_buf141 (portadataout[141], portadataout_tbuf[141]);
   buf portadataout_buf142 (portadataout[142], portadataout_tbuf[142]);
   buf portadataout_buf143 (portadataout[143], portadataout_tbuf[143]);
  
   buf portbdataout_buf0 (portbdataout[0], portbdataout_tbuf[0]);
   buf portbdataout_buf1 (portbdataout[1], portbdataout_tbuf[1]);
   buf portbdataout_buf2 (portbdataout[2], portbdataout_tbuf[2]);
   buf portbdataout_buf3 (portbdataout[3], portbdataout_tbuf[3]);
   buf portbdataout_buf4 (portbdataout[4], portbdataout_tbuf[4]);
   buf portbdataout_buf5 (portbdataout[5], portbdataout_tbuf[5]);
   buf portbdataout_buf6 (portbdataout[6], portbdataout_tbuf[6]);
   buf portbdataout_buf7 (portbdataout[7], portbdataout_tbuf[7]);
   buf portbdataout_buf8 (portbdataout[8], portbdataout_tbuf[8]);
   buf portbdataout_buf9 (portbdataout[9], portbdataout_tbuf[9]);
   buf portbdataout_buf10 (portbdataout[10], portbdataout_tbuf[10]);
   buf portbdataout_buf11 (portbdataout[11], portbdataout_tbuf[11]);
   buf portbdataout_buf12 (portbdataout[12], portbdataout_tbuf[12]);
   buf portbdataout_buf13 (portbdataout[13], portbdataout_tbuf[13]);
   buf portbdataout_buf14 (portbdataout[14], portbdataout_tbuf[14]);
   buf portbdataout_buf15 (portbdataout[15], portbdataout_tbuf[15]);
   buf portbdataout_buf16 (portbdataout[16], portbdataout_tbuf[16]);
   buf portbdataout_buf17 (portbdataout[17], portbdataout_tbuf[17]);
   buf portbdataout_buf18 (portbdataout[18], portbdataout_tbuf[18]);
   buf portbdataout_buf19 (portbdataout[19], portbdataout_tbuf[19]);
   buf portbdataout_buf20 (portbdataout[20], portbdataout_tbuf[20]);
   buf portbdataout_buf21 (portbdataout[21], portbdataout_tbuf[21]);
   buf portbdataout_buf22 (portbdataout[22], portbdataout_tbuf[22]);
   buf portbdataout_buf23 (portbdataout[23], portbdataout_tbuf[23]);
   buf portbdataout_buf24 (portbdataout[24], portbdataout_tbuf[24]);
   buf portbdataout_buf25 (portbdataout[25], portbdataout_tbuf[25]);
   buf portbdataout_buf26 (portbdataout[26], portbdataout_tbuf[26]);
   buf portbdataout_buf27 (portbdataout[27], portbdataout_tbuf[27]);
   buf portbdataout_buf28 (portbdataout[28], portbdataout_tbuf[28]);
   buf portbdataout_buf29 (portbdataout[29], portbdataout_tbuf[29]);
   buf portbdataout_buf30 (portbdataout[30], portbdataout_tbuf[30]);
   buf portbdataout_buf31 (portbdataout[31], portbdataout_tbuf[31]);
   buf portbdataout_buf32 (portbdataout[32], portbdataout_tbuf[32]);
   buf portbdataout_buf33 (portbdataout[33], portbdataout_tbuf[33]);
   buf portbdataout_buf34 (portbdataout[34], portbdataout_tbuf[34]);
   buf portbdataout_buf35 (portbdataout[35], portbdataout_tbuf[35]);
   buf portbdataout_buf36 (portbdataout[36], portbdataout_tbuf[36]);
   buf portbdataout_buf37 (portbdataout[37], portbdataout_tbuf[37]);
   buf portbdataout_buf38 (portbdataout[38], portbdataout_tbuf[38]);
   buf portbdataout_buf39 (portbdataout[39], portbdataout_tbuf[39]);
   buf portbdataout_buf40 (portbdataout[40], portbdataout_tbuf[40]);
   buf portbdataout_buf41 (portbdataout[41], portbdataout_tbuf[41]);
   buf portbdataout_buf42 (portbdataout[42], portbdataout_tbuf[42]);
   buf portbdataout_buf43 (portbdataout[43], portbdataout_tbuf[43]);
   buf portbdataout_buf44 (portbdataout[44], portbdataout_tbuf[44]);
   buf portbdataout_buf45 (portbdataout[45], portbdataout_tbuf[45]);
   buf portbdataout_buf46 (portbdataout[46], portbdataout_tbuf[46]);
   buf portbdataout_buf47 (portbdataout[47], portbdataout_tbuf[47]);
   buf portbdataout_buf48 (portbdataout[48], portbdataout_tbuf[48]);
   buf portbdataout_buf49 (portbdataout[49], portbdataout_tbuf[49]);
   buf portbdataout_buf50 (portbdataout[50], portbdataout_tbuf[50]);
   buf portbdataout_buf51 (portbdataout[51], portbdataout_tbuf[51]);
   buf portbdataout_buf52 (portbdataout[52], portbdataout_tbuf[52]);
   buf portbdataout_buf53 (portbdataout[53], portbdataout_tbuf[53]);
   buf portbdataout_buf54 (portbdataout[54], portbdataout_tbuf[54]);
   buf portbdataout_buf55 (portbdataout[55], portbdataout_tbuf[55]);
   buf portbdataout_buf56 (portbdataout[56], portbdataout_tbuf[56]);
   buf portbdataout_buf57 (portbdataout[57], portbdataout_tbuf[57]);
   buf portbdataout_buf58 (portbdataout[58], portbdataout_tbuf[58]);
   buf portbdataout_buf59 (portbdataout[59], portbdataout_tbuf[59]);
   buf portbdataout_buf60 (portbdataout[60], portbdataout_tbuf[60]);
   buf portbdataout_buf61 (portbdataout[61], portbdataout_tbuf[61]);
   buf portbdataout_buf62 (portbdataout[62], portbdataout_tbuf[62]);
   buf portbdataout_buf63 (portbdataout[63], portbdataout_tbuf[63]);
   buf portbdataout_buf64 (portbdataout[64], portbdataout_tbuf[64]);
   buf portbdataout_buf65 (portbdataout[65], portbdataout_tbuf[65]);
   buf portbdataout_buf66 (portbdataout[66], portbdataout_tbuf[66]);
   buf portbdataout_buf67 (portbdataout[67], portbdataout_tbuf[67]);
   buf portbdataout_buf68 (portbdataout[68], portbdataout_tbuf[68]);
   buf portbdataout_buf69 (portbdataout[69], portbdataout_tbuf[69]);
   buf portbdataout_buf70 (portbdataout[70], portbdataout_tbuf[70]);
   buf portbdataout_buf71 (portbdataout[71], portbdataout_tbuf[71]);
   buf portbdataout_buf72 (portbdataout[72], portbdataout_tbuf[72]);
   buf portbdataout_buf73 (portbdataout[73], portbdataout_tbuf[73]);
   buf portbdataout_buf74 (portbdataout[74], portbdataout_tbuf[74]);
   buf portbdataout_buf75 (portbdataout[75], portbdataout_tbuf[75]);
   buf portbdataout_buf76 (portbdataout[76], portbdataout_tbuf[76]);
   buf portbdataout_buf77 (portbdataout[77], portbdataout_tbuf[77]);
   buf portbdataout_buf78 (portbdataout[78], portbdataout_tbuf[78]);
   buf portbdataout_buf79 (portbdataout[79], portbdataout_tbuf[79]);
   buf portbdataout_buf80 (portbdataout[80], portbdataout_tbuf[80]);
   buf portbdataout_buf81 (portbdataout[81], portbdataout_tbuf[81]);
   buf portbdataout_buf82 (portbdataout[82], portbdataout_tbuf[82]);
   buf portbdataout_buf83 (portbdataout[83], portbdataout_tbuf[83]);
   buf portbdataout_buf84 (portbdataout[84], portbdataout_tbuf[84]);
   buf portbdataout_buf85 (portbdataout[85], portbdataout_tbuf[85]);
   buf portbdataout_buf86 (portbdataout[86], portbdataout_tbuf[86]);
   buf portbdataout_buf87 (portbdataout[87], portbdataout_tbuf[87]);
   buf portbdataout_buf88 (portbdataout[88], portbdataout_tbuf[88]);
   buf portbdataout_buf89 (portbdataout[89], portbdataout_tbuf[89]);
   buf portbdataout_buf90 (portbdataout[90], portbdataout_tbuf[90]);
   buf portbdataout_buf91 (portbdataout[91], portbdataout_tbuf[91]);
   buf portbdataout_buf92 (portbdataout[92], portbdataout_tbuf[92]);
   buf portbdataout_buf93 (portbdataout[93], portbdataout_tbuf[93]);
   buf portbdataout_buf94 (portbdataout[94], portbdataout_tbuf[94]);
   buf portbdataout_buf95 (portbdataout[95], portbdataout_tbuf[95]);
   buf portbdataout_buf96 (portbdataout[96], portbdataout_tbuf[96]);
   buf portbdataout_buf97 (portbdataout[97], portbdataout_tbuf[97]);
   buf portbdataout_buf98 (portbdataout[98], portbdataout_tbuf[98]);
   buf portbdataout_buf99 (portbdataout[99], portbdataout_tbuf[99]);
   buf portbdataout_buf100 (portbdataout[100], portbdataout_tbuf[100]);
   buf portbdataout_buf101 (portbdataout[101], portbdataout_tbuf[101]);
   buf portbdataout_buf102 (portbdataout[102], portbdataout_tbuf[102]);
   buf portbdataout_buf103 (portbdataout[103], portbdataout_tbuf[103]);
   buf portbdataout_buf104 (portbdataout[104], portbdataout_tbuf[104]);
   buf portbdataout_buf105 (portbdataout[105], portbdataout_tbuf[105]);
   buf portbdataout_buf106 (portbdataout[106], portbdataout_tbuf[106]);
   buf portbdataout_buf107 (portbdataout[107], portbdataout_tbuf[107]);
   buf portbdataout_buf108 (portbdataout[108], portbdataout_tbuf[108]);
   buf portbdataout_buf109 (portbdataout[109], portbdataout_tbuf[109]);
   buf portbdataout_buf110 (portbdataout[110], portbdataout_tbuf[110]);
   buf portbdataout_buf111 (portbdataout[111], portbdataout_tbuf[111]);
   buf portbdataout_buf112 (portbdataout[112], portbdataout_tbuf[112]);
   buf portbdataout_buf113 (portbdataout[113], portbdataout_tbuf[113]);
   buf portbdataout_buf114 (portbdataout[114], portbdataout_tbuf[114]);
   buf portbdataout_buf115 (portbdataout[115], portbdataout_tbuf[115]);
   buf portbdataout_buf116 (portbdataout[116], portbdataout_tbuf[116]);
   buf portbdataout_buf117 (portbdataout[117], portbdataout_tbuf[117]);
   buf portbdataout_buf118 (portbdataout[118], portbdataout_tbuf[118]);
   buf portbdataout_buf119 (portbdataout[119], portbdataout_tbuf[119]);
   buf portbdataout_buf120 (portbdataout[120], portbdataout_tbuf[120]);
   buf portbdataout_buf121 (portbdataout[121], portbdataout_tbuf[121]);
   buf portbdataout_buf122 (portbdataout[122], portbdataout_tbuf[122]);
   buf portbdataout_buf123 (portbdataout[123], portbdataout_tbuf[123]);
   buf portbdataout_buf124 (portbdataout[124], portbdataout_tbuf[124]);
   buf portbdataout_buf125 (portbdataout[125], portbdataout_tbuf[125]);
   buf portbdataout_buf126 (portbdataout[126], portbdataout_tbuf[126]);
   buf portbdataout_buf127 (portbdataout[127], portbdataout_tbuf[127]);
   buf portbdataout_buf128 (portbdataout[128], portbdataout_tbuf[128]);
   buf portbdataout_buf129 (portbdataout[129], portbdataout_tbuf[129]);
   buf portbdataout_buf130 (portbdataout[130], portbdataout_tbuf[130]);
   buf portbdataout_buf131 (portbdataout[131], portbdataout_tbuf[131]);
   buf portbdataout_buf132 (portbdataout[132], portbdataout_tbuf[132]);
   buf portbdataout_buf133 (portbdataout[133], portbdataout_tbuf[133]);
   buf portbdataout_buf134 (portbdataout[134], portbdataout_tbuf[134]);
   buf portbdataout_buf135 (portbdataout[135], portbdataout_tbuf[135]);
   buf portbdataout_buf136 (portbdataout[136], portbdataout_tbuf[136]);
   buf portbdataout_buf137 (portbdataout[137], portbdataout_tbuf[137]);
   buf portbdataout_buf138 (portbdataout[138], portbdataout_tbuf[138]);
   buf portbdataout_buf139 (portbdataout[139], portbdataout_tbuf[139]);
   buf portbdataout_buf140 (portbdataout[140], portbdataout_tbuf[140]);
   buf portbdataout_buf141 (portbdataout[141], portbdataout_tbuf[141]);
   buf portbdataout_buf142 (portbdataout[142], portbdataout_tbuf[142]);
   buf portbdataout_buf143 (portbdataout[143], portbdataout_tbuf[143]);

   initial
     begin
	tmp_mem = {mem9, mem8, mem7, mem6, mem5, mem4, mem3, mem2, mem1};
	if(init_file_layout == "none")
	  begin
	      if (ram_block_type == "M-RAM" || ram_block_type == "m-ram" ||
	          ram_block_type == "MegeRAM" ||
	         (mixed_port_feed_through_mode == "dont_care" && 
	          ram_block_type == "auto"))
	       mem = 'bX;
	      else
	           mem = 'b0;
	  end
	else
	  begin
	     mem = 'b0;
	     if(init_file_layout == "port_b")
	       begin
		  l = 0;
		  depth = port_b_last_address - port_b_first_address + 1;
		  for (j = 0; j < depth; j = j + 1)
		    begin
		       for (k = 0; k < port_b_data_width; k = k + 1)
			 begin
			    index = j + (depth * k);
			    mem[l] = tmp_mem[index];
			    l = l + 1;
			 end
		    end 
	       end
	     else if (init_file_layout == "port_a")
	       begin
		  l = 0;
		  depth = port_a_last_address - port_a_first_address + 1;	 
		  for (j = 0; j < depth; j = j + 1)
		    begin
		       for (k = 0; k < port_a_data_width; k = k + 1)
			 begin
			    index = j + (depth * k);
			    mem[l] = tmp_mem[index];
			    l = l + 1;
			 end
		    end 
	       end 
	  end 
	portadataout_tmp = 'b0;
	portbdataout_tmp = 'b0;
     end
   
   assign portadataout_tbuf = portadataout_tmp;
   assign portbdataout_tbuf = portbdataout_tmp;
   
   // PORT A
   always @ (portaclock)
     begin
	case (operation_mode)
	  "single_port":
	    begin
	       if (portawriteenable) 
		 begin // WRITE: mem[portaaddress] = portadatani
		    if(~portaclock)
		      wr_a <= 1'b1;
		    else if(portaclock)
		      begin
			 wr_a <= 1'b0;
			 for (i = 0; i < port_a_data_width; i = i + 1)
			   if(portabyteenamask[
			   i/(port_a_data_width
				  /port_a_byte_enable_mask_width)] == 1'b0)
			     portadataout_tmp[i] = 1'bX;
			   else
			     portadataout_tmp[i] = portadatain[i];
		      end
		 end 
	       else if(~portawriteenable)
		 begin // READ: portadataout = mem[portaaddress]
		    wr_a <= 1'b0;
		    if(portaclock)
		      begin
			 for (i = 0; i < port_a_data_width; i = i + 1)
			   portadataout_tmp[i] = 
				  mem[portaaddress*port_a_data_width + i];
		      end
		 end 
	    end // case: "single_port"
	  "dual_port":
	    begin
	       if(portawriteenable)
		 // WRITE: mem[portaaddress] =  portadatain;
		 begin
		    if(sameclock == 1'b1 && 
		       (ram_block_type == "MegaRAM" || 
			ram_block_type == "M-RAM" || 
			ram_block_type == "m-ram" ||
			(ram_block_type == "auto" && 
			 mixed_port_feed_through_mode == "dont_care")))
		      begin
			 // WRITE: mem[portaaddress] =  portadatain;
			 if(portaclock)
			   wr_a <= 1'b1;
			 else
			   wr_a <= 1'b0;
		      end
		    else
		      begin
			 // WRITE: mem[portaaddress] =  portadatain;
			 if((ram_block_type != "MegaRAM") && 
			    (ram_block_type != "M-RAM") && 
			    (ram_block_type != "m-ram") &&
			    ((ram_block_type != "auto") || 
			     (mixed_port_feed_through_mode != "dont_care"))) 
			   begin 
			      if(~portaclock)
				wr_a <= 1'b1;
			      else
				wr_a <= 1'b0;
			   end 
			 else
			   begin 
			      if(portaclock)
				wr_a <= 1'b1;
			      else
				wr_a <= 1'b0;
			   end
		      end 
		 end
	       else
		 wr_a <= 1'b0;
	    end // case: "dual_port"
	  "bidir_dual_port":
	    if(~portawriteenable)
	      begin
		 wr_a <= 1'b0;
		 //  READ: portadataout = mem[portaaddress]
		 if(sameclock == 1'b1 && portbwriteenable &&
		    (ram_block_type == "MegaRAM" || 
		     ram_block_type == "M-RAM" || 
		     ram_block_type == "m-ram" || 
		     (ram_block_type == "auto" && 
		      mixed_port_feed_through_mode == "dont_care")))
		   begin
		      if(portaclock)
			begin
			   if(
			      (((portaaddress*port_a_data_width) < 
				(portbaddress*port_b_data_width)) && 
			       (((portaaddress*port_a_data_width) 
				 + port_a_data_width-1) 
				< (portbaddress*port_b_data_width))) ||
			      (((portaaddress*port_a_data_width) > 
				(portbaddress*port_b_data_width)) && 
			       (((portbaddress*port_b_data_width) 
				 + port_b_data_width-1) < 
				(portaaddress*port_a_data_width)))
			      )
			     begin
				for (i = 0; i < port_a_data_width; i = i + 1)
				  begin
				     portadataout_tmp[i] 
				    = mem[portaaddress*port_a_data_width + i];
				  end
			     end
			   else
			     begin
				for (i = 0; i < port_a_data_width; i = i + 1)
				  begin
				     if((portaaddress*port_a_data_width) <= 
					(portbaddress*port_b_data_width))
				       begin
					  if((((portaaddress*port_a_data_width) + i) >= 
					      (portbaddress*port_b_data_width)) && 
					     ((portaaddress*port_a_data_width) + i < 
					      ((portbaddress*port_b_data_width) + 
					       port_b_data_width)))
					    begin
					       portadataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       portadataout_tmp[i] 
					      = mem[portaaddress*port_a_data_width + i];
					    end
				       end
				     else
				       begin
					  if(((portaaddress*port_a_data_width) + i) <= 
					     ((portbaddress*port_b_data_width) + 
					      port_b_data_width))
					    begin
					       portadataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       portadataout_tmp[i] 
					      = mem[portaaddress*port_a_data_width + i];
					    end
				       end
				  end
			     end 
			end
		   end 
		 else
		   begin // READ: portadataout = mem[portaaddress];
		      if(portaclock)
			begin
			   for (i = 0; i < port_a_data_width; i = i + 1)
			     portadataout_tmp[i] = 
				    mem[portaaddress*port_a_data_width + i];
			end 
		   end 
	      end 
	    else if(portawriteenable)
	      begin // WRITE: mem[portaaddress] = portadatain
		 if(sameclock == 1'b1 && portbwriteenable && 
		    (ram_block_type == "MegaRAM" || 
		     ram_block_type == "M-RAM" || 
		     ram_block_type == "m-ram" || 
		     (ram_block_type == "auto" && 
		      mixed_port_feed_through_mode == "dont_care")))
		   begin
		      if(portaclock)
			begin
			   wr_a = 1'b1;
			   if(
			      (((portaaddress*port_a_data_width) < 
				(portbaddress*port_b_data_width)) && 
			       (((portaaddress*port_a_data_width) 
				 + port_a_data_width-1) 
				< (portbaddress*port_b_data_width))) ||
			      (((portaaddress*port_a_data_width) > 
				(portbaddress*port_b_data_width)) && 
			       (((portbaddress*port_b_data_width) 
				 + port_b_data_width-1) < 
				(portaaddress*port_a_data_width)))
			      )
			     begin
				for (i = 0; i < port_a_data_width; i = i + 1)
				  if(portabyteenamask
				     [i/(port_a_data_width
					 /port_a_byte_enable_mask_width)] == 1'b0)
				    portadataout_tmp[i] = 1'bX;
				  else
				    portadataout_tmp[i] = portadatain[i];
			     end
			   else
			     begin
				for (i = 0; i < port_a_data_width; i = i + 1)
				  begin
				     if((portaaddress*port_a_data_width) <= 
					(portbaddress*port_b_data_width))
				       begin
					  if((((portaaddress*port_a_data_width) + i) >= 
					      (portbaddress*port_b_data_width)) && 
					     ((portaaddress*port_a_data_width) + i < 
					      ((portbaddress*port_b_data_width) + 
					       port_b_data_width)))
					    begin
					       portadataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       for (i = 0; i < port_a_data_width; i = i + 1)
						 if(portabyteenamask
						    [i/(port_a_data_width
							/port_a_byte_enable_mask_width)] == 1'b0)
						   portadataout_tmp[i] = 1'bX;
						 else
						   portadataout_tmp[i] = portadatain[i];
					    end
				       end
				     else
				       begin
					  if(((portaaddress*port_a_data_width) + i) <= 
					     ((portbaddress*port_b_data_width) + 
					      port_b_data_width))
					    begin
					       portadataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       for (i = 0; i < port_a_data_width; i = i + 1)
						 if(portabyteenamask
						    [i/(port_a_data_width
							/port_a_byte_enable_mask_width)] == 1'b0)
						   portadataout_tmp[i] = 1'bX;
						 else
						   portadataout_tmp[i] = portadatain[i];
					    end 
				       end
				  end
			     end
			end
		      else
			wr_a = 1'b0;
		   end
		 else
		   begin
		      // WRITE: mem[portaaddress] =  portadatain;
		      if((ram_block_type != "MegaRAM") && 
			 (ram_block_type != "M-RAM") && 
			 (ram_block_type != "m-ram") &&
			 ((ram_block_type != "auto") || 
			  (mixed_port_feed_through_mode != "dont_care"))) 
			begin
			   if(portaclock)
			     begin
				wr_a <= 1'b0;
				for (i = 0; i < port_a_data_width; i = i + 1)
				  if(portabyteenamask[
				    i/(port_a_data_width
					 /port_a_byte_enable_mask_width)] 
				     == 1'b0)
				    portadataout_tmp[i] = 1'bX;
				  else
				    portadataout_tmp[i] = portadatain[i];
			     end
			   else
			     wr_a <= 1'b1;
			end
		      else
			begin
			   if(portaclock)
			     begin
				wr_a <= 1'b1;
				for (i = 0; i < port_a_data_width; i = i + 1)
				  if(portabyteenamask[
				    i/(port_a_data_width
					 /port_a_byte_enable_mask_width)] 
				     == 1'b0)
				    portadataout_tmp[i] = 1'bX;
				  else
				    portadataout_tmp[i] = portadatain[i];
			     end
			   else
			     wr_a <= 1'b0;
			end
		   end 
	      end
	  "rom":
	    begin
	       if(portaclock)
		 begin
		    for (i = 0; i < port_a_data_width; i = i + 1)
		      portadataout_tmp[i] = 
			     mem[portaaddress*port_a_data_width + i];
		 end
	    end // case: "rom"
	  default :;
	endcase // case(operation_mode)
     end
   
   // PORT B
   always @ (portbclock)
     begin
	case (operation_mode)
	  "dual_port":
	    begin
	       if(portbreadenable)
		 begin
		    //  READ: portbdataout = mem[portbaddress];
		    if(sameclock == 1'b1 && portawriteenable &&
		       (ram_block_type == "MegaRAM" || 
			ram_block_type == "M-RAM" || 
			ram_block_type == "m-ram" || 
			(ram_block_type == "auto" && 
			 mixed_port_feed_through_mode == "dont_care")))
		      begin
			 // READ: portbdataout = mem[portbaddress];
			 if(portbclock)
			   begin
			      if(
				 (((portbaddress*port_b_data_width) < 
				   (portaaddress*port_a_data_width)) && 
				  (((portbaddress*port_b_data_width) 
				    + port_b_data_width-1) 
				   < (portaaddress*port_a_data_width))) ||
				 (((portbaddress*port_b_data_width) > 
				   (portaaddress*port_a_data_width)) && 
				  (((portaaddress*port_a_data_width) 
				    + port_a_data_width-1) < 
				   (portbaddress*port_b_data_width)))
				 )
				begin
				   for (i = 0; i < port_b_data_width; i = i + 1)
				     begin
					portbdataout_tmp[i] 
				       = mem[portbaddress*port_b_data_width + i];
				     end
				end
			      else
				begin
				   for (i = 0; i < port_b_data_width; i = i + 1)
				     begin
					if((portbaddress*port_b_data_width) <= 
					   (portaaddress*port_a_data_width))
					  begin
					     if((((portbaddress*port_b_data_width) + i) >= 
						 (portaaddress*port_a_data_width)) && 
						((portbaddress*port_b_data_width) + i < 
						 ((portaaddress*port_a_data_width) + 
						  port_a_data_width)))
					       begin
						  portbdataout_tmp[i] = 1'bX;
					       end
					     else
					       begin
						  portbdataout_tmp[i] 
						 = mem[portbaddress*port_b_data_width + i];
					       end
					  end
					else
					  begin
					     if(((portbaddress*port_b_data_width) + i) <= 
						((portaaddress*port_a_data_width) + 
						 port_a_data_width))
					       begin
						  portbdataout_tmp[i] = 1'bX;
					       end
					     else
					       begin
						  portbdataout_tmp[i] 
						 = mem[portaaddress*port_a_data_width + i];
					       end
					  end
				     end
				end 
			   end 
		      end 
		    else
		      begin
			 // READ: portbdataout = mem[portbaddress];
			 if(portbclock)
			   begin
			      for (i = 0; i < port_b_data_width; i = i + 1)
				portbdataout_tmp[i] = 
				       mem[portbaddress*port_b_data_width + i];
			   end 
		      end 
		 end
	    end // case: "dual_port"
	  "bidir_dual_port":
	    if(~portbwriteenable)
	      begin
		 wr_b <= 1'b0;		
		 // READ: portbdataout = mem[portbaddress]
		 if(sameclock == 1'b1 && portawriteenable &&
		    (ram_block_type == "MegaRAM" || 
		     ram_block_type == "M-RAM" ||
		     ram_block_type == "m-ram" || 
		     (ram_block_type == "auto" && 
		      mixed_port_feed_through_mode == "dont_care")))
		   begin			 
		      if(portbclock)
			begin
			   if(
			      (((portbaddress*port_b_data_width) < 
				(portaaddress*port_a_data_width)) && 
			       (((portbaddress*port_b_data_width) 
				 + port_b_data_width-1) 
				< (portaaddress*port_a_data_width))) ||
			      (((portbaddress*port_b_data_width) > 
				(portaaddress*port_a_data_width)) && 
			       (((portaaddress*port_a_data_width) 
				 + port_a_data_width-1) < 
				(portbaddress*port_b_data_width)))
			      )
			     begin
				for (i = 0; i < port_b_data_width; i = i + 1)
				  begin
				     portbdataout_tmp[i] 
				    = mem[portbaddress*port_b_data_width + i];
				  end
			     end
			   else
			     begin
				for (i = 0; i < port_b_data_width; i = i + 1)
				  begin
				     if((portbaddress*port_b_data_width) <= 
					(portaaddress*port_a_data_width))
				       begin
					  if((((portbaddress*port_b_data_width) + i) >= 
					      (portaaddress*port_a_data_width)) && 
					     ((portbaddress*port_b_data_width) + i < 
					      ((portaaddress*port_a_data_width) + 
					       port_a_data_width)))
					    begin
					       portbdataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       portbdataout_tmp[i] 
					      = mem[portbaddress*port_b_data_width + i];
					    end
				       end
				     else
				       begin
					  if(((portbaddress*port_b_data_width) + i) <= 
					     ((portaaddress*port_a_data_width) + 
					      port_a_data_width))
					    begin
					       portbdataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       portbdataout_tmp[i] 
					      = mem[portbaddress*port_b_data_width + i];
					    end
				       end
				  end 
			     end
			end 
		   end
		 else
		   begin // READ: portbdataout = mem[portbaddress];
		      if(portbclock)
			begin
			   for (i = 0; i < port_b_data_width; i = i + 1)
			     portbdataout_tmp[i] = 
				    mem[portbaddress*port_b_data_width + i];
			end 
		   end
	      end
	    else if(portbwriteenable)
	      begin // WRITE: mem[portbaddress] = portbdatain
		 if(sameclock == 1'b1 && portawriteenable && 
		    (ram_block_type == "MegaRAM" || 
		     ram_block_type == "M-RAM" ||
		     ram_block_type == "m-ram" || 
		     (ram_block_type == "auto" && 
		      mixed_port_feed_through_mode == "dont_care")))
		   begin	 
		      if(portbclock)
			begin
			   wr_b = 1'b1;
			   if(
			      (((portbaddress*port_b_data_width) < 
				(portaaddress*port_a_data_width)) && 
			       (((portbaddress*port_b_data_width) 
				 + port_b_data_width-1) 
				< (portaaddress*port_a_data_width))) ||
			      (((portbaddress*port_b_data_width) > 
				(portaaddress*port_a_data_width)) && 
			       (((portaaddress*port_a_data_width) 
				 + port_a_data_width-1) < 
				(portbaddress*port_b_data_width)))
			      )
			     begin
				for (i = 0; i < port_b_data_width; i = i + 1)
				  if(portbbyteenamask
				     [i/(port_b_data_width
					 /port_b_byte_enable_mask_width)] == 1'b0)
				    portbdataout_tmp[i] = 1'bX;
				  else
				    portbdataout_tmp[i] = portbdatain[i];
			     end
			   else
			     begin
				for (i = 0; i < port_b_data_width; i = i + 1)
				  begin
				     if((portbaddress*port_b_data_width) <= 
					(portaaddress*port_a_data_width))
				       begin
					  if((((portbaddress*port_b_data_width) + i) >= 
					      (portaaddress*port_a_data_width)) && 
					     ((portbaddress*port_b_data_width) + i < 
					      ((portaaddress*port_a_data_width) + 
					       port_a_data_width)))
					    begin
					       portbdataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       for (i = 0; i < port_b_data_width; i = i + 1)
						 if(portbbyteenamask
						    [i/(port_b_data_width
							/port_b_byte_enable_mask_width)] == 1'b0)
						   portbdataout_tmp[i] = 1'bX;
						 else
						   portbdataout_tmp[i] = portbdatain[i];
					    end
				       end
				     else
				       begin
					  if(((portbaddress*port_b_data_width) + i) <= 
					     ((portaaddress*port_a_data_width) + 
					      port_a_data_width))
					    begin
					       portbdataout_tmp[i] = 1'bX;
					    end
					  else
					    begin
					       for (i = 0; i < port_b_data_width; i = i + 1)
						 if(portbbyteenamask
						    [i/(port_b_data_width
							/port_b_byte_enable_mask_width)] == 1'b0)
						   portbdataout_tmp[i] = 1'bX;
						 else
						   portbdataout_tmp[i] = portbdatain[i];
					    end
				       end
				  end
			     end
			end 
		      else
			wr_b = 1'b0;
		   end
		 else
		   begin
		      // WRITE: mem[portbaddress] =  portbdatain;
		      if((ram_block_type != "MegaRAM") && 
			 (ram_block_type != "M-RAM") &&
			 (ram_block_type != "m-ram") && 
			 ((ram_block_type != "auto") || 
			  (mixed_port_feed_through_mode != "dont_care"))) 
			begin 
			   if(portbclock)
			     begin
				wr_b <= 1'b0;
				for (i = 0; i < port_b_data_width; i = i + 1)
				  if(portbbyteenamask[
				    i/(port_b_data_width
					 /port_b_byte_enable_mask_width)] 
				     == 1'b0)
				    portbdataout_tmp[i] = 1'bX;
				  else
				    portbdataout_tmp[i] = portbdatain[i];
			     end 
			   else
			     wr_b <= 1'b1;
			end 
		      else
			begin // WRITE ON POSITIVE EDGE OF CLOCK FOR M-RAM
			   if(portbclock)
			     begin
				wr_b <= 1'b1;
				for (i = 0; i < port_b_data_width; i = i + 1)
				  if(portbbyteenamask[
				    i/(port_b_data_width
					 /port_b_byte_enable_mask_width)] 
				     == 1'b0)
				    portbdataout_tmp[i] = 1'bX;
				  else
				    portbdataout_tmp[i] = portbdatain[i];
			     end
			   else
			     wr_b <= 1'b0;
			end 
		   end  
	      end 	       
	  default :;
	endcase // case(operation_mode)
     end 
   
   // WRITE LOGIC BLOCK FOR PORT A
   always @ (posedge wr_a)
     begin
	// WRITE: mem[portaaddress] = portadatain;
	if(wr_a)
	  begin
	     for (i = 0; i < port_a_data_width; i = i + 1)
	       if(portabyteenamask
		  [i/(port_a_data_width
		      /port_a_byte_enable_mask_width)] !== 1'b0)
		 mem[portaaddress*port_a_data_width + i] =  
		      portadatain[i];
	  end
     end
   
   // WRITE LOGIC BLOCK FOR PORT B
   always @ (posedge wr_b)
     begin
	// WRITE: mem[portbaddress] =  portbdatain;
	if(wr_b)
	  begin
	     for (i = 0; i < port_b_data_width; i = i + 1)
	       if(portbbyteenamask
		  [i/(port_b_data_width
		      /port_b_byte_enable_mask_width)] !== 1'b0)
		 mem[portbaddress*port_b_data_width + i] =
		      portbdatain[i];	
	  end
     end
   
   // CLEAR LOGIC BLOCK
   always @ (posedge cleara)
     begin
   	// ACLEAR PORT A
	     if(port_a_address_clear != "none")
	       mem = {(589823){1'bx}};
	     else
	       begin
		  for (i = 0; i < port_a_data_width; i = i + 1)
		    if(portabyteenamask
		       [i/(port_a_data_width/
			   port_a_byte_enable_mask_width)] !== 1'b0)
		      mem[portaaddress*port_a_data_width + i] =  1'bX;
	       end
	  end
	
   always @ (posedge clearb)
     begin
	// ACLEAR PORT B
	if(operation_mode != "dual_port")
	  begin
	     if(port_b_address_clear != "none")
	       mem = {(589823){1'bx}};
	     else
	       begin
		  for (i = 0; i < port_b_data_width; i = i + 1)
		    if(portbbyteenamask
		       [i/(port_b_data_width/
			   port_b_byte_enable_mask_width)] !== 1'b0)
		      mem[portbaddress*port_b_data_width + i] =  1'bX;
	       end
	  end
     end   
   
endmodule 

///////////////////////////////////////////////////////////////////////////////
//
//                               CYCLONE_RAM_BLOCK
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
  module cyclone_ram_block 
    (
     portadatain, 
     portaaddr, 
     portawe, 
     portbdatain, 
     portbaddr, 
     portbrewe, 
     clk0, clk1, 
     ena0, ena1, 
     clr0, clr1,
     portabyteenamasks, 
     portbbyteenamasks,
     devclrn,
     devpor,
     portadataout, 
     portbdataout
     );
   
   parameter mem1 = 512'b0;
   parameter mem2 = 512'b0;
   parameter mem3 = 512'b0;
   parameter mem4 = 512'b0;
   parameter mem5 = 512'b0;
   parameter mem6 = 512'b0;
   parameter mem7 = 512'b0;
   parameter mem8 = 512'b0;
   parameter mem9 = 512'b0;
   parameter operation_mode = "single_port";
   parameter mixed_port_feed_through_mode = "dont_care";
   parameter ram_block_type = "auto"; 
   parameter logical_ram_name = "ram_name"; 
   parameter init_file = "init_file.hex"; 
   parameter init_file_layout = "none";
   parameter data_interleave_width_in_bits = 1;
   parameter data_interleave_offset_in_bits = 1;
   parameter port_a_logical_ram_depth = 0;
   parameter port_a_logical_ram_width = 0;
   parameter port_a_data_in_clear = "none";
   parameter port_a_address_clear = "none";
   parameter port_a_write_enable_clear = "none";
   parameter port_a_data_out_clock = "none";
   parameter port_a_data_out_clear = "none";
   parameter port_a_first_address = 0;
   parameter port_a_last_address = 0;
   parameter port_a_first_bit_number = 0;
   parameter port_a_byte_enable_clear = "none";
   parameter port_a_data_in_clock = "clock0"; 
   parameter port_a_address_clock = "clock0"; 
   parameter port_a_write_enable_clock = "clock0";
   parameter port_a_byte_enable_clock = "clock0";
   parameter port_b_logical_ram_depth = 0;
   parameter port_b_logical_ram_width = 0;
   parameter port_b_data_in_clock = "none";
   parameter port_b_data_in_clear = "none";
   parameter port_b_address_clock = "none";
   parameter port_b_address_clear = "none";
   parameter port_b_read_enable_write_enable_clock = "none";
   parameter port_b_read_enable_write_enable_clear = "none";
   parameter port_b_data_out_clock = "none";
   parameter port_b_data_out_clear = "none";
   parameter port_b_first_address = 0;
   parameter port_b_last_address = 0;
   parameter port_b_first_bit_number = 0;
   parameter port_a_data_width = 144;
   parameter port_b_data_width = 144;
   parameter port_a_address_width = 144; 
   parameter port_b_address_width = 144; 
   parameter port_b_byte_enable_clear = "none";
   parameter port_b_byte_enable_clock = "none";
   parameter port_a_byte_enable_mask_width = 144; 
   parameter port_b_byte_enable_mask_width = 144; 
   parameter lpm_type = "cyclone_ram_block";
   parameter connectivity_checking = "off";
   
   input     portawe;
   input [15:0] portabyteenamasks; 
   input [15:0] portbbyteenamasks; 
   input 	portbrewe;
   input 	clr0;
   input 	clr1;
   input 	clk0;
   input 	clk1;
   input 	ena0;
   input 	ena1;
   input [143:0] portadatain;
   input [143:0] portbdatain;
   input [15:0]  portaaddr;
   input [15:0]  portbaddr;
   input 	 devclrn;
   input 	 devpor;
   output [143:0] portadataout;
   output [143:0] portbdataout; 

   tri1 	  ena0;
   tri1 	  ena1;
      
   wire [143:0]   portawe_bus;
   wire [143:0]   portbrewe_bus; 
   wire [143:0]   portadatain_bus;
   wire [143:0]   portbdatain_bus;
   wire [143:0]   portadatain_mbus;
   wire [143:0]   portbdatain_mbus;
   wire [143:0]   portaaddr_bus;
   wire [143:0]   portbaddr_bus;
   wire [143:0]   portamask_bus; 
   wire [143:0]   portbmask_bus;
   wire [143:0]   portadataout_bus;
   wire [143:0]   portbdataout_bus;
   wire [143:0]   portadataout_tmp;
   wire [143:0]   portbdataout_tmp;
   wire [143:0]   portaaddr_tmp;
   wire [143:0]   portbaddr_tmp;
   wire [143:0]   portadatain_tmp;
   wire [143:0]   portbdatain_tmp;
   wire [1:0] 	  clr_bus;
   wire [1:0] 	  clk_bus;
   wire [1:0] 	  ena_bus;
   wire [4:0] 	  done_a;
   wire [4:0] 	  done_b;
   wire [4:0] 	  clkout_a;
   wire [4:0] 	  clkout_b;
   wire [4:0] 	  done_a_tmp;
   wire [4:0] 	  done_b_tmp;
   wire 	  clock_a;
   wire 	  clock_b;
   wire 	  clrdly_a;
   wire 	  clrdly_b;
   wire 	  edg;
   wire [143:0]   portawe_tmp;
   wire [143:0]   portbrewe_tmp;
   wire [143:0]   portabyteenamasks_tmp;
   wire [143:0]   portbbyteenamasks_tmp;
   reg [143:0] 	  portaaddr_delta;
   reg [143:0] 	  portbaddr_delta;
   reg [143:0] 	  portawe_delta;
   reg [143:0] 	  portbrewe_delta;
   reg [143:0] 	  portadatain_delta;
   reg [143:0] 	  portbdatain_delta;
   reg [143:0] 	  portabyteenamasks_delta;
   reg [143:0] 	  portbbyteenamasks_delta;

   // here
   wire 	  adatain_aclr;
   wire 	  adatain_ena;
   wire 	  aaddr_aclr;
   wire 	  aaddr_ena;

   wire 	  bdatain_clk;
   wire 	  bdatain_aclr;
   wire 	  bdatain_ena;
   wire 	  baddr_clk;
   wire 	  baddr_aclr;
   wire 	  baddr_ena;
   wire 	  brewe_clk;
   wire 	  brewe_aclr;
   wire 	  brewe_ena;
   wire 	  abyteenamasks_aclr;
   wire 	  bbyteenamasks_clk;
   wire 	  bbyteenamasks_aclr;
   wire 	  bbyteenamasks_ena;
   wire 	  adataout_clk;
   wire 	  adataout_aclr;
   wire 	  adataout_ena;
   wire 	  bdataout_clk;
   wire 	  bdataout_aclr;
   wire 	  bdataout_ena;
      
   wire 	  portadatain_aclr;
   wire 	  portaaddr_aclr;
   wire           portawe_aclr;
   wire 	  awe_aclr;
   wire 	  awe_ena;
   wire 	  portbdatain_clk;
   wire 	  portbdatain_aclr;
   wire 	  portbaddr_clk;
   wire 	  portbaddr_aclr;
   wire 	  portbrewe_clk;
   wire 	  portbrewe_aclr;
   wire 	  portabyteenamasks_aclr;
   wire 	  portbbyteenamasks_clk;
   wire 	  portbbyteenamasks_aclr;
   wire 	  portadataout_clk;
   wire 	  portadataout_aclr;
   wire 	  portbdataout_clk;
   wire 	  portbdataout_aclr;
   wire [5:0] 	  aclra;
   wire [5:0] 	  aclrb;
   
   cyclone_ram_clear ram_aclra_reg
     (
      .aclr(aclra[2] || ~devclrn),
      .d(portawe_bus[0]),
      .clk(clrdly_a),
      .ena(clock_a),
      .edg(edg),
      .q(aclra[5])
      );
   
   assign 	  edg = ((port_b_address_clock == "clock0") && 
			 (ram_block_type == "MegaRAM" || 
			  ram_block_type == "M-RAM" || 
			  ram_block_type == "m-ram" ||
			  (ram_block_type == "auto" && 
			   mixed_port_feed_through_mode == "dont_care"))) ? 1'b1 : 1'b0;
   
   cyclone_ram_clear ram_aclrb_reg
     (
      .aclr(aclrb[2] || ~devclrn),
      .d(portbrewe_bus[0]),
      .clk(clrdly_b),
      .ena(clock_b),
      .edg(edg),
      .q(aclrb[5])
      );
   
   cyclone_ram_register	ram_portadatain_reg 
     (
      .data (portadatain_delta),
      .clk (clk_bus[0]),
      .aclr(adatain_aclr),
      .ena (adatain_ena),
      .ifclk(1'b1),
      .ifaclr((port_a_data_in_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena(1'b1),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b0),
      .dataout (portadatain_bus),
      .aclrout(aclra[0]),
      .clkout(clkout_a[0]),
      .done (done_a_tmp[0])
      );
   defparam 	  ram_portadatain_reg.data_width = 144;
   defparam 	  ram_portadatain_reg.sclr = "true";
   defparam 	  ram_portadatain_reg.preset = "false";

   assign 	  adatain_aclr = clr_bus[portadatain_aclr] || ~devclrn;
   assign 	  adatain_ena = ena_bus[0];
      
   assign 	  portadatain_aclr = ((port_a_data_in_clear == "clear0") || 
				      (port_a_data_in_clear == "none")) ? 
				       1'b0 : 1'b1;
   assign 	  done_a[0] = ((done_a_tmp[0] == 1'b1) || 
			       (port_a_data_in_clock == "none")) ? 
				1'b1 : 1'b0;
   
   cyclone_ram_register	ram_portaaddr_reg 
     (
      .data (portaaddr_delta),
      .clk (clk_bus[0]),
      .aclr(aaddr_aclr),
      .ena (aaddr_ena),
      .ifclk(1'b1),
      .ifaclr((port_a_address_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena(1'b1),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b0),
      .dataout (portaaddr_bus),
      .aclrout(aclra[1]),
      .clkout(clkout_a[1]),
      .done (done_a_tmp[1])
      );
   defparam 	  ram_portaaddr_reg.data_width = 16;
   defparam 	  ram_portaaddr_reg.sclr = "true";
   defparam 	  ram_portaaddr_reg.preset = "false";
   
   assign 	  aaddr_aclr = clr_bus[portaaddr_aclr] || ~devclrn;
   assign 	  aaddr_ena = ena_bus[0];
   
   assign 	  portaaddr_aclr = ((port_a_address_clear == "clear0") || 
				    (port_a_address_clear == "none")) ? 
				     1'b0 : 1'b1; 
   assign 	  done_a[1] = ((done_a_tmp[1] == 1'b1) || 
			       (port_a_address_clock == "none")) ? 
				1'b1 : 1'b0;
   
   cyclone_ram_register	ram_portawe_reg 
     (
      .data (portawe_delta),
      .clk (clk_bus[0]),
      .aclr(awe_aclr),
      .ena (awe_ena),
      .ifclk(1'b1),
      .ifaclr((port_a_write_enable_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena(1'b1),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b0),
      .dataout (portawe_bus),
      .aclrout(aclra[2]),
      .clkout(clkout_a[2]),
      .done (done_a_tmp[2])
      );
   defparam 	  ram_portawe_reg.data_width = 1;
   defparam 	  ram_portawe_reg.sclr = "true";
   defparam 	  ram_portawe_reg.preset = "false";

   assign 	  awe_aclr = clr_bus[portawe_aclr] || ~devclrn;
   assign 	  awe_ena = ena_bus[0];
      
   assign 	  portawe_aclr = ((port_a_write_enable_clear == "clear0") || 
				  (port_a_write_enable_clear == "none")) ? 
				   1'b0 : 1'b1;
   assign 	  done_a[2] = ((done_a_tmp[2] == 1'b1) || 
			       (port_a_write_enable_clock == "none")) ? 
				1'b1 : 1'b0;
   
   cyclone_ram_register	ram_portbdatain_reg 
     (
      .data (portbdatain_delta), 
      .clk (bdatain_clk),
      .aclr(bdatain_aclr),
      .ena (bdatain_ena),
      .ifclk((port_b_data_in_clock == "none") ? 1'b0 : 1'b1 ),
      .ifaclr((port_b_data_in_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena((port_b_data_in_clock == "none") ? 1'b0 : 1'b1 ),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b0),
      .dataout (portbdatain_bus),
      .aclrout(aclrb[0]),
      .clkout(clkout_b[0]),
      .done (done_b_tmp[0])
      );
   defparam 	  ram_portbdatain_reg.data_width = 144;
   defparam 	  ram_portbdatain_reg.sclr = "true";
   defparam 	  ram_portbdatain_reg.preset = "false";

   assign 	  bdatain_clk = clk_bus[portbdatain_clk];
   assign 	  bdatain_aclr = clr_bus[portbdatain_aclr] || ~devclrn;
   assign 	  bdatain_ena = ena_bus[portbdatain_clk];
      
   assign 	  portbdatain_clk = ((port_b_data_in_clock == "clock0") || 
				     (port_b_data_in_clock == "none")) ? 
				      1'b0 : 1'b1;
   assign 	  portbdatain_aclr = ((port_b_data_in_clear == "clear0") || 
				      (port_b_data_in_clear == "none")) ? 
				       1'b0 : 1'b1;  
   assign 	  done_b[0] = ((done_b_tmp[0] == 1'b1) || 
			       (port_b_data_in_clock == "none")) ? 
				1'b1 : 1'b0;
   
   cyclone_ram_register	ram_portbaddr_reg 
     (
      .data (portbaddr_delta),
      .clk (baddr_clk),
      .aclr (baddr_aclr),
      .ena (baddr_ena),
      .ifclk((port_b_address_clock == "none") ? 1'b0 : 1'b1 ),
      .ifaclr((port_b_address_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena((port_b_address_clock == "none") ? 1'b0 : 1'b1 ),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b0),
      .dataout (portbaddr_bus),
      .aclrout(aclrb[1]),
      .clkout(clkout_b[1]),
      .done (done_b_tmp[1])
      );
   defparam 	  ram_portbaddr_reg.data_width = 16;
   defparam 	  ram_portbaddr_reg.sclr = "true";
   defparam 	  ram_portbaddr_reg.preset = "false";

   assign 	  baddr_clk = clk_bus[portbaddr_clk];
   assign 	  baddr_aclr = clr_bus[portbaddr_aclr] || ~devclrn;
   assign 	  baddr_ena = ena_bus[portbaddr_clk];
      
   assign 	  portbaddr_clk = ((port_b_address_clock == "clock0") || 
				   (port_b_address_clock == "none")) ? 
				    1'b0 : 1'b1; 
   assign 	  portbaddr_aclr = ((port_b_address_clear == "clear0") || 
				    (port_b_address_clear == "none")) ? 
				     1'b0 : 1'b1;
   assign 	  done_b[1] = ((done_b_tmp[1] == 1'b1) || 
			       (port_b_address_clock == "none")) ? 
				1'b1 : 1'b0;
   
   cyclone_ram_register	ram_portbrewe_reg 
     (
      .data (portbrewe_delta),
      .clk (brewe_clk),
      .aclr(brewe_aclr),
      .ena (brewe_ena),
      .ifclk((port_b_read_enable_write_enable_clock == "none") ? 
	      1'b0 : 1'b1 ),
      .ifaclr((port_b_read_enable_write_enable_clear == "none") ? 
	       1'b0 : 1'b1 ),
      .ifena((port_b_read_enable_write_enable_clock == "none") ? 
	      1'b0 : 1'b1 ),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup((operation_mode != "dual_port") ? 1'b0 : 1'b1),
      .dataout (portbrewe_bus),
      .aclrout(aclrb[2]),
      .clkout(clkout_b[2]),
      .done (done_b_tmp[2])
      );
   defparam 	  ram_portbrewe_reg.data_width = 1;
   defparam 	  ram_portbrewe_reg.sclr = "true";
   defparam 	  ram_portbrewe_reg.preset = "true";

   assign 	  brewe_clk  = clk_bus[portbrewe_clk];
   assign 	  brewe_aclr = clr_bus[portbrewe_aclr] || ~devclrn;
   assign 	  brewe_ena  = ena_bus[portbrewe_clk];
   
   assign 	  portbrewe_clk = ((port_b_read_enable_write_enable_clock == 
				    "clock0") || 
				   (port_b_read_enable_write_enable_clock == 
				    "none")) ? 1'b0 : 1'b1;
   assign 	  portbrewe_aclr = ((port_b_read_enable_write_enable_clear == 
				     "clear0") || 
				    (port_b_read_enable_write_enable_clear == 
				     "none")) ? 1'b0 : 1'b1;
   assign 	  done_b[2] = ((done_b_tmp[2] == 1'b1) || 
			       (port_b_read_enable_write_enable_clock == 
				"none")) ? 1'b1 : 1'b0;
   
   cyclone_ram_register	ram_portabyteenamasks_reg 
     (
      .data (portabyteenamasks_delta),
      .clk (clk_bus[0]), 
      .aclr (abyteenamasks_aclr),
      .ena (ena_bus[0]),
      .ifclk(1'b1),
      .ifaclr((port_a_byte_enable_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena(1'b1),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b1),
      .dataout (portamask_bus),
      .aclrout(aclra[3]),
      .clkout(clkout_a[3]),
      .done (done_a_tmp[3])
      );
   defparam 	  ram_portabyteenamasks_reg.data_width = 
		  port_a_byte_enable_mask_width;
   defparam 	  ram_portabyteenamasks_reg.sclr = "true";
   defparam 	  ram_portabyteenamasks_reg.preset = "true";

   assign 	  abyteenamasks_aclr = clr_bus[portabyteenamasks_aclr] || ~devclrn;
      
   assign 	  portabyteenamasks_aclr = ((port_a_byte_enable_clear == 
					     "clear0") || 
					    (port_a_byte_enable_clear == 
					     "none")) ? 1'b0 : 1'b1;
   assign 	  done_a[3] = ((done_a_tmp[3] == 1'b1) || 
			       (port_a_byte_enable_clock == "none")) ? 
				1'b1 : 1'b0;
   
   cyclone_ram_register	ram_portbbyteenamasks_reg 
     (
      .data (portbbyteenamasks_delta),
      .clk (bbyteenamasks_clk),
      .aclr (bbyteenamasks_aclr),
      .ena (bbyteenamasks_ena),
      .ifclk((port_b_byte_enable_clock == "none") ? 1'b0 : 1'b1 ),
      .ifaclr((port_b_byte_enable_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena((port_b_byte_enable_clock == "none") ? 1'b0 : 1'b1 ),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b1),
      .dataout (portbmask_bus),
      .aclrout(aclrb[3]),
      .clkout(clkout_b[3]),
      .done (done_b_tmp[3])
      );
   defparam 	  ram_portbbyteenamasks_reg.data_width = 
		  port_b_byte_enable_mask_width;
   defparam 	  ram_portbbyteenamasks_reg.sclr = "true";
   defparam 	  ram_portbbyteenamasks_reg.preset = "true";

   assign 	  bbyteenamasks_clk = clk_bus[portbbyteenamasks_clk];
   assign 	  bbyteenamasks_aclr = clr_bus[portbbyteenamasks_aclr] || ~devclrn;
   assign 	  bbyteenamasks_ena = ena_bus[portbbyteenamasks_clk];
   
   
   assign 	  portbbyteenamasks_clk = ((port_b_byte_enable_clock == 
					    "clock0") || 
					   (port_b_byte_enable_clock == 
					    "none")) ? 1'b0 : 1'b1; 
   assign 	  portbbyteenamasks_aclr = ((port_b_byte_enable_clear == 
					     "clear0") || 
					    (port_b_byte_enable_clear == 
					     "none")) ? 1'b0 : 1'b1;
   assign 	  done_b[3] = ((done_b_tmp[3] == 1'b1) || 
			       (port_b_byte_enable_clock == "none")) ? 
				1'b1 : 1'b0;
   
   assign 	  clock_a = (port_a_write_enable_clock == port_b_read_enable_write_enable_clock) ? 
			      done_a[0] & done_a[1] & done_a[2] & done_b[2] & done_a[3] : 
		              done_a[0] & done_a[1] & done_a[2] & done_a[3] ;
   assign 	  clock_b = (port_a_write_enable_clock == port_b_read_enable_write_enable_clock) ?
			      done_b[0] & done_b[1] & done_b[2] & done_a[2] & done_b[3] :
		              done_b[0] & done_b[1] & done_b[2] & done_b[3] ;
   assign 	  clrdly_a = (port_a_write_enable_clock == port_b_read_enable_write_enable_clock) ?
			       clkout_a[0] & clkout_a[1] & clkout_a[2] & clkout_b[2] & clkout_a[3] :
		               clkout_a[0] & clkout_a[1] & clkout_a[2] & clkout_a[3];
   assign 	  clrdly_b = (port_a_write_enable_clock == port_b_read_enable_write_enable_clock) ? 
			       clkout_b[0] & clkout_b[1] & clkout_b[2] & clkout_a[2] & clkout_b[3] :
   			       clkout_b[0] & clkout_b[1] & clkout_b[2] & clkout_b[3];
   
   cyclone_ram_internal internal_ram
     (
      .portawriteenable(portawe_bus[0]), 
      .portbwriteenable(portbrewe_bus[0]),
      .cleara(aclra[5]),
      .clearb(aclrb[5]),
      .portadatain(portadatain_bus[143:0]), 
      .portbdatain(portbdatain_bus[143:0]), 
      .portaaddress(portaaddr_bus[15:0]), 
      .portbaddress(portbaddr_bus[15:0]), 
      .portabyteenamask(portamask_bus[15:0]), 
      .portbbyteenamask(portbmask_bus[15:0]), 
      .portbreadenable(portbrewe_bus[0]),
      .portaclock(clock_a),
      .portbclock(clock_b),
      .sameclock(port_b_address_clock == "clock0" ? 1'b1 : 1'b0),
      .portadataout(portadataout_bus),
      .portbdataout(portbdataout_bus)
      );
   defparam 	  internal_ram.operation_mode = operation_mode;
   defparam 	  internal_ram.ram_block_type = ram_block_type;
   defparam 	  internal_ram.mixed_port_feed_through_mode = 
		  mixed_port_feed_through_mode;
   defparam 	  internal_ram.port_a_data_width = port_a_data_width;
   defparam 	  internal_ram.port_b_data_width = port_b_data_width;
   defparam 	  internal_ram.port_a_address_width = port_a_address_width;
   defparam 	  internal_ram.port_b_address_width = port_b_address_width;
   defparam 	  internal_ram.port_a_byte_enable_mask_width = 
		  port_a_byte_enable_mask_width;
   defparam 	  internal_ram.port_b_byte_enable_mask_width = 
		  port_b_byte_enable_mask_width;
   defparam 	  internal_ram.init_file_layout = init_file_layout;
   defparam 	  internal_ram.port_a_first_address = port_a_first_address;
   defparam 	  internal_ram.port_a_last_address = port_a_last_address;
   defparam 	  internal_ram.port_b_first_address = port_b_first_address;
   defparam 	  internal_ram.port_b_last_address = port_b_last_address;
   defparam 	  internal_ram.port_a_address_clear = port_a_address_clear;
   defparam 	  internal_ram.port_b_address_clear = port_b_address_clear;
   defparam 	  internal_ram.mem1 = mem1;
   defparam 	  internal_ram.mem2 = mem2;
   defparam 	  internal_ram.mem3 = mem3;
   defparam 	  internal_ram.mem4 = mem4;
   defparam 	  internal_ram.mem5 = mem5;
   defparam 	  internal_ram.mem6 = mem6;
   defparam 	  internal_ram.mem7 = mem7;
   defparam 	  internal_ram.mem8 = mem8;
   defparam 	  internal_ram.mem9 = mem9; 
   
   cyclone_ram_register	ram_portadataout_reg 
      (
       .data (portadataout_bus),
       .clk (adataout_clk),
       .aclr (adataout_aclr),
       .ena (adataout_ena),
       .ifclk((port_a_data_out_clock == "none") ? 1'b0 : 1'b1 ),
       .ifaclr((port_a_data_out_clear == "none") ? 1'b0 : 1'b1 ),
       .ifena((port_a_data_out_clock == "none") ? 1'b0 : 1'b1 ),
       .devclrn(devclrn),
       .devpor(devpor),
       .powerup(1'b0),
       .dataout (portadataout_tmp),
       .aclrout(aclra[4]),
       .clkout(clkout_a[4]),
       .done (done_a[4])
       );
   defparam 	ram_portadataout_reg.data_width = 144;
   defparam 	ram_portadataout_reg.sclr = "false";
   defparam 	ram_portadataout_reg.preset = "false";
   
   assign 	adataout_clk = clk_bus[portadataout_clk];
   assign 	adataout_aclr = clr_bus[portadataout_aclr] || ~devclrn;
   assign       adataout_ena = ena_bus[portadataout_clk];
      
   assign 	portadataout_clk = ((port_a_data_out_clock == "clock0") || 
				    (port_a_data_out_clock == "none")) ? 
				     1'b0 : 1'b1; 
   assign 	portadataout_aclr = ((port_a_data_out_clear == "clear0") || 
				     (port_a_data_out_clear == "none")) ? 
				      1'b0 : 1'b1;
   
   cyclone_ram_register	ram_portbdataout_reg 
     (
      .data (portbdataout_bus),
      .clk (bdataout_clk),
      .aclr(bdataout_aclr),
      .ena (bdataout_ena),
      .ifclk((port_b_data_out_clock == "none") ? 1'b0 : 1'b1 ),
      .ifaclr((port_b_data_out_clear == "none") ? 1'b0 : 1'b1 ),
      .ifena((port_b_data_out_clock == "none") ? 1'b0 : 1'b1 ),
      .devclrn(devclrn),
      .devpor(devpor),
      .powerup(1'b0),
      .dataout (portbdataout_tmp),
      .aclrout(aclrb[4]),
      .clkout(clkout_b[4]),
      .done (done_b[4])
      );
   defparam 	ram_portbdataout_reg.data_width = 144;
   defparam 	ram_portbdataout_reg.sclr = "false";
   defparam 	ram_portbdataout_reg.preset = "false";

   assign 	bdataout_clk = clk_bus[portbdataout_clk];
   assign 	bdataout_aclr = clr_bus[portbdataout_aclr] || ~devclrn;
   assign 	bdataout_ena = ena_bus[portbdataout_clk];
   
   assign 	portbdataout_clk = ((port_b_data_out_clock == "clock0") || 
				    (port_b_data_out_clock == "none")) ? 
				     1'b0 : 1'b1; 
   assign 	portbdataout_aclr = ((port_b_data_out_clear == "clear0") || 
				     (port_b_data_out_clear == "none")) ? 
				      1'b0 : 1'b1;
   
   assign 	clk_bus               = {clk1, clk0};
   assign 	clr_bus               = {clr1, clr0};
   assign 	ena_bus               = {ena1, ena0};
   assign 	portaaddr_tmp[15:0]   = portaaddr[15:0];
   assign 	portbaddr_tmp[15:0]   = portbaddr[15:0];
   assign 	portawe_tmp[0]        = portawe;
   assign 	portbrewe_tmp[0]      = portbrewe;   
   assign 	portadatain_tmp       = portadatain;
   assign 	portbdatain_tmp       = portbdatain;
   assign 	portabyteenamasks_tmp[15:0] = portabyteenamasks;
   assign 	portbbyteenamasks_tmp[15:0] = portbbyteenamasks;
   
   always @ (portaaddr_tmp or portbaddr_tmp or 
	     portawe_tmp or portbrewe_tmp or
	     portadatain_tmp or portbdatain_tmp or
	     portabyteenamasks_tmp or portbbyteenamasks_tmp)
     begin
	portaaddr_delta[15:0]   <= portaaddr_tmp[15:0];
	portbaddr_delta[15:0]   <= portbaddr_tmp[15:0];
   	portawe_delta[0]        <= portawe_tmp[0];
    	portbrewe_delta[0]      <= portbrewe_tmp[0];   
    	portadatain_delta       <= portadatain_tmp;
    	portbdatain_delta       <= portbdatain_tmp;
   	portabyteenamasks_delta <= portabyteenamasks_tmp;
    	portbbyteenamasks_delta <= portbbyteenamasks_tmp;
     end
   
   assign portadataout = portadataout_tmp; 
   assign portbdataout = portbdataout_tmp; 
   
endmodule // cyclone_ram_block

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : m_cntr
//
// Description : Timing simulation model for the M counter. This is the
//               loop feedback counter for the Cyclone PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module m_cntr (clk,
               reset,
               cout,
               initial_value,
               modulus,
               time_delay
              );

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] initial_value;
    input [31:0] modulus;
    input [31:0] time_delay;

    // OUTPUT PORTS
    output cout;

    // INTERNAL VARIABLES AND NETS
    integer count;
    reg tmp_cout;
    reg first_rising_edge;
    reg clk_last_value;
    reg cout_tmp;

    initial
    begin
        count = 1;
        first_rising_edge = 1;
        clk_last_value = 0;
    end

    always @(reset or clk)
    begin
        if (reset)
        begin
            count = 1;
            tmp_cout = 0;
            first_rising_edge = 1;
        end
        else begin
            if (clk == 1 && clk_last_value !== clk && first_rising_edge)
            begin
                first_rising_edge = 0;
                tmp_cout = clk;
            end
            else if (first_rising_edge == 0)
            begin
                if (count < modulus)
                   count = count + 1;
                else
                begin
                   count = 1;
                   tmp_cout = ~tmp_cout;
                end
            end
        end
        clk_last_value = clk;

        cout_tmp <= #(time_delay) tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // m_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : n_cntr
//
// Description : Timing simulation model for the N counter. This is the
//               input clock divide counter for the Cyclone PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module n_cntr (clk,
               reset,
               cout,
               modulus,
               time_delay
              );

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] modulus;
    input [31:0] time_delay;

    // OUTPUT PORTS
    output cout;

    // INTERNAL VARIABLES AND NETS
    integer count;
    reg tmp_cout;
    reg first_rising_edge;
    reg clk_last_value;
    reg cout_tmp;

    initial
    begin
        count = 1;
        first_rising_edge = 1;
        clk_last_value = 0;
    end

    always @(reset or clk)
    begin
        if (reset)
        begin
            count = 1;
            tmp_cout = 0;
            first_rising_edge = 1;
        end
        else begin
            if (clk == 1 && clk_last_value !== clk && first_rising_edge)
            begin
                first_rising_edge = 0;
                tmp_cout = clk;
            end
            else if (first_rising_edge == 0)
            begin
                if (count < modulus)
                    count = count + 1;
                else
                begin
                    count = 1;
                    tmp_cout = ~tmp_cout;
                end
            end
        end
        clk_last_value = clk;

        cout_tmp <= #(time_delay) tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // n_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : scale_cntr
//
// Description : Timing simulation model for the output scale-down counters.
//               This is a common model for the L0, L1, G0, G1, G2, G3, E0,
//               E1, E2 and E3 output counters of the Cyclone PLL.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps
module scale_cntr(clk,
                  reset,
                  cout,
                  high,
                  low,
                  initial_value,
                  mode,
                  time_delay,
                  ph_tap
                 );

    // INPUT PORTS
    input clk;
    input reset;
    input [31:0] high;
    input [31:0] low;
    input [31:0] initial_value;
    input [8*6:1] mode;
    input [31:0] time_delay;
    input [31:0] ph_tap;

    // OUTPUT PORTS
    output cout;

    // INTERNAL VARIABLES AND NETS
    reg tmp_cout;
    reg first_rising_edge;
    reg clk_last_value;
    reg init;
    integer count;
    integer output_shift_count;
    reg cout_tmp;
    reg [31:0] high_reg;
    reg [31:0] low_reg;

    initial
    begin
        count = 1;
        first_rising_edge = 0;
        tmp_cout = 0;
        output_shift_count = 0;
    end

    always @(clk or reset)
    begin
        if (init !== 1'b1)
        begin
            high_reg = high;
            low_reg = low;
            clk_last_value = 0;
            init = 1'b1;
        end
        if (reset)
        begin
            count = 1;
            output_shift_count = 0;
            tmp_cout = 0;
            first_rising_edge = 0;
        end
        else if (clk_last_value !== clk)
        begin
            if (mode == "off")
                tmp_cout = 0;
            else if (mode == "bypass")
                tmp_cout = clk;
            else if (first_rising_edge == 0)
            begin
                if (clk == 1)
                begin
                    output_shift_count = output_shift_count + 1;
                    if (output_shift_count == initial_value)
                    begin
                       tmp_cout = clk;
                       first_rising_edge = 1;
                    end
                end
            end
            else if (output_shift_count < initial_value)
            begin
                if (clk == 1)
                    output_shift_count = output_shift_count + 1;
            end
            else
            begin
                count = count + 1;
                if (mode == "even" && (count == (high_reg*2) + 1))
                begin
                    tmp_cout = 0;
                    low_reg = low;
                end
                else if (mode == "odd" && (count == (high_reg*2)))
                begin
                    tmp_cout = 0;
                    low_reg = low;
                end
                else if (count == (high_reg + low_reg)*2 + 1)
                begin
                    tmp_cout = 1;
                    count = 1;        // reset count
                    high_reg = high;
                end
            end
        end
        clk_last_value = clk;
        cout_tmp <= #(time_delay) tmp_cout;
    end

    and (cout, cout_tmp, 1'b1);

endmodule // scale_cntr

///////////////////////////////////////////////////////////////////////////////
//
// Module Name : pll_reg
//
// Description : Simulation model for a simple DFF.
//               This is required for the generation of the bit slip-signals.
//               No timing, powers upto 0.
//
///////////////////////////////////////////////////////////////////////////////

`timescale 1ps / 1ps
module pll_reg (q,
                clk,
                ena,
                d,
                clrn,
                prn
               );

    // INPUT PORTS
    input d;
    input clk;
    input clrn;
    input prn;
    input ena;

    // OUTPUT PORTS
    output q;

    // INTERNAL VARIABLES
    reg q;

    // DEFAULT VALUES THRO' PULLUPs
    tri1 prn, clrn, ena;

    initial q = 0;

    always @ (posedge clk or negedge clrn or negedge prn )
    begin
        if (prn == 1'b0)
            q <= 1;
        else if (clrn == 1'b0)
            q <= 0;
        else if ((clk == 1) & (ena == 1'b1))
            q <= d;
    end

endmodule // pll_reg

//////////////////////////////////////////////////////////////////////////////
//
// Module Name : cyclone_pll
//
// Description : Timing simulation model for the Cyclone StratixGX PLL.
//               In the functional mode, it is also the model for the altpll
//               megafunction.
// 
// Limitations : Does not support Spread Spectrum and Bandwidth.
//
// Outputs     : Up to 10 output clocks, each defined by its own set of
//               parameters. Locked output (active high) indicates when the
//               PLL locks. clkbad, clkloss and activeclock are used for
//               clock switchover to inidicate which input clock has gone
//               bad, when the clock switchover initiates and which input
//               clock is being used as the reference, respectively.
//               scandataout is the data output of the serial scan chain.
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
`define WORD_LENGTH 18

module cyclone_pll (inclk,
                    fbin,
                    ena,
                    clkswitch,
                    areset,
                    pfdena,
                    clkena,
                    extclkena,
                    scanclk,
                    scanaclr,
                    scandata,
                    clk,
                    extclk,
                    clkbad,
                    activeclock,
                    locked,
                    clkloss,
                    scandataout,
                    // lvds mode specific ports
                    comparator,
                    enable0,
                    enable1
                   );

    parameter operation_mode = "normal";
    parameter qualify_conf_done = "off";
    parameter compensate_clock = "clk0";
    parameter pll_type = "auto";
    parameter scan_chain = "long";
    parameter lpm_type = "cyclone_pll";

    parameter clk0_multiply_by = 1;
    parameter clk0_divide_by = 1;
    parameter clk0_phase_shift = 0;
    parameter clk0_time_delay = 0;
    parameter clk0_duty_cycle = 50;

    parameter clk1_multiply_by = 1;
    parameter clk1_divide_by = 1;
    parameter clk1_phase_shift = 0;
    parameter clk1_time_delay = 0;
    parameter clk1_duty_cycle = 50;

    parameter clk2_multiply_by = 1;
    parameter clk2_divide_by = 1;
    parameter clk2_phase_shift = 0;
    parameter clk2_time_delay = 0;
    parameter clk2_duty_cycle = 50;

    parameter clk3_multiply_by = 1;
    parameter clk3_divide_by = 1;
    parameter clk3_phase_shift = 0;
    parameter clk3_time_delay = 0;
    parameter clk3_duty_cycle = 50;

    parameter clk4_multiply_by = 1;
    parameter clk4_divide_by = 1;
    parameter clk4_phase_shift = 0;
    parameter clk4_time_delay = 0;
    parameter clk4_duty_cycle = 50;

    parameter clk5_multiply_by = 1;
    parameter clk5_divide_by = 1;
    parameter clk5_phase_shift = 0;
    parameter clk5_time_delay = 0;
    parameter clk5_duty_cycle = 50;

    parameter extclk0_multiply_by = 1;
    parameter extclk0_divide_by = 1;
    parameter extclk0_phase_shift = 0;
    parameter extclk0_time_delay = 0;
    parameter extclk0_duty_cycle = 50;

    parameter extclk1_multiply_by = 1;
    parameter extclk1_divide_by = 1;
    parameter extclk1_phase_shift = 0;
    parameter extclk1_time_delay = 0;
    parameter extclk1_duty_cycle = 50;

    parameter extclk2_multiply_by = 1;
    parameter extclk2_divide_by = 1;
    parameter extclk2_phase_shift = 0;
    parameter extclk2_time_delay = 0;
    parameter extclk2_duty_cycle = 50;

    parameter extclk3_multiply_by = 1;
    parameter extclk3_divide_by = 1;
    parameter extclk3_phase_shift = 0;
    parameter extclk3_time_delay = 0;
    parameter extclk3_duty_cycle = 50;

    parameter primary_clock = "inclk0";
    parameter inclk0_input_frequency = 10000;
    parameter inclk1_input_frequency = 10000;
    parameter gate_lock_signal = "no";
    parameter gate_lock_counter = 1;
    parameter valid_lock_multiplier = 5;
    parameter invalid_lock_multiplier = 5;

    parameter switch_over_on_lossclk = "off";
    parameter switch_over_on_gated_lock = "off";
    parameter switch_over_counter = 1;
    parameter enable_switch_over_counter = "off";
    parameter feedback_source = "e0";
    parameter bandwidth = 0;
    parameter bandwidth_type = "auto";
    parameter down_spread = "0.0";
    parameter spread_frequency = 0;
    parameter common_rx_tx = "off";
    parameter rx_outclock_resource = "auto";
    parameter use_vco_bypass = "false";
    parameter use_dc_coupling = "false";

    parameter pfd_min = 0;
    parameter pfd_max = 0;
    parameter vco_min = 0;
    parameter vco_max = 0;
    parameter vco_center = 0;

    // ADVANCED USE PARAMETERS
    parameter m_initial = 1;
    parameter m = 1;
    parameter n = 1;
    parameter m2 = 1;
    parameter n2 = 1;
    parameter ss = 0;

    parameter l0_high = 1;
    parameter l0_low = 1;
    parameter l0_initial = 1;
    parameter l0_mode = "bypass";
    parameter l0_ph = 0;
    parameter l0_time_delay = 0;

    parameter l1_high = 1;
    parameter l1_low = 1;
    parameter l1_initial = 1;
    parameter l1_mode = "bypass";
    parameter l1_ph = 0;
    parameter l1_time_delay = 0;

    parameter g0_high = 1;
    parameter g0_low = 1;
    parameter g0_initial = 1;
    parameter g0_mode = "bypass";
    parameter g0_ph = 0;
    parameter g0_time_delay = 0;

    parameter g1_high = 1;
    parameter g1_low = 1;
    parameter g1_initial = 1;
    parameter g1_mode = "bypass";
    parameter g1_ph = 0;
    parameter g1_time_delay = 0;

    parameter g2_high = 1;
    parameter g2_low = 1;
    parameter g2_initial = 1;
    parameter g2_mode = "bypass";
    parameter g2_ph = 0;
    parameter g2_time_delay = 0;

    parameter g3_high = 1;
    parameter g3_low = 1;
    parameter g3_initial = 1;
    parameter g3_mode = "bypass";
    parameter g3_ph = 0;
    parameter g3_time_delay = 0;

    parameter e0_high = 1;
    parameter e0_low = 1;
    parameter e0_initial = 1;
    parameter e0_mode = "bypass";
    parameter e0_ph = 0;
    parameter e0_time_delay = 0;

    parameter e1_high = 1;
    parameter e1_low = 1;
    parameter e1_initial = 1;
    parameter e1_mode = "bypass";
    parameter e1_ph = 0;
    parameter e1_time_delay = 0;

    parameter e2_high = 1;
    parameter e2_low = 1;
    parameter e2_initial = 1;
    parameter e2_mode = "bypass";
    parameter e2_ph = 0;
    parameter e2_time_delay = 0;

    parameter e3_high = 1;
    parameter e3_low = 1;
    parameter e3_initial = 1;
    parameter e3_mode = "bypass";
    parameter e3_ph = 0;
    parameter e3_time_delay = 0;

    parameter m_ph = 0;
    parameter m_time_delay = 0;
    parameter n_time_delay = 0;

    parameter extclk0_counter = "e0";
    parameter extclk1_counter = "e1";
    parameter extclk2_counter = "e2";
    parameter extclk3_counter = "e3";

    parameter clk0_counter = "g0";
    parameter clk1_counter = "g1";
    parameter clk2_counter = "g2";
    parameter clk3_counter = "g3";
    parameter clk4_counter = "l0";
    parameter clk5_counter = "l1";

    // LVDS mode parameters
    parameter enable0_counter = "l0";
    parameter enable1_counter = "l0";

    parameter charge_pump_current = 0;
    parameter loop_filter_r = "1.0";
    parameter loop_filter_c = 1;

    parameter pll_compensation_delay = 0;
    parameter simulation_type = "timing";
    parameter source_is_pll = "off";

    //parameter for cyclone lvds
    parameter clk0_phase_shift_num = 0;
    parameter clk1_phase_shift_num = 0;
    parameter clk2_phase_shift_num = 0;

    parameter skip_vco = "off";

    // INPUT PORTS
    input [1:0] inclk;
    input fbin;
    input ena;
    input clkswitch;
    input areset;
    input pfdena;
    input [5:0] clkena;
    input [3:0] extclkena;
    input scanclk;
    input scanaclr;
    input scandata;
    // lvds specific input ports
    input comparator;

    // OUTPUT PORTS
    output [5:0] clk;
    output [3:0] extclk;
    output [1:0] clkbad;
    output activeclock;
    output locked;
    output clkloss;
    output scandataout;
    // lvds specific output ports
    output enable0;
    output enable1;

    // BUFFER INPUTS
    buf (inclk0_ipd, inclk[0]);
    buf (inclk1_ipd, inclk[1]);
    buf (ena_ipd, ena);
    buf (fbin_ipd, fbin);
    buf (areset_ipd, areset);
    buf (pfdena_ipd, pfdena);
    buf (clkena0_ipd, clkena[0]);
    buf (clkena1_ipd, clkena[1]);
    buf (clkena2_ipd, clkena[2]);
    buf (clkena3_ipd, clkena[3]);
    buf (clkena4_ipd, clkena[4]);
    buf (clkena5_ipd, clkena[5]);
    buf (extclkena0_ipd, extclkena[0]);
    buf (extclkena1_ipd, extclkena[1]);
    buf (extclkena2_ipd, extclkena[2]);
    buf (extclkena3_ipd, extclkena[3]);
    buf (scanclk_ipd, scanclk);
    buf (scanaclr_ipd, scanaclr);
    buf (scandata_ipd, scandata);
    buf (comparator_ipd, comparator);
    buf (clkswitch_ipd, clkswitch);

    // INTERNAL VARIABLES AND NETS
    integer scan_chain_length;
    integer i;
    integer j;
    integer k;
    integer l_index;
    integer gate_count;
    integer egpp_offset;
    integer sched_time;
    integer delay_chain;
    integer low;
    integer high;
    integer initial_delay;
    integer fbk_phase;
    integer fbk_delay;
    integer phase_shift[0:7];
    integer last_phase_shift[0:7];

    integer m_times_vco_period;
    integer new_m_times_vco_period;
    integer refclk_period;
    integer fbclk_period;
    integer primary_clock_frequency;
    integer high_time;
    integer low_time;
    integer my_rem;
    integer tmp_rem;
    integer rem;
    integer tmp_vco_per;
    integer vco_per;
    integer offset;
    integer temp_offset;
    integer cycles_to_lock;
    integer cycles_to_unlock;
    integer l0_count;
    integer l1_count;
    integer loop_xplier;
    integer loop_initial;
    integer loop_ph;
    integer loop_time_delay;
    integer cycle_to_adjust;
    integer total_pull_back;
    integer pull_back_M;
    integer pull_back_ext_cntr;

    time    fbclk_time;
    time    first_fbclk_time;
    time    refclk_time;
    time    scanaclr_rising_time;
    time    scanaclr_falling_time;
 
    reg got_first_refclk;
    reg got_second_refclk;
    reg got_first_fbclk;
    reg refclk_last_value;
    reg fbclk_last_value;
    reg inclk_last_value;
    reg pll_is_locked;
    reg pll_about_to_lock;
    reg locked_tmp;
    reg l0_got_first_rising_edge;
    reg l1_got_first_rising_edge;
    reg vco_l0_last_value;
    reg vco_l1_last_value;
    reg areset_ipd_last_value;
    reg ena_ipd_last_value;
    reg pfdena_ipd_last_value;
    reg inclk_out_of_range;
    reg schedule_vco_last_value;

    reg gate_out;
    reg vco_val;

    reg [31:0] m_initial_val;
    reg [31:0] m_val;
    reg [31:0] m2_val;
    reg [31:0] n_val;
    reg [31:0] n2_val;
    reg [31:0] m_time_delay_val;
    reg [31:0] n_time_delay_val;
    reg [31:0] m_delay;
    reg [8*6:1] m_mode_val;
    reg [8*6:1] m2_mode_val;
    reg [8*6:1] n_mode_val;
    reg [8*6:1] n2_mode_val;
    reg [31:0] l0_high_val;
    reg [31:0] l0_low_val;
    reg [31:0] l0_initial_val;
    reg [31:0] l0_time_delay_val;
    reg [8*6:1] l0_mode_val;
    reg [31:0] l1_high_val;
    reg [31:0] l1_low_val;
    reg [31:0] l1_initial_val;
    reg [31:0] l1_time_delay_val;
    reg [8*6:1] l1_mode_val;

    reg [31:0] g0_high_val;
    reg [31:0] g0_low_val;
    reg [31:0] g0_initial_val;
    reg [31:0] g0_time_delay_val;
    reg [8*6:1] g0_mode_val;

    reg [31:0] g1_high_val;
    reg [31:0] g1_low_val;
    reg [31:0] g1_initial_val;
    reg [31:0] g1_time_delay_val;
    reg [8*6:1] g1_mode_val;

    reg [31:0] g2_high_val;
    reg [31:0] g2_low_val;
    reg [31:0] g2_initial_val;
    reg [31:0] g2_time_delay_val;
    reg [8*6:1] g2_mode_val;

    reg [31:0] g3_high_val;
    reg [31:0] g3_low_val;
    reg [31:0] g3_initial_val;
    reg [31:0] g3_time_delay_val;
    reg [8*6:1] g3_mode_val;

    reg [31:0] e0_high_val;
    reg [31:0] e0_low_val;
    reg [31:0] e0_initial_val;
    reg [31:0] e0_time_delay_val;
    reg [8*6:1] e0_mode_val;

    reg [31:0] e1_high_val;
    reg [31:0] e1_low_val;
    reg [31:0] e1_initial_val;
    reg [31:0] e1_time_delay_val;
    reg [8*6:1] e1_mode_val;

    reg [31:0] e2_high_val;
    reg [31:0] e2_low_val;
    reg [31:0] e2_initial_val;
    reg [31:0] e2_time_delay_val;
    reg [8*6:1] e2_mode_val;

    reg [31:0] e3_high_val;
    reg [31:0] e3_low_val;
    reg [31:0] e3_initial_val;
    reg [31:0] e3_time_delay_val;
    reg [8*6:1] e3_mode_val;

    reg scanclk_last_value;
    reg scanaclr_last_value;
    reg transfer;
    reg transfer_enable;
    reg [288:0] scan_data;
    reg schedule_vco;
    reg schedule_offset;
    reg stop_vco;
    reg inclk_n;

    reg [7:0] vco_out;
    wire inclk_l0;
    wire inclk_l1;
    wire inclk_m;
    wire clk0_tmp;
    wire clk1_tmp;
    wire clk2_tmp;
    wire clk3_tmp;
    wire clk4_tmp;
    wire clk5_tmp;
    wire extclk0_tmp;
    wire extclk1_tmp;
    wire extclk2_tmp;
    wire extclk3_tmp;
    wire nce_l0;
    wire nce_l1;
    wire nce_temp;

    reg vco_l0;
    reg vco_l1;

    wire clk0;
    wire clk1;
    wire clk2;
    wire clk3;
    wire clk4;
    wire clk5;
    wire extclk0;
    wire extclk1;
    wire extclk2;
    wire extclk3;
    
    wire lvds_dffb_clk;
    wire dffa_out;
    
    reg first_schedule;

    wire enable0_tmp;
    wire enable1_tmp;
    wire enable_0;
    wire enable_1;
    reg l0_tmp;
    reg l1_tmp;

    reg vco_period_was_phase_adjusted;
    reg phase_adjust_was_scheduled;

    // for external feedback mode

    reg [31:0] ext_fbk_cntr_high;
    reg [31:0] ext_fbk_cntr_low;
    reg [31:0] ext_fbk_cntr_delay;
    reg [8*2:1] ext_fbk_cntr;
    integer ext_fbk_cntr_ph;
    integer ext_fbk_cntr_initial;

    wire inclk_e0;
    wire inclk_e1;
    wire inclk_e2;
    wire inclk_e3;
    wire [31:0] cntr_e0_initial;
    wire [31:0] cntr_e1_initial;
    wire [31:0] cntr_e2_initial;
    wire [31:0] cntr_e3_initial;
    wire [31:0] cntr_e0_delay;
    wire [31:0] cntr_e1_delay;
    wire [31:0] cntr_e2_delay;
    wire [31:0] cntr_e3_delay;
    reg  [31:0] ext_fbk_delay;

    // variables for clk_switch
    reg clk0_is_bad;
    reg clk1_is_bad;
    reg inclk0_last_value;
    reg inclk1_last_value;
    reg other_clock_value;
    reg other_clock_last_value;
    reg primary_clk_is_bad;
    reg current_clk_is_bad;
    reg external_switch;
    reg [8*6:1] current_clock;
    reg active_clock;
    reg clkloss_tmp;
    reg got_curr_clk_falling_edge_after_clkswitch;
    reg active_clk_was_switched;

    integer clk0_count;
    integer clk1_count;
    integer switch_over_count;

    reg scandataout_tmp;
    integer quiet_time;
    reg pll_in_quiet_period;
    time start_quiet_time;
    reg quiet_period_violation;
    reg reconfig_err;
    reg scanclr_violation;
    reg scanclr_clk_violation;
    reg got_first_scanclk_after_scanclr_inactive_edge;
    reg error;

    reg no_warn;

    // internal parameters
    parameter EGPP_SCAN_CHAIN = 289;
    parameter GPP_SCAN_CHAIN = 193;
    parameter TRST = 5000;
    parameter TRSTCLK = 5000;

    // user to advanced internal signals

    integer   i_m_initial;
    integer   i_m;
    integer   i_n;
    integer   i_m2;
    integer   i_n2;
    integer   i_ss;
    integer   i_l0_high;
    integer   i_l1_high;
    integer   i_g0_high;
    integer   i_g1_high;
    integer   i_g2_high;
    integer   i_g3_high;
    integer   i_e0_high;
    integer   i_e1_high;
    integer   i_e2_high;
    integer   i_e3_high;
    integer   i_l0_low;
    integer   i_l1_low;
    integer   i_g0_low;
    integer   i_g1_low;
    integer   i_g2_low;
    integer   i_g3_low;
    integer   i_e0_low;
    integer   i_e1_low;
    integer   i_e2_low;
    integer   i_e3_low;
    integer   i_l0_initial;
    integer   i_l1_initial;
    integer   i_g0_initial;
    integer   i_g1_initial;
    integer   i_g2_initial;
    integer   i_g3_initial;
    integer   i_e0_initial;
    integer   i_e1_initial;
    integer   i_e2_initial;
    integer   i_e3_initial;
    reg [8*6:1]   i_l0_mode;
    reg [8*6:1]   i_l1_mode;
    reg [8*6:1]   i_g0_mode;
    reg [8*6:1]   i_g1_mode;
    reg [8*6:1]   i_g2_mode;
    reg [8*6:1]   i_g3_mode;
    reg [8*6:1]   i_e0_mode;
    reg [8*6:1]   i_e1_mode;
    reg [8*6:1]   i_e2_mode;
    reg [8*6:1]   i_e3_mode;
    integer   i_vco_min;
    integer   i_vco_max;
    integer   i_vco_center;
    integer   i_pfd_min;
    integer   i_pfd_max;
    integer   i_l0_ph;
    integer   i_l1_ph;
    integer   i_g0_ph;
    integer   i_g1_ph;
    integer   i_g2_ph;
    integer   i_g3_ph;
    integer   i_e0_ph;
    integer   i_e1_ph;
    integer   i_e2_ph;
    integer   i_e3_ph;
    integer   i_m_ph;
    integer   m_ph_val;
    integer   i_l0_time_delay;
    integer   i_l1_time_delay;
    integer   i_g0_time_delay;
    integer   i_g1_time_delay;
    integer   i_g2_time_delay;
    integer   i_g3_time_delay;
    integer   i_e0_time_delay;
    integer   i_e1_time_delay;
    integer   i_e2_time_delay;
    integer   i_e3_time_delay;
    integer   i_m_time_delay;
    integer   i_n_time_delay;
    integer   i_extclk3_counter;
    integer   i_extclk2_counter;
    integer   i_extclk1_counter;
    integer   i_extclk0_counter;
    integer   i_clk5_counter;
    integer   i_clk4_counter;
    integer   i_clk3_counter;
    integer   i_clk2_counter;
    integer   i_clk1_counter;
    integer   i_clk0_counter;
    integer   i_charge_pump_current;
    integer   i_loop_filter_r;
    integer   max_neg_abs;
    integer   output_count;
    integer   new_divisor;

    // uppercase to lowercase parameter values
    reg [8*`WORD_LENGTH:1] l_operation_mode;
    reg [8*`WORD_LENGTH:1] l_pll_type;
    reg [8*`WORD_LENGTH:1] l_qualify_conf_done;
    reg [8*`WORD_LENGTH:1] l_compensate_clock;
    reg [8*`WORD_LENGTH:1] l_scan_chain;
    reg [8*`WORD_LENGTH:1] l_primary_clock;
    reg [8*`WORD_LENGTH:1] l_gate_lock_signal;
    reg [8*`WORD_LENGTH:1] l_switch_over_on_lossclk;
    reg [8*`WORD_LENGTH:1] l_switch_over_on_gated_lock;
    reg [8*`WORD_LENGTH:1] l_enable_switch_over_counter;
    reg [8*`WORD_LENGTH:1] l_feedback_source;
    reg [8*`WORD_LENGTH:1] l_bandwidth_type;
    reg [8*`WORD_LENGTH:1] l_simulation_type;
//    reg [8*`WORD_LENGTH:1] l_source_is_pll;
    reg [8*`WORD_LENGTH:1] l_enable0_counter;
    reg [8*`WORD_LENGTH:1] l_enable1_counter;

    reg init;

    specify
    endspecify

    function integer abs;
    input value;
    integer value;
    begin
       if (value < 0)
          abs = value * -1;
       else abs = value;
    end
    endfunction

    // find twice the period of the slowest clock
    function integer slowest_clk;
    input L0, L1, G0, G1, G2, G3, E0, E1, E2, E3, scan_chain, refclk, m_mod;
    integer L0, L1, G0, G1, G2, G3, E0, E1, E2, E3;
    reg [8*5:1] scan_chain;
    integer refclk;
    reg [31:0] m_mod;
    integer max_modulus;
    begin
       if (L0 > L1)
           max_modulus = L0;
       else
           max_modulus = L1;
       if (G0 > max_modulus)
           max_modulus = G0;
       if (G1 > max_modulus)
           max_modulus = G1;
       if (G2 > max_modulus)
           max_modulus = G2;
       if (G3 > max_modulus)
           max_modulus = G3;
       if (scan_chain == "long")
       begin
          if (E0 > max_modulus)
              max_modulus = E0;
          if (E1 > max_modulus)
              max_modulus = E1;
          if (E2 > max_modulus)
              max_modulus = E2;
          if (E3 > max_modulus)
              max_modulus = E3;
       end

       slowest_clk = ((refclk/m_mod) * max_modulus *2);
    end
    endfunction

    // find the greatest common denominator of X and Y
    function integer gcd;
    input X,Y;
    integer X,Y;
    integer L, S, R, G;
    begin
        if (X < Y) // find which is smaller.
        begin
            S = X;
            L = Y;
        end
        else
        begin
            S = Y;
            L = X;
        end

        R = S;
        while ( R > 1)
        begin
            S = L;
            L = R;
            R = S % L; // divide bigger number by smaller.
                       // remainder becomes smaller number.
        end
        if (R == 0)    // if evenly divisible then L is gcd else it is 1.
            G = L;
        else
            G = R;
        gcd = G;
    end
    endfunction

    // find the least common multiple of A1 to A10
    function integer lcm;
    input A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, P;
    integer A1, A2, A3, A4, A5, A6, A7, A8, A9, A10, P;
    integer M1, M2, M3, M4, M5 , M6, M7, M8, M9, R;
    begin
        M1 = (A1 * A2)/gcd(A1, A2);
        M2 = (M1 * A3)/gcd(M1, A3);
        M3 = (M2 * A4)/gcd(M2, A4);
        M4 = (M3 * A5)/gcd(M3, A5);
        M5 = (M4 * A6)/gcd(M4, A6);
        M6 = (M5 * A7)/gcd(M5, A7);
        M7 = (M6 * A8)/gcd(M6, A8);
        M8 = (M7 * A9)/gcd(M7, A9);
        M9 = (M8 * A10)/gcd(M8, A10);
        if (M9 < 3)
            R = 10;
        else if ((M9 < 10) && (M9 >= 3))
            R = 4 * M9;
        else
            R = M9;
        lcm = R; 
    end
    endfunction

    // find the factor of division of the output clock frequency
    // compared to the VCO
    function integer output_counter_value;
    input clk_divide, clk_mult, M, N;
    integer clk_divide, clk_mult, M, N;
    integer R;
    begin
        R = (clk_divide * M)/(clk_mult * N);
        output_counter_value = R;
    end
    endfunction

    // find the mode of each of the PLL counters - bypass, even or odd
    function [8*6:1] counter_mode;
    input duty_cycle;
    input output_counter_value;
    integer duty_cycle;
    integer output_counter_value;
    integer half_cycle_high;
    reg [8*6:1] R;
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
        if (output_counter_value == 1)
            R = "bypass";
        else if ((half_cycle_high % 2) == 0)
            R = "even";
        else
            R = "odd";
        counter_mode = R;
    end
    endfunction

    // find the number of VCO clock cycles to hold the output clock high
    function integer counter_high;
    input output_counter_value, duty_cycle;
    integer output_counter_value, duty_cycle;
    integer half_cycle_high;
    integer tmp_counter_high;
    integer mode;
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
        mode = ((half_cycle_high % 2) == 0);
        tmp_counter_high = half_cycle_high/2;
        counter_high = tmp_counter_high + !mode;
    end
    endfunction

    // find the number of VCO clock cycles to hold the output clock low
    function integer counter_low;
    input output_counter_value, duty_cycle;
    integer output_counter_value, duty_cycle, counter_h;
    integer half_cycle_high;
    integer mode;
    integer tmp_counter_high;
    begin
        half_cycle_high = (2*duty_cycle*output_counter_value)/100;
        mode = ((half_cycle_high % 2) == 0);
        tmp_counter_high = half_cycle_high/2;
        counter_h = tmp_counter_high + !mode;
        counter_low =  output_counter_value - counter_h;
    end
    endfunction

    // find the smallest time delay amongst t1 to t10
    function integer mintimedelay;
    input t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer m1,m2,m3,m4,m5,m6,m7,m8,m9;
    begin
        if (t1 < t2)
            m1 = t1;
        else
            m1 = t2;
        if (m1 < t3)
            m2 = m1;
        else
            m2 = t3;
        if (m2 < t4)
            m3 = m2;
        else
            m3 = t4;
        if (m3 < t5)
            m4 = m3;
        else
            m4 = t5;
        if (m4 < t6)
            m5 = m4;
        else
            m5 = t6;
        if (m5 < t7)
            m6 = m5;
        else
            m6 = t7;
        if (m6 < t8)
            m7 = m6;
        else
            m7 = t8;
        if (m7 < t9)
            m8 = m7;
        else
            m8 = t9;
        if (m8 < t10)
            m9 = m8;
        else
            m9 = t10;
        if (m9 > 0)
            mintimedelay = m9;
        else
            mintimedelay = 0;
    end
    endfunction

    // find the numerically largest negative number, and return its absolute value
    function integer maxnegabs;
    input t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer t1, t2, t3, t4, t5, t6, t7, t8, t9, t10;
    integer m1,m2,m3,m4,m5,m6,m7,m8,m9;
    begin
        if (t1 < t2) m1 = t1; else m1 = t2;
        if (m1 < t3) m2 = m1; else m2 = t3;
        if (m2 < t4) m3 = m2; else m3 = t4;
        if (m3 < t5) m4 = m3; else m4 = t5;
        if (m4 < t6) m5 = m4; else m5 = t6;
        if (m5 < t7) m6 = m5; else m6 = t7;
        if (m6 < t8) m7 = m6; else m7 = t8;
        if (m7 < t9) m8 = m7; else m8 = t9;
        if (m8 < t10) m9 = m8; else m9 = t10;
        maxnegabs = (m9 < 0) ? 0 - m9 : 0;
    end
    endfunction

    // adjust the given tap_phase by adding the largest negative number (ph_base) 
    function integer ph_adjust;
    input tap_phase, ph_base;
    integer tap_phase, ph_base;
    begin
        ph_adjust = tap_phase + ph_base;
    end
    endfunction

    // find the actual time delay for each PLL counter
    function integer counter_time_delay;
    input clk_time_delay, m_time_delay, n_time_delay;
    integer clk_time_delay, m_time_delay, n_time_delay;
    begin
        counter_time_delay = clk_time_delay + m_time_delay - n_time_delay;
    end
    endfunction

    // find the number of VCO clock cycles to wait initially before the first 
    // rising edge of the output clock
    function integer counter_initial;
    input tap_phase, m, n;
    integer tap_phase, m, n, phase;
    begin
        if (tap_phase < 0) tap_phase = 0 - tap_phase;
        // adding 0.5 for rounding correction (required in order to round
        // to the nearest integer instead of truncating)
        phase = ((tap_phase * m) / (360 * n)) + 0.5;
        counter_initial = phase;
    end
    endfunction

    // find which VCO phase tap to align the rising edge of the output clock to
    function integer counter_ph;
    input tap_phase;
    input m,n;
    integer m,n, phase;
    integer tap_phase;
    begin
    // adding 0.5 for rounding correction
        phase = (tap_phase * m / n) + 0.5;
        counter_ph = (phase % 360)/45;
    end
    endfunction

    // convert the given string to length 6 by padding with spaces
    function [8*6:1] translate_string;
    input mode;
    reg [8*6:1] new_mode;
    begin
        if (mode == "bypass")
           new_mode = "bypass";
        else if (mode == "even")
            new_mode = "  even";
        else if (mode == "odd")
            new_mode = "   odd";

        translate_string = new_mode;
    end
    endfunction

    // convert string to integer with sign
    function integer str2int; 
    input [8*16:1] s;

    reg [8*16:1] reg_s;
    reg [8:1] digit;
    reg [8:1] tmp;
    integer m, magnitude;
    integer sign;

    begin
        sign = 1;
        magnitude = 0;
        reg_s = s;
        for (m=1; m<=16; m=m+1)
        begin
            tmp = reg_s[128:121];
            digit = tmp & 8'b00001111;
            reg_s = reg_s << 8;
            // Accumulate ascii digits 0-9 only.
            if ((tmp>=48) && (tmp<=57)) 
                magnitude = (magnitude * 10) + digit;
            if (tmp == 45)
                sign = -1;  // Found a '-' character, i.e. number is negative.
        end
        str2int = sign*magnitude;
    end
    endfunction

    // this is for cyclone lvds only
    // convert phase delay to integer
    function integer get_int_phase_shift; 
    input [8*16:1] s;
    input i_phase_shift;
    integer i_phase_shift;

    begin
        if (i_phase_shift != 0)
        begin                   
            get_int_phase_shift = i_phase_shift;
        end       
        else
        begin
            get_int_phase_shift = str2int(s);
        end        
    end
    endfunction

    // calculate the given phase shift (in ps) in terms of degrees
    function integer get_phase_degree; 
    input phase_shift;
    integer phase_shift, result;
    begin
        result = (phase_shift * 360) / inclk0_input_frequency;
        // this is to round up the calculation result
        if ( result > 0 )
            result = result + 1;
        else if ( result < 0 )
            result = result - 1;
        else
            result = 0;

        // assign the rounded up result
        get_phase_degree = result;
    end
    endfunction

    // convert uppercase parameter values to lowercase
    // assumes that the maximum character length of a parameter is 18
    function [8*`WORD_LENGTH:1] alpha_tolower;
    input [8*`WORD_LENGTH:1] given_string;

    reg [8*`WORD_LENGTH:1] return_string;
    reg [8*`WORD_LENGTH:1] reg_string;
    reg [8:1] tmp;
    reg [8:1] conv_char;
    integer byte_count;
    begin
        return_string = "                    "; // initialise strings to spaces
        conv_char = "        ";
        reg_string = given_string;
        for (byte_count = `WORD_LENGTH; byte_count >= 1; byte_count = byte_count - 1)
        begin
            tmp = reg_string[8*`WORD_LENGTH:(8*(`WORD_LENGTH-1)+1)];
            reg_string = reg_string << 8;
            if ((tmp >= 65) && (tmp <= 90)) // ASCII number of 'A' is 65, 'Z' is 90
            begin
                conv_char = tmp + 32; // 32 is the difference in the position of 'A' and 'a' in the ASCII char set
                return_string = {return_string, conv_char};
            end
            else
                return_string = {return_string, tmp};
        end
    
        alpha_tolower = return_string;
    end
    endfunction

    initial
    begin

        // convert string parameter values from uppercase to lowercase,
        // as expected in this model
        l_operation_mode             = alpha_tolower(operation_mode);
        l_pll_type                   = alpha_tolower(pll_type);
        l_qualify_conf_done          = alpha_tolower(qualify_conf_done);
        l_compensate_clock           = alpha_tolower(compensate_clock);
        l_scan_chain                 = alpha_tolower(scan_chain);
        l_primary_clock              = alpha_tolower(primary_clock);
        l_gate_lock_signal           = alpha_tolower(gate_lock_signal);
        l_switch_over_on_lossclk     = alpha_tolower(switch_over_on_lossclk);
        l_switch_over_on_gated_lock  = alpha_tolower(switch_over_on_gated_lock);
        l_enable_switch_over_counter = alpha_tolower(enable_switch_over_counter);
        l_feedback_source            = alpha_tolower(feedback_source);
        l_bandwidth_type             = alpha_tolower(bandwidth_type);
        l_simulation_type            = alpha_tolower(simulation_type);
//        l_source_is_pll              = alpha_tolower(source_is_pll);
        l_enable0_counter            = alpha_tolower(enable0_counter);
        l_enable1_counter            = alpha_tolower(enable1_counter);

        if (m == 0)
        begin 
            // convert user parameters to advanced
            i_n = 1;
            i_m = lcm (clk0_multiply_by, clk1_multiply_by,
                       clk2_multiply_by, clk3_multiply_by,
                       clk4_multiply_by, clk5_multiply_by,
                       extclk0_multiply_by,
                       extclk1_multiply_by, extclk2_multiply_by,
                       extclk3_multiply_by, inclk0_input_frequency);
            i_m_time_delay = maxnegabs(str2int(clk0_time_delay),
                                     str2int(clk1_time_delay),
                                     str2int(clk2_time_delay),
                                     str2int(clk3_time_delay),
                                     str2int(clk4_time_delay),
                                     str2int(clk5_time_delay),
                                     str2int(extclk0_time_delay),
                                     str2int(extclk1_time_delay),
                                     str2int(extclk2_time_delay),
                                     str2int(extclk3_time_delay));
            i_n_time_delay = mintimedelay(str2int(clk0_time_delay),
                                     str2int(clk1_time_delay),
                                     str2int(clk2_time_delay),
                                     str2int(clk3_time_delay),
                                     str2int(clk4_time_delay),
                                     str2int(clk5_time_delay),
                                     str2int(extclk0_time_delay),
                                     str2int(extclk1_time_delay),
                                     str2int(extclk2_time_delay),
                                     str2int(extclk3_time_delay));
            i_g0_high = counter_high(output_counter_value(clk0_divide_by,
                        clk0_multiply_by, i_m, i_n), clk0_duty_cycle);
            i_g1_high = counter_high(output_counter_value(clk1_divide_by,
                        clk1_multiply_by, i_m, i_n), clk1_duty_cycle);
            i_g2_high = counter_high(output_counter_value(clk2_divide_by,
                        clk2_multiply_by, i_m, i_n), clk2_duty_cycle);
            i_g3_high = counter_high(output_counter_value(clk3_divide_by,
                        clk3_multiply_by, i_m, i_n), clk3_duty_cycle);
            i_l0_high = counter_high(output_counter_value(clk4_divide_by,
                        clk4_multiply_by,  i_m, i_n), clk4_duty_cycle);
            i_l1_high = counter_high(output_counter_value(clk5_divide_by,
                        clk5_multiply_by,  i_m, i_n), clk5_duty_cycle);
            i_e0_high = counter_high(output_counter_value(extclk0_divide_by,
                        extclk0_multiply_by,  i_m, i_n), extclk0_duty_cycle);
            i_e1_high = counter_high(output_counter_value(extclk1_divide_by,
                        extclk1_multiply_by,  i_m, i_n), extclk1_duty_cycle);
            i_e2_high = counter_high(output_counter_value(extclk2_divide_by,
                        extclk2_multiply_by,  i_m, i_n), extclk2_duty_cycle);
            i_e3_high = counter_high(output_counter_value(extclk3_divide_by,
                        extclk3_multiply_by,  i_m, i_n), extclk3_duty_cycle);
            i_g0_low  = counter_low(output_counter_value(clk0_divide_by,
                        clk0_multiply_by,  i_m, i_n), clk0_duty_cycle);
            i_g1_low  = counter_low(output_counter_value(clk1_divide_by,
                        clk1_multiply_by,  i_m, i_n), clk1_duty_cycle);
            i_g2_low  = counter_low(output_counter_value(clk2_divide_by,
                        clk2_multiply_by,  i_m, i_n), clk2_duty_cycle);
            i_g3_low  = counter_low(output_counter_value(clk3_divide_by,
                        clk3_multiply_by,  i_m, i_n), clk3_duty_cycle);
            i_l0_low  = counter_low(output_counter_value(clk4_divide_by,
                        clk4_multiply_by,  i_m, i_n), clk4_duty_cycle);
            i_l1_low  = counter_low(output_counter_value(clk5_divide_by,
                        clk5_multiply_by,  i_m, i_n), clk5_duty_cycle);
            i_e0_low  = counter_low(output_counter_value(extclk0_divide_by,
                        extclk0_multiply_by,  i_m, i_n), extclk0_duty_cycle);
            i_e1_low  = counter_low(output_counter_value(extclk1_divide_by,
                        extclk1_multiply_by,  i_m, i_n), extclk1_duty_cycle);
            i_e2_low  = counter_low(output_counter_value(extclk2_divide_by,
                        extclk2_multiply_by,  i_m, i_n), extclk2_duty_cycle);
            i_e3_low  = counter_low(output_counter_value(extclk3_divide_by,
                        extclk3_multiply_by,  i_m, i_n), extclk3_duty_cycle);
            max_neg_abs = maxnegabs( get_int_phase_shift(clk0_phase_shift, clk0_phase_shift_num),
                                     get_int_phase_shift(clk1_phase_shift, clk1_phase_shift_num),
                                     get_int_phase_shift(clk2_phase_shift, clk2_phase_shift_num),
                                     str2int(clk3_phase_shift),
                                     str2int(clk4_phase_shift),
                                     str2int(clk5_phase_shift),
                                     str2int(extclk0_phase_shift),
                                     str2int(extclk1_phase_shift),
                                     str2int(extclk2_phase_shift),
                                     str2int(extclk3_phase_shift));
            i_g0_initial = counter_initial(get_phase_degree(ph_adjust(get_int_phase_shift(clk0_phase_shift, clk0_phase_shift_num), max_neg_abs)), i_m, i_n);
            i_g1_initial = counter_initial(get_phase_degree(ph_adjust(get_int_phase_shift(clk1_phase_shift, clk1_phase_shift_num), max_neg_abs)), i_m, i_n);
            i_g2_initial = counter_initial(get_phase_degree(ph_adjust(get_int_phase_shift(clk2_phase_shift, clk2_phase_shift_num), max_neg_abs)), i_m, i_n);
            i_g3_initial = counter_initial(get_phase_degree(ph_adjust(str2int(clk3_phase_shift), max_neg_abs)), i_m, i_n);
            i_l0_initial = counter_initial(get_phase_degree(ph_adjust(str2int(clk4_phase_shift), max_neg_abs)), i_m, i_n);
            i_l1_initial = counter_initial(get_phase_degree(ph_adjust(str2int(clk5_phase_shift), max_neg_abs)), i_m, i_n);
            i_e0_initial = counter_initial(get_phase_degree(ph_adjust(str2int(extclk0_phase_shift), max_neg_abs)), i_m, i_n);
            i_e1_initial = counter_initial(get_phase_degree(ph_adjust(str2int(extclk1_phase_shift), max_neg_abs)), i_m, i_n);
            i_e2_initial = counter_initial(get_phase_degree(ph_adjust(str2int(extclk2_phase_shift), max_neg_abs)), i_m, i_n);
            i_e3_initial = counter_initial(get_phase_degree(ph_adjust(str2int(extclk3_phase_shift), max_neg_abs)), i_m, i_n);
            i_g0_mode = counter_mode(clk0_duty_cycle, output_counter_value(clk0_divide_by, clk0_multiply_by,  i_m, i_n));
            i_g1_mode = counter_mode(clk1_duty_cycle,output_counter_value(clk1_divide_by, clk1_multiply_by,  i_m, i_n));
            i_g2_mode = counter_mode(clk2_duty_cycle,output_counter_value(clk2_divide_by, clk2_multiply_by,  i_m, i_n));
            i_g3_mode = counter_mode(clk3_duty_cycle,output_counter_value(clk3_divide_by, clk3_multiply_by,  i_m, i_n));
            i_l0_mode = counter_mode(clk4_duty_cycle,output_counter_value(clk4_divide_by, clk4_multiply_by,  i_m, i_n));
            i_l1_mode = counter_mode(clk5_duty_cycle,output_counter_value(clk5_divide_by, clk5_multiply_by,  i_m, i_n));
            i_e0_mode = counter_mode(extclk0_duty_cycle,output_counter_value(extclk0_divide_by, extclk0_multiply_by,  i_m, i_n));
            i_e1_mode = counter_mode(extclk1_duty_cycle,output_counter_value(extclk1_divide_by, extclk1_multiply_by,  i_m, i_n));
            i_e2_mode = counter_mode(extclk2_duty_cycle,output_counter_value(extclk2_divide_by, extclk2_multiply_by,  i_m, i_n));
            i_e3_mode = counter_mode(extclk3_duty_cycle,output_counter_value(extclk3_divide_by, extclk3_multiply_by,  i_m, i_n));
            i_m_ph    = counter_ph(get_phase_degree(max_neg_abs), i_m, i_n);
            i_m_initial = counter_initial(get_phase_degree(max_neg_abs), i_m, i_n);
            i_g0_ph = counter_ph(get_phase_degree(ph_adjust(get_int_phase_shift(clk0_phase_shift, clk0_phase_shift_num),max_neg_abs)), i_m, i_n);
            i_g1_ph = counter_ph(get_phase_degree(ph_adjust(get_int_phase_shift(clk1_phase_shift, clk1_phase_shift_num),max_neg_abs)), i_m, i_n);
            i_g2_ph = counter_ph(get_phase_degree(ph_adjust(get_int_phase_shift(clk2_phase_shift, clk2_phase_shift_num),max_neg_abs)), i_m, i_n);
            i_g3_ph = counter_ph(get_phase_degree(ph_adjust(str2int(clk3_phase_shift),max_neg_abs)), i_m, i_n);
            i_l0_ph = counter_ph(get_phase_degree(ph_adjust(str2int(clk4_phase_shift),max_neg_abs)), i_m, i_n);
            i_l1_ph = counter_ph(get_phase_degree(ph_adjust(str2int(clk5_phase_shift),max_neg_abs)), i_m, i_n);
            i_e0_ph = counter_ph(get_phase_degree(ph_adjust(str2int(extclk0_phase_shift),max_neg_abs)), i_m, i_n);
            i_e1_ph = counter_ph(get_phase_degree(ph_adjust(str2int(extclk1_phase_shift),max_neg_abs)), i_m, i_n);
            i_e2_ph = counter_ph(get_phase_degree(ph_adjust(str2int(extclk2_phase_shift),max_neg_abs)), i_m, i_n);
            i_e3_ph = counter_ph(get_phase_degree(ph_adjust(str2int(extclk3_phase_shift),max_neg_abs)), i_m, i_n);

            i_g0_time_delay = counter_time_delay(str2int(clk0_time_delay),
                                                 i_m_time_delay,
                                                 i_n_time_delay);
            i_g1_time_delay = counter_time_delay(str2int(clk1_time_delay),
                                                 i_m_time_delay,
                                                 i_n_time_delay);
            i_g2_time_delay = counter_time_delay(str2int(clk2_time_delay),
                                                 i_m_time_delay,
                                                 i_n_time_delay);
            i_g3_time_delay = counter_time_delay(str2int(clk3_time_delay),
                                                 i_m_time_delay,
                                                 i_n_time_delay);
            i_l0_time_delay = counter_time_delay(str2int(clk4_time_delay),
                                                 i_m_time_delay,
                                                 i_n_time_delay);
            i_l1_time_delay = counter_time_delay(str2int(clk5_time_delay),
                                                 i_m_time_delay,
                                                 i_n_time_delay);
            i_e0_time_delay = counter_time_delay(str2int(extclk0_time_delay),
                                                 i_m_time_delay,
                                                 i_n_time_delay);
            i_e1_time_delay = counter_time_delay(str2int(extclk1_time_delay),
                                                 i_m_time_delay,
                                                 i_n_time_delay);
            i_e2_time_delay = counter_time_delay(str2int(extclk2_time_delay),
                                                 i_m_time_delay,
                                                 i_n_time_delay);
            i_e3_time_delay = counter_time_delay(str2int(extclk3_time_delay),
                                                 i_m_time_delay,
                                                 i_n_time_delay);
            i_extclk3_counter = "e3" ;
            i_extclk2_counter = "e2" ;
            i_extclk1_counter = "e1" ;
            i_extclk0_counter = "e0" ;
            i_clk5_counter    = "l1" ;
            i_clk4_counter    = "l0" ;
            i_clk3_counter    = "g3" ;
            i_clk2_counter    = "g2" ;
            i_clk1_counter    = "g1" ;
            i_clk0_counter    = "g0" ;

            // in external feedback mode, need to adjust M value to take
            // into consideration the external feedback counter value
            if (l_operation_mode == "external_feedback")
            begin
                // if there is a negative phase shift, m_initial can only be 1
                if (max_neg_abs > 0)
                    i_m_initial = 1;

                if (l_feedback_source == "extclk0")
                begin
                    if (i_e0_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e0_high + i_e0_low;
                end
                else if (l_feedback_source == "extclk1")
                begin
                    if (i_e1_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e1_high + i_e1_low;
                end
                else if (l_feedback_source == "extclk2")
                begin
                    if (i_e2_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e2_high + i_e2_low;
                end
                else if (l_feedback_source == "extclk3")
                begin
                    if (i_e3_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e3_high + i_e3_low;
                end
                else // default to e0
                begin
                    if (i_e0_mode == "bypass")
                        output_count = 1;
                    else
                        output_count = i_e0_high + i_e0_low;
                end

                if (i_m > output_count)
                    i_m = i_m / output_count;
                else
                begin
                    new_divisor = gcd(i_m, output_count);
                    i_m = i_m / new_divisor;
                    i_n = output_count / new_divisor;
                end
            end

        end
        else 
        begin //  m != 0

            i_n = n;
            i_m = m;
            i_l0_high = l0_high;
            i_l1_high = l1_high;
            i_g0_high = g0_high;
            i_g1_high = g1_high;
            i_g2_high = g2_high;
            i_g3_high = g3_high;
            i_e0_high = e0_high;
            i_e1_high = e1_high;
            i_e2_high = e2_high;
            i_e3_high = e3_high;
            i_l0_low  = l0_low;
            i_l1_low  = l1_low;
            i_g0_low  = g0_low;
            i_g1_low  = g1_low;
            i_g2_low  = g2_low;
            i_g3_low  = g3_low;
            i_e0_low  = e0_low;
            i_e1_low  = e1_low;
            i_e2_low  = e2_low;
            i_e3_low  = e3_low;
            i_l0_initial = l0_initial;
            i_l1_initial = l1_initial;
            i_g0_initial = g0_initial;
            i_g1_initial = g1_initial;
            i_g2_initial = g2_initial;
            i_g3_initial = g3_initial;
            i_e0_initial = e0_initial;
            i_e1_initial = e1_initial;
            i_e2_initial = e2_initial;
            i_e3_initial = e3_initial;
            i_l0_mode = alpha_tolower(l0_mode);
            i_l1_mode = alpha_tolower(l1_mode);
            i_g0_mode = alpha_tolower(g0_mode);
            i_g1_mode = alpha_tolower(g1_mode);
            i_g2_mode = alpha_tolower(g2_mode);
            i_g3_mode = alpha_tolower(g3_mode);
            i_e0_mode = alpha_tolower(e0_mode);
            i_e1_mode = alpha_tolower(e1_mode);
            i_e2_mode = alpha_tolower(e2_mode);
            i_e3_mode = alpha_tolower(e3_mode);
            i_l0_ph  = l0_ph;
            i_l1_ph  = l1_ph;
            i_g0_ph  = g0_ph;
            i_g1_ph  = g1_ph;
            i_g2_ph  = g2_ph;
            i_g3_ph  = g3_ph;
            i_e0_ph  = e0_ph;
            i_e1_ph  = e1_ph;
            i_e2_ph  = e2_ph;
            i_e3_ph  = e3_ph;
            i_m_ph   = m_ph;        // default
            i_m_initial = m_initial;
            i_l0_time_delay = l0_time_delay;
            i_l1_time_delay = l1_time_delay;
            i_g0_time_delay = g0_time_delay;
            i_g1_time_delay = g1_time_delay;
            i_g2_time_delay = g2_time_delay;
            i_g3_time_delay = g3_time_delay;
            i_e0_time_delay = e0_time_delay;
            i_e1_time_delay = e1_time_delay;
            i_e2_time_delay = e2_time_delay;
            i_e3_time_delay = e3_time_delay;
            i_m_time_delay  = m_time_delay;
            i_n_time_delay  = n_time_delay;
            i_extclk3_counter = alpha_tolower(extclk3_counter);
            i_extclk2_counter = alpha_tolower(extclk2_counter);
            i_extclk1_counter = alpha_tolower(extclk1_counter);
            i_extclk0_counter = alpha_tolower(extclk0_counter);
            i_clk5_counter    = alpha_tolower(clk5_counter);
            i_clk4_counter    = alpha_tolower(clk4_counter);
            i_clk3_counter    = alpha_tolower(clk3_counter);
            i_clk2_counter    = alpha_tolower(clk2_counter);
            i_clk1_counter    = alpha_tolower(clk1_counter);
            i_clk0_counter    = alpha_tolower(clk0_counter);

        end // user to advanced conversion

        // set the scan_chain length
        if (l_scan_chain == "long")
            scan_chain_length = EGPP_SCAN_CHAIN;
        else if (l_scan_chain == "short")
            scan_chain_length = GPP_SCAN_CHAIN;

        if (l_primary_clock == "inclk0")
        begin
            refclk_period = inclk0_input_frequency * i_n;
            primary_clock_frequency = inclk0_input_frequency;
        end
        else if (l_primary_clock == "inclk1")
        begin
            refclk_period = inclk1_input_frequency * i_n;
            primary_clock_frequency = inclk1_input_frequency;
        end

        m_times_vco_period = refclk_period;
        new_m_times_vco_period = refclk_period;

        fbclk_period = 0;
        high_time = 0;
        low_time = 0;
        schedule_vco = 0;
        schedule_offset = 1;
        vco_out[7:0] = 8'b0;
        fbclk_last_value = 0;
        offset = 0;
        temp_offset = 0;
        got_first_refclk = 0;
        got_first_fbclk = 0;
        fbclk_time = 0;
        first_fbclk_time = 0;
        refclk_time = 0;
        first_schedule = 1;
        sched_time = 0;
        vco_val = 0;
        l0_got_first_rising_edge = 0;
        l1_got_first_rising_edge = 0;
        vco_l0_last_value = 0;
        l0_count = 1;
        l1_count = 1;
        l0_tmp = 0;
        l1_tmp = 0;
        gate_count = 0;
        gate_out = 0;
        initial_delay = 0;
        fbk_phase = 0;
        for (i = 0; i <= 7; i = i + 1)
        begin
           phase_shift[i] = 0;
           last_phase_shift[i] = 0;
        end
        fbk_delay = 0;
        inclk_n = 0;
        cycle_to_adjust = 0;
        m_delay = 0;
        vco_l0 = 0;
        vco_l1 = 0;
        total_pull_back = 0;
        pull_back_M = 0;
        pull_back_ext_cntr = 0;
        vco_period_was_phase_adjusted = 0;
        phase_adjust_was_scheduled = 0;
        ena_ipd_last_value = 0;
        inclk_out_of_range = 0;
        scandataout_tmp = 0;
        schedule_vco_last_value = 0;

        // set initial values for counter parameters
        m_initial_val = i_m_initial;
        m_val = i_m;
        m_time_delay_val = i_m_time_delay;
        n_val = i_n;
        n_time_delay_val = i_n_time_delay;
        m_ph_val = i_m_ph;

        m2_val = m2;
        n2_val = n2;

        if (m_val == 1)
            m_mode_val = "bypass";
        if (m2_val == 1)
            m2_mode_val = "bypass";
        if (n_val == 1)
            n_mode_val = "bypass";
        if (n2_val == 1)
            n2_mode_val = "bypass";

        if (skip_vco == "on")
        begin
            m_val = 1;
            m_initial_val = 1;
            m_time_delay_val = 0;
            m_ph_val = 0;
        end

        l0_high_val = i_l0_high;
        l0_low_val = i_l0_low;
        l0_initial_val = i_l0_initial;
        l0_mode_val = i_l0_mode;
        l0_time_delay_val = i_l0_time_delay;

        l1_high_val = i_l1_high;
        l1_low_val = i_l1_low;
        l1_initial_val = i_l1_initial;
        l1_mode_val = i_l1_mode;
        l1_time_delay_val = i_l1_time_delay;

        g0_high_val = i_g0_high;
        g0_low_val = i_g0_low;
        g0_initial_val = i_g0_initial;
        g0_mode_val = i_g0_mode;
        g0_time_delay_val = i_g0_time_delay;

        g1_high_val = i_g1_high;
        g1_low_val = i_g1_low;
        g1_initial_val = i_g1_initial;
        g1_mode_val = i_g1_mode;
        g1_time_delay_val = i_g1_time_delay;

        g2_high_val = i_g2_high;
        g2_low_val = i_g2_low;
        g2_initial_val = i_g2_initial;
        g2_mode_val = i_g2_mode;
        g2_time_delay_val = i_g2_time_delay;

        g3_high_val = i_g3_high;
        g3_low_val = i_g3_low;
        g3_initial_val = i_g3_initial;
        g3_mode_val = i_g3_mode;
        g3_time_delay_val = i_g3_time_delay;

        e0_high_val = i_e0_high;
        e0_low_val = i_e0_low;
        e0_initial_val = i_e0_initial;
        e0_mode_val = i_e0_mode;
        e0_time_delay_val = i_e0_time_delay;

        e1_high_val = i_e1_high;
        e1_low_val = i_e1_low;
        e1_initial_val = i_e1_initial;
        e1_mode_val = i_e1_mode;
        e1_time_delay_val = i_e1_time_delay;

        e2_high_val = i_e2_high;
        e2_low_val = i_e2_low;
        e2_initial_val = i_e2_initial;
        e2_mode_val = i_e2_mode;
        e2_time_delay_val = i_e2_time_delay;

        e3_high_val = i_e3_high;
        e3_low_val = i_e3_low;
        e3_initial_val = i_e3_initial;
        e3_mode_val = i_e3_mode;
        e3_time_delay_val = i_e3_time_delay;

        i = 0;
        j = 0;
        inclk_last_value = 0;

        ext_fbk_cntr_ph = 0;
        ext_fbk_cntr_initial = 1;

        // initialize clkswitch variables

        clk0_is_bad = 0;
        clk1_is_bad = 0;
        inclk0_last_value = 0;
        inclk1_last_value = 0;
        other_clock_value = 0;
        other_clock_last_value = 0;
        primary_clk_is_bad = 0;
        current_clk_is_bad = 0;
        external_switch = 0;
        current_clock = l_primary_clock;
        if (l_primary_clock == "inclk0")
           active_clock = 0;
        else
           active_clock = 1;
        clkloss_tmp = 0;
        got_curr_clk_falling_edge_after_clkswitch = 0;
        clk0_count = 0;
        clk1_count = 0;
        switch_over_count = 0;
        active_clk_was_switched = 0;

        // initialize quiet_time
        quiet_time = slowest_clk(l0_high_val+l0_low_val,
                                 l1_high_val+l1_low_val,
                                 g0_high_val+g0_low_val,
                                 g1_high_val+g1_low_val,
                                 g2_high_val+g2_low_val,
                                 g3_high_val+g3_low_val,
                                 e0_high_val+e0_low_val,
                                 e1_high_val+e1_low_val,
                                 e2_high_val+e2_low_val,
                                 e3_high_val+e3_low_val,
                                 l_scan_chain,
                                 refclk_period, m_val);
        pll_in_quiet_period = 0;
        start_quiet_time = 0; 
        quiet_period_violation = 0;
        reconfig_err = 0;
        scanclr_violation = 0;
        scanclr_clk_violation = 0;
        got_first_scanclk_after_scanclr_inactive_edge = 0;
        error = 0;
        scanaclr_rising_time = 0;
        scanaclr_falling_time = 0;

        // VCO feedback loop settings for external feedback mode
        // first find which ext counter is used for feedback

        if (l_operation_mode == "external_feedback")
        begin
           if (l_feedback_source == "extclk0")
           begin
              if (i_extclk0_counter == "e0")
                  ext_fbk_cntr = "e0";
              else if (i_extclk0_counter == "e1")
                  ext_fbk_cntr = "e1";
              else if (i_extclk0_counter == "e2")
                  ext_fbk_cntr = "e2";
              else if (i_extclk0_counter == "e3")
                  ext_fbk_cntr = "e3";
              else ext_fbk_cntr = "e0";
           end
           else if (l_feedback_source == "extclk1")
           begin
              if (i_extclk1_counter == "e0")
                  ext_fbk_cntr = "e0";
              else if (i_extclk1_counter == "e1")
                  ext_fbk_cntr = "e1";
              else if (i_extclk1_counter == "e2")
                  ext_fbk_cntr = "e2";
              else if (i_extclk1_counter == "e3")
                  ext_fbk_cntr = "e3";
              else ext_fbk_cntr = "e0";
           end
           else if (l_feedback_source == "extclk2")
           begin
              if (i_extclk2_counter == "e0")
                  ext_fbk_cntr = "e0";
              else if (i_extclk2_counter == "e1")
                  ext_fbk_cntr = "e1";
              else if (i_extclk2_counter == "e2")
                  ext_fbk_cntr = "e2";
              else if (i_extclk2_counter == "e3")
                  ext_fbk_cntr = "e3";
              else ext_fbk_cntr = "e0";
           end
           else if (l_feedback_source == "extclk3")
           begin
              if (i_extclk3_counter == "e0")
                  ext_fbk_cntr = "e0";
              else if (i_extclk3_counter == "e1")
                  ext_fbk_cntr = "e1";
              else if (i_extclk3_counter == "e2")
                  ext_fbk_cntr = "e2";
              else if (i_extclk3_counter == "e3")
                  ext_fbk_cntr = "e3";
              else ext_fbk_cntr = "e0";
           end

           // now save this counter's parameters
           if (ext_fbk_cntr == "e0")
              ext_fbk_cntr_high = e0_high_val;
           else if (ext_fbk_cntr == "e1")
              ext_fbk_cntr_high = e1_high_val;
           else if (ext_fbk_cntr == "e2")
              ext_fbk_cntr_high = e2_high_val;
           else if (ext_fbk_cntr == "e3")
              ext_fbk_cntr_high = e3_high_val;

           if (ext_fbk_cntr == "e0")
              ext_fbk_cntr_low = e0_low_val;
           else if (ext_fbk_cntr == "e1")
              ext_fbk_cntr_low = e1_low_val;
           else if (ext_fbk_cntr == "e2")
              ext_fbk_cntr_low = e2_low_val;
           else if (ext_fbk_cntr == "e3")
              ext_fbk_cntr_low = e3_low_val;

           if (ext_fbk_cntr == "e0")
              ext_fbk_cntr_ph = i_e0_ph;
           else if (ext_fbk_cntr == "e1")
              ext_fbk_cntr_ph = i_e1_ph;
           else if (ext_fbk_cntr == "e2")
              ext_fbk_cntr_ph = i_e2_ph;
           else if (ext_fbk_cntr == "e3")
              ext_fbk_cntr_ph = i_e3_ph;

           if (ext_fbk_cntr == "e0")
              ext_fbk_cntr_initial = i_e0_initial;
           else if (ext_fbk_cntr == "e1")
              ext_fbk_cntr_initial = i_e1_initial;
           else if (ext_fbk_cntr == "e2")
              ext_fbk_cntr_initial = i_e2_initial;
           else if (ext_fbk_cntr == "e3")
              ext_fbk_cntr_initial = i_e3_initial;

           if (ext_fbk_cntr == "e0")
              ext_fbk_cntr_delay = e0_time_delay_val;
           else if (ext_fbk_cntr == "e1")
              ext_fbk_cntr_delay = e1_time_delay_val;
           else if (ext_fbk_cntr == "e2")
              ext_fbk_cntr_delay = e2_time_delay_val;
           else if (ext_fbk_cntr == "e3")
              ext_fbk_cntr_delay = e3_time_delay_val;
        end

        l_index = 1;
        stop_vco = 0;
        cycles_to_lock = 0;
        cycles_to_unlock = 0;
        if (l_pll_type == "fast")
           locked_tmp = 1;
        else
           locked_tmp = 0;
        pll_is_locked = 0;
        pll_about_to_lock = 0;

        no_warn = 0;
    end

    assign inclk_m = l_operation_mode == "external_feedback" ? (l_feedback_source == "extclk0" ? extclk0_tmp :
                     l_feedback_source == "extclk1" ? extclk1_tmp :
                     l_feedback_source == "extclk2" ? extclk2_tmp :
                     l_feedback_source == "extclk3" ? extclk3_tmp : 'b0) :
                     vco_out[m_ph_val];

    m_cntr m1 (.clk(inclk_m),
                .reset(areset_ipd || (!ena_ipd) || stop_vco),
                .cout(fbclk),
                .initial_value(m_initial_val),
                .modulus(m_val),
                .time_delay(m_delay));

    always @(clkswitch_ipd)
    begin
       if (clkswitch_ipd == 1'b1)
          external_switch = 1;
    end

    always @(inclk0_ipd or inclk1_ipd)
    begin
        // save the inclk event value
        if (inclk0_ipd !== inclk0_last_value)
        begin
            if (current_clock !== "inclk0")
                other_clock_value = inclk0_ipd;
        end
        if (inclk1_ipd !== inclk1_last_value)
        begin
            if (current_clock !== "inclk1")
                other_clock_value = inclk1_ipd;
        end

        // check if either input clk is bad
        if (inclk0_ipd === 1'b1 && inclk0_ipd !== inclk0_last_value)
        begin
            clk0_count = clk0_count + 1;
            clk0_is_bad = 0;
            clk1_count = 0;
            if (clk0_count > 2)
            begin
               // no event on other clk for 2 cycles
               clk1_is_bad = 1;
               if (current_clock == "inclk1")
                  current_clk_is_bad = 1;
            end
        end
        if (inclk1_ipd === 1'b1 && inclk1_ipd !== inclk1_last_value)
        begin
            clk1_count = clk1_count + 1;
            clk1_is_bad = 0;
            clk0_count = 0;
            if (clk1_count > 2)
            begin
               // no event on other clk for 2 cycles
               clk0_is_bad = 1;
               if (current_clock == "inclk0")
                  current_clk_is_bad = 1;
            end
        end

        // check if the bad clk is the primary clock
        if (((l_primary_clock == "inclk0") && (clk0_is_bad == 1'b1)) || ((l_primary_clock == "inclk1") && (clk1_is_bad == 1'b1)))
           primary_clk_is_bad = 1;
        else
           primary_clk_is_bad = 0;

        // actual switching
        if ((inclk0_ipd !== inclk0_last_value) && current_clock == "inclk0")
        begin
           if (external_switch == 1'b1)
           begin
              if (!got_curr_clk_falling_edge_after_clkswitch)
              begin
                 if (inclk0_ipd === 1'b0)
                    got_curr_clk_falling_edge_after_clkswitch = 1;
                 inclk_n = inclk0_ipd;
              end
           end
           else inclk_n = inclk0_ipd;
        end
        if ((inclk1_ipd !== inclk1_last_value) && current_clock == "inclk1")
        begin
           if (external_switch == 1'b1)
           begin
              if (!got_curr_clk_falling_edge_after_clkswitch)
              begin
                 if (inclk1_ipd === 1'b0)
                    got_curr_clk_falling_edge_after_clkswitch = 1;
                 inclk_n = inclk1_ipd;
              end
           end
           else inclk_n = inclk1_ipd;
        end
        if ((other_clock_value == 1'b1) && (other_clock_value != other_clock_last_value) && (l_switch_over_on_lossclk == "on") && l_enable_switch_over_counter == "on" && primary_clk_is_bad)
            switch_over_count = switch_over_count + 1;
        if ((other_clock_value == 1'b0) && (other_clock_value != other_clock_last_value))
        begin
            if ((external_switch && (got_curr_clk_falling_edge_after_clkswitch || current_clk_is_bad)) || (l_switch_over_on_lossclk == "on" && primary_clk_is_bad && ((l_enable_switch_over_counter == "off" || switch_over_count == switch_over_counter))))
            begin
                got_curr_clk_falling_edge_after_clkswitch = 0;
                if (current_clock == "inclk0")
                   current_clock = "inclk1";
                else
                   current_clock = "inclk0";
                active_clock = ~active_clock;
                active_clk_was_switched = 1;
                switch_over_count = 0;
                external_switch = 0;
                current_clk_is_bad = 0;
            end
        end

        if (l_switch_over_on_lossclk == "on" && (clkswitch_ipd != 1'b1))
        begin
           if (primary_clk_is_bad)
              clkloss_tmp = 1;
           else
              clkloss_tmp = 0;
        end
        else clkloss_tmp = clkswitch_ipd;

        inclk0_last_value = inclk0_ipd;
        inclk1_last_value = inclk1_ipd;
        other_clock_last_value = other_clock_value;

    end

    and (clkbad[0], clk0_is_bad, 1'b1);
    and (clkbad[1], clk1_is_bad, 1'b1);
    and (activeclock, active_clock, 1'b1);
    and (clkloss, clkloss_tmp, 1'b1);

    n_cntr n1 (.clk(inclk_n),
//               .reset(1'b0),
               .reset(areset_ipd),
               .cout(refclk),
               .modulus(n_val),
               .time_delay(n_time_delay_val)
              );

    scale_cntr l0 (.clk(vco_out[i_l0_ph]),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(l0_clk),
                   .high(l0_high_val),
                   .low(l0_low_val),
                   .initial_value(l0_initial_val),
                   .mode(l0_mode_val),
                   .time_delay(l0_time_delay_val),
                   .ph_tap(i_l0_ph)
                  );

    scale_cntr l1 (.clk(vco_out[i_l1_ph]),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(l1_clk),
                   .high(l1_high_val),
                   .low(l1_low_val),
                   .initial_value(l1_initial_val),
                   .mode(l1_mode_val),
                   .time_delay(l1_time_delay_val),
                   .ph_tap(i_l1_ph)
                  );

    scale_cntr g0 (.clk(vco_out[i_g0_ph]),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(g0_clk),
                   .high(g0_high_val),
                   .low(g0_low_val),
                   .initial_value(g0_initial_val),
                   .mode(g0_mode_val),
                   .time_delay(g0_time_delay_val),
                   .ph_tap(i_g0_ph)
                  );

    pll_reg lvds_dffa (.d(comparator_ipd),
                       .clrn(1'b1),
                       .prn(1'b1),
                       .ena(1'b1),
                       .clk(g0_clk),
                       .q(dffa_out)
                      );

    pll_reg lvds_dffb (.d(dffa_out),
                       .clrn(1'b1),
                       .prn(1'b1),
                       .ena(1'b1),
                       .clk(lvds_dffb_clk),
                       .q(dffb_out)
                      );

    assign lvds_dffb_clk = (l_enable0_counter == "l0") ? l0_clk : (l_enable0_counter == "l1") ? l1_clk : 1'b0;

    pll_reg lvds_dffc (.d(dffb_out),
                       .clrn(1'b1),
                       .prn(1'b1),
                       .ena(1'b1),
                       .clk(lvds_dffc_clk),
                       .q(dffc_out)
                      );

    assign lvds_dffc_clk = (l_enable0_counter == "l0") ? l0_clk : (l_enable0_counter == "l1") ? l1_clk : 1'b0;

    assign nce_temp = ~dffc_out && dffb_out;

    pll_reg lvds_dffd (.d(nce_temp),
                       .clrn(1'b1),
                       .prn(1'b1),
                       .ena(1'b1),
                       .clk(~lvds_dffd_clk),
                       .q(dffd_out)
                      );

    assign lvds_dffd_clk = (l_enable0_counter == "l0") ? l0_clk : (l_enable0_counter == "l1") ? l1_clk : 1'b0;

    assign nce_l0 = (l_enable0_counter == "l0") ? dffd_out : 'b0;
    assign nce_l1 = (l_enable0_counter == "l1") ? dffd_out : 'b0;

    scale_cntr g1 (.clk(vco_out[i_g1_ph]),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(g1_clk),
                   .high(g1_high_val),
                   .low(g1_low_val),
                   .initial_value(g1_initial_val),
                   .mode(g1_mode_val),
                   .time_delay(g1_time_delay_val),
                   .ph_tap(i_g1_ph)
                  );

    scale_cntr g2 (.clk(vco_out[i_g2_ph]),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(g2_clk),
                   .high(g2_high_val),
                   .low(g2_low_val),
                   .initial_value(g2_initial_val),
                   .mode(g2_mode_val),
                   .time_delay(g2_time_delay_val),
                   .ph_tap(i_g2_ph)
                  );

    scale_cntr g3 (.clk(vco_out[i_g3_ph]),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(g3_clk),
                   .high(g3_high_val),
                   .low(g3_low_val),
                   .initial_value(g3_initial_val),
                   .mode(g3_mode_val),
                   .time_delay(g3_time_delay_val),
                   .ph_tap(i_g3_ph)
                  );
    assign cntr_e0_initial = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e0") ? 1 : e0_initial_val;
    assign cntr_e0_delay = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e0") ? ext_fbk_delay : e0_time_delay_val;

    scale_cntr e0 (.clk(vco_out[i_e0_ph]),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(e0_clk),
                   .high(e0_high_val),
                   .low(e0_low_val),
                   .initial_value(cntr_e0_initial),
                   .mode(e0_mode_val),
                   .time_delay(cntr_e0_delay),
                   .ph_tap(i_e0_ph)
                  );

    assign cntr_e1_initial = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e1") ? 1 : e1_initial_val;
    assign cntr_e1_delay = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e1") ? ext_fbk_delay : e1_time_delay_val;
    scale_cntr e1 (.clk(vco_out[i_e1_ph]),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(e1_clk),
                   .high(e1_high_val),
                   .low(e1_low_val),
                   .initial_value(cntr_e1_initial),
                   .mode(e1_mode_val),
                   .time_delay(cntr_e1_delay),
                   .ph_tap(i_e1_ph)
                  );

    assign cntr_e2_initial = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e2") ? 1 : e2_initial_val;
    assign cntr_e2_delay = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e2") ? ext_fbk_delay : e2_time_delay_val;
    scale_cntr e2 (.clk(vco_out[i_e2_ph]),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(e2_clk),
                   .high(e2_high_val),
                   .low(e2_low_val),
                   .initial_value(cntr_e2_initial),
                   .mode(e2_mode_val),
                   .time_delay(cntr_e2_delay),
                   .ph_tap(i_e2_ph)
                  );

    assign cntr_e3_initial = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e3") ? 1 : e3_initial_val;
    assign cntr_e3_delay = (l_operation_mode == "external_feedback" && ext_fbk_cntr == "e3") ? ext_fbk_delay : e3_time_delay_val;
    scale_cntr e3 (.clk(vco_out[i_e3_ph]),
                   .reset(areset_ipd || (!ena_ipd) || stop_vco),
                   .cout(e3_clk),
                   .high(e3_high_val),
                   .low(e3_low_val),
                   .initial_value(cntr_e3_initial),
                   .mode(e3_mode_val),
                   .time_delay(cntr_e3_delay),
                   .ph_tap(i_e3_ph)
                  );


    always @(vco_out[i_l0_ph] or posedge areset_ipd or negedge ena_ipd or stop_vco)
    begin
        if (areset_ipd == 1'b1 || ena_ipd == 1'b0 || stop_vco == 1'b1)
        begin
            l0_count = 1;
            l0_got_first_rising_edge = 0;
        end
        else begin
            if (nce_l0 == 1'b0)
            begin
                if (l0_got_first_rising_edge == 1'b0)
                begin
                    if (vco_out[i_l0_ph] == 1'b1 && vco_out[i_l0_ph] != vco_l0_last_value)
                        l0_got_first_rising_edge = 1;
                end
                else if (vco_out[i_l0_ph] != vco_l0_last_value)
                begin
                    l0_count = l0_count + 1;
                    if (l0_count == (l0_high_val + l0_low_val) * 2)
                        l0_count  = 1;
                end
            end
            if (vco_out[i_l0_ph] == 1'b0 && vco_out[i_l0_ph] != vco_l0_last_value)
            begin
                if (l0_count == 1)
                begin
                    l0_tmp = 1;
                    l0_got_first_rising_edge = 0;
                end
                else l0_tmp = 0;
            end
        end
        vco_l0_last_value = vco_out[i_l0_ph];
    end

    always @(vco_out[i_l1_ph] or posedge areset_ipd or negedge ena_ipd or stop_vco)
    begin
        if (areset_ipd == 1'b1 || ena_ipd == 1'b0 || stop_vco == 1'b1)
        begin
            l1_count = 1;
            l1_got_first_rising_edge = 0;
        end
        else begin
            if (nce_l1 == 1'b0)
            begin
                if (l1_got_first_rising_edge == 1'b0)
                begin
                    if (vco_out[i_l1_ph] == 1'b1 && vco_out[i_l1_ph] != vco_l1_last_value)
                        l1_got_first_rising_edge = 1;
                end
                else if (vco_out[i_l1_ph] != vco_l1_last_value)
                begin
                    l1_count = l1_count + 1;
                    if (l1_count == (l1_high_val + l1_low_val) * 2)
                        l1_count  = 1;
                end
            end
            if (vco_out[i_l1_ph] == 1'b0 && vco_out[i_l1_ph] != vco_l1_last_value)
            begin
                if (l1_count == 1)
                begin
                    l1_tmp = 1;
                    l1_got_first_rising_edge = 0;
                end
                else l1_tmp = 0;
            end
        end
        vco_l1_last_value = vco_out[i_l1_ph];
    end

    assign enable0_tmp = (l_enable0_counter == "l0") ? l0_tmp : l1_tmp;
    assign enable1_tmp = (l_enable1_counter == "l0") ? l0_tmp : l1_tmp;

    always @ (inclk_n or ena_ipd or areset_ipd)
    begin
       if (areset_ipd == 'b1)
       begin
           gate_count = 0;
           gate_out = 0; 
       end
       else if (inclk_n == 'b1 && inclk_last_value != inclk_n)
           if (ena_ipd == 'b1)
           begin
               gate_count = gate_count + 1;
               if (gate_count == gate_lock_counter)
                   gate_out = 1;
           end
       inclk_last_value = inclk_n;
    end

    assign locked = (l_gate_lock_signal == "yes") ? gate_out && locked_tmp : locked_tmp;

    always @ (scanclk_ipd or scanaclr_ipd)
    begin
        if (scanaclr_ipd === 1'b1 && scanaclr_last_value === 1'b0)
            scanaclr_rising_time = $time;
        else if (scanaclr_ipd === 1'b0 && scanaclr_last_value === 1'b1)
        begin
            scanaclr_falling_time = $time;
            // check for scanaclr active pulse width
            if ($time - scanaclr_rising_time < TRST)
            begin
                scanclr_violation = 1;
                $display ("Warning : Detected SCANACLR ACTIVE pulse width violation. Required is 5000 ps, actual is %0t. Reconfiguration may not work.", $time - scanaclr_rising_time);
                $display ("Time: %0t  Instance: %m", $time);
            end
            else begin
                scanclr_violation = 0;
                for (i = 0; i <= scan_chain_length; i = i + 1)
                   scan_data[i] = 0;
            end
            got_first_scanclk_after_scanclr_inactive_edge = 0;
        end
        else if ((scanclk_ipd === 'b1 && scanclk_last_value !== scanclk_ipd) && (got_first_scanclk_after_scanclr_inactive_edge === 1'b0) && ($time - scanaclr_falling_time < TRSTCLK))
        begin
            scanclr_clk_violation = 1;
            $display ("Warning : Detected SCANACLR INACTIVE time violation before rising edge of SCANCLK. Required is 5000 ps, actual is %0t. Reconfiguration may not work.", $time - scanaclr_falling_time);
            $display ("Time: %0t  Instance: %m", $time);
            got_first_scanclk_after_scanclr_inactive_edge = 1;
        end
        else if (scanclk_ipd == 'b1 && scanclk_last_value != scanclk_ipd && scanaclr_ipd === 1'b0)
        begin
            if (pll_in_quiet_period && ($time - start_quiet_time < quiet_time))
            begin
                $display("Time: %0t", $time, "   Warning : Detected transition on SCANCLK during quiet time. PLL may not function correctly."); 
                quiet_period_violation = 1;
            end
            else begin
                pll_in_quiet_period = 0;
                for (j = scan_chain_length-1; j >= 1; j = j - 1)
                begin
                    scan_data[j] = scan_data[j - 1];
                end
                scan_data[0] = scandata_ipd;
            end
            if (got_first_scanclk_after_scanclr_inactive_edge === 1'b0)
            begin
                got_first_scanclk_after_scanclr_inactive_edge = 1;
                scanclr_clk_violation = 0;
            end
        end
        else if (scanclk_ipd === 1'b0 && scanclk_last_value !== scanclk_ipd && scanaclr_ipd === 1'b0)
        begin
            if (pll_in_quiet_period && ($time - start_quiet_time < quiet_time))
            begin
                $display("Time: %0t", $time, "   Warning : Detected transition on SCANCLK during quiet time. PLL may not function correctly."); 
                quiet_period_violation = 1;
            end
            else if (scan_data[scan_chain_length-1] == 1'b1)
            begin
                pll_in_quiet_period = 1;
                quiet_period_violation = 0;
                reconfig_err = 0;
                start_quiet_time = $time;
                // initiate transfer
                scandataout_tmp <= 1'b1;
                quiet_time = slowest_clk(l0_high_val+l0_low_val,
                                         l1_high_val+l1_low_val,
                                         g0_high_val+g0_low_val,
                                         g1_high_val+g1_low_val,
                                         g2_high_val+g2_low_val,
                                         g3_high_val+g3_low_val,
                                         e0_high_val+e0_low_val,
                                         e1_high_val+e1_low_val,
                                         e2_high_val+e2_low_val,
                                         e3_high_val+e3_low_val,
                                         l_scan_chain,
                                         refclk_period, m_val);
                transfer = 1;
            end
        end
        scanclk_last_value = scanclk_ipd;
        scanaclr_last_value = scanaclr_ipd;
    end

    always @(scandataout_tmp)
    begin
        if (scandataout_tmp == 1'b1)
            scandataout_tmp <= #(quiet_time) 1'b0;
    end

    always @(posedge transfer)
    begin
        if (transfer == 1'b1)
        begin
            $display("NOTE : Reconfiguring PLL");
            $display ("Time: %0t  Instance: %m", $time);
            if (l_scan_chain == "long")
            begin
               // cntr e3
               error = 0;
               if (scan_data[273] == 1'b1)
               begin
                   e3_mode_val = "bypass";
                   if (scan_data[283] == 1'b1)
                   begin
                       e3_mode_val = "off";
                       $display("Warning : The specified bit settings will turn OFF the E3 counter. It cannot be turned on unless the part is re-initialized.");
                   end
               end
               else if (scan_data[283] == 1'b1)
                   e3_mode_val = "odd";
               else
                   e3_mode_val = "even";
               // before reading delay bits, clear e3_time_delay_val
               e3_time_delay_val = 32'b0;
               e3_time_delay_val = scan_data[287:284];
               e3_time_delay_val = e3_time_delay_val * 250;
               if (e3_time_delay_val > 3000)
                   e3_time_delay_val = 3000;
               e3_high_val[8:0] = scan_data[272:264];
               e3_low_val[8:0] = scan_data[282:274];
               if (e3_high_val[8:0] == 9'b000000000)
                   e3_high_val[9:0] = 10'b1000000000;
               if (e3_low_val[8:0] == 9'b000000000)
                   e3_low_val[9:0] = 10'b1000000000;

               if (ext_fbk_cntr == "e3")
               begin
                   ext_fbk_cntr_high = e3_high_val;
                   ext_fbk_cntr_low = e3_low_val;
                   ext_fbk_cntr_delay = e3_time_delay_val;
               end

               // cntr e2
               if (scan_data[249] == 1'b1)
               begin
                   e2_mode_val = "bypass";
                   if (scan_data[259] == 1'b1)
                   begin
                       e2_mode_val = "off";
                       $display("Warning : The specified bit settings will turn OFF the E2 counter. It cannot be turned on unless the part is re-initialized.");
                   end
               end
               else if (scan_data[259] == 1'b1)
                   e2_mode_val = "odd";
               else
                   e2_mode_val = "even";
               e2_time_delay_val = 32'b0;
               e2_time_delay_val = scan_data[263:260];
               e2_time_delay_val = e2_time_delay_val * 250;
               if (e2_time_delay_val > 3000)
                   e2_time_delay_val = 3000;
               e2_high_val[8:0] = scan_data[248:240];
               e2_low_val[8:0] = scan_data[258:250];
               if (e2_high_val[8:0] == 9'b000000000)
                   e2_high_val[9:0] = 10'b1000000000;
               if (e2_low_val[8:0] == 9'b000000000)
                   e2_low_val[9:0] = 10'b1000000000;

               if (ext_fbk_cntr == "e2")
               begin
                   ext_fbk_cntr_high = e2_high_val;
                   ext_fbk_cntr_low = e2_low_val;
                   ext_fbk_cntr_delay = e2_time_delay_val;
               end

               // cntr e1
               if (scan_data[225] == 1'b1)
               begin
                   e1_mode_val = "bypass";
                   if (scan_data[235] == 1'b1)
                   begin
                       e1_mode_val = "off";
                       $display("Warning : The specified bit settings will turn OFF the E1 counter. It cannot be turned on unless the part is re-initialized.");
                   end
               end
               else if (scan_data[235] == 1'b1)
                   e1_mode_val = "odd";
               else
                   e1_mode_val = "even";
               e1_time_delay_val = 32'b0;
               e1_time_delay_val = scan_data[239:236];
               e1_time_delay_val = e1_time_delay_val * 250;
               if (e1_time_delay_val > 3000)
                   e1_time_delay_val = 3000;
               e1_high_val[8:0] = scan_data[224:216];
               e1_low_val[8:0] = scan_data[234:226];
               if (e1_high_val[8:0] == 9'b000000000)
                   e1_high_val[9:0] = 10'b1000000000;
               if (e1_low_val[8:0] == 9'b000000000)
                   e1_low_val[9:0] = 10'b1000000000;

               if (ext_fbk_cntr == "e1")
               begin
                   ext_fbk_cntr_high = e1_high_val;
                   ext_fbk_cntr_low = e1_low_val;
                   ext_fbk_cntr_delay = e1_time_delay_val;
               end

               // cntr e0
               if (scan_data[201] == 1'b1)
               begin
                   e0_mode_val = "bypass";
                   if (scan_data[211] == 1'b1)
                   begin
                       e0_mode_val = "off";
                       $display("Warning : The specified bit settings will turn OFF the E0 counter. It cannot be turned on unless the part is re-initialized.");
                   end
               end
               else if (scan_data[211] == 1'b1)
                   e0_mode_val = "odd";
               else
                   e0_mode_val = "even";
               e0_time_delay_val = 32'b0;
               e0_time_delay_val = scan_data[215:212];
               e0_time_delay_val = e0_time_delay_val * 250;
               if (e0_time_delay_val > 3000)
                   e0_time_delay_val = 3000;
               e0_high_val[8:0] = scan_data[200:192];
               e0_low_val[8:0] = scan_data[210:202];
               if (e0_high_val[8:0] == 9'b000000000)
                   e0_high_val[9:0] = 10'b1000000000;
               if (e0_low_val[8:0] == 9'b000000000)
                   e0_low_val[9:0] = 10'b1000000000;

               if (ext_fbk_cntr == "e0")
               begin
                   ext_fbk_cntr_high = e0_high_val;
                   ext_fbk_cntr_low = e0_low_val;
                   ext_fbk_cntr_delay = e0_time_delay_val;
               end

               $display("PLL reconfigured with E3 high = %d, E3 low = %d, E3 mode = %s, E3 time delay = %0d", e3_high_val[9:0], e3_low_val[9:0], e3_mode_val, e3_time_delay_val);
               $display("                                   E2 high = %d, E2 low = %d, E2 mode = %s, E2 time delay = %0d", e2_high_val[9:0], e2_low_val[9:0], e2_mode_val, e2_time_delay_val);
               $display("                                   E1 high = %d, E1 low = %d, E1 mode = %s, E1 time delay = %0d", e1_high_val[9:0], e1_low_val[9:0], e1_mode_val, e1_time_delay_val);
               $display("                                   E0 high = %d, E0 low = %d, E0 mode = %s, E0 time delay = %0d", e0_high_val[9:0], e0_low_val[9:0], e0_mode_val, e0_time_delay_val);

            end
            // cntr l1
            if (scan_data[177] == 1'b1)
            begin
                l1_mode_val = "bypass";
                if (scan_data[187] == 1'b1)
                begin
                    l1_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the L1 counter. It cannot be turned on unless the part is re-initialized.");
                end
            end
            else if (scan_data[187] == 1'b1)
                l1_mode_val = "odd";
            else
                l1_mode_val = "even";
            l1_time_delay_val = 32'b0;
            l1_time_delay_val = scan_data[191:188];
            l1_time_delay_val = l1_time_delay_val * 250;
            if (l1_time_delay_val > 3000)
                l1_time_delay_val = 3000;
            l1_high_val[8:0] = scan_data[176:168];
            l1_low_val[8:0] = scan_data[186:178];
            if (l1_high_val[8:0] == 9'b000000000)
                l1_high_val[9:0] = 10'b1000000000;
            if (l1_low_val[8:0] == 9'b000000000)
                l1_low_val[9:0] = 10'b1000000000;

            // cntr l0
            if (scan_data[153] == 1'b1)
            begin
                l0_mode_val = "bypass";
                if (scan_data[163] == 1'b1)
                begin
                    l0_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the L0 counter. It cannot be turned on unless the part is re-initialized.");
                end
            end
            else if (scan_data[163] == 1'b1)
                l0_mode_val = "odd";
            else
                l0_mode_val = "even";
            l0_time_delay_val = 32'b0;
            l0_time_delay_val = scan_data[167:164];
            l0_time_delay_val = l0_time_delay_val * 250;
            if (l0_time_delay_val > 3000)
                l0_time_delay_val = 3000;
            l0_high_val[8:0] = scan_data[152:144];
            l0_low_val[8:0] = scan_data[162:154];
            if (l0_high_val[8:0] == 9'b000000000)
                l0_high_val[9:0] = 10'b1000000000;
            if (l0_low_val[8:0] == 9'b000000000)
                l0_low_val[9:0] = 10'b1000000000;

            $display("                                   L1 high = %d, L1 low = %d, L1 mode = %s, L1 time delay = %0d", l1_high_val[9:0], l1_low_val[9:0], l1_mode_val, l1_time_delay_val);
            $display("                                   L0 high = %d, L0 low = %d, L0 mode = %s, L0 time delay = %0d", l0_high_val[9:0], l0_low_val[9:0], l0_mode_val, l0_time_delay_val);

            // cntr g3
            if (scan_data[129] == 1'b1)
            begin
                g3_mode_val = "bypass";
                if (scan_data[139] == 1'b1)
                begin
                    g3_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the G3 counter. It cannot be turned on unless the part is re-initialized.");
                end
            end
            else if (scan_data[139] == 1'b1)
                g3_mode_val = "odd";
            else
                g3_mode_val = "even";
            g3_time_delay_val = 32'b0;
            g3_time_delay_val = scan_data[143:140];
            g3_time_delay_val = g3_time_delay_val * 250;
            if (g3_time_delay_val > 3000)
                g3_time_delay_val = 3000;
            g3_high_val[8:0] = scan_data[128:120];
            g3_low_val[8:0] = scan_data[138:130];
            if (g3_high_val[8:0] == 9'b000000000)
                g3_high_val[9:0] = 10'b1000000000;
            if (g3_low_val[8:0] == 9'b000000000)
                g3_low_val[9:0] = 10'b1000000000;

            // cntr g2
            if (scan_data[105] == 1'b1)
            begin
                g2_mode_val = "bypass";
                if (scan_data[115] == 1'b1)
                begin
                    g2_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the G2 counter. It cannot be turned on unless the part is re-initialized.");
                end
            end
            else if (scan_data[115] == 1'b1)
                g2_mode_val = "odd";
            else
                g2_mode_val = "even";
            g2_time_delay_val = 32'b0;
            g2_time_delay_val = scan_data[119:116];
            g2_time_delay_val = g2_time_delay_val * 250;
            if (g2_time_delay_val > 3000)
                g2_time_delay_val = 3000;
            g2_high_val[8:0] = scan_data[104:96];
            g2_low_val[8:0] = scan_data[114:106];
            if (g2_high_val[8:0] == 9'b000000000)
                g2_high_val[9:0] = 10'b1000000000;
            if (g2_low_val[8:0] == 9'b000000000)
                g2_low_val[9:0] = 10'b1000000000;

            // cntr g1
            if (scan_data[81] == 1'b1)
            begin
                g1_mode_val = "bypass";
                if (scan_data[91] == 1'b1)
                begin
                    g1_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the G1 counter. It cannot be turned on unless the part is re-initialized.");
                end
            end
            else if (scan_data[91] == 1'b1)
                g1_mode_val = "odd";
            else
                g1_mode_val = "even";
            g1_time_delay_val = 32'b0;
            g1_time_delay_val = scan_data[95:92];
            g1_time_delay_val = g1_time_delay_val * 250;
            if (g1_time_delay_val > 3000)
                g1_time_delay_val = 3000;
            g1_high_val[8:0] = scan_data[80:72];
            g1_low_val[8:0] = scan_data[90:82];
            if (g1_high_val[8:0] == 9'b000000000)
                g1_high_val[9:0] = 10'b1000000000;
            if (g1_low_val[8:0] == 9'b000000000)
                g1_low_val[9:0] = 10'b1000000000;

            // cntr g0
            if (scan_data[57] == 1'b1)
            begin
                g0_mode_val = "bypass";
                if (scan_data[67] == 1'b1)
                begin
                    g0_mode_val = "off";
                    $display("Warning : The specified bit settings will turn OFF the G0 counter. It cannot be turned on unless the part is re-initialized.");
                end
            end
            else if (scan_data[67] == 1'b1)
                g0_mode_val = "odd";
            else
                g0_mode_val = "even";
            g0_time_delay_val = 32'b0;
            g0_time_delay_val = scan_data[71:68];
            g0_time_delay_val = g0_time_delay_val * 250;
            if (g0_time_delay_val > 3000)
                g0_time_delay_val = 3000;
            g0_high_val[8:0] = scan_data[56:48];
            g0_low_val[8:0] = scan_data[66:58];
            if (g0_high_val[8:0] == 9'b000000000)
                g0_high_val[9:0] = 10'b1000000000;
            if (g0_low_val[8:0] == 9'b000000000)
                g0_low_val[9:0] = 10'b1000000000;

            $display("                                   G3 high = %d, G3 low = %d, G3 mode = %s, G3 time delay = %0d", g3_high_val[9:0], g3_low_val[9:0], g3_mode_val, g3_time_delay_val);
            $display("                                   G2 high = %d, G2 low = %d, G2 mode = %s, G2 time delay = %0d", g2_high_val[9:0], g2_low_val[9:0], g2_mode_val, g2_time_delay_val);
            $display("                                   G1 high = %d, G1 low = %d, G1 mode = %s, G1 time delay = %0d", g1_high_val[9:0], g1_low_val[9:0], g1_mode_val, g1_time_delay_val);
            $display("                                   G0 high = %d, G0 low = %d, G0 mode = %s, G0 time delay = %0d", g0_high_val[9:0], g0_low_val[9:0], g0_mode_val, g0_time_delay_val);

            // cntr M
            error = 0;
            m_val[8:0] = scan_data[32:24];
            if (scan_data[33] !== 1'b1)
            begin
                if (m_mode_val === "bypass")
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal mode for the M counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work.");
                end
                else if (m_val[8:0] == 9'b000000001)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal 1 value for M counter. Instead, the M counter should be BYPASSED. Reconfiguration may not work.");
                end
                else if (m_val[8:0] == 9'b000000000)
                    m_val[9:0] = 10'b1000000000;
                m_mode_val = "";
            end
            else if (scan_data[33] == 1'b1)
            begin
                if (m_mode_val !== "bypass")
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal mode for the M counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work.");
                end
                else if (scan_data[24] !== 1'b0)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal value for counter M in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.");
                end
                else
                    m_val[9:0] = 10'b0000000001;
                m_mode_val = "bypass";
            end
            if (skip_vco == "on")
                m_val[9:0] = 10'b0000000001;
            if (error == 0)
                $display("                                   M modulus = %d ", m_val[9:0]);

            // cntr M2
            if (ss > 0)
            begin
                error = 0;
                m2_val[8:0] = scan_data[42:34];
                if (scan_data[43] !== 1'b1)
                begin
                    if (m2_mode_val === "bypass")
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal mode for the M2 counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work.");
                    end
                    else if (m2_val[8:0] == 9'b000000001)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal 1 value for M2 counter. Instead, the N counter should be BYPASSED. Reconfiguration may not work.");
                    end
                    else if (m2_val[8:0] == 9'b000000000)
                        m2_val[9:0] = 10'b1000000000;
                    m2_mode_val = "";
                end
                else if (scan_data[43] == 1'b1)
                begin
                    if (m2_mode_val !== "bypass")
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal mode for the M2 counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work.");
                    end
                    else if (scan_data[34] !== 1'b0)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal value for counter M2 in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.");
                    end
                    else
                        m2_val[9:0] = 10'b0000000001;
                    m2_mode_val = "bypass";
                end
                if (m_mode_val != m2_mode_val)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Incompatible modes for M1/M2 counters. Either both should be BYASSED or both NON-BYPASSED. Reconfiguration may not work.");
                end
                if (error == 0)
                    $display(" M2 modulus = %d ", m2_val[9:0]);
            end

            m_time_delay_val = 32'b0;
            m_time_delay_val = scan_data[47:44];
            m_time_delay_val = m_time_delay_val * 250;
            if (m_time_delay_val > 3000)
                m_time_delay_val = 3000;
            if (skip_vco == "on")
                m_time_delay_val = 32'b0;
            $display("                                   M time delay = %0d", m_time_delay_val);

            // cntr N
            error = 0;
            n_val[8:0] = scan_data[8:0];
            if (scan_data[9] !== 1'b1)
            begin
                if (n_mode_val === "bypass")
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal mode for the N counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work.");
                end
                else if (n_val[8:0] == 9'b000000001)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal 1 value for N counter. Instead, the N counter should be BYPASSED. Reconfiguration may not work.");
                end
                else if (n_val[8:0] == 9'b000000000)
                    n_val[9:0] = 10'b1000000000;
                n_mode_val = "";
            end
            else if (scan_data[9] == 1'b1)     // bypass
            begin
                if (n_mode_val !== "bypass")
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal mode for the N counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work.");
                end
                else if (scan_data[0] !== 1'b0)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Illegal value for counter N in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.");
                end
                else
                    n_val[9:0] = 10'b0000000001;

                n_mode_val = "bypass";
            end
            if (error == 0)
                $display("                                   N modulus = %d ", n_val[9:0]);

            // cntr N2
            if (ss > 0)
            begin
                error = 0;
                n2_val[8:0] = scan_data[18:10];
                if (scan_data[19] !== 1'b1)
                begin
                    if (n2_mode_val === "bypass")
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal mode for the N2 counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work.");
                    end
                    else if (n2_val[8:0] == 9'b000000001)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal 1 value for N2 counter. Instead, the N2 counter should be BYPASSED. Reconfiguration may not work.");
                    end
                    else if (n2_val[8:0] == 9'b000000000)
                        n2_val = 10'b1000000000;
                    n2_mode_val = "";
                end
                else if (scan_data[19] == 1'b1)     // bypass
                begin
                    if (n2_mode_val !== "bypass")
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal mode for the N2 counter. Cannot switch between BYPASS/NON-BYPASS modes. Reconfiguration may not work.");
                    end
                    else if (scan_data[10] !== 1'b0)
                    begin
                        reconfig_err = 1;
                        error = 1;
                        $display ("Warning : Illegal value for counter N2 in BYPASS mode. The LSB of the counter should be set to 0 in order to operate the counter in BYPASS mode. Reconfiguration may not work.");
                    end
                    else
                        n2_val[9:0] = 10'b0000000001;

                    n2_mode_val = "bypass";
                end
                if (n_mode_val != n2_mode_val)
                begin
                    reconfig_err = 1;
                    error = 1;
                    $display ("Warning : Incompatible modes for N1/N2 counters. Either both should be BYASSED or both NON-BYPASSED.");
                end
                if (error == 0)
                    $display(" N2 modulus = %d ", n2_val[9:0]);
            end // ss > 0

            n_time_delay_val = 32'b0;
            n_time_delay_val = scan_data[23:20];
            n_time_delay_val = n_time_delay_val * 250;
            if (n_time_delay_val > 3000)
                n_time_delay_val = 3000;
            $display("                                   N time delay = %0d", n_time_delay_val);

            transfer = 0;
            // clear the scan_chain
            for (i = 0; i <= scan_chain_length; i = i + 1)
               scan_data[i] = 0;
        end
    end

always @(schedule_vco or areset_ipd or ena_ipd)
begin
    sched_time = 0;

    for (i = 0; i <= 7; i=i+1)
        last_phase_shift[i] = phase_shift[i];
 
    cycle_to_adjust = 0;
    l_index = 1;
    m_times_vco_period = new_m_times_vco_period;

    // give appropriate messages
    // if areset was asserted
    if (areset_ipd == 1'b1 && areset_ipd_last_value !== areset_ipd)
    begin
        $display (" Note : PLL was reset");
        $display ("Time: %0t  Instance: %m", $time);
    end

    // if ena was deasserted
    if (ena_ipd == 1'b0 && ena_ipd_last_value !== ena_ipd)
    begin
        $display (" Note : PLL was disabled");
        $display ("Time: %0t  Instance: %m", $time);
    end

    // illegal value on areset_ipd
    if (areset_ipd === 1'bx && (areset_ipd_last_value === 1'b0 || areset_ipd_last_value === 1'b1))
    begin
        $display("Warning : Illegal value 'X' detected on ARESET input");
        $display ("Time: %0t  Instance: %m", $time);
    end

   if ((schedule_vco !== schedule_vco_last_value) && (areset_ipd == 1'b1 || ena_ipd == 1'b0 || stop_vco == 1'b1))
   begin

      // drop VCO taps to 0
      for (i = 0; i <= 7; i=i+1)
      begin
         for (j = 0; j <= last_phase_shift[i] + 1; j=j+1)
             vco_out[i] <= #(j) 1'b0;
         phase_shift[i] = 0;
         last_phase_shift[i] = 0;
      end

      // reset lock parameters
      locked_tmp = 0;
      if (l_pll_type == "fast")
         locked_tmp = 1;
      pll_is_locked = 0;
      pll_about_to_lock = 0;
      cycles_to_lock = 0;
      cycles_to_unlock = 0;

      got_first_refclk = 0;
      got_second_refclk = 0;
      refclk_time = 0;
      got_first_fbclk = 0;
      fbclk_time = 0;
      first_fbclk_time = 0;
      fbclk_period = 0;

      first_schedule = 1;
      schedule_offset = 1;
      vco_val = 0;
      vco_period_was_phase_adjusted = 0;
      phase_adjust_was_scheduled = 0;

      // reset enable0 and enable1 counter parameters
//      l0_count = 1;
//      l1_count = 1;
//      l0_got_first_rising_edge = 0;
//      l1_got_first_rising_edge = 0;

   end else if (ena_ipd === 1'b1 && areset_ipd === 1'b0 && stop_vco === 1'b0)
   begin

       // else note areset deassert time
       // note it as refclk_time to prevent false triggering
       // of stop_vco after areset
       if (areset_ipd === 1'b0 && areset_ipd_last_value === 1'b1)
       begin
           refclk_time = $time;
       end

      // calculate loop_xplier : this will be different from m_val in ext. fbk mode
      loop_xplier = m_val;
      loop_initial = i_m_initial - 1;
      loop_ph = i_m_ph;
      loop_time_delay = m_time_delay_val;

      if (l_operation_mode == "external_feedback")
      begin
         loop_xplier = m_val * (ext_fbk_cntr_high + ext_fbk_cntr_low);
         loop_ph = ext_fbk_cntr_ph;
         loop_initial = ext_fbk_cntr_initial - 1 + ((i_m_initial - 1) * (ext_fbk_cntr_high + ext_fbk_cntr_low));
         loop_time_delay = m_time_delay_val + ext_fbk_cntr_delay;
      end

      // convert initial value to delay
      initial_delay = (loop_initial * m_times_vco_period)/loop_xplier;

      // convert loop ph_tap to delay
      rem = m_times_vco_period % loop_xplier;
      vco_per = m_times_vco_period/loop_xplier;
      if (rem != 0)
          vco_per = vco_per + 1;
      fbk_phase = (loop_ph * vco_per)/8;

      if (l_operation_mode == "external_feedback")
      begin
          pull_back_ext_cntr = ext_fbk_cntr_delay + (ext_fbk_cntr_initial - 1) * (m_times_vco_period/loop_xplier) + fbk_phase;

          while (pull_back_ext_cntr > refclk_period)
              pull_back_ext_cntr = pull_back_ext_cntr - refclk_period;

          pull_back_M =  m_time_delay_val + (i_m_initial - 1) * (ext_fbk_cntr_high + ext_fbk_cntr_low) * (m_times_vco_period/loop_xplier);

          while (pull_back_M > refclk_period)
              pull_back_M = pull_back_M - refclk_period;
      end
      else begin
          pull_back_ext_cntr = 0;
          pull_back_M = initial_delay + m_time_delay_val + fbk_phase;
      end

      total_pull_back = pull_back_M + pull_back_ext_cntr;
      if (l_simulation_type == "timing")
          total_pull_back = total_pull_back + pll_compensation_delay;

      while (total_pull_back > refclk_period)
          total_pull_back = total_pull_back - refclk_period;

      if (total_pull_back > 0)
          offset = refclk_period - total_pull_back;

      if (l_operation_mode == "external_feedback")
      begin
          fbk_delay = pull_back_M;
          if (l_simulation_type == "timing")
              fbk_delay = fbk_delay + pll_compensation_delay;

          ext_fbk_delay = pull_back_ext_cntr - fbk_phase;
      end
      else begin
          fbk_delay = total_pull_back - fbk_phase;
          if (fbk_delay < 0)
          begin
              offset = offset - fbk_phase;
              fbk_delay = total_pull_back;
          end
      end

      // assign m_delay
      m_delay = fbk_delay;

      for (i = 1; i <= loop_xplier; i=i+1)
      begin
         // adjust cycles
         tmp_vco_per = m_times_vco_period/loop_xplier;
         if (rem != 0 && l_index <= rem)
         begin
            tmp_rem = (loop_xplier * l_index) % rem;
            cycle_to_adjust = (loop_xplier * l_index) / rem;
            if (tmp_rem != 0)
               cycle_to_adjust = cycle_to_adjust + 1;
         end
         if (cycle_to_adjust == i)
         begin
            tmp_vco_per = tmp_vco_per + 1;
            l_index = l_index + 1;
         end

         // calculate high and low periods
         high_time = tmp_vco_per/2;
         if (tmp_vco_per % 2 != 0)
             high_time = high_time + 1;
         low_time = tmp_vco_per - high_time;

         // schedule the rising and falling egdes
         for (j=0; j<=1; j=j+1)
         begin
            vco_val = ~vco_val;
            if (vco_val == 1'b0)
                sched_time = sched_time + high_time;
            else
                sched_time = sched_time + low_time;

            // add offset
            if (schedule_offset == 1'b1)
            begin
               sched_time = sched_time + offset;
               schedule_offset = 0;
            end

            // schedule taps with appropriate phase shifts
            for (k = 0; k <= 7; k=k+1)
            begin
               phase_shift[k] = (k*tmp_vco_per)/8;
               if (first_schedule)
                   vco_out[k] <= #(sched_time + phase_shift[k]) vco_val;
               else
                   vco_out[k] <= #(sched_time + last_phase_shift[k]) vco_val;
            end
         end
      end
      if (first_schedule)
      begin
         vco_val = ~vco_val;
         if (vco_val == 1'b0)
             sched_time = sched_time + high_time;
         else
             sched_time = sched_time + low_time;
         for (k = 0; k <= 7; k=k+1)
         begin
            phase_shift[k] = (k*tmp_vco_per)/8;
            vco_out[k] <= #(sched_time+phase_shift[k]) vco_val;
         end
         first_schedule = 0;
      end

      // this may no longer be required

      schedule_vco <= #(sched_time) ~schedule_vco;
      if (vco_period_was_phase_adjusted)
      begin
          m_times_vco_period = refclk_period;
          new_m_times_vco_period = refclk_period;
          vco_period_was_phase_adjusted = 0;
          phase_adjust_was_scheduled = 1;

          tmp_vco_per = m_times_vco_period/loop_xplier;
          for (k = 0; k <= 7; k=k+1)
              phase_shift[k] = (k*tmp_vco_per)/8;
      end
   end

     areset_ipd_last_value = areset_ipd;
     ena_ipd_last_value = ena_ipd;
     schedule_vco_last_value = schedule_vco;

end

always @(pfdena_ipd)
begin
   if (pfdena_ipd === 1'b0)
   begin
      locked_tmp = 1'bx;
      pll_is_locked = 0;
      cycles_to_lock = 0;
      $display (" Note : PFDENA was deasserted");
      $display ("Time: %0t  Instance: %m", $time);
   end
   else if (pfdena_ipd === 1'b1 && pfdena_ipd_last_value === 1'b0)
   begin
       // PFD was disabled, now enabled again
      got_first_refclk = 0;
      got_second_refclk = 0;
      refclk_time = $time;
   end
   pfdena_ipd_last_value = pfdena_ipd;
end

always @(negedge refclk or negedge fbclk)
begin
   refclk_last_value = refclk;
   fbclk_last_value = fbclk;
end

always @(posedge refclk or posedge fbclk)
begin
    if (refclk == 1'b1 && refclk_last_value !== refclk && areset_ipd === 1'b0)
    begin
       if (! got_first_refclk)
       begin
          got_first_refclk = 1;
       end else
       begin
          got_second_refclk = 1;
          refclk_period = $time - refclk_time;

          // check if incoming freq. will cause VCO range to be
          // exceeded
          if ( (vco_max != 0 && vco_min != 0) && (skip_vco == "off") && (pfdena_ipd === 1'b1) &&
               ((refclk_period/loop_xplier > vco_max) ||
               (refclk_period/loop_xplier < vco_min)) )
          begin
              if (pll_is_locked == 1'b1)
              begin
                  $display ("Warning : Input clock freq. is not within VCO range. PLL may lose lock");
                  $display ("Time: %0t  Instance: %m", $time);
              end
              else begin
                  $display ("Warning : Input clock freq. is not within VCO range. PLL may not lock");
                  $display ("Time: %0t  Instance: %m", $time);
              end
              inclk_out_of_range = 1;
          end
          else if ( vco_min == 0 && vco_max == 0 && pll_type == "cdr")
          begin
              if (refclk_period != primary_clock_frequency)
              begin
                  if (no_warn == 0)
                  begin
                      $display("Warning : Incoming clock period %d for PLL does not match the specified inclock period %d. ALTGXB simulation may not function correctly.", refclk_period, primary_clock_frequency);
                      $display ("Time: %0t  Instance: %m", $time);
                      no_warn = 1;
                  end
              end
          end
          else begin
              inclk_out_of_range = 0;
          end

       end
       if (stop_vco == 1'b1)
       begin
          stop_vco = 0;
          schedule_vco = ~schedule_vco;
       end
       refclk_time = $time;
    end

    if (fbclk == 1'b1 && fbclk_last_value !== fbclk)
    begin
       if (!got_first_fbclk)
       begin
          got_first_fbclk = 1;
          first_fbclk_time = $time;
       end
       else
          fbclk_period = $time - fbclk_time;

       // need refclk_period here, so initialized to proper value above
       if ( ($time - refclk_time > 1.5 * refclk_period) && pfdena_ipd === 1'b1)
       begin
           stop_vco = 1;
           // reset
           got_first_refclk = 0;
           got_first_fbclk = 0;
           got_second_refclk = 0;
           if (pll_is_locked == 1'b1)
           begin
              pll_is_locked = 0;
              locked_tmp = 0;
              if (l_pll_type == "fast")
                 locked_tmp = 1;
              $display ("Note : PLL lost lock due to loss of input clock");
              $display ("Time: %0t  Instance: %m", $time);
           end
           pll_about_to_lock = 0;
           cycles_to_lock = 0;
           cycles_to_unlock = 0;
           first_schedule = 1;
       end
       fbclk_time = $time;
    end

    if (got_second_refclk && pfdena_ipd === 1'b1 && (!inclk_out_of_range))
    begin
       // now we know actual incoming period
//       if (abs(refclk_period - fbclk_period) > 2)
//       begin
//           new_m_times_vco_period = refclk_period;
//       end
//       else if (abs(fbclk_time - refclk_time) <= 2 || (refclk_period - abs(fbclk_time - refclk_time) <= 2))
       if (abs(fbclk_time - refclk_time) <= 5 || (got_first_fbclk && abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5))
       begin
           // considered in phase
           if (cycles_to_lock == valid_lock_multiplier - 1)
              pll_about_to_lock <= 1;
           if (cycles_to_lock == valid_lock_multiplier)
           begin
              if (pll_is_locked === 1'b0)
              begin
                  $display (" Note : PLL locked to incoming clock");
                  $display ("Time: %0t  Instance: %m", $time);
              end
              pll_is_locked = 1;
              locked_tmp = 1;
              if (l_pll_type == "fast")
                 locked_tmp = 0;
           end
           // increment lock counter only if the second part of the above
           // time check is NOT true
           if (!(abs(refclk_period - abs(fbclk_time - refclk_time)) <= 5))
           begin
               cycles_to_lock = cycles_to_lock + 1;
           end

           // adjust m_times_vco_period
           new_m_times_vco_period = refclk_period;

       end else
       begin
           // if locked, begin unlock
           if (pll_is_locked)
           begin
               cycles_to_unlock = cycles_to_unlock + 1;
               if (cycles_to_unlock == invalid_lock_multiplier)
               begin
                   pll_is_locked = 0;
                   locked_tmp = 0;
                   if (l_pll_type == "fast")
                       locked_tmp = 1;
                   pll_about_to_lock = 0;
                   cycles_to_lock = 0;
                   $display ("Note : PLL lost lock");
                   $display ("Time: %0t  Instance: %m", $time);
                   first_schedule = 1;
                   schedule_offset = 1;
                   vco_period_was_phase_adjusted = 0;
                   phase_adjust_was_scheduled = 0;
               end
           end
           if (abs(refclk_period - fbclk_period) <= 2)
           begin
               // frequency is still good
               if ($time == fbclk_time && (!phase_adjust_was_scheduled))
               begin
                   if (abs(fbclk_time - refclk_time) > refclk_period/2)
                   begin
                       new_m_times_vco_period = m_times_vco_period + (refclk_period - abs(fbclk_time - refclk_time));
                       vco_period_was_phase_adjusted = 1;
                   end else
                   begin
                       new_m_times_vco_period = m_times_vco_period - abs(fbclk_time - refclk_time);
                       vco_period_was_phase_adjusted = 1;
                   end
               end
           end else
           begin
               new_m_times_vco_period = refclk_period;
               phase_adjust_was_scheduled = 0;
           end
       end
    end

    if (quiet_period_violation == 1'b1 || reconfig_err == 1'b1 || scanclr_violation == 1'b1 || scanclr_clk_violation == 1'b1)
    begin
        locked_tmp = 0;
        if (l_pll_type == "fast")
            locked_tmp = 1;
    end

    refclk_last_value = refclk;
    fbclk_last_value = fbclk;
end

    assign clk0_tmp = clk0_counter == "l0" ? l0_clk : clk0_counter == "l1" ? l1_clk : clk0_counter == "g0" ? g0_clk : clk0_counter == "g1" ? g1_clk : clk0_counter == "g2" ? g2_clk : clk0_counter == "g3" ? g3_clk : 'b0;

    assign clk0 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk0_tmp : 'bx;

    dffe ena0_reg (.D(clkena0_ipd),
                   .CLRN(1'b1),
                   .PRN(1'b1),
                   .ENA(1'b1),
                   .CLK(!clk0_tmp),
                   .Q(ena0)
                  );

    assign clk1_tmp = clk1_counter == "l0" ? l0_clk : clk1_counter == "l1" ? l1_clk : clk1_counter == "g0" ? g0_clk : clk1_counter == "g1" ? g1_clk : clk1_counter == "g2" ? g2_clk : clk1_counter == "g3" ? g3_clk : 'b0;

    assign clk1 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk1_tmp : 'bx;

    dffe ena1_reg (.D(clkena1_ipd),
                   .CLRN(1'b1),
                   .PRN(1'b1),
                   .ENA(1'b1),
                   .CLK(!clk1_tmp),
                   .Q(ena1)
                  );

    assign clk2_tmp = clk2_counter == "l0" ? l0_clk : clk2_counter == "l1" ? l1_clk : clk2_counter == "g0" ? g0_clk : clk2_counter == "g1" ? g1_clk : clk2_counter == "g2" ? g2_clk : clk2_counter == "g3" ? g3_clk : 'b0;

    assign clk2 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk2_tmp : 'bx;

    dffe ena2_reg (.D(clkena2_ipd),
                   .CLRN(1'b1),
                   .PRN(1'b1),
                   .ENA(1'b1),
                   .CLK(!clk2_tmp),
                   .Q(ena2)
                  );

    assign clk3_tmp = clk3_counter == "l0" ? l0_clk : clk3_counter == "l1" ? l1_clk : clk3_counter == "g0" ? g0_clk : clk3_counter == "g1" ? g1_clk : clk3_counter == "g2" ? g2_clk : clk3_counter == "g3" ? g3_clk : 'b0;

    assign clk3 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk3_tmp : 'bx;

    dffe ena3_reg (.D(clkena3_ipd),
                   .CLRN(1'b1),
                   .PRN(1'b1),
                   .ENA(1'b1),
                   .CLK(!clk3_tmp),
                   .Q(ena3)
                  );

    assign clk4_tmp = clk4_counter == "l0" ? l0_clk : clk4_counter == "l1" ? l1_clk : clk4_counter == "g0" ? g0_clk : clk4_counter == "g1" ? g1_clk : clk4_counter == "g2" ? g2_clk : clk4_counter == "g3" ? g3_clk : 'b0;

    assign clk4 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk4_tmp : 'bx;

    dffe ena4_reg (.D(clkena4_ipd),
                   .CLRN(1'b1),
                   .PRN(1'b1),
                   .ENA(1'b1),
                   .CLK(!clk4_tmp),
                   .Q(ena4)
                  );

    assign clk5_tmp = clk5_counter == "l0" ? l0_clk : clk5_counter == "l1" ? l1_clk : clk5_counter == "g0" ? g0_clk : clk5_counter == "g1" ? g1_clk : clk5_counter == "g2" ? g2_clk : clk5_counter == "g3" ? g3_clk : 'b0;

    assign clk5 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? clk5_tmp : 'bx;

    dffe ena5_reg (.D(clkena5_ipd),
                   .CLRN(1'b1),
                   .PRN(1'b1),
                   .ENA(1'b1),
                   .CLK(!clk5_tmp),
                   .Q(ena5)
                  );

    assign extclk0_tmp = extclk0_counter == "e0" ? e0_clk : extclk0_counter == "e1" ? e1_clk : extclk0_counter == "e2" ? e2_clk : extclk0_counter == "e3" ? e3_clk : 'b0;

    assign extclk0 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? extclk0_tmp : 'bx;

    dffe extena0_reg (.D(extclkena0_ipd),
                      .CLRN(1'b1),
                      .PRN(1'b1),
                      .ENA(1'b1),
                      .CLK(!extclk0_tmp),
                      .Q(extena0)
                     );

    assign extclk1_tmp = extclk1_counter == "e0" ? e0_clk : extclk1_counter == "e1" ? e1_clk : extclk1_counter == "e2" ? e2_clk : extclk1_counter == "e3" ? e3_clk : 'b0;

    assign extclk1 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? extclk1_tmp : 'bx;

    dffe extena1_reg (.D(extclkena1_ipd),
                      .CLRN(1'b1),
                      .PRN(1'b1),
                      .ENA(1'b1),
                      .CLK(!extclk1_tmp),
                      .Q(extena1)
                     );

    assign extclk2_tmp = extclk2_counter == "e0" ? e0_clk : extclk2_counter == "e1" ? e1_clk : extclk2_counter == "e2" ? e2_clk : extclk2_counter == "e3" ? e3_clk : 'b0;

    assign extclk2 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? extclk2_tmp : 'bx;

    dffe extena2_reg (.D(extclkena2_ipd),
                      .CLRN(1'b1),
                      .PRN(1'b1),
                      .ENA(1'b1),
                      .CLK(!extclk2_tmp),
                      .Q(extena2)
                     );

    assign extclk3_tmp = extclk3_counter == "e0" ? e0_clk : extclk3_counter == "e1" ? e1_clk : extclk3_counter == "e2" ? e2_clk : extclk3_counter == "e3" ? e3_clk : 'b0;

    assign extclk3 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || (pll_about_to_lock == 1'b1 && !quiet_period_violation && !reconfig_err && !scanclr_violation && !scanclr_clk_violation) ? extclk3_tmp : 'bx;

    dffe extena3_reg (.D(extclkena3_ipd),
                      .CLRN(1'b1),
                      .PRN(1'b1),
                      .ENA(1'b1),
                      .CLK(!extclk3_tmp),
                      .Q(extena3)
                     );

    assign enable_0 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || pll_about_to_lock == 1'b1 ? enable0_tmp : 'bx;
    assign enable_1 = (areset_ipd === 1'b1 || ena_ipd === 1'b0) || pll_about_to_lock == 1'b1 ? enable1_tmp : 'bx;

    // ACCELERATE OUTPUTS
    and (clk[0], ena0, clk0);
    and (clk[1], ena1, clk1);
    and (clk[2], ena2, clk2);
    and (clk[3], ena3, clk3);
    and (clk[4], ena4, clk4);
    and (clk[5], ena5, clk5);

    and (extclk[0], extena0, extclk0);
    and (extclk[1], extena1, extclk1);
    and (extclk[2], extena2, extclk2);
    and (extclk[3], extena3, extclk3);

    and (enable0, 1'b1, enable_0);
    and (enable1, 1'b1, enable_1);

    and (scandataout, 1'b1, scandataout_tmp);

endmodule
//////////////////////////////////////////////////////////////////////////////
//
// Module Name : cyclone_dll
//
// Description : Simulation model for the Cyclone DLL.
//
// Outputs     : Delayctrlout output (active high) indicates when the
//               DLL locks to the incoming clock
//
//////////////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps

module cyclone_dll (clk,
                    delayctrlout
                   );

    // GLOBAL PARAMETERS
    parameter input_frequency   = "10000 ps";
    parameter phase_shift       = "0";
    parameter sim_valid_lock    = 1;
    parameter sim_invalid_lock  = 5;
    parameter lpm_type          = "cyclone_dll";

    // INPUT PORTS
    input clk;

    // OUTPUT PORTS
    output delayctrlout;

    // INTERNAL NETS AND VARIABLES
    reg clk_ipd_last_value;
    reg got_first_rising_edge;
    reg got_first_falling_edge;
    reg dll_is_locked;
    reg start_clk_detect;
    reg start_clk_detect_last_value;
    reg violation;
    reg duty_cycle_warn;
    reg input_freq_warn;

    time clk_ipd_last_rising_edge;
    time clk_ipd_last_falling_edge;

    integer clk_per_tolerance;
    integer duty_cycle;
    integer clk_detect_count;
    integer half_cycles_to_lock;
    integer half_cycles_to_keep_lock;

    integer input_period;

    // BUFFER INPUTS
    buf (clk_ipd, clk);

    // FUNCTIONS
    // convert string to integer with sign
    function integer str2int; 
    input [8*16:1] s;

    reg [8*16:1] reg_s;
    reg [8:1] digit;
    reg [8:1] tmp;
    integer m, magnitude;
    integer sign;

    begin
        sign = 1;
        magnitude = 0;
        reg_s = s;
        for (m=1; m<=16; m=m+1)
        begin
            tmp = reg_s[128:121];
            digit = tmp & 8'b00001111;
            reg_s = reg_s << 8;
            // Accumulate ascii digits 0-9 only.
            if ((tmp>=48) && (tmp<=57)) 
                magnitude = (magnitude * 10) + digit;
            if (tmp == 45)
                sign = -1;  // Found a '-' character, i.e. number is negative.
        end
        str2int = sign*magnitude;
    end
    endfunction

    initial
    begin
        clk_ipd_last_value = 0;
        got_first_rising_edge = 0;
        got_first_falling_edge = 0;
        clk_ipd_last_rising_edge = 0;
        clk_ipd_last_falling_edge = 0;
        input_period = str2int(input_frequency);
        duty_cycle = input_period/2;
        clk_per_tolerance = input_period * 0.1;

        // if sim_valid_lock == 0, DLL starts out locked.
        if (sim_valid_lock == 0)
            dll_is_locked = 1;
        else
            dll_is_locked = 0;

        clk_detect_count = 0;
        start_clk_detect = 0;
        start_clk_detect_last_value = 0;
        half_cycles_to_lock = 0;
        half_cycles_to_keep_lock = 0;
        violation = 0;
        duty_cycle_warn = 1;
        input_freq_warn = 1;
    end

    always @(clk_ipd)
    begin
        if (clk_ipd == 1'b1 && clk_ipd != clk_ipd_last_value)
        begin
            // rising edge
            if (got_first_rising_edge == 1'b0)
            begin
                got_first_rising_edge = 1;
                half_cycles_to_lock = half_cycles_to_lock + 1;
                if (sim_valid_lock > 0 && half_cycles_to_lock >= sim_valid_lock && violation == 1'b0)
                begin
                    dll_is_locked <= 1;
                    $display(" Note : DLL locked to incoming clock.");
                    $display("Time: %0t  Instance: %m", $time);
                end

                // start the internal clock that will monitor
                // the input clock
                start_clk_detect <= 1;
            end
            else
            begin
                // reset clock event counter
                clk_detect_count = 0;
                // check for clk_period violation
                if ( (($time - clk_ipd_last_rising_edge) < (input_period - clk_per_tolerance)) || (($time - clk_ipd_last_rising_edge) > (input_period + clk_per_tolerance)) )
                begin
                    violation = 1;
                    if (input_freq_warn === 1'b1)
                    begin
                        $display(" Warning : Input frequency violation");
                        $display("Time: %0t  Instance: %m", $time);
                        input_freq_warn = 0;
                    end
                end
                else if ( (($time - clk_ipd_last_falling_edge) < (duty_cycle - clk_per_tolerance/2)) || (($time - clk_ipd_last_falling_edge) > (duty_cycle + clk_per_tolerance/2)) )
                begin
                    // duty cycle violation
                    violation = 1;
                    if (duty_cycle_warn === 1'b1)
                    begin
                        $display(" Warning : Duty Cycle violation");
                        $display("Time: %0t  Instance: %m", $time);
                        duty_cycle_warn = 0;
                    end
                end
                else
                    violation = 0;
                if (violation)
                begin
                    if (dll_is_locked)
                    begin
                        half_cycles_to_keep_lock = half_cycles_to_keep_lock + 1;
                        if (half_cycles_to_keep_lock > sim_invalid_lock)
                        begin
                            dll_is_locked <= 0;
                            $display(" Warning : DLL lost lock due to input frequency/Duty cycle violation.");
                            $display("Time: %0t  Instance: %m", $time);
                            // reset lock and unlock counters
                            half_cycles_to_lock = 0;
                            half_cycles_to_keep_lock = 0;
                            got_first_rising_edge = 0;
                            got_first_falling_edge = 0;
                        end
                    end
                    else
                        half_cycles_to_lock = 0;
                end
                else begin
                    if (dll_is_locked == 1'b0)
                    begin
                        // increment lock counter
                        half_cycles_to_lock = half_cycles_to_lock + 1;
                        if (half_cycles_to_lock > sim_valid_lock)
                        begin
                            dll_is_locked <= 1;
                            $display(" Note : DLL locked to incoming clock.");
                            $display("Time: %0t  Instance: %m", $time);
                        end
                    end
                    else
                        half_cycles_to_keep_lock = 0;
                end
            end
            clk_ipd_last_rising_edge = $time;
        end
        else if (clk_ipd == 1'b0 && clk_ipd != clk_ipd_last_value)
        begin
            // falling edge
            // reset clock event counter
            clk_detect_count = 0;
            got_first_falling_edge = 1;
            if (got_first_rising_edge == 1'b1)
            begin
                // check for duty cycle violation
                if ( (($time - clk_ipd_last_rising_edge) < (duty_cycle - clk_per_tolerance/2)) || (($time - clk_ipd_last_rising_edge) > (duty_cycle + clk_per_tolerance/2)) )
                begin
                    violation = 1;
                    if (duty_cycle_warn === 1'b1)
                    begin
                        $display(" Warning : Duty Cycle violation");
                        $display("Time: %0t  Instance: %m", $time);
                        duty_cycle_warn = 0;
                    end
                end
                else
                    violation = 0;
                if (dll_is_locked)
                begin
                    if (violation)
                    begin
                        half_cycles_to_keep_lock = half_cycles_to_keep_lock + 1;
                        if (half_cycles_to_keep_lock > sim_invalid_lock)
                        begin
                            dll_is_locked <= 0;
                            $display(" Warning : DLL lost lock due to input frequency/Duty cycle violation.");
                            $display("Time: %0t  Instance: %m", $time);
                            // reset lock and unlock counters
                            half_cycles_to_lock = 0;
                            half_cycles_to_keep_lock = 0;
                            got_first_rising_edge = 0;
                            got_first_falling_edge = 0;
                        end
                    end
                    else
                        half_cycles_to_keep_lock = 0;
                end
                else
                begin
                    if (violation)
                    begin
                        // reset_lock_counter
                        half_cycles_to_lock = 0;
                    end
                    else
                    begin
                        // increment lock counter
                        half_cycles_to_lock = half_cycles_to_lock + 1;
                    end
                end
            end
            else
            begin
                // first clk edge is falling edge, do nothing
            end
            clk_ipd_last_falling_edge = $time;
        end
        else
        begin
            // illegal value
            if (dll_is_locked && (got_first_rising_edge == 1'b1 || got_first_falling_edge == 1'b1))
            begin
                dll_is_locked <= 0;
                // reset lock and unlock counters
                half_cycles_to_lock = 0;
                half_cycles_to_keep_lock = 0;
                got_first_rising_edge = 0;
                got_first_falling_edge = 0;
                $display(" Error : Illegal value detected on input clock. DLL will lose lock.");
                $display("Time: %0t  Instance: %m", $time);
            end
            else if (got_first_rising_edge == 1'b1 || got_first_falling_edge == 1'b1)
            begin
                // clock started up, then went to 'X'
                // this is to weed out the 'X' at start of simulation
                $display(" Error : Illegal value detected on input clock.");
                $display("Time: %0t  Instance: %m", $time);
                // reset lock counter
                half_cycles_to_lock = 0;
            end
        end
        clk_ipd_last_value = clk_ipd;
    end

    // ********************************************************************
    // The following block generates the internal clock that is used to
    // track loss of input clock. A counter counts events on this internal
    // clock, and is reset to 0 on event on input clock. If input clock
    // flatlines, the counter will exceed the limit and DLL will lose lock.
    // Events on internal clock are scheduled at the max. allowable input
    // clock tolerance, to allow 'sim_invalid_lock' parameter value = 1.
    // ********************************************************************

    always @(start_clk_detect)
    begin
        if (start_clk_detect != start_clk_detect_last_value)
        begin
            // increment clock event counter
            clk_detect_count = clk_detect_count + 1;
            if (dll_is_locked)
            begin
                if (clk_detect_count > sim_invalid_lock)
                begin
                    dll_is_locked = 0;
                    $display(" Warning : DLL lost lock due to loss of input clock.");
                    $display("Time: %0t  Instance: %m", $time);
                    // reset lock and unlock counters
                    half_cycles_to_lock = 0;
                    half_cycles_to_keep_lock = 0;
                    got_first_rising_edge = 0;
                    got_first_falling_edge = 0;
                    clk_detect_count = 0;
                    start_clk_detect <= #(input_period/2) 1'b0;
                end
                else
                    start_clk_detect <= #(input_period/2 + clk_per_tolerance/2) ~start_clk_detect;
            end
            else if (clk_detect_count > 10)
            begin
                $display(" Warning : No input clock. DLL will not lock.");
                $display("Time: %0t  Instance: %m", $time);
                clk_detect_count = 0;
            end
            else
                start_clk_detect <= #(input_period/2 + clk_per_tolerance/2) ~start_clk_detect;
        end
        // save this event value
        start_clk_detect_last_value = start_clk_detect;
    end

    // ACCELERATE OUTPUTS
    and (delayctrlout, 1'b1, dll_is_locked);

endmodule
///////////////////////////////////////////////////////////////////////
//
// CYCLONE JTAG Atom
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module  cyclone_jtag (tms, tck, tdi, ntrst, tdoutap, tdouser, tdo, tmsutap, tckutap, tdiutap, shiftuser, clkdruser, updateuser, runidleuser, usr1user);

	input    tms, tck, tdi, ntrst, tdoutap, tdouser;

	output   tdo, tmsutap, tckutap, tdiutap, shiftuser, clkdruser;
	output	updateuser, runidleuser, usr1user;

   parameter lpm_type = "cyclone_jtag";

	initial
	begin
	end

	always @(tms or tck or tdi or ntrst or tdoutap or tdouser) 
	begin 
	end

endmodule

///////////////////////////////////////////////////////////////////////
//
// CYCLONE CRCBLOCK Atom
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module  cyclone_crcblock 
	(
	clk,
	shiftnld,
	ldsrc,
	crcerror,
	regout
	);

input clk;
input shiftnld;
input ldsrc;

output crcerror;
output regout;

parameter oscillator_divider = 1;
parameter lpm_type = "cyclone_crcblock";

endmodule
///////////////////////////////////////////////////////////////////////////////
//
// CYCLONE ASYNCH IO Atom
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ps/1 ps

module cyclone_asynch_io (datain, oe, regin, padio, combout, regout);
   
   input datain, oe;
   input regin;
   output combout;
   output regout;
   inout  padio;
   
   parameter operation_mode = "input";
   parameter bus_hold = "false";
   parameter open_drain_output = "false";
   
   reg 	     prev_value;
   reg 	     tmp_padio, tmp_combout;
   reg 	     buf_control;
   
   buf(datain_in, datain);
   buf(oe_in, oe);
   
   tri 	     padio_tmp;
   
   specify
      (padio => combout) = (0,0);
      (datain => padio) = (0, 0);
      (posedge oe => (padio +: padio_tmp)) = (0, 0);
      (negedge oe => (padio +: 1'bz)) = (0, 0);
      (regin => regout) = (0, 0);
   endspecify
   
   initial
      begin
	 prev_value = 'b0;
	 tmp_padio = 'bz;
      end
   
	always @(datain_in or oe_in or padio)
	begin
		if (bus_hold == "true" )
		begin
			buf_control = 'b1;
			if ( operation_mode == "output" || operation_mode == "bidir")
			begin
				if ( oe_in == 1)
				begin
					if ( open_drain_output == "true" )
					begin
						if (datain_in == 0)
						begin
							tmp_padio =  1'b0;
							prev_value = 1'b0;
						end
						else if (datain_in == 1'bx)
						begin
							tmp_padio = 1'bx;
							prev_value = 1'bx;
						end
						else   // output of tri is 'Z'
						begin
							if ( operation_mode == "bidir")
								prev_value = padio;
							
							tmp_padio = 1'bz;
						end
					end  
					else  // open drain_output = false;
					begin
						tmp_padio = datain_in;
						prev_value = datain_in;
					end
				end   
				else if ( oe_in == 0 )
				begin
					if (operation_mode == "bidir")
						prev_value = padio;

					tmp_padio = 1'bz;
				end
				else   // oe == 'X' 
				begin
					tmp_padio = 1'bx;
					prev_value = 1'bx;
				end
			end
			
			if ( operation_mode == "output")
				tmp_combout = 1'bz;
			else
				tmp_combout = padio;
		end
		else    // bus hold is false
		begin
			buf_control = 'b0;
			if ( operation_mode == "input")
			begin
				tmp_combout = padio;
			end
			else if (operation_mode == "output" || operation_mode == "bidir")
			begin
				if ( operation_mode  == "bidir")
					tmp_combout = padio;
				
				if ( oe_in == 1 )
				begin
					if ( open_drain_output == "true" )
					begin
						if (datain_in == 0)
							tmp_padio = 1'b0;
						else if ( datain_in == 1'bx)
							tmp_padio = 1'bx;
						else
							tmp_padio = 1'bz;
					end
					else
						tmp_padio = datain_in;
				end
				else if ( oe_in == 0 )
					tmp_padio = 1'bz;
				else
					tmp_padio = 1'bx;
			end
			else
				$display ("Error: Invalid operation_mode specified in cyclone io atom!\n");
			end
		end
   
   bufif1 (weak1, weak0) b(padio_tmp, prev_value, buf_control);  //weak value
   pmos (padio_tmp, tmp_padio, 'b0);
   pmos (combout, tmp_combout, 'b0);
   pmos (padio, padio_tmp, 'b0);
   and (regout, regin, 1'b1);
endmodule

///////////////////////////////////////////////////////////////////////////////
//
// CYCLONE IO Atom
//
///////////////////////////////////////////////////////////////////////////////
`timescale 1 ps/1 ps

module cyclone_io (datain, oe, outclk, outclkena, inclk, inclkena, areset, sreset,
					devclrn, devpor, devoe,
                   padio, combout, regout);

	parameter operation_mode = "input";
	parameter open_drain_output = "false";
	parameter bus_hold = "false";

	parameter output_register_mode = "none";
	parameter output_async_reset = "none";
	parameter output_sync_reset = "none";
	parameter output_power_up = "low";
	parameter tie_off_output_clock_enable = "false";
	
	parameter oe_register_mode = "none";
	parameter oe_async_reset = "none";
	parameter oe_sync_reset = "none";
	parameter oe_power_up = "low";
	parameter tie_off_oe_clock_enable = "false";

	parameter input_register_mode = "none";
	parameter input_async_reset = "none";
	parameter input_sync_reset = "none";
	parameter input_power_up = "low";

	inout		padio;
	input		datain, oe;
	input		outclk, outclkena, inclk, inclkena, areset, sreset;
	input		devclrn, devpor, devoe;
 	output		combout, regout;
	
	wire	out_reg_clk_ena, oe_reg_clk_ena;

	wire	tmp_oe_reg_out, tmp_input_reg_out, tmp_output_reg_out; 
	
	wire	inreg_sreset_is_used, outreg_sreset_is_used, oereg_sreset_is_used;

	wire	inreg_sreset, outreg_sreset, oereg_sreset;

	wire	in_reg_aclr, in_reg_apreset;
	
	wire	oe_reg_aclr, oe_reg_apreset, oe_reg_sel;
	
	wire	out_reg_aclr, out_reg_apreset, out_reg_sel;
	
	wire	input_reg_pu_low, output_reg_pu_low, oe_reg_pu_low;
	
	wire	inreg_D, outreg_D, oereg_D;

	wire	tmp_datain, tmp_oe;
	wire	iareset, isreset;

	assign input_reg_pu_low = ( input_power_up == "low") ? 'b0 : 'b1;
	assign output_reg_pu_low = ( output_power_up == "low") ? 'b0 : 'b1;
	assign oe_reg_pu_low = ( oe_power_up == "low") ? 'b0 : 'b1;
	
	assign  out_reg_sel = (output_register_mode == "register" ) ? 'b1 : 'b0;
	assign	oe_reg_sel = ( oe_register_mode == "register" ) ? 'b1 : 'b0;
	 
	assign	iareset = ( areset === 'b0 || areset === 'b1 ) ? !areset : 'b1;
	assign	isreset = ( sreset === 'b0 || sreset === 'b1 ) ? sreset : 'b0;

	// output register signals
	assign out_reg_aclr = (output_async_reset == "clear") ? iareset : 'b1;
	assign out_reg_apreset = ( output_async_reset == "preset") ? iareset : 'b1;
    assign outreg_sreset_is_used = ( output_sync_reset == "none") ? 'b0 : 'b1;
	assign outreg_sreset = (output_sync_reset == "clear") ? 'b0 : 'b1;

	// oe register signals
	assign oe_reg_aclr = ( oe_async_reset == "clear") ? iareset : 'b1;
	assign oe_reg_apreset = ( oe_async_reset == "preset") ? iareset : 'b1;
	assign oereg_sreset_is_used = ( oe_sync_reset == "none") ? 'b0 : 'b1;
	assign oereg_sreset = (oe_sync_reset == "clear") ? 'b0 : 'b1;

	// input register signals
	assign in_reg_aclr = ( input_async_reset == "clear") ? iareset : 'b1;
	assign in_reg_apreset = ( input_async_reset == "preset") ? iareset : 'b1;
	assign inreg_sreset_is_used = ( input_sync_reset == "none") ? 'b0 : 'b1;
	assign inreg_sreset = (input_sync_reset == "clear") ? 'b0 : 'b1;

	// oe and output register clock enable signals
	assign out_reg_clk_ena = ( tie_off_output_clock_enable == "true") ? 'b1 : outclkena;
	assign oe_reg_clk_ena = ( tie_off_oe_clock_enable == "true") ? 'b1 : outclkena;

	// input reg
	mux21 inreg_D_mux (.MO (inreg_D),
			           .A (padio),
			           .B (inreg_sreset),
			           .S (isreset && inreg_sreset_is_used));
   
	dffe input_reg (.Q (tmp_input_reg_out),
                       .CLK (inclk),
                       .ENA (inclkena),
                       .D (inreg_D),
                       .CLRN (in_reg_aclr && devclrn && (input_reg_pu_low || devpor)),
                       .PRN (in_reg_apreset && (!input_reg_pu_low || devpor)));
	//output reg
	mux21 outreg_D_mux (.MO (outreg_D),
			           .A (datain),
			           .B (outreg_sreset),
			           .S (isreset && outreg_sreset_is_used));

	dffe output_reg (.Q (tmp_output_reg_out),
                     .CLK (outclk),
                     .ENA (out_reg_clk_ena),
                     .D (outreg_D),
                     .CLRN (out_reg_aclr && devclrn && (output_reg_pu_low || devpor)),
                     .PRN (out_reg_apreset && (!output_reg_pu_low || devpor)));
	//oe reg
	mux21 oereg_D_mux (.MO (oereg_D),
			           .A (oe),
			           .B (oereg_sreset),
			           .S (isreset && oereg_sreset_is_used));

	dffe oe_reg (.Q (tmp_oe_reg_out),
                 .CLK (outclk),
                 .ENA (oe_reg_clk_ena),
                 .D (oereg_D),
                 .CLRN (oe_reg_aclr && devclrn && (oe_reg_pu_low || devpor)),
				 .PRN (oe_reg_apreset && (!oe_reg_pu_low || devpor)));

	// asynchronous block
	assign tmp_oe = (oe_reg_sel == 'b1) ? tmp_oe_reg_out : oe;
	assign tmp_datain = ((operation_mode == "output" || operation_mode == "bidir") && out_reg_sel == 'b1 ) ? tmp_output_reg_out : datain;

	cyclone_asynch_io	asynch_inst(.datain(tmp_datain),
                                    .oe(tmp_oe),
                                    .regin(tmp_input_reg_out),
                                    .padio(padio),
                                    .combout(combout),
                                    .regout(regout));
	defparam asynch_inst.operation_mode = operation_mode;
	defparam asynch_inst.bus_hold = bus_hold;
	defparam asynch_inst.open_drain_output = open_drain_output;

endmodule
///////////////////////////////////////////////////////////////////////
//
// CYCLONE SPIBLOCK Atom
//
///////////////////////////////////////////////////////////////////////

`timescale 1 ps/1 ps
module  cyclone_asmiblock 
	(
	dclkin,
	scein,
	sdoin,
	data0out,
	oe
	);

input dclkin;
input scein;
input sdoin;
input oe;

output data0out;

parameter lpm_type = "cyclone_asmiblock";

endmodule
