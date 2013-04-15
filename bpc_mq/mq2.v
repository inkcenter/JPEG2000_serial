`timescale 1ns/10ps
module mq
     ( //output
	   MQ_out,
	   word_last_flag,
	   stop,
	   data_valid_pass_reg,
	   flush_over,
	   word_last_valid,
	   bit_enough_to_bpc,
	   one_codeblock_over,
	   //input
	   PCXD,
	   flush,
	   clk,
	   rst,
	   rst_syn,
	   start_aga,
	   song_require,
	   block_all_bp_over);
	   
output [15:0]MQ_out; //from fifo
output word_last_flag;
output stop;
output[1:0] data_valid_pass_reg;
output flush_over;
output[1:0]word_last_valid;
output bit_enough_to_bpc;
output one_codeblock_over;

input[7:0] PCXD;
input flush;           	
input clk,rst;
input rst_syn;
input start_aga;
input [13:0]song_require;
input block_all_bp_over;

reg flush_reg;

always @(posedge clk or negedge rst)
 if(!rst)
   flush_reg<=1'b0;
 else if(rst_syn)
	flush_reg<=1'b0;
 else if(start_aga) 
   flush_reg<=1'b0;
 else
   flush_reg<=flush;
   
reg[7:0] PCXD_reg;

always @(posedge clk or negedge rst)
 if(!rst)
	PCXD_reg<=8'b0;
  else if(rst_syn)
	PCXD_reg<=8'b0;
 else if(start_aga) begin
   PCXD_reg<=8'b0;
 end
 else
   PCXD_reg<=PCXD;
   
wire shift_judge_stop_end;


wire D=PCXD_reg[0];
wire[4:0]CX=PCXD_reg[5:1];
wire[1:0]pass=PCXD_reg[7:6];   
wire start_MQ=(pass==2'b00)? shift_judge_stop_end:1;

reg[4:0] cx_delay_for_stop;

reg[1:0] count_stop;

always @(posedge clk or negedge rst) begin
  if(!rst) begin
    cx_delay_for_stop <=5'b0;
  end
  else if(rst_syn)begin
	cx_delay_for_stop <=5'b0;
  end
  else if(start_aga) begin
    cx_delay_for_stop <=5'b0;
  end
  else if( flush_over==1'b1) begin
    cx_delay_for_stop <=5'b0;
  end
  else if(count_stop==1'b1) begin
    cx_delay_for_stop <= CX;
  end
end


parameter ind_cx0=6,
          ind_cx1=8,
		  ind_cx2_17=0,
		  ind_cx18=92;

reg[1:0] fsm_for_out_vlid_n;
reg[1:0] fsm_for_out_vlid;

parameter idle_out=2'b00,
          top_valid_out=2'b01,
		  normal_valid_out=2'b10;
		  
always @(posedge clk or negedge rst) begin
  if(!rst) begin
    fsm_for_out_vlid <=2'b00;
  end
  else if(rst_syn)begin
	 fsm_for_out_vlid <=2'b00;
  end
  else if(start_aga) begin
    fsm_for_out_vlid <=2'b00;
  end
  else begin
    fsm_for_out_vlid <= fsm_for_out_vlid_n;
  end
end

always @(*) begin
  fsm_for_out_vlid_n = fsm_for_out_vlid;
  case(fsm_for_out_vlid)
    idle_out:             begin
	                       if({CX,D}!=6'b0) begin
						     if(pass!=2'b11) begin
							   fsm_for_out_vlid_n = normal_valid_out;
							 end
							 else begin
							   fsm_for_out_vlid_n = top_valid_out;
							 end
						   end
                           else begin
						       fsm_for_out_vlid_n = idle_out;
                           end
                         end	
    top_valid_out:        begin
                            if((pass==2'b10)||(pass==2'b01)) begin
							   fsm_for_out_vlid_n = normal_valid_out;
							end
                            else if(flush_over==1'b1) begin
                               fsm_for_out_vlid_n = idle_out;
                            end
                            else begin
                               fsm_for_out_vlid_n =  top_valid_out;
                            end
                          end	
    
	normal_valid_out:     begin
                            if(flush_over==1'b1) begin
                              fsm_for_out_vlid_n = idle_out;
                            end
                            else begin
                              fsm_for_out_vlid_n =  normal_valid_out;
                            end
                          end	
    
	default:			  begin			 
                             fsm_for_out_vlid_n =2'b11;
						  end
  endcase
end
	
wire top_valid;
wire normal_valid;

assign top_valid = (fsm_for_out_vlid == top_valid_out);
assign normal_valid = (fsm_for_out_vlid == normal_valid_out);
	
reg stop_delay;

reg flush_over;
		  

reg [15:0]Qe1; 
wire MPS1;
wire D_eq_MPS1;
reg D_eq_MPS1_delay;
reg[4:0] CX1;
wire CX_eq_CX1;
reg[1:0] pass1;
wire pass_eq_pass1;
reg [6:0]NMPS1;
reg [6:0]NLPS1;
reg [6:0]index;
wire[6:0]index_next;  
wire[6:0]index_final;       
reg [6:0]index_cx0_sp,index_cx1_sp,index_cx2_sp,index_cx3_sp,index_cx4_sp,index_cx5_sp,index_cx6_sp;
reg [6:0]index_cx7_sp,index_cx8_sp,index_cx9_sp,index_cx10_sp,index_cx11_sp,index_cx12_sp,index_cx13_sp;
reg [6:0]index_cx14_sp,index_cx15_sp,index_cx16_sp,index_cx17_sp,index_cx18_sp;

//*************************index for SP*************************//

reg [6:0]index_cx0_mrp,index_cx1_mrp,index_cx2_mrp,index_cx3_mrp,index_cx4_mrp,index_cx5_mrp,index_cx6_mrp;
reg [6:0]index_cx7_mrp,index_cx8_mrp,index_cx9_mrp,index_cx10_mrp,index_cx11_mrp,index_cx12_mrp,index_cx13_mrp;
reg [6:0]index_cx14_mrp,index_cx15_mrp,index_cx16_mrp,index_cx17_mrp,index_cx18_mrp;
		 
//*************************index for mrp***********************//

reg [6:0]index_cx0_cp,index_cx1_cp,index_cx2_cp,index_cx3_cp,index_cx4_cp,index_cx5_cp,index_cx6_cp;
reg [6:0]index_cx7_cp,index_cx8_cp,index_cx9_cp,index_cx10_cp,index_cx11_cp,index_cx12_cp,index_cx13_cp;
reg [6:0]index_cx14_cp,index_cx15_cp,index_cx16_cp,index_cx17_cp,index_cx18_cp;

//*************************index for cp***********************//


always @(*)
  begin
      case({pass,CX})
    	7'b0100000:   index=index_cx0_sp;
    	7'b0100001:   index=index_cx1_sp;
    	7'b0100010:   index=index_cx2_sp;
    	7'b0100011:   index=index_cx3_sp;
    	7'b0100100:   index=index_cx4_sp;
    	7'b0100101:   index=index_cx5_sp;  //91;
    	7'b0100110:   index=index_cx6_sp;
    	7'b0100111:   index=index_cx7_sp;
    	7'b0101000:   index=index_cx8_sp;
    	7'b0101001:   index=index_cx9_sp;
    	7'b0101010:   index=index_cx10_sp;
    	7'b0101011:   index=index_cx11_sp;
    	7'b0101100:   index=index_cx12_sp;
    	7'b0101101:   index=index_cx13_sp;
    	7'b0101110:   index=index_cx14_sp;
    	7'b0101111:   index=index_cx15_sp;
    	7'b0110000:   index=index_cx16_sp;
    	7'b0110001:   index=index_cx17_sp;
    	7'b0110010:   index=index_cx18_sp;
		
		7'b1000000:   index=index_cx0_mrp;
    	7'b1000001:   index=index_cx1_mrp;
    	7'b1000010:   index=index_cx2_mrp;
    	7'b1000011:   index=index_cx3_mrp;
    	7'b1000100:   index=index_cx4_mrp;
    	7'b1000101:   index=index_cx5_mrp;  //91;
    	7'b1000110:   index=index_cx6_mrp;
    	7'b1000111:   index=index_cx7_mrp;
    	7'b1001000:   index=index_cx8_mrp;
    	7'b1001001:   index=index_cx9_mrp;
    	7'b1001010:   index=index_cx10_mrp;
    	7'b1001011:   index=index_cx11_mrp;
    	7'b1001100:   index=index_cx12_mrp;
    	7'b1001101:   index=index_cx13_mrp;
    	7'b1001110:   index=index_cx14_mrp;
    	7'b1001111:   index=index_cx15_mrp;
    	7'b1010000:   index=index_cx16_mrp;
    	7'b1010001:   index=index_cx17_mrp;
    	7'b1010010:   index=index_cx18_mrp;
		
		
		7'b1100000:   index=index_cx0_cp;
    	7'b1100001:   index=index_cx1_cp;
    	7'b1100010:   index=index_cx2_cp;
    	7'b1100011:   index=index_cx3_cp;
    	7'b1100100:   index=index_cx4_cp;
    	7'b1100101:   index=index_cx5_cp;  //91;
    	7'b1100110:   index=index_cx6_cp;
    	7'b1100111:   index=index_cx7_cp;
    	7'b1101000:   index=index_cx8_cp;
    	7'b1101001:   index=index_cx9_cp;
    	7'b1101010:   index=index_cx10_cp;
    	7'b1101011:   index=index_cx11_cp;
    	7'b1101100:   index=index_cx12_cp;
    	7'b1101101:   index=index_cx13_cp;
    	7'b1101110:   index=index_cx14_cp;
    	7'b1101111:   index=index_cx15_cp;
    	7'b1110000:   index=index_cx16_cp;
    	7'b1110001:   index=index_cx17_cp;
    	7'b1110010:   index=index_cx18_cp;
    	default:      index=7'b0;
      endcase
    end

  
 //-----------D_eq_MPS1------------index_final--------------// 
 
 assign MPS1=(index_final[0]);
 assign D_eq_MPS1=(D==MPS1);
 
 always @(posedge clk or negedge rst)
  if(!rst)
	D_eq_MPS1_delay<=0;
   else if(rst_syn)begin
	D_eq_MPS1_delay<=0;
   end
  else if(start_aga) begin
   D_eq_MPS1_delay<=0;
  end
  else if(start_MQ&&(!stop_delay))
   D_eq_MPS1_delay<=D_eq_MPS1;
  
   
 always @(posedge clk or negedge rst)
	if(!rst)
		CX1<=0;
	else if(rst_syn)begin
		CX1<=0;
	end
	else if(start_aga) begin
		CX1<=0;
	end	 
	else if(shift_judge_stop_end)
		CX1<= cx_delay_for_stop;
	else if(start_MQ&&(!stop_delay))
		CX1<=CX;
	 
 
 always @(posedge clk or negedge rst)
   if(!rst)
     pass1<=0;
	else if(rst_syn)begin
		 pass1<=0;
	end
   else if(start_aga) begin
     pass1<=0;
   end
   else if(shift_judge_stop_end)
     pass1<=pass1;
   else if(start_MQ&&(!stop_delay))
     pass1<=pass;
   else if(stop_delay==1'b1)
     pass1<= pass1;   
   else if(start_MQ==0)
     pass1<=0;
	 
assign CX_eq_CX1=(CX1==CX);
assign pass_eq_pass1=(pass1==pass); 

wire renorm;

wire sel_index;

reg[6:0] index_delay;

always @(posedge clk or negedge rst) begin
  if(!rst) begin
    index_delay<=7'b0;
  end
  else if(rst_syn)begin
	index_delay<=7'b0;
  end
  else if(start_aga) begin
    index_delay<=7'b0;
  end
  else if(flush_over) begin
    index_delay<=7'b0;
  end
  else if(count_stop==1'b1) begin
    index_delay<=index_final;
  end
end
 

assign sel_index=(pass_eq_pass1 && CX_eq_CX1 && renorm);

assign index_final=(shift_judge_stop_end)? index_delay:(sel_index)? index_next:index;

reg[3:0] count_Qe0;


 //Qe1,NMPS1,NLPS1
always @(posedge clk or negedge rst)
  if(!rst)
    begin
      Qe1<=16'b0;NMPS1<=0;NLPS1<=0;count_Qe0<=4'b0;
    end
	 else if(rst_syn)begin
		 Qe1<=16'b0;NMPS1<=0;NLPS1<=0;count_Qe0<=4'b0;
	 end
  else if(start_aga)
    begin
      Qe1<=16'b0;NMPS1<=0;NLPS1<=0;count_Qe0<=4'b0;
    end	
  else if(start_MQ&&(!stop_delay))
  case(index_final)
    0:
      begin
        Qe1<=16'h5601;NMPS1<=2;NLPS1<=3; count_Qe0<=1;
      end
    1:
      begin
        Qe1<=16'h5601;NMPS1<=3;NLPS1<=2; count_Qe0<=1;
      end
    2:
      begin
        Qe1<=16'h3401;NMPS1<=4;NLPS1<=12; count_Qe0<=2;
      end
    3:
      begin
        Qe1<=16'h3401;NMPS1<=5;NLPS1<=13; count_Qe0<=2;
      end
    4:
      begin
        Qe1<=16'h1801;NMPS1<=6;NLPS1<=18; count_Qe0<=3;
      end
    5:
      begin
        Qe1<=16'h1801;NMPS1<=7;NLPS1<=19; count_Qe0<=3;
      end
    6:
      begin
        Qe1<=16'h0ac1;NMPS1<=8;NLPS1<=24; count_Qe0<=4;
      end
    7:
      begin
        Qe1<=16'h0ac1;NMPS1<=9;NLPS1<=25; count_Qe0<=4;
      end
    8:
      begin
        Qe1<=16'h0521;NMPS1<=10;NLPS1<=58; count_Qe0<=5;
      end
    9:
      begin
        Qe1<=16'h0521;NMPS1<=11;NLPS1<=59; count_Qe0<=5;
      end
    10:
      begin
        Qe1<=16'h0221;NMPS1<=76;NLPS1<=66; count_Qe0<=6;
      end 
    11:
      begin
        Qe1<=16'h0221;NMPS1<=77;NLPS1<=67; count_Qe0<=6;
      end  
    12:
      begin
        Qe1<=16'h5601;NMPS1<=14;NLPS1<=13; count_Qe0<=1;
      end 
    13:
      begin
        Qe1<=16'h5601;NMPS1<=15;NLPS1<=12; count_Qe0<=1;
      end
    14:
      begin
        Qe1<=16'h5401;NMPS1<=16;NLPS1<=28; count_Qe0<=1;
      end 
    15:
      begin
        Qe1<=16'h5401;NMPS1<=17;NLPS1<=29; count_Qe0<=1;
      end  
    16:
      begin
        Qe1<=16'h4801;NMPS1<=18;NLPS1<=28; count_Qe0<=1;
      end 
    17:
      begin
        Qe1<=16'h4801;NMPS1<=19;NLPS1<=29; count_Qe0<=1;
      end
    18:
      begin
        Qe1<=16'h3801;NMPS1<=20;NLPS1<=28; count_Qe0<=2;
      end 
    19:
      begin
        Qe1<=16'h3801;NMPS1<=21;NLPS1<=29; count_Qe0<=2;
      end  
    20:
      begin
        Qe1<=16'h3001;NMPS1<=22;NLPS1<=34; count_Qe0<=2;
      end 
    21:
      begin
        Qe1<=16'h3001;NMPS1<=23;NLPS1<=35; count_Qe0<=2;
      end
    22:
      begin
        Qe1<=16'h2401;NMPS1<=24;NLPS1<=36; count_Qe0<=2;
      end 
    23:
      begin
        Qe1<=16'h2401;NMPS1<=25;NLPS1<=37; count_Qe0<=2;
      end  
    24:
      begin
        Qe1<=16'h1c01;NMPS1<=26;NLPS1<=40; count_Qe0<=3;
      end 
    25:
      begin
        Qe1<=16'h1c01;NMPS1<=27;NLPS1<=41; count_Qe0<=3;
      end  
    26:
      begin
        Qe1<=16'h1601;NMPS1<=58;NLPS1<=42; count_Qe0<=3;
      end 
    27:
      begin
        Qe1<=16'h1601;NMPS1<=59;NLPS1<=43; count_Qe0<=3;
      end  
    28:
      begin
        Qe1<=16'h5601;NMPS1<=30;NLPS1<=29; count_Qe0<=1;
      end 
    29:
      begin
        Qe1<=16'h5601;NMPS1<=31;NLPS1<=28; count_Qe0<=1;
      end 
      
    
    30:
      begin
        Qe1<=16'h5401;NMPS1<=32;NLPS1<=28; count_Qe0<=1;
      end
    31:
      begin
        Qe1<=16'h5401;NMPS1<=33;NLPS1<=29; count_Qe0<=1;
      end
    32:
      begin
        Qe1<=16'h5101;NMPS1<=34;NLPS1<=30; count_Qe0<=1;
      end
    33:
      begin
        Qe1<=16'h5101;NMPS1<=35;NLPS1<=31; count_Qe0<=1;
      end
    34:
      begin
        Qe1<=16'h4801;NMPS1<=36;NLPS1<=32; count_Qe0<=1;
      end
    35:
      begin
        Qe1<=16'h4801;NMPS1<=37;NLPS1<=33; count_Qe0<=1;
      end
    36:
      begin
        Qe1<=16'h3801;NMPS1<=38;NLPS1<=34; count_Qe0<=2;
      end
    37:
      begin
        Qe1<=16'h3801;NMPS1<=39;NLPS1<=35; count_Qe0<=2;
      end
    38:
      begin
        Qe1<=16'h3401;NMPS1<=40;NLPS1<=36; count_Qe0<=2;
      end
    39:
      begin
        Qe1<=16'h3401;NMPS1<=41;NLPS1<=37; count_Qe0<=2;
      end
    40:
      begin
        Qe1<=16'h3001;NMPS1<=42;NLPS1<=38; count_Qe0<=2;
      end 
    41:
      begin
        Qe1<=16'h3001;NMPS1<=43;NLPS1<=39; count_Qe0<=2;
      end  
    42:
      begin
        Qe1<=16'h2801;NMPS1<=44;NLPS1<=38; count_Qe0<=2;
      end 
    43:
      begin
        Qe1<=16'h2801;NMPS1<=45;NLPS1<=39; count_Qe0<=2;
      end
    44:
      begin
        Qe1<=16'h2401;NMPS1<=46;NLPS1<=40; count_Qe0<=2;
      end 
    45:
      begin
        Qe1<=16'h2401;NMPS1<=47;NLPS1<=41; count_Qe0<=2;
      end  
    46:
      begin
        Qe1<=16'h2201;NMPS1<=48;NLPS1<=42; count_Qe0<=2;
      end 
    47:
      begin
        Qe1<=16'h2201;NMPS1<=49;NLPS1<=43; count_Qe0<=2;
      end
    48:
      begin
        Qe1<=16'h1c01;NMPS1<=50;NLPS1<=44; count_Qe0<=3;
      end 
    49:
      begin
        Qe1<=16'h1c01;NMPS1<=51;NLPS1<=45; count_Qe0<=3;
      end  
    50:
      begin
        Qe1<=16'h1801;NMPS1<=52;NLPS1<=46; count_Qe0<=3;
      end 
    51:
      begin
        Qe1<=16'h1801;NMPS1<=53;NLPS1<=47; count_Qe0<=3;
      end
    52:
      begin
        Qe1<=16'h1601;NMPS1<=54;NLPS1<=48; count_Qe0<=3;
      end 
    53:
      begin
        Qe1<=16'h1601;NMPS1<=55;NLPS1<=49; count_Qe0<=3;
      end  
    54:
      begin
        Qe1<=16'h1401;NMPS1<=56;NLPS1<=50; count_Qe0<=3;
      end 
    55:
      begin
        Qe1<=16'h1401;NMPS1<=57;NLPS1<=51; count_Qe0<=3;
      end  
    56:
      begin
        Qe1<=16'h1201;NMPS1<=58;NLPS1<=52; count_Qe0<=3;
      end 
    57:
      begin
        Qe1<=16'h1201;NMPS1<=59;NLPS1<=53; count_Qe0<=3;
      end  
    58:
      begin
        Qe1<=16'h1101;NMPS1<=60;NLPS1<=54; count_Qe0<=3;
      end 
    59:
      begin
        Qe1<=16'h1101;NMPS1<=61;NLPS1<=55; count_Qe0<=3;
      end   
    60:
      begin
        Qe1<=16'h0ac1;NMPS1<=62;NLPS1<=56; count_Qe0<=4;
      end
    61:
      begin
        Qe1<=16'h0ac1;NMPS1<=63;NLPS1<=57; count_Qe0<=4;
      end
    62:
      begin
        Qe1<=16'h09c1;NMPS1<=64;NLPS1<=58; count_Qe0<=4;
      end
    63:
      begin
        Qe1<=16'h09c1;NMPS1<=65;NLPS1<=59; count_Qe0<=4;
      end
    64:
      begin
        Qe1<=16'h08a1;NMPS1<=66;NLPS1<=60; count_Qe0<=4;
      end
    65:
      begin
        Qe1<=16'h08a1;NMPS1<=67;NLPS1<=61; count_Qe0<=4;
      end
    66:
      begin
        Qe1<=16'h0521;NMPS1<=68;NLPS1<=62; count_Qe0<=5;
      end
    67:
      begin
        Qe1<=16'h0521;NMPS1<=69;NLPS1<=63; count_Qe0<=5;
      end
    68:
      begin
        Qe1<=16'h0441;NMPS1<=70;NLPS1<=64; count_Qe0<=5;
      end
    69:
      begin
        Qe1<=16'h0441;NMPS1<=71;NLPS1<=65; count_Qe0<=5;
      end
    70:
      begin
        Qe1<=16'h02a1;NMPS1<=72;NLPS1<=66; count_Qe0<=6;
      end 
    71:
      begin
        Qe1<=16'h02a1;NMPS1<=73;NLPS1<=67; count_Qe0<=6;
      end  
    72:
      begin
        Qe1<=16'h0221;NMPS1<=74;NLPS1<=68; count_Qe0<=6;
      end 
    73:
      begin
        Qe1<=16'h0221;NMPS1<=75;NLPS1<=69; count_Qe0<=6;
      end
    74:
      begin
        Qe1<=16'h0141;NMPS1<=76;NLPS1<=70; count_Qe0<=7;
      end 
    75:
      begin
        Qe1<=16'h0141;NMPS1<=77;NLPS1<=71; count_Qe0<=7;
      end  
    76:
      begin
        Qe1<=16'h0111;NMPS1<=78;NLPS1<=72; count_Qe0<=7;
      end 
    77:
      begin
        Qe1<=16'h0111;NMPS1<=79;NLPS1<=73; count_Qe0<=7;
      end
    78:
      begin
        Qe1<=16'h0085;NMPS1<=80;NLPS1<=74; count_Qe0<=8;
      end 
    79:
      begin
        Qe1<=16'h0085;NMPS1<=81;NLPS1<=75; count_Qe0<=8;
      end  
    80:
      begin
        Qe1<=16'h0049;NMPS1<=82;NLPS1<=76; count_Qe0<=9;
      end 
    81:
      begin
        Qe1<=16'h0049;NMPS1<=83;NLPS1<=77; count_Qe0<=9;
      end
    82:
      begin
        Qe1<=16'h0025;NMPS1<=84;NLPS1<=78; count_Qe0<=10;
      end 
    83:
      begin
        Qe1<=16'h0025;NMPS1<=85;NLPS1<=79; count_Qe0<=10;
      end  
    84:
      begin
        Qe1<=16'h0015;NMPS1<=86;NLPS1<=80; count_Qe0<=11;
      end 
    85:
      begin
        Qe1<=16'h0015;NMPS1<=87;NLPS1<=81; count_Qe0<=11;
      end  
    86:
      begin
        Qe1<=16'h0009;NMPS1<=88;NLPS1<=82; count_Qe0<=12;
      end 
    87:
      begin
        Qe1<=16'h0009;NMPS1<=89;NLPS1<=83; count_Qe0<=12;
      end  
    88:
      begin
        Qe1<=16'h0005;NMPS1<=90;NLPS1<=84; count_Qe0<=13;
      end 
    89:
      begin
        Qe1<=16'h0005;NMPS1<=91;NLPS1<=85; count_Qe0<=13;
      end   
    90:
      begin
        Qe1<=16'h0001;NMPS1<=90;NLPS1<=86; count_Qe0<=15;
      end 
    91:
      begin
        Qe1<=16'h0001;NMPS1<=91;NLPS1<=87; count_Qe0<=15;
      end  
    92:
      begin
        Qe1<=16'h5601;NMPS1<=92;NLPS1<=92; count_Qe0<=1;
      end 
    93:
      begin
        Qe1<=16'h5601;NMPS1<=93;NLPS1<=93; count_Qe0<=1;
      end  
    
    default:
      begin
        Qe1<=16'b0;NMPS1<=7'b0;NLPS1<=7'b0;count_Qe0<=4'b0;
      end    
      
  endcase
  
  

  
	
//--------flush_en for pipline4 and 5---------//
//when there is bit coded in the MQ,flush is active;otherwise don't flush 

reg[3:0] count_flush_delay0;
  
parameter  sidle=2'b00;

parameter  s_flush_wait=2'b01;

parameter  s_flush=2'b11;
 
          

reg[1:0] state,nxstate;

always @(posedge clk or negedge rst)
  if(!rst)
   state<=sidle;
	else if(rst_syn)begin
		state<=sidle;
	end  
  else if(start_aga) begin
   state<=sidle;
  end   
  else 
   state<=nxstate;

always @(*)
  case(state)
  sidle:            if(flush_reg)
	                  nxstate=s_flush_wait;
			        else
			          nxstate=sidle;
  
  s_flush_wait:     if(!start_MQ)	
                      nxstate=s_flush;
					else
					  nxstate=s_flush_wait;
			  
  s_flush:          if(count_flush_delay0==10)
	                  nxstate=sidle;
			        else
			          nxstate=s_flush;
		
  endcase	
	
//to indicate the num of clk cycles the flush signal hold at 1
//the flush=1 keep for 9 clks
always @(posedge clk or negedge rst)
  if(!rst)
    count_flush_delay0<=0;
  else if(rst_syn)
	count_flush_delay0<=0;
  else if(start_aga) 
    count_flush_delay0<=0;
  else if(flush_over)
    count_flush_delay0<=0;
  else if(state==s_flush)
    count_flush_delay0<=count_flush_delay0+1;
  else if(count_flush_delay0==11)
    count_flush_delay0<=0;
 
 

wire flush_en_delay0_0=(!flush_over)?((state==s_flush)&&(count_flush_delay0==0)):0;
wire flush_en_delay0_1=(!flush_over)?(count_flush_delay0==1):0;
wire flush_en_delay0_2=(!flush_over)?(count_flush_delay0==2):0;
wire flush_en_delay0_3=(!flush_over)?(count_flush_delay0==3):0;
wire flush_en_delay0_4=(!flush_over)?(count_flush_delay0==4):0;
wire flush_en_delay0_5=(!flush_over)?(count_flush_delay0==5):0;
wire flush_en_delay0_6=(!flush_over)?(count_flush_delay0==6):0;
wire flush_en_delay0_7=(!flush_over)?(count_flush_delay0==7):0;
wire flush_en_delay0_8=(!flush_over)?(count_flush_delay0==8):0;
wire flush_en_delay0_9=(!flush_over)?(count_flush_delay0==9):0;
wire flush_en_delay0_10=(!flush_over)?(count_flush_delay0==10):0;
wire flush_en_delay0_11=(!flush_over)?(count_flush_delay0==11):0;





//-----------Delay for pipeline 2-------//
  
reg start_MQ_delay1;

always @(posedge clk or negedge rst)
  if(!rst)
    start_MQ_delay1<=0;
  else if(rst_syn)
	start_MQ_delay1<=0;
  else if(start_aga)
    start_MQ_delay1<=0;
  else if((!flush_over)&&(!stop_delay))
    start_MQ_delay1<=start_MQ;
    

reg flush_delay1;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_delay1<=0;
  else if(rst_syn)
	flush_delay1<=0;
  else if(start_aga)
    flush_delay1<=0;	
  else if(flush_over)
    flush_delay1<=0;
  else
    flush_delay1<=((state==s_flush)||(count_flush_delay0==11));

reg flush_en_delay1_sp,flush_en_delay1_mrp,flush_en_delay1_cp;

reg flush_en_delay1_0,flush_en_delay1_1,flush_en_delay1_2,flush_en_delay1_3,flush_en_delay1_4;

reg flush_en_delay1_5,flush_en_delay1_6,flush_en_delay1_7,flush_en_delay1_8;

reg flush_en_delay1_9,flush_en_delay1_10,flush_en_delay1_11;

	
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_0<=0;
  else if(rst_syn)
	flush_en_delay1_0<=0;
  else if(start_aga)
    flush_en_delay1_0<=0;
  else if(flush_over)
    flush_en_delay1_0<=0;
  else
    flush_en_delay1_0<=flush_en_delay0_0;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_1<=0;
  else if(rst_syn)
	flush_en_delay1_1<=0;
  else if(start_aga) 
    flush_en_delay1_1<=0;
  else if(flush_over)
    flush_en_delay1_1<=0;
  else
    flush_en_delay1_1<=flush_en_delay0_1;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_2<=0;
  else if(rst_syn)
	flush_en_delay1_2<=0;
  else if(start_aga) 
    flush_en_delay1_2<=0;		
  else if(flush_over)
    flush_en_delay1_2<=0;
  else
    flush_en_delay1_2<=flush_en_delay0_2;
	

always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_3<=0;
  else if(rst_syn)
	flush_en_delay1_3<=0;
  else if(start_aga) 
    flush_en_delay1_3<=0;	
  else if(flush_over)
    flush_en_delay1_3<=0;
  else
    flush_en_delay1_3<=flush_en_delay0_3;
	
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_4<=0;
  else if(rst_syn)
	flush_en_delay1_4<=0;
  else if(start_aga) 
    flush_en_delay1_4<=0;
  else if(flush_over)
    flush_en_delay1_4<=0;
  else
    flush_en_delay1_4<=flush_en_delay0_4;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_5<=0;
  else if(rst_syn)
	flush_en_delay1_5<=0;
  else if(start_aga) 
    flush_en_delay1_5<=0;
  else if(flush_over)
    flush_en_delay1_5<=0;
  else
    flush_en_delay1_5<=flush_en_delay0_5;
	
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_6<=0;
  else if(rst_syn)
	flush_en_delay1_6<=0;
  else if(start_aga) 
    flush_en_delay1_6<=0;
  else if(flush_over)
    flush_en_delay1_6<=0;
  else
    flush_en_delay1_6<=flush_en_delay0_6;
	

	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_7<=0;
  else if(rst_syn)
	flush_en_delay1_7<=0;
  else if(start_aga) 
    flush_en_delay1_7<=0;
  else if(flush_over)
    flush_en_delay1_7<=0;
  else
    flush_en_delay1_7<=flush_en_delay0_7;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_8<=0;
  else if(rst_syn)
	flush_en_delay1_8<=0;
  else if(start_aga) 
    flush_en_delay1_8<=0;	
  else if(flush_over)
    flush_en_delay1_8<=0;
  else
    flush_en_delay1_8<=flush_en_delay0_8;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_9<=0;
  else if(rst_syn)
	flush_en_delay1_9<=0;
  else if(start_aga) 
    flush_en_delay1_9<=0;
  else if(flush_over)
    flush_en_delay1_9<=0;
  else
    flush_en_delay1_9<=flush_en_delay0_9;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_10<=0;
  else if(rst_syn)
	flush_en_delay1_10<=0;
  else if(start_aga) 
    flush_en_delay1_10<=0;	
  else if(flush_over)
    flush_en_delay1_10<=0;
  else
    flush_en_delay1_10<=flush_en_delay0_10;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_11<=0;
  else if(rst_syn)
	flush_en_delay1_11<=0;
  else if(start_aga) 
    flush_en_delay1_11<=0;
  else if(flush_over)
    flush_en_delay1_11<=0;
  else
    flush_en_delay1_11<=flush_en_delay0_11;
	

always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_sp<=0;
  else if(rst_syn)
	flush_en_delay1_sp<=0;	
  else if(start_aga) 
    flush_en_delay1_sp<=0;
  else if(flush_over)
    flush_en_delay1_sp<=0;
  else
    flush_en_delay1_sp<=(flush_en_delay0_0||flush_en_delay0_2);
	

always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_mrp<=0;
  else if(rst_syn)
	flush_en_delay1_mrp<=0;
  else if(start_aga) 
    flush_en_delay1_mrp<=0;
  else if(flush_over)
    flush_en_delay1_mrp<=0;
  else
    flush_en_delay1_mrp<=(flush_en_delay0_4||flush_en_delay0_6);
	

always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay1_cp<=0;
  else if(rst_syn)
	flush_en_delay1_cp<=0;
  else if(start_aga) 
    flush_en_delay1_cp<=0;
  else if(flush_over)
    flush_en_delay1_cp<=0;
  else
    flush_en_delay1_cp<=(flush_en_delay0_8||flush_en_delay0_10);
	

     
   
 //****************pipline2****************//
 
 
 
//----------renorm------------//

wire space_judge;

wire[15:0]A_sub_Qe;
wire[15:0]A_sub_Qe_shift_1;
wire[15:0]A_sub_Qe_shift_2;
   

reg [1:0]count_A0_1;

assign renorm =(space_judge)? 1:(A_sub_Qe<16'h8000);
//----------------------------//

 
reg [15:0]A;
wire[15:0] A_temp;

assign index_next=(D_eq_MPS1_delay)?NMPS1:NLPS1;
	

wire [16:0]Qe1_t2={Qe1,1'b0};
/*
wire[8:0] cpa={1'b1,A}-Qe1_t2;

assign space_judge=(D_eq_MPS1_delay)? (!cpa[8]):(cpa[8]);
*/
assign space_judge=(D_eq_MPS1_delay)?(A<Qe1_t2):(A>=Qe1_t2);


assign A_sub_Qe=A-Qe1;
assign A_sub_Qe_shift_1={A_sub_Qe[14:0],1'b0};
assign A_sub_Qe_shift_2={A_sub_Qe[13:0],2'b0};

reg[15:0]A_temp_1;

always @(*)
 case(count_A0_1)
     0:  A_temp_1=A_sub_Qe;
     1:  A_temp_1=A_sub_Qe_shift_1;
     2:  A_temp_1=A_sub_Qe_shift_2;
 default:  A_temp_1=15'b0;
 endcase

 
reg[15:0] A_temp_2;

always @(*)
  case(count_Qe0)
    1:     A_temp_2={Qe1[14:0],1'b0};
	2:     A_temp_2={Qe1[13:0],2'b0};
	3:     A_temp_2={Qe1[12:0],3'b0};
	4:     A_temp_2={Qe1[11:0],4'b0};
	5:     A_temp_2={Qe1[10:0],5'b0};
	6:     A_temp_2={Qe1[9:0],6'b0};
	7:     A_temp_2={Qe1[8:0],7'b0};
	8:     A_temp_2={Qe1[7:0],8'b0};
	9:     A_temp_2={Qe1[6:0],9'b0};
    10:    A_temp_2={Qe1[5:0],10'b0};
	11:    A_temp_2={Qe1[4:0],11'b0};
	12:    A_temp_2={Qe1[3:0],12'b0};
	13:    A_temp_2={Qe1[2:0],13'b0};
	15:    A_temp_2={Qe1[0],15'b0};
default:   A_temp_2=16'b0;
  endcase
 
  
assign A_temp=(space_judge)? A_temp_2:A_temp_1;



 //------count_A0_1---//

always @(*)
  begin
    if(A_sub_Qe[15]==1'b1)
      count_A0_1=0;
    else if(A_sub_Qe[14]==1'b1)
      count_A0_1=1;
    else if(A_sub_Qe[13]==1'b1)
      count_A0_1=2;
    else
	  count_A0_1=2'b1;
  end
 
reg[3:0]count_A0; 

always @(*)
 if(space_judge)
  count_A0=count_Qe0;
 else 
  count_A0=count_A0_1;
 


 reg[15:0]A_sp,A_mrp,A_cp;

 
always @(posedge clk or negedge rst)
  begin
    if(!rst)
	  begin
	    A_sp<=16'h8000;
		A_mrp<=16'h8000;
		A_cp<=16'h8000;
	  end
	else if(rst_syn)begin
		A_sp<=16'h8000;
		A_mrp<=16'h8000;
		A_cp<=16'h8000;
	end
	else if(start_aga) begin
        A_sp<=16'h8000;
		A_mrp<=16'h8000;
		A_cp<=16'h8000;
	end
	else if(flush_over)
	  begin
	    A_sp<=16'h8000;
		A_mrp<=16'h8000;
		A_cp<=16'h8000;
	  end
	else if(start_MQ_delay1&&(!stop_delay))
	  begin
	    case(pass1)
	       2'b01:   A_sp<=A_temp;
	       2'b10:   A_mrp<=A_temp;
	       2'b11:   A_cp<=A_temp;
		endcase
	  end
  end
  
always @(*) 
 begin
   case(pass1)
    2'b01:     A=A_sp;
    2'b10:     A=A_mrp;
    2'b11:     A=A_cp;
    default:   A=16'b0;
   endcase
 end
 
	
	
always @(posedge clk or negedge rst)
  begin
    if(!rst)
	  begin
       index_cx0_sp<=ind_cx0;
       index_cx1_sp<=ind_cx1;
       index_cx2_sp<=ind_cx2_17; 
       index_cx3_sp<=ind_cx2_17;
       index_cx4_sp<=ind_cx2_17;
       index_cx5_sp<=ind_cx2_17; 
       index_cx6_sp<=ind_cx2_17;
       index_cx7_sp<=ind_cx2_17;
       index_cx8_sp<=ind_cx2_17;
       index_cx9_sp<=ind_cx2_17;
       index_cx10_sp<=ind_cx2_17;
       index_cx11_sp<=ind_cx2_17;
       index_cx12_sp<=ind_cx2_17;
       index_cx13_sp<=ind_cx2_17;
       index_cx14_sp<=ind_cx2_17;
       index_cx15_sp<=ind_cx2_17;
       index_cx16_sp<=ind_cx2_17;
       index_cx17_sp<=ind_cx2_17;
       index_cx18_sp<=ind_cx18;
	   
	   index_cx0_mrp<=ind_cx0;
       index_cx1_mrp<=ind_cx1;
       index_cx2_mrp<=ind_cx2_17; 
       index_cx3_mrp<=ind_cx2_17;
       index_cx4_mrp<=ind_cx2_17;
       index_cx5_mrp<=ind_cx2_17; 
       index_cx6_mrp<=ind_cx2_17;
       index_cx7_mrp<=ind_cx2_17;
       index_cx8_mrp<=ind_cx2_17;
       index_cx9_mrp<=ind_cx2_17;
       index_cx10_mrp<=ind_cx2_17;
       index_cx11_mrp<=ind_cx2_17;
       index_cx12_mrp<=ind_cx2_17;
       index_cx13_mrp<=ind_cx2_17;
       index_cx14_mrp<=ind_cx2_17;
       index_cx15_mrp<=ind_cx2_17;
       index_cx16_mrp<=ind_cx2_17;
       index_cx17_mrp<=ind_cx2_17;
       index_cx18_mrp<=ind_cx18;
	   
	   index_cx0_cp<=ind_cx0;
       index_cx1_cp<=ind_cx1;
       index_cx2_cp<=ind_cx2_17; 
       index_cx3_cp<=ind_cx2_17;
       index_cx4_cp<=ind_cx2_17;
       index_cx5_cp<=ind_cx2_17; 
       index_cx6_cp<=ind_cx2_17;
       index_cx7_cp<=ind_cx2_17;
       index_cx8_cp<=ind_cx2_17;
       index_cx9_cp<=ind_cx2_17;
       index_cx10_cp<=ind_cx2_17;
       index_cx11_cp<=ind_cx2_17;
       index_cx12_cp<=ind_cx2_17;
       index_cx13_cp<=ind_cx2_17;
       index_cx14_cp<=ind_cx2_17;
       index_cx15_cp<=ind_cx2_17;
       index_cx16_cp<=ind_cx2_17;
       index_cx17_cp<=ind_cx2_17;
       index_cx18_cp<=ind_cx18;
     end
	 else if(rst_syn)
	 begin
		index_cx0_sp<=ind_cx0;
		index_cx1_sp<=ind_cx1;
		index_cx2_sp<=ind_cx2_17; 
		index_cx3_sp<=ind_cx2_17;
		index_cx4_sp<=ind_cx2_17;
		index_cx5_sp<=ind_cx2_17; 
		index_cx6_sp<=ind_cx2_17;
		index_cx7_sp<=ind_cx2_17;
		index_cx8_sp<=ind_cx2_17;
		index_cx9_sp<=ind_cx2_17;
		index_cx10_sp<=ind_cx2_17;
		index_cx11_sp<=ind_cx2_17;
		index_cx12_sp<=ind_cx2_17;
		index_cx13_sp<=ind_cx2_17;
		index_cx14_sp<=ind_cx2_17;
		index_cx15_sp<=ind_cx2_17;
		index_cx16_sp<=ind_cx2_17;
		index_cx17_sp<=ind_cx2_17;
		index_cx18_sp<=ind_cx18;
		
		index_cx0_mrp<=ind_cx0;
		index_cx1_mrp<=ind_cx1;
		index_cx2_mrp<=ind_cx2_17;
		index_cx3_mrp<=ind_cx2_17;
		index_cx4_mrp<=ind_cx2_17;
		index_cx5_mrp<=ind_cx2_17;
		index_cx6_mrp<=ind_cx2_17;
		index_cx7_mrp<=ind_cx2_17;
		index_cx8_mrp<=ind_cx2_17;
		index_cx9_mrp<=ind_cx2_17;
		index_cx10_mrp<=ind_cx2_17;
		index_cx11_mrp<=ind_cx2_17;
		index_cx12_mrp<=ind_cx2_17;
		index_cx13_mrp<=ind_cx2_17;
		index_cx14_mrp<=ind_cx2_17;
		index_cx15_mrp<=ind_cx2_17;
		index_cx16_mrp<=ind_cx2_17;
		index_cx17_mrp<=ind_cx2_17;
		index_cx18_mrp<=ind_cx18;
		
		index_cx0_cp<=ind_cx0;
		index_cx1_cp<=ind_cx1;
		index_cx2_cp<=ind_cx2_17; 
		index_cx3_cp<=ind_cx2_17;
		index_cx4_cp<=ind_cx2_17;
		index_cx5_cp<=ind_cx2_17; 
		index_cx6_cp<=ind_cx2_17;
		index_cx7_cp<=ind_cx2_17;
		index_cx8_cp<=ind_cx2_17;
		index_cx9_cp<=ind_cx2_17;
		index_cx10_cp<=ind_cx2_17;
		index_cx11_cp<=ind_cx2_17;
		index_cx12_cp<=ind_cx2_17;
		index_cx13_cp<=ind_cx2_17;
		index_cx14_cp<=ind_cx2_17;
		index_cx15_cp<=ind_cx2_17;
		index_cx16_cp<=ind_cx2_17;
		index_cx17_cp<=ind_cx2_17;
		index_cx18_cp<=ind_cx18; 
	 end
	 else if(start_aga)
	  begin
       index_cx0_sp<=ind_cx0;
       index_cx1_sp<=ind_cx1;
       index_cx2_sp<=ind_cx2_17; 
       index_cx3_sp<=ind_cx2_17;
       index_cx4_sp<=ind_cx2_17;
       index_cx5_sp<=ind_cx2_17; 
       index_cx6_sp<=ind_cx2_17;
       index_cx7_sp<=ind_cx2_17;
       index_cx8_sp<=ind_cx2_17;
       index_cx9_sp<=ind_cx2_17;
       index_cx10_sp<=ind_cx2_17;
       index_cx11_sp<=ind_cx2_17;
       index_cx12_sp<=ind_cx2_17;
       index_cx13_sp<=ind_cx2_17;
       index_cx14_sp<=ind_cx2_17;
       index_cx15_sp<=ind_cx2_17;
       index_cx16_sp<=ind_cx2_17;
       index_cx17_sp<=ind_cx2_17;
       index_cx18_sp<=ind_cx18;
	   
	   index_cx0_mrp<=ind_cx0;
       index_cx1_mrp<=ind_cx1;
       index_cx2_mrp<=ind_cx2_17; 
       index_cx3_mrp<=ind_cx2_17;
       index_cx4_mrp<=ind_cx2_17;
       index_cx5_mrp<=ind_cx2_17; 
       index_cx6_mrp<=ind_cx2_17;
       index_cx7_mrp<=ind_cx2_17;
       index_cx8_mrp<=ind_cx2_17;
       index_cx9_mrp<=ind_cx2_17;
       index_cx10_mrp<=ind_cx2_17;
       index_cx11_mrp<=ind_cx2_17;
       index_cx12_mrp<=ind_cx2_17;
       index_cx13_mrp<=ind_cx2_17;
       index_cx14_mrp<=ind_cx2_17;
       index_cx15_mrp<=ind_cx2_17;
       index_cx16_mrp<=ind_cx2_17;
       index_cx17_mrp<=ind_cx2_17;
       index_cx18_mrp<=ind_cx18;
	   
	   index_cx0_cp<=ind_cx0;
       index_cx1_cp<=ind_cx1;
       index_cx2_cp<=ind_cx2_17; 
       index_cx3_cp<=ind_cx2_17;
       index_cx4_cp<=ind_cx2_17;
       index_cx5_cp<=ind_cx2_17; 
       index_cx6_cp<=ind_cx2_17;
       index_cx7_cp<=ind_cx2_17;
       index_cx8_cp<=ind_cx2_17;
       index_cx9_cp<=ind_cx2_17;
       index_cx10_cp<=ind_cx2_17;
       index_cx11_cp<=ind_cx2_17;
       index_cx12_cp<=ind_cx2_17;
       index_cx13_cp<=ind_cx2_17;
       index_cx14_cp<=ind_cx2_17;
       index_cx15_cp<=ind_cx2_17;
       index_cx16_cp<=ind_cx2_17;
       index_cx17_cp<=ind_cx2_17;
       index_cx18_cp<=ind_cx18;
     end
    else if(flush_over)
      begin
       index_cx0_sp<=ind_cx0;
       index_cx1_sp<=ind_cx1;
       index_cx2_sp<=ind_cx2_17;
       index_cx3_sp<=ind_cx2_17;
       index_cx4_sp<=ind_cx2_17;
       index_cx5_sp<=ind_cx2_17; 
       index_cx6_sp<=ind_cx2_17;
       index_cx7_sp<=ind_cx2_17;
       index_cx8_sp<=ind_cx2_17;
       index_cx9_sp<=ind_cx2_17;
       index_cx10_sp<=ind_cx2_17;
       index_cx11_sp<=ind_cx2_17;
       index_cx12_sp<=ind_cx2_17;
       index_cx13_sp<=ind_cx2_17;
       index_cx14_sp<=ind_cx2_17;
       index_cx15_sp<=ind_cx2_17;
       index_cx16_sp<=ind_cx2_17;
       index_cx17_sp<=ind_cx2_17;
       index_cx18_sp<=ind_cx18;
	   
	   index_cx0_mrp<=ind_cx0;
       index_cx1_mrp<=ind_cx1;
       index_cx2_mrp<=ind_cx2_17; 
       index_cx3_mrp<=ind_cx2_17;
       index_cx4_mrp<=ind_cx2_17;
       index_cx5_mrp<=ind_cx2_17; 
       index_cx6_mrp<=ind_cx2_17;
       index_cx7_mrp<=ind_cx2_17;
       index_cx8_mrp<=ind_cx2_17;
       index_cx9_mrp<=ind_cx2_17;
       index_cx10_mrp<=ind_cx2_17;
       index_cx11_mrp<=ind_cx2_17;
       index_cx12_mrp<=ind_cx2_17;
       index_cx13_mrp<=ind_cx2_17;
       index_cx14_mrp<=ind_cx2_17;
       index_cx15_mrp<=ind_cx2_17;
       index_cx16_mrp<=ind_cx2_17;
       index_cx17_mrp<=ind_cx2_17;
       index_cx18_mrp<=ind_cx18;
	   	   
	   index_cx0_cp<=ind_cx0;
       index_cx1_cp<=ind_cx1;
       index_cx2_cp<=ind_cx2_17; 
       index_cx3_cp<=ind_cx2_17;
       index_cx4_cp<=ind_cx2_17;
       index_cx5_cp<=ind_cx2_17; 
       index_cx6_cp<=ind_cx2_17;
       index_cx7_cp<=ind_cx2_17;
       index_cx8_cp<=ind_cx2_17;
       index_cx9_cp<=ind_cx2_17;
       index_cx10_cp<=ind_cx2_17;
       index_cx11_cp<=ind_cx2_17;
       index_cx12_cp<=ind_cx2_17;
       index_cx13_cp<=ind_cx2_17;
       index_cx14_cp<=ind_cx2_17;
       index_cx15_cp<=ind_cx2_17;
       index_cx16_cp<=ind_cx2_17;
       index_cx17_cp<=ind_cx2_17;
       index_cx18_cp<=ind_cx18;
      end
    else if(start_MQ_delay1&&renorm&&(!stop_delay))  //&&(!stop))
	  begin
       case({pass1,CX1})

           7'b0100000:   index_cx0_sp<=index_next;
           7'b0100001:   index_cx1_sp<=index_next;
           7'b0100010:   index_cx2_sp<=index_next;
           7'b0100011:   index_cx3_sp<=index_next;
           7'b0100100:   index_cx4_sp<=index_next;
           7'b0100101:   index_cx5_sp<=index_next;
           7'b0100110:   index_cx6_sp<=index_next;
           7'b0100111:   index_cx7_sp<=index_next;
           7'b0101000:   index_cx8_sp<=index_next;
           7'b0101001:   index_cx9_sp<=index_next;
           7'b0101010:  index_cx10_sp<=index_next;
           7'b0101011:  index_cx11_sp<=index_next;
           7'b0101100:  index_cx12_sp<=index_next;
           7'b0101101:  index_cx13_sp<=index_next;
           7'b0101110:  index_cx14_sp<=index_next;
           7'b0101111:  index_cx15_sp<=index_next;
           7'b0110000:  index_cx16_sp<=index_next;
           7'b0110001:  index_cx17_sp<=index_next;
           7'b0110010:  index_cx18_sp<=index_next;
		   
		   
		   7'b1000000:   index_cx0_mrp<=index_next;
           7'b1000001:   index_cx1_mrp<=index_next;
           7'b1000010:   index_cx2_mrp<=index_next;
           7'b1000011:   index_cx3_mrp<=index_next;
           7'b1000100:   index_cx4_mrp<=index_next;
           7'b1000101:   index_cx5_mrp<=index_next;
           7'b1000110:   index_cx6_mrp<=index_next;
           7'b1000111:   index_cx7_mrp<=index_next;
           7'b1001000:   index_cx8_mrp<=index_next;
           7'b1001001:   index_cx9_mrp<=index_next;
           7'b1001010:  index_cx10_mrp<=index_next;
           7'b1001011:  index_cx11_mrp<=index_next;
           7'b1001100:  index_cx12_mrp<=index_next;
           7'b1001101:  index_cx13_mrp<=index_next;
           7'b1001110:  index_cx14_mrp<=index_next;
           7'b1001111:  index_cx15_mrp<=index_next;
           7'b1010000:  index_cx16_mrp<=index_next;
           7'b1010001:  index_cx17_mrp<=index_next;
           7'b1010010:  index_cx18_mrp<=index_next;
		   
		   7'b1100000:   index_cx0_cp<=index_next;
           7'b1100001:   index_cx1_cp<=index_next;
           7'b1100010:   index_cx2_cp<=index_next;
           7'b1100011:   index_cx3_cp<=index_next;
           7'b1100100:   index_cx4_cp<=index_next;
           7'b1100101:   index_cx5_cp<=index_next;
           7'b1100110:   index_cx6_cp<=index_next;
           7'b1100111:   index_cx7_cp<=index_next;
           7'b1101000:   index_cx8_cp<=index_next;
           7'b1101001:   index_cx9_cp<=index_next;
           7'b1101010:  index_cx10_cp<=index_next;
           7'b1101011:  index_cx11_cp<=index_next;
           7'b1101100:  index_cx12_cp<=index_next;
           7'b1101101:  index_cx13_cp<=index_next;
           7'b1101110:  index_cx14_cp<=index_next;
           7'b1101111:  index_cx15_cp<=index_next;
           7'b1110000:  index_cx16_cp<=index_next;
           7'b1110001:  index_cx17_cp<=index_next;
           7'b1110010:  index_cx18_cp<=index_next;
          default: 
            begin
              index_cx0_sp<=7'b0;
              index_cx1_sp<=7'b0;
              index_cx2_sp<=7'b0;
              index_cx3_sp<=7'b0;
              index_cx4_sp<=7'b0;
              index_cx5_sp<=7'b0; 
              index_cx6_sp<=7'b0;
              index_cx7_sp<=7'b0;
              index_cx8_sp<=7'b0;
              index_cx9_sp<=7'b0;
              index_cx10_sp<=7'b0;
              index_cx11_sp<=7'b0;
              index_cx12_sp<=7'b0;
              index_cx13_sp<=7'b0;
              index_cx14_sp<=7'b0;
              index_cx15_sp<=7'b0;
              index_cx16_sp<=7'b0;
              index_cx17_sp<=7'b0;
              index_cx18_sp<=7'b0;
			  
			  index_cx0_mrp<=7'b0;
              index_cx1_mrp<=7'b0;
              index_cx2_mrp<=7'b0;
              index_cx3_mrp<=7'b0;
              index_cx4_mrp<=7'b0;
              index_cx5_mrp<=7'b0; 
              index_cx6_mrp<=7'b0;
              index_cx7_mrp<=7'b0;
              index_cx8_mrp<=7'b0;
              index_cx9_mrp<=7'b0;
              index_cx10_mrp<=7'b0;
              index_cx11_mrp<=7'b0;
              index_cx12_mrp<=7'b0;
              index_cx13_mrp<=7'b0;
              index_cx14_mrp<=7'b0;
              index_cx15_mrp<=7'b0;
              index_cx16_mrp<=7'b0;
              index_cx17_mrp<=7'b0;
              index_cx18_mrp<=7'b0;
			  
			  index_cx0_cp<=7'b0;
              index_cx1_cp<=7'b0;
              index_cx2_cp<=7'b0;
              index_cx3_cp<=7'b0;
              index_cx4_cp<=7'b0;
              index_cx5_cp<=7'b0; 
              index_cx6_cp<=7'b0;
              index_cx7_cp<=7'b0;
              index_cx8_cp<=7'b0;
              index_cx9_cp<=7'b0;
              index_cx10_cp<=7'b0;
              index_cx11_cp<=7'b0;
              index_cx12_cp<=7'b0;
              index_cx13_cp<=7'b0;
              index_cx14_cp<=7'b0;
              index_cx15_cp<=7'b0;
              index_cx16_cp<=7'b0;
              index_cx17_cp<=7'b0;
              index_cx18_cp<=7'b0;
			    
            end
          endcase
	 
     end
  end	
 
//-------delay for pipeline 3-------//
 reg start_MQ_delay2;
always @(posedge clk or negedge rst)
  if(!rst)
    start_MQ_delay2<=0;
  else if(rst_syn)
	start_MQ_delay2<=0;
  else if(start_aga) 
    start_MQ_delay2<=0;
  else if((!flush_over)&&(!stop_delay))
    start_MQ_delay2<=start_MQ_delay1;

	
reg[1:0] pass2;
	
always @(posedge clk or negedge rst)
  if(!rst)
    pass2<=0;
  else if(rst_syn)
	pass2<=0;
  else if(start_aga)
    pass2<=0;
  else if(start_MQ_delay1&&(!stop_delay))
    pass2<=pass1;
  else if(start_MQ_delay1==0)
    pass2<=0;
	
reg space_judge_delay;

always @(posedge clk or negedge rst)
  if(!rst)
    space_judge_delay<=0;
  else if(rst_syn)
	space_judge_delay<=0;
  else if(start_aga)
    space_judge_delay<=0;
  else if(start_MQ_delay1&&(!stop_delay))
    space_judge_delay<=space_judge;
	
reg[15:0] Qe1_delay;

always @(posedge clk or negedge rst)
  if(!rst)
    Qe1_delay<=0;
  else if(rst_syn)
	Qe1_delay<=0;
  else if(start_aga) 
    Qe1_delay<=0;
  else if(start_MQ_delay1&&(!stop_delay))
    Qe1_delay<=Qe1;
	
reg[3:0] count_A0_delay1;

always @(posedge clk or negedge rst)
 if(!rst)
   count_A0_delay1<=0;
 else if(rst_syn)
	count_A0_delay1<=0;
 else if(start_aga) 
   count_A0_delay1<=0;
 else if(start_MQ_delay1&&(!stop_delay))
   count_A0_delay1<=count_A0;

   
reg flush_delay2;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_delay2<=0;
  else if(rst_syn)
	flush_delay2<=0;
  else if(start_aga) 
    flush_delay2<=0;
  else if(flush_over)
    flush_delay2<=0;
  else
    flush_delay2<=flush_delay1;

reg flush_en_delay2_sp,flush_en_delay2_mrp,flush_en_delay2_cp;

reg flush_en_delay2_0,flush_en_delay2_3,flush_en_delay2_6;

reg flush_en_delay2_1,flush_en_delay2_4,flush_en_delay2_7;

reg flush_en_delay2_2,flush_en_delay2_5,flush_en_delay2_8;

reg flush_en_delay2_9,flush_en_delay2_10,flush_en_delay2_11;
	
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_0<=0;
  else if(rst_syn)
	flush_en_delay2_0<=0;
  else if(start_aga) 
    flush_en_delay2_0<=0;
  else if(flush_over)
    flush_en_delay2_0<=0;
  else
    flush_en_delay2_0<=flush_en_delay1_0;
	

always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_3<=0;
  else if(rst_syn)
	flush_en_delay2_3<=0;
  else if(start_aga) 
    flush_en_delay2_3<=0;
  else if(flush_over)
    flush_en_delay2_3<=0;
  else
    flush_en_delay2_3<=flush_en_delay1_3;
	
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_6<=0;
  else if(rst_syn)
	flush_en_delay2_6<=0;
  else if(start_aga) 
    flush_en_delay2_6<=0;
  else if(flush_over)
    flush_en_delay2_6<=0;
  else
    flush_en_delay2_6<=flush_en_delay1_6;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_1<=0;
  else if(rst_syn)
	flush_en_delay2_1<=0;
  else if(start_aga) 
    flush_en_delay2_1<=0;
  else if(flush_over)
    flush_en_delay2_1<=0;
  else
    flush_en_delay2_1<=flush_en_delay1_1;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_4<=0;
  else if(rst_syn)
	flush_en_delay2_4<=0;
  else if(start_aga) 
    flush_en_delay2_4<=0;
  else if(flush_over)
    flush_en_delay2_4<=0;
  else
    flush_en_delay2_4<=flush_en_delay1_4;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_7<=0;
  else if(rst_syn)
	flush_en_delay2_7<=0;
  else if(start_aga)
    flush_en_delay2_7<=0;
  else if(flush_over)
    flush_en_delay2_7<=0;
  else
    flush_en_delay2_7<=flush_en_delay1_7;

always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_2<=0;
  else if(rst_syn)
	flush_en_delay2_2<=0;
  else if(start_aga) 
    flush_en_delay2_2<=0;
  else if(flush_over)
    flush_en_delay2_2<=0;
  else
    flush_en_delay2_2<=flush_en_delay1_2;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_5<=0;
  else if(rst_syn)
	flush_en_delay2_5<=0;
  else if(start_aga) 
    flush_en_delay2_5<=0;
  else if(flush_over)
    flush_en_delay2_5<=0;
  else
    flush_en_delay2_5<=flush_en_delay1_5;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_8<=0;
  else if(rst_syn)
	flush_en_delay2_8<=0;
  else if(start_aga)
    flush_en_delay2_8<=0;
  else if(flush_over)
    flush_en_delay2_8<=0;
  else
    flush_en_delay2_8<=flush_en_delay1_8;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_9<=0;
  else if(rst_syn)
	flush_en_delay2_9<=0;
  else if(start_aga) 
    flush_en_delay2_9<=0;
  else if(flush_over)
    flush_en_delay2_9<=0;
  else
    flush_en_delay2_9<=flush_en_delay1_9;

always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_10<=0;
  else if(rst_syn)
	flush_en_delay2_10<=0;
  else if(start_aga)
    flush_en_delay2_10<=0;
  else if(flush_over)
    flush_en_delay2_10<=0;
  else
    flush_en_delay2_10<=flush_en_delay1_10;

always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_11<=0;
  else if(rst_syn)
	flush_en_delay2_11<=0;	
  else if(start_aga)
    flush_en_delay2_11<=0;
  else if(flush_over)
    flush_en_delay2_11<=0;
  else
    flush_en_delay2_11<=flush_en_delay1_11;	
	



always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_sp<=0;
  else if(rst_syn)
	flush_en_delay2_sp<=0;
  else if(start_aga) 
    flush_en_delay2_sp<=0;
  else if(flush_over)
    flush_en_delay2_sp<=0;
  else
    flush_en_delay2_sp<=flush_en_delay1_sp;
	

always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_mrp<=0;
  else if(rst_syn)
	flush_en_delay2_mrp<=0;
  else if(start_aga) 
    flush_en_delay2_mrp<=0;
  else if(flush_over)
    flush_en_delay2_mrp<=0;
  else
    flush_en_delay2_mrp<=flush_en_delay1_mrp;
	

always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay2_cp<=0;
  else if(rst_syn)
	flush_en_delay2_cp<=0;
  else if(start_aga) 
    flush_en_delay2_cp<=0;
  else if(flush_over)
    flush_en_delay2_cp<=0;
  else
    flush_en_delay2_cp<=flush_en_delay1_cp;

	
	
//****************pipline3*******************//



//-------------C16---------------//
//------the update of C16---//


reg [15:0]C16,C16_temp,C16_temp_reg;
reg carry_C16,carry_C16_reg;//calculate the C16

always @(*)
  begin
	C16_temp=C16;
	carry_C16=0;
	if(start_MQ_delay2)
		begin
		  if(space_judge_delay)
			begin
			  C16_temp=C16;
			end
		  else if(!space_judge_delay)
			begin
			  {carry_C16,C16_temp}=C16+Qe1_delay;
			end
		end
	else
	  begin
		C16_temp=16'b0;
		carry_C16=1'b0;
	  end
	end
  

reg[15:0] C16_temp_shift;

always @(*)
  case(count_A0_delay1)
    0:    C16_temp_shift=C16_temp;
	1:    C16_temp_shift={C16_temp[14:0],1'b0};
	2:    C16_temp_shift={C16_temp[13:0],2'b0};
	3:    C16_temp_shift={C16_temp[12:0],3'b0};
	4:    C16_temp_shift={C16_temp[11:0],4'b0};
	5:    C16_temp_shift={C16_temp[10:0],5'b0};
	6:    C16_temp_shift={C16_temp[9:0],6'b0};
	7:    C16_temp_shift={C16_temp[8:0],7'b0};
	8:    C16_temp_shift={C16_temp[7:0],8'b0};
	9:    C16_temp_shift={C16_temp[6:0],9'b0};
    10:   C16_temp_shift={C16_temp[5:0],10'b0};
	11:   C16_temp_shift={C16_temp[4:0],11'b0};
	12:   C16_temp_shift={C16_temp[3:0],12'b0};
	13:   C16_temp_shift={C16_temp[2:0],13'b0};
	15:   C16_temp_shift={C16_temp[0],15'b0};
default:  C16_temp_shift=16'b0;
  endcase  

  
reg[15:0]C16_sp,C16_mrp,C16_cp;
  
always @(posedge clk or negedge rst)
  begin
    if(!rst)
	  begin
		C16_sp<=16'h0000;
		C16_mrp<=16'h0000;
		C16_cp<=16'h0000;
	  end
	else if(rst_syn)
	begin
		C16_sp<=16'h0000;
		C16_mrp<=16'h0000;
	    C16_cp<=16'h0000;
	end
	else if(start_aga) begin
	    C16_sp<=16'h0000;
		C16_mrp<=16'h0000;
		C16_cp<=16'h0000;
	end
	else if(flush_over)
	  begin
		C16_sp<=16'h0000;
		C16_mrp<=16'h0000;
		C16_cp<=16'h0000;
	  end
	else if(start_MQ_delay2&&(!stop_delay))
	  begin
	    case(pass2)
	       2'b01:   C16_sp<=C16_temp_shift;
	       2'b10:   C16_mrp<=C16_temp_shift;
	       2'b11:   C16_cp<=C16_temp_shift;
	    endcase
	  end
  end

  
always @(*)
  begin
   case(pass2)
     2'b01:     C16=C16_sp;
     2'b10:     C16=C16_mrp;
     2'b11:     C16=C16_cp;
     default:   C16=16'b0;
   endcase
  end
  

  
		   
//-------delay for pipeline 4-------//

always @(posedge clk or negedge rst)
  if(!rst)
    C16_temp_reg<=0;
  else if(rst_syn)
	C16_temp_reg<=0;
  else if(start_aga) 
    C16_temp_reg<=0;
  else if(start_MQ_delay2&&(!stop_delay))
    C16_temp_reg<=C16_temp;
	

always @(posedge clk or negedge rst)
  begin
    if(!rst)
      carry_C16_reg<=0;
	else if(rst_syn)
	  carry_C16_reg<=0;
	else if(start_aga) 
      carry_C16_reg<=0;
    else if(start_MQ_delay2&&(!stop_delay))
      carry_C16_reg<=carry_C16;
  end
  
reg[3:0] count_A0_reg;

always @(posedge clk or negedge rst)
 if(!rst)
   count_A0_reg<=0;
 else if(rst_syn)
   count_A0_reg<=0;
 else if(start_aga) 
   count_A0_reg<=0;
 else if(start_MQ_delay2&&(!stop_delay))
   count_A0_reg<=count_A0_delay1;


reg start_MQ_delay3;
always @(posedge clk or negedge rst)
  if(!rst)
    start_MQ_delay3<=0;
  else if(rst_syn)
	start_MQ_delay3<=0;	
  else if(start_aga) 
    start_MQ_delay3<=0;
  else if((!flush_over)&&(!stop_delay))
    start_MQ_delay3<=start_MQ_delay2;

	
reg[1:0] pass3;
	
always @(posedge clk or negedge rst)
  if(!rst)
    pass3<=0;
  else if(rst_syn)
	pass3<=0;
  else if(start_aga) 
    pass3<=0;
  else if(start_MQ_delay2&&(!stop_delay))
    pass3<=pass2;
  else if(start_MQ_delay2==0)
    pass3<=0;
	
	
reg flush_delay3;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_delay3<=0;
  else if(rst_syn)
	flush_delay3<=0;
  else if(start_aga) 
    flush_delay3<=0;
  else if(flush_over)
    flush_delay3<=0;
  else
    flush_delay3<=flush_delay2;

reg flush_en_delay3_sp,flush_en_delay3_mrp,flush_en_delay3_cp;

reg flush_en_delay3_0,flush_en_delay3_3,flush_en_delay3_6;

reg flush_en_delay3_1,flush_en_delay3_4,flush_en_delay3_7;

reg flush_en_delay3_2,flush_en_delay3_5,flush_en_delay3_8;

reg flush_en_delay3_9,flush_en_delay3_10,flush_en_delay3_11;
	
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_0<=0;
	else if(rst_syn)
		flush_en_delay3_0<=0;
  else if(start_aga) begin
    flush_en_delay3_0<=0;
  end
  else if(flush_over)
    flush_en_delay3_0<=0;
  else
    flush_en_delay3_0<=flush_en_delay2_0;
	

always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_3<=0;
	else if(rst_syn)
		flush_en_delay3_3<=0;
  else if(start_aga) begin
    flush_en_delay3_3<=0;
  end	
  else if(flush_over)
    flush_en_delay3_3<=0;
  else
    flush_en_delay3_3<=flush_en_delay2_3;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_6<=0;
  else if(rst_syn)
	flush_en_delay3_6<=0;
  else if(start_aga)
    flush_en_delay3_6<=0;
  else if(flush_over)
    flush_en_delay3_6<=0;
  else
    flush_en_delay3_6<=flush_en_delay2_6;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_1<=0;
  else if(rst_syn)
	flush_en_delay3_1<=0;
  else if(start_aga) 
    flush_en_delay3_1<=0;
  else if(flush_over)
    flush_en_delay3_1<=0;
  else
    flush_en_delay3_1<=flush_en_delay2_1;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_4<=0;
  else if(rst_syn)
	flush_en_delay3_4<=0;
  else if(start_aga) 
    flush_en_delay3_4<=0;	
  else if(flush_over)
    flush_en_delay3_4<=0;
  else
    flush_en_delay3_4<=flush_en_delay2_4;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_7<=0;
  else if(rst_syn)
	flush_en_delay3_7<=0;
  else if(start_aga) 
    flush_en_delay3_7<=0;	
  else if(flush_over)
    flush_en_delay3_7<=0;
  else
    flush_en_delay3_7<=flush_en_delay2_7;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_2<=0;
  else if(rst_syn)
	flush_en_delay3_2<=0;
  else if(start_aga) 
    flush_en_delay3_2<=0;
  else if(flush_over)
    flush_en_delay3_2<=0;
  else
    flush_en_delay3_2<=flush_en_delay2_2;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_5<=0;
  else if(rst_syn)
	flush_en_delay3_5<=0;
  else if(start_aga) 
    flush_en_delay3_5<=0;
  else if(flush_over)
    flush_en_delay3_5<=0;
  else
    flush_en_delay3_5<=flush_en_delay2_5;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_8<=0;
  else if(rst_syn)
	flush_en_delay3_8<=0;
  else if(start_aga) 
    flush_en_delay3_8<=0;
  else if(flush_over)
    flush_en_delay3_8<=0;
  else
    flush_en_delay3_8<=flush_en_delay2_8;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_9<=0;
  else if(rst_syn)
	flush_en_delay3_9<=0;
  else if(start_aga)
    flush_en_delay3_9<=0;
  else if(flush_over)
    flush_en_delay3_9<=0;
  else
    flush_en_delay3_9<=flush_en_delay2_9;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_10<=0;
  else if(rst_syn)
	flush_en_delay3_10<=0;
  else if(start_aga) 
    flush_en_delay3_10<=0;
  else if(flush_over)
    flush_en_delay3_10<=0;
  else
    flush_en_delay3_10<=flush_en_delay2_10;
	
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_11<=0;
  else if(rst_syn)
	flush_en_delay3_11<=0;
  else if(start_aga) 
    flush_en_delay3_11<=0;
  else if(flush_over)
    flush_en_delay3_11<=0;
  else
    flush_en_delay3_11<=flush_en_delay2_11;
	
	



always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_sp<=0;
  else if(rst_syn)
	flush_en_delay3_sp<=0;
  else if(start_aga) 
    flush_en_delay3_sp<=0;
  else if(flush_over)
    flush_en_delay3_sp<=0;
  else
    flush_en_delay3_sp<=flush_en_delay2_sp;
	

always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_mrp<=0;
  else if(rst_syn)
	flush_en_delay3_mrp<=0;
  else if(start_aga) 
    flush_en_delay3_mrp<=0;
  else if(flush_over)
    flush_en_delay3_mrp<=0;
  else
    flush_en_delay3_mrp<=flush_en_delay2_mrp;
	

always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay3_cp<=0;
  else if(rst_syn)
	flush_en_delay3_cp<=0;
  else if(start_aga) 
    flush_en_delay3_cp<=0;
  else if(flush_over)
    flush_en_delay3_cp<=0;
  else
    flush_en_delay3_cp<=flush_en_delay2_cp;

	
//---------------------------------------------------------//
//----------------------pipeline4--------------------------//

//adder for C12 to add carry of C16+Qe
//wire [11:0]C12=C[27:16];

reg [27:0]C,C_temp;

reg [7:0]B;
reg [3:0]CT;


wire[11:0]C12_temp;
assign C12_temp=C[27:16]+carry_C16_reg;


//-------------------------------------------------------//
//---------logic for flush--------//

reg [16:0]Temp;

always @(*)
   case({flush_en_delay3_0,flush_en_delay3_4,flush_en_delay3_8})
     3'b100:    Temp=C[15:0]+A_sp;
     3'b010:    Temp=C[15:0]+A_mrp;
     3'b001:    Temp=C[15:0]+A_cp;
	 default:   Temp=16'b0;
   endcase

 wire C_lt_Temp=(Temp>17'hffff);
 //there may be a carry_C16 bit
 wire [27:0]C_set1={C[27:16],16'hffff};
 wire [27:0]C_temp_flush=(C_lt_Temp)?C_set1:(C_set1-16'h8000);
 
 reg[27:0] C_temp_flush_reg;
 
 always @(posedge clk or negedge rst)
   if(!rst)
     C_temp_flush_reg<=0;
	else if(rst_syn)
		C_temp_flush_reg<=0;
   else if(start_aga) begin
    C_temp_flush_reg<=0;
  end
  else
     C_temp_flush_reg<=C_temp_flush;
 

//*******************************************************//

wire [3:0]num_shift;
assign num_shift=(flush_delay3)?CT:count_A0_reg;



always @(*)
  if(start_MQ_delay3)
    C_temp={C12_temp,C16_temp_reg};
  else if(flush_en_delay3_1||flush_en_delay3_5||flush_en_delay3_9)
    C_temp=C_temp_flush_reg;
  else if(flush_en_delay3_2||flush_en_delay3_6||flush_en_delay3_10)
    C_temp=C;
  else 
    C_temp=28'b0;
    
	
//---judge whether or not to do bit filling for first Byte--//
wire B_eq_ff=(B==8'hff);
wire B_eq_fe=(B==8'hfe);
reg [3:0]CT_add_1;
reg [7:0]B1;
reg B_add1;


//always @(CT or B_eq_ff or B_eq_fe or C_temp)
always@(*)
  begin
    CT_add_1=7;B_add1=0;  
  case(CT)
    1:if(B_eq_ff) 
        begin
          B1=C_temp[26:19]; 
          //predict the first Byte to output after bit filling
          //first C reg shift,then Byte_out
        end
      else if(C_temp[26]==1)
        begin
          B_add1=1;   //B+1,and clear C_temp[27]
          if(B_eq_fe)
            B1={1'b0,C_temp[25:19]};
          else
            begin
              CT_add_1=8;
              B1=C_temp[25:18];
            end
        end
      else
        begin
          CT_add_1=8;
          B1=C_temp[25:18];
        end
    2:if(B_eq_ff) 
        begin
          B1=C_temp[25:18]; 
        end
      else if(C_temp[25]==1)
        begin
          B_add1=1;   
          if(B_eq_fe)
            B1={1'b0,C_temp[24:18]};
          else
            begin
              CT_add_1=8;
              B1=C_temp[24:17];
            end
        end
      else
        begin
          CT_add_1=8;
          B1=C_temp[24:17];
        end
    3:if(B_eq_ff) 
        begin
          B1=C_temp[24:17]; 
        end
      else if(C_temp[24]==1)
        begin
          B_add1=1;   
          if(B_eq_fe)
            B1={1'b0,C_temp[23:17]};
          else
            begin
              CT_add_1=8;
              B1=C_temp[23:16];
            end
        end
      else
        begin
          CT_add_1=8;
          B1=C_temp[23:16];
        end
    4:if(B_eq_ff) 
        begin
          B1=C_temp[23:16]; 
        end
      else if(C_temp[23]==1)
        begin
          B_add1=1;   
          if(B_eq_fe)
            B1={1'b0,C_temp[22:16]};
          else
            begin
              CT_add_1=8;
              B1=C_temp[22:15];
            end
        end
      else
        begin
          CT_add_1=8;
          B1=C_temp[22:15];
        end
    5:if(B_eq_ff) 
        begin
          B1=C_temp[22:15]; 
        end
      else if(C_temp[22]==1)
        begin
          B_add1=1;   
          if(B_eq_fe)
            B1={1'b0,C_temp[21:15]};
          else
            begin
              CT_add_1=8;
              B1=C_temp[21:14];
            end
        end
      else
        begin
          CT_add_1=8;
          B1=C_temp[21:14];
        end
    6:if(B_eq_ff) 
        begin
          B1=C_temp[21:14]; 
        end
      else if(C_temp[21]==1)
        begin
          B_add1=1;   
          if(B_eq_fe)
            B1={1'b0,C_temp[20:14]};
          else
            begin
              CT_add_1=8;
              B1=C_temp[20:13];
            end
        end
      else
        begin
          CT_add_1=8;
          B1=C_temp[20:13];
        end
    7:if(B_eq_ff) 
        begin
          B1=C_temp[20:13]; 
        end
      else if(C_temp[20]==1)
        begin
          B_add1=1;   
          if(B_eq_fe)
            B1={1'b0,C_temp[19:13]};
          else
            begin
              CT_add_1=8;
              B1=C_temp[19:12];
            end
        end
      else
        begin
          CT_add_1=8;
          B1=C_temp[19:12];
        end
    8:if(B_eq_ff) 
        begin
          B1=C_temp[19:12]; 
        end
      else if(C_temp[19]==1)
        begin
          B_add1=1;   
          if(B_eq_fe)
            B1={1'b0,C_temp[18:12]};
          else
            begin
              CT_add_1=8;
              B1=C_temp[18:11];
            end
        end
      else
        begin
          CT_add_1=8;
          B1=C_temp[18:11];
        end
    9:if(B_eq_ff) 
        begin
          B1=C_temp[18:11]; 
        end
      else if(C_temp[18]==1)
        begin
          B_add1=1;   
          if(B_eq_fe)
            B1={1'b0,C_temp[17:11]};
          else
            begin
              CT_add_1=8;
              B1=C_temp[17:10];
            end
        end
      else
        begin
          CT_add_1=8;
          B1=C_temp[17:10];
        end
    10:if(B_eq_ff) 
        begin
          B1=C_temp[17:10]; 
        end
      else if(C_temp[17]==1)
        begin
          B_add1=1;   
          if(B_eq_fe)
            B1={1'b0,C_temp[16:10]};
          else
            begin
              CT_add_1=8;
              B1=C_temp[16:9];
            end
        end
      else
        begin
          CT_add_1=8;
          B1=C_temp[16:9];
        end
    11:if(B_eq_ff) 
        begin
          B1=C_temp[16:9]; 
        end
      else if(C_temp[16]==1)
        begin
          B_add1=1;   
          if(B_eq_fe)
            B1={1'b0,C_temp[15:9]};
          else
            begin
              CT_add_1=8;
              B1=C_temp[15:8];
            end
        end
      else
        begin
          CT_add_1=8;
          B1=C_temp[15:8];
        end
    //when flush,if no uniqe has happened,CT will be 12
    12:if(B_eq_ff) 
        begin
          B1=C_temp[15:8]; 
        end
      else if(C_temp[15]==1)
        begin
          B_add1=1;   
          if(B_eq_fe)
            B1={1'b0,C_temp[14:8]};
          else
            begin
              CT_add_1=8;
              B1=C_temp[14:7];
            end
        end
      else
        begin
          CT_add_1=8;
          B1=C_temp[14:7];
        end
     default:
        begin
          CT_add_1=4'b0;
          B_add1=1'b0;
          B1=8'b0;
        end 
  endcase
  end
 
 //****************bout *************************//

wire [4:0]CT_plus_add_1_7=CT+7;
wire [4:0]CT_plus_add_1_8=CT+8;
//wire [4:0]CT_plus_add_1;

//assign CT_plus_add_1=(CT_add_1[3])? CT_plus_add_1_8:CT_plus_add_1_7;


wire SA_st_CT=(count_A0_reg<CT);

wire Bout_flag_flush;

//wire [1:0]Bout_flag_normal;

//Bout_flag:indicate 1 or 2 byte to output
//0:no Byte output
//1:output 1 Byte
//2:output 2 Bytes

//;assign Bout_flag_normal=(SA_st_CT)?0:((count_A0_reg<CT_plus_add_1)?1:2);
assign Bout_flag_flush=(flush_delay3)? 1:0;


reg[1:0] Bout_flag_normal_f;

always @(*)
  if(SA_st_CT)
   Bout_flag_normal_f=0;
  else if(count_A0_reg>=CT+8)
   Bout_flag_normal_f=2;
  else if(count_A0_reg<CT+7)
   Bout_flag_normal_f=1;
  else if(CT_add_1[3])
   Bout_flag_normal_f=1;  
  else 
   Bout_flag_normal_f=2; 
 
 
reg fsm_for_first_sp;
reg fsm_for_first_sp_n;

//reg count_mq_sp;

always @(posedge clk or negedge rst) begin
  if(!rst) begin
    fsm_for_first_sp <=1'b0;
  end
  else if(rst_syn)begin
	fsm_for_first_sp <=1'b0;
  end
  else if(start_aga) begin
    fsm_for_first_sp <=1'b0;
  end
  else begin
    fsm_for_first_sp <= fsm_for_first_sp_n;
  end
end

always @(*) begin
  fsm_for_first_sp_n = fsm_for_first_sp;
  case(fsm_for_first_sp)
    0:             begin
	                 if((Bout_flag_normal_f!=0)&&(start_MQ_delay3==1)&&(pass3==2'b01)) begin
					  fsm_for_first_sp_n =1;
					 end
					 else begin
					  fsm_for_first_sp_n =0;
					 end
				   end
    1:             begin
	                if(flush_over==1) begin
					  fsm_for_first_sp_n =0;
					end
					else begin
					  fsm_for_first_sp_n =1;
					end
				   end
  endcase
end


reg fsm_for_first_mrp;
reg fsm_for_first_mrp_n;



always @(posedge clk or negedge rst) begin
  if(!rst) begin
    fsm_for_first_mrp <=1'b0;
  end
  else if(rst_syn)begin
	fsm_for_first_mrp <=1'b0;
  end
  else if(start_aga) begin
    fsm_for_first_mrp <=1'b0;
  end
  else begin
    fsm_for_first_mrp <= fsm_for_first_mrp_n;
  end
end

always @(*) begin
  fsm_for_first_mrp_n = fsm_for_first_mrp;
  case(fsm_for_first_mrp)
    0:             begin
	                 if((Bout_flag_normal_f!=0)&&(start_MQ_delay3==1)&&(pass3==2'b10)) begin
					  fsm_for_first_mrp_n =1;
					 end
					 else begin
					  fsm_for_first_mrp_n =0;
					 end
				   end
    1:             begin
	                if(flush_over==1) begin
					  fsm_for_first_mrp_n =0;
					end
					else begin
					  fsm_for_first_mrp_n =1;
					end
				   end
  endcase
end



reg fsm_for_first_cp;
reg fsm_for_first_cp_n;



always @(posedge clk or negedge rst) begin
  if(!rst) begin
    fsm_for_first_cp <=1'b0;
  end
  else if(rst_syn)begin
	fsm_for_first_cp <=1'b0;
  end
  else if(start_aga) begin
    fsm_for_first_cp <=1'b0;
  end
  else begin
    fsm_for_first_cp <= fsm_for_first_cp_n;
  end
end

always @(*) begin
  fsm_for_first_cp_n = fsm_for_first_cp;
  case(fsm_for_first_cp)
    0:             begin
	                 if((Bout_flag_normal_f!=0)&&(start_MQ_delay3==1)&&(pass3==2'b11)) begin
					  fsm_for_first_cp_n =1;
					 end
					 else begin
					  fsm_for_first_cp_n =0;
					 end
				   end
    1:             begin
	                if(flush_over==1) begin
					  fsm_for_first_cp_n =0;
					end
					else begin
					  fsm_for_first_cp_n =1;
					end
				   end
  endcase
end



reg stop_en;

wire[1:0] Bout_flag_normal;
assign Bout_flag_normal=(((fsm_for_first_sp==0)&&(pass3==2'b01))||((fsm_for_first_mrp==0)&&(pass3==2'b10))||((fsm_for_first_cp==0)&&(pass3==2'b11)))? ((stop_en==1'b1)? 3:0):Bout_flag_normal_f;


 
 //*******************MASK***************************//
 
 reg[27:0] MASK_1,MASK_2;
 wire[3:0] SA_sub_CT=count_A0_reg-CT;
 


reg[1:0] sel_mask;
always @(*)begin
 case(CT_add_1)
  4'b0111:    sel_mask=2'b01;
  4'b1000:    sel_mask=2'b10;
  default: sel_mask=2'b00;
 endcase
 end
  
 
 
 //always @(count_A0_reg or CT or Bout_flag_flush or SA_st_CT or SA_sub_CT)
 always @(*)
   begin
     MASK_1=28'b0000000011111111111111111111;
	 MASK_2=28'b0000000001111111111111111111;
	 if(Bout_flag_flush)
	  begin
	    MASK_1=28'b0000000011111111111111111111;
	    MASK_2=28'b0000000001111111111111111111;
	  end
	 else if(!SA_st_CT)
	   begin
	    MASK_1=MASK_1<<(SA_sub_CT);
		MASK_2=MASK_2<<(SA_sub_CT);
	   end
	 else 
	  begin
	    MASK_1=28'b1;
		MASK_2=28'b1;
	  end	  
   end
 
reg[27:0] MASK;

//always @(MASK_1 or MASK_2 or sel_mask)
always @(*)
 if(sel_mask==2'b01)
	MASK=MASK_1;
 else if(sel_mask==2'b10)
	MASK=MASK_2;
 else 
    MASK=28'b1;
	

	

  
//**************************C_updated_1  and  C_aux  ************************// 

 wire[27:0] C_temp_shift;
 assign C_temp_shift=C_temp<<num_shift;
 
 wire[27:0] C_temp_shift_fill0;
 assign C_temp_shift_fill0=C_temp_shift&MASK;
 
 reg[27:0] C_updated_1;
 
 always @(*)
  if(num_shift==0)
   C_updated_1=C_temp;
  else if(SA_st_CT&&(!flush_delay3)) 
   C_updated_1=C_temp_shift;
  else 
   C_updated_1=C_temp_shift_fill0;
   
 wire[27:0] C_aux;
 assign C_aux=C_temp<<CT;
 
 
 

//-------------------------CT_f---------------------//

//------------------------------//
//calculate CT_f after A reg shift left

wire[3:0] CT_f_1= CT-count_A0_reg; 
wire[3:0] CT_f_2_1= CT_plus_add_1_7-num_shift; 
wire[3:0] CT_f_2_2= CT_plus_add_1_8-num_shift; 

reg[3:0]CT_f;
 
always @(*)
    begin	   
	  if(SA_st_CT&&(!flush_delay3))  
        CT_f=CT_f_1;
      else if(CT_add_1[3])
        CT_f=CT_f_2_2;
	  else
	    CT_f=CT_f_2_1;
    end





   

//***********************stop**************************//





always @(*)
  if(count_A0_reg>=CT+8)
    stop_en=1;
  else if(count_A0_reg<CT+7)
    stop_en=0;
  else if(CT_add_1==7)
    stop_en=1;
  else stop_en=0;
  



always @(posedge clk or negedge rst)
   if(!rst)
    count_stop<=0;
  else if(rst_syn)
	count_stop<=0;	
  else if(start_aga) 
    count_stop<=0;
  else if(flush_over)
    count_stop<=0;
  else if((count_stop!=0)||((stop_en)&&(count_stop==0)))
    count_stop<=count_stop+1;

	
wire stop_for_pipline4;
assign stop_for_pipline4=((count_stop==0)&&(stop_en))||(count_stop==1);

wire stop;
assign stop=(((count_stop==0)&&(stop_en))||(count_stop==1)||(count_stop==2));




//**************logic for stop delay**********************//

always @(posedge clk or negedge rst)
  if(!rst)
   stop_delay<=0;
  else if(rst_syn)
   stop_delay<=0;
  else if(start_aga) 
   stop_delay<=0;
  else if(flush_over)
   stop_delay<=0;
  else 
   stop_delay<=stop;

reg stop_delay_delay;   

always @(posedge clk or negedge rst) begin
  if(!rst) begin
   stop_delay_delay <=0;
  end
  else if(rst_syn)begin
	stop_delay_delay <=0;
  end
  else if(start_aga) begin
   stop_delay_delay <=0;
  end
  else if(flush_over) begin
   stop_delay_delay <=0;
  end
  else begin
   stop_delay_delay <=stop_delay;
  end
end

assign shift_judge_stop_end = ((stop_delay_delay==1'b1)&&(stop_delay==1'b0));

 
reg stop_for_pipline4_delay;

always @(posedge clk or negedge rst)
  if(!rst)
   stop_for_pipline4_delay<=0;
   else if(rst_syn)begin
	stop_for_pipline4_delay<=0;
   end
  else if(start_aga) begin
   stop_for_pipline4_delay<=0;
  end
  else if(flush_over)
   stop_for_pipline4_delay<=0;
  else 
   stop_for_pipline4_delay<=stop_for_pipline4;
//********** set delay reg to deal with  stop **********//

reg[1:0] sel_mask_delay;
reg[27:0] C_aux_delay;
reg[3:0] SA_sub_CT_delay;
reg[3:0] CT_add_1_delay;
reg[7:0] B1_delay;
reg[1:0] pass3_delay;

always @(posedge clk or negedge rst)
  if(!rst)
    sel_mask_delay<=0;
  else if(rst_syn)begin
  	sel_mask_delay<=0;
  end
  else if(start_aga) begin
    sel_mask_delay<=0;
  end
  else if(flush)
    sel_mask_delay<=0;
  else if(count_stop==0)
    sel_mask_delay<=sel_mask;

always @(posedge clk or negedge rst)
  if(!rst)
    C_aux_delay<=0;
  else if(rst_syn)
	C_aux_delay<=0;
  else if(start_aga) 
    C_aux_delay<=0;
  else if(flush)
    C_aux_delay<=0;
  else if(count_stop==0)
    C_aux_delay<=C_aux;
	
always @(posedge clk or negedge rst)
  if(!rst)
    SA_sub_CT_delay<=0;
  else if(rst_syn)
	SA_sub_CT_delay<=0;
  else if(start_aga) 
    SA_sub_CT_delay<=0;
  else if(flush)
    SA_sub_CT_delay<=0;
  else if(count_stop==0)
    SA_sub_CT_delay<=SA_sub_CT;
	
always @(posedge clk or negedge rst)
  if(!rst)
    CT_add_1_delay<=0;
  else if(rst_syn)
	CT_add_1_delay<=0;
  else if(start_aga) 
    CT_add_1_delay<=0;
  else if(flush)
    CT_add_1_delay<=0;
  else if(count_stop==0)
    CT_add_1_delay<=CT_add_1;
	
always @(posedge clk or negedge rst)
  if(!rst)
    B1_delay<=0;
  else if(rst_syn)
	B1_delay<=0;
  else if(start_aga) 
    B1_delay<=0;
  else if(flush)
    B1_delay<=0;
  else if(count_stop==0)
    B1_delay<=B1;
		
always @(posedge clk or negedge rst)
  if(!rst)
    pass3_delay<=0;
  else if(rst_syn)
	pass3_delay<=0;
  else if(start_aga)
    pass3_delay<=0;
  else if(flush)
    pass3_delay<=0;
  else if(count_stop==0)
    pass3_delay<=pass3;
	


//********************************************************//
//------------logic for second Byteout********************//


//-------------------------S_1---------------------------//

reg [3:0] SA_sub_CT_S_1;
reg [3:0] CT_add_1_S_1;
reg [1:0] sel_mask_S;
reg [27:0] C_aux_S_1;
reg [7:0] B1_S_1;

reg[27:0] MASK_S;
	
always @(posedge clk or negedge rst)
  if(!rst)
    sel_mask_S<=0;
	else if(rst_syn)
	  sel_mask_S<=0;
  else if(start_aga) 
    sel_mask_S<=0;
  else if((stop_delay)&&(count_stop==1))
    sel_mask_S<=sel_mask_delay;

always @(posedge clk or negedge rst)
  if(!rst)
    C_aux_S_1<=0;
  else if(rst_syn)
	C_aux_S_1<=0;
  else if(start_aga) 
    C_aux_S_1<=0;
  else if((stop_delay)&&(count_stop==1))
    C_aux_S_1<=C_aux_delay;


always @(posedge clk or negedge rst)
  if(!rst)
    SA_sub_CT_S_1<=0;
  else if(rst_syn)
	SA_sub_CT_S_1<=0;
  else if(start_aga) 
    SA_sub_CT_S_1<=0;
  else if((stop_delay)&&(count_stop==1))
    SA_sub_CT_S_1<=SA_sub_CT_delay;
	
always @(posedge clk or negedge rst)
  if(!rst)
    CT_add_1_S_1<=0;
  else if(rst_syn)
	CT_add_1_S_1<=0;
  else if(start_aga) 
    CT_add_1_S_1<=0;
  else if((stop_delay)&&(count_stop==1))
    CT_add_1_S_1<=CT_add_1_delay;
	
always @(posedge clk or negedge rst)
  if(!rst)
    B1_S_1<=0;
  else if(rst_syn)
	B1_S_1<=0;
  else if(start_aga) 
    B1_S_1<=0;
  else if((stop_delay)&&(count_stop==1))
    B1_S_1<=B1_delay;
	
//always @(sel_mask_S)
always @(*)
 if(sel_mask_S==2'b01)
	MASK_S=28'b0000000011111111111111111111;
 else if(sel_mask_S==2'b10)
	MASK_S=28'b0000000001111111111111111111;
 else 
    MASK_S=28'b1;

wire[27:0] C_temp_S_1;
assign C_temp_S_1=C_aux_S_1 & MASK_S;

wire[27:0] C_temp_shift_S_1;
assign C_temp_shift_S_1=C_temp_S_1 << CT_add_1_S_1 ;

wire[4:0] Sub_2_S;
assign Sub_2_S=SA_sub_CT_S_1 - CT_add_1_S_1 ;

//------------------------------S_2--------------------------//

reg [4:0] Sub_2_S_2;
reg [3:0] CT_add_1_S_2;
reg [3:0] SA_sub_CT_S_2;
reg [27:0] C_temp_shift_S_2;
reg [27:0] C_temp_S_2;
reg [7:0] B1_S_2;


always @(posedge clk or negedge rst)
  if(!rst)
    Sub_2_S_2<=0;
  else if(rst_syn)
	Sub_2_S_2<=0;	
  else if(start_aga) 
    Sub_2_S_2<=0;
  else if((stop_delay)&&(count_stop==2))
    Sub_2_S_2<=Sub_2_S;
	
always @(posedge clk or negedge rst)
  if(!rst)
    CT_add_1_S_2<=0;
  else if(rst_syn)
	CT_add_1_S_2<=0;
  else if(start_aga) 
    CT_add_1_S_2<=0;
  else if((stop_delay)&&(count_stop==2))
    CT_add_1_S_2<=CT_add_1_S_1;
	
always @(posedge clk or negedge rst)
  if(!rst)
    SA_sub_CT_S_2<=0;
  else if(rst_syn)
	SA_sub_CT_S_2<=0;
  else if(start_aga) 
    SA_sub_CT_S_2<=0;
  else if((stop_delay)&&(count_stop==2))
    SA_sub_CT_S_2<=SA_sub_CT_S_1;
	
always @(posedge clk or negedge rst)
  if(!rst)
    C_temp_shift_S_2<=0;
  else if(rst_syn)
	C_temp_shift_S_2<=0;
  else if(start_aga) 
    C_temp_shift_S_2<=0;
  else if((stop_delay)&&(count_stop==2))
    C_temp_shift_S_2<=C_temp_shift_S_1;
	
always @(posedge clk or negedge rst)
  if(!rst)
    C_temp_S_2<=0;
  else if(rst_syn)
	C_temp_S_2<=0;
  else if(start_aga) 
    C_temp_S_2<=0;
  else if((stop_delay)&&(count_stop==2))
    C_temp_S_2<=C_temp_S_1;
	
always @(posedge clk or negedge rst)
  if(!rst)
    B1_S_2<=0;
  else if(rst_syn)
    B1_S_2<=0;
  else if(start_aga)
    B1_S_2<=0;
  else if((stop_delay)&&(count_stop==2))
    B1_S_2<=B1_S_1;
	
//-----------------C_updated_2   and  C---------------------//
	
reg[27:0] MASK_C2;

reg [3:0]CT_add_2;
wire sel_mask_2=(CT_add_2== 7);


//always @(sel_mask_2)
always @(*)
 if(sel_mask_2)
	MASK_C2=28'b0000000011111111111111111111;
 else 
	MASK_C2=28'b0000000001111111111111111111;

	
wire[27:0] C_updated_2;
assign C_updated_2=((C_temp_shift_S_2 & MASK_C2) << Sub_2_S_2);

wire[27:0] C_mux;

assign C_mux=(count_stop==3)? C_updated_2:C_updated_1;
 
reg[27:0] C_sp,C_mrp,C_cp;
 
 always @(posedge clk or negedge rst)
  if(!rst)
    begin
	  C_sp<=28'b0;
	  C_mrp<=28'b0;
	  C_cp<=28'b0;
	end
	else if(rst_syn)
		begin
			C_sp<=28'b0;
			C_mrp<=28'b0;
			C_cp<=28'b0;
		end
  else if(start_aga) begin
      C_sp<=28'b0;
	  C_mrp<=28'b0;
	  C_cp<=28'b0;
  end
  else if(flush_over)
    begin
	  C_sp<=28'b0;
	  C_mrp<=28'b0;
	  C_cp<=28'b0;
	end
  else if((start_MQ_delay3&&(!stop_for_pipline4_delay))||flush_delay3)
    begin 
	  if(count_stop==3)
	   begin
	     if(pass3_delay==2'b01)
		  C_sp<=C_mux;
		 else if(pass3_delay==2'b10)
		  C_mrp<=C_mux;
		 else if(pass3_delay==2'b11)
		  C_cp<=C_mux;
	   end
	  else
       begin
	     if((pass3==2'b01)||(flush_en_delay3_1))
		  C_sp<=C_mux;
		 else if((pass3==2'b10)||(flush_en_delay3_5))
		  C_mrp<=C_mux;
		 else if((pass3==2'b11)||(flush_en_delay3_9))
		  C_cp<=C_mux;
	   end
	end
	   
	
 always @(*)
 if((pass3==2'b01)||(flush_en_delay3_sp))
   C=C_sp;
  else if((pass3==2'b10)||(flush_en_delay3_mrp))
   C=C_mrp;
  else if((pass3==2'b11)||(flush_en_delay3_cp))
   C=C_cp;
  else 
   C=28'b0;
 


//----------------------------B2 and CT_add_2---------------------------//

wire B1_eq_ff=(B1_S_2==8'hff);
wire B1_eq_fe=(B1_S_2==8'hfe);
reg [7:0]B2;
//reg B2_add1;


//always @(CT_add_1_S_2 or B1_eq_ff or B1_eq_fe or C_temp_S_2)
always@(*)
  begin
    CT_add_2=7;//B1_add1=0;  
  case(CT_add_1_S_2)
  
	7:if(B1_eq_ff) 
        begin
          B2=C_temp_S_2[20:13]; 
        end
      else if(C_temp_S_2[20]==1)
        begin
          //B1_add1=1;   
          if(B1_eq_fe)
            B2={1'b0,C_temp_S_2[19:13]};
          else
            begin
              CT_add_2=8;
              B2=C_temp_S_2[19:12];
            end
        end
      else
        begin
          CT_add_2=8;
          B2=C_temp_S_2[19:12];
        end
    8:if(B1_eq_ff) 
        begin
          B2=C_temp_S_2[19:12]; 
        end
      else if(C_temp_S_2[19]==1)
        begin
          //B1_add1=1;   
          if(B1_eq_fe)
            B2={1'b0,C_temp_S_2[18:12]};
          else
            begin
              CT_add_2=8;
              B2=C_temp_S_2[18:11];
            end
        end
      else
        begin
          CT_add_2=8;
          B2=C_temp_S_2[18:11];
        end
		
	default:
        begin
          CT_add_2=4'b0;
          //B1_add1=1'b0;
          B2=8'b0;
        end 
    
  endcase
  end

//---------------------CT_s  and  CT---------------------------//

wire [3:0] CT_s;
wire [4:0] CT_add_all=CT_add_1_S_2 + CT_add_2; 
assign CT_s=CT_add_all-SA_sub_CT_S_2;


wire[3:0] CT_mux;
wire sel_CT=(count_stop==3);
assign CT_mux=(sel_CT)? CT_s:CT_f;

reg[3:0] CT_sp,CT_mrp,CT_cp;

always @(posedge clk or negedge rst)
  begin
    if(!rst)
	  begin
	    CT_sp<=4'b1100;
		CT_mrp<=4'b1100;
		CT_cp<=4'b1100;
	  end
	else if(rst_syn)
		begin
			CT_sp<=4'b1100;
		    CT_mrp<=4'b1100;
			CT_cp<=4'b1100;
		end
    else if(start_aga) begin
      CT_sp<=4'b1100;
	  CT_mrp<=4'b1100;
	  CT_cp<=4'b1100;
    end
	else if(flush_over)
	  begin
	    CT_sp<=4'b1100;
		CT_mrp<=4'b1100;
		CT_cp<=4'b1100;
	  end
	else if((start_MQ_delay3&&(!stop_for_pipline4_delay))||flush_delay3)
	  begin
	    if(count_stop==3)
		  begin
	        if(pass3_delay==2'b01)
		      CT_sp<=CT_mux;
		    else if(pass3_delay==2'b10)
		      CT_mrp<=CT_mux;
		    else if(pass3_delay==2'b11)
		      CT_cp<=CT_mux;
	      end
		else
		  begin
            if((pass3==2'b01)||(flush_en_delay3_1))
		      CT_sp<=CT_mux;
		    else if((pass3==2'b10)||(flush_en_delay3_5))
		      CT_mrp<=CT_mux;
		    else if((pass3==2'b11)||(flush_en_delay3_9))
		      CT_cp<=CT_mux; 
          end
	  end
	end
  

 always @(*)
  if((pass3==2'b01)||(flush_en_delay3_1)||(flush_en_delay3_2))
   CT=CT_sp;
  else if((pass3==2'b10)||(flush_en_delay3_5)||(flush_en_delay3_6))
   CT=CT_mrp;
  else if((pass3==2'b11)||(flush_en_delay3_9)||(flush_en_delay3_10))
   CT=CT_cp;
  else
   CT=4'b0;

//---------------------B and pipline 5-----------------------------//
//----------------------pipline5----------------------------//
wire sel_B=(count_stop==3);
 
wire[7:0] B_mux;
assign B_mux=(sel_B)? B2:B1;
 
reg[7:0] B_sp,B_mrp,B_cp;
 
 always @(posedge clk or negedge rst)
  if(!rst)
    begin
	  B_sp<=8'b0;
	  B_mrp<=8'b0;
	  B_cp<=8'b0;
	end
	else if(rst_syn)
		begin
			B_sp<=8'b0;
		    B_mrp<=8'b0;
		    B_cp<=8'b0;
		end
    else if(start_aga) begin
      B_sp<=8'b0;
	  B_mrp<=8'b0;
	  B_cp<=8'b0;
    end
  else if(flush_over)
    begin
	  B_sp<=8'b0;
	  B_mrp<=8'b0;
	  B_cp<=8'b0;
	end
  else if((start_MQ_delay3&&(!stop_for_pipline4_delay))||flush_delay3)
    begin
	  if(count_stop==3)
	    begin
	      if(pass3_delay==2'b01)
		    B_sp<=B_mux;
		  else if(pass3_delay==2'b10)
		    B_mrp<=B_mux;
		  else if(pass3_delay==2'b11)
		    B_cp<=B_mux;
	    end
	  else
	    begin
		  if(((pass3==2'b01)&&(Bout_flag_normal_f[0]==1))||(flush_en_delay3_1)||(flush_en_delay3_2))
		    B_sp<=B_mux;
		  else if(((pass3==2'b10)&&(Bout_flag_normal_f[0]==1))||(flush_en_delay3_5)||(flush_en_delay3_6))
		    B_mrp<=B_mux;
		  else if(((pass3==2'b11)&&(Bout_flag_normal_f[0]==1))||(flush_en_delay3_9)||(flush_en_delay3_10))
		    B_cp<=B_mux;
	    end
	end
	
 always @(*)
  if((pass3==2'b01)||(flush_en_delay3_1)||(flush_en_delay3_2)||(flush_en_delay3_3))
   B=B_sp;
  else if((pass3==2'b10)||(flush_en_delay3_5)||(flush_en_delay3_6)||(flush_en_delay3_7))
   B=B_mrp;
  else if((pass3==2'b11)||(flush_en_delay3_9)||(flush_en_delay3_10)||(flush_en_delay3_11))
   B=B_cp;
  else
   B=8'b0;

//-----------------work_en and work_en_reg  for pipline 5------------------------//

wire work_en=(start_MQ_delay3&&(count_stop==0));
reg work_en_reg;

always @(posedge clk or negedge rst)
 if(!rst)
   work_en_reg<=0;
 else if(rst_syn)
	work_en_reg<=0;
 else work_en_reg<=work_en;

//---------------------------------------------------------------------------// 
 
reg [1:0]Bout_flag_reg;

always @(posedge clk or negedge rst)
   if(!rst)
     Bout_flag_reg<=2'b00;
   else if(rst_syn)
	 Bout_flag_reg<=2'b00;
   else if(start_aga) 
     Bout_flag_reg<=2'b00;
   else 
     case({work_en,flush_delay3})
        2'b10:  Bout_flag_reg<=Bout_flag_normal;
        2'b01:	begin
		         if(((flush_en_delay3_1)&&(fsm_for_first_sp==0))||((flush_en_delay3_5)&&(fsm_for_first_mrp==0))||((flush_en_delay3_9)&&(fsm_for_first_cp==0))) begin
		          Bout_flag_reg<=0;
				 end
				 else begin
				  Bout_flag_reg<=Bout_flag_flush;	
				 end
				end	
       default: Bout_flag_reg<=2'b00;
	 endcase
   		
reg[7:0] B_reg;

always @(posedge clk or negedge rst)
   if(!rst)
     B_reg<=8'b0;
   else if(rst_syn)
	 B_reg<=8'b0;
   else if(start_aga) 
     B_reg<=8'b0;
   else if(flush_over)
     B_reg<=8'b0;
   else if(work_en||flush_delay3)
     B_reg<=B;
	 
	 
reg[7:0] B1_reg;

always @(posedge clk or negedge rst)
   if(!rst)
     B1_reg<=8'b0;
   else if(rst_syn)
	 B1_reg<=8'b0;
   else if(start_aga) 
     B1_reg<=8'b0;
   else if(flush_over)
     B1_reg<=8'b0;
   else if(work_en)
     B1_reg<=B1;
	 

reg B_add1_reg;

always @(posedge clk or negedge rst)
  if(!rst)
    begin
      B_add1_reg<=0; 
    end
	else if(rst_syn)begin
		B_add1_reg<=0; 
	end
  else if(start_aga) begin
     B_add1_reg<=0;
   end
  else if(flush_over)
    begin
      B_add1_reg<=0; 
    end
  else if(work_en||flush_en_delay3_1||flush_en_delay3_2||flush_en_delay3_5||flush_en_delay3_6||flush_en_delay3_9||flush_en_delay3_10)
    begin
      B_add1_reg<=B_add1; 
    end
 else //if(flush_en_delay3_2||flush_en_delay3_5||flush_en_delay3_8)  //the 3rd,6rd ,9rd flush cycle
    begin
      B_add1_reg<=0;
	end
	


//-----------Delay for pipeline 5-------//

reg flush_delay4;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_delay4<=0;
  else if(rst_syn)begin
	flush_delay4<=0;
  end
  else if(start_aga) begin
    flush_delay4<=0;
  end
  else if(!flush_over)
    flush_delay4<=flush_delay3;

reg flush_en_delay4_0;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay4_0<=0;
	else if(rst_syn)begin
	  flush_en_delay4_0<=0;	
	end
   else if(start_aga) begin
    flush_en_delay4_0<=0;
  end
  else if(!flush_over)
    flush_en_delay4_0<=flush_en_delay3_0;	
	
	
reg flush_en_delay4_1;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay4_1<=0;
	else if(rst_syn)begin
	  flush_en_delay4_1<=0;
	end
  else if(start_aga) begin
    flush_en_delay4_1<=0;
  end
  else if(!flush_over)
    flush_en_delay4_1<=flush_en_delay3_1;


reg flush_en_delay4_2;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay4_2<=0;
	else if(rst_syn)begin
		flush_en_delay4_2<=0;
	end
  else if(start_aga) begin
    flush_en_delay4_2<=0;
  end
  else if(!flush_over)
    flush_en_delay4_2<=flush_en_delay3_2;
	
reg flush_en_delay4_3;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay4_3<=0;
  else if(rst_syn)
	  flush_en_delay4_3<=0;
  else if(start_aga) begin
    flush_en_delay4_3<=0;
  end
  else if(!flush_over)
    flush_en_delay4_3<=flush_en_delay3_3;
	
	
reg flush_en_delay4_4;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay4_4<=0;
  else if(rst_syn)
	  flush_en_delay4_4<=0;
  else if(start_aga) 
    flush_en_delay4_4<=0;
  else if(!flush_over)
    flush_en_delay4_4<=flush_en_delay3_4;

	
reg flush_en_delay4_5;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay4_5<=0;
  else if(rst_syn)
    flush_en_delay4_5<=0;
  else if(start_aga) 
    flush_en_delay4_5<=0;
  else if(!flush_over)
    flush_en_delay4_5<=flush_en_delay3_5;


reg flush_en_delay4_6;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay4_6<=0;
	else if(rst_syn)
	  flush_en_delay4_6<=0;
  else if(start_aga) 
    flush_en_delay4_6<=0;
  else if(!flush_over)
    flush_en_delay4_6<=flush_en_delay3_6;	

	
reg flush_en_delay4_7;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay4_7<=0;
   else if(rst_syn)
		flush_en_delay4_7<=0;
  else if(start_aga) 
    flush_en_delay4_7<=0;
  else if(!flush_over)
    flush_en_delay4_7<=flush_en_delay3_7;
	

	
reg flush_en_delay4_9;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay4_9<=0;
	else if(rst_syn)
	  flush_en_delay4_9<=0;
  else if(start_aga)
    flush_en_delay4_9<=0;
  else if(!flush_over)
    flush_en_delay4_9<=flush_en_delay3_9;
	
reg flush_en_delay4_10;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay4_10<=0;
	else if(rst_syn)
	  flush_en_delay4_10<=0;
  else if(start_aga)
    flush_en_delay4_10<=0;
  else if(!flush_over)
    flush_en_delay4_10<=flush_en_delay3_10;
	
reg flush_en_delay4_11;
always @(posedge clk or negedge rst)
  if(!rst)
    flush_en_delay4_11<=0;
  else if(rst_syn)
	flush_en_delay4_11<=0;
  else if(start_aga) 
    flush_en_delay4_11<=0;
  else if(!flush_over)
    flush_en_delay4_11<=flush_en_delay3_11;
	
	
reg[1:0] pass4;
always @(posedge clk or negedge rst)
  if(!rst)
    pass4<=0;
  else if(rst_syn)
	pass4<=0;
  else if(start_aga) 
    pass4<=0;
  else if(work_en)
    pass4<=pass3;
  else if(start_MQ_delay3==0)
    pass4<=0;
	
	
//the 2nd ,5rd,8rd cycle of flush to judge whether B=8'hff





//----------------cache and cache flag---------------------//

reg [7:0]cache_sp,cache_mrp,cache_cp;
reg cache_flag_sp,cache_flag_mrp,cache_flag_cp;

//--------------------en singal---------------------//

wire en_sp,en_mrp,en_cp;
assign en_sp=((pass4==2'b01)||((flush_en_delay4_1)&&(fsm_for_first_sp==1))||flush_en_delay4_2);
assign en_mrp=((pass4==2'b10)||((flush_en_delay4_5)&&(fsm_for_first_mrp==1))||flush_en_delay4_6);
assign en_cp=((pass4==2'b11)||((flush_en_delay4_9)&&(fsm_for_first_cp==1))||flush_en_delay4_10);

wire [7:0]B_to_fifo=B_add1_reg?(B_reg+1):B_reg; 

always @(posedge clk or negedge rst)
  if(!rst)
     begin
      cache_sp<=8'b0;
	  cache_mrp<=8'b0;
	  cache_cp<=8'b0;
      cache_flag_sp<=0;
	  cache_flag_mrp<=0;
	  cache_flag_cp<=0;
     end 
	else if(rst_syn)
		begin
			cache_sp<=8'b0;
		    cache_mrp<=8'b0;
		    cache_cp<=8'b0;
		    cache_flag_sp<=0;
		    cache_flag_mrp<=0;
		    cache_flag_cp<=0;
		end
   else if(start_aga) begin
      cache_sp<=8'b0;
	  cache_mrp<=8'b0;
	  cache_cp<=8'b0;
      cache_flag_sp<=0;
	  cache_flag_mrp<=0;
	  cache_flag_cp<=0;
   end
   else if(flush_over)
     begin
      cache_sp<=8'b0;
	  cache_mrp<=8'b0;
	  cache_cp<=8'b0;
      cache_flag_sp<=0;
	  cache_flag_mrp<=0;
	  cache_flag_cp<=0;   //all output
     end 
   else if(work_en_reg||flush_delay4)
     begin
      if(en_sp) 
	   begin
	     if(Bout_flag_reg==3) begin
		   cache_sp<=B1_reg;
		   cache_flag_sp<=1;
		 end
		 else if(cache_flag_sp==0)
          begin
	       if(Bout_flag_reg==1)
	        begin
	         cache_sp<=B_to_fifo;
	         cache_flag_sp<=1;
            end
	       else if(Bout_flag_reg==2)
		     cache_flag_sp<=0;
          end
         else if(cache_flag_sp==1)
          begin
           if(Bout_flag_reg==1)
              cache_flag_sp<=0;
	       else if(Bout_flag_reg==2)
	          begin
		       cache_sp<=B1_reg;
		       cache_flag_sp<=1;
       	      end   
          end
	   end  
	  else if(en_mrp)
	   begin
	    if(Bout_flag_reg==3) begin
		   cache_mrp<=B1_reg;
		   cache_flag_mrp<=1;
		 end
		else if(cache_flag_mrp==0)
          begin
	       if(Bout_flag_reg==1)
	        begin
	         cache_mrp<=B_to_fifo;
	         cache_flag_mrp<=1;
            end
	       else if(Bout_flag_reg==2)
		     cache_flag_mrp<=0;
          end
         else if(cache_flag_mrp==1)
          begin
           if(Bout_flag_reg==1)
              cache_flag_mrp<=0;
	       else if(Bout_flag_reg==2)
	          begin
		       cache_mrp<=B1_reg;
		       cache_flag_mrp<=1;
       	      end   
          end
	   end  
	  else if(en_cp)
	   begin
	    if(Bout_flag_reg==3) begin
		   cache_cp<=B1_reg;
		   cache_flag_cp<=1;
		 end
		else if(cache_flag_cp==0)
          begin
	       if(Bout_flag_reg==1)
	        begin
	         cache_cp<=B_to_fifo;
	         cache_flag_cp<=1;
            end
	       else if(Bout_flag_reg==2)
		     cache_flag_cp<=0;
          end
         else if(cache_flag_cp==1)
          begin
           if(Bout_flag_reg==1)
              cache_flag_cp<=0;
	       else if(Bout_flag_reg==2)
	          begin
		       cache_cp<=B1_reg;
		       cache_flag_cp<=1;
       	      end   
          end
	   end  
	 
	 end	 

//**mux for data_to_fifo**//
reg [2:0]sel3;
reg [15:0]data_to_fifo;

always @(*)
  if(en_sp||flush_en_delay4_3)
    case(sel3)  
      0:data_to_fifo={B_to_fifo,cache_sp};
      1:data_to_fifo={B1_reg,B_to_fifo};
      2:data_to_fifo={8'b0,cache_sp};
      3:data_to_fifo={8'b0,B_to_fifo};
      default:data_to_fifo=16'bzzzz_zzzz_zzzz_zzzz;
    endcase
  else if(en_mrp||flush_en_delay4_7)
    case(sel3)  
      0:data_to_fifo={B_to_fifo,cache_mrp};
      1:data_to_fifo={B1_reg,B_to_fifo};
      2:data_to_fifo={8'b0,cache_mrp};
      3:data_to_fifo={8'b0,B_to_fifo};
      default:data_to_fifo=16'bzzzz_zzzz_zzzz_zzzz;
    endcase
  else if(en_cp||flush_en_delay4_11)
    case(sel3)  
      0:data_to_fifo={B_to_fifo,cache_cp};
      1:data_to_fifo={B1_reg,B_to_fifo};
      2:data_to_fifo={8'b0,cache_cp};
      3:data_to_fifo={8'b0,B_to_fifo};
      default:data_to_fifo=16'bzzzz_zzzz_zzzz_zzzz;
    endcase
  else 
     data_to_fifo=16'bz;
	 
reg [15:0] MQ_out; 

always @(posedge clk or negedge rst)
  if(!rst)
     MQ_out<=16'b0;
  else if(rst_syn)
	MQ_out<=16'bz;
  else if(start_aga) 
     MQ_out<=16'bz;
  else
     MQ_out<=data_to_fifo;

wire[7:0] MQ_out_a=MQ_out[15:8];
wire[7:0] MQ_out_b=MQ_out[7:0];
    
wire[1:0]  Bout_flag_reg_sp;
wire[1:0]  Bout_flag_reg_mrp;
wire[1:0]  Bout_flag_reg_cp;
assign Bout_flag_reg_sp=((pass4==2'b01)||((flush_en_delay4_1)&&(fsm_for_first_sp==1))||flush_en_delay4_2)? Bout_flag_reg:2'b0;
assign Bout_flag_reg_mrp=((pass4==2'b10)||((flush_en_delay4_5)&&(fsm_for_first_mrp==1))||flush_en_delay4_6)? Bout_flag_reg:2'b0;
assign Bout_flag_reg_cp=((pass4==2'b11)||((flush_en_delay4_9)&&(fsm_for_first_cp==1))||flush_en_delay4_10)? Bout_flag_reg:2'b0;

  
wire [1:0]sum_flag_sp=(Bout_flag_reg_sp==3)? 1:(cache_flag_sp+Bout_flag_reg_sp); 
wire [1:0]sum_flag_mrp=(Bout_flag_reg_mrp==3)? 1:(cache_flag_mrp+Bout_flag_reg_mrp); 
wire [1:0]sum_flag_cp=(Bout_flag_reg_cp==3)? 1:(cache_flag_cp+Bout_flag_reg_cp); 
 
//--judge the last word to fifo is one byte or two--//
reg word_last_flag;  //0-one byte  1-two bytes

always @(posedge clk or negedge rst)
  if(!rst)
    word_last_flag<=0;
  else if(rst_syn)
	word_last_flag<=0;
  else if(start_aga) 
    word_last_flag<=0;
  else if(flush_en_delay4_2||flush_en_delay4_6||flush_en_delay4_10)
         case({flush_en_delay4_2,flush_en_delay4_6,flush_en_delay4_10})
		   3'b100:  word_last_flag<=(sum_flag_sp>1)?1:0;
		   3'b010:  word_last_flag<=(sum_flag_mrp>1)?1:0;
		   3'b001:  word_last_flag<=(sum_flag_cp>1)?1:0;
           default: word_last_flag<=1'b0;
         endcase
  else if(flush_en_delay4_3||flush_en_delay4_7||flush_en_delay4_11) //update at the base of flush_en_delay3_2,6,10
         case({flush_en_delay4_3,flush_en_delay4_7,flush_en_delay4_11})
		   3'b100:  if(cache_flag_sp==1)
                          begin
                            if(B_to_fifo!=8'hff)
                              word_last_flag<=1;
                            else
                              word_last_flag<=0;
                          end
                    else if(B_to_fifo!=8'hff)
                              word_last_flag<=0;//if (cache_flag_sp==0)&&(B_to_fifo=8'hff) ,keep the word_last_flag when flush_en_delay3_2
		   
		   
		   3'b010:  if(cache_flag_mrp==1)
                          begin
                            if(B_to_fifo!=8'hff)
                              word_last_flag<=1;
                            else
                              word_last_flag<=0;
                          end
                    else if(B_to_fifo!=8'hff)
                              word_last_flag<=0;//if (cache_flag_mrp==0)&&(B_to_fifo=8'hff) ,keep the word_last_flag when flush_en_delay3_6
		   
		   
		   
		   3'b001:  if(cache_flag_cp==1)
                          begin
                            if(B_to_fifo!=8'hff)
                              word_last_flag<=1;
                            else
                              word_last_flag<=0;
                          end
                    else if(B_to_fifo!=8'hff)
                              word_last_flag<=0;//if (cache_flag_cp==0)&&(B_to_fifo=8'hff) ,keep the word_last_flag when flush_en_delay3_10
           
		   
		   default: word_last_flag<=1'b0;
         endcase

reg[1:0]word_last_valid;

always @(posedge clk or negedge rst)
  if(!rst)
    word_last_valid<=2'b00;
	else if(rst_syn)
	  word_last_valid<=2'b00;
  else if(start_aga)
    word_last_valid<=2'b00;
  else if(flush_en_delay4_2||flush_en_delay4_6||flush_en_delay4_10||flush_en_delay4_3||flush_en_delay4_7||flush_en_delay4_11)
    case({(flush_en_delay4_2||flush_en_delay4_3),(flush_en_delay4_6||flush_en_delay4_7),(flush_en_delay4_10||flush_en_delay4_11)})
     3'b100:  word_last_valid<=2'b01;
     3'b010:  word_last_valid<=2'b10;
     3'b001:  word_last_valid<=2'b11;
     default: word_last_valid<=2'b00;
    endcase
  else
    word_last_valid<=2'b00;
    
		 
		

 
always @(*)
  begin
    sel3=7;
    if(flush_en_delay4_3)
	    begin
          if((cache_flag_sp==1)&&(B_to_fifo!=8'hff))
            sel3=0;
          else if((cache_flag_sp==1)&&(B_to_fifo==8'hff))
            sel3=2;
          else if((cache_flag_sp==0)&&(B_to_fifo!=8'hff))
            sel3=3;
        end
	else if(flush_en_delay4_7)
	    begin
          if((cache_flag_mrp==1)&&(B_to_fifo!=8'hff))
            sel3=0;
          else if((cache_flag_mrp==1)&&(B_to_fifo==8'hff))
            sel3=2;
          else if((cache_flag_mrp==0)&&(B_to_fifo!=8'hff))
            sel3=3;
        end
	else if(flush_en_delay4_11)
	    begin
          if((cache_flag_cp==1)&&(B_to_fifo!=8'hff))
            sel3=0;
          else if((cache_flag_cp==1)&&(B_to_fifo==8'hff))
            sel3=2;
          else if((cache_flag_cp==0)&&(B_to_fifo!=8'hff))
            sel3=3;
        end
	
    else if(((cache_flag_sp==1)&&(Bout_flag_reg)&&en_sp)||((cache_flag_mrp==1)&&(Bout_flag_reg)&&en_mrp)||((cache_flag_cp==1)&&(Bout_flag_reg)&&en_cp))
      sel3=0;
    else if(((cache_flag_sp==0)&&(Bout_flag_reg==2)&&(pass4==2'b01))||((cache_flag_mrp==0)&&(Bout_flag_reg==2)&&(pass4==2'b10))||((cache_flag_cp==0)&&(Bout_flag_reg==2)&&(pass4==2'b11)))
      sel3=1;
  end
  
//*****************data_valid*************************************//

wire data_valid_usual=(!flush_over)&&((sum_flag_sp>1)||(sum_flag_mrp>1)||(sum_flag_cp>1))&&((work_en_reg)||flush_delay4);

assign data_valid=(flush_en_delay4_3||flush_en_delay4_7||flush_en_delay4_11)?(flush_en_delay4_3&&((cache_flag_sp==1)||(B_to_fifo!=8'hff)))||(flush_en_delay4_7&&((cache_flag_mrp==1)||(B_to_fifo!=8'hff)))||(flush_en_delay4_11&&((cache_flag_cp==1)||(B_to_fifo!=8'hff))):data_valid_usual;

reg[1:0] data_valid_pass;

always @(*) begin
  if(data_valid_usual)
     case({en_sp,en_mrp,en_cp})   
      3'b100:    begin
	              if(normal_valid) begin
				    data_valid_pass=2'b01;
                  end
                  else begin
                    data_valid_pass=2'b00;
                  end
                 end
      3'b010:    begin
	              if(normal_valid) begin
				    data_valid_pass=2'b10;
                  end
                  else begin
                    data_valid_pass=2'b00;
                  end
                 end
      3'b001:    begin
	              if((top_valid)||(normal_valid)) begin
				    data_valid_pass=2'b11;
                  end
                  else begin
                    data_valid_pass=2'b00;
                  end
                 end
     default:    data_valid_pass=2'b00;
    endcase
  else if((flush_en_delay4_3||flush_en_delay4_7||flush_en_delay4_11)&& data_valid)
    case({flush_en_delay4_3,flush_en_delay4_7,flush_en_delay4_11})
      3'b100:   begin
	              if(normal_valid) begin
				    data_valid_pass=2'b01;
                  end
                  else begin
                    data_valid_pass=2'b00;
                  end
                 end
      3'b010:   begin
	              if(normal_valid) begin
				    data_valid_pass=2'b10;
                  end
                  else begin
                    data_valid_pass=2'b00;
                  end
                 end
      3'b001:   begin
	              if((top_valid)||(normal_valid)) begin
				    data_valid_pass=2'b11;
                  end
                  else begin
                    data_valid_pass=2'b00;
                  end
                 end
      default:  data_valid_pass=2'b00;
    endcase
  else 
    data_valid_pass=2'b00;
end
    
reg[1:0] data_valid_pass_reg;

always @(posedge clk or negedge rst)
  if(!rst)
     data_valid_pass_reg<=2'b00;
  else if(rst_syn)
	data_valid_pass_reg<=2'b00;
  else
     data_valid_pass_reg<=data_valid_pass;
     
    


//---flush_over:one clk later than flush_en_delay3_8--//
//flush_over is after the last word write to sram from MQ_fifo(sp/topbp cp)
//top bp have cp coding only,
reg flush_delay5_11,flush_delay6_11;
always @(posedge clk or negedge rst)
  if(!rst)
    begin
      flush_delay5_11<=0;
      flush_delay6_11<=0;
      flush_over<=0;
    end
	else if(rst_syn)
		begin
			flush_delay5_11<=0;
			flush_delay6_11<=0;
			flush_over<=0;	
		end
  else if(start_aga) begin
      flush_delay5_11<=0;
      flush_delay6_11<=0;
      flush_over<=0;
  end
  else if(!flush_over)
    begin
      flush_delay5_11<=flush_en_delay4_11;
      flush_delay6_11<=flush_delay5_11;
      flush_over<=flush_delay6_11;
    end
  else
    begin
      flush_delay5_11<=0;
      flush_delay6_11<=0;
      flush_over<=0;
    end
//*******************************************************************//

reg [13:0]count_mq_out;
reg flush_delay5;
reg one_codeblock_over;
always @(posedge clk or negedge rst)begin
	if(!rst)begin
		one_codeblock_over<=0;
	end
	else if(rst_syn)begin
		one_codeblock_over<=0;
	end
	else if((block_all_bp_over&&flush_over)||(start_aga==1'b1))begin
		one_codeblock_over<=1;
	end
	else begin
		one_codeblock_over<=0;
	end
end	
	
	
	
always @(posedge clk or negedge rst)begin
	if(!rst)begin
		count_mq_out<=0;
	end
	else if(rst_syn)begin
		count_mq_out<=0;
	end
	else if((block_all_bp_over&&flush_over)||(start_aga==1'b1))begin
		count_mq_out<=0;
	end
	else if(flush_delay5==0)begin
		if(data_valid_pass_reg!=0)begin
			count_mq_out<=count_mq_out+2;
		end
	end
	else if(flush_delay5==1)begin
		if(word_last_valid==0)begin
			if(data_valid_pass_reg!=0)begin
				count_mq_out<=count_mq_out+2;				
			end
		end
		else if(word_last_valid!=0)begin
			if((data_valid_pass_reg!=0)&&(word_last_flag==1'b1))begin
				count_mq_out<=count_mq_out+2;				
			end
			else if((data_valid_pass_reg!=0)&&(word_last_flag==1'b0))begin
				count_mq_out<=count_mq_out+1;
			end
		end
	end
end

reg bit_enough_to_bpc;
always @(posedge clk or negedge rst)begin
	if(!rst)begin
		bit_enough_to_bpc<=0;
	end
	else if(rst_syn)begin
		bit_enough_to_bpc<=0;
	end
	else if(flush_over)begin
		if(count_mq_out>=song_require)begin
			bit_enough_to_bpc<=1;
		end
		else begin
			bit_enough_to_bpc<=0;
		end
	end
	else begin
			bit_enough_to_bpc<=0;
	end	
end	

always @(posedge clk or negedge rst)
  if(!rst)
    flush_delay5<=0;
  else if(rst_syn)begin
	flush_delay5<=0;
  end  
 else if(start_aga) begin
    flush_delay5<=0;
 end
  else if(!flush_over)
    flush_delay5<=flush_delay4;

endmodule

	 




  
 
  

	



