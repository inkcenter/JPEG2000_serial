`timescale 1ns/10ps
module transpose( //output
                  atrcol_out1,
                  atrcol_out2,				  
                  //input
				  col_ldata,
				  col_hdata,
				  col_out_vld,
				  dwt_work,
				  clk_tr,
				  rst,
				  rst_syn);
				  
    output [15:0] atrcol_out1;
    output [15:0] atrcol_out2;
	input  [15:0] col_ldata;
	input  [15:0] col_hdata;
	input  col_out_vld;
	input  clk_tr;
	input  rst;
	input rst_syn;
	input dwt_work;
	
	reg [15:0] stage1_reg1;
	reg [15:0] stage1_reg2;
	
	always@(posedge clk_tr or negedge rst) begin
	    if(!rst) begin
		    stage1_reg1 <= 16'b0;
		end
		else if(rst_syn)begin
			stage1_reg1 <= 16'b0;
		end
		else if(dwt_work == 1'b1) begin
		    stage1_reg1 <= col_ldata;
		end
	end
	
	always@(posedge clk_tr or negedge rst) begin
	    if(!rst) begin
		    stage1_reg2 <= 16'b0;
		end
		else if(rst_syn)begin
			stage1_reg2 <= 16'b0;
		end
		else if(dwt_work == 1'b1) begin
		    stage1_reg2 <= col_hdata;
		end
	end
	
	reg [15:0] stage2_reg;
	
	always@(posedge clk_tr or negedge rst) begin
	    if(!rst) begin
		    stage2_reg <= 16'b0;
		end
		else if(rst_syn)begin
			stage2_reg <= 16'b0;
		end
		else if(dwt_work == 1'b1) begin
		    stage2_reg <= stage1_reg2;
		end
	end
	
   
    reg sel_cnt;
	
	always@(posedge clk_tr or negedge rst) begin
	    if(!rst) begin
		    sel_cnt <= 1'b0;
		end
		else if(rst_syn)begin
			sel_cnt <= 1'b0;
		end
		else if(dwt_work == 1'b1) begin
		        if(col_out_vld == 1'b1)begin
		           sel_cnt <= (sel_cnt ^ 1'b1);
		        end
		        else begin
		           sel_cnt <= 1'b0;
		        end
	    end
	end
	
	wire [15:0] atrcol_out1;
	wire [15:0] atrcol_out2;
	
	assign atrcol_out1 = (sel_cnt == 1'b1)?  stage1_reg1:stage2_reg;
	assign atrcol_out2 = (sel_cnt == 1'b1)?  col_ldata:stage1_reg2;
   
      
endmodule 