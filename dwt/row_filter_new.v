`timescale 1ns/10ps
module row_filter(//output
                  row_ldata,
				  row_hdata,
				  row_out_vld,
				  
                  //input 
				  atrcol_out1,
				  atrcol_out2,
				  col_out_vld,
				  level,
				 dwt_work,
				 rf_over,
				  clk_rf,
				  rst,
				  rst_syn);
	output rf_over;			  
    output [15:0] row_ldata;
	output [15:0] row_hdata;
	output row_out_vld;
	input  [15:0] atrcol_out1;
	input  [15:0] atrcol_out2;
	input  [2:0] level;
	input  col_out_vld;
	input  clk_rf;
	input  rst;
	input  rst_syn;
	input  dwt_work;

	parameter a = 14'b10101111010011;
	parameter b = 18'b011001110011001101;
	parameter c = 19'b1010101001111100111;
	parameter d = 16'b0111000110111000;
	parameter e = 10'b0101110110;
	parameter f = 9'b011011011;

	parameter idle = 2'b00;
	parameter calc_fl = 2'b01;
	parameter calc_sl = 2'b10;
	parameter calc_other = 2'b11;
	
	reg [1:0] fsm_rf;
	reg [1:0] fsm_rf_n;
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    fsm_rf <= 2'b0;
		end
		else if(rst_syn)begin
			fsm_rf <= 2'b0;
		end
		else begin
		    fsm_rf <= fsm_rf_n;
		end
	end
	
	wire rcv_col_vld = ((fsm_rf == calc_fl)||(fsm_rf == calc_sl)||(fsm_rf == calc_other));
	
	wire calc_fl_uvld = (fsm_rf == calc_fl);
	
	wire calc_sl_uvld = (fsm_rf == calc_sl);
	
	wire srst = (fsm_rf == idle);
	
	reg [7:0] prow_cnt;
	reg prow_cnt_sel;
	
	always@(*) begin
	    case(level) 
		    3'b000: begin
			    prow_cnt_sel = (prow_cnt == 128);
			end
			3'b001: begin
			    prow_cnt_sel = (prow_cnt == 64);
			end
			3'b010: begin
			    prow_cnt_sel = (prow_cnt == 32);
			end
			3'b011: begin
			    prow_cnt_sel = (prow_cnt == 16);
			end
			3'b100: begin
			    prow_cnt_sel = (prow_cnt == 8);
			end
			default: begin
			    prow_cnt_sel = 0;
			end
		endcase
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    prow_cnt <= 10'b0;
		end
		else if(rst_syn)begin
			 prow_cnt <= 10'b0;
		end
		else if(srst == 1'b1) begin
		    prow_cnt <= 10'b0;
		end
		else if(dwt_work)begin
		       if(rcv_col_vld == 1'b1) begin
		          if(prow_cnt_sel == 1'b1) begin
			         prow_cnt <= 1;
			      end
		          else begin
			         prow_cnt <= prow_cnt + 1;
			      end
		       end
	    end
	end
	
	reg [7:0] arow_cnt;
	
	always @(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    arow_cnt <= 10'b0;
		end
		else if(rst_syn)begin
			arow_cnt <= 10'b0;
		end
		else if(srst == 1'b1) begin
		    arow_cnt <= 10'b0;
		end
		else if(dwt_work) begin
		       if(prow_cnt_sel == 1'b1) begin
		           arow_cnt <= arow_cnt + 1;
		       end
	    end
	end
	
	wire calc_fl_over = ((prow_cnt == 3)&&(arow_cnt == 0));
	
	wire calc_sl_over = ((prow_cnt == 7)&&(arow_cnt == 0));
	
	reg [15:0] stage1_reg1;
	reg [15:0] stage1_reg2;
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    stage1_reg1 <= 16'b0;
		end
		else if(rst_syn)begin
			stage1_reg1 <= 16'b0;
		end
		else if(srst == 1'b1) begin
		    stage1_reg1 <= 16'b0;
		end
		else if(dwt_work) begin
		        if(rcv_col_vld == 1'b1) begin
		          stage1_reg1 <= atrcol_out2;
		        end
	    end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    stage1_reg2 <= 16'b0;
		end
		else if(rst_syn)begin
			stage1_reg2 <= 16'b0;
		end
		else if(srst == 1'b1) begin
		    stage1_reg2 <= 16'b0;
		end
		else if(dwt_work) begin
		         if(rcv_col_vld == 1'b1) begin
		           stage1_reg2 <= atrcol_out1;
		         end
	    end
	end
	
	wire [29:0] mul_out1;
	wire [33:0] mul_out2;
	
	assign mul_out1 = $signed(stage1_reg1)*$signed(a);
	assign mul_out2 = $signed(stage1_reg2)*$signed(b);
	
	wire [15:0] stage2_reg1_n;
	wire [19:0] stage2_reg3_n;
	
	assign stage2_reg1_n = mul_out1[28:13];
	assign stage2_reg3_n = mul_out2[32:13];
	
	reg [15:0] stage2_reg1;
	reg [15:0] stage2_reg2;
	reg [19:0] stage2_reg3;
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    stage2_reg1 <= 16'b0;
		end
		else if(rst_syn)begin
			stage2_reg1 <= 16'b0;
		end
		else if(dwt_work) begin 
		    stage2_reg1 <= stage2_reg1_n;
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    stage2_reg3 <= 0;
		end
		else if(rst_syn)begin
			stage2_reg3 <= 0;
		end
		else if(dwt_work) begin
		    stage2_reg3 <= stage2_reg3_n;
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    stage2_reg2 <= 16'b0;
		end
		else if(rst_syn)begin
			stage2_reg2 <= 16'b0;
		end
		else if(dwt_work) begin
		    stage2_reg2 <= stage1_reg2;
		end
	end
	
	reg [15:0] boundary_reg1;
	reg [15:0] boundary_reg2;
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    boundary_reg1 <= 16'b0;
		end
		else if(rst_syn)begin
			boundary_reg1 <= 16'b0;
		end
		else if(dwt_work) begin
		    boundary_reg1 <= stage2_reg2;
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    boundary_reg2 <= 16'b0;
		end
		else if(rst_syn)begin
			boundary_reg2 <= 16'b0;
		end
		else if(dwt_work) begin
		    boundary_reg2 <= boundary_reg1;
		end
	end
	
	reg [15:0] buffer1_reg1;
	reg [15:0] buffer1_reg2;
	reg [19:0] buffer2_reg1;
	reg [19:0] buffer2_reg2;
	
	wire [15:0] buffer1_reg1_n;
	wire [19:0] buffer2_reg1_n;
	
	wire buffer2_sel;
	assign buffer2_sel = ((prow_cnt == 2)||(prow_cnt == 3));
	
	assign buffer1_reg1_n = stage2_reg1 + stage2_reg2;
	assign buffer2_reg1_n = (buffer2_sel == 1'b1)? (stage2_reg3 + {{4{stage2_reg1[15]}},stage2_reg1}):(stage2_reg3 + {{4{buffer1_reg2[15]}},buffer1_reg2});
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    buffer1_reg1 <= 16'b0;
		end
		else if(rst_syn)begin
			buffer1_reg1 <= 16'b0;
		end
		else if(dwt_work) begin
		    buffer1_reg1 <= buffer1_reg1_n;
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    buffer1_reg2 <= 16'b0;
		end
		else if(rst_syn)begin
			buffer1_reg2 <= 16'b0;
		end
		else if(dwt_work) begin
		    buffer1_reg2 <= buffer1_reg1;
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    buffer2_reg1 <= 0;
		end
		else if(rst_syn)begin
			buffer2_reg1 <= 0;
		end
		else if(dwt_work) begin
		    buffer2_reg1 <= buffer2_reg1_n;
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    buffer2_reg2 <= 0;
		end
		else if(rst_syn)begin
			 buffer2_reg2 <= 0;
		end
		else if(dwt_work) begin
		    buffer2_reg2 <= buffer2_reg1;
		end
	end
	
	reg [15:0] stage3_reg1;
	reg [16:0] stage3_reg2;
	
	wire [15:0] stage3_reg1_n;
	wire [16:0] stage3_reg2_n;
	
	
	wire [15:0] add_in1;
    assign add_in1 = ((prow_cnt == 2)||(prow_cnt == 3))? boundary_reg2:stage2_reg2;
	wire boundary_cal;
	assign boundary_cal=((prow_cnt==4)||(prow_cnt==5));
	
	assign stage3_reg1_n = add_in1 + buffer1_reg2;
	assign stage3_reg2_n = (boundary_cal==1)?({{3{add_in1[15]}},add_in1,1'b0} + {{4{buffer1_reg2[15]}},buffer1_reg2} + buffer2_reg2):({{4{add_in1[15]}},add_in1} + {{4{buffer1_reg2[15]}},buffer1_reg2} + buffer2_reg2);

	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    stage3_reg1 <= 16'b0;
		end
		else if(rst_syn)begin
			stage3_reg1 <= 16'b0;
		end
		else if(srst == 1'b1) begin
		    stage3_reg1 <= 16'b0;
		end
		else if(dwt_work) begin
		       if(calc_fl_uvld == 1'b1) begin
		         stage3_reg1 <= 16'b0;
		       end
		       else begin
		         stage3_reg1 <= stage3_reg1_n;
		       end
		end
	end

	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    stage3_reg2 <= 17'b0;
		end
		else if(rst_syn)begin
			stage3_reg2 <= 17'b0;
		end
		else if(srst == 1'b1) begin
		    stage3_reg2 <= 17'b0;
		end
		else if(dwt_work) begin
		         if(calc_fl_uvld == 1'b1) begin
		           stage3_reg2 <= 17'b0;
		         end
		         else begin
		           stage3_reg2 <= stage3_reg2_n;
		         end
	    end
	end
	
	wire [34:0] mul_out3;
	wire [31:0] mul_out4;
	
	assign mul_out3 = $signed(stage3_reg1)*$signed(c);
	assign mul_out4 = $signed(stage3_reg2)*$signed(d);
	
	wire [20:0] stage4_reg1_n;
	wire [18:0] stage4_reg2_n;
	
	assign stage4_reg1_n = mul_out3[33:13];
	assign stage4_reg2_n = mul_out4[31:13];
	
	reg [20:0] stage4_reg1;
	reg [18:0] stage4_reg2;
	reg [16:0] stage4_reg3;
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    stage4_reg1 <= 0;
		end
		else if(rst_syn)begin
			stage4_reg1 <= 0;
		end
		else if(dwt_work) begin
		    stage4_reg1 <= stage4_reg1_n;
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    stage4_reg2 <= 0;
		end
		else if(rst_syn)begin
			stage4_reg2 <= 0;
		end
		else if(dwt_work) begin
		    stage4_reg2 <= stage4_reg2_n;
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    stage4_reg3 <= 17'b0;
		end
		else if(rst_syn)begin
			stage4_reg3 <= 17'b0;
		end
		else if(dwt_work) begin
		    stage4_reg3 <= stage3_reg2;
		end
	end
	
	wire [20:0] buffer3_reg1_n;
	wire [18:0] buffer4_reg1_n;
	
	reg [20:0] buffer3_reg1;
	reg [20:0] buffer3_reg2;
	reg [18:0] buffer4_reg1;
	reg [18:0] buffer4_reg2;
	
	wire buffer4_sel = ((prow_cnt == 6)||(prow_cnt == 7));
	
	assign buffer3_reg1_n = stage4_reg1 + {{4{stage4_reg3[16]}},stage4_reg3};
	assign buffer4_reg1_n = (buffer4_sel == 1'b1)? ({{2{stage4_reg2[18]}},stage4_reg2} + stage4_reg1):({{2{stage4_reg2[18]}},stage4_reg2} + buffer3_reg2);
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    buffer3_reg1 <= 0;
		end
		else if(rst_syn)begin
			buffer3_reg1 <= 0;
		end
		else if(dwt_work) begin
		    buffer3_reg1 <= buffer3_reg1_n;
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    buffer3_reg2 <= 0;
		end
		else if(rst_syn)begin
			buffer3_reg2 <= 0;
		end
		else if(dwt_work) begin
		    buffer3_reg2 <= buffer3_reg1;
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    buffer4_reg1 <= 0;
		end
		else if(rst_syn)begin
			buffer4_reg1 <= 0;
		end
		else if(dwt_work) begin
		    buffer4_reg1 <= buffer4_reg1_n;
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    buffer4_reg2 <= 0;
		end
		else if(rst_syn)begin
			buffer4_reg2 <= 0;
		end
		else if(dwt_work) begin
		    buffer4_reg2 <= buffer4_reg1;
		end
	end
	
	reg [16:0] boundary_reg3;
	reg [16:0] boundary_reg4;
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    boundary_reg3 <= 16'b0;
		end
		else if(rst_syn)begin
			boundary_reg3 <= 16'b0;
		end
		else if(dwt_work) begin
		    boundary_reg3 <= stage4_reg3;
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    boundary_reg4 <= 16'b0;
		end
		else if(rst_syn)begin
			 boundary_reg4 <= 16'b0;
		end
		else if(dwt_work) begin
		    boundary_reg4 <= boundary_reg3;
		end
	end
	
	wire boundary_sel = ((prow_cnt == 6)||(prow_cnt == 7));
	
	wire [20:0] stage5_reg2_n;
	wire [20:0] stage5_reg1_n;
	
	wire [16:0] add_in2;
	assign add_in2 = (boundary_sel == 1)? boundary_reg4:stage4_reg3;
	
	wire boundary_cal_s;
	assign boundary_cal_s= ((prow_cnt == 8)||(prow_cnt == 9)||((level==3'b100)&&(arow_cnt>0)&&(prow_cnt==1)));
	
	assign stage5_reg2_n = {{4{add_in2[16]}},add_in2} + buffer3_reg2;
	wire [20:0] mid_add;
	assign mid_add = buffer3_reg2 + {{2{buffer4_reg2[18]}},buffer4_reg2};
	assign stage5_reg1_n =(boundary_cal_s==1)? ({{3{add_in2[16]}},add_in2,1'b0} + mid_add):({{4{add_in2[16]}},add_in2} + mid_add);
	
	reg [20:0] stage5_reg2;
	reg [20:0] stage5_reg1;
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    stage5_reg2 <= 0;
		end
		else if(rst_syn)begin
			stage5_reg2 <= 0;
		end
		else if(srst == 1'b1) begin
		    stage5_reg2 <= 0;
		end
		else if(dwt_work) begin
		       if(calc_sl_uvld == 1'b1) begin
		          stage5_reg2 <= 0;
		       end
		       else begin
		          stage5_reg2 <= stage5_reg2_n;
		       end
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    stage5_reg1 <= 0;
		end
		else if(rst_syn)begin
			stage5_reg1 <= 0;
		end
		else if(srst == 1'b1) begin
		    stage5_reg1 <= 0;
		end
		else if(dwt_work) begin
		       if(calc_sl_uvld == 1'b1) begin
		           stage5_reg1 <= 0;
		       end
		       else begin
		           stage5_reg1 <= stage5_reg1_n;
		       end
	    end
	end
	
	wire [28:0] mul_out5;
	wire [29:0] mul_out6;
	
	assign mul_out5 = $signed(stage5_reg1)*$signed(f);
	assign mul_out6 = $signed(stage5_reg2)*$signed(e);
	
	wire [15:0] row_ldata_n;
	wire [15:0] row_hdata_n;
	
	assign row_ldata_n = mul_out5[28:13];
	assign row_hdata_n = mul_out6[28:13];
	
	reg [15:0] row_ldata;
	reg [15:0] row_hdata;
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    row_ldata <= 16'b0;
		end
		else if(rst_syn)begin
			row_ldata <= 16'b0;
		end
		else if(srst == 1'b1) begin
		    row_ldata <= 16'b0;
		end
		else if(dwt_work) begin
		    row_ldata <= row_ldata_n;
		end
	end
	
	always@(posedge clk_rf or negedge rst) begin  
	    if(!rst) begin
		    row_hdata <= 16'b0;
		end
		else if(rst_syn)begin
			 row_hdata <= 16'b0;
		end
		else if(srst == 1'b1) begin
		    row_hdata <= 16'b0;
		end
		else if(dwt_work) begin
		    row_hdata <= row_hdata_n;
		end
	end
	
	
	reg rf_over;
	always@(*) begin
	    case(level)
		    3'b000: begin
			    rf_over = ((arow_cnt == 64)&&(prow_cnt == 9));
			end
			3'b001: begin
			    rf_over = ((arow_cnt == 32)&&(prow_cnt == 9));
			end
			3'b010: begin
			    rf_over = ((arow_cnt == 16)&&(prow_cnt == 9));
			end
			3'b011: begin
			    rf_over = ((arow_cnt == 8)&&(prow_cnt == 9));
			end
			3'b100: begin
			    rf_over = ((arow_cnt == 5)&&(prow_cnt == 1));
			end
			default: begin
			    rf_over = 0;
			end
		endcase
	end
	
	reg row_out_vld;
	
	always@(posedge clk_rf or negedge rst) begin
	    if(!rst) begin
		    row_out_vld <= 1'b0;
		end
		else if(rst_syn)begin
			 row_out_vld <= 1'b0;
		end
		else if(srst == 1'b1) begin
		    row_out_vld <= 1'b0;
		end
		else if(dwt_work) begin
		        if(((arow_cnt == 0)&&(prow_cnt == 9))||((level==3'b100)&&(arow_cnt==1)&&(prow_cnt==1)))begin
		           row_out_vld <= 1'b1;
		        end
		        else if(rf_over == 1'b1) begin
		           row_out_vld <= 1'b0;
		        end
	    end
    end
	
	always@(*) begin
	    fsm_rf_n = fsm_rf;
		case(fsm_rf)
            idle: begin
			    if(col_out_vld == 1'b1) begin
				    fsm_rf_n = calc_fl;
				end
				else begin
				    fsm_rf_n = idle;
				end
            end			
			calc_fl: begin
			    if(calc_fl_over == 1'b1) begin
				    fsm_rf_n = calc_sl;
				end
				else begin
				    fsm_rf_n = calc_fl;
				end
			end
			calc_sl: begin
			    if(calc_sl_over == 1'b1) begin
				    fsm_rf_n = calc_other;
				end
				else begin
				    fsm_rf_n = calc_sl;
				end
			end
			calc_other: begin
			    if(rf_over == 1'b1) begin
				    fsm_rf_n = idle;
				end
				else begin
				    fsm_rf_n = calc_other;
				end
			end
			default: begin
			    fsm_rf_n = idle;
			end
		endcase
	end
	
	
endmodule 