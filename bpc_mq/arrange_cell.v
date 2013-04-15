`timescale 1ns/10ps
module arrange_cell(//output
                    arrange_out,
					arrange_out_vld,
					//input 
					stall_vld,
					//halt,
					cxd_c,
					cxd_r,
					cxd_vld_c,
					cxd_vld_l,
					cxd_vld_r,
					clk_dwt,
					pos_clk_bpc,
					rst,
					rst_syn);
					
	output [7:0] arrange_out;
	output  arrange_out_vld;
	input  stall_vld;
	input  [7:0] cxd_c;
	input  [7:0] cxd_r;
	input  cxd_vld_c;
	input  cxd_vld_l;
	input  cxd_vld_r;
	input  clk_dwt;
	input  pos_clk_bpc;
	input  rst;
	input  rst_syn;
	
	
	reg [7:0] arrange_out;
	reg arrange_out_vld;
	
	always@(posedge clk_dwt or negedge rst) begin
	    if(!rst) begin
		    arrange_out <= 8'b0;
			arrange_out_vld <= 1'b0;
		end
		else if(rst_syn)begin
			arrange_out <= 8'b0;
			arrange_out_vld <= 1'b0;
		end
		else if(pos_clk_bpc==1'b1)begin
			if(stall_vld == 1'b1) begin
				arrange_out <= arrange_out;
				arrange_out_vld <= arrange_out_vld;
			end
			else if(((cxd_vld_c == 1'b1)&&(cxd_vld_l == 1'b0))||((cxd_vld_c == 1'b0)&&(cxd_vld_r == 1'b0))) begin
				arrange_out <= 8'b0;
				arrange_out_vld <= 1'b0;
			end
			else if((cxd_vld_c == 1'b1)&&(cxd_vld_l == 1'b1)) begin
				arrange_out <= cxd_c;
				arrange_out_vld <= cxd_vld_c;
			end
			else if((cxd_vld_c == 1'b0)&&(cxd_vld_r == 1'b1)) begin
				arrange_out <= cxd_r;
				arrange_out_vld <= cxd_vld_r;
			end
		end
	end
	
endmodule 