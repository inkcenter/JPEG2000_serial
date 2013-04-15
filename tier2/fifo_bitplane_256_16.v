module fifo_bitplane_256_16(rd_clk,
						wr_clk,
						rst_syn,
						din,
						pass,
						fifo_group,
						rd_data_count_sp_0,
                        rd_data_count_mp_0,
                        rd_data_count_cp_0,
                        rd_data_count_sp_1,
                        rd_data_count_mp_1,
                        rd_data_count_cp_1,
						empty_sp_0,
                        empty_mp_0,
                        empty_cp_0,
                        empty_sp_1,
                        empty_mp_1,
                        empty_cp_1,
						dout_sp_0,
                        dout_mp_0,
                        dout_cp_0,
                        dout_sp_1,
                        dout_mp_1,
                        dout_cp_1,
						rd_en_sp_0,
						rd_en_mp_0,
						rd_en_cp_0,
						rd_en_sp_1,
						rd_en_mp_1,
						rd_en_cp_1

);
	input rd_clk;
	input wr_clk;
	input rst_syn;
	input fifo_group;

	input [1:0]pass;
	input [15:0]din;
	input rd_en_sp_0;
	input rd_en_mp_0;
	input rd_en_cp_0;
	input rd_en_sp_1;
	input rd_en_mp_1;
	input rd_en_cp_1;
	output [7:0]rd_data_count_sp_0;
	output [7:0]rd_data_count_mp_0;
	output [7:0]rd_data_count_cp_0;
	output [7:0]rd_data_count_sp_1;
	output [7:0]rd_data_count_mp_1;
	output [7:0]rd_data_count_cp_1;
	output empty_sp_0;
	output empty_mp_0;
	output empty_cp_0;
	output empty_sp_1;
	output empty_mp_1;
	output empty_cp_1;
	output [15:0]dout_sp_0;
	output [15:0]dout_mp_0;
	output [15:0]dout_cp_0;
	output [15:0]dout_sp_1;
	output [15:0]dout_mp_1;
	output [15:0]dout_cp_1;




	wire wr_en_sp_0=(pass==1)&&(!fifo_group);
	wire wr_en_mp_0=(pass==2)&&(!fifo_group);
	wire wr_en_cp_0=(pass==3)&&(!fifo_group);
	wire wr_en_sp_1=(pass==1)&&(fifo_group);
	wire wr_en_mp_1=(pass==2)&&(fifo_group);
	wire wr_en_cp_1=(pass==3)&&(fifo_group);
	// Outputs
	wire [15:0]dout_sp_0;
	wire [15:0]dout_mp_0;
	wire [15:0]dout_cp_0;
	wire [15:0]dout_sp_1;
	wire [15:0]dout_mp_1;
	wire [15:0]dout_cp_1;
	wire full_sp_0;
	wire full_mp_0;
	wire full_cp_0;
	wire full_sp_1;
	wire full_mp_1;
	wire full_cp_1;
	wire empty_sp_0;
	wire empty_mp_0;
	wire empty_cp_0;
	wire empty_sp_1;
	wire empty_mp_1;
	wire empty_cp_1;
	wire [7:0]rd_data_count_sp_0;
	wire [7:0]rd_data_count_mp_0;
	wire [7:0]rd_data_count_cp_0;
	wire [7:0]rd_data_count_sp_1;
	wire [7:0]rd_data_count_mp_1;
	wire [7:0]rd_data_count_cp_1;



	fifo_256_16	fifo_sp_0(
		.rst			(rst_syn),
		.wr_clk			(wr_clk),
		.rd_clk			(rd_clk),
		.din			(din),
		.wr_en			(wr_en_sp_0),
		.rd_en			(rd_en_sp_0),
		.dout			(dout_sp_0),
		.full			(full_sp_0),
		.empty			(empty_sp_0),
		.rd_data_count	(rd_data_count_sp_0)
	);
	fifo_256_16	fifo_mp_0(
		.rst			(rst_syn),
		.wr_clk			(wr_clk),
		.rd_clk			(rd_clk),
		.din			(din),
		.wr_en			(wr_en_mp_0),
		.rd_en			(rd_en_mp_0),
		.dout			(dout_mp_0),
		.full			(full_mp_0),
		.empty			(empty_mp_0),
		.rd_data_count	(rd_data_count_mp_0)
	);
	fifo_256_16	fifo_cp_0(
		.rst			(rst_syn),
		.wr_clk			(wr_clk),
		.rd_clk			(rd_clk),
		.din			(din),
		.wr_en			(wr_en_cp_0),
		.rd_en			(rd_en_cp_0),
		.dout			(dout_cp_0),
		.full			(full_cp_0),
		.empty			(empty_cp_0),
		.rd_data_count	(rd_data_count_cp_0)
	);
	fifo_256_16	fifo_sp_1(
		.rst			(rst_syn),
		.wr_clk			(wr_clk),
		.rd_clk			(rd_clk),
		.din			(din),
		.wr_en			(wr_en_sp_1),
		.rd_en			(rd_en_sp_1),
		.dout			(dout_sp_1),
		.full			(full_sp_1),
		.empty			(empty_sp_1),
		.rd_data_count	(rd_data_count_sp_1)
	);
	fifo_256_16	fifo_mp_1(
		.rst			(rst_syn),
		.wr_clk			(wr_clk),
		.rd_clk			(rd_clk),
		.din			(din),
		.wr_en			(wr_en_mp_1),
		.rd_en			(rd_en_mp_1),
		.dout			(dout_mp_1),
		.full			(full_mp_1),
		.empty			(empty_mp_1),
		.rd_data_count	(rd_data_count_mp_1)
	);
	fifo_256_16	fifo_cp_1(
		.rst			(rst_syn),
		.wr_clk			(wr_clk),
		.rd_clk			(rd_clk),
		.din			(din),
		.wr_en			(wr_en_cp_1),
		.rd_en			(rd_en_cp_1),
		.dout			(dout_cp_1),
		.full			(full_cp_1),
		.empty			(empty_cp_1),
		.rd_data_count	(rd_data_count_cp_1)
	);
endmodule

