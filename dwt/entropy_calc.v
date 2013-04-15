`timescale 1ns/10ps	
module entropy_calc(/*autoarg*/
    //Inputs
    clk, rst, data_HH, data_LH, data_HL, 
    data_LL, Y_U_V_over, tier1_over, one_codeblock_over,rst_syn, 
	compression_ratio,
    //Outputs
	bpc_start,
    entropy_calc_over, read_en_LL, read_en_HL, 
    read_en_LH, read_en_HH, address_LL, address_LH, 
    address_HL, address_HH, byte_number_codeblock
);
input clk;
input rst;
input rst_syn;
input [16:0]data_HH;
input [16:0]data_LH;
input [16:0]data_HL;
input [16:0]data_LL;
input [1:0]Y_U_V_over;
input tier1_over;
input one_codeblock_over;
input [2:0]compression_ratio;

output bpc_start;
output entropy_calc_over;
output read_en_LL;
output read_en_HL;
output read_en_LH;
output read_en_HH;
output [13:0]address_LL;
output [13:0]address_LH;
output [13:0]address_HL;
output [13:0]address_HH;
output [13:0]byte_number_codeblock;
parameter 	IDLE=0,
			READ_ODD_ROW=1,
			READ_EVEN_ROW=2,
			CODEBLOCK_OVER=3,
			GET_CODEBLOCK_ADDRESS=4,
			ENTROPY_CALC_OVER=6,
			NEXT_CODEBLOCK=5,
			CALC_LOG=7,
			TIER1_WORKING=8;




/*********************** reg ********************/
	reg[13:0]byte_number_codeblock;
	reg[13:0]byte_allocate;
	reg[9:0]log_diff;
	reg[4:0]exponent_delay1;
	reg[4:0]exponent_delay2;
	reg[19:0]entropy_codeblock_delay2;
	reg[24:0]exponent_input;
	reg[5:0]shift_number;
	reg[19:0]entropy_codeblock_delay1;
	reg[4:0]exponent;
	reg[7:0]table_input;
	reg[3:0]Y_U_V_over_counter;
	reg read_start_delay1;

	reg[15:0]data_bar;
	reg[15:0]data_current_tran;
	reg[15:0]data_left_tran;
	reg[15:0]data_upper_tran;
	reg entropy_calc_over;
	reg last_codeblock_of_current_level;
	reg read_en_LL;
	reg read_en_HL;
	reg read_en_LH;
	reg read_en_HH;
	reg [13:0]address_LL;
	reg [13:0]address_LH;
	reg [13:0]address_HL;
	reg [13:0]address_HH;

	reg[16:0]data_from_ram;
	reg [6:0]table_output;
	reg[24:0]total_entropy;
	reg[15:0]data_current_tran_delay;
	reg first_row;
	reg first_row_delay;
	reg first_row_delay_1;
	reg [19:0]entropy_LL5_Y;//{{{
	reg [19:0]entropy_LL5_U;
	reg [19:0]entropy_LL5_V;
	reg [19:0]entropy_HL5_Y;
	reg [19:0]entropy_HL5_U;
	reg [19:0]entropy_HL5_V;
	reg [19:0]entropy_LH5_Y;
	reg [19:0]entropy_LH5_U;
	reg [19:0]entropy_LH5_V;
	reg [19:0]entropy_HH5_Y;
	reg [19:0]entropy_HH5_U;
	reg [19:0]entropy_HH5_V;
	reg [19:0]entropy_HL4_Y;
	reg [19:0]entropy_HL4_U;
	reg [19:0]entropy_HL4_V;
	reg [19:0]entropy_LH4_Y;
	reg [19:0]entropy_LH4_U;
	reg [19:0]entropy_LH4_V;
	reg [19:0]entropy_HH4_Y;
	reg [19:0]entropy_HH4_U;
	reg [19:0]entropy_HH4_V;
	reg [19:0]entropy_HL3_Y;
	reg [19:0]entropy_HL3_U;
	reg [19:0]entropy_HL3_V;
	reg [19:0]entropy_LH3_Y;
	reg [19:0]entropy_LH3_U;
	reg [19:0]entropy_LH3_V;
	reg [19:0]entropy_HH3_Y;
	reg [19:0]entropy_HH3_U;
	reg [19:0]entropy_HH3_V;
	reg [19:0]entropy_HL2_Y;
	reg [19:0]entropy_HL2_U;
	reg [19:0]entropy_HL2_V;
	reg [19:0]entropy_LH2_Y;
	reg [19:0]entropy_LH2_U;
	reg [19:0]entropy_LH2_V;
	reg [19:0]entropy_HH2_Y;
	reg [19:0]entropy_HH2_U;
	reg [19:0]entropy_HH2_V;
	reg [19:0]entropy_HL1_Y;
	reg [19:0]entropy_HL1_U;
	reg [19:0]entropy_HL1_V;
	reg [19:0]entropy_LH1_Y;
	reg [19:0]entropy_LH1_U;
	reg [19:0]entropy_LH1_V;
	reg [19:0]entropy_HH1_Y;
	reg [19:0]entropy_HH1_U;
	reg [19:0]entropy_HH1_V;//}}}
	reg codeblock_over_delay_1;
	reg codeblock_over_delay_2;
	reg codeblock_over_delay_3;
	reg codeblock_over_delay;
	reg codeblock_over;
	reg [19:0]entropy_codeblock;
	reg [16:0]difference;
	reg [13:0]ram_address;
	reg data_sel_delay;
	reg [5:0]fetch_data_index;
	reg [5:0]data_reg_index;
	reg [16:0]data_current;
	reg [16:0]data_left;
	reg [16:0]data_upper;
	reg data_vld;
	reg fetch_data_vld;
	reg get_data_bar_vld;
	reg get_entropy_vld;
	reg sum_entropy_vld;
	reg data_sel;
	reg row_over;
	reg[2:0]level;
	reg col_over;
	reg[5:0]col_counter;
	reg[5:0]row_counter;
	reg[3:0]state;
	reg[3:0]nextstate;
	reg[5:0]codeblock_counter;
	reg[16:0]data_reg_0_0;// {{{
	reg[16:0]data_reg_0_1;
	reg[16:0]data_reg_0_2;
	reg[16:0]data_reg_0_3;
	reg[16:0]data_reg_0_4;
	reg[16:0]data_reg_0_5;
	reg[16:0]data_reg_0_6;
	reg[16:0]data_reg_0_7;
	reg[16:0]data_reg_0_8;
	reg[16:0]data_reg_0_9;
	reg[16:0]data_reg_0_10;
	reg[16:0]data_reg_0_11;
	reg[16:0]data_reg_0_12;
	reg[16:0]data_reg_0_13;
	reg[16:0]data_reg_0_14;
	reg[16:0]data_reg_0_15;
	reg[16:0]data_reg_0_16;
	reg[16:0]data_reg_0_17;
	reg[16:0]data_reg_0_18;
	reg[16:0]data_reg_0_19;
	reg[16:0]data_reg_0_20;
	reg[16:0]data_reg_0_21;
	reg[16:0]data_reg_0_22;
	reg[16:0]data_reg_0_23;
	reg[16:0]data_reg_0_24;
	reg[16:0]data_reg_0_25;
	reg[16:0]data_reg_0_26;
	reg[16:0]data_reg_0_27;
	reg[16:0]data_reg_0_28;
	reg[16:0]data_reg_0_29;
	reg[16:0]data_reg_0_30;
	reg[16:0]data_reg_0_31;
	reg[16:0]data_reg_0_32;
	reg[16:0]data_reg_0_33;
	reg[16:0]data_reg_0_34;
	reg[16:0]data_reg_0_35;
	reg[16:0]data_reg_0_36;
	reg[16:0]data_reg_0_37;
	reg[16:0]data_reg_0_38;
	reg[16:0]data_reg_0_39;
	reg[16:0]data_reg_0_40;
	reg[16:0]data_reg_0_41;
	reg[16:0]data_reg_0_42;
	reg[16:0]data_reg_0_43;
	reg[16:0]data_reg_0_44;
	reg[16:0]data_reg_0_45;
	reg[16:0]data_reg_0_46;
	reg[16:0]data_reg_0_47;
	reg[16:0]data_reg_0_48;
	reg[16:0]data_reg_0_49;
	reg[16:0]data_reg_0_50;
	reg[16:0]data_reg_0_51;
	reg[16:0]data_reg_0_52;
	reg[16:0]data_reg_0_53;
	reg[16:0]data_reg_0_54;
	reg[16:0]data_reg_0_55;
	reg[16:0]data_reg_0_56;
	reg[16:0]data_reg_0_57;
	reg[16:0]data_reg_0_58;
	reg[16:0]data_reg_0_59;
	reg[16:0]data_reg_0_60;
	reg[16:0]data_reg_0_61;
	reg[16:0]data_reg_0_62;
	reg[16:0]data_reg_0_63;
	reg[16:0]data_reg_1_0;
	reg[16:0]data_reg_1_1;
	reg[16:0]data_reg_1_2;
	reg[16:0]data_reg_1_3;
	reg[16:0]data_reg_1_4;
	reg[16:0]data_reg_1_5;
	reg[16:0]data_reg_1_6;
	reg[16:0]data_reg_1_7;
	reg[16:0]data_reg_1_8;
	reg[16:0]data_reg_1_9;
	reg[16:0]data_reg_1_10;
	reg[16:0]data_reg_1_11;
	reg[16:0]data_reg_1_12;
	reg[16:0]data_reg_1_13;
	reg[16:0]data_reg_1_14;
	reg[16:0]data_reg_1_15;
	reg[16:0]data_reg_1_16;
	reg[16:0]data_reg_1_17;
	reg[16:0]data_reg_1_18;
	reg[16:0]data_reg_1_19;
	reg[16:0]data_reg_1_20;
	reg[16:0]data_reg_1_21;
	reg[16:0]data_reg_1_22;
	reg[16:0]data_reg_1_23;
	reg[16:0]data_reg_1_24;
	reg[16:0]data_reg_1_25;
	reg[16:0]data_reg_1_26;
	reg[16:0]data_reg_1_27;
	reg[16:0]data_reg_1_28;
	reg[16:0]data_reg_1_29;
	reg[16:0]data_reg_1_30;
	reg[16:0]data_reg_1_31;
	reg[16:0]data_reg_1_32;
	reg[16:0]data_reg_1_33;
	reg[16:0]data_reg_1_34;
	reg[16:0]data_reg_1_35;
	reg[16:0]data_reg_1_36;
	reg[16:0]data_reg_1_37;
	reg[16:0]data_reg_1_38;
	reg[16:0]data_reg_1_39;
	reg[16:0]data_reg_1_40;
	reg[16:0]data_reg_1_41;
	reg[16:0]data_reg_1_42;
	reg[16:0]data_reg_1_43;
	reg[16:0]data_reg_1_44;
	reg[16:0]data_reg_1_45;
	reg[16:0]data_reg_1_46;
	reg[16:0]data_reg_1_47;
	reg[16:0]data_reg_1_48;
	reg[16:0]data_reg_1_49;
	reg[16:0]data_reg_1_50;
	reg[16:0]data_reg_1_51;
	reg[16:0]data_reg_1_52;
	reg[16:0]data_reg_1_53;
	reg[16:0]data_reg_1_54;
	reg[16:0]data_reg_1_55;
	reg[16:0]data_reg_1_56;
	reg[16:0]data_reg_1_57;
	reg[16:0]data_reg_1_58;
	reg[16:0]data_reg_1_59;
	reg[16:0]data_reg_1_60;
	reg[16:0]data_reg_1_61;
	reg[16:0]data_reg_1_62;
	reg[16:0]data_reg_1_63;//}}}
	/**************** wire *****************/
	//wire[3:0]compression_ratio;
	wire tier1_working;
	wire[10:0]log_result;
	wire calc_log;
	wire[32:0]entropy_codeblock_expanded_shifted;
	wire[32:0]entropy_total_expanded_shifted;
	wire[32:0]entropy_codeblock_expanded;
	wire[32:0]entropy_total_expanded;
	wire new_data_availible;
	wire read_start=(Y_U_V_over==1||Y_U_V_over==2||Y_U_V_over==3);

	wire all_codeblock_over;
	wire read_en;
	reg bpc_start;
	/**************** wire internal ******************/
	//assign compression_ratio=1;
	assign tier1_working=state==TIER1_WORKING;
	assign calc_log=state==CALC_LOG;
	assign entropy_codeblock_expanded_shifted=entropy_codeblock_expanded<<shift_number;
	assign entropy_total_expanded_shifted=entropy_total_expanded<<shift_number;
	assign all_codeblock_over=codeblock_counter==48;
	assign new_data_availible=Y_U_V_over_counter!=0;
	assign entropy_codeblock_expanded={5'b0,entropy_codeblock_delay2[19:0],8'b0};
	assign entropy_total_expanded={total_entropy[24:0],8'b0};
	assign log_result={exponent_delay2[4:0],6'b0}+table_output;
	/**************** wire output *******************/
	assign read_en=(state==READ_ODD_ROW||state==READ_EVEN_ROW);
	/**************** reg internal ****************/
	always@(*)
	begin
		if(tier1_working)
		begin
			case(compression_ratio)
				0:byte_number_codeblock=entropy_codeblock[13:0];//ratio is 1:5
				1:byte_number_codeblock=entropy_codeblock[13:1];//ratio is 1:10
				2:byte_number_codeblock=entropy_codeblock[13:2];//ratio is 1:20
				3:byte_number_codeblock=entropy_codeblock[13:3];//ratio is 1:40
				4:byte_number_codeblock=entropy_codeblock[13:4];//ratio is 1:80
				default:byte_number_codeblock=entropy_codeblock[13:0];
			endcase
		end 
		else byte_number_codeblock=0;
	end
	always@(*)
	begin
		if(log_diff>=180&&log_diff<=600)
		begin
			case(log_diff)
				180:byte_allocate=1399;
				181:byte_allocate=1384;
				182:byte_allocate=1369;
				183:byte_allocate=1355;
				184:byte_allocate=1340;
				185:byte_allocate=1326;
				186:byte_allocate=1311;
				187:byte_allocate=1297;
				188:byte_allocate=1283;
				189:byte_allocate=1269;
				190:byte_allocate=1256;
				191:byte_allocate=1242;
				192:byte_allocate=1229;
				193:byte_allocate=1216;
				194:byte_allocate=1202;
				195:byte_allocate=1190;
				196:byte_allocate=1177;
				197:byte_allocate=1164;
				198:byte_allocate=1151;
				199:byte_allocate=1139;
				200:byte_allocate=1127;//{{{
				201:byte_allocate=1115;
				202:byte_allocate=1103;
				203:byte_allocate=1091;
				204:byte_allocate=1079;
				205:byte_allocate=1067;
				206:byte_allocate=1056;
				207:byte_allocate=1045;
				208:byte_allocate=1033;
				209:byte_allocate=1022;
				210:byte_allocate=1011;
				211:byte_allocate=1000;
				212:byte_allocate=989 ;
				213:byte_allocate=979 ;
				214:byte_allocate=968 ;
				215:byte_allocate=958 ;
				216:byte_allocate=948 ;
				217:byte_allocate=937 ;
				218:byte_allocate=927 ;
				219:byte_allocate=917 ;
				220:byte_allocate=907 ;
				221:byte_allocate=898 ;
				222:byte_allocate=888 ;
				223:byte_allocate=878 ;
				224:byte_allocate=869 ;
				225:byte_allocate=860 ;
				226:byte_allocate=850 ;
				227:byte_allocate=841 ;
				228:byte_allocate=832 ;
				229:byte_allocate=823 ;
				230:byte_allocate=814 ;
				231:byte_allocate=805 ;
				232:byte_allocate=797 ;
				233:byte_allocate=788 ;
				234:byte_allocate=780 ;
				235:byte_allocate=771 ;
				236:byte_allocate=763 ;
				237:byte_allocate=755 ;
				238:byte_allocate=747 ;
				239:byte_allocate=739 ;
				240:byte_allocate=731 ;
				241:byte_allocate=723 ;
				242:byte_allocate=715 ;
				243:byte_allocate=707 ;
				244:byte_allocate=700 ;
				245:byte_allocate=692 ;
				246:byte_allocate=685 ;
				247:byte_allocate=677 ;
				248:byte_allocate=670 ;
				249:byte_allocate=663 ;
				250:byte_allocate=656 ;
				251:byte_allocate=649 ;
				252:byte_allocate=642 ;
				253:byte_allocate=635 ;
				254:byte_allocate=628 ;
				255:byte_allocate=621 ;
				256:byte_allocate=614 ;
				257:byte_allocate=608 ;
				258:byte_allocate=601 ;
				259:byte_allocate=595 ;
				260:byte_allocate=588 ;
				261:byte_allocate=582 ;
				262:byte_allocate=576 ;
				263:byte_allocate=570 ;
				264:byte_allocate=563 ;
				265:byte_allocate=557 ;
				266:byte_allocate=551 ;
				267:byte_allocate=545 ;
				268:byte_allocate=540 ;
				269:byte_allocate=534 ;
				270:byte_allocate=528 ;
				271:byte_allocate=522 ;
				272:byte_allocate=517 ;
				273:byte_allocate=511 ;
				274:byte_allocate=506 ;
				275:byte_allocate=500 ;
				276:byte_allocate=495 ;
				277:byte_allocate=489 ;
				278:byte_allocate=484 ;
				279:byte_allocate=479 ;
				280:byte_allocate=474 ;
				281:byte_allocate=469 ;
				282:byte_allocate=464 ;
				283:byte_allocate=459 ;
				284:byte_allocate=454 ;
				285:byte_allocate=449 ;
				286:byte_allocate=444 ;
				287:byte_allocate=439 ;
				288:byte_allocate=434 ;
				289:byte_allocate=430 ;
				290:byte_allocate=425 ;
				291:byte_allocate=421 ;
				292:byte_allocate=416 ;
				293:byte_allocate=412 ;
				294:byte_allocate=407 ;
				295:byte_allocate=403 ;
				296:byte_allocate=398 ;
				297:byte_allocate=394 ;
				298:byte_allocate=390 ;
				299:byte_allocate=386 ;
				300:byte_allocate=381 ;
				301:byte_allocate=377 ;
				302:byte_allocate=373 ;
				303:byte_allocate=369 ;
				304:byte_allocate=365 ;
				305:byte_allocate=361 ;
				306:byte_allocate=357 ;
				307:byte_allocate=354 ;
				308:byte_allocate=350 ;
				309:byte_allocate=346 ;
				310:byte_allocate=342 ;
				311:byte_allocate=339 ;
				312:byte_allocate=335 ;
				313:byte_allocate=331 ;
				314:byte_allocate=328 ;
				315:byte_allocate=324 ;
				316:byte_allocate=321 ;
				317:byte_allocate=317 ;
				318:byte_allocate=314 ;
				319:byte_allocate=311 ;
				320:byte_allocate=307 ;
				321:byte_allocate=304 ;
				322:byte_allocate=301 ;
				323:byte_allocate=297 ;
				324:byte_allocate=294 ;
				325:byte_allocate=291 ;
				326:byte_allocate=288 ;
				327:byte_allocate=285 ;
				328:byte_allocate=282 ;
				329:byte_allocate=279 ;
				330:byte_allocate=276 ;
				331:byte_allocate=273 ;
				332:byte_allocate=270 ;
				333:byte_allocate=267 ;
				334:byte_allocate=264 ;
				335:byte_allocate=261 ;
				336:byte_allocate=258 ;
				337:byte_allocate=256 ;
				338:byte_allocate=253 ;
				339:byte_allocate=250 ;
				340:byte_allocate=247 ;
				341:byte_allocate=245 ;
				342:byte_allocate=242 ;
				343:byte_allocate=239 ;
				344:byte_allocate=237 ;
				345:byte_allocate=234 ;
				346:byte_allocate=232 ;
				347:byte_allocate=229 ;
				348:byte_allocate=227 ;
				349:byte_allocate=224 ;
				350:byte_allocate=222 ;
				351:byte_allocate=220 ;
				352:byte_allocate=217 ;
				353:byte_allocate=215 ;
				354:byte_allocate=213 ;
				355:byte_allocate=210 ;
				356:byte_allocate=208 ;
				357:byte_allocate=206 ;
				358:byte_allocate=204 ;
				359:byte_allocate=201 ;
				360:byte_allocate=199 ;
				361:byte_allocate=197 ;
				362:byte_allocate=195 ;
				363:byte_allocate=193 ;
				364:byte_allocate=191 ;
				365:byte_allocate=189 ;
				366:byte_allocate=187 ;
				367:byte_allocate=185 ;
				368:byte_allocate=183 ;
				369:byte_allocate=181 ;
				370:byte_allocate=179 ;
				371:byte_allocate=177 ;
				372:byte_allocate=175 ;
				373:byte_allocate=173 ;
				374:byte_allocate=171 ;
				375:byte_allocate=169 ;
				376:byte_allocate=168 ;
				377:byte_allocate=166 ;
				378:byte_allocate=164 ;
				379:byte_allocate=162 ;
				380:byte_allocate=160 ;
				381:byte_allocate=159 ;
				382:byte_allocate=157 ;
				383:byte_allocate=155 ;
				384:byte_allocate=154 ;
				385:byte_allocate=152 ;
				386:byte_allocate=150 ;
				387:byte_allocate=149 ;
				388:byte_allocate=147 ;
				389:byte_allocate=146 ;
				390:byte_allocate=144 ;
				391:byte_allocate=142 ;
				392:byte_allocate=141 ;
				393:byte_allocate=139 ;
				394:byte_allocate=138 ;
				395:byte_allocate=136 ;
				396:byte_allocate=135 ;
				397:byte_allocate=133 ;
				398:byte_allocate=132 ;
				399:byte_allocate=131 ;
				400:byte_allocate=129 ;
				401:byte_allocate=128 ;
				402:byte_allocate=126 ;
				403:byte_allocate=125 ;
				404:byte_allocate=124 ;
				405:byte_allocate=122 ;
				406:byte_allocate=121 ;
				407:byte_allocate=120 ;
				408:byte_allocate=118 ;
				409:byte_allocate=117 ;
				410:byte_allocate=116 ;
				411:byte_allocate=115 ;
				412:byte_allocate=113 ;
				413:byte_allocate=112 ;
				414:byte_allocate=111 ;
				415:byte_allocate=110 ;
				416:byte_allocate=109 ;
				417:byte_allocate=107 ;
				418:byte_allocate=106 ;
				419:byte_allocate=105 ;
				420:byte_allocate=104 ;
				421:byte_allocate=103 ;
				422:byte_allocate=102 ;
				423:byte_allocate=101 ;
				424:byte_allocate=100 ;
				425:byte_allocate=99 ;
				426:byte_allocate=97 ;
				427:byte_allocate=96 ;
				428:byte_allocate=95 ;
				429:byte_allocate=94 ;
				430:byte_allocate=93 ;
				431:byte_allocate=92 ;
				432:byte_allocate=91 ;
				433:byte_allocate=90 ;
				434:byte_allocate=89 ;
				435:byte_allocate=88 ;
				436:byte_allocate=87 ;
				437:byte_allocate=87 ;
				438:byte_allocate=86 ;
				439:byte_allocate=85 ;
				440:byte_allocate=84 ;
				441:byte_allocate=83 ;
				442:byte_allocate=82 ;
				443:byte_allocate=81 ;
				444:byte_allocate=80 ;
				445:byte_allocate=79 ;
				446:byte_allocate=78 ;
				447:byte_allocate=78 ;
				448:byte_allocate=77 ;
				449:byte_allocate=76 ;
				450:byte_allocate=75 ;
				451:byte_allocate=74 ;
				452:byte_allocate=74 ;
				453:byte_allocate=73 ;
				454:byte_allocate=72 ;
				455:byte_allocate=71 ;
				456:byte_allocate=70 ;
				457:byte_allocate=70 ;
				458:byte_allocate=69 ;
				459:byte_allocate=68 ;
				460:byte_allocate=67 ;
				461:byte_allocate=67 ;
				462:byte_allocate=66 ;
				463:byte_allocate=65 ;
				464:byte_allocate=65 ;
				465:byte_allocate=64 ;
				466:byte_allocate=63 ;
				467:byte_allocate=63 ;
				468:byte_allocate=62 ;
				469:byte_allocate=61 ;
				470:byte_allocate=61 ;
				471:byte_allocate=60 ;
				472:byte_allocate=59 ;
				473:byte_allocate=59 ;
				474:byte_allocate=58 ;
				475:byte_allocate=57 ;
				476:byte_allocate=57 ;
				477:byte_allocate=56 ;
				478:byte_allocate=55 ;
				479:byte_allocate=55 ;
				480:byte_allocate=54 ;
				481:byte_allocate=54 ;
				482:byte_allocate=53 ;
				483:byte_allocate=53 ;
				484:byte_allocate=52 ;
				485:byte_allocate=51 ;
				486:byte_allocate=51 ;
				487:byte_allocate=50 ;
				488:byte_allocate=50 ;
				489:byte_allocate=49 ;
				490:byte_allocate=49 ;
				491:byte_allocate=48 ;
				492:byte_allocate=48 ;
				493:byte_allocate=47 ;
				494:byte_allocate=47 ;
				495:byte_allocate=46 ;
				496:byte_allocate=46 ;
				497:byte_allocate=45 ;
				498:byte_allocate=45 ;
				499:byte_allocate=44 ;
				500:byte_allocate=44 ;
				501:byte_allocate=43 ;
				502:byte_allocate=43 ;
				503:byte_allocate=42 ;
				504:byte_allocate=42 ;
				505:byte_allocate=41 ;
				506:byte_allocate=41 ;
				507:byte_allocate=41 ;
				508:byte_allocate=40 ;
				509:byte_allocate=40 ;
				510:byte_allocate=39 ;
				511:byte_allocate=39 ;
				512:byte_allocate=38 ;
				513:byte_allocate=38 ;
				514:byte_allocate=38 ;
				515:byte_allocate=37 ;
				516:byte_allocate=37 ;
				517:byte_allocate=36 ;
				518:byte_allocate=36 ;
				519:byte_allocate=36 ;
				520:byte_allocate=35 ;
				521:byte_allocate=35 ;
				522:byte_allocate=34 ;
				523:byte_allocate=34 ;
				524:byte_allocate=34 ;
				525:byte_allocate=33 ;
				526:byte_allocate=33 ;
				527:byte_allocate=33 ;
				528:byte_allocate=32 ;
				529:byte_allocate=32 ;
				530:byte_allocate=32 ;
				531:byte_allocate=31 ;
				532:byte_allocate=31 ;
				533:byte_allocate=31 ;
				534:byte_allocate=30 ;
				535:byte_allocate=30 ;
				536:byte_allocate=30 ;
				537:byte_allocate=29 ;
				538:byte_allocate=29 ;
				539:byte_allocate=29 ;
				540:byte_allocate=28 ;
				541:byte_allocate=28 ;
				542:byte_allocate=28 ;
				543:byte_allocate=27 ;
				544:byte_allocate=27 ;
				545:byte_allocate=27 ;
				546:byte_allocate=27 ;
				547:byte_allocate=26 ;
				548:byte_allocate=26 ;
				549:byte_allocate=26 ;
				550:byte_allocate=25 ;
				551:byte_allocate=25 ;
				552:byte_allocate=25 ;
				553:byte_allocate=25 ;
				554:byte_allocate=24 ;
				555:byte_allocate=24 ;
				556:byte_allocate=24 ;
				557:byte_allocate=24 ;
				558:byte_allocate=23 ;
				559:byte_allocate=23 ;
				560:byte_allocate=23 ;
				561:byte_allocate=23 ;
				562:byte_allocate=22 ;
				563:byte_allocate=22 ;
				564:byte_allocate=22 ;
				565:byte_allocate=22 ;
				566:byte_allocate=21 ;
				567:byte_allocate=21 ;
				568:byte_allocate=21 ;
				569:byte_allocate=21 ;
				570:byte_allocate=20 ;
				571:byte_allocate=20 ;
				572:byte_allocate=20 ;
				573:byte_allocate=20 ;
				574:byte_allocate=20 ;
				575:byte_allocate=19 ;
				576:byte_allocate=19 ;
				577:byte_allocate=19 ;
				578:byte_allocate=19 ;
				579:byte_allocate=19 ;
				580:byte_allocate=18 ;
				581:byte_allocate=18 ;
				582:byte_allocate=18 ;
				583:byte_allocate=18 ;
				584:byte_allocate=18 ;
				585:byte_allocate=17 ;
				586:byte_allocate=17 ;
				587:byte_allocate=17 ;
				588:byte_allocate=17 ;
				589:byte_allocate=17 ;
				590:byte_allocate=16 ;
				591:byte_allocate=16 ;
				592:byte_allocate=16 ;
				593:byte_allocate=16 ;
				594:byte_allocate=16 ;
				595:byte_allocate=16 ;
				596:byte_allocate=15 ;
				597:byte_allocate=15 ;
				598:byte_allocate=15 ;
				599:byte_allocate=15 ;
				600:byte_allocate=15 ;//}}}
				default:byte_allocate=14'bx;
			endcase
		end 
		else if(log_diff>600)
		begin
			byte_allocate=15;
		end 
		else //log_diff<180
		begin
			byte_allocate=1399;
		end 
	end
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			log_diff<=0;
		else if(rst_syn)
			log_diff<=0;
		else if(!(codeblock_counter==3||codeblock_counter==2||codeblock_counter==1||codeblock_counter==0))
		begin
			if(calc_log)
				log_diff<=total_entropy-log_result;
		end 
	end
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			exponent_delay1<=0;
			exponent_delay2<=0;
		end 
		else if(rst_syn)
		begin
			exponent_delay1<=0;
		    exponent_delay2<=0;
		end
		else
		begin
			exponent_delay1<=exponent;
			exponent_delay2<=exponent_delay1;
		end 
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			shift_number<=0;
		else if(rst_syn)
			shift_number<=0;
		else shift_number<=25-exponent;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			exponent_input<=0;
		else if(rst_syn)
			exponent_input<=0;
		else if(calc_log)
		begin
			case(codeblock_counter)
				0:exponent_input<=total_entropy;
				default:exponent_input<={5'b0,entropy_codeblock};
			endcase
		end 
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			entropy_codeblock_delay1<=0;
			entropy_codeblock_delay2<=0;
		end 
		else if(rst_syn)
		begin
			entropy_codeblock_delay1<=0;
			entropy_codeblock_delay2<=0;
		end
		else 
		begin
			entropy_codeblock_delay1<=entropy_codeblock;
			entropy_codeblock_delay2<=entropy_codeblock_delay1;
		end 
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			table_input<=0;
		else if(rst_syn)
			table_input<=0;
		else if(calc_log)
		begin
			if(codeblock_counter==2)
			begin
				table_input<=entropy_total_expanded_shifted[32:25];
			end 
			else if(codeblock_counter>=3&&codeblock_counter<=49)
			begin
				table_input<=entropy_codeblock_expanded_shifted[32:25];
			end 
		end 
	end
	
	always@(*)
	begin
	    casex(exponent_input)
			25'b1_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=24;//{{{
			25'b0_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=23;
			25'b0_01xx_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=22;
			25'b0_001x_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=21;
			25'b0_0001_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=20;
			25'b0_0000_1xxx_xxxx_xxxx_xxxx_xxxx:exponent=19;
			25'b0_0000_01xx_xxxx_xxxx_xxxx_xxxx:exponent=18;
			25'b0_0000_001x_xxxx_xxxx_xxxx_xxxx:exponent=17;
			25'b0_0000_0001_xxxx_xxxx_xxxx_xxxx:exponent=16;
			25'b0_0000_0000_1xxx_xxxx_xxxx_xxxx:exponent=15;
			25'b0_0000_0000_01xx_xxxx_xxxx_xxxx:exponent=14;
			25'b0_0000_0000_001x_xxxx_xxxx_xxxx:exponent=13;
			25'b0_0000_0000_0001_xxxx_xxxx_xxxx:exponent=12;
			25'b0_0000_0000_0000_1xxx_xxxx_xxxx:exponent=11;
			25'b0_0000_0000_0000_01xx_xxxx_xxxx:exponent=10;
			25'b0_0000_0000_0000_001x_xxxx_xxxx:exponent= 9;
			25'b0_0000_0000_0000_0001_xxxx_xxxx:exponent= 8;
			25'b0_0000_0000_0000_0000_1xxx_xxxx:exponent= 7;
			25'b0_0000_0000_0000_0000_01xx_xxxx:exponent= 6;
			25'b0_0000_0000_0000_0000_001x_xxxx:exponent= 5;
			25'b0_0000_0000_0000_0000_0001_xxxx:exponent= 4;
			25'b0_0000_0000_0000_0000_0000_1xxx:exponent= 3;
			25'b0_0000_0000_0000_0000_0000_01xx:exponent= 2;
			25'b0_0000_0000_0000_0000_0000_001x:exponent= 1;
			25'b0_0000_0000_0000_0000_0000_0001:exponent= 0;
			25'b0_0000_0000_0000_0000_0000_0000:exponent= 0;//}}}
			default:exponent= 25'bx;
			endcase
		
	end

	always@(*)
	begin
	    case(table_input)
			0  :  table_output=0 ; //{{{
			1  :  table_output=1 ;
			2  :  table_output=1 ;
			3  :  table_output=1 ;
			4  :  table_output=2 ;
			5  :  table_output=2 ;
			6  :  table_output=2 ;
			7  :  table_output=3 ;
			8  :  table_output=3 ;
			9  :  table_output=4 ;
			10 :  table_output=4 ;
			11 :  table_output=4 ;
			12 :  table_output=5 ;
			13 :  table_output=5 ;
			14 :  table_output=5 ;
			15 :  table_output=6 ;
			16 :  table_output=6 ;
			17 :  table_output=6 ;
			18 :  table_output=7 ;
			19 :  table_output=7 ;
			20 :  table_output=7 ;
			21 :  table_output=8 ;
			22 :  table_output=8 ;
			23 :  table_output=8 ;
			24 :  table_output=9 ;
			25 :  table_output=9 ;
			26 :  table_output=9 ;
			27 :  table_output=10;
			28 :  table_output=10;
			29 :  table_output=10;
			30 :  table_output=11;
			31 :  table_output=11;
			32 :  table_output=11;
			33 :  table_output=12;
			34 :  table_output=12;
			35 :  table_output=12;
			36 :  table_output=12;
			37 :  table_output=13;
			38 :  table_output=13;
			39 :  table_output=13;
			40 :  table_output=14;
			41 :  table_output=14;
			42 :  table_output=14;
			43 :  table_output=15;
			44 :  table_output=15;
			45 :  table_output=15;
			46 :  table_output=16;
			47 :  table_output=16;
			48 :  table_output=16;
			49 :  table_output=16;
			50 :  table_output=17;
			51 :  table_output=17;
			52 :  table_output=17;
			53 :  table_output=18;
			54 :  table_output=18;
			55 :  table_output=18;
			56 :  table_output=19;
			57 :  table_output=19;
			58 :  table_output=19;
			59 :  table_output=19;
			60 :  table_output=20;
			61 :  table_output=20;
			62 :  table_output=20;
			63 :  table_output=21;
			64 :  table_output=21;
			65 :  table_output=21;
			66 :  table_output=21;
			67 :  table_output=22;
			68 :  table_output=22;
			69 :  table_output=22;
			70 :  table_output=23;
			71 :  table_output=23;
			72 :  table_output=23;
			73 :  table_output=23;
			74 :  table_output=24;
			75 :  table_output=24;
			76 :  table_output=24;
			77 :  table_output=25;
			78 :  table_output=25;
			79 :  table_output=25;
			80 :  table_output=25;
			81 :  table_output=26;
			82 :  table_output=26;
			83 :  table_output=26;
			84 :  table_output=26;
			85 :  table_output=27;
			86 :  table_output=27;
			87 :  table_output=27;
			88 :  table_output=28;
			89 :  table_output=28;
			90 :  table_output=28;
			91 :  table_output=28;
			92 :  table_output=29;
			93 :  table_output=29;
			94 :  table_output=29;
			95 :  table_output=29;
			96 :  table_output=30;
			97 :  table_output=30;
			98 :  table_output=30;
			99 :  table_output=30;
			100:  table_output=31;
			101:  table_output=31;
			102:  table_output=31;
			103:  table_output=31;
			104:  table_output=32;
			105:  table_output=32;
			106:  table_output=32;
			107:  table_output=32;
			108:  table_output=33;
			109:  table_output=33;
			110:  table_output=33;
			111:  table_output=34;
			112:  table_output=34;
			113:  table_output=34;
			114:  table_output=34;
			115:  table_output=35;
			116:  table_output=35;
			117:  table_output=35;
			118:  table_output=35;
			119:  table_output=35;
			120:  table_output=36;
			121:  table_output=36;
			122:  table_output=36;
			123:  table_output=36;
			124:  table_output=37;
			125:  table_output=37;
			126:  table_output=37;
			127:  table_output=37;
			128:  table_output=38;  
			129:  table_output=38;   
			130:  table_output=38;   
			131:  table_output=38;   
			132:  table_output=39;   
			133:  table_output=39;   
			134:  table_output=39;   
			135:  table_output=39;   
			136:  table_output=40;   
			137:  table_output=40;   
			138:  table_output=40;   
			139:  table_output=40;   
			140:  table_output=41;   
			141:  table_output=41;   
			142:  table_output=41;   
			143:  table_output=41;   
			144:  table_output=41;   
			145:  table_output=42;   
			146:  table_output=42;   
			147:  table_output=42;   
			148:  table_output=42;   
			149:  table_output=43;   
			150:  table_output=43;   
			151:  table_output=43;   
			152:  table_output=43;   
			153:  table_output=43;   
			154:  table_output=44;   
			155:  table_output=44;   
			156:  table_output=44;   
			157:  table_output=44;   
			158:  table_output=45;   
			159:  table_output=45;   
			160:  table_output=45;   
			161:  table_output=45;   
			162:  table_output=45;   
			163:  table_output=46;   
			164:  table_output=46;   
			165:  table_output=46;   
			166:  table_output=46;   
			167:  table_output=47;   
			168:  table_output=47;   
			169:  table_output=47;   
			170:  table_output=47;   
			171:  table_output=47;   
			172:  table_output=48;   
			173:  table_output=48;   
			174:  table_output=48;   
			175:  table_output=48;   
			176:  table_output=49;   
			177:  table_output=49;   
			178:  table_output=49;   
			179:  table_output=49;   
			180:  table_output=49;   
			181:  table_output=50;   
			182:  table_output=50;   
			183:  table_output=50;   
			184:  table_output=50;   
			185:  table_output=50;   
			186:  table_output=51;   
			187:  table_output=51;   
			188:  table_output=51;   
			189:  table_output=51;   
			190:  table_output=51;   
			191:  table_output=52;   
			192:  table_output=52;   
			193:  table_output=52;   
			194:  table_output=52;   
			195:  table_output=52;   
			196:  table_output=53;   
			197:  table_output=53;   
			198:  table_output=53;   
			199:  table_output=53;   
			200:  table_output=54;   
			201:  table_output=54;   
			202:  table_output=54;   
			203:  table_output=54;   
			204:  table_output=54;   
			205:  table_output=55;   
			206:  table_output=55;   
			207:  table_output=55;   
			208:  table_output=55;   
			209:  table_output=55;   
			210:  table_output=56;   
			211:  table_output=56;   
			212:  table_output=56;   
			213:  table_output=56;   
			214:  table_output=56;   
			215:  table_output=56;   
			216:  table_output=57;   
			217:  table_output=57;   
			218:  table_output=57;   
			219:  table_output=57;   
			220:  table_output=57;   
			221:  table_output=58;   
			222:  table_output=58;   
			223:  table_output=58;   
			224:  table_output=58;   
			225:  table_output=58;   
			226:  table_output=59;   
			227:  table_output=59;   
			228:  table_output=59;   
			229:  table_output=59;   
			230:  table_output=59;   
			231:  table_output=60;   
			232:  table_output=60;   
			233:  table_output=60;   
			234:  table_output=60;   
			235:  table_output=60;   
			236:  table_output=61;   
			237:  table_output=61;   
			238:  table_output=61;   
			239:  table_output=61;   
			240:  table_output=61;   
			241:  table_output=61;   
			242:  table_output=62;   
			243:  table_output=62;   
			244:  table_output=62;   
			245:  table_output=62;   
			246:  table_output=62;   
			247:  table_output=63;   
			248:  table_output=63;   
			249:  table_output=63;   
			250:  table_output=63;   
			251:  table_output=63;   
			252:  table_output=63;   
			253:  table_output=64;   
			254:  table_output=64;   
			255:  table_output=64;   
			default:table_output=7'bx ;//}}}
		endcase
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			read_start_delay1<=0;
		else if(rst_syn)
			read_start_delay1<=0;
		else read_start_delay1<=read_start;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			Y_U_V_over_counter<=0;
		else if(rst_syn)
			Y_U_V_over_counter<=0;
		else if(read_start&&(!read_start_delay1))
			Y_U_V_over_counter<=Y_U_V_over_counter+1;
		else if(state==CODEBLOCK_OVER&&last_codeblock_of_current_level)
		begin
			if(codeblock_counter==47)
				Y_U_V_over_counter<=Y_U_V_over_counter-3;
			else
				Y_U_V_over_counter<=Y_U_V_over_counter-1;
		end
		else if(tier1_over)begin		//////
			Y_U_V_over_counter<=0;		//////
		end								//////
	end
	
	
	always@(*)
	begin
	    if(data_current[16])
			data_current_tran=16'b1000_0000_0000_0000-data_current[15:0];
		else data_current_tran=16'b1000_0000_0000_0000+data_current[15:0];
	end
	always@(*)
	begin
	    if(data_left[16])
			data_left_tran=16'b1000_0000_0000_0000-data_left[15:0];
		else data_left_tran=16'b1000_0000_0000_0000+data_left[15:0];
	end
	always@(*)
	begin
	    if(data_upper[16])
			data_upper_tran=16'b1000_0000_0000_0000-data_upper[15:0];
		else data_upper_tran=16'b1000_0000_0000_0000+data_upper[15:0];
	end
	always@(*)
	begin
		if(!(state==TIER1_WORKING||state==CALC_LOG))
		begin
			case(codeblock_counter)
				2,5,8,11,14,17,20,23,26,29,32,35,47:
					last_codeblock_of_current_level=1;
				default:last_codeblock_of_current_level=0;
			endcase
		end 
		else last_codeblock_of_current_level=0;
	end
	always@(*)
	begin
	    case(codeblock_counter)
			0,3,6,9,12,15,18,21,24,27,30,33,36,39,42:
				data_from_ram=data_HH;
			1,4,7,10,13,16,19,22,25,28,31,34,37,40,43:
				data_from_ram=data_LH;
			2,5,8,11,14,17,20,23,26,29,32,35,38,41,44:
				data_from_ram=data_HL;
			45,46,47:data_from_ram=data_LL;
			default:data_from_ram=17'bx;
	    endcase
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			total_entropy<=0;
		else if(rst_syn)
			total_entropy<=0;
		else if(codeblock_over_delay_3)
			total_entropy<=total_entropy+entropy_codeblock;
		else if(calc_log&&codeblock_counter==3)
			total_entropy<=log_result;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			data_current_tran_delay<=0;
		else if(rst_syn)
			data_current_tran_delay<=0;
		else data_current_tran_delay<=data_current_tran;
	end
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			first_row<=0;
		else if(rst_syn)
			first_row<=0;
		else if(row_counter==0)
			first_row<=1;
		else first_row<=0;
	end
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			first_row_delay<=0;
		else if(rst_syn)
			first_row_delay<=0;
		else first_row_delay<=first_row;
	end
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			first_row_delay_1<=0;
		else if(rst_syn)
			first_row_delay_1<=0;
		else first_row_delay_1<=first_row_delay;
	end


	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			entropy_LL5_Y<=0;//{{{
			entropy_LL5_U<=0;
			entropy_LL5_V<=0;
			entropy_HL5_Y<=0;
			entropy_HL5_U<=0;
			entropy_HL5_V<=0;
			entropy_LH5_Y<=0;
			entropy_LH5_U<=0;
			entropy_LH5_V<=0;
			entropy_HH5_Y<=0;
			entropy_HH5_U<=0;
			entropy_HH5_V<=0;
			entropy_HL4_Y<=0;
			entropy_HL4_U<=0;
			entropy_HL4_V<=0;
			entropy_LH4_Y<=0;
			entropy_LH4_U<=0;
			entropy_LH4_V<=0;
			entropy_HH4_Y<=0;
			entropy_HH4_U<=0;
			entropy_HH4_V<=0;
			entropy_HL3_Y<=0;
			entropy_HL3_U<=0;
			entropy_HL3_V<=0;
			entropy_LH3_Y<=0;
			entropy_LH3_U<=0;
			entropy_LH3_V<=0;
			entropy_HH3_Y<=0;
			entropy_HH3_U<=0;
			entropy_HH3_V<=0;
			entropy_HL2_Y<=0;
			entropy_HL2_U<=0;
			entropy_HL2_V<=0;
			entropy_LH2_Y<=0;
			entropy_LH2_U<=0;
			entropy_LH2_V<=0;
			entropy_HH2_Y<=0;
			entropy_HH2_U<=0;
			entropy_HH2_V<=0;
			entropy_HL1_Y<=0;
			entropy_HL1_U<=0;
			entropy_HL1_V<=0;
			entropy_LH1_Y<=0;
			entropy_LH1_U<=0;
			entropy_LH1_V<=0;
			entropy_HH1_Y<=0;
			entropy_HH1_U<=0;
			entropy_HH1_V<=0;//}}}
		end
		else if(rst_syn)
		begin
			entropy_LL5_Y<=0;
			entropy_LL5_U<=0;
			entropy_LL5_V<=0;
			entropy_HL5_Y<=0;
			entropy_HL5_U<=0;
			entropy_HL5_V<=0;
			entropy_LH5_Y<=0;
			entropy_LH5_U<=0;
			entropy_LH5_V<=0;
			entropy_HH5_Y<=0;
			entropy_HH5_U<=0;
			entropy_HH5_V<=0;
			entropy_HL4_Y<=0;
			entropy_HL4_U<=0;
			entropy_HL4_V<=0;
			entropy_LH4_Y<=0;
			entropy_LH4_U<=0;
			entropy_LH4_V<=0;
			entropy_HH4_Y<=0;
			entropy_HH4_U<=0;
			entropy_HH4_V<=0;
			entropy_HL3_Y<=0;
			entropy_HL3_U<=0;
			entropy_HL3_V<=0;
			entropy_LH3_Y<=0;
			entropy_LH3_U<=0;
			entropy_LH3_V<=0;
			entropy_HH3_Y<=0;
			entropy_HH3_U<=0;
			entropy_HH3_V<=0;
			entropy_HL2_Y<=0;
			entropy_HL2_U<=0;
			entropy_HL2_V<=0;
			entropy_LH2_Y<=0;
			entropy_LH2_U<=0;
			entropy_LH2_V<=0;
			entropy_HH2_Y<=0;
			entropy_HH2_U<=0;
			entropy_HH2_V<=0;
			entropy_HL1_Y<=0;
			entropy_HL1_U<=0;
			entropy_HL1_V<=0;
			entropy_LH1_Y<=0;
			entropy_LH1_U<=0;
			entropy_LH1_V<=0;
			entropy_HH1_Y<=0;
			entropy_HH1_U<=0;
			entropy_HH1_V<=0;
		end
		else if(codeblock_over_delay_3)
		begin
			case(codeblock_counter)
				1:entropy_HH1_Y<=entropy_codeblock;//{{{
				2:entropy_LH1_Y<=entropy_codeblock;
				3:entropy_HL1_Y<=entropy_codeblock;
				4:entropy_HH1_U<=entropy_codeblock;
				5:entropy_LH1_U<=entropy_codeblock;
				6:entropy_HL1_U<=entropy_codeblock;
				7:entropy_HH1_V<=entropy_codeblock;
				8:entropy_LH1_V<=entropy_codeblock;
				9:entropy_HL1_V<=entropy_codeblock;
				10:entropy_HH2_Y<=entropy_codeblock;
				11:entropy_LH2_Y<=entropy_codeblock;
				12:entropy_HL2_Y<=entropy_codeblock;
				13:entropy_HH2_U<=entropy_codeblock;
				14:entropy_LH2_U<=entropy_codeblock;
				15:entropy_HL2_U<=entropy_codeblock;
				16:entropy_HH2_V<=entropy_codeblock;
				17:entropy_LH2_V<=entropy_codeblock;
				18:entropy_HL2_V<=entropy_codeblock;
				19:entropy_HH3_Y<=entropy_codeblock;
				20:entropy_LH3_Y<=entropy_codeblock;
				21:entropy_HL3_Y<=entropy_codeblock;
				22:entropy_HH3_U<=entropy_codeblock;
				23:entropy_LH3_U<=entropy_codeblock;
				24:entropy_HL3_U<=entropy_codeblock;
				25:entropy_HH3_V<=entropy_codeblock;
				26:entropy_LH3_V<=entropy_codeblock;
				27:entropy_HL3_V<=entropy_codeblock;
				28:entropy_HH4_Y<=entropy_codeblock;
				29:entropy_LH4_Y<=entropy_codeblock;
				30:entropy_HL4_Y<=entropy_codeblock;
				31:entropy_HH4_U<=entropy_codeblock;
				32:entropy_LH4_U<=entropy_codeblock;
				33:entropy_HL4_U<=entropy_codeblock;
				34:entropy_HH4_V<=entropy_codeblock;
				35:entropy_LH4_V<=entropy_codeblock;
				36:entropy_HL4_V<=entropy_codeblock;
				37:entropy_HH5_Y<=entropy_codeblock;
				38:entropy_LH5_Y<=entropy_codeblock;
				39:entropy_HL5_Y<=entropy_codeblock;
				40:entropy_HH5_U<=entropy_codeblock;
				41:entropy_LH5_U<=entropy_codeblock;
				42:entropy_HL5_U<=entropy_codeblock;
				43:entropy_HH5_V<=entropy_codeblock;
				44:entropy_LH5_V<=entropy_codeblock;
				45:entropy_HL5_V<=entropy_codeblock;
				46:entropy_LL5_Y<=entropy_codeblock;
				47:entropy_LL5_U<=entropy_codeblock;
				48:entropy_LL5_V<=entropy_codeblock;//}}}
			endcase
		end
		else if(calc_log)//entropy_LL5_Y and others are used to store the byte_allocate when calc_log is asserted
		begin
			case(codeblock_counter)
				5:entropy_LL5_Y<=byte_allocate;		//5:entropy_LL5_Y<=byte_allocate;//{{{
				6:entropy_LL5_U<=byte_allocate;		//6:entropy_LL5_U<=byte_allocate;
				7:entropy_LL5_V<=byte_allocate;		//7:entropy_LL5_V<=byte_allocate;
				8:entropy_HL5_Y<=byte_allocate;		//8:entropy_HL5_Y<=byte_allocate;
				9:entropy_LH5_Y<=byte_allocate;		//9:entropy_HL5_U<=byte_allocate;
				10:entropy_HH5_Y<=byte_allocate;	//10:entropy_HL5_V<=byte_allocate;
				11:entropy_HL5_U<=byte_allocate;	//11:entropy_LH5_Y<=byte_allocate;
				12:entropy_LH5_U<=byte_allocate;	//12:entropy_LH5_U<=byte_allocate;
				13:entropy_HH5_U<=byte_allocate;	//13:entropy_LH5_V<=byte_allocate;
				14:entropy_HL5_V<=byte_allocate;	//14:entropy_HH5_Y<=byte_allocate;
				15:entropy_LH5_V<=byte_allocate;	//15:entropy_HH5_U<=byte_allocate;
				16:entropy_HH5_V<=byte_allocate;	//16:entropy_HH5_V<=byte_allocate;
				17:entropy_HL4_Y<=byte_allocate;	//17:entropy_HL4_Y<=byte_allocate;
				18:entropy_LH4_Y<=byte_allocate;	//18:entropy_HL4_U<=byte_allocate;
				19:entropy_HH4_Y<=byte_allocate;	//19:entropy_HL4_V<=byte_allocate;
				20:entropy_HL4_U<=byte_allocate;	//20:entropy_LH4_Y<=byte_allocate;
				21:entropy_LH4_U<=byte_allocate;	//21:entropy_LH4_U<=byte_allocate;
				22:entropy_HH4_U<=byte_allocate;	//22:entropy_LH4_V<=byte_allocate;
				23:entropy_HL4_V<=byte_allocate;	//23:entropy_HH4_Y<=byte_allocate;
				24:entropy_LH4_V<=byte_allocate;	//24:entropy_HH4_U<=byte_allocate;
				25:entropy_HH4_V<=byte_allocate;	//25:entropy_HH4_V<=byte_allocate;
				26:entropy_HL3_Y<=byte_allocate;	//26:entropy_HL3_Y<=byte_allocate;
				27:entropy_LH3_Y<=byte_allocate;	//27:entropy_HL3_U<=byte_allocate;
				28:entropy_HH3_Y<=byte_allocate;	//28:entropy_HL3_V<=byte_allocate;
				29:entropy_HL3_U<=byte_allocate;	//29:entropy_LH3_Y<=byte_allocate;
				30:entropy_LH3_U<=byte_allocate;	//30:entropy_LH3_U<=byte_allocate;
				31:entropy_HH3_U<=byte_allocate;	//31:entropy_LH3_V<=byte_allocate;
				32:entropy_HL3_V<=byte_allocate;	//32:entropy_HH3_Y<=byte_allocate;
				33:entropy_LH3_V<=byte_allocate;	//33:entropy_HH3_U<=byte_allocate;
				34:entropy_HH3_V<=byte_allocate;	//34:entropy_HH3_V<=byte_allocate;
				35:entropy_HL2_Y<=byte_allocate;	//35:entropy_HL2_Y<=byte_allocate;
				36:entropy_LH2_Y<=byte_allocate;	//36:entropy_HL2_U<=byte_allocate;
				37:entropy_HH2_Y<=byte_allocate;	//37:entropy_HL2_V<=byte_allocate;
				38:entropy_HL2_U<=byte_allocate;	//38:entropy_LH2_Y<=byte_allocate;
				39:entropy_LH2_U<=byte_allocate;	//39:entropy_LH2_U<=byte_allocate;
				40:entropy_HH2_U<=byte_allocate;	//40:entropy_LH2_V<=byte_allocate;
				41:entropy_HL2_V<=byte_allocate;	//41:entropy_HH2_Y<=byte_allocate;
				42:entropy_LH2_V<=byte_allocate;	//42:entropy_HH2_U<=byte_allocate;
				43:entropy_HH2_V<=byte_allocate;	//43:entropy_HH2_V<=byte_allocate;
				44:entropy_HL1_Y<=byte_allocate;	//44:entropy_HL1_Y<=byte_allocate;
				45:entropy_LH1_Y<=byte_allocate;	//45:entropy_HL1_U<=byte_allocate;
				46:entropy_HH1_Y<=byte_allocate;	//46:entropy_HL1_V<=byte_allocate;
				47:entropy_HL1_U<=byte_allocate;	//47:entropy_LH1_Y<=byte_allocate;
				48:entropy_LH1_U<=byte_allocate;	//48:entropy_LH1_U<=byte_allocate;
				49:entropy_HH1_U<=byte_allocate;	//49:entropy_LH1_V<=byte_allocate;
				50:entropy_HL1_V<=byte_allocate;	//50:entropy_HH1_Y<=byte_allocate;
				51:entropy_LH1_V<=byte_allocate;	//51:entropy_HH1_U<=byte_allocate;
				52:entropy_HH1_V<=byte_allocate;	//52:entropy_HH1_V<=byte_allocate;//}}}
			endcase
		end 
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			codeblock_over_delay_1<=0;
		else if(rst_syn)
			codeblock_over_delay_1<=0;	
		else codeblock_over_delay_1<=codeblock_over_delay;
	end
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			codeblock_over_delay_2<=0;
		else if(rst_syn)
			codeblock_over_delay_2<=0;	
		else codeblock_over_delay_2<=codeblock_over_delay_1;
	end
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			codeblock_over_delay_3<=0;
		else if(rst_syn)
			codeblock_over_delay_3<=0;	
		else codeblock_over_delay_3<=codeblock_over_delay_2;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			codeblock_over_delay<=0;
		else if(rst_syn)
			codeblock_over_delay<=0;
		else codeblock_over_delay<=codeblock_over;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			codeblock_over<=0;
		else if(rst_syn)
			codeblock_over<=0;
		else if(state==CODEBLOCK_OVER)
			codeblock_over<=1;
		else codeblock_over<=0;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			entropy_codeblock<=0;
		else if(rst_syn)
			entropy_codeblock<=0;	
		else if(codeblock_over_delay_3)
			entropy_codeblock<=0;
		else if(sum_entropy_vld)
		begin
			if(entropy_codeblock+difference>=20'b1111_1111_1111_1111_1111)
			begin
				$display("overflow!!");
			end 
			entropy_codeblock<=entropy_codeblock+difference;
		end 
		else if(calc_log||tier1_working)
		begin
			case(codeblock_counter)
				0:entropy_codeblock<=entropy_LL5_Y;		//0:entropy_codeblock<=entropy_LL5_Y;//{{{
				1:entropy_codeblock<=entropy_LL5_U;		//1:entropy_codeblock<=entropy_LL5_U;
				2:entropy_codeblock<=entropy_LL5_V;		//2:entropy_codeblock<=entropy_LL5_V;
				3:entropy_codeblock<=entropy_HL5_Y;		//3:entropy_codeblock<=entropy_HL5_Y;
				4:entropy_codeblock<=entropy_LH5_Y;		//4:entropy_codeblock<=entropy_HL5_U;
				5:entropy_codeblock<=entropy_HH5_Y;		//5:entropy_codeblock<=entropy_HL5_V;
				6:entropy_codeblock<=entropy_HL5_U;		//6:entropy_codeblock<=entropy_LH5_Y;
				7:entropy_codeblock<=entropy_LH5_U;		//7:entropy_codeblock<=entropy_LH5_U;
				8:entropy_codeblock<=entropy_HH5_U;		//8:entropy_codeblock<=entropy_LH5_V;
				9:entropy_codeblock<=entropy_HL5_V;		//9:entropy_codeblock<=entropy_HH5_Y;
				10:entropy_codeblock<=entropy_LH5_V;	//10:entropy_codeblock<=entropy_HH5_U;
				11:entropy_codeblock<=entropy_HH5_V;	//11:entropy_codeblock<=entropy_HH5_V;
				12:entropy_codeblock<=entropy_HL4_Y;	//12:entropy_codeblock<=entropy_HL4_Y;
				13:entropy_codeblock<=entropy_LH4_Y;	//13:entropy_codeblock<=entropy_HL4_U;
				14:entropy_codeblock<=entropy_HH4_Y;	//14:entropy_codeblock<=entropy_HL4_V;
				15:entropy_codeblock<=entropy_HL4_U;	//15:entropy_codeblock<=entropy_LH4_Y;
				16:entropy_codeblock<=entropy_LH4_U;	//16:entropy_codeblock<=entropy_LH4_U;
				17:entropy_codeblock<=entropy_HH4_U;	//17:entropy_codeblock<=entropy_LH4_V;
				18:entropy_codeblock<=entropy_HL4_V;	//18:entropy_codeblock<=entropy_HH4_Y;
				19:entropy_codeblock<=entropy_LH4_V;	//19:entropy_codeblock<=entropy_HH4_U;
				20:entropy_codeblock<=entropy_HH4_V;	//20:entropy_codeblock<=entropy_HH4_V;
				21:entropy_codeblock<=entropy_HL3_Y;	//21:entropy_codeblock<=entropy_HL3_Y;
				22:entropy_codeblock<=entropy_LH3_Y;	//22:entropy_codeblock<=entropy_HL3_U;
				23:entropy_codeblock<=entropy_HH3_Y;	//23:entropy_codeblock<=entropy_HL3_V;
				24:entropy_codeblock<=entropy_HL3_U;	//24:entropy_codeblock<=entropy_LH3_Y;
				25:entropy_codeblock<=entropy_LH3_U;	//25:entropy_codeblock<=entropy_LH3_U;
				26:entropy_codeblock<=entropy_HH3_U;	//26:entropy_codeblock<=entropy_LH3_V;
				27:entropy_codeblock<=entropy_HL3_V;	//27:entropy_codeblock<=entropy_HH3_Y;
				28:entropy_codeblock<=entropy_LH3_V;	//28:entropy_codeblock<=entropy_HH3_U;
				29:entropy_codeblock<=entropy_HH3_V;	//29:entropy_codeblock<=entropy_HH3_V;
				30:entropy_codeblock<=entropy_HL2_Y;	//30:entropy_codeblock<=entropy_HL2_Y;
				31:entropy_codeblock<=entropy_LH2_Y;	//31:entropy_codeblock<=entropy_HL2_U;
				32:entropy_codeblock<=entropy_HH2_Y;	//32:entropy_codeblock<=entropy_HL2_V;
				33:entropy_codeblock<=entropy_HL2_U;	//33:entropy_codeblock<=entropy_LH2_Y;
				34:entropy_codeblock<=entropy_LH2_U;	//34:entropy_codeblock<=entropy_LH2_U;
				35:entropy_codeblock<=entropy_HH2_U;	//35:entropy_codeblock<=entropy_LH2_V;
				36:entropy_codeblock<=entropy_HL2_V;	//36:entropy_codeblock<=entropy_HH2_Y;
				37:entropy_codeblock<=entropy_LH2_V;	//37:entropy_codeblock<=entropy_HH2_U;
				38:entropy_codeblock<=entropy_HH2_V;	//38:entropy_codeblock<=entropy_HH2_V;
				39:entropy_codeblock<=entropy_HL1_Y;	//39:entropy_codeblock<=entropy_HL1_Y;
				40:entropy_codeblock<=entropy_LH1_Y;	//40:entropy_codeblock<=entropy_HL1_U;
				41:entropy_codeblock<=entropy_HH1_Y;	//41:entropy_codeblock<=entropy_HL1_V;
				42:entropy_codeblock<=entropy_HL1_U;	//42:entropy_codeblock<=entropy_LH1_Y;
				43:entropy_codeblock<=entropy_LH1_U;	//43:entropy_codeblock<=entropy_LH1_U;
				44:entropy_codeblock<=entropy_HH1_U;	//44:entropy_codeblock<=entropy_LH1_V;
				45:entropy_codeblock<=entropy_HL1_V;	//45:entropy_codeblock<=entropy_HH1_Y;
				46:entropy_codeblock<=entropy_LH1_V;	//46:entropy_codeblock<=entropy_HH1_U;
				47:entropy_codeblock<=entropy_HH1_V;	//47:entropy_codeblock<=entropy_HH1_V;//}}}
			endcase
		end 
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			difference<=0;
		else if(rst_syn)
			difference<=0;	
		else if(fetch_data_index==2&&first_row)
			difference<=0;// do not compute for the first data of each codeblock
		else if(get_entropy_vld)
		begin
			if(data_current_tran_delay>=data_bar)
				difference<=data_current_tran_delay-data_bar;
			else difference<=data_bar-data_current_tran_delay;
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			data_bar<=0;
		else if(rst_syn)
			data_bar<=0;
		else if(get_data_bar_vld)
		begin
			if(first_row_delay_1)// the first row
				data_bar<=data_left_tran;
			else if(fetch_data_index==1)// the first column
				data_bar<=data_upper_tran;
			else
			begin
				if(data_current_tran>=data_left_tran&&data_current_tran>=data_upper_tran)
				begin
					if(data_left_tran<=data_upper_tran)
						data_bar<=data_left_tran;
					else data_bar<=data_upper_tran;
				end
				else if(data_current_tran<=data_left_tran&&data_current_tran<=data_upper_tran)
				begin
					if(data_left_tran>=data_upper_tran)
						data_bar<=data_left_tran;
					else data_bar<=data_upper_tran;
				end
				else
				begin
					data_bar<=data_left_tran+data_upper_tran-data_current_tran;
				end
			end
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			sum_entropy_vld<=0;
		else if(rst_syn)
			sum_entropy_vld<=0;
		else sum_entropy_vld<=get_entropy_vld;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			get_entropy_vld<=0;
		else if(rst_syn)
			get_entropy_vld<=0;
		else get_entropy_vld<=get_data_bar_vld;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			get_data_bar_vld<=0;
		else if(rst_syn)
			get_data_bar_vld<=0;
		else get_data_bar_vld<=fetch_data_vld;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			codeblock_counter<=0;
		else if(rst_syn)
			codeblock_counter<=0;
		else if(all_codeblock_over&&codeblock_over_delay_3||((nextstate==TIER1_WORKING)&&(state==CALC_LOG)))
			codeblock_counter<=0;
		else if(state==CODEBLOCK_OVER||calc_log)
			codeblock_counter<=codeblock_counter+1;
		else if(state==TIER1_WORKING)
		begin
			if(one_codeblock_over)
				codeblock_counter<=codeblock_counter+1;
		end 
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			data_upper<=0;
		else if(rst_syn)
			data_upper<=0;
		else if(fetch_data_vld)
		begin
			if(data_sel_delay&&(!row_counter==0))
				case(fetch_data_index)
					0:data_upper<=data_reg_0_0;//{{{
					1:data_upper<=data_reg_0_1;
					2:data_upper<=data_reg_0_2;
					3:data_upper<=data_reg_0_3;
					4:data_upper<=data_reg_0_4;
					5:data_upper<=data_reg_0_5;
					6:data_upper<=data_reg_0_6;
					7:data_upper<=data_reg_0_7;
					8:data_upper<=data_reg_0_8;
					9:data_upper<=data_reg_0_9;
					10:data_upper<=data_reg_0_10;
					11:data_upper<=data_reg_0_11;
					12:data_upper<=data_reg_0_12;
					13:data_upper<=data_reg_0_13;
					14:data_upper<=data_reg_0_14;
					15:data_upper<=data_reg_0_15;
					16:data_upper<=data_reg_0_16;
					17:data_upper<=data_reg_0_17;
					18:data_upper<=data_reg_0_18;
					19:data_upper<=data_reg_0_19;
					20:data_upper<=data_reg_0_20;
					21:data_upper<=data_reg_0_21;
					22:data_upper<=data_reg_0_22;
					23:data_upper<=data_reg_0_23;
					24:data_upper<=data_reg_0_24;
					25:data_upper<=data_reg_0_25;
					26:data_upper<=data_reg_0_26;
					27:data_upper<=data_reg_0_27;
					28:data_upper<=data_reg_0_28;
					29:data_upper<=data_reg_0_29;
					30:data_upper<=data_reg_0_30;
					31:data_upper<=data_reg_0_31;
					32:data_upper<=data_reg_0_32;
					33:data_upper<=data_reg_0_33;
					34:data_upper<=data_reg_0_34;
					35:data_upper<=data_reg_0_35;
					36:data_upper<=data_reg_0_36;
					37:data_upper<=data_reg_0_37;
					38:data_upper<=data_reg_0_38;
					39:data_upper<=data_reg_0_39;
					40:data_upper<=data_reg_0_40;
					41:data_upper<=data_reg_0_41;
					42:data_upper<=data_reg_0_42;
					43:data_upper<=data_reg_0_43;
					44:data_upper<=data_reg_0_44;
					45:data_upper<=data_reg_0_45;
					46:data_upper<=data_reg_0_46;
					47:data_upper<=data_reg_0_47;
					48:data_upper<=data_reg_0_48;
					49:data_upper<=data_reg_0_49;
					50:data_upper<=data_reg_0_50;
					51:data_upper<=data_reg_0_51;
					52:data_upper<=data_reg_0_52;
					53:data_upper<=data_reg_0_53;
					54:data_upper<=data_reg_0_54;
					55:data_upper<=data_reg_0_55;
					56:data_upper<=data_reg_0_56;
					57:data_upper<=data_reg_0_57;
					58:data_upper<=data_reg_0_58;
					59:data_upper<=data_reg_0_59;
					60:data_upper<=data_reg_0_60;
					61:data_upper<=data_reg_0_61;
					62:data_upper<=data_reg_0_62;
					63:data_upper<=data_reg_0_63;
				endcase//}}}
			else
			begin
				case(fetch_data_index)
					0:data_upper<=data_reg_1_0;//{{{
					1:data_upper<=data_reg_1_1;
					2:data_upper<=data_reg_1_2;
					3:data_upper<=data_reg_1_3;
					4:data_upper<=data_reg_1_4;
					5:data_upper<=data_reg_1_5;
					6:data_upper<=data_reg_1_6;
					7:data_upper<=data_reg_1_7;
					8:data_upper<=data_reg_1_8;
					9:data_upper<=data_reg_1_9;
					10:data_upper<=data_reg_1_10;
					11:data_upper<=data_reg_1_11;
					12:data_upper<=data_reg_1_12;
					13:data_upper<=data_reg_1_13;
					14:data_upper<=data_reg_1_14;
					15:data_upper<=data_reg_1_15;
					16:data_upper<=data_reg_1_16;
					17:data_upper<=data_reg_1_17;
					18:data_upper<=data_reg_1_18;
					19:data_upper<=data_reg_1_19;
					20:data_upper<=data_reg_1_20;
					21:data_upper<=data_reg_1_21;
					22:data_upper<=data_reg_1_22;
					23:data_upper<=data_reg_1_23;
					24:data_upper<=data_reg_1_24;
					25:data_upper<=data_reg_1_25;
					26:data_upper<=data_reg_1_26;
					27:data_upper<=data_reg_1_27;
					28:data_upper<=data_reg_1_28;
					29:data_upper<=data_reg_1_29;
					30:data_upper<=data_reg_1_30;
					31:data_upper<=data_reg_1_31;
					32:data_upper<=data_reg_1_32;
					33:data_upper<=data_reg_1_33;
					34:data_upper<=data_reg_1_34;
					35:data_upper<=data_reg_1_35;
					36:data_upper<=data_reg_1_36;
					37:data_upper<=data_reg_1_37;
					38:data_upper<=data_reg_1_38;
					39:data_upper<=data_reg_1_39;
					40:data_upper<=data_reg_1_40;
					41:data_upper<=data_reg_1_41;
					42:data_upper<=data_reg_1_42;
					43:data_upper<=data_reg_1_43;
					44:data_upper<=data_reg_1_44;
					45:data_upper<=data_reg_1_45;
					46:data_upper<=data_reg_1_46;
					47:data_upper<=data_reg_1_47;
					48:data_upper<=data_reg_1_48;
					49:data_upper<=data_reg_1_49;
					50:data_upper<=data_reg_1_50;
					51:data_upper<=data_reg_1_51;
					52:data_upper<=data_reg_1_52;
					53:data_upper<=data_reg_1_53;
					54:data_upper<=data_reg_1_54;
					55:data_upper<=data_reg_1_55;
					56:data_upper<=data_reg_1_56;
					57:data_upper<=data_reg_1_57;
					58:data_upper<=data_reg_1_58;
					59:data_upper<=data_reg_1_59;
					60:data_upper<=data_reg_1_60;
					61:data_upper<=data_reg_1_61;
					62:data_upper<=data_reg_1_62;
					63:data_upper<=data_reg_1_63;
				endcase//}}}
			end
		end
	end
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			data_left<=0;
		else if(rst_syn)
			data_left<=0;
		else if(fetch_data_vld)
		begin
			if(data_sel_delay)
				case(fetch_data_index)//{{{
					1:data_left<=data_reg_1_0;
					2:data_left<=data_reg_1_1;
					3:data_left<=data_reg_1_2;
					4:data_left<=data_reg_1_3;
					5:data_left<=data_reg_1_4;
					6:data_left<=data_reg_1_5;
					7:data_left<=data_reg_1_6;
					8:data_left<=data_reg_1_7;
					9:data_left<=data_reg_1_8;
					10:data_left<=data_reg_1_9;
					11:data_left<=data_reg_1_10;
					12:data_left<=data_reg_1_11;
					13:data_left<=data_reg_1_12;
					14:data_left<=data_reg_1_13;
					15:data_left<=data_reg_1_14;
					16:data_left<=data_reg_1_15;
					17:data_left<=data_reg_1_16;
					18:data_left<=data_reg_1_17;
					19:data_left<=data_reg_1_18;
					20:data_left<=data_reg_1_19;
					21:data_left<=data_reg_1_20;
					22:data_left<=data_reg_1_21;
					23:data_left<=data_reg_1_22;
					24:data_left<=data_reg_1_23;
					25:data_left<=data_reg_1_24;
					26:data_left<=data_reg_1_25;
					27:data_left<=data_reg_1_26;
					28:data_left<=data_reg_1_27;
					29:data_left<=data_reg_1_28;
					30:data_left<=data_reg_1_29;
					31:data_left<=data_reg_1_30;
					32:data_left<=data_reg_1_31;
					33:data_left<=data_reg_1_32;
					34:data_left<=data_reg_1_33;
					35:data_left<=data_reg_1_34;
					36:data_left<=data_reg_1_35;
					37:data_left<=data_reg_1_36;
					38:data_left<=data_reg_1_37;
					39:data_left<=data_reg_1_38;
					40:data_left<=data_reg_1_39;
					41:data_left<=data_reg_1_40;
					42:data_left<=data_reg_1_41;
					43:data_left<=data_reg_1_42;
					44:data_left<=data_reg_1_43;
					45:data_left<=data_reg_1_44;
					46:data_left<=data_reg_1_45;
					47:data_left<=data_reg_1_46;
					48:data_left<=data_reg_1_47;
					49:data_left<=data_reg_1_48;
					50:data_left<=data_reg_1_49;
					51:data_left<=data_reg_1_50;
					52:data_left<=data_reg_1_51;
					53:data_left<=data_reg_1_52;
					54:data_left<=data_reg_1_53;
					55:data_left<=data_reg_1_54;
					56:data_left<=data_reg_1_55;
					57:data_left<=data_reg_1_56;
					58:data_left<=data_reg_1_57;
					59:data_left<=data_reg_1_58;
					60:data_left<=data_reg_1_59;
					61:data_left<=data_reg_1_60;
					62:data_left<=data_reg_1_61;
					63:data_left<=data_reg_1_62;
				endcase//}}}
			else
				case(fetch_data_index)//{{{
					1:data_left<=data_reg_0_0;
					2:data_left<=data_reg_0_1;
					3:data_left<=data_reg_0_2;
					4:data_left<=data_reg_0_3;
					5:data_left<=data_reg_0_4;
					6:data_left<=data_reg_0_5;
					7:data_left<=data_reg_0_6;
					8:data_left<=data_reg_0_7;
					9:data_left<=data_reg_0_8;
					10:data_left<=data_reg_0_9;
					11:data_left<=data_reg_0_10;
					12:data_left<=data_reg_0_11;
					13:data_left<=data_reg_0_12;
					14:data_left<=data_reg_0_13;
					15:data_left<=data_reg_0_14;
					16:data_left<=data_reg_0_15;
					17:data_left<=data_reg_0_16;
					18:data_left<=data_reg_0_17;
					19:data_left<=data_reg_0_18;
					20:data_left<=data_reg_0_19;
					21:data_left<=data_reg_0_20;
					22:data_left<=data_reg_0_21;
					23:data_left<=data_reg_0_22;
					24:data_left<=data_reg_0_23;
					25:data_left<=data_reg_0_24;
					26:data_left<=data_reg_0_25;
					27:data_left<=data_reg_0_26;
					28:data_left<=data_reg_0_27;
					29:data_left<=data_reg_0_28;
					30:data_left<=data_reg_0_29;
					31:data_left<=data_reg_0_30;
					32:data_left<=data_reg_0_31;
					33:data_left<=data_reg_0_32;
					34:data_left<=data_reg_0_33;
					35:data_left<=data_reg_0_34;
					36:data_left<=data_reg_0_35;
					37:data_left<=data_reg_0_36;
					38:data_left<=data_reg_0_37;
					39:data_left<=data_reg_0_38;
					40:data_left<=data_reg_0_39;
					41:data_left<=data_reg_0_40;
					42:data_left<=data_reg_0_41;
					43:data_left<=data_reg_0_42;
					44:data_left<=data_reg_0_43;
					45:data_left<=data_reg_0_44;
					46:data_left<=data_reg_0_45;
					47:data_left<=data_reg_0_46;
					48:data_left<=data_reg_0_47;
					49:data_left<=data_reg_0_48;
					50:data_left<=data_reg_0_49;
					51:data_left<=data_reg_0_50;
					52:data_left<=data_reg_0_51;
					53:data_left<=data_reg_0_52;
					54:data_left<=data_reg_0_53;
					55:data_left<=data_reg_0_54;
					56:data_left<=data_reg_0_55;
					57:data_left<=data_reg_0_56;
					58:data_left<=data_reg_0_57;
					59:data_left<=data_reg_0_58;
					60:data_left<=data_reg_0_59;
					61:data_left<=data_reg_0_60;
					62:data_left<=data_reg_0_61;
					63:data_left<=data_reg_0_62;
				endcase//}}}
		end
	end
	
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			data_sel_delay<=0;
		else if(rst_syn)
			data_sel_delay<=0;
		else data_sel_delay<=data_sel;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			data_current<=0;
		else if(rst_syn)
			data_current<=0;
		else if(fetch_data_vld)
		begin
			if(data_sel_delay)
			begin
				case(fetch_data_index)//{{{
					0:data_current<=data_reg_1_0;
					1:data_current<=data_reg_1_1;
					2:data_current<=data_reg_1_2;
					3:data_current<=data_reg_1_3;
					4:data_current<=data_reg_1_4;
					5:data_current<=data_reg_1_5;
					6:data_current<=data_reg_1_6;
					7:data_current<=data_reg_1_7;
					8:data_current<=data_reg_1_8;
					9:data_current<=data_reg_1_9;
					10:data_current<=data_reg_1_10;
					11:data_current<=data_reg_1_11;
					12:data_current<=data_reg_1_12;
					13:data_current<=data_reg_1_13;
					14:data_current<=data_reg_1_14;
					15:data_current<=data_reg_1_15;
					16:data_current<=data_reg_1_16;
					17:data_current<=data_reg_1_17;
					18:data_current<=data_reg_1_18;
					19:data_current<=data_reg_1_19;
					20:data_current<=data_reg_1_20;
					21:data_current<=data_reg_1_21;
					22:data_current<=data_reg_1_22;
					23:data_current<=data_reg_1_23;
					24:data_current<=data_reg_1_24;
					25:data_current<=data_reg_1_25;
					26:data_current<=data_reg_1_26;
					27:data_current<=data_reg_1_27;
					28:data_current<=data_reg_1_28;
					29:data_current<=data_reg_1_29;
					30:data_current<=data_reg_1_30;
					31:data_current<=data_reg_1_31;
					32:data_current<=data_reg_1_32;
					33:data_current<=data_reg_1_33;
					34:data_current<=data_reg_1_34;
					35:data_current<=data_reg_1_35;
					36:data_current<=data_reg_1_36;
					37:data_current<=data_reg_1_37;
					38:data_current<=data_reg_1_38;
					39:data_current<=data_reg_1_39;
					40:data_current<=data_reg_1_40;
					41:data_current<=data_reg_1_41;
					42:data_current<=data_reg_1_42;
					43:data_current<=data_reg_1_43;
					44:data_current<=data_reg_1_44;
					45:data_current<=data_reg_1_45;
					46:data_current<=data_reg_1_46;
					47:data_current<=data_reg_1_47;
					48:data_current<=data_reg_1_48;
					49:data_current<=data_reg_1_49;
					50:data_current<=data_reg_1_50;
					51:data_current<=data_reg_1_51;
					52:data_current<=data_reg_1_52;
					53:data_current<=data_reg_1_53;
					54:data_current<=data_reg_1_54;
					55:data_current<=data_reg_1_55;
					56:data_current<=data_reg_1_56;
					57:data_current<=data_reg_1_57;
					58:data_current<=data_reg_1_58;
					59:data_current<=data_reg_1_59;
					60:data_current<=data_reg_1_60;
					61:data_current<=data_reg_1_61;
					62:data_current<=data_reg_1_62;
					63:data_current<=data_reg_1_63;
				endcase//}}}
			end
			else
			begin
				case(fetch_data_index)//{{{
					0:data_current<=data_reg_0_0;
					1:data_current<=data_reg_0_1;
					2:data_current<=data_reg_0_2;
					3:data_current<=data_reg_0_3;
					4:data_current<=data_reg_0_4;
					5:data_current<=data_reg_0_5;
					6:data_current<=data_reg_0_6;
					7:data_current<=data_reg_0_7;
					8:data_current<=data_reg_0_8;
					9:data_current<=data_reg_0_9;
					10:data_current<=data_reg_0_10;
					11:data_current<=data_reg_0_11;
					12:data_current<=data_reg_0_12;
					13:data_current<=data_reg_0_13;
					14:data_current<=data_reg_0_14;
					15:data_current<=data_reg_0_15;
					16:data_current<=data_reg_0_16;
					17:data_current<=data_reg_0_17;
					18:data_current<=data_reg_0_18;
					19:data_current<=data_reg_0_19;
					20:data_current<=data_reg_0_20;
					21:data_current<=data_reg_0_21;
					22:data_current<=data_reg_0_22;
					23:data_current<=data_reg_0_23;
					24:data_current<=data_reg_0_24;
					25:data_current<=data_reg_0_25;
					26:data_current<=data_reg_0_26;
					27:data_current<=data_reg_0_27;
					28:data_current<=data_reg_0_28;
					29:data_current<=data_reg_0_29;
					30:data_current<=data_reg_0_30;
					31:data_current<=data_reg_0_31;
					32:data_current<=data_reg_0_32;
					33:data_current<=data_reg_0_33;
					34:data_current<=data_reg_0_34;
					35:data_current<=data_reg_0_35;
					36:data_current<=data_reg_0_36;
					37:data_current<=data_reg_0_37;
					38:data_current<=data_reg_0_38;
					39:data_current<=data_reg_0_39;
					40:data_current<=data_reg_0_40;
					41:data_current<=data_reg_0_41;
					42:data_current<=data_reg_0_42;
					43:data_current<=data_reg_0_43;
					44:data_current<=data_reg_0_44;
					45:data_current<=data_reg_0_45;
					46:data_current<=data_reg_0_46;
					47:data_current<=data_reg_0_47;
					48:data_current<=data_reg_0_48;
					49:data_current<=data_reg_0_49;
					50:data_current<=data_reg_0_50;
					51:data_current<=data_reg_0_51;
					52:data_current<=data_reg_0_52;
					53:data_current<=data_reg_0_53;
					54:data_current<=data_reg_0_54;
					55:data_current<=data_reg_0_55;
					56:data_current<=data_reg_0_56;
					57:data_current<=data_reg_0_57;
					58:data_current<=data_reg_0_58;
					59:data_current<=data_reg_0_59;
					60:data_current<=data_reg_0_60;
					61:data_current<=data_reg_0_61;
					62:data_current<=data_reg_0_62;
					63:data_current<=data_reg_0_63;
				endcase//}}}
			end
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			fetch_data_index<=0;
		else if(rst_syn)
			fetch_data_index<=0;
		else fetch_data_index<=data_reg_index;
	end
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			data_reg_index<=0;
		else if(rst_syn)
			data_reg_index<=0;
		else data_reg_index<=col_counter;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			data_current<=0;
		else if(rst_syn)
			data_current<=0;
		else if(fetch_data_vld)
		begin
			if(data_sel_delay)
			begin
				case(fetch_data_index)
					0:data_current<=data_reg_1_0;//{{{
					1:data_current<=data_reg_1_1;
					2:data_current<=data_reg_1_2;
					3:data_current<=data_reg_1_3;
					4:data_current<=data_reg_1_4;
					5:data_current<=data_reg_1_5;
					6:data_current<=data_reg_1_6;
					7:data_current<=data_reg_1_7;
					8:data_current<=data_reg_1_8;
					9:data_current<=data_reg_1_9;
					10:data_current<=data_reg_1_10;
					11:data_current<=data_reg_1_11;
					12:data_current<=data_reg_1_12;
					13:data_current<=data_reg_1_13;
					14:data_current<=data_reg_1_14;
					15:data_current<=data_reg_1_15;
					16:data_current<=data_reg_1_16;
					17:data_current<=data_reg_1_17;
					18:data_current<=data_reg_1_18;
					19:data_current<=data_reg_1_19;
					20:data_current<=data_reg_1_20;
					21:data_current<=data_reg_1_21;
					22:data_current<=data_reg_1_22;
					23:data_current<=data_reg_1_23;
					24:data_current<=data_reg_1_24;
					25:data_current<=data_reg_1_25;
					26:data_current<=data_reg_1_26;
					27:data_current<=data_reg_1_27;
					28:data_current<=data_reg_1_28;
					29:data_current<=data_reg_1_29;
					30:data_current<=data_reg_1_30;
					31:data_current<=data_reg_1_31;
					32:data_current<=data_reg_1_32;
					33:data_current<=data_reg_1_33;
					34:data_current<=data_reg_1_34;
					35:data_current<=data_reg_1_35;
					36:data_current<=data_reg_1_36;
					37:data_current<=data_reg_1_37;
					38:data_current<=data_reg_1_38;
					39:data_current<=data_reg_1_39;
					40:data_current<=data_reg_1_40;
					41:data_current<=data_reg_1_41;
					42:data_current<=data_reg_1_42;
					43:data_current<=data_reg_1_43;
					44:data_current<=data_reg_1_44;
					45:data_current<=data_reg_1_45;
					46:data_current<=data_reg_1_46;
					47:data_current<=data_reg_1_47;
					48:data_current<=data_reg_1_48;
					49:data_current<=data_reg_1_49;
					50:data_current<=data_reg_1_50;
					51:data_current<=data_reg_1_51;
					52:data_current<=data_reg_1_52;
					53:data_current<=data_reg_1_53;
					54:data_current<=data_reg_1_54;
					55:data_current<=data_reg_1_55;
					56:data_current<=data_reg_1_56;
					57:data_current<=data_reg_1_57;
					58:data_current<=data_reg_1_58;
					59:data_current<=data_reg_1_59;
					60:data_current<=data_reg_1_60;
					61:data_current<=data_reg_1_61;
					62:data_current<=data_reg_1_62;
					63:data_current<=data_reg_1_63;//}}}
				endcase
			end
			else 
			begin
				case(fetch_data_index)
					0:data_current<=data_reg_0_0;//{{{
					1:data_current<=data_reg_0_1;
					2:data_current<=data_reg_0_2;
					3:data_current<=data_reg_0_3;
					4:data_current<=data_reg_0_4;
					5:data_current<=data_reg_0_5;
					6:data_current<=data_reg_0_6;
					7:data_current<=data_reg_0_7;
					8:data_current<=data_reg_0_8;
					9:data_current<=data_reg_0_9;
					10:data_current<=data_reg_0_10;
					11:data_current<=data_reg_0_11;
					12:data_current<=data_reg_0_12;
					13:data_current<=data_reg_0_13;
					14:data_current<=data_reg_0_14;
					15:data_current<=data_reg_0_15;
					16:data_current<=data_reg_0_16;
					17:data_current<=data_reg_0_17;
					18:data_current<=data_reg_0_18;
					19:data_current<=data_reg_0_19;
					20:data_current<=data_reg_0_20;
					21:data_current<=data_reg_0_21;
					22:data_current<=data_reg_0_22;
					23:data_current<=data_reg_0_23;
					24:data_current<=data_reg_0_24;
					25:data_current<=data_reg_0_25;
					26:data_current<=data_reg_0_26;
					27:data_current<=data_reg_0_27;
					28:data_current<=data_reg_0_28;
					29:data_current<=data_reg_0_29;
					30:data_current<=data_reg_0_30;
					31:data_current<=data_reg_0_31;
					32:data_current<=data_reg_0_32;
					33:data_current<=data_reg_0_33;
					34:data_current<=data_reg_0_34;
					35:data_current<=data_reg_0_35;
					36:data_current<=data_reg_0_36;
					37:data_current<=data_reg_0_37;
					38:data_current<=data_reg_0_38;
					39:data_current<=data_reg_0_39;
					40:data_current<=data_reg_0_40;
					41:data_current<=data_reg_0_41;
					42:data_current<=data_reg_0_42;
					43:data_current<=data_reg_0_43;
					44:data_current<=data_reg_0_44;
					45:data_current<=data_reg_0_45;
					46:data_current<=data_reg_0_46;
					47:data_current<=data_reg_0_47;
					48:data_current<=data_reg_0_48;
					49:data_current<=data_reg_0_49;
					50:data_current<=data_reg_0_50;
					51:data_current<=data_reg_0_51;
					52:data_current<=data_reg_0_52;
					53:data_current<=data_reg_0_53;
					54:data_current<=data_reg_0_54;
					55:data_current<=data_reg_0_55;
					56:data_current<=data_reg_0_56;
					57:data_current<=data_reg_0_57;
					58:data_current<=data_reg_0_58;
					59:data_current<=data_reg_0_59;
					60:data_current<=data_reg_0_60;
					61:data_current<=data_reg_0_61;
					62:data_current<=data_reg_0_62;
					63:data_current<=data_reg_0_63;//}}}
				endcase
			end
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			data_vld<=0;
		else if(rst_syn)
			data_vld<=0;	
		else data_vld<=read_en;
	end
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			fetch_data_vld<=0;
		else if(rst_syn)
			fetch_data_vld<=0;
		else fetch_data_vld<=data_vld;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
		begin
			data_reg_0_0<=0;// {{{
			data_reg_0_1<=0;
			data_reg_0_2<=0;
			data_reg_0_3<=0;
			data_reg_0_4<=0;
			data_reg_0_5<=0;
			data_reg_0_6<=0;
			data_reg_0_7<=0;
			data_reg_0_8<=0;
			data_reg_0_9<=0;
			data_reg_0_10<=0;
			data_reg_0_11<=0;
			data_reg_0_12<=0;
			data_reg_0_13<=0;
			data_reg_0_14<=0;
			data_reg_0_15<=0;
			data_reg_0_16<=0;
			data_reg_0_17<=0;
			data_reg_0_18<=0;
			data_reg_0_19<=0;
			data_reg_0_20<=0;
			data_reg_0_21<=0;
			data_reg_0_22<=0;
			data_reg_0_23<=0;
			data_reg_0_24<=0;
			data_reg_0_25<=0;
			data_reg_0_26<=0;
			data_reg_0_27<=0;
			data_reg_0_28<=0;
			data_reg_0_29<=0;
			data_reg_0_30<=0;
			data_reg_0_31<=0;
			data_reg_0_32<=0;
			data_reg_0_33<=0;
			data_reg_0_34<=0;
			data_reg_0_35<=0;
			data_reg_0_36<=0;
			data_reg_0_37<=0;
			data_reg_0_38<=0;
			data_reg_0_39<=0;
			data_reg_0_40<=0;
			data_reg_0_41<=0;
			data_reg_0_42<=0;
			data_reg_0_43<=0;
			data_reg_0_44<=0;
			data_reg_0_45<=0;
			data_reg_0_46<=0;
			data_reg_0_47<=0;
			data_reg_0_48<=0;
			data_reg_0_49<=0;
			data_reg_0_50<=0;
			data_reg_0_51<=0;
			data_reg_0_52<=0;
			data_reg_0_53<=0;
			data_reg_0_54<=0;
			data_reg_0_55<=0;
			data_reg_0_56<=0;
			data_reg_0_57<=0;
			data_reg_0_58<=0;
			data_reg_0_59<=0;
			data_reg_0_60<=0;
			data_reg_0_61<=0;
			data_reg_0_62<=0;
			data_reg_0_63<=0;
			data_reg_1_0<=0;
			data_reg_1_1<=0;
			data_reg_1_2<=0;
			data_reg_1_3<=0;
			data_reg_1_4<=0;
			data_reg_1_5<=0;
			data_reg_1_6<=0;
			data_reg_1_7<=0;
			data_reg_1_8<=0;
			data_reg_1_9<=0;
			data_reg_1_10<=0;
			data_reg_1_11<=0;
			data_reg_1_12<=0;
			data_reg_1_13<=0;
			data_reg_1_14<=0;
			data_reg_1_15<=0;
			data_reg_1_16<=0;
			data_reg_1_17<=0;
			data_reg_1_18<=0;
			data_reg_1_19<=0;
			data_reg_1_20<=0;
			data_reg_1_21<=0;
			data_reg_1_22<=0;
			data_reg_1_23<=0;
			data_reg_1_24<=0;
			data_reg_1_25<=0;
			data_reg_1_26<=0;
			data_reg_1_27<=0;
			data_reg_1_28<=0;
			data_reg_1_29<=0;
			data_reg_1_30<=0;
			data_reg_1_31<=0;
			data_reg_1_32<=0;
			data_reg_1_33<=0;
			data_reg_1_34<=0;
			data_reg_1_35<=0;
			data_reg_1_36<=0;
			data_reg_1_37<=0;
			data_reg_1_38<=0;
			data_reg_1_39<=0;
			data_reg_1_40<=0;
			data_reg_1_41<=0;
			data_reg_1_42<=0;
			data_reg_1_43<=0;
			data_reg_1_44<=0;
			data_reg_1_45<=0;
			data_reg_1_46<=0;
			data_reg_1_47<=0;
			data_reg_1_48<=0;
			data_reg_1_49<=0;
			data_reg_1_50<=0;
			data_reg_1_51<=0;
			data_reg_1_52<=0;
			data_reg_1_53<=0;
			data_reg_1_54<=0;
			data_reg_1_55<=0;
			data_reg_1_56<=0;
			data_reg_1_57<=0;
			data_reg_1_58<=0;
			data_reg_1_59<=0;
			data_reg_1_60<=0;
			data_reg_1_61<=0;
			data_reg_1_62<=0;
			data_reg_1_63<=0;//}}}
		end
		else if(rst_syn)
		begin
			data_reg_0_0<=0;
			data_reg_0_1<=0;
			data_reg_0_2<=0;
			data_reg_0_3<=0;
			data_reg_0_4<=0;
			data_reg_0_5<=0;
			data_reg_0_6<=0;
			data_reg_0_7<=0;
			data_reg_0_8<=0;
			data_reg_0_9<=0;
			data_reg_0_10<=0;
			data_reg_0_11<=0;
			data_reg_0_12<=0;
			data_reg_0_13<=0;
			data_reg_0_14<=0;
			data_reg_0_15<=0;
			data_reg_0_16<=0;
			data_reg_0_17<=0;
			data_reg_0_18<=0;
			data_reg_0_19<=0;
			data_reg_0_20<=0;
			data_reg_0_21<=0;
			data_reg_0_22<=0;
			data_reg_0_23<=0;
			data_reg_0_24<=0;
			data_reg_0_25<=0;
			data_reg_0_26<=0;
			data_reg_0_27<=0;
			data_reg_0_28<=0;
			data_reg_0_29<=0;
			data_reg_0_30<=0;
			data_reg_0_31<=0;
			data_reg_0_32<=0;
			data_reg_0_33<=0;
			data_reg_0_34<=0;
			data_reg_0_35<=0;
			data_reg_0_36<=0;
			data_reg_0_37<=0;
			data_reg_0_38<=0;
			data_reg_0_39<=0;
			data_reg_0_40<=0;
			data_reg_0_41<=0;
			data_reg_0_42<=0;
			data_reg_0_43<=0;
			data_reg_0_44<=0;
			data_reg_0_45<=0;
			data_reg_0_46<=0;
			data_reg_0_47<=0;
			data_reg_0_48<=0;
			data_reg_0_49<=0;
			data_reg_0_50<=0;
			data_reg_0_51<=0;
		    data_reg_0_52<=0;
		    data_reg_0_53<=0;
		    data_reg_0_54<=0;
		    data_reg_0_55<=0;
		    data_reg_0_56<=0;
		    data_reg_0_57<=0;
		    data_reg_0_58<=0;
		    data_reg_0_59<=0;
		    data_reg_0_60<=0;
		    data_reg_0_61<=0;
		    data_reg_0_62<=0;
		    data_reg_0_63<=0;
		    data_reg_1_0<=0;
		    data_reg_1_1<=0;
		    data_reg_1_2<=0;
		    data_reg_1_3<=0;
		    data_reg_1_4<=0;
		    data_reg_1_5<=0;
		    data_reg_1_6<=0;
		    data_reg_1_7<=0;
		    data_reg_1_8<=0;
		    data_reg_1_9<=0;
		    data_reg_1_10<=0;
		    data_reg_1_11<=0;
		    data_reg_1_12<=0;
		    data_reg_1_13<=0;
		    data_reg_1_14<=0;
		    data_reg_1_15<=0;
		    data_reg_1_16<=0;
		    data_reg_1_17<=0;
		    data_reg_1_18<=0;
		    data_reg_1_19<=0;
		    data_reg_1_20<=0;
		    data_reg_1_21<=0;
		    data_reg_1_22<=0;
		    data_reg_1_23<=0;
		    data_reg_1_24<=0;
		    data_reg_1_25<=0;
		    data_reg_1_26<=0;
		    data_reg_1_27<=0;
		    data_reg_1_28<=0;
		    data_reg_1_29<=0;
		    data_reg_1_30<=0;
		    data_reg_1_31<=0;
		    data_reg_1_32<=0;
		    data_reg_1_33<=0;
		    data_reg_1_34<=0;
		    data_reg_1_35<=0;
		    data_reg_1_36<=0;
		    data_reg_1_37<=0;
		    data_reg_1_38<=0;
		    data_reg_1_39<=0;
		    data_reg_1_40<=0;
		    data_reg_1_41<=0;
		    data_reg_1_42<=0;
		    data_reg_1_43<=0;
		    data_reg_1_44<=0;
		    data_reg_1_45<=0;
		    data_reg_1_46<=0;
		    data_reg_1_47<=0;
		    data_reg_1_48<=0;
		    data_reg_1_49<=0;
		    data_reg_1_50<=0;
		    data_reg_1_51<=0;
		    data_reg_1_52<=0;
		    data_reg_1_53<=0;
		    data_reg_1_54<=0;
		    data_reg_1_55<=0;
		    data_reg_1_56<=0;
		    data_reg_1_57<=0;
		    data_reg_1_58<=0;
		    data_reg_1_59<=0;
		    data_reg_1_60<=0;
		    data_reg_1_61<=0;
		    data_reg_1_62<=0;
		    data_reg_1_63<=0;
		end
		else if(data_vld)
		begin
			if(data_sel)
			begin //{{{
				case(data_reg_index)
					0:data_reg_1_0<=data_from_ram;
					1:data_reg_1_1<=data_from_ram;
					2:data_reg_1_2<=data_from_ram;
					3:data_reg_1_3<=data_from_ram;
					4:data_reg_1_4<=data_from_ram;
					5:data_reg_1_5<=data_from_ram;
					6:data_reg_1_6<=data_from_ram;
					7:data_reg_1_7<=data_from_ram;
					8:data_reg_1_8<=data_from_ram;
					9:data_reg_1_9<=data_from_ram;
					10:data_reg_1_10<=data_from_ram;
					11:data_reg_1_11<=data_from_ram;
					12:data_reg_1_12<=data_from_ram;
					13:data_reg_1_13<=data_from_ram;
					14:data_reg_1_14<=data_from_ram;
					15:data_reg_1_15<=data_from_ram;
					16:data_reg_1_16<=data_from_ram;
					17:data_reg_1_17<=data_from_ram;
					18:data_reg_1_18<=data_from_ram;
					19:data_reg_1_19<=data_from_ram;
					20:data_reg_1_20<=data_from_ram;
					21:data_reg_1_21<=data_from_ram;
					22:data_reg_1_22<=data_from_ram;
					23:data_reg_1_23<=data_from_ram;
					24:data_reg_1_24<=data_from_ram;
					25:data_reg_1_25<=data_from_ram;
					26:data_reg_1_26<=data_from_ram;
					27:data_reg_1_27<=data_from_ram;
					28:data_reg_1_28<=data_from_ram;
					29:data_reg_1_29<=data_from_ram;
					30:data_reg_1_30<=data_from_ram;
					31:data_reg_1_31<=data_from_ram;
					32:data_reg_1_32<=data_from_ram;
					33:data_reg_1_33<=data_from_ram;
					34:data_reg_1_34<=data_from_ram;
					35:data_reg_1_35<=data_from_ram;
					36:data_reg_1_36<=data_from_ram;
					37:data_reg_1_37<=data_from_ram;
					38:data_reg_1_38<=data_from_ram;
					39:data_reg_1_39<=data_from_ram;
					40:data_reg_1_40<=data_from_ram;
					41:data_reg_1_41<=data_from_ram;
					42:data_reg_1_42<=data_from_ram;
					43:data_reg_1_43<=data_from_ram;
					44:data_reg_1_44<=data_from_ram;
					45:data_reg_1_45<=data_from_ram;
					46:data_reg_1_46<=data_from_ram;
					47:data_reg_1_47<=data_from_ram;
					48:data_reg_1_48<=data_from_ram;
					49:data_reg_1_49<=data_from_ram;
					50:data_reg_1_50<=data_from_ram;
					51:data_reg_1_51<=data_from_ram;
					52:data_reg_1_52<=data_from_ram;
					53:data_reg_1_53<=data_from_ram;
					54:data_reg_1_54<=data_from_ram;
					55:data_reg_1_55<=data_from_ram;
					56:data_reg_1_56<=data_from_ram;
					57:data_reg_1_57<=data_from_ram;
					58:data_reg_1_58<=data_from_ram;
					59:data_reg_1_59<=data_from_ram;
					60:data_reg_1_60<=data_from_ram;
					61:data_reg_1_61<=data_from_ram;
					62:data_reg_1_62<=data_from_ram;
					63:data_reg_1_63<=data_from_ram;
				endcase
			end //}}}
			else
			begin//{{{
				case(data_reg_index)
					0:data_reg_0_0<=data_from_ram;
					1:data_reg_0_1<=data_from_ram;
					2:data_reg_0_2<=data_from_ram;
					3:data_reg_0_3<=data_from_ram;
					4:data_reg_0_4<=data_from_ram;
					5:data_reg_0_5<=data_from_ram;
					6:data_reg_0_6<=data_from_ram;
					7:data_reg_0_7<=data_from_ram;
					8:data_reg_0_8<=data_from_ram;
					9:data_reg_0_9<=data_from_ram;
					10:data_reg_0_10<=data_from_ram;
					11:data_reg_0_11<=data_from_ram;
					12:data_reg_0_12<=data_from_ram;
					13:data_reg_0_13<=data_from_ram;
					14:data_reg_0_14<=data_from_ram;
					15:data_reg_0_15<=data_from_ram;
					16:data_reg_0_16<=data_from_ram;
					17:data_reg_0_17<=data_from_ram;
					18:data_reg_0_18<=data_from_ram;
					19:data_reg_0_19<=data_from_ram;
					20:data_reg_0_20<=data_from_ram;
					21:data_reg_0_21<=data_from_ram;
					22:data_reg_0_22<=data_from_ram;
					23:data_reg_0_23<=data_from_ram;
					24:data_reg_0_24<=data_from_ram;
					25:data_reg_0_25<=data_from_ram;
					26:data_reg_0_26<=data_from_ram;
					27:data_reg_0_27<=data_from_ram;
					28:data_reg_0_28<=data_from_ram;
					29:data_reg_0_29<=data_from_ram;
					30:data_reg_0_30<=data_from_ram;
					31:data_reg_0_31<=data_from_ram;
					32:data_reg_0_32<=data_from_ram;
					33:data_reg_0_33<=data_from_ram;
					34:data_reg_0_34<=data_from_ram;
					35:data_reg_0_35<=data_from_ram;
					36:data_reg_0_36<=data_from_ram;
					37:data_reg_0_37<=data_from_ram;
					38:data_reg_0_38<=data_from_ram;
					39:data_reg_0_39<=data_from_ram;
					40:data_reg_0_40<=data_from_ram;
					41:data_reg_0_41<=data_from_ram;
					42:data_reg_0_42<=data_from_ram;
					43:data_reg_0_43<=data_from_ram;
					44:data_reg_0_44<=data_from_ram;
					45:data_reg_0_45<=data_from_ram;
					46:data_reg_0_46<=data_from_ram;
					47:data_reg_0_47<=data_from_ram;
					48:data_reg_0_48<=data_from_ram;
					49:data_reg_0_49<=data_from_ram;
					50:data_reg_0_50<=data_from_ram;
					51:data_reg_0_51<=data_from_ram;
					52:data_reg_0_52<=data_from_ram;
					53:data_reg_0_53<=data_from_ram;
					54:data_reg_0_54<=data_from_ram;
					55:data_reg_0_55<=data_from_ram;
					56:data_reg_0_56<=data_from_ram;
					57:data_reg_0_57<=data_from_ram;
					58:data_reg_0_58<=data_from_ram;
					59:data_reg_0_59<=data_from_ram;
					60:data_reg_0_60<=data_from_ram;
					61:data_reg_0_61<=data_from_ram;
					62:data_reg_0_62<=data_from_ram;
					63:data_reg_0_63<=data_from_ram;//}}}
				endcase
			end
		end
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			data_sel<=0;
		else if(rst_syn)
			data_sel<=0;
		else if(state==READ_ODD_ROW)
			data_sel<=1;
		else data_sel<=0;
	end
	
	always@(*)
	begin
	    case(level)
			0:row_over=row_counter==63;
			1:row_over=row_counter==31;
			2:row_over=row_counter==15;
			3:row_over=row_counter==7;
			4:row_over=row_counter==3;
			default:row_over=0;
		endcase
	end
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			col_counter<=0;
		else if(rst_syn)
			col_counter<=0;
		else if(col_over)
			col_counter<=0;
		else if(read_en)
			col_counter<=col_counter+1;
	end
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			row_counter<=0;
		else if(rst_syn)
			row_counter<=0;
		else if(col_over&&row_over)
			row_counter<=0;
		else if(col_over)
			row_counter<=row_counter+1;
	end
	
	
	always@(*)
	begin
	    case(codeblock_counter)
			0,1,2,3,4,5,6,7,8:level=0;
			9,10,11,12,13,14,15,16,17:level=1;
			18,19,20,21,22,23,24,25,26:level=2;
			27,28,29,30,31,32,33,34,35:level=3;
			36,37,38,39,40,41,42,43,44,45,46,47:level=4;
			default:level=0;
	    endcase
	end
	always@(*)
	begin
	    case(level)
			0:col_over=col_counter==63;
			1:col_over=col_counter==31;
			2:col_over=col_counter==15;
			3:col_over=col_counter==7;
			4:col_over=col_counter==3;
			default:col_over=0;
		endcase
	end

	/**************** reg output******************/
	always@(*)
	begin
		read_en_HH=0;
		read_en_LH=0;
		read_en_HL=0;
		read_en_LL=0;
		address_HH=0;
		address_LL=0;
		address_LH=0;
		address_HL=0;
	    case(codeblock_counter)
			0,3,6,9,12,15,18,21,24,27,30,33,36,39,42:
			begin
				read_en_HH=read_en;
				address_HH=ram_address;
			end 
			1,4,7,10,13,16,19,22,25,28,31,34,37,40,43:
			begin
				read_en_LH=read_en;
				address_LH=ram_address;
			end 
			2,5,8,11,14,17,20,23,26,29,32,35,38,41,44:
			begin
				read_en_HL=read_en;
				address_HL=ram_address;
			end 
			45,46,47:
			begin
				read_en_LL=read_en;
				address_LL=ram_address;
			end 
	    endcase
	end

	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			entropy_calc_over<=0;
		else if(rst_syn)
			entropy_calc_over<=0;
		else if(state==ENTROPY_CALC_OVER)
			entropy_calc_over<=1;
	end
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			ram_address<=0;
		else if(rst_syn)
			ram_address<=0;
		else if(state==GET_CODEBLOCK_ADDRESS)//{{{
		begin
			case(codeblock_counter)
				0,1,2://read HL1,LH1,HH1 for Y
					ram_address<=0;
				9,10,11://read HL2,LH2,HH2 for Y
					ram_address<=12288;
				18,19,20://read HL3,LH3,HH3 for Y
					ram_address<=15360;
				27,28,29://read HL4,LH4,HH4 for Y
					ram_address<=16128;
				36,37,38://read HL5,LH5,HH5 for Y
					ram_address<=16320;
				45://read LL5 for Y
					ram_address<=0;
				//16,17,18://read HL1,LH1,HH1 for U
				3,4,5://read HL1,LH1,HH1 for U
					ram_address<=4096;
				12,13,14://read HL2,LH2,HH2 for U
					ram_address<=13312;
				21,22,23://read HL3,LH3,HH3 for U
					ram_address<=15616;
				30,31,32://read HL4,LH4,HH4 for U
					ram_address<=16192;
				39,40,41://read HL5,LH5,HH5 for U
					ram_address<=16336;
				46://read LL5 for U
					ram_address<=16;
				//32,33,34://read HL1,LH1,HH1 for V
				6,7,8://read HL1,LH1,HH1 for V
					ram_address<=8192;
				15,16,17://read HL2,LH2,HH2 for V
					ram_address<=14336;
				24,25,26://read HL3,LH3,HH3 for V
					ram_address<=15872;
				33,34,35://read HL4,LH4,HH4 for V
					ram_address<=16256;
				42,43,44://read HL5,LH5,HH5 for V
					ram_address<=16352;
				47://read LL5 for V
					ram_address<=32;
				default:ram_address<=0;
			endcase//}}}
		end
		else if(state==READ_ODD_ROW||state==READ_EVEN_ROW)
		begin
			ram_address<=ram_address+1;
		end
	end
	
	////////////////// fsm //////////////////
	reg bpc_start_before_reg;


	assign bpc_start_before=(state==TIER1_WORKING)?1'b1:1'b0;
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			bpc_start_before_reg<=0;
		else if(rst_syn)
			bpc_start_before_reg<=0;
		else 
		bpc_start_before_reg<=bpc_start_before;
	end
	wire bpc_start_m=((bpc_start_before_reg==1'b0)&&(bpc_start_before))?1'b1:1'b0;

	always@(posedge clk or negedge rst)
	begin
	    if(!rst)begin
			bpc_start<=0;
		end
		else if(rst_syn)begin
			bpc_start<=0;
		end
		else begin
			bpc_start<=bpc_start_m;
		end
	end
	
	
	
	
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			state<=IDLE;
		else if(rst_syn)
			state<=IDLE;
		else state<=nextstate;
	end
	always@(*)
	begin
	    case(state)
			IDLE:
			begin
				if(new_data_availible)
					nextstate=GET_CODEBLOCK_ADDRESS;
				else nextstate=IDLE;
			end 
			READ_ODD_ROW:
			begin
				if(col_over)
					nextstate=READ_EVEN_ROW;
				else nextstate=READ_ODD_ROW;
			end 
			READ_EVEN_ROW:
			begin
				if(row_over&&col_over)
					nextstate=CODEBLOCK_OVER;
				else if(col_over)
					nextstate=READ_ODD_ROW;
				else nextstate=READ_EVEN_ROW;
			end 
			CODEBLOCK_OVER:
			begin

				
				if(codeblock_counter==47)
						nextstate=ENTROPY_CALC_OVER;
					else
						nextstate=NEXT_CODEBLOCK;
			end 
			NEXT_CODEBLOCK:
			begin
				nextstate=GET_CODEBLOCK_ADDRESS;
			end 
			GET_CODEBLOCK_ADDRESS:
			begin
				nextstate=READ_ODD_ROW;
			end 
			ENTROPY_CALC_OVER:
			begin
				if(codeblock_over_delay_3)
					nextstate=CALC_LOG;
				else nextstate=ENTROPY_CALC_OVER;
			end 
			CALC_LOG:
			begin
				if(codeblock_counter==52)
					nextstate=TIER1_WORKING;
				else nextstate=CALC_LOG;
			end 
			TIER1_WORKING:
			begin
				if(tier1_over)
					nextstate=IDLE;
				else nextstate=TIER1_WORKING;
			end 
			default:nextstate=IDLE;
	    endcase
	    
	end
endmodule
