`timescale 1ns/10ps
module test();

parameter RST_TIME = 10;
parameter START_TIME = 200000;
//input
reg start_cpu;
reg clk_dwt;
reg clk_sg;
wire clk_rc;
reg rst;
wire [31:0] addra_all_1;
reg  [2:0]  compression_ratio;
wire [31:0] douta_all_1;
wire        ena_all_1;
wire [31:0] output_address;
wire [31:0] output_to_fpga_32;
//wire        start_cpu;
wire        test_tier1;
wire [3:0]  wea_all_1;
wire [3:0]  write_en;

initial begin
		clk_dwt=0;
	forever
		#5 clk_dwt=~clk_dwt;
end 
assign clk_rc=clk_dwt;
initial 
begin
	compression_ratio=0;
	rst = 0;
	start_cpu = 0;
	#RST_TIME;
	rst = 1;
	#START_TIME;
	#START_TIME;
	#5;
	#10;
		#7992000;
	start_cpu = 1;
	#20;
	start_cpu = 0;
end
// always #10000 $display($time);
initial
begin
	repeat(24)
	begin
		@(posedge jpeg2000_top.rst_syn)
	begin
		#START_TIME;
		start_cpu = 1;
		#20;
		start_cpu = 0;
	end 
	end
end


initial
begin
	$fsdbDumpfile("wave.fsdb");
	$fsdbDumpvars(4,test);
end
 
jpeg2000_top jpeg2000_top(/*autoinst*/
    .clk_dwt                    (clk_dwt                        ),
    .rst                        (rst                            ),
    .start_cpu                  (start_cpu                      ),
    .douta_all_1                (douta_all_1[31:0]              ),
    .compression_ratio          (compression_ratio[2:0]         ),
    .write_en                   (write_en[3:0]                  ),
    .output_address             (output_address[31:0]           ),
    .ena_all_1                  (ena_all_1                      ),
    .wea_all_1                  (wea_all_1[3:0]                 ),
    .addra_all_1                (addra_all_1[31:0]              ),
    .output_to_fpga_32          (output_to_fpga_32[31:0]        ),
    .test_tier1                 (test_tier1                     )
);
endmodule
