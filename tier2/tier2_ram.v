`timescale 1ns/1ns
module tier2_ram(rd_clk,
				laddr_rd,
				laddr_wr,
				output_to_ram,
				lram_write_en,
				lram_read_en,
				ldata_ram,
				rst_syn
);

	parameter ADDR_WIDTH=14,
			WORD_WIDTH=18;

	input rd_clk;
	input [ADDR_WIDTH-1:0]laddr_rd;
	input [ADDR_WIDTH-1:0]laddr_wr;
	input [WORD_WIDTH-1:0]output_to_ram;
	input lram_write_en;
	input lram_read_en;
	input rst_syn;

	output [WORD_WIDTH-1:0]ldata_ram;
	/***** wire *****/
	wire [ADDR_WIDTH-1:0]lram_address;

	
	/***** wire internal *****/
	assign lram_address=lram_write_en?laddr_wr:(lram_read_en?laddr_rd:0);

	/***** wire output *****/
	//assign lrw_=~lram_write_en;




 ram_12k	ram_12k (
		.clka			(rd_clk),
		.wea			(lram_write_en),
		.addra			(lram_address),
		.dina			(output_to_ram),
		.douta			(ldata_ram),
		.rsta(rst_syn)
	);



endmodule

