`timescale 1ns/10ps
module quant_circuit ( //output
                       quant_out_h,
					   quant_out_l,
					   quant_out_vld,
					   //input
					   row_ldata,
					   row_hdata,
					   row_out_vld,
					   dwt_work,
					   ce0_ctrl,
					   level,
					   clk_qk,
					   rst,
					   rst_syn);

input [15:0] row_ldata;
input [15:0] row_hdata;
input row_out_vld;
input dwt_work;
input [2:0] level;
input ce0_ctrl;
input clk_qk;
input rst;
input rst_syn;


output[16:0] quant_out_h;
output[16:0] quant_out_l;
output quant_out_vld;

reg[3:0] indic_mux_l;
reg[3:0] indic_mux_h;


always @(*) begin
  case(level)
    3'b000:   begin
	            if(ce0_ctrl==1'b1) begin
				  indic_mux_h = 4'b1101; //LH1
				  indic_mux_l =4'b0000;
				end
				else begin
				  indic_mux_l = 4'b1110;  //HL1
				  indic_mux_h = 4'b1111;  //HH1
				end
			  end
	3'b001:   begin
	            if(ce0_ctrl==1'b0) begin
				  indic_mux_h = 4'b1010;  //LH2
				  indic_mux_l =4'b0000;
				end
				else begin
				  indic_mux_l = 4'b1011;  //HL2
				  indic_mux_h = 4'b1100;  //HH2
				end
			  end
	3'b010:   begin
	            if(ce0_ctrl==1'b1) begin
				  indic_mux_h = 4'b0111;  //LH3
				  indic_mux_l =4'b0000;
				end
				else begin
				  indic_mux_l = 4'b1000;  //HL3
				  indic_mux_h = 4'b1001;  //HH3
				end
			  end
	3'b011:   begin
	            if(ce0_ctrl==1'b0) begin
				  indic_mux_h = 4'b0100;  //LH4
				  indic_mux_l =4'b0000;
				end
				else begin
				  indic_mux_l = 4'b0101;  //HL4
				  indic_mux_h = 4'b0110;  //HH4
				end
			  end
	3'b100:   begin
	            if(ce0_ctrl==1'b1) begin
				  indic_mux_l = 4'b0000;  //LL5
				  indic_mux_h = 4'b0001;  //LH5
				end
				else begin
				  indic_mux_l = 4'b0010;  //HL5
				  indic_mux_h = 4'b0011;  //HH5
				end
			  end 
	default:  begin
	            indic_mux_l = 4'b0000;
				indic_mux_h = 4'b0000;
			  end
   endcase
end

parameter 
          mux_in1=20'b01000011111110111100,     //278460   LL5
          mux_in2=20'b01000100101100100010,     //281378   LH5
          mux_in3=20'b01000100101100100010,     //281378   HL5
          mux_in4=20'b01000101100100100011,     //284963   HH5
          mux_in5=20'b00100010001010110011,     //139955   LH4
          mux_in6=20'b00100010001010110011,     //139955   HL4
          mux_in7=20'b00100010011010111001,     //140985   HH4
          mux_in8=20'b00010000101111000100,     //68548    LH3
          mux_in9=20'b00010000101111000100,     //68548    HL3
          mux_in10=20'b00010000101001000101,    //68165    HH3
          mux_in11=20'b00000111111111010000,    //32720    LH2
          mux_in12=20'b00000111111111010000,    //32720    HL2
          mux_in13=20'b00000111101111010011,    //31699    HH2
          mux_in14=20'b00000100000010111000,    //16568    LH1
          mux_in15=20'b00000100000010111000,    //16568    HL1
          mux_in16=20'b00000100001010010111;    //17047    HH1
		  
reg[19:0] mux_out_l;
reg[19:0] mux_out_h;

always@(*) begin
  case(indic_mux_l)
          4'b0000:mux_out_l=mux_in1;
          4'b0001:mux_out_l=mux_in2;
          4'b0010:mux_out_l=mux_in3;
          4'b0011:mux_out_l=mux_in4;
          4'b0100:mux_out_l=mux_in5;
          4'b0101:mux_out_l=mux_in6;
          4'b0110:mux_out_l=mux_in7;
          4'b0111:mux_out_l=mux_in8;
          4'b1000:mux_out_l=mux_in9;
          4'b1001:mux_out_l=mux_in10;
          4'b1010:mux_out_l=mux_in11;
          4'b1011:mux_out_l=mux_in12;
          4'b1100:mux_out_l=mux_in13;
          4'b1101:mux_out_l=mux_in14;
          4'b1110:mux_out_l=mux_in15;
          4'b1111:mux_out_l=mux_in16;
  endcase  
end

always@(*) begin
  case(indic_mux_h)
          4'b0000:mux_out_h=mux_in1;
          4'b0001:mux_out_h=mux_in2;
          4'b0010:mux_out_h=mux_in3;
          4'b0011:mux_out_h=mux_in4;
          4'b0100:mux_out_h=mux_in5;
          4'b0101:mux_out_h=mux_in6;
          4'b0110:mux_out_h=mux_in7;
          4'b0111:mux_out_h=mux_in8;
          4'b1000:mux_out_h=mux_in9;
          4'b1001:mux_out_h=mux_in10;
          4'b1010:mux_out_h=mux_in11;
          4'b1011:mux_out_h=mux_in12;
          4'b1100:mux_out_h=mux_in13;
          4'b1101:mux_out_h=mux_in14;
          4'b1110:mux_out_h=mux_in15;
          4'b1111:mux_out_h=mux_in16;
  endcase  
end

//////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////

wire cal_vld;
assign cal_vld = ((level == 3'b100)||(((level==3'b000)||(level==3'b010))&&(ce0_ctrl==1'b0))||(((level==3'b001)||(level==3'b011))&&(ce0_ctrl==1'b1)));

reg cal_vld_reg;

always @(posedge clk_qk or negedge rst) begin
  if(!rst)
    cal_vld_reg <= 1'b0;
  else if(rst_syn)
	cal_vld_reg <= 1'b0;
  else if(dwt_work==1'b1)
    cal_vld_reg <= cal_vld;
end

wire signed [35:0] mul_out_l;
assign mul_out_l= $signed(row_ldata)*$signed(mux_out_l);


reg[35:0] mul_out_l_reg_vld;

always @(posedge clk_qk or negedge rst) begin
  if(!rst)
    mul_out_l_reg_vld <= 36'b0;
  else if(rst_syn)
	mul_out_l_reg_vld <= 36'b0;	
  else if(dwt_work==1'b1)
    mul_out_l_reg_vld <= mul_out_l;
end



reg[15:0] mul_out_l_reg_unvld;

always @(posedge clk_qk or negedge rst) begin
  if(!rst)
    mul_out_l_reg_unvld <= 16'b0;
  else if(rst_syn)
	mul_out_l_reg_unvld <= 16'b0;
  else if(dwt_work==1'b1)
    mul_out_l_reg_unvld <= row_ldata;
end


reg[16:0] quant_out_l;

always @(posedge clk_qk or negedge rst) begin
  if(!rst)
    quant_out_l <= 17'b0;
  else if(rst_syn)
	 quant_out_l <= 17'b0;
  else if(dwt_work==1'b1) begin
            if(cal_vld_reg) begin
              if(mul_out_l_reg_vld[30]==1'b0) begin
			     quant_out_l <= $signed(mul_out_l_reg_vld[30:14]);
			  end
			  else begin
			    if((|mul_out_l_reg_vld[13:0])==1'b1) begin
				 quant_out_l <= $signed(mul_out_l_reg_vld[30:14])+$signed(2'b01);
				end
				else begin
			     quant_out_l <= $signed(mul_out_l_reg_vld[30:14]);
			    end
			  end
            end 
            else begin
              quant_out_l <= $signed(mul_out_l_reg_unvld);
            end
  end
end
//////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////

wire signed [35:0] mul_out_h;
assign mul_out_h= $signed(row_hdata)*$signed(mux_out_h);


reg[35:0] mul_out_h_reg;

always @(posedge clk_qk or negedge rst) begin
  if(!rst)
    mul_out_h_reg <= 36'b0;
  else if(rst_syn)
    mul_out_h_reg <= 36'b0;	
  else if(dwt_work==1'b1)
    mul_out_h_reg <= mul_out_h;
end 
 

 
reg[16:0] quant_out_h;

always @(posedge clk_qk or negedge rst) begin
  if(!rst)
    quant_out_h <= 17'b0;
  else if(rst_syn)
    quant_out_h <= 17'b0;	
  else if(dwt_work==1'b1) begin
          if(mul_out_h_reg[30]==1'b0) begin
             quant_out_h <= $signed(mul_out_h_reg[30:14]) ;
		  end
		  else begin
		    if((|mul_out_h_reg[13:0])==1'b1) begin
		     quant_out_h <= $signed(mul_out_h_reg[30:14])+$signed(2'b01);
			end
			else begin
			 quant_out_h <= $signed(mul_out_h_reg[30:14]);
			end
		  end 
  end
end

/////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////

reg row_out_vld_reg;

always @(posedge clk_qk or negedge rst) begin
  if(!rst)
    row_out_vld_reg <= 1'b0;
  else if(rst_syn)
    row_out_vld_reg <= 1'b0;	
  else if(dwt_work==1'b1)
    row_out_vld_reg <= row_out_vld;
end		  

reg quant_out_vld;

always @(posedge clk_qk or negedge rst) begin
  if(!rst)
    quant_out_vld <= 16'b0;
  else if(rst_syn)
     quant_out_vld <= 16'b0;
  else if(dwt_work==1'b1||(level==3'b111))
    quant_out_vld <= row_out_vld_reg;
end	

endmodule
