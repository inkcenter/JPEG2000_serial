`timescale 1ns/10ps
module col_filter(//output 
                  col_hdata,
				  col_ldata,
				  col_out_vld,
				  //input
				  odd_data,
				  even_data,
				  start_cf,
				  level,
				  dwt_work,
				  clk_cf,
				  rst,
				rst_syn		);

    output [15:0] col_hdata;
	output [15:0] col_ldata;
	output col_out_vld;
	input  [15:0] odd_data;
	input  [15:0] even_data;
	input  [2:0] level;
	input  start_cf;
	input  clk_cf;
	input  rst;
	input rst_syn;
	input dwt_work;

	
	
	parameter a = 14'b10101111010011;
	parameter b = 18'b011001110011001101;
	parameter c = 19'b1010101001111100111;
	parameter d = 16'b0111000110111000;
	parameter e = 10'b0101110110;
	parameter f = 9'b011011011;
	
	parameter idle = 2'b00;
	parameter calc_fr = 2'b01;
	parameter calc_sr = 2'b10;
	parameter calc_other = 2'b11;
	
	reg [1:0] fsm_cf;
	reg [1:0] fsm_cf_n;
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    fsm_cf <= 2'b0;
		end
		else if(rst_syn)begin
			fsm_cf <= 2'b0;
		end
		else if(dwt_work == 1'b1) begin
		    fsm_cf <= fsm_cf_n;
		end
	end
	
	wire srst = (fsm_cf == idle);
	
	wire data_out1_uvalid = (fsm_cf == calc_fr);
	
	wire data_out2_uvalid = (fsm_cf == calc_sr);
	
	wire rcv_data_vld = ((fsm_cf == calc_fr)||(fsm_cf == calc_sr)||(fsm_cf == calc_other));
	
	reg [7:0] prow_cnt;
	reg  prow_cnt_sel;
	
	always@(*) begin
	    case(level) 
		    3'b000: begin
			    prow_cnt_sel = (prow_cnt == 128);
			end
			3'b001: begin
			    prow_cnt_sel = (prow_cnt == 64);
			end
			3'b010: begin
			    prow_cnt_sel = (prow_cnt == 32);
			end
			3'b011: begin
			    prow_cnt_sel = (prow_cnt == 16);
			end
			3'b100: begin
			    prow_cnt_sel = (prow_cnt == 8);
			end
			default: begin
			    prow_cnt_sel = 0;
			end
		endcase
	end

	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    prow_cnt <= 10'b0;
		end
		else if(rst_syn)begin
			prow_cnt <= 10'b0;
		end
		else if(srst == 1'b1) begin
		    prow_cnt <= 10'b0;
		end
		else if(dwt_work == 1'b1) begin
		               if(rcv_data_vld == 1'b1) begin
		                  if(prow_cnt_sel == 1'b1) begin            
			                prow_cnt <= 1;
			              end
			              else begin
		                    prow_cnt <= prow_cnt + 1;
		                  end
		               end
	    end
	end
	reg [7:0] arow_cnt;
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    arow_cnt <= 10'b0;
		end
		else if(rst_syn)begin
			arow_cnt <= 10'b0;
		end
		else if(srst == 1'b1) begin
		    arow_cnt <= 10'b0;
		end
		else if(dwt_work == 1'b1) begin
		             if(prow_cnt_sel == 1'b1) begin
		                arow_cnt <= arow_cnt + 1;
		             end
	    end
	end
	wire calc_fr_over = ((arow_cnt == 1)&&(prow_cnt == 1));
	
	wire calc_sr_over = ((arow_cnt == 2)&&(prow_cnt == 3)); 
	
	reg [15:0] odd_data_reg;
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    odd_data_reg <= 16'b0;
		end
		else if(rst_syn)begin
			odd_data_reg <= 16'b0;
		end
		else if(srst == 1'b1) begin
		    odd_data_reg <= 16'b0;
		end
		else if(dwt_work == 1'b1) begin
         		if(rcv_data_vld == 1'b1) begin
					      odd_data_reg <= odd_data;
		        end
		end
	end

	reg [15:0] even_data_reg;
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    even_data_reg <= 16'b0;
		end
		else if(rst_syn)begin
			even_data_reg <= 16'b0;
		end
		else if(srst == 1'b1) begin
		    even_data_reg <= 16'b0;
		end
		else if(dwt_work == 1'b1) begin
		        if(rcv_data_vld == 1'b1) begin
		                  even_data_reg <= even_data;
                end
		end
	end
	
	reg [15:0] stage2_reg1;
	wire [15:0] stage2_reg1_n;
	reg [19:0] stage2_reg2;
	wire [19:0] stage2_reg2_n;
	reg [15:0] stage2_reg3;
	
	wire [29:0] mul_out1;
    wire [33:0] mul_out2;
    assign mul_out1 = $signed(odd_data_reg)*$signed(a);
    assign mul_out2 = $signed(even_data_reg)*$signed(b);

    assign stage2_reg1_n = mul_out1[28:13];
    assign stage2_reg2_n = mul_out2[32:13];	
	
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    stage2_reg1 <= 16'b0;
		end
		else if(rst_syn)begin
			stage2_reg1 <= 16'b0;
		end
		else if(dwt_work == 1'b1) begin
		    stage2_reg1 <= stage2_reg1_n;
		end
	end
	
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    stage2_reg2 <= 16'b0;
		end
		else if(rst_syn)begin
			stage2_reg2 <= 16'b0;
		end
		else if(dwt_work == 1'b1) begin
		    stage2_reg2 <= stage2_reg2_n;
		end
	end
	
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    stage2_reg3 <= 16'b0;
		end
		else if(rst_syn)begin
			stage2_reg3 <= 16'b0;
		end
		else if(dwt_work == 1'b1) begin
		    stage2_reg3 <= even_data_reg;
		end
	end
	
	wire [15:0] ram1_idata;
	wire [15:0] ram1_odata;
	wire [19:0] ram2_idata;
	wire [19:0] ram2_odata;
	wire [8:0] cf_raddr1;
	wire [8:0] cf_waddr1;
	wire [8:0] cf_raddr2;
	wire [8:0] cf_waddr2;

	

	reg [8:0] cf_raddr1_reg;
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    cf_raddr1_reg <= 9'b0;
		end 
		else if(rst_syn)begin
			cf_raddr1_reg <= 9'b0;
		end
		else if(srst == 1'b1) begin
		    cf_raddr1_reg <= 9'b0;
		end
		else if(dwt_work == 1'b1) begin
		        if(prow_cnt > 0) begin
		           case(level)
		              3'b000: begin
		                        if(cf_raddr1_reg == 127) begin
								 cf_raddr1_reg <= 0;
								end
								else begin
								 cf_raddr1_reg <= cf_raddr1_reg + 1;
								end
		              end
		              3'b001: begin
		                       if(cf_raddr1_reg == 63) begin
		                        cf_raddr1_reg <= 0;
		                       end
		                       else begin
		                        cf_raddr1_reg <= cf_raddr1_reg + 1;
		                       end
		              end
		              3'b010: begin
		                  if(cf_raddr1_reg == 31) begin
		                      cf_raddr1_reg <= 0;
		                  end
		                  else begin
		                      cf_raddr1_reg <= cf_raddr1_reg + 1;
		                  end
		              end
		              3'b011: begin
		                  if(cf_raddr1_reg == 15) begin
		                      cf_raddr1_reg <= 0;
		                  end
		                  else begin
		                      cf_raddr1_reg <= cf_raddr1_reg + 1;
		                  end
		              end
		              3'b100: begin
		                  if(cf_raddr1_reg == 7) begin
		                      cf_raddr1_reg <= 0;
		                  end
		                  else begin
		                      cf_raddr1_reg <= cf_raddr1_reg + 1;
		                  end
		              end
		            endcase
		        end
		end
	end
	
	reg [8:0] cf_waddr1_reg;
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    cf_waddr1_reg <= 9'b0;
		end
		else if(rst_syn)begin
			 cf_waddr1_reg <= 9'b0;
		end
		else if(srst == 1'b1) begin
		    cf_waddr1_reg <= 9'b0;
		end 
		else if(dwt_work == 1'b1) begin
		    cf_waddr1_reg <= cf_raddr1_reg;
		end
	end
	
	assign cf_raddr1 = cf_raddr1_reg;
	assign cf_waddr1 = cf_waddr1_reg;
	assign cf_raddr2 = cf_raddr1_reg;
	assign cf_waddr2 = cf_waddr1_reg;
	
	reg extend_sel;
	
	always @(*) begin
	  case(level)
	    3'b000:   begin
                   extend_sel=(((arow_cnt==64)&&(prow_cnt>1))||((arow_cnt==65)&&(prow_cnt==1)));
                  end
        3'b001:   begin
                   extend_sel=(((arow_cnt==32)&&(prow_cnt>1))||((arow_cnt==33)&&(prow_cnt==1)));
                  end
		3'b010:   begin
                   extend_sel=(((arow_cnt==16)&&(prow_cnt>1))||((arow_cnt==17)&&(prow_cnt==1)));
                  end	
        3'b011:   begin
                   extend_sel=(((arow_cnt==8)&&(prow_cnt>1))||((arow_cnt==9)&&(prow_cnt==1)));
                  end
        3'b100:   begin
                   extend_sel=(((arow_cnt==4)&&(prow_cnt>1))||((arow_cnt==5)&&(prow_cnt==1)));
                  end	
       default:   begin
                   extend_sel=0;
                  end
      endcase
    end	  
	
	wire [15:0] ram1_odata_v;
	wire [19:0] ram2_odata_v;
	

	assign ram1_odata_v=ram1_odata;
	assign ram2_odata_v=ram2_odata;
	
	wire  ram2_idata_sel = ((arow_cnt == 0)||((arow_cnt == 1)&&(prow_cnt == 1)));		//// first delay
	
	assign ram1_idata = (extend_sel==1'b1)? ram1_odata: (stage2_reg3 + stage2_reg1);
	assign ram2_idata = (extend_sel==1'b1)? ram2_odata: ((ram2_idata_sel == 1'b1)?  (stage2_reg2 + {{4{stage2_reg1[15]}},stage2_reg1}):(stage2_reg2 + {{4{ram1_odata_v[15]}},ram1_odata_v}));
	
	reg cf_wren1_reg;
    always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    cf_wren1_reg <= 1'b0;
		end
		else if(rst_syn)begin
			cf_wren1_reg <= 1'b0;
		end
		else if(srst == 1'b1) begin
		    cf_wren1_reg <= 1'b0;
		end
		else if(dwt_work == 1'b1) begin
               		if(prow_cnt > 0) begin
		              cf_wren1_reg <= 1'b1;
		            end
		end
    end	
	
	wire cf_wren1 = cf_wren1_reg;
	wire cf_wren2 = cf_wren1_reg;
	
	
	dual_sram u_sram1(
	.clka (clk_cf),
	.wea (cf_wren1),
	.addra (cf_waddr1),
	.dina (ram1_idata),
	.clkb (clk_cf),
	.addrb (cf_raddr1),
	.doutb (ram1_odata));
	
	
	dual_sram20 u_sram2(
	.clka (clk_cf),
	.wea (cf_wren2),
	.addra (cf_waddr2),
	.dina (ram2_idata),
	.clkb (clk_cf),
	.addrb (cf_raddr2),
	.doutb(ram2_odata));
	

	
	wire [15:0] stage3_reg1_n;
	assign stage3_reg1_n = stage2_reg3 + ram1_odata_v;
	wire [16:0] stage3_reg2_n;
	
	wire boundary_cal;
	
	assign boundary_cal=(((arow_cnt==1)&&(prow_cnt>1))||((arow_cnt==2)&&(prow_cnt==1)));
	
	assign stage3_reg2_n = (boundary_cal==1)? ({{3{stage2_reg3[15]}},stage2_reg3,1'b0}+{{4{ram1_odata_v[15]}},ram1_odata_v} + ram2_odata_v):({{4{stage2_reg3[15]}},stage2_reg3} + {{4{ram1_odata_v[15]}},ram1_odata_v} + ram2_odata_v);
	
	reg [15:0] stage3_reg1;
	reg [16:0] stage3_reg2;
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    stage3_reg1 <= 16'b0;
		end
		else if(rst_syn)begin
			stage3_reg1 <= 16'b0;
		end
		else if(srst == 1'b1) begin
		    stage3_reg1 <= 16'b0;
		end
		else if(dwt_work == 1'b1) begin
		        if(data_out1_uvalid == 1'b1) begin
		           stage3_reg1 <= 16'b0;
		        end
		        else begin
		           stage3_reg1 <= stage3_reg1_n;
		        end
	    end
	end
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    stage3_reg2 <= 17'b0;
		end
		else if(rst_syn)begin
			stage3_reg2 <= 17'b0;
		end
		else if(srst == 1'b1) begin
		    stage3_reg2 <= 17'b0;
		end
		else if(dwt_work == 1'b1) begin
		        if(data_out1_uvalid == 1'b1) begin
		          stage3_reg2 <= 17'b0;
		        end
		        else begin
		          stage3_reg2 <= stage3_reg2_n;
		        end
	    end
	end
	
	reg [20:0] stage4_reg1;
	reg [18:0] stage4_reg2;
	reg [16:0] stage4_reg3;
	
	wire [20:0] stage4_reg1_n;
	wire [18:0] stage4_reg2_n;
	
	wire [34:0] mul_out3;
	wire [31:0] mul_out4;
	
	assign mul_out3 = $signed(stage3_reg1)*$signed(c);
	assign mul_out4 = $signed(stage3_reg2)*$signed(d);
	
	assign stage4_reg1_n = mul_out3[33:13];
	assign stage4_reg2_n = mul_out4[31:13];
	
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    stage4_reg1 <= 21'b0;
		end
		else if(rst_syn)begin
			 stage4_reg1 <= 21'b0;
		end
		else if(dwt_work == 1'b1) begin
		    stage4_reg1 <= stage4_reg1_n;
		end
	end 
	
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    stage4_reg2 <= 19'b0;
		end
		else if(rst_syn)begin
			stage4_reg2 <= 19'b0;
		end
		else if(dwt_work == 1'b1) begin
		    stage4_reg2 <= stage4_reg2_n;
		end
	end 
	
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    stage4_reg3 <= 17'b0;
		end
		else if(rst_syn)begin
			 stage4_reg3 <= 17'b0;
		end
		else if(dwt_work == 1'b1) begin
		    stage4_reg3 <= stage3_reg2;
		end
	end 
	
	wire [20:0] ram3_idata;
	wire [20:0] ram3_odata;
	wire [17:0] ram4_idata;
	wire [17:0] ram4_odata;
	
	wire [8:0] cf_raddr3;
	wire [8:0] cf_waddr3;
	wire [8:0] cf_raddr4;
	wire [8:0] cf_waddr4;
	

	
	reg [8:0] cf_raddr3_reg;
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    cf_raddr3_reg <= 9'b0;
		end
		else if(rst_syn)begin
			cf_raddr3_reg <= 9'b0;
		end
		else if(srst == 1'b1) begin
		    cf_raddr3_reg <= 9'b0;
		end
		else if(dwt_work == 1'b1) begin
		        if((arow_cnt > 1)||((arow_cnt == 1)&&(prow_cnt > 2))) begin
		           case(level)
		               3'b000: begin
					             if(cf_raddr3_reg == 127) begin
								   cf_raddr3_reg <=0;
								 end
								 else begin
		                           cf_raddr3_reg <= cf_raddr3_reg + 1;
								 end
		               end
		               3'b001: begin
		                   if(cf_raddr3_reg == 63) begin
		                       cf_raddr3_reg <= 0;
		                   end
		                   else begin
		                       cf_raddr3_reg <= cf_raddr3_reg + 1;
		                   end
		               end
		               3'b010: begin
		                   if(cf_raddr3_reg == 31) begin
		                       cf_raddr3_reg <= 0;
		                   end
		                   else begin
		                       cf_raddr3_reg <= cf_raddr3_reg + 1;
		                   end
		               end
		               3'b011: begin
		                   if(cf_raddr3_reg == 15) begin
		                       cf_raddr3_reg <= 0;
		                   end
		                   else begin
		                       cf_raddr3_reg <= cf_raddr3_reg + 1;
		                   end
		               end
		               3'b100: begin
		                   if(cf_raddr3_reg == 7) begin
		                       cf_raddr3_reg <= 0;
		                   end
		                   else begin
		                       cf_raddr3_reg <= cf_raddr3_reg + 1;
		                   end
		               end
		           endcase
		        end
	    end
	end
	
	reg [8:0] cf_waddr3_reg;
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    cf_waddr3_reg <= 9'b0;
		end
		else if(rst_syn)begin
			 cf_waddr3_reg <= 9'b0;
		end
		else if(srst == 1'b1) begin
		    cf_waddr3_reg <= 9'b0;
		end
		else if(dwt_work == 1'b1) begin
		    cf_waddr3_reg <= cf_raddr3_reg;
		end
	end
	
	assign cf_raddr3 = cf_raddr3_reg;
	assign cf_waddr3 = cf_waddr3_reg;
	assign cf_raddr4 = cf_raddr3_reg;
	assign cf_waddr4 = cf_waddr3_reg;
	
	wire [20:0] ram3_odata_v;
	wire [17:0] ram4_odata_v;
		assign ram3_odata_v= ram3_odata;
		assign ram4_odata_v= ram4_odata;

	wire ram4_idata_sel = ((arow_cnt < 2)||((arow_cnt == 2)&&(prow_cnt < 4)));
	
	assign ram3_idata = stage4_reg1 + {{4{stage4_reg3[16]}},stage4_reg3};
	assign ram4_idata = (ram4_idata_sel == 1'b1)?  ({{2{stage4_reg2[18]}},stage4_reg2} + stage4_reg1):({{2{stage4_reg2[18]}},stage4_reg2} + ram3_odata_v);
	
	wire cf_wren3 = cf_wren1_reg;
	wire cf_wren4 = cf_wren1_reg;
	
	
	dual_sram21 u_sram3(
	.clka (clk_cf),
	.wea (cf_wren3),
	.addra (cf_waddr3),
	.dina (ram3_idata),
	.clkb (clk_cf),
	.addrb (cf_raddr3),
	.doutb (ram3_odata));
	
	
	dual_sram18 u_sram4(
	.clka (clk_cf),
	.wea (cf_wren4),
	.addra (cf_waddr4),
	.dina (ram4_idata),
	.clkb (clk_cf),
	.addrb (cf_raddr4),
	.doutb (ram4_odata));
	
	
	
	wire [20:0] stage5_reg1_n;
	wire [20:0] stage5_reg2_n;
	
	wire boundary_cal_s;
	assign boundary_cal_s = (((arow_cnt == 2)&&(prow_cnt >3))||((arow_cnt==3)&&(prow_cnt<4)));
	
	assign stage5_reg1_n = (boundary_cal_s==1)? ({{3{stage4_reg3[16]}},stage4_reg3,1'b0} + ram3_odata_v + {{3{ram4_odata_v[17]}},ram4_odata_v}) :({{4{stage4_reg3[16]}},stage4_reg3} + ram3_odata_v + {{3{ram4_odata_v[17]}},ram4_odata_v});
	assign stage5_reg2_n = {{4{stage4_reg3[16]}},stage4_reg3} + ram3_odata_v;
	
	reg [20:0] stage5_reg1;
	reg [20:0] stage5_reg2;
	
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    stage5_reg1 <= 16'b0;
		end
		else if(rst_syn)begin
			stage5_reg1 <= 16'b0;
		end
		else if(srst == 1'b1) begin
		    stage5_reg1 <= 16'b0;
		end
		else if(dwt_work == 1'b1) begin
		        if(data_out2_uvalid == 1'b1) begin
		           stage5_reg1 <= 16'b0;
		        end
		        else begin
		           stage5_reg1 <= stage5_reg1_n;
		        end
	    end
	end
	
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    stage5_reg2 <= 16'b0;
		end
		else if(rst_syn)begin
			stage5_reg2 <= 16'b0;
		end
		else if(srst == 1'b1) begin
		    stage5_reg2 <= 16'b0;
		end
		else if(dwt_work == 1'b1) begin
		       if(data_out2_uvalid == 1'b1) begin
		         stage5_reg2 <= 16'b0;
		       end
		       else begin
		         stage5_reg2 <= stage5_reg2_n;
		       end
	    end
	end
	
	reg [15:0] col_ldata;
	reg [15:0] col_hdata;
	
	wire [15:0] col_ldata_n;
	wire [15:0] col_hdata_n;
	
	wire [28:0] mul_out5;
	wire [29:0] mul_out6;
	
	assign mul_out5 = $signed(stage5_reg1)*$signed(f);
	assign mul_out6 = $signed(stage5_reg2)*$signed(e);
	
	assign col_ldata_n = {mul_out5[28:13]};
	assign col_hdata_n = {mul_out6[28:13]};
	
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    col_ldata <= 16'b0;
		end
		else if(rst_syn)begin
			col_ldata <= 16'b0;
		end
		else if(srst == 1'b1) begin
		    col_ldata <= 16'b0;
		end
		else if(dwt_work == 1'b1) begin
		    col_ldata <= col_ldata_n;
		end
	end
	
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    col_hdata <= 16'b0;
		end
		else if(rst_syn)begin
			col_hdata <= 16'b0;
		end
		else if(srst == 1'b1) begin
		    col_hdata <= 16'b0;
		end
		else if(dwt_work == 1'b1) begin
		    col_hdata <= col_hdata_n;
		end
	end
	
	reg cf_over;
	always@(*) begin
	    case(level)
            3'b000: begin
			    cf_over = ((arow_cnt == 66)&&(prow_cnt == 5));
            end
			3'b001: begin
			    cf_over = ((arow_cnt == 34)&&(prow_cnt == 5));
			end
			3'b010: begin
			    cf_over = ((arow_cnt == 18)&&(prow_cnt == 5));
			end
			3'b011: begin
			    cf_over = ((arow_cnt == 10)&&(prow_cnt == 5));
			end
			3'b100: begin
			    cf_over = ((arow_cnt == 6)&&(prow_cnt == 5));
			end
            default: begin
			    cf_over = 0;
            end			
		endcase
	end
	
	reg col_out_vld;
	always@(posedge clk_cf or negedge rst) begin
	    if(!rst) begin
		    col_out_vld <= 1'b0;
		end
		else if(rst_syn)begin
			col_out_vld <= 1'b0;
		end
		else if(srst == 1'b1) begin
		    col_out_vld <= 1'b0;
		end
		else if(dwt_work == 1'b1) begin
             		if((arow_cnt == 2)&&(prow_cnt == 5)) begin
		              col_out_vld <= 1'b1;
		            end
		            else if(cf_over == 1'b1) begin
		              col_out_vld <= 1'b0;
		            end
	    end
	end
	
	always@(*) begin
	    fsm_cf_n = fsm_cf;
		case(fsm_cf) 
		    idle: begin
			    if(start_cf == 1'b1) begin
				    fsm_cf_n = calc_fr;
				end
				else begin
				    fsm_cf_n = idle;
				end
			end
			calc_fr: begin
			    if(calc_fr_over == 1'b1) begin
				    fsm_cf_n = calc_sr;
				end
				else begin
				    fsm_cf_n = calc_fr;
				end
			end
			calc_sr: begin
			    if(calc_sr_over == 1'b1) begin
				    fsm_cf_n = calc_other;
				end
				else begin
				    fsm_cf_n = calc_sr;
				end
			end
			calc_other: begin
			    if(cf_over == 1'b1) begin
				    fsm_cf_n = idle;
				end
				else begin
				    fsm_cf_n = calc_other;
				end
			end	
			default: begin
			    fsm_cf_n = idle;
			end
		endcase
	end
	
	
endmodule 
