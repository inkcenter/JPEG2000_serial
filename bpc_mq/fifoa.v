`timescale 1ns/10ps
module fifoa(//output
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
			 wrfull,
			 //input
			 wr_vld,
			 rd_vld,
			 fifo_in0,
			 fifo_in1,
			 fifo_in2,
			 fifo_in3,
			 fifo_in4,
			 fifo_in5,
			 fifo_in6,
			 fifo_in7,
			 fifo_in8,
             fifo_in9,
			 clk_rd,
			 clk_wr);
			 
	output [7:0] fifo_out0;
	output [7:0] fifo_out1;
	output [7:0] fifo_out2;
	output [7:0] fifo_out3;
	output [7:0] fifo_out4;
	output [7:0] fifo_out5;
	output [7:0] fifo_out6;
	output [7:0] fifo_out7;
	output [7:0] fifo_out8;
	output [7:0] fifo_out9;
	output [9:0] rdempty;
	output [9:0] wrfull;
	
	input [7:0] fifo_in0;
	input [7:0] fifo_in1;
    input [7:0] fifo_in2;
    input [7:0] fifo_in3;
    input [7:0] fifo_in4;
    input [7:0] fifo_in5;
    input [7:0] fifo_in6;
    input [7:0] fifo_in7;
    input [7:0] fifo_in8;
    input [7:0] fifo_in9;
    input [9:0] wr_vld;
	input [9:0] rd_vld;
	input       clk_rd;
	input       clk_wr;
	
	wire [7:0] fifo_in0;
	wire [7:0] fifo_in1;
	wire [7:0] fifo_in2;
	wire [7:0] fifo_in3;
	wire [7:0] fifo_in4;
	wire [7:0] fifo_in5;
	wire [7:0] fifo_in6;
	wire [7:0] fifo_in7;
	wire [7:0] fifo_in8;
	wire [7:0] fifo_in9;
	
	wire [9:0] rdempty;
	wire [9:0] wrfull;
	
			 

				 
	fifo  u_fifo0(
	              .wr_clk (clk_wr),
	              .rd_clk (clk_rd),
	              .din  (fifo_in0),
	              .wr_en (wr_vld[0]),
	              .rd_en (rd_vld[0]),
	              .dout (fifo_out0),
	              .full (wrfull[0]),
	              .empty (rdempty[0]));
				 

				 
	fifo  u_fifo1(
	             .wr_clk (clk_wr),
	             .rd_clk (clk_rd),
	             .din  (fifo_in1),
	             .wr_en (wr_vld[1]),
	             .rd_en (rd_vld[1]),
	             .dout (fifo_out1),
	             .full (wrfull[1]),
	             .empty (rdempty[1]));
	
				 

	
	fifo  u_fifo2(
	             .wr_clk (clk_wr),
	             .rd_clk (clk_rd),
	             .din  (fifo_in2),
	             .wr_en (wr_vld[2]),
	             .rd_en (rd_vld[2]),
	             .dout (fifo_out2),
	             .full (wrfull[2]),
	             .empty (rdempty[2]));			 
	
				 

	
	fifo  u_fifo3(
	             .wr_clk (clk_wr),
	             .rd_clk (clk_rd),
	             .din  (fifo_in3),
	             .wr_en (wr_vld[3]),
	             .rd_en (rd_vld[3]),
	             .dout (fifo_out3),
	             .full (wrfull[3]),
	             .empty (rdempty[3]));
	
				 

				 
	fifo  u_fifo4(
	             .wr_clk (clk_wr),
	             .rd_clk (clk_rd),
	             .din  (fifo_in4),
	             .wr_en (wr_vld[4]),
	             .rd_en (rd_vld[4]),
	             .dout (fifo_out4),
	             .full (wrfull[4]),
	             .empty (rdempty[4]));
				 

	
	fifo  u_fifo5(
	             .wr_clk (clk_wr),
	             .rd_clk (clk_rd),
	             .din  (fifo_in5),
	             .wr_en (wr_vld[5]),
	             .rd_en (rd_vld[5]),
	             .dout (fifo_out5),
	             .full (wrfull[5]),
	             .empty (rdempty[5]));
				 

				 
	fifo  u_fifo6(
	             .wr_clk (clk_wr),
	             .rd_clk (clk_rd),
	             .din  (fifo_in6),
	             .wr_en (wr_vld[6]),
	             .rd_en (rd_vld[6]),
	             .dout (fifo_out6),
	             .full (wrfull[6]),
	             .empty (rdempty[6]));
				 

				 
	fifo  u_fifo7(
	             .wr_clk (clk_wr),
	             .rd_clk (clk_rd),
	             .din  (fifo_in7),
	             .wr_en (wr_vld[7]),
	             .rd_en (rd_vld[7]),
	             .dout (fifo_out7),
	             .full (wrfull[7]),
	             .empty (rdempty[7]));
				 

				 
	fifo  u_fifo8(
	             .wr_clk (clk_wr),
	             .rd_clk (clk_rd),
	             .din  (fifo_in8),
	             .wr_en (wr_vld[8]),
	             .rd_en (rd_vld[8]),
	             .dout (fifo_out8),
	             .full (wrfull[8]),
	             .empty (rdempty[8]));
				 
				 
	fifo  u_fifo9(
	             .wr_clk (clk_wr),
	             .rd_clk (clk_rd),
	             .din  (fifo_in9),
	             .wr_en (wr_vld[9]),
	             .rd_en (rd_vld[9]),
	             .dout (fifo_out9),
	             .full (wrfull[9]),
	             .empty (rdempty[9]));
				 
				 
endmodule