`timescale 1ns/10ps
module flu(//output
           row_ldata,
		   row_hdata,
		   row_out_vld,
		    rf_over,		   
		   //input
		   odd_data,
		   even_data,
		   start_cf,
		   level,
		   dwt_work,

		   clk_flu,
		   rst,
		   rst_syn);
	
	output [15:0] row_ldata;
	output [15:0] row_hdata;
	output row_out_vld;
	output rf_over;
	
	input [15:0] odd_data;
	input [15:0] even_data;
	input start_cf;
	input [2:0] level;
	input dwt_work;
	input clk_flu;
	input rst;
	input rst_syn;
    
	wire [15:0] col_hdata;
	wire [15:0] col_ldata;
	wire col_out_vld;
	
	wire [15:0] atrcol_out1;
	wire [15:0] atrcol_out2;

	wire rf_over;
	col_filter u_col_filter(//output 
                  .col_hdata  (col_hdata),
				  .col_ldata  (col_ldata),
				  .col_out_vld  (col_out_vld),
				  
				  //input
				  .odd_data  (odd_data),
				  .even_data  (even_data),
				  .start_cf  (start_cf),
				  .level  (level),
				  .dwt_work  (dwt_work),
				  .clk_cf  (clk_flu),
				  .rst  (rst),
				  .rst_syn(rst_syn));
				  
	transpose u_transpose( //output
                  .atrcol_out1  (atrcol_out1),
                  .atrcol_out2  (atrcol_out2),				  
                  //input
				  .col_ldata  (col_ldata),
				  .col_hdata  (col_hdata),
				  .col_out_vld  (col_out_vld),
				  .dwt_work  (dwt_work),
				  .clk_tr  (clk_flu),
				  .rst  (rst),
				  .rst_syn(rst_syn));
				  
	row_filter u_row_filter(//output
                  .row_ldata  (row_ldata),
				  .row_hdata  (row_hdata),
				  .row_out_vld  (row_out_vld),
				  
                  //input 
				  .atrcol_out1  (atrcol_out1),
				  .atrcol_out2  (atrcol_out2),
				  .col_out_vld  (col_out_vld),
				  .level  (level),
				  .dwt_work  (dwt_work),
				  .rf_over(rf_over),										
				  .clk_rf  (clk_flu),
				  .rst  (rst),
				  .rst_syn(rst_syn));
	
	
endmodule 
