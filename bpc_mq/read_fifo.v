`timescale 1ns/10ps
module read_fifo(//output
                 fifo_out,
                 rd_vld,
				 start_aga,
				 //input
				 fifo_out0,
				 fifo_out1,
				 fifo_out2,
				 fifo_out3,
				 fifo_out4,
				 fifo_out5,
				 fifo_out6,
				 fifo_out7,
				 fifo_out8,
				 fifo_out9,
				 rdempty,
				 stop_rd,
				 clk_rd,
				 halt_to_fifo,
				 rst,
				 rst_syn	);
	
    output [7:0] fifo_out;
	output start_aga;		// to  bpc_read_control
	output [9:0] rd_vld;
	
	input [7:0] fifo_out0;
	input [7:0] fifo_out1;
	input [7:0] fifo_out2;
	input [7:0] fifo_out3;
	input [7:0] fifo_out4;
	input [7:0] fifo_out5;
	input [7:0] fifo_out6;
	input [7:0] fifo_out7;
	input [7:0] fifo_out8;
	input [7:0] fifo_out9;
	input [9:0] rdempty;
	input       stop_rd;
	input       clk_rd;
	input       rst;
	input       rst_syn;
	input halt_to_fifo;
	
    reg [9:0] rd_vld_reg;
	reg [9:0] rd_vld_n;
	

	reg start_aga;
	wire start_aga_1;
	assign start_aga_1=((rdempty==10'b1111111111))?1'b1:1'b0;

	
	  always@(posedge clk_rd or negedge rst)begin
		if(!rst)begin
			start_aga<=1'b0;
		end
		else if(rst_syn)begin
			start_aga<=1'b0;
		end
		else if(start_aga_1==1'b1)begin
			 if(halt_to_fifo==1'b1)begin
				start_aga<=1'b1;
			end
			else begin
				start_aga<=1'b0;
			end
		end	
		else begin
			start_aga<=1'b0;
		end
	end   

	always@(posedge clk_rd or negedge rst) begin
	    if(!rst) begin
		    rd_vld_reg <= 10'b0;
		end
		else if(rst_syn)begin
			rd_vld_reg <= 10'b0;
		end
		else begin
		    rd_vld_reg <= rd_vld_n;
		end
	end
	
	always@(*) begin
	    rd_vld_n = rd_vld_reg;
	if((stop_rd == 1'b0)&&(rdempty!=10'b1111111111))begin
			if(rd_vld_reg == 10'b0) begin
			    rd_vld_n = 10'b0000000001;
			end
			else begin
		        rd_vld_n = {rd_vld_reg[8:0],rd_vld_reg[9]};
			end
		end
	end
	
	wire [9:0] rd_vld;
	assign rd_vld = ((stop_rd == 1'b1)||(rdempty==10'b1111111111))? 10'b0:rd_vld_reg;

	reg [9:0]rd_vld_delay1;
	always@(posedge clk_rd or negedge rst) begin
	  if(!rst) begin
	    rd_vld_delay1 <= 10'b0;
	  end
	  else if(rst_syn)begin
		rd_vld_delay1 <= 10'b0;
	  end
	  else begin
	    rd_vld_delay1 <= rd_vld;
	  end
	end
	
	reg [7:0] fifo_out;
	always@(*) begin
	    case(rd_vld_delay1)
		    10'b0000000001: begin
			    fifo_out = fifo_out0;
			end
			10'b0000000010: begin
			    fifo_out = fifo_out1;
			end
			10'b0000000100: begin
			    fifo_out = fifo_out2;
			end
			10'b0000001000: begin
			    fifo_out = fifo_out3;
			end
			10'b0000010000: begin
			    fifo_out = fifo_out4;
			end
			10'b0000100000: begin
			    fifo_out = fifo_out5;
			end
			10'b0001000000: begin
			    fifo_out = fifo_out6;
			end
			10'b0010000000: begin
			    fifo_out = fifo_out7;
			end
			10'b0100000000: begin
			    fifo_out = fifo_out8;
			end
			10'b1000000000: begin
			    fifo_out = fifo_out9;
			end
			default: begin
			    fifo_out = 8'b0;
			end
		endcase
	end
	
	

endmodule 