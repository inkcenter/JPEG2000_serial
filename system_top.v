//==================================================================================================
//  Filename      : system_top.v
//  Created On    : 2013-04-04 20:07:14
//  Last Modified : 2013-06-23 13:25:48
//  Revision      : 
//  Author        : Tian Changsong
//
//  Description   : 
//
//
//==================================================================================================
`timescale 1ns / 1ps
module top(/*autoport*/
//inout
     fpga_0_Generic_Ethernet_10_100_PHY_MDIO_pin,
     sda,
     data_sram,
     fpga_0_DDR2_SDRAM_DDR2_DQS_n_pin,
     fpga_0_DDR2_SDRAM_DDR2_DQS_pin,
     fpga_0_DDR2_SDRAM_DDR2_DQ_pin,
//output
     start_cpu,
     test_signals,
     rst_n,
     fpga_0_Generic_Ethernet_10_100_PHY_rst_n_pin,
     fpga_0_Generic_Ethernet_10_100_PHY_tx_en_pin,
     fpga_0_Generic_Ethernet_10_100_PHY_tx_data_pin,
     fpga_0_Generic_Ethernet_10_100_PHY_MDC_pin,
     fpga_0_RS232_TX_pin,
     scl,
     clk_camera,
     output_test_camera,
     output_test_sram,
     address_to_sram,
     adv,
     write_en_n,
     chip_en,
     output_en,
     byte_en,
     clk_sram,
     fpga_0_DDR2_SDRAM_DDR2_CE_pin,
     fpga_0_DDR2_SDRAM_DDR2_WE_n_pin,
     fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin,
     fpga_0_DDR2_SDRAM_DDR2_CS_n_pin,
     fpga_0_DDR2_SDRAM_DDR2_DM_pin,
     fpga_0_DDR2_SDRAM_DDR2_Clk_pin,
     fpga_0_DDR2_SDRAM_DDR2_ODT_pin,
     fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin,
     fpga_0_DDR2_SDRAM_DDR2_Addr_pin,
     fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin,
     fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin,
//input
     clk_fpga,
     compression_ratio,
     rst,
     fpga_push_button,
     fpga_0_Generic_Ethernet_10_100_PHY_tx_clk_pin,
     fpga_0_Generic_Ethernet_10_100_PHY_rx_clk_pin,
     fpga_0_Generic_Ethernet_10_100_PHY_crs_pin,
     fpga_0_Generic_Ethernet_10_100_PHY_dv_pin,
     fpga_0_Generic_Ethernet_10_100_PHY_rx_data_pin,
     fpga_0_Generic_Ethernet_10_100_PHY_col_pin,
     fpga_0_Generic_Ethernet_10_100_PHY_rx_er_pin,
     fpga_0_RS232_RX_pin,
     cam_href,
     cam_pclk,
     cam_data,
     cam_vsyn);


input clk_fpga;
input [2:0]compression_ratio;
input rst;
input fpga_push_button;
output start_cpu;
output test_signals;
output rst_n;
input  fpga_0_Generic_Ethernet_10_100_PHY_tx_clk_pin;
input  fpga_0_Generic_Ethernet_10_100_PHY_rx_clk_pin;
input  fpga_0_Generic_Ethernet_10_100_PHY_crs_pin;
input  fpga_0_Generic_Ethernet_10_100_PHY_dv_pin;
input [3:0] fpga_0_Generic_Ethernet_10_100_PHY_rx_data_pin;
input  fpga_0_Generic_Ethernet_10_100_PHY_col_pin;
input  fpga_0_Generic_Ethernet_10_100_PHY_rx_er_pin;
output fpga_0_Generic_Ethernet_10_100_PHY_rst_n_pin;
output fpga_0_Generic_Ethernet_10_100_PHY_tx_en_pin;
output [3:0] fpga_0_Generic_Ethernet_10_100_PHY_tx_data_pin;
output fpga_0_Generic_Ethernet_10_100_PHY_MDC_pin;
inout  fpga_0_Generic_Ethernet_10_100_PHY_MDIO_pin;
input fpga_0_RS232_RX_pin;
output fpga_0_RS232_TX_pin;




// camera
input cam_href;
input cam_pclk;
input [7:0]cam_data;
input cam_vsyn;
inout sda;
output scl;
output clk_camera;
output output_test_camera;

// sram
inout [31:0]data_sram;
output output_test_sram;
output [17:0]address_to_sram;

output adv;
output write_en_n;
output chip_en;
output output_en;
output [3:0]byte_en;
output clk_sram;
//ddr
output [1:0]fpga_0_DDR2_SDRAM_DDR2_CE_pin;
output fpga_0_DDR2_SDRAM_DDR2_WE_n_pin;
output [1:0]fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin;
output [1:0]fpga_0_DDR2_SDRAM_DDR2_CS_n_pin;
output [7:0]fpga_0_DDR2_SDRAM_DDR2_DM_pin;
inout [7:0]fpga_0_DDR2_SDRAM_DDR2_DQS_n_pin;
inout [7:0]fpga_0_DDR2_SDRAM_DDR2_DQS_pin;
inout [63:0]fpga_0_DDR2_SDRAM_DDR2_DQ_pin;
output [1:0]fpga_0_DDR2_SDRAM_DDR2_Clk_pin;
output [1:0]fpga_0_DDR2_SDRAM_DDR2_ODT_pin;
output fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin;
output [12:0]fpga_0_DDR2_SDRAM_DDR2_Addr_pin;
output fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin;
output [1:0]fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin;

/* wire */
wire clk_200;
wire clk_100;
wire test_tier1;
wire clk_dwt;
wire start_cpu;
wire [17:0] addra_all_1;
wire [2:0]  compression_ratio;
wire [31:0] douta_all_1;
wire [31:0] output_address;
wire [31:0] output_to_fpga_32;
wire [3:0]  write_en;
wire test_signals;
wire [1:0]fpga_0_DDR2_SDRAM_DDR2_CE_pin;
wire fpga_0_DDR2_SDRAM_DDR2_WE_n_pin;
wire [1:0]fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin;
wire [1:0]fpga_0_DDR2_SDRAM_DDR2_CS_n_pin;
wire [7:0]fpga_0_DDR2_SDRAM_DDR2_DM_pin;
wire [7:0]fpga_0_DDR2_SDRAM_DDR2_DQS_n_pin;
wire [1:0]fpga_0_DDR2_SDRAM_DDR2_Clk_pin;
wire [1:0]fpga_0_DDR2_SDRAM_DDR2_ODT_pin;
wire fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin;
wire [12:0]fpga_0_DDR2_SDRAM_DDR2_Addr_pin;
wire [7:0]fpga_0_DDR2_SDRAM_DDR2_DQS_pin;
wire [63:0]fpga_0_DDR2_SDRAM_DDR2_DQ_pin;
wire fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin;
wire [1:0]fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin;
wire [31:0]jpeg2000_output_bram_BRAM_Din_B_pin;
wire fpga_0_rst_1_sys_rst_pin;
wire fpga_0_Generic_Ethernet_10_100_PHY_MDC_pin;
wire fpga_0_clk_1_sys_clk_pin;
wire fpga_0_RS232_TX_pin;
wire fpga_0_Generic_Ethernet_10_100_PHY_MDIO_pin;
wire fpga_0_Generic_Ethernet_10_100_PHY_tx_en_pin;
wire [3:0]fpga_0_Generic_Ethernet_10_100_PHY_tx_data_pin;
wire fpga_0_Generic_Ethernet_10_100_PHY_rst_n_pin;
wire clk_camera;
wire rst_n;
wire cam_pclk;
wire output_en;
wire cam_href;
wire [3:0]byte_en;
wire sda;
wire output_test_sram;
wire start_button;
wire scl;
wire cam_vsyn;
wire clk_25;
wire write_en_n;
wire output_test_camera;
wire [17:0]address_from_dwt;
wire adv;
wire configure_over;
wire fpga_push_button;
wire [31:0]data_sram;
wire [7:0]cam_data;
wire [17:0]address_to_sram;
wire clk_sram;
wire chip_en;
wire jpeg_start_from_sram;
wire jpeg_working;
wire one_image_over;
wire rst_to_jpeg;
wire [31:0]data_to_jpeg;
/* reg */
reg start_to_jpeg;
reg [17:0]address_to_sram_reg;//for test
reg one_image_over_status;
reg one_image_over_reg;
reg sram_store_over;
reg start_cpu_reg1;
reg start_cpu_reg2;
reg cpu_process_over;
reg [1:0]start_reason;
reg start_cpu_posedge;
reg cpu_process_over_status;
reg [24:0]sram_time_counter;
reg [24:0]jpeg_time_cpunter;
reg [24:0]cpu_time_counter;

/* wire assignment */
assign fpga_0_rst_1_sys_rst_pin=rst;
assign fpga_0_clk_1_sys_clk_pin=clk_100;
assign clk_camera = clk_25;
assign start_button=fpga_push_button;
assign clk_sram = clk_100;
assign rst_n = ~rst;
assign address_from_dwt=addra_all_1;
assign douta_all_1= data_to_jpeg;
assign rst_to_jpeg = rst&&(!one_image_over_reg);
assign clk_dwt=clk_100;
assign test_signals=clk_200&&(&compression_ratio)&&test_tier1&&(&address_to_sram_reg)&&(&start_reason)&&(&sram_time_counter)&&(&cpu_time_counter)&&(&jpeg_time_cpunter);

always @(posedge clk_100 or negedge rst)
begin
  if (!rst) 
  begin
    cpu_time_counter<=0;
  end
  else if(start_to_jpeg)
  begin
    cpu_time_counter<=0;
  end
  else if(one_image_over_status)
  begin
    cpu_time_counter<=cpu_time_counter+1;
  end
end
always @(posedge clk_100 or negedge rst)
begin
  if (!rst) 
  begin
    jpeg_time_cpunter<=0;
  end
  else if(one_image_over_reg)
  begin
    jpeg_time_cpunter<=0;
  end
  else if(jpeg_working)
  begin
    jpeg_time_cpunter<=jpeg_time_cpunter+1;
  end
end
always @(posedge clk_100 or negedge rst)
begin
  if (!rst) 
  begin
    sram_time_counter<=0;
  end
  else if(one_image_over_reg)
  begin
    sram_time_counter<=0;
  end
  else if(!jpeg_working)
    sram_time_counter<=sram_time_counter+1;
end


always @(posedge clk_100 or negedge rst)
begin
  if (!rst) 
  begin 
    cpu_process_over_status<=0;
  end
  else if(start_to_jpeg)
  begin
    cpu_process_over_status<=0;
  end
  else if(cpu_process_over)
  begin
    cpu_process_over_status<=1;
  end
end
always @(posedge clk_100 or negedge rst)
begin
  if (!rst) 
  begin
    start_cpu_posedge<=0;
  end
  else if(start_cpu_reg1&&(!start_cpu_reg2))
  begin
    start_cpu_posedge<=1;
  end
  else start_cpu_posedge<=0;
end
always @(posedge clk_100 or negedge rst)
begin
  if (!rst) 
  begin
    sram_store_over<=0;
  end
  else if(start_to_jpeg)
  begin
    sram_store_over<=0;
  end
  else if(jpeg_start_from_sram)
    sram_store_over<=1;
end
always @(posedge clk_100 or negedge rst)
begin
  if (!rst) 
  begin
    cpu_process_over<=0;
  end
  else if(start_cpu_reg2&&(!start_cpu_reg1))
  begin
    cpu_process_over<=1;
  end
  else cpu_process_over<=0;
end
always @(posedge clk_100 or negedge rst)
begin
  if (!rst) 
  begin
    start_cpu_reg1<=0;
    start_cpu_reg2<=0;
  end
  else 
  begin
    start_cpu_reg1<=start_cpu;
    start_cpu_reg2<=start_cpu_reg1;
  end
end
always @(posedge clk_100 or negedge rst)//one_image_over_status being 1 means jpeg2000 is over but cpu is still processing the last tile
begin
  if (!rst) 
  begin
    one_image_over_status<=0;
  end
  else if(start_to_jpeg)
  begin
    one_image_over_status<=0;
  end
  else if(one_image_over)
    one_image_over_status<=1;
end
always@(posedge clk_100 or negedge rst)
begin
  if(!rst)
  begin
    start_to_jpeg<=0;
    start_reason<=0;
  end
  else if((!one_image_over_status)&&jpeg_working&&start_cpu_posedge)//start between tiles 
  begin
    start_to_jpeg<=1;
    start_reason<=1;
  end
  else if((!one_image_over_status)&&(!jpeg_working)&&jpeg_start_from_sram)//the first image or cpu processing the last tile over while sram store is not over 
  begin
    start_to_jpeg<=1;
    start_reason<=2;
  end
  else if(one_image_over_status&&cpu_process_over_status&&sram_store_over)//sram store over but cpu processing is not
  begin
    start_to_jpeg<=1;//
    start_reason<=3;
  end
  else start_to_jpeg<=0;
end

always @(posedge clk_100 or negedge rst)
begin
  if (!rst) 
  begin
    one_image_over_reg<=0;
  end
  else  
  begin
    one_image_over_reg<=one_image_over;
  end
end
always @(posedge clk_100 or negedge rst)
begin
  if (!rst) 
  begin
    address_to_sram_reg<=0;
  end
  else  
  begin
    address_to_sram_reg<=address_to_sram;
  end
end

    sram_control sram_control(/*autoinst*/
      .data_sram(data_sram[31:0]),
      .address_to_sram(address_to_sram[17:0]),
      .adv(adv),
      .write_en_n(write_en_n),
      .chip_en(chip_en),
      .output_en(output_en),
      .byte_en(byte_en[3:0]),
      .output_test_sram(output_test_sram),
      .jpeg_start_from_sram(jpeg_start_from_sram),
      .data_to_jpeg(data_to_jpeg[31:0]),
      .jpeg_working(jpeg_working),
      .clk_100(clk_100),
      .rst(rst_to_jpeg),
      .cam_data(cam_data[7:0]),
      .cam_pclk(cam_pclk),
      .cam_href(cam_href),
      .cam_vsyn(cam_vsyn),
      .configure_over(configure_over),
      .address_from_dwt(address_from_dwt[17:0]));

    camera_control camera_control(/*autoinst*/
          .sda(sda),
          .scl(scl),
          .output_test_camera(output_test_camera),
          .configure_over(configure_over),
          .clk_25(clk_25),
          .rst(rst),
          .cam_href(cam_href),
          .cam_pclk(cam_pclk),
          .cam_vsyn(cam_vsyn),
          .start_button(start_button));

	dll dll
   (// Clock in ports
    .CLKIN1_IN            (clk_fpga),      
    // Clock out ports
    .CLKOUT0_OUT           (clk_200),    
    .CLKOUT1_OUT           (clk_100),
    .CLKOUT2_OUT   (clk_25)
	 );    
	 
   jpeg2000_top  jpeg2000_top(/*autoinst*/
    .clk_dwt                    (clk_dwt                        ),
    .rst                        (rst_to_jpeg                            ),
    .start_cpu                  (start_to_jpeg),
    .douta_all_1                (douta_all_1[31:0]              ),
    .compression_ratio          (compression_ratio[2:0]         ),
    .write_en                   (write_en[3:0]                  ),
    .output_address             (output_address[31:0]           ),
    .addra_all_1                (addra_all_1[17:0]              ),
    .output_to_fpga_32          (output_to_fpga_32[31:0]        ),
    .test_tier1(test_tier1),
    .one_image_over(one_image_over)
);

(* BOX_TYPE = "user_black_box" *)
cpu_with_ethernet cpu_with_ethernet (
    .fpga_0_RS232_RX_pin(fpga_0_RS232_RX_pin), 
    .fpga_0_RS232_TX_pin(fpga_0_RS232_TX_pin), 
    .fpga_0_LEDS_GPIO_IO_O_pin(start_cpu), 
    .fpga_0_Push_Buttons_GPIO_IO_I_pin(fpga_push_button), 
    .fpga_0_Generic_Ethernet_10_100_PHY_tx_clk_pin(fpga_0_Generic_Ethernet_10_100_PHY_tx_clk_pin), 
    .fpga_0_Generic_Ethernet_10_100_PHY_rx_clk_pin(fpga_0_Generic_Ethernet_10_100_PHY_rx_clk_pin), 
    .fpga_0_Generic_Ethernet_10_100_PHY_crs_pin(fpga_0_Generic_Ethernet_10_100_PHY_crs_pin), 
    .fpga_0_Generic_Ethernet_10_100_PHY_dv_pin(fpga_0_Generic_Ethernet_10_100_PHY_dv_pin), 
    .fpga_0_Generic_Ethernet_10_100_PHY_rx_data_pin(fpga_0_Generic_Ethernet_10_100_PHY_rx_data_pin), 
    .fpga_0_Generic_Ethernet_10_100_PHY_col_pin(fpga_0_Generic_Ethernet_10_100_PHY_col_pin), 
    .fpga_0_Generic_Ethernet_10_100_PHY_rx_er_pin(fpga_0_Generic_Ethernet_10_100_PHY_rx_er_pin), 
    .fpga_0_Generic_Ethernet_10_100_PHY_rst_n_pin(fpga_0_Generic_Ethernet_10_100_PHY_rst_n_pin), 
    .fpga_0_Generic_Ethernet_10_100_PHY_tx_en_pin(fpga_0_Generic_Ethernet_10_100_PHY_tx_en_pin), 
    .fpga_0_Generic_Ethernet_10_100_PHY_tx_data_pin(fpga_0_Generic_Ethernet_10_100_PHY_tx_data_pin), 
    .fpga_0_Generic_Ethernet_10_100_PHY_MDC_pin(fpga_0_Generic_Ethernet_10_100_PHY_MDC_pin), 
    .fpga_0_Generic_Ethernet_10_100_PHY_MDIO_pin(fpga_0_Generic_Ethernet_10_100_PHY_MDIO_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_Clk_pin(fpga_0_DDR2_SDRAM_DDR2_Clk_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin(fpga_0_DDR2_SDRAM_DDR2_Clk_n_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_CE_pin(fpga_0_DDR2_SDRAM_DDR2_CE_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_CS_n_pin(fpga_0_DDR2_SDRAM_DDR2_CS_n_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_ODT_pin(fpga_0_DDR2_SDRAM_DDR2_ODT_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin(fpga_0_DDR2_SDRAM_DDR2_RAS_n_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin(fpga_0_DDR2_SDRAM_DDR2_CAS_n_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_WE_n_pin(fpga_0_DDR2_SDRAM_DDR2_WE_n_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin(fpga_0_DDR2_SDRAM_DDR2_BankAddr_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_Addr_pin(fpga_0_DDR2_SDRAM_DDR2_Addr_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_DQ_pin(fpga_0_DDR2_SDRAM_DDR2_DQ_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_DM_pin(fpga_0_DDR2_SDRAM_DDR2_DM_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_DQS_pin(fpga_0_DDR2_SDRAM_DDR2_DQS_pin), 
    .fpga_0_DDR2_SDRAM_DDR2_DQS_n_pin(fpga_0_DDR2_SDRAM_DDR2_DQS_n_pin), 
    .fpga_0_clk_1_sys_clk_pin(fpga_0_clk_1_sys_clk_pin), 
    .fpga_0_rst_1_sys_rst_pin(fpga_0_rst_1_sys_rst_pin), 
    .jpeg2000_output_bram_BRAM_Rst_B_pin(1'b0), 
    .jpeg2000_output_bram_BRAM_Clk_B_pin(clk_100), 
    .jpeg2000_output_bram_BRAM_EN_B_pin(1'b1), 
    .jpeg2000_output_bram_BRAM_WEN_B_pin(write_en), 
    .jpeg2000_output_bram_BRAM_Addr_B_pin(output_address), 
    .jpeg2000_output_bram_BRAM_Din_B_pin(jpeg2000_output_bram_BRAM_Din_B_pin), 
    .jpeg2000_output_bram_BRAM_Dout_B_pin(output_to_fpga_32)
    );
endmodule
