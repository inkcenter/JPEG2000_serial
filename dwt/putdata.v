module putdata(/*autoarg*/
    //input
    clk, rst, start, rst_syn, 

    //output
    dina_o1, dina_o2, addra_o1_w, addra_o2_w, 
    ena_o1_w, ena_o2_w, wea_o1_w, wea_o2_w
);
			   
	output [16:0] dina_o1;
	output [16:0] dina_o2;
	output [13:0] addra_o1_w;
    output [13:0] addra_o2_w;
    output ena_o1_w;
    output ena_o2_w;
	output wea_o1_w;
	output wea_o2_w;

    input clk;
    input rst;
    input start;
	input rst_syn;

	integer k;
	integer i;
	integer cnt,
		cnt_1,
		cnt_2,
		cnt_3,
		cnt_4,
		cnt_5,
		cnt_6,
		cnt_7,
		cnt_8,
		cnt_9,
		cnt_10,
		cnt_11,
		cnt_12,
		cnt_13,
		cnt_14,
		cnt_15;
	integer fp_r_1,
		fp_r_2 ,
		fp_r_3 ,
		fp_r_4 ,
		fp_r_5 ,
		fp_r_6 ,
		fp_r_7 ,
		fp_r_8 ,
		fp_r_9 ,
		fp_r_10,
		fp_r_11,
		fp_r_12,
		fp_r_13,
		fp_r_14,
		fp_r_15,
		fp_r_16,
		fp_r_17,
		fp_r_18,
		fp_r_19,
		fp_r_20,
		fp_r_21,
		fp_r_22,
		fp_r_23,
		fp_r_24,
		fp_r_25,
		fp_r_26,
		fp_r_27,
		fp_r_28,
		fp_r_29,
		fp_r_30,
		fp_r_31,
		fp_r_32,
		fp_r_33,
		fp_r_34,
		fp_r_35,
		fp_r_36,
		fp_r_37,
		fp_r_38,
		fp_r_39,
		fp_r_40,
		fp_r_41,
		fp_r_42,
		fp_r_43,
		fp_r_44,
		fp_r_45,
		fp_r_46,
		fp_r_47,
		fp_r_48;
	reg [5:0]lion_counter;

	reg [15:0] address;
	reg[7:0]mem[49151:0];    //// 49152 = 128 * 128 * 3
	always@(posedge rst_syn)
	begin
	    lion_counter<=lion_counter+1;
	end
	
    initial  
	begin
		//fp_r_1  = $fopen("lena_yuv_128.txt", "r");
		//fp_r_2  = $fopen("lena_yuv_128.txt", "r");
		//fp_r_3  = $fopen("lena_yuv_128.txt", "r");
		//fp_r_4  = $fopen("lena_yuv_128.txt", "r");
		//fp_r_5  = $fopen("lena_yuv_128.txt", "r");
		//fp_r_6  = $fopen("lena_yuv_128.txt", "r");
		//fp_r_7  = $fopen("lena_yuv_128.txt", "r");
		//fp_r_8  = $fopen("lena_yuv_128.txt", "r");
		//fp_r_9  = $fopen("lena_yuv_128.txt", "r");
		//fp_r_10 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_11 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_12 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_13 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_14 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_15 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_16 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_17 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_18 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_19 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_20 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_21 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_22 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_23 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_24 = $fopen("lena_yuv_128.txt", "r");
		//fp_r_25 = $fopen("lena_yuv_128.txt", "r");	
		
		//fp_r_1  = $fopen("./elephants/Elephant11.TXT", "r");
		//fp_r_2  = $fopen("./elephants/Elephant12.TXT", "r");
		//fp_r_3  = $fopen("./elephants/Elephant13.TXT", "r");
		//fp_r_4  = $fopen("./elephants/Elephant14.TXT", "r");
		//fp_r_5  = $fopen("./elephants/Elephant15.TXT", "r");
		//fp_r_6  = $fopen("./elephants/Elephant19.TXT", "r");
		//fp_r_7  = $fopen("./elephants/Elephant20.TXT", "r");
		//fp_r_8  = $fopen("./elephants/Elephant21.TXT", "r");
		//fp_r_9  = $fopen("./elephants/Elephant22.TXT", "r");
		//fp_r_10 = $fopen("./elephants/Elephant23.TXT", "r");
		//fp_r_11 = $fopen("./elephants/Elephant27.TXT", "r");
		//fp_r_12 = $fopen("./elephants/Elephant28.TXT", "r");
		//fp_r_13 = $fopen("./elephants/Elephant29.TXT", "r");
		//fp_r_14 = $fopen("./elephants/Elephant30.TXT", "r");
		//fp_r_15 = $fopen("./elephants/Elephant31.TXT", "r");
		//fp_r_16 = $fopen("./elephants/Elephant35.TXT", "r");
		//fp_r_17 = $fopen("./elephants/Elephant36.TXT", "r");
		//fp_r_18 = $fopen("./elephants/Elephant37.TXT", "r");
		//fp_r_19 = $fopen("./elephants/Elephant38.TXT", "r");
		//fp_r_20 = $fopen("./elephants/Elephant39.TXT", "r");
		//fp_r_21 = $fopen("./elephants/Elephant43.TXT", "r");
		//fp_r_22 = $fopen("./elephants/Elephant44.TXT", "r");
		//fp_r_23 = $fopen("./elephants/Elephant45.TXT", "r");
		//fp_r_24 = $fopen("./elephants/Elephant46.TXT", "r");
		//fp_r_25 = $fopen("./elephants/Elephant47.TXT", "r");	

		
		
		fp_r_1  = $fopen("./moon48/tile11.txt", "r");
		fp_r_2  = $fopen("./moon48/tile12.txt", "r");
		fp_r_3  = $fopen("./moon48/tile13.txt", "r");
		fp_r_4  = $fopen("./moon48/tile14.txt", "r");
		fp_r_5  = $fopen("./moon48/tile15.txt", "r");
		fp_r_6  = $fopen("./moon48/tile19.txt", "r");
		fp_r_7  = $fopen("./moon48/tile20.txt", "r");
		fp_r_8  = $fopen("./moon48/tile21.txt", "r");
		fp_r_9  = $fopen("./moon48/tile22.txt", "r");
		fp_r_10 = $fopen("./moon48/tile23.txt", "r");
		fp_r_11 = $fopen("./moon48/tile27.txt", "r");
		fp_r_12 = $fopen("./moon48/tile28.txt", "r");
		fp_r_13 = $fopen("./moon48/tile29.txt", "r");
		fp_r_14 = $fopen("./moon48/tile30.txt", "r");
		fp_r_15 = $fopen("./moon48/tile31.txt", "r");
		fp_r_16 = $fopen("./moon48/tile35.txt", "r");
		fp_r_17 = $fopen("./moon48/tile36.txt", "r");
		fp_r_18 = $fopen("./moon48/tile37.txt", "r");
		fp_r_19 = $fopen("./moon48/tile38.txt", "r");
		fp_r_20 = $fopen("./moon48/tile39.txt", "r");
		fp_r_21 = $fopen("./moon48/tile43.txt", "r");
		fp_r_22 = $fopen("./moon48/tile44.txt", "r");
		fp_r_23 = $fopen("./moon48/tile45.txt", "r");
		fp_r_24 = $fopen("./moon48/tile46.txt", "r");
		fp_r_25 = $fopen("./moon48/tile47.txt", "r");


		//fp_r_1  = $fopen("./lion48/lion11.TXT", "r");
		//fp_r_2  = $fopen("./lion48/lion12.TXT", "r");
		//fp_r_3  = $fopen("./lion48/lion13.TXT", "r");
		//fp_r_4  = $fopen("./lion48/lion14.TXT", "r");
		//fp_r_5  = $fopen("./lion48/lion15.TXT", "r");
		//fp_r_6  = $fopen("./lion48/lion19.TXT", "r");
		//fp_r_7  = $fopen("./lion48/lion20.TXT", "r");
		//fp_r_8  = $fopen("./lion48/lion21.TXT", "r");
		//fp_r_9  = $fopen("./lion48/lion22.TXT", "r");
		//fp_r_10 = $fopen("./lion48/lion23.TXT", "r");
		//fp_r_11 = $fopen("./lion48/lion27.TXT", "r");
		//fp_r_12 = $fopen("./lion48/lion28.TXT", "r");
		//fp_r_13 = $fopen("./lion48/lion29.TXT", "r");
		//fp_r_14 = $fopen("./lion48/lion30.TXT", "r");
		//fp_r_15 = $fopen("./lion48/lion31.TXT", "r");
		//fp_r_16 = $fopen("./lion48/lion35.TXT", "r");
		//fp_r_17 = $fopen("./lion48/lion36.TXT", "r");
		//fp_r_18 = $fopen("./lion48/lion37.TXT", "r");
		//fp_r_19 = $fopen("./lion48/lion38.TXT", "r");
		//fp_r_20 = $fopen("./lion48/lion39.TXT", "r");
		//fp_r_21 = $fopen("./lion48/lion43.TXT", "r");
		//fp_r_22 = $fopen("./lion48/lion44.TXT", "r");
		//fp_r_23 = $fopen("./lion48/lion45.TXT", "r");
		//fp_r_24 = $fopen("./lion48/lion46.TXT", "r");
		//fp_r_25 = $fopen("./lion48/lion47.TXT", "r");


		//fp_r_26 = $fopen("./elephant48/elephant26.TXT", "r");
		//fp_r_27 = $fopen("./elephant48/elephant27.TXT", "r");
		//fp_r_28 = $fopen("./elephant48/elephant28.TXT", "r");
		//fp_r_29 = $fopen("./elephant48/elephant29.TXT", "r");
		//fp_r_30 = $fopen("./elephant48/elephant30.TXT", "r");
		//fp_r_31 = $fopen("./elephant48/elephant31.TXT", "r");
		//fp_r_32 = $fopen("./elephant48/elephant32.TXT", "r");
		//fp_r_33 = $fopen("./elephant48/elephant33.TXT", "r");
		//fp_r_34 = $fopen("./elephant48/elephant34.TXT", "r");
		//fp_r_35 = $fopen("./elephant48/elephant35.TXT", "r");
		//fp_r_36 = $fopen("./elephant48/elephant36.TXT", "r");
		//fp_r_37 = $fopen("./elephant48/elephant37.TXT", "r");
		//fp_r_38 = $fopen("./elephant48/elephant38.TXT", "r");
		//fp_r_39 = $fopen("./elephant48/elephant39.TXT", "r");
		//fp_r_40 = $fopen("./elephant48/elephant40.TXT", "r");
		//fp_r_41 = $fopen("./elephant48/elephant41.TXT", "r");
		//fp_r_42 = $fopen("./elephant48/elephant42.TXT", "r");
		//fp_r_43 = $fopen("./elephant48/elephant43.TXT", "r");
		//fp_r_44 = $fopen("./elephant48/elephant44.TXT", "r");
		//fp_r_45 = $fopen("./elephant48/elephant45.TXT", "r");
		//fp_r_46 = $fopen("./elephant48/elephant46.TXT", "r");
		//fp_r_47 = $fopen("./elephant48/elephant47.TXT", "r");
		//fp_r_48 = $fopen("./elephant48/elephant48.TXT", "r");
		lion_counter=0;
        address=0;
        while(!$feof(fp_r_1))  begin 
            for(i=0;i<512;i=i+1)  begin
                cnt_1 = $fscanf (fp_r_1, "%d",mem[address]); 
                address=address+1;
            end
        end
        $fclose(fp_r_1);
		repeat(25)
		begin
			@(negedge rst_syn)
			begin
				address=0;
				case(lion_counter)
					0:$display("lion_counter=",lion_counter);
					1 :
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_2  = $fopen("lena_yuv_128.txt", "r");
							//address=0;
							while(!$feof(fp_r_2))  
							begin 
								
								for(i=0;i<512;i=i+1)  
								begin
									cnt_2 = $fscanf (fp_r_2, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_2);
						end
					2 :
						begin
							$display("lion_counter=",lion_counter);
						//	$display("fuck!");
							//fp_r_3  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							$display("address=",address);
							while(!$feof(fp_r_3))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
								//	$display("address=",address,"i=",i);
									cnt_3 = $fscanf (fp_r_3, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_3);
						end

					3 :
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_4  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_4))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt_4 = $fscanf (fp_r_4, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_4);
						end

					4 :
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_5  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_5))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_5, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_5 );
						end

					5 :
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_6  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_6))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_6, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_6 );
						end

					6 :
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_7  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_7))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_7, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_7);
						end

					7 :
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_8  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_8))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_8, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_8);
						end

					8 :
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_9  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_9))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_9, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_9 );
						end

					9 :
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_10  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_10))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_10, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_10 );
						end

					10:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_11  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_11))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_11, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_11 );
						end

					11:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_12  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_12))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_12, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_12 );
						end

					12:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_13  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_13))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_13, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_13 );
						end

					13:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_14  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_14))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_14, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_14 );
						end

					14:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_15  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_15))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_15, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_15 );
						end

					15:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_16  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_16))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_16, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_16 );
						end

					16:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_17  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_17))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_17, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_17 );
						end

					17:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_18  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_18))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_18, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_18 );
						end

					18:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_19  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_19))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_19, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_19 );
						end

					19:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_20  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_20))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_20, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_20 );
						end

					20:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_21  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_21))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_21, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_21 );
						end

					21:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_22  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_22))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_22, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_22 );
						end

					22:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_23  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_23))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_23, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_23 );
						end

					23:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_24  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_24))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_24, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_24 );
						end

					24:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_25  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_25))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_25, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_25 );
						end

					25:
						begin
							$display("lion_counter=",lion_counter);
							//fp_r_26  = $fopen("lena_yuv_128.txt", "r");
							address=0;
							while(!$feof(fp_r_26))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_26, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_26 );
						end

					26:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_27  = $fopen("./lion48/lion27.TXT", "r");
							address=0;
							while(!$feof(fp_r_27))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_27, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_27 );
						end

					27:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_28  = $fopen("./lion48/lion28.TXT", "r");
							address=0;
							while(!$feof(fp_r_28))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_28, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_28 );
						end

					28:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_29  = $fopen("./lion48/lion29.TXT", "r");
							address=0;
							while(!$feof(fp_r_29))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_29, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_29 );
						end

					29:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_30  = $fopen("./lion48/lion30.TXT", "r");
							address=0;
							while(!$feof(fp_r_30))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_30, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_30 );
						end

					30:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_31  = $fopen("./lion48/lion31.TXT", "r");
							address=0;
							while(!$feof(fp_r_31))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_31, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_31 );
						end

					31:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_32  = $fopen("./lion48/lion32.TXT", "r");
							address=0;
							while(!$feof(fp_r_32))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_32, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_32 );
						end

					32:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_33  = $fopen("./lion48/lion33.TXT", "r");
							address=0;
							while(!$feof(fp_r_33))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_33, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_33 );
						end

					33:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_34  = $fopen("./lion48/lion34.TXT", "r");
							address=0;
							while(!$feof(fp_r_34))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_34, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_34 );
						end

					34:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_35  = $fopen("./lion48/lion35.TXT", "r");
							address=0;
							while(!$feof(fp_r_35))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_35, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_35 );
						end

					35:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_36  = $fopen("./lion48/lion36.TXT", "r");
							address=0;
							while(!$feof(fp_r_36))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_36, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_36 );
						end

					36:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_37  = $fopen("./lion48/lion37.TXT", "r");
							address=0;
							while(!$feof(fp_r_37))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_37, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_37 );
						end

					37:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_38  = $fopen("./lion48/lion38.TXT", "r");
							address=0;
							while(!$feof(fp_r_38))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_38, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_38 );
						end

					38:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_39  = $fopen("./lion48/lion39.TXT", "r");
							address=0;
							while(!$feof(fp_r_39))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_39, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_39 );
						end

					39:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_40  = $fopen("./lion48/lion40.TXT", "r");
							address=0;
							while(!$feof(fp_r_40))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_40, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_40 );
						end

					40:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_41  = $fopen("./lion48/lion41.TXT", "r");
							address=0;
							while(!$feof(fp_r_41))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_41, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_41 );
						end

					41:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_42  = $fopen("./lion48/lion42.TXT", "r");
							address=0;
							while(!$feof(fp_r_42))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_42, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_42 );
						end

					42:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_43  = $fopen("./lion48/lion43.TXT", "r");
							address=0;
							while(!$feof(fp_r_43))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_43, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_43 );
						end

					43:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_44  = $fopen("./lion48/lion44.TXT", "r");
							address=0;
							while(!$feof(fp_r_44))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_44, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_44 );
						end

					44:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_45  = $fopen("./lion48/lion45.TXT", "r");
							address=0;
							while(!$feof(fp_r_45))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_45, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_45 );
						end

					45:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_46  = $fopen("./lion48/lion46.TXT", "r");
							address=0;
							while(!$feof(fp_r_46))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_46, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_46 );
						end

					46:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_47  = $fopen("./lion48/lion47.TXT", "r");
							address=0;
							while(!$feof(fp_r_47))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_47, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_47 );
						end

					47:
						begin
							$display("lion_counter=",lion_counter);
							fp_r_48  = $fopen("./lion48/lion48.TXT", "r");
							address=0;
							while(!$feof(fp_r_48))  
							begin 
								for(i=0;i<512;i=i+1)  
								begin
									cnt = $fscanf (fp_r_48, "%d",mem[address]); 
									address=address+1;
								end
							end
							$fclose(fp_r_48 );
						end
				endcase
			end
		end
    end
	
	assign wea_o1_w = (start == 1'b0)?  1'b1:1'bz;
	assign wea_o2_w = (start == 1'b0)?  1'b1:1'bz;
	assign ena_o1_w = (start == 1'b0)?  1'b1:1'bz;
	assign ena_o2_w = (start == 1'b0)?  1'b1:1'bz;
	
	reg [13:0] addra_o1_w;
	reg [13:0] addra_o2_w;
	reg [13:0] addra_o1_n;
	reg [13:0] addra_o2_n;
	
	
	always@(posedge clk or negedge rst) begin
	    if(!rst) begin
		    addra_o1_w <= 14'b0;
			addra_o2_w <= 14'b0;
		end
		else if(rst_syn)begin
		    addra_o1_w <= 14'b0;
			addra_o2_w <= 14'b0;
		end
		else begin
		    addra_o1_w <= addra_o1_n;
			addra_o2_w <= addra_o2_n;
		end
	end
	
	reg [5:0] count;
	reg [5:0] count_n;
	
	always@(posedge clk or negedge rst) begin
	    if(!rst) begin
		    count <= 6'b0;
		end
		else if(rst_syn)
			count <= 6'b0;
		else begin
		    count <= count_n;
		end
	end
	
	always@(*) begin
	    if(addra_o1_w == 12288) begin
	        addra_o1_n = addra_o1_w;
			addra_o2_n = addra_o1_w;
	    end
	    else begin
	        addra_o1_n = addra_o1_w + 1;
		    addra_o2_n = addra_o2_w + 1;
		end
	end
	
	reg [15:0] act_addr;
	reg [15:0] act_addr_n;
	
	always@(posedge clk or negedge rst) begin
	    if(!rst) begin
		    act_addr <= 16'b0;
		end
		else if(rst_syn)
			act_addr <= 16'b0;
		else begin
		    act_addr <= act_addr_n;
		end
	end
    
	always@(*) begin
		if(count == 63) begin
		    act_addr_n = act_addr + 130;
		end
		else begin
		    act_addr_n = act_addr + 2;
		end
		count_n = count;
		if(count == 63) begin
		    count_n = 0;
		end
		else begin
		    count_n = count + 1;
		end
	end
	
	wire [16:0] dina_o1;
	wire [16:0] dina_o2;
	
	assign dina_o1 = (addra_o1_w < 12288)? {1'bz,mem[act_addr+1],mem[act_addr]}:17'bz;
	assign dina_o2 = (addra_o2_w < 12288)? {1'bz,mem[act_addr + 129],mem[act_addr + 128]}:17'bz;
	
endmodule
