`timescale 1ns/10ps
module mq_out_state_generate(  //output
								word_last_sp,
								word_last_cp,
								word_last_mrp,
								bp_code_over,	
								//input
								data_valid_pass_reg,
								word_last_valid,
								word_last_flag,
								flush_over,
								clk,
								rst,	
								rst_syn		);
								
output word_last_sp;
output word_last_mrp;
output word_last_cp;
output bp_code_over;

input [1:0]data_valid_pass_reg;
input [1:0]word_last_valid;
input word_last_flag;
input flush_over;
input clk;
input rst;
input rst_syn;

reg bp_code_over;
reg word_last_sp;
reg word_last_mrp;
reg word_last_cp;



always @(posedge clk or negedge rst) 
	begin
		if(!rst) 
			begin
				bp_code_over <=1'b0;
			end
		else if(rst_syn)
			begin
				bp_code_over <=1'b0;
			end
		else 
			begin
				bp_code_over <=flush_over;
			end
	end

	
	
always @(posedge clk or negedge rst) 
	begin
		if(!rst) 
			begin
				word_last_sp <=1'b0;
			end
		else if(rst_syn)
			begin
				word_last_sp <=1'b0;
			end
		else if((word_last_valid==2'b01)&&(data_valid_pass_reg==2'b01))
			begin
				word_last_sp <=word_last_flag;
			end
		else if(bp_code_over) 
			begin
				word_last_sp <=1'b0;
			end
	end

always @(posedge clk or negedge rst) 
	begin
		if(!rst) 
			begin
				word_last_mrp <=1'b0;
			end
		else if(rst_syn)
			begin
				word_last_mrp <=1'b0;
			end
		else if((word_last_valid==2'b10)&&(data_valid_pass_reg==2'b10))
			begin
				word_last_mrp <=word_last_flag;
			end
		else if(bp_code_over) 
			begin
				word_last_mrp <=1'b0;
			end
	end	
	
always @(posedge clk or negedge rst) 
	begin
		if(!rst) 
			begin
				word_last_cp <=1'b0;
			end
		else if(rst_syn)
			begin
				word_last_cp <=1'b0;
			end
		else if((word_last_valid==2'b11)&&(data_valid_pass_reg==2'b11))
			begin
				word_last_cp <=word_last_flag;
			end
		else if(bp_code_over) 
			begin
				word_last_cp <=1'b0;
			end
	end
	
endmodule

