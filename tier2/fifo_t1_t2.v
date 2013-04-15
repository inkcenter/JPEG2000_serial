`timescale 1ns/1ns
module fifo_t1_t2(/*autoarg*/
    //input
    flush_over, zero_plane_number, codeblock_counter, 
    wr_clk, rd_clk, rst, rst_syn, data_from_mq, 
    cal_truncation_point_start, compression_ratio, 
    pass_plane, word_last_flag_plane_sp, 
    word_last_flag_plane_mp, word_last_flag_plane_cp, 
    one_codeblock_over, pass_error_plane_sp, 
    pass_error_plane_mp, pass_error_plane_cp, 

    //output
    target_slope, codeblock_shift_over, cal_truncation_point_over, 
    output_to_ram, buffer_all_over, 
    lram_write_en, lram_address_wr, target_byte_number
);

	parameter ADDR_WIDTH=14,
		WORD_WIDTH=18;


	input flush_over;
	input [3:0]zero_plane_number;
	input [7:0]codeblock_counter;
	input wr_clk;
	input rd_clk;
	input rst;
	input rst_syn;
	input [15:0]data_from_mq;
	input cal_truncation_point_start;
	
	input [2:0]compression_ratio;
	input [1:0]pass_plane;
	input word_last_flag_plane_sp;
	input word_last_flag_plane_mp;
	input word_last_flag_plane_cp;
	input one_codeblock_over;
	input [30:0]pass_error_plane_sp;
	input [30:0]pass_error_plane_mp;
	input [30:0]pass_error_plane_cp;



	output [8:0]target_slope;
	output codeblock_shift_over;
	output cal_truncation_point_over;
	output [WORD_WIDTH-1:0]output_to_ram;
	output buffer_all_over;
	output lram_write_en;
	output [ADDR_WIDTH-1:0]lram_address_wr;
	output [19:0]target_byte_number;

	/*********** wire ***********/
	wire zero_error_pass;
	wire last_codeblock;
	wire codeblock_shift_over;
	wire byte_full;
	wire [1:0]word_last_flag_plus;
	wire cal_truncation_point_over;
	wire cal_truncation_en;
	wire [37:0]pass_word_count_expanded_shifted;
	wire [37:0]pass_error_expanded_shifted;
	wire [15:0]dout_plane_sp_0;
    wire [15:0]dout_plane_mp_0;
    wire [15:0]dout_plane_cp_0;
    wire [15:0]dout_plane_sp_1;
    wire [15:0]dout_plane_mp_1;
    wire [15:0]dout_plane_cp_1;
	wire	[7:0]	rd_data_count_plane_sp_0; 
	wire	[7:0]	rd_data_count_plane_mp_0; 
	wire	[7:0]	rd_data_count_plane_cp_0; 
	wire	[7:0]	rd_data_count_plane_sp_1; 
	wire	[7:0]	rd_data_count_plane_mp_1; 
	wire	[7:0]	rd_data_count_plane_cp_1; 
	wire rd_en_plane_sp_0;
	wire rd_en_plane_sp_1;
	wire rd_en_plane_mp_0;
	wire rd_en_plane_mp_1;
	wire rd_en_plane_cp_0;
	wire rd_en_plane_cp_1;
	wire empty_plane_sp_0;
    wire empty_plane_mp_0;
    wire empty_plane_cp_0;
    wire empty_plane_sp_1;
    wire empty_plane_mp_1;
    wire empty_plane_cp_1;
	wire [38:0]pass_error_expanded;
	wire [38:0]pass_word_count_expanded;
	wire [7:0]rears_pass_error;
	wire [7:0]rears_pass_word_count;
	wire [2:0]empty_combo_0;
	wire [2:0]empty_combo_1;
	wire [2:0]empty_combo;


	/********** reg **********/
	reg [5:0]codeblock_over_counter;
	reg [3:0]flush_over_counter;
	reg buffer_all_over;
	reg one_codeblock_over_reg;
	reg pass_over_reg;
	reg [2:0]time_counter;
	reg [3:0]zero_plane_number_reg;
	reg word_last_flag;
	reg word_last_flag_plane_sp_reg;
	reg word_last_flag_plane_mp_reg;
	reg word_last_flag_plane_cp_reg;
	reg [8:0]target_slope;
	reg [8:0]temp;
	reg [19:0]byte_counter;
	reg [19:0]target_byte_number;
	reg lram_write_en;
	reg [ADDR_WIDTH-1:0]lram_address_wr;
	reg over_reg1;
	reg over_reg2;
	reg over_reg3;
	reg [29:0]exponent_input;
	reg [4:0]exponent;
	reg [4:0]state;                         
	reg [4:0]nextstate;                     
	reg [5:0]pass_number;
	reg [7:0]pass_word_count;
	reg fifo_group;
	reg [17:0]output_to_ram;
	reg [7:0]table_output;
	reg [7:0]table_input;
	reg [8:0]slope;
	reg [8:0]distoration_tran;
	reg [7:0]pass_length_tran;
	reg [15:0]fifo_out;
	reg [29:0]pass_error;
	reg empty;

	
	reg [29:0]pass_error_plane_sp_0_reg;
	reg [29:0]pass_error_plane_mp_0_reg;
	reg [29:0]pass_error_plane_cp_0_reg;
	reg [29:0]pass_error_plane_sp_1_reg;
	reg [29:0]pass_error_plane_mp_1_reg;
	reg [29:0]pass_error_plane_cp_1_reg;
	reg [3:0]slope_table_1  ;//{{{
	reg [3:0]slope_table_2  ;
	reg [3:0]slope_table_3  ;
	reg [3:0]slope_table_4  ;
	reg [3:0]slope_table_5  ;
	reg [3:0]slope_table_6  ;
	reg [3:0]slope_table_7  ;
	reg [3:0]slope_table_8  ;
	reg [3:0]slope_table_9  ;
	reg [3:0]slope_table_10 ;
	reg [3:0]slope_table_11 ;
	reg [3:0]slope_table_12 ;
	reg [3:0]slope_table_13 ;
	reg [3:0]slope_table_14 ;
	reg [3:0]slope_table_15 ;
	reg [3:0]slope_table_16 ;
	reg [3:0]slope_table_17 ;
	reg [3:0]slope_table_18 ;
	reg [3:0]slope_table_19 ;
	reg [3:0]slope_table_20 ;
	reg [3:0]slope_table_21 ;
	reg [3:0]slope_table_22 ;
	reg [3:0]slope_table_23 ;
	reg [3:0]slope_table_24 ;
	reg [3:0]slope_table_25 ;
	reg [3:0]slope_table_26 ;
	reg [3:0]slope_table_27 ;
	reg [3:0]slope_table_28 ;
	reg [3:0]slope_table_29 ;
	reg [3:0]slope_table_30 ;
	reg [3:0]slope_table_31 ;
	reg [3:0]slope_table_32 ;
	reg [3:0]slope_table_33 ;
	reg [3:0]slope_table_34 ;
	reg [3:0]slope_table_35 ;
	reg [3:0]slope_table_36 ;
	reg [3:0]slope_table_37 ;
	reg [3:0]slope_table_38 ;
	reg [3:0]slope_table_39 ;
	reg [3:0]slope_table_40 ;
	reg [3:0]slope_table_41 ;
	reg [3:0]slope_table_42 ;
	reg [3:0]slope_table_43 ;
	reg [3:0]slope_table_44 ;
	reg [3:0]slope_table_45 ;
	reg [3:0]slope_table_46 ;
	reg [3:0]slope_table_47 ;
	reg [3:0]slope_table_48 ;
	reg [3:0]slope_table_49 ;
	reg [3:0]slope_table_50 ;
	reg [8:0]slope_table_51 ;
	reg [8:0]slope_table_52 ;
	reg [8:0]slope_table_53 ;
	reg [8:0]slope_table_54 ;
	reg [8:0]slope_table_55 ;
	reg [8:0]slope_table_56 ;
	reg [8:0]slope_table_57 ;
	reg [8:0]slope_table_58 ;
	reg [8:0]slope_table_59 ;
	reg [8:0]slope_table_60 ;
	reg [8:0]slope_table_61 ;
	reg [8:0]slope_table_62 ;
	reg [8:0]slope_table_63 ;
	reg [8:0]slope_table_64 ;
	reg [8:0]slope_table_65 ;
	reg [8:0]slope_table_66 ;
	reg [8:0]slope_table_67 ;
	reg [8:0]slope_table_68 ;
	reg [8:0]slope_table_69 ;
	reg [8:0]slope_table_70 ;
	reg [8:0]slope_table_71 ;
	reg [8:0]slope_table_72 ;
	reg [8:0]slope_table_73 ;
	reg [8:0]slope_table_74 ;
	reg [8:0]slope_table_75 ;
	reg [8:0]slope_table_76 ;
	reg [8:0]slope_table_77 ;
	reg [8:0]slope_table_78 ;
	reg [8:0]slope_table_79 ;
	reg [8:0]slope_table_80 ;
	reg [8:0]slope_table_81 ;
	reg [8:0]slope_table_82 ;
	reg [8:0]slope_table_83 ;
	reg [8:0]slope_table_84 ;
	reg [8:0]slope_table_85 ;
	reg [8:0]slope_table_86 ;
	reg [8:0]slope_table_87 ;
	reg [8:0]slope_table_88 ;
	reg [8:0]slope_table_89 ;
	reg [8:0]slope_table_90 ;
	reg [8:0]slope_table_91 ;
	reg [8:0]slope_table_92 ;
	reg [8:0]slope_table_93 ;
	reg [8:0]slope_table_94 ;
	reg [8:0]slope_table_95 ;
	reg [8:0]slope_table_96 ;
	reg [8:0]slope_table_97 ;
	reg [8:0]slope_table_98 ;
	reg [8:0]slope_table_99 ;
	reg [8:0]slope_table_100; 
	reg [8:0]slope_table_101; 
	reg [8:0]slope_table_102; 
	reg [8:0]slope_table_103; 
	reg [8:0]slope_table_104; 
	reg [8:0]slope_table_105; 
	reg [8:0]slope_table_106; 
	reg [8:0]slope_table_107; 
	reg [8:0]slope_table_108; 
	reg [8:0]slope_table_109; 
	reg [8:0]slope_table_110; 
	reg [8:0]slope_table_111; 
	reg [8:0]slope_table_112; 
	reg [8:0]slope_table_113; 
	reg [8:0]slope_table_114; 
	reg [8:0]slope_table_115; 
	reg [8:0]slope_table_116; 
	reg [8:0]slope_table_117; 
	reg [8:0]slope_table_118; 
	reg [8:0]slope_table_119; 
	reg [8:0]slope_table_120; 
	reg [8:0]slope_table_121; 
	reg [8:0]slope_table_122; 
	reg [8:0]slope_table_123; 
	reg [8:0]slope_table_124; 
	reg [8:0]slope_table_125; 
	reg [8:0]slope_table_126; 
	reg [8:0]slope_table_127; 
	reg [8:0]slope_table_128; 
	reg [8:0]slope_table_129; 
	reg [8:0]slope_table_130; 
	reg [8:0]slope_table_131; 
	reg [8:0]slope_table_132; 
	reg [8:0]slope_table_133; 
	reg [8:0]slope_table_134; 
	reg [8:0]slope_table_135; 
	reg [8:0]slope_table_136; 
	reg [8:0]slope_table_137; 
	reg [8:0]slope_table_138; 
	reg [8:0]slope_table_139; 
	reg [8:0]slope_table_140; 
	reg [8:0]slope_table_141; 
	reg [8:0]slope_table_142; 
	reg [8:0]slope_table_143; 
	reg [8:0]slope_table_144; 
	reg [8:0]slope_table_145; 
	reg [8:0]slope_table_146; 
	reg [8:0]slope_table_147; 
	reg [8:0]slope_table_148; 
	reg [8:0]slope_table_149; 
	reg [8:0]slope_table_150; 
	reg [8:0]slope_table_151; 
	reg [8:0]slope_table_152; 
	reg [8:0]slope_table_153; 
	reg [8:0]slope_table_154; 
	reg [8:0]slope_table_155; 
	reg [8:0]slope_table_156; 
	reg [8:0]slope_table_157; 
	reg [8:0]slope_table_158; 
	reg [8:0]slope_table_159; 
	reg [8:0]slope_table_160; 
	reg [8:0]slope_table_161; 
	reg [8:0]slope_table_162; 
	reg [8:0]slope_table_163; 
	reg [8:0]slope_table_164; 
	reg [8:0]slope_table_165; 
	reg [8:0]slope_table_166; 
	reg [8:0]slope_table_167; 
	reg [8:0]slope_table_168; 
	reg [8:0]slope_table_169; 
	reg [8:0]slope_table_170; 
	reg [8:0]slope_table_171; 
	reg [8:0]slope_table_172; 
	reg [8:0]slope_table_173; 
	reg [8:0]slope_table_174; 
	reg [8:0]slope_table_175; 
	reg [8:0]slope_table_176; 
	reg [8:0]slope_table_177; 
	reg [8:0]slope_table_178; 
	reg [8:0]slope_table_179; 
	reg [8:0]slope_table_180; 
	reg [8:0]slope_table_181; 
	reg [8:0]slope_table_182; 
	reg [8:0]slope_table_183; 
	reg [8:0]slope_table_184; 
	reg [8:0]slope_table_185; 
	reg [8:0]slope_table_186; 
	reg [8:0]slope_table_187; 
	reg [8:0]slope_table_188; 
	reg [8:0]slope_table_189; 
	reg [8:0]slope_table_190; 
	reg [8:0]slope_table_191; 
	reg [8:0]slope_table_192; 
	reg [8:0]slope_table_193; 
	reg [8:0]slope_table_194; 
	reg [8:0]slope_table_195; 
	reg [8:0]slope_table_196; 
	reg [8:0]slope_table_197; 
	reg [8:0]slope_table_198; 
	reg [8:0]slope_table_199; 
	reg [8:0]slope_table_200; 
	reg [8:0]slope_table_201; 
	reg [8:0]slope_table_202; 
	reg [8:0]slope_table_203; 
	reg [8:0]slope_table_204; 
	reg [8:0]slope_table_205; 
	reg [8:0]slope_table_206; 
	reg [8:0]slope_table_207; 
	reg [8:0]slope_table_208; 
	reg [8:0]slope_table_209; 
	reg [8:0]slope_table_210; 
	reg [8:0]slope_table_211; 
	reg [8:0]slope_table_212; 
	reg [8:0]slope_table_213; 
	reg [8:0]slope_table_214; 
	reg [8:0]slope_table_215; 
	reg [8:0]slope_table_216; 
	reg [8:0]slope_table_217; 
	reg [8:0]slope_table_218; 
	reg [8:0]slope_table_219; 
	reg [8:0]slope_table_220; 
	reg [8:0]slope_table_221; 
	reg [8:0]slope_table_222; 
	reg [8:0]slope_table_223; 
	reg [8:0]slope_table_224; 
	reg [8:0]slope_table_225; 
	reg [8:0]slope_table_226; 
	reg [8:0]slope_table_227; 
	reg [8:0]slope_table_228; 
	reg [8:0]slope_table_229; 
	reg [8:0]slope_table_230; 
	reg [8:0]slope_table_231; 
	reg [8:0]slope_table_232; 
	reg [8:0]slope_table_233; 
	reg [8:0]slope_table_234; 
	reg [8:0]slope_table_235; 
	reg [8:0]slope_table_236; 
	reg [8:0]slope_table_237; 
	reg [8:0]slope_table_238; 
	reg [8:0]slope_table_239; 
	reg [8:0]slope_table_240; 
	reg [8:0]slope_table_241; 
	reg [8:0]slope_table_242; 
	reg [8:0]slope_table_243; 
	reg [8:0]slope_table_244; 
	reg [8:0]slope_table_245; 
	reg [8:0]slope_table_246; 
	reg [8:0]slope_table_247; 
	reg [8:0]slope_table_248; 
	reg [8:0]slope_table_249; 
	reg [8:0]slope_table_250; 
	reg [8:0]slope_table_251; 
	reg [8:0]slope_table_252; 
	reg [8:0]slope_table_253; 
	reg [8:0]slope_table_254; 
	reg [8:0]slope_table_255; 
	reg [8:0]slope_table_256; 
	reg [8:0]slope_table_257; 
	reg [8:0]slope_table_258; 
	reg [8:0]slope_table_259; 
	reg [8:0]slope_table_260; 
	reg [8:0]slope_table_261; 
	reg [8:0]slope_table_262; 
	reg [8:0]slope_table_263; 
	reg [8:0]slope_table_264; 
	reg [8:0]slope_table_265; 
	reg [8:0]slope_table_266; 
	reg [8:0]slope_table_267; 
	reg [8:0]slope_table_268; 
	reg [8:0]slope_table_269; 
	reg [8:0]slope_table_270; 
	reg [8:0]slope_table_271; 
	reg [8:0]slope_table_272; 
	reg [8:0]slope_table_273; 
	reg [8:0]slope_table_274; 
	reg [8:0]slope_table_275; 
	reg [8:0]slope_table_276; 
	reg [8:0]slope_table_277; 
	reg [8:0]slope_table_278; 
	reg [8:0]slope_table_279; 
	reg [8:0]slope_table_280; 
	reg [8:0]slope_table_281; 
	reg [8:0]slope_table_282; 
	reg [8:0]slope_table_283; 
	reg [8:0]slope_table_284; 
	reg [8:0]slope_table_285; 
	reg [8:0]slope_table_286; 
	reg [8:0]slope_table_287; 
	reg [8:0]slope_table_288; 
	reg [8:0]slope_table_289; 
	reg [8:0]slope_table_290; 
	reg [8:0]slope_table_291; 
	reg [8:0]slope_table_292; 
	reg [8:0]slope_table_293; 
	reg [8:0]slope_table_294; 
	reg [8:0]slope_table_295; 
	reg [8:0]slope_table_296; 
	reg [8:0]slope_table_297; 
	reg [8:0]slope_table_298; 
	reg [8:0]slope_table_299; 
	reg [3:0]slope_table_300; 
	reg [3:0]slope_table_301; 
	reg [3:0]slope_table_302; 
	reg [3:0]slope_table_303; 
	reg [3:0]slope_table_304; 
	reg [3:0]slope_table_305; 
	reg [3:0]slope_table_306; 
	reg [3:0]slope_table_307; 
	reg [3:0]slope_table_308; 
	reg [3:0]slope_table_309; 
	reg [3:0]slope_table_310; 
	reg [3:0]slope_table_311; 
	reg [3:0]slope_table_312; 
	reg [3:0]slope_table_313; 
	reg [3:0]slope_table_314; 
	reg [3:0]slope_table_315; 
	reg [3:0]slope_table_316; 
	reg [3:0]slope_table_317; 
	reg [3:0]slope_table_318; 
	reg [3:0]slope_table_319; 
	reg [3:0]slope_table_320; 
	reg [3:0]slope_table_321; 
	reg [3:0]slope_table_322; 
	reg [3:0]slope_table_323; 
	reg [3:0]slope_table_324; 
	reg [3:0]slope_table_325; 
	reg [3:0]slope_table_326; 
	reg [3:0]slope_table_327; 
	reg [3:0]slope_table_328; 
	reg [3:0]slope_table_329; 
	reg [3:0]slope_table_330; 
	reg [3:0]slope_table_331; 
	reg [3:0]slope_table_332; 
	reg [3:0]slope_table_333; 
	reg [3:0]slope_table_334; 
	reg [3:0]slope_table_335; 
	reg [3:0]slope_table_336; 
	reg [3:0]slope_table_337; 
	reg [3:0]slope_table_338; 
	reg [3:0]slope_table_339; 
	reg [3:0]slope_table_340; 
	reg [3:0]slope_table_341; 
	reg [3:0]slope_table_342; 
	reg [3:0]slope_table_343; 
	reg [3:0]slope_table_344; 
	reg [3:0]slope_table_345; 
	reg [3:0]slope_table_346; 
	reg [3:0]slope_table_347; 
	reg [3:0]slope_table_348; 
	reg [3:0]slope_table_349; 
	reg [3:0]slope_table_350; 
	reg [3:0]slope_table_351; 
	reg [3:0]slope_table_352; 
	reg [3:0]slope_table_353; 
	reg [3:0]slope_table_354; 
	reg [3:0]slope_table_355; 
	reg [3:0]slope_table_356; 
	reg [3:0]slope_table_357; 
	reg [3:0]slope_table_358; 
	reg [3:0]slope_table_359; 
	reg [3:0]slope_table_360; 
	reg [3:0]slope_table_361; 
	reg [3:0]slope_table_362; 
	reg [3:0]slope_table_363; 
	reg [3:0]slope_table_364; 
	reg [3:0]slope_table_365; 
	reg [3:0]slope_table_366; 
	reg [3:0]slope_table_367; 
	reg [3:0]slope_table_368; 
	reg [3:0]slope_table_369; 
	reg [3:0]slope_table_370; 
	reg [3:0]slope_table_371; 
	reg [3:0]slope_table_372; 
	reg [3:0]slope_table_373; 
	reg [3:0]slope_table_374; 
	reg [3:0]slope_table_375; 
	reg [3:0]slope_table_376; 
	reg [3:0]slope_table_377; 
	reg [3:0]slope_table_378; 
	reg [3:0]slope_table_379; 
	reg [3:0]slope_table_380; 
	reg [3:0]slope_table_381; 
	reg [3:0]slope_table_382; 
	reg [3:0]slope_table_383; 
	reg [3:0]slope_table_384; 
	reg [3:0]slope_table_385; 
	reg [3:0]slope_table_386; 
	reg [3:0]slope_table_387; 
	reg [3:0]slope_table_388; 
	reg [3:0]slope_table_389; 
	reg [3:0]slope_table_390; 
	reg [3:0]slope_table_391; 
	reg [3:0]slope_table_392; 
	reg [3:0]slope_table_393; 
	reg [3:0]slope_table_394; 
	reg [3:0]slope_table_395; 
	reg [3:0]slope_table_396; 
	reg [3:0]slope_table_397; 
	reg [3:0]slope_table_398; 
	reg [3:0]slope_table_399; 
	reg [3:0]slope_table_400; 
	reg [3:0]slope_table_401; 
	reg [3:0]slope_table_402; 
	reg [3:0]slope_table_403; 
	reg [3:0]slope_table_404; 
	reg [3:0]slope_table_405; 
	reg [3:0]slope_table_406; 
	reg [3:0]slope_table_407; 
	reg [3:0]slope_table_408; 
	reg [3:0]slope_table_409; 
	reg [3:0]slope_table_410; 
	reg [3:0]slope_table_411; 
	reg [3:0]slope_table_412; 
	reg [3:0]slope_table_413; 
	reg [3:0]slope_table_414; 
	reg [3:0]slope_table_415; 
	reg [3:0]slope_table_416; 
	reg [3:0]slope_table_417; 
	reg [3:0]slope_table_418; 
	reg [3:0]slope_table_419; 
	reg [3:0]slope_table_420; 
	reg [3:0]slope_table_421; 
	reg [3:0]slope_table_422; 
	reg [3:0]slope_table_423; 
	reg [3:0]slope_table_424; 
	reg [3:0]slope_table_425; 
	reg [3:0]slope_table_426; 
	reg [3:0]slope_table_427; 
	reg [3:0]slope_table_428; 
	reg [3:0]slope_table_429; 
	reg [3:0]slope_table_430; 
	reg [3:0]slope_table_431; 
	reg [3:0]slope_table_432; 
	reg [3:0]slope_table_433; 
	reg [3:0]slope_table_434; 
	reg [3:0]slope_table_435; 
	reg [3:0]slope_table_436; 
	reg [3:0]slope_table_437; 
	reg [3:0]slope_table_438; 
	reg [3:0]slope_table_439; 
	reg [3:0]slope_table_440; 
	reg [3:0]slope_table_441; 
	reg [3:0]slope_table_442; 
	reg [3:0]slope_table_443; 
	reg [3:0]slope_table_444; 
	reg [3:0]slope_table_445; 
	reg [3:0]slope_table_446; 
	reg [3:0]slope_table_447; 
	reg [3:0]slope_table_448; 
	reg [3:0]slope_table_449; 
	reg [3:0]slope_table_450; 
	reg [3:0]slope_table_451; 
	reg [3:0]slope_table_452; 
	reg [3:0]slope_table_453; 
	reg [3:0]slope_table_454; 
	reg [3:0]slope_table_455; 
	reg [3:0]slope_table_456; 
	reg [3:0]slope_table_457; 
	reg [3:0]slope_table_458; 
	reg [3:0]slope_table_459; 
	reg [3:0]slope_table_460; 
	reg [3:0]slope_table_461; 
	reg [3:0]slope_table_462; 
	reg [3:0]slope_table_463; 
	reg [3:0]slope_table_464; 
	reg [3:0]slope_table_465; 
	reg [3:0]slope_table_466; 
	reg [3:0]slope_table_467; 
	reg [3:0]slope_table_468; 
	reg [3:0]slope_table_469; 
	reg [3:0]slope_table_470; 
	reg [3:0]slope_table_471; 
	reg [3:0]slope_table_472; 
	reg [3:0]slope_table_473; 
	reg [3:0]slope_table_474; 
	reg [3:0]slope_table_475; 
	reg [3:0]slope_table_476; 
	reg [3:0]slope_table_477; 
	reg [3:0]slope_table_478; 
	reg [3:0]slope_table_479; 
	reg [9:0]slope_table_480; //480=29*16+16//}}}

	



	parameter IDLE=0,
		FIND_FIRST_PASS=1,
		CAL_SLOPE_1=2,
		CAL_SLOPE_2=3,
		CAL_SLOPE_3=4,
		SHIFT_PASS_FIRST_HEADER=5,
		SHIFT_PASS_SECOND_HEADER=6,
		SHIFT_CODESTREAM=7,
		NEXT_PASS=8,
		PASS_OVER=9,
		CAL_TRUNCATION_POINT=10,
		CAL_TRUNCATION_POINT_OVER=11,
		BUFFER=12,
		WAITING_WRITE_OVER=13,
		SHIFT_OVER_FLAG=14,
		ONE_EMPTY_CODEBLOCK_OVER=15;
	/*** wire output ***/
	assign codeblock_shift_over=pass_over_reg&&one_codeblock_over_reg||state==ONE_EMPTY_CODEBLOCK_OVER;
	assign cal_truncation_point_over=(state==CAL_TRUNCATION_POINT_OVER); 
	
	/*** reg output ***/
	always@(posedge rd_clk or negedge rst)
	begin
	    if(!rst)
			target_slope<=0;
		else if(rst_syn)
			target_slope<=0;
		else if(cal_truncation_en&&lram_address_wr==480)
			target_slope<=1;//in the case that even the total number of byte cannot meet the required number under the certain bit rate
		else if(byte_full)
			target_slope<=481-lram_address_wr;
	end
	
	always@(posedge rd_clk or negedge rst)
	begin
	    if(!rst)
			lram_address_wr<=0;
		else if(rst_syn)
			lram_address_wr<=0;
		else if(buffer_all_over)
			lram_address_wr<=0;
		else if(lram_write_en||cal_truncation_en)
			lram_address_wr<=lram_address_wr+1;
	end
	
	always@(posedge rd_clk or negedge rst)
	begin
	    if(!rst)
			output_to_ram<=0;
		else if(rst_syn)
			output_to_ram<=0;
		else 
		begin
			case(state)
				SHIFT_PASS_FIRST_HEADER:output_to_ram<={2'b11,codeblock_counter,pass_word_count[7:0]};
				SHIFT_PASS_SECOND_HEADER:output_to_ram<={word_last_flag_plus[1:0],zero_plane_number_reg[3:0],3'b0,slope[8:0]};
				SHIFT_CODESTREAM:output_to_ram<={2'b00,fifo_out};
				SHIFT_OVER_FLAG:output_to_ram<={2'b11,16'hffff};
			endcase
		end
	end
	
	/******************** reg internal *************************/
	always@(posedge rd_clk or negedge rst)//normally this counter should be 0,only when one_codeblock_over occurs while the former codeblock is still outputting to ram this counter increase
	begin
		if(!rst)
			codeblock_over_counter<=0;
		else if(rst_syn)
			codeblock_over_counter<=0;
		else if(one_codeblock_over_reg&&one_codeblock_over)
			codeblock_over_counter<=codeblock_over_counter+1;//in the case of empty codeblocks
		else if(state==ONE_EMPTY_CODEBLOCK_OVER)
			codeblock_over_counter<=codeblock_over_counter-1;
	end
	
	always@(posedge rd_clk or negedge rst)
	begin
		if(!rst)
			flush_over_counter<=0;
		else if(rst_syn)
			flush_over_counter<=flush_over_counter+1;
		else if(codeblock_shift_over)
			flush_over_counter<=0;
		else if(flush_over)
			flush_over_counter<=flush_over_counter+1;
	end
	
	always@(posedge rd_clk or negedge rst)
	begin
		if(!rst)
			buffer_all_over<=0;
		else if(rst_syn)
			buffer_all_over<=0;
		else if(state==SHIFT_OVER_FLAG)
			buffer_all_over<=1;
		else buffer_all_over<=0;
	end
	always@(posedge rd_clk or negedge rst)
	begin
	    if(!rst)
			time_counter<=0;
		else if(rst_syn)
			time_counter<=0;
		else if(time_counter==5)
			time_counter<=0;
		else if(state==WAITING_WRITE_OVER)
			time_counter<=time_counter+1;
	end
	always@(posedge rd_clk or negedge rst)
	begin
		if(!rst)
			one_codeblock_over_reg<=0;
		else if(rst_syn)
			one_codeblock_over_reg<=0;
		else if(one_codeblock_over)
			one_codeblock_over_reg<=1;
		else if(pass_over_reg&&one_codeblock_over_reg)
			one_codeblock_over_reg<=0;
	end
	always@(posedge rd_clk or negedge rst)
	begin
		if(!rst)
			pass_over_reg<=0;
		else if(state==PASS_OVER)
			pass_over_reg<=1;
		else if(flush_over||one_codeblock_over_reg)
			pass_over_reg<=0;
	end

	always@(posedge wr_clk or negedge rst)
	begin
		if(!rst)
			zero_plane_number_reg<=0;
		else if(rst_syn)
			zero_plane_number_reg<=0;
		else if(one_codeblock_over)
			zero_plane_number_reg<=zero_plane_number;
	    else if(flush_over)
			zero_plane_number_reg<=zero_plane_number;
	end
	
	/* always@(posedge wr_clk or negedge rst)
	begin
		if(!rst)
			zero_plane_number_reg<=0;
		else if(rst_syn)
			zero_plane_number_reg<=0;
		else if(flush_over)
			zero_plane_number_reg<=zero_plane_number;
	    
	end */
	always@(*)
	begin
	    case(pass_number)
 			0:word_last_flag=word_last_flag_plane_sp_reg;
    		1:word_last_flag=word_last_flag_plane_mp_reg;
    		2:word_last_flag=word_last_flag_plane_cp_reg;
			default:word_last_flag=0;
		endcase

	end
	always@(posedge wr_clk or negedge rst)
	begin
	    if(!rst)
		begin
			word_last_flag_plane_sp_reg <=0;
			word_last_flag_plane_mp_reg <=0;
			word_last_flag_plane_cp_reg <=0;
		end
		else if(rst_syn)
		begin
			word_last_flag_plane_sp_reg <=0;
			word_last_flag_plane_mp_reg <=0;
			word_last_flag_plane_cp_reg <=0;
		end

		else if(flush_over)
		begin
			word_last_flag_plane_sp_reg <=word_last_flag_plane_sp;
			word_last_flag_plane_mp_reg <=word_last_flag_plane_mp;
			word_last_flag_plane_cp_reg <=word_last_flag_plane_cp;
		end
	end

	
	
	
	
	always@(*)
	begin
	    if(cal_truncation_en)
		begin
			case(lram_address_wr)
				480:temp=slope_table_1  ;//{{{
				479:temp=slope_table_2  ;
				478:temp=slope_table_3  ;
				477:temp=slope_table_4  ;
				476:temp=slope_table_5  ;
				475:temp=slope_table_6  ;
				474:temp=slope_table_7  ;
				473:temp=slope_table_8  ;
				472:temp=slope_table_9  ;
				471:temp=slope_table_10 ;
				470:temp=slope_table_11 ;
				469:temp=slope_table_12 ;
				468:temp=slope_table_13 ;
				467:temp=slope_table_14 ;
				466:temp=slope_table_15 ;
				465:temp=slope_table_16 ;
				464:temp=slope_table_17 ;
				463:temp=slope_table_18 ;
				462:temp=slope_table_19 ;
				461:temp=slope_table_20 ;
				460:temp=slope_table_21 ;
				459:temp=slope_table_22 ;
				458:temp=slope_table_23 ;
				457:temp=slope_table_24 ;
				456:temp=slope_table_25 ;
				455:temp=slope_table_26 ;
				454:temp=slope_table_27 ;
				453:temp=slope_table_28 ;
				452:temp=slope_table_29 ;
				451:temp=slope_table_30 ;
				450:temp=slope_table_31 ;
				449:temp=slope_table_32 ;
				448:temp=slope_table_33 ;
				447:temp=slope_table_34 ;
				446:temp=slope_table_35 ;
				445:temp=slope_table_36 ;
				444:temp=slope_table_37 ;
				443:temp=slope_table_38 ;
				442:temp=slope_table_39 ;
				441:temp=slope_table_40 ;
				440:temp=slope_table_41 ;
				439:temp=slope_table_42 ;
				438:temp=slope_table_43 ;
				437:temp=slope_table_44 ;
				436:temp=slope_table_45 ;
				435:temp=slope_table_46 ;
				434:temp=slope_table_47 ;
				433:temp=slope_table_48 ;
				432:temp=slope_table_49 ;
				431:temp=slope_table_50 ;
				430:temp=slope_table_51 ;
				429:temp=slope_table_52 ;
				428:temp=slope_table_53 ;
				427:temp=slope_table_54 ;
				426:temp=slope_table_55 ;
				425:temp=slope_table_56 ;
				424:temp=slope_table_57 ;
				423:temp=slope_table_58 ;
				422:temp=slope_table_59 ;
				421:temp=slope_table_60 ;
				420:temp=slope_table_61 ;
				419:temp=slope_table_62 ;
				418:temp=slope_table_63 ;
				417:temp=slope_table_64 ;
				416:temp=slope_table_65 ;
				415:temp=slope_table_66 ;
				414:temp=slope_table_67 ;
				413:temp=slope_table_68 ;
				412:temp=slope_table_69 ;
				411:temp=slope_table_70 ;
				410:temp=slope_table_71 ;
				409:temp=slope_table_72 ;
				408:temp=slope_table_73 ;
				407:temp=slope_table_74 ;
				406:temp=slope_table_75 ;
				405:temp=slope_table_76 ;
				404:temp=slope_table_77 ;
				403:temp=slope_table_78 ;
				402:temp=slope_table_79 ;
				401:temp=slope_table_80 ;
				400:temp=slope_table_81 ;
				399:temp=slope_table_82 ;
				398:temp=slope_table_83 ;
				397:temp=slope_table_84 ;
				396:temp=slope_table_85 ;
				395:temp=slope_table_86 ;
				394:temp=slope_table_87 ;
				393:temp=slope_table_88 ;
				392:temp=slope_table_89 ;
				391:temp=slope_table_90 ;
				390:temp=slope_table_91 ;
				389:temp=slope_table_92 ;
				388:temp=slope_table_93 ;
				387:temp=slope_table_94 ;
				386:temp=slope_table_95 ;
				385:temp=slope_table_96 ;
				384:temp=slope_table_97 ;
				383:temp=slope_table_98 ;
				382:temp=slope_table_99 ;
				381:temp=slope_table_100;
				380:temp=slope_table_101;
				379:temp=slope_table_102;
				378:temp=slope_table_103;
				377:temp=slope_table_104;
				376:temp=slope_table_105;
				375:temp=slope_table_106;
				374:temp=slope_table_107;
				373:temp=slope_table_108;
				372:temp=slope_table_109;
				371:temp=slope_table_110;
				370:temp=slope_table_111;
				369:temp=slope_table_112;
				368:temp=slope_table_113;
				367:temp=slope_table_114;
				366:temp=slope_table_115;
				365:temp=slope_table_116;
				364:temp=slope_table_117;
				363:temp=slope_table_118;
				362:temp=slope_table_119;
				361:temp=slope_table_120;
				360:temp=slope_table_121;
				359:temp=slope_table_122;
				358:temp=slope_table_123;
				357:temp=slope_table_124;
				356:temp=slope_table_125;
				355:temp=slope_table_126;
				354:temp=slope_table_127;
				353:temp=slope_table_128;
				352:temp=slope_table_129;
				351:temp=slope_table_130;
				350:temp=slope_table_131;
				349:temp=slope_table_132;
				348:temp=slope_table_133;
				347:temp=slope_table_134;
				346:temp=slope_table_135;
				345:temp=slope_table_136;
				344:temp=slope_table_137;
				343:temp=slope_table_138;
				342:temp=slope_table_139;
				341:temp=slope_table_140;
				340:temp=slope_table_141;
				339:temp=slope_table_142;
				338:temp=slope_table_143;
				337:temp=slope_table_144;
				336:temp=slope_table_145;
				335:temp=slope_table_146;
				334:temp=slope_table_147;
				333:temp=slope_table_148;
				332:temp=slope_table_149;
				331:temp=slope_table_150;
				330:temp=slope_table_151;
				329:temp=slope_table_152;
				328:temp=slope_table_153;
				327:temp=slope_table_154;
				326:temp=slope_table_155;
				325:temp=slope_table_156;
				324:temp=slope_table_157;
				323:temp=slope_table_158;
				322:temp=slope_table_159;
				321:temp=slope_table_160;
				320:temp=slope_table_161;
				319:temp=slope_table_162;
				318:temp=slope_table_163;
				317:temp=slope_table_164;
				316:temp=slope_table_165;
				315:temp=slope_table_166;
				314:temp=slope_table_167;
				313:temp=slope_table_168;
				312:temp=slope_table_169;
				311:temp=slope_table_170;
				310:temp=slope_table_171;
				309:temp=slope_table_172;
				308:temp=slope_table_173;
				307:temp=slope_table_174;
				306:temp=slope_table_175;
				305:temp=slope_table_176;
				304:temp=slope_table_177;
				303:temp=slope_table_178;
				302:temp=slope_table_179;
				301:temp=slope_table_180;
				300:temp=slope_table_181;
				299:temp=slope_table_182;
				298:temp=slope_table_183;
				297:temp=slope_table_184;
				296:temp=slope_table_185;
				295:temp=slope_table_186;
				294:temp=slope_table_187;
				293:temp=slope_table_188;
				292:temp=slope_table_189;
				291:temp=slope_table_190;
				290:temp=slope_table_191;
				289:temp=slope_table_192;
				288:temp=slope_table_193;
				287:temp=slope_table_194;
				286:temp=slope_table_195;
				285:temp=slope_table_196;
				284:temp=slope_table_197;
				283:temp=slope_table_198;
				282:temp=slope_table_199;
				281:temp=slope_table_200;
				280:temp=slope_table_201;
				279:temp=slope_table_202;
				278:temp=slope_table_203;
				277:temp=slope_table_204;
				276:temp=slope_table_205;
				275:temp=slope_table_206;
				274:temp=slope_table_207;
				273:temp=slope_table_208;
				272:temp=slope_table_209;
				271:temp=slope_table_210;
				270:temp=slope_table_211;
				269:temp=slope_table_212;
				268:temp=slope_table_213;
				267:temp=slope_table_214;
				266:temp=slope_table_215;
				265:temp=slope_table_216;
				264:temp=slope_table_217;
				263:temp=slope_table_218;
				262:temp=slope_table_219;
				261:temp=slope_table_220;
				260:temp=slope_table_221;
				259:temp=slope_table_222;
				258:temp=slope_table_223;
				257:temp=slope_table_224;
				256:temp=slope_table_225;
				255:temp=slope_table_226;
				254:temp=slope_table_227;
				253:temp=slope_table_228;
				252:temp=slope_table_229;
				251:temp=slope_table_230;
				250:temp=slope_table_231;
				249:temp=slope_table_232;
				248:temp=slope_table_233;
				247:temp=slope_table_234;
				246:temp=slope_table_235;
				245:temp=slope_table_236;
				244:temp=slope_table_237;
				243:temp=slope_table_238;
				242:temp=slope_table_239;
				241:temp=slope_table_240;
				240:temp=slope_table_241;
				239:temp=slope_table_242;
				238:temp=slope_table_243;
				237:temp=slope_table_244;
				236:temp=slope_table_245;
				235:temp=slope_table_246;
				234:temp=slope_table_247;
				233:temp=slope_table_248;
				232:temp=slope_table_249;
				231:temp=slope_table_250;
				230:temp=slope_table_251;
				229:temp=slope_table_252;
				228:temp=slope_table_253;
				227:temp=slope_table_254;
				226:temp=slope_table_255;
				225:temp=slope_table_256;
				224:temp=slope_table_257;
				223:temp=slope_table_258;
				222:temp=slope_table_259;
				221:temp=slope_table_260;
				220:temp=slope_table_261;
				219:temp=slope_table_262;
				218:temp=slope_table_263;
				217:temp=slope_table_264;
				216:temp=slope_table_265;
				215:temp=slope_table_266;
				214:temp=slope_table_267;
				213:temp=slope_table_268;
				212:temp=slope_table_269;
				211:temp=slope_table_270;
				210:temp=slope_table_271;
				209:temp=slope_table_272;
				208:temp=slope_table_273;
				207:temp=slope_table_274;
				206:temp=slope_table_275;
				205:temp=slope_table_276;
				204:temp=slope_table_277;
				203:temp=slope_table_278;
				202:temp=slope_table_279;
				201:temp=slope_table_280;
				200:temp=slope_table_281;
				199:temp=slope_table_282;
				198:temp=slope_table_283;
				197:temp=slope_table_284;
				196:temp=slope_table_285;
				195:temp=slope_table_286;
				194:temp=slope_table_287;
				193:temp=slope_table_288;
				192:temp=slope_table_289;
				191:temp=slope_table_290;
				190:temp=slope_table_291;
				189:temp=slope_table_292;
				188:temp=slope_table_293;
				187:temp=slope_table_294;
				186:temp=slope_table_295;
				185:temp=slope_table_296;
				184:temp=slope_table_297;
				183:temp=slope_table_298;
				182:temp=slope_table_299;
				181:temp=slope_table_300;
				180:temp=slope_table_301;
				179:temp=slope_table_302;
				178:temp=slope_table_303;
				177:temp=slope_table_304;
				176:temp=slope_table_305;
				175:temp=slope_table_306;
				174:temp=slope_table_307;
				173:temp=slope_table_308;
				172:temp=slope_table_309;
				171:temp=slope_table_310;
				170:temp=slope_table_311;
				169:temp=slope_table_312;
				168:temp=slope_table_313;
				167:temp=slope_table_314;
				166:temp=slope_table_315;
				165:temp=slope_table_316;
				164:temp=slope_table_317;
				163:temp=slope_table_318;
				162:temp=slope_table_319;
				161:temp=slope_table_320;
				160:temp=slope_table_321;
				159:temp=slope_table_322;
				158:temp=slope_table_323;
				157:temp=slope_table_324;
				156:temp=slope_table_325;
				155:temp=slope_table_326;
				154:temp=slope_table_327;
				153:temp=slope_table_328;
				152:temp=slope_table_329;
				151:temp=slope_table_330;
				150:temp=slope_table_331;
				149:temp=slope_table_332;
				148:temp=slope_table_333;
				147:temp=slope_table_334;
				146:temp=slope_table_335;
				145:temp=slope_table_336;
				144:temp=slope_table_337;
				143:temp=slope_table_338;
				142:temp=slope_table_339;
				141:temp=slope_table_340;
				140:temp=slope_table_341;
				139:temp=slope_table_342;
				138:temp=slope_table_343;
				137:temp=slope_table_344;
				136:temp=slope_table_345;
				135:temp=slope_table_346;
				134:temp=slope_table_347;
				133:temp=slope_table_348;
				132:temp=slope_table_349;
				131:temp=slope_table_350;
				130:temp=slope_table_351;
				129:temp=slope_table_352;
				128:temp=slope_table_353;
				127:temp=slope_table_354;
				126:temp=slope_table_355;
				125:temp=slope_table_356;
				124:temp=slope_table_357;
				123:temp=slope_table_358;
				122:temp=slope_table_359;
				121:temp=slope_table_360;
				120:temp=slope_table_361;
				119:temp=slope_table_362;
				118:temp=slope_table_363;
				117:temp=slope_table_364;
				116:temp=slope_table_365;
				115:temp=slope_table_366;
				114:temp=slope_table_367;
				113:temp=slope_table_368;
				112:temp=slope_table_369;
				111:temp=slope_table_370;
				110:temp=slope_table_371;
				109:temp=slope_table_372;
				108:temp=slope_table_373;
				107:temp=slope_table_374;
				106:temp=slope_table_375;
				105:temp=slope_table_376;
				104:temp=slope_table_377;
				103:temp=slope_table_378;
				102:temp=slope_table_379;
				101:temp=slope_table_380;
				100:temp=slope_table_381;
				99 :temp=slope_table_382;
				98 :temp=slope_table_383;
				97 :temp=slope_table_384;
				96 :temp=slope_table_385;
				95 :temp=slope_table_386;
				94 :temp=slope_table_387;
				93 :temp=slope_table_388;
				92 :temp=slope_table_389;
				91 :temp=slope_table_390;
				90 :temp=slope_table_391;
				89 :temp=slope_table_392;
				88 :temp=slope_table_393;
				87 :temp=slope_table_394;
				86 :temp=slope_table_395;
				85 :temp=slope_table_396;
				84 :temp=slope_table_397;
				83 :temp=slope_table_398;
				82 :temp=slope_table_399;
				81 :temp=slope_table_400;
				80 :temp=slope_table_401;
				79 :temp=slope_table_402;
				78 :temp=slope_table_403;
				77 :temp=slope_table_404;
				76 :temp=slope_table_405;
				75 :temp=slope_table_406;
				74 :temp=slope_table_407;
				73 :temp=slope_table_408;
				72 :temp=slope_table_409;
				71 :temp=slope_table_410;
				70 :temp=slope_table_411;
				69 :temp=slope_table_412;
				68 :temp=slope_table_413;
				67 :temp=slope_table_414;
				66 :temp=slope_table_415;
				65 :temp=slope_table_416;
				64 :temp=slope_table_417;
				63 :temp=slope_table_418;
				62 :temp=slope_table_419;
				61 :temp=slope_table_420;
				60 :temp=slope_table_421;
				59 :temp=slope_table_422;
				58 :temp=slope_table_423;
				57 :temp=slope_table_424;
				56 :temp=slope_table_425;
				55 :temp=slope_table_426;
				54 :temp=slope_table_427;
				53 :temp=slope_table_428;
				52 :temp=slope_table_429;
				51 :temp=slope_table_430;
				50 :temp=slope_table_431;
				49 :temp=slope_table_432;
				48 :temp=slope_table_433;
				47 :temp=slope_table_434;
				46 :temp=slope_table_435;
				45 :temp=slope_table_436;
				44 :temp=slope_table_437;
				43 :temp=slope_table_438;
				42 :temp=slope_table_439;
				41 :temp=slope_table_440;
				40 :temp=slope_table_441;
				39 :temp=slope_table_442;
				38 :temp=slope_table_443;
				37 :temp=slope_table_444;
				36 :temp=slope_table_445;
				35 :temp=slope_table_446;
				34 :temp=slope_table_447;
				33 :temp=slope_table_448;
				32 :temp=slope_table_449;
				31 :temp=slope_table_450;
				30 :temp=slope_table_451;
				29 :temp=slope_table_452;
				28 :temp=slope_table_453;
				27 :temp=slope_table_454;
				26 :temp=slope_table_455;
				25 :temp=slope_table_456;
				24 :temp=slope_table_457;
				23 :temp=slope_table_458;
				22 :temp=slope_table_459;
				21 :temp=slope_table_460;
				20 :temp=slope_table_461;
				19 :temp=slope_table_462;
				18 :temp=slope_table_463;
				17 :temp=slope_table_464;
				16 :temp=slope_table_465;
				15 :temp=slope_table_466;
				14 :temp=slope_table_467;
				13 :temp=slope_table_468;
				12 :temp=slope_table_469;
				11 :temp=slope_table_470;
				10 :temp=slope_table_471;
				9  :temp=slope_table_472;
				8  :temp=slope_table_473;
				7  :temp=slope_table_474;
				6  :temp=slope_table_475;
				5  :temp=slope_table_476;
				4  :temp=slope_table_477;
				3  :temp=slope_table_478;
				2  :temp=slope_table_479;
				1  :temp=slope_table_480;
				0  :temp=0;//}}}
				default:temp=0;
			endcase
		end
		else temp=0;
	end
	
	always@(posedge rd_clk or negedge rst)
	begin
	    if(!rst)
			byte_counter<=0;
		else if(rst_syn)
			byte_counter<=0;
		else if(cal_truncation_en)
		begin
			//$display(temp);
			byte_counter<=byte_counter+temp;
		end
	end
	
	
	always@(*)//the number is the number of dual byte
	begin
	    case(compression_ratio)
			0:target_byte_number=4919 ;//compress ratio=5:1
			1:target_byte_number=2458  ;//compress ratio=10:1
			2:target_byte_number=1229  ;//compress ratio=20:1
			3:target_byte_number=614   ;//compress ratio=40:1
			4:target_byte_number=307   ;//compress ratio=80:1
			default:target_byte_number=0;
	    endcase
	end
	always@(posedge rd_clk or negedge rst)
	begin
	    if(!rst)
			lram_write_en<=0;
		else if(rst_syn)
			lram_write_en<=0;
		else if((state==SHIFT_PASS_SECOND_HEADER)||(state==SHIFT_CODESTREAM)||(state==SHIFT_PASS_FIRST_HEADER)||(state==SHIFT_OVER_FLAG))
			lram_write_en<=1;
		else lram_write_en<=0;
	end
	
	always@(posedge wr_clk)
	begin
	    over_reg1<=one_codeblock_over;
		over_reg2<=over_reg1;
		over_reg3<=over_reg2;
	end
	
	always@(*)
	begin
		if(fifo_group)
		begin
			case(pass_number)
				0:fifo_out=dout_plane_sp_0;
    			1:fifo_out=dout_plane_mp_0;
    			2:fifo_out=dout_plane_cp_0;
				default:fifo_out=0;
			endcase
		end
		else
		begin
			case(pass_number)
				0:fifo_out=dout_plane_sp_1;
    			1:fifo_out=dout_plane_mp_1;
    			2:fifo_out=dout_plane_cp_1;
				default:fifo_out=0;
			endcase
		end
	end
	
	always@(*)
	begin
	    case(state)
			 CAL_SLOPE_1:exponent_input=pass_error_expanded[37:8];
			 CAL_SLOPE_2:exponent_input=pass_word_count_expanded[37:8];
			 default:exponent_input=0;
			endcase
	end
	
	always@(*)
	begin
	    casex(exponent_input)
			30'b1x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=29;
			30'b01_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=28;
			30'b00_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=27;
			30'b00_01xx_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=26;
			30'b00_001x_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=25;
			30'b00_0001_xxxx_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=24;
			30'b00_0000_1xxx_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=23;
			30'b00_0000_01xx_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=22;
			30'b00_0000_001x_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=21;
			30'b00_0000_0001_xxxx_xxxx_xxxx_xxxx_xxxx:exponent=20;
			30'b00_0000_0000_1xxx_xxxx_xxxx_xxxx_xxxx:exponent=19;
			30'b00_0000_0000_01xx_xxxx_xxxx_xxxx_xxxx:exponent=18;
			30'b00_0000_0000_001x_xxxx_xxxx_xxxx_xxxx:exponent=17;
			30'b00_0000_0000_0001_xxxx_xxxx_xxxx_xxxx:exponent=16;
			30'b00_0000_0000_0000_1xxx_xxxx_xxxx_xxxx:exponent=15;
			30'b00_0000_0000_0000_01xx_xxxx_xxxx_xxxx:exponent=14;
			30'b00_0000_0000_0000_001x_xxxx_xxxx_xxxx:exponent=13;
			30'b00_0000_0000_0000_0001_xxxx_xxxx_xxxx:exponent=12;
			30'b00_0000_0000_0000_0000_1xxx_xxxx_xxxx:exponent=11;
			30'b00_0000_0000_0000_0000_01xx_xxxx_xxxx:exponent=10;
			30'b00_0000_0000_0000_0000_001x_xxxx_xxxx:exponent= 9;
			30'b00_0000_0000_0000_0000_0001_xxxx_xxxx:exponent= 8;
			30'b00_0000_0000_0000_0000_0000_1xxx_xxxx:exponent= 7;
			30'b00_0000_0000_0000_0000_0000_01xx_xxxx:exponent= 6;
			30'b00_0000_0000_0000_0000_0000_001x_xxxx:exponent= 5;
			30'b00_0000_0000_0000_0000_0000_0001_xxxx:exponent= 4;
			30'b00_0000_0000_0000_0000_0000_0000_1xxx:exponent= 3;
			30'b00_0000_0000_0000_0000_0000_0000_01xx:exponent= 2;
			30'b00_0000_0000_0000_0000_0000_0000_001x:exponent= 1;
			30'b00_0000_0000_0000_0000_0000_0000_0001:exponent= 0;
			30'b00_0000_0000_0000_0000_0000_0000_0000:exponent= 0;
			default:exponent= 5'bx;
			endcase
		
	end


	// always@(posedge flush_over)
	// begin
	    // if(!fifo_group&&(!(&empty_combo_1)))//fifo_1 not empty
			// $display("warning! fifo_1 is not empty!","at time",$time);
		// else if(fifo_group&&(!(&empty_combo_0)))//fifo_0 not empty
			// $display("warning! fifo_0 is not empty!","at time",$time);
	// end
	
	always@(posedge rd_clk or negedge rst)
	begin
	    if(!rst)
		begin
			slope_table_1  <=0;//{{{
			slope_table_2  <=0;
			slope_table_3  <=0;
			slope_table_4  <=0;
			slope_table_5  <=0;
			slope_table_6  <=0;
			slope_table_7  <=0;
			slope_table_8  <=0;
			slope_table_9  <=0;
			slope_table_10 <=0;
			slope_table_11 <=0;
			slope_table_12 <=0;
			slope_table_13 <=0;
			slope_table_14 <=0;
			slope_table_15 <=0;
			slope_table_16 <=0;
			slope_table_17 <=0;
			slope_table_18 <=0;
			slope_table_19 <=0;
			slope_table_20 <=0;
			slope_table_21 <=0;
			slope_table_22 <=0;
			slope_table_23 <=0;
			slope_table_24 <=0;
			slope_table_25 <=0;
			slope_table_26 <=0;
			slope_table_27 <=0;
			slope_table_28 <=0;
			slope_table_29 <=0;
			slope_table_30 <=0;
			slope_table_31 <=0;
			slope_table_32 <=0;
			slope_table_33 <=0;
			slope_table_34 <=0;
			slope_table_35 <=0;
			slope_table_36 <=0;
			slope_table_37 <=0;
			slope_table_38 <=0;
			slope_table_39 <=0;
			slope_table_40 <=0;
			slope_table_41 <=0;
			slope_table_42 <=0;
			slope_table_43 <=0;
			slope_table_44 <=0;
			slope_table_45 <=0;
			slope_table_46 <=0;
			slope_table_47 <=0;
			slope_table_48 <=0;
			slope_table_49 <=0;
			slope_table_50 <=0;
			slope_table_51 <=0;
			slope_table_52 <=0;
			slope_table_53 <=0;
			slope_table_54 <=0;
			slope_table_55 <=0;
			slope_table_56 <=0;
			slope_table_57 <=0;
			slope_table_58 <=0;
			slope_table_59 <=0;
			slope_table_60 <=0;
			slope_table_61 <=0;
			slope_table_62 <=0;
			slope_table_63 <=0;
			slope_table_64 <=0;
			slope_table_65 <=0;
			slope_table_66 <=0;
			slope_table_67 <=0;
			slope_table_68 <=0;
			slope_table_69 <=0;
			slope_table_70 <=0;
			slope_table_71 <=0;
			slope_table_72 <=0;
			slope_table_73 <=0;
			slope_table_74 <=0;
			slope_table_75 <=0;
			slope_table_76 <=0;
			slope_table_77 <=0;
			slope_table_78 <=0;
			slope_table_79 <=0;
			slope_table_80 <=0;
			slope_table_81 <=0;
			slope_table_82 <=0;
			slope_table_83 <=0;
			slope_table_84 <=0;
			slope_table_85 <=0;
			slope_table_86 <=0;
			slope_table_87 <=0;
			slope_table_88 <=0;
			slope_table_89 <=0;
			slope_table_90 <=0;
			slope_table_91 <=0;
			slope_table_92 <=0;
			slope_table_93 <=0;
			slope_table_94 <=0;
			slope_table_95 <=0;
			slope_table_96 <=0;
			slope_table_97 <=0;
			slope_table_98 <=0;
			slope_table_99 <=0;
			slope_table_100<=0; 
			slope_table_101<=0; 
			slope_table_102<=0; 
			slope_table_103<=0; 
			slope_table_104<=0; 
			slope_table_105<=0; 
			slope_table_106<=0; 
			slope_table_107<=0; 
			slope_table_108<=0; 
			slope_table_109<=0; 
			slope_table_110<=0; 
			slope_table_111<=0; 
			slope_table_112<=0; 
			slope_table_113<=0; 
			slope_table_114<=0; 
			slope_table_115<=0; 
			slope_table_116<=0; 
			slope_table_117<=0; 
			slope_table_118<=0; 
			slope_table_119<=0; 
			slope_table_120<=0; 
			slope_table_121<=0; 
			slope_table_122<=0; 
			slope_table_123<=0; 
			slope_table_124<=0; 
			slope_table_125<=0; 
			slope_table_126<=0; 
			slope_table_127<=0; 
			slope_table_128<=0; 
			slope_table_129<=0; 
			slope_table_130<=0; 
			slope_table_131<=0; 
			slope_table_132<=0; 
			slope_table_133<=0; 
			slope_table_134<=0; 
			slope_table_135<=0; 
			slope_table_136<=0; 
			slope_table_137<=0; 
			slope_table_138<=0; 
			slope_table_139<=0; 
			slope_table_140<=0; 
			slope_table_141<=0; 
			slope_table_142<=0; 
			slope_table_143<=0; 
			slope_table_144<=0; 
			slope_table_145<=0; 
			slope_table_146<=0; 
			slope_table_147<=0; 
			slope_table_148<=0; 
			slope_table_149<=0; 
			slope_table_150<=0; 
			slope_table_151<=0; 
			slope_table_152<=0; 
			slope_table_153<=0; 
			slope_table_154<=0; 
			slope_table_155<=0; 
			slope_table_156<=0; 
			slope_table_157<=0; 
			slope_table_158<=0; 
			slope_table_159<=0; 
			slope_table_160<=0; 
			slope_table_161<=0; 
			slope_table_162<=0; 
			slope_table_163<=0; 
			slope_table_164<=0; 
			slope_table_165<=0; 
			slope_table_166<=0; 
			slope_table_167<=0; 
			slope_table_168<=0; 
			slope_table_169<=0; 
			slope_table_170<=0; 
			slope_table_171<=0; 
			slope_table_172<=0; 
			slope_table_173<=0; 
			slope_table_174<=0; 
			slope_table_175<=0; 
			slope_table_176<=0; 
			slope_table_177<=0; 
			slope_table_178<=0; 
			slope_table_179<=0; 
			slope_table_180<=0; 
			slope_table_181<=0; 
			slope_table_182<=0; 
			slope_table_183<=0; 
			slope_table_184<=0; 
			slope_table_185<=0; 
			slope_table_186<=0; 
			slope_table_187<=0; 
			slope_table_188<=0; 
			slope_table_189<=0; 
			slope_table_190<=0; 
			slope_table_191<=0; 
			slope_table_192<=0; 
			slope_table_193<=0; 
			slope_table_194<=0; 
			slope_table_195<=0; 
			slope_table_196<=0; 
			slope_table_197<=0; 
			slope_table_198<=0; 
			slope_table_199<=0; 
			slope_table_200<=0; 
			slope_table_201<=0; 
			slope_table_202<=0; 
			slope_table_203<=0; 
			slope_table_204<=0; 
			slope_table_205<=0; 
			slope_table_206<=0; 
			slope_table_207<=0; 
			slope_table_208<=0; 
			slope_table_209<=0; 
			slope_table_210<=0; 
			slope_table_211<=0; 
			slope_table_212<=0; 
			slope_table_213<=0; 
			slope_table_214<=0; 
			slope_table_215<=0; 
			slope_table_216<=0; 
			slope_table_217<=0; 
			slope_table_218<=0; 
			slope_table_219<=0; 
			slope_table_220<=0; 
			slope_table_221<=0; 
			slope_table_222<=0; 
			slope_table_223<=0; 
			slope_table_224<=0; 
			slope_table_225<=0; 
			slope_table_226<=0; 
			slope_table_227<=0; 
			slope_table_228<=0; 
			slope_table_229<=0; 
			slope_table_230<=0; 
			slope_table_231<=0; 
			slope_table_232<=0; 
			slope_table_233<=0; 
			slope_table_234<=0; 
			slope_table_235<=0; 
			slope_table_236<=0; 
			slope_table_237<=0; 
			slope_table_238<=0; 
			slope_table_239<=0; 
			slope_table_240<=0; 
			slope_table_241<=0; 
			slope_table_242<=0; 
			slope_table_243<=0; 
			slope_table_244<=0; 
			slope_table_245<=0; 
			slope_table_246<=0; 
			slope_table_247<=0; 
			slope_table_248<=0; 
			slope_table_249<=0; 
			slope_table_250<=0; 
			slope_table_251<=0; 
			slope_table_252<=0; 
			slope_table_253<=0; 
			slope_table_254<=0; 
			slope_table_255<=0; 
			slope_table_256<=0; 
			slope_table_257<=0; 
			slope_table_258<=0; 
			slope_table_259<=0; 
			slope_table_260<=0; 
			slope_table_261<=0; 
			slope_table_262<=0; 
			slope_table_263<=0; 
			slope_table_264<=0; 
			slope_table_265<=0; 
			slope_table_266<=0; 
			slope_table_267<=0; 
			slope_table_268<=0; 
			slope_table_269<=0; 
			slope_table_270<=0; 
			slope_table_271<=0; 
			slope_table_272<=0; 
			slope_table_273<=0; 
			slope_table_274<=0; 
			slope_table_275<=0; 
			slope_table_276<=0; 
			slope_table_277<=0; 
			slope_table_278<=0; 
			slope_table_279<=0; 
			slope_table_280<=0; 
			slope_table_281<=0; 
			slope_table_282<=0; 
			slope_table_283<=0; 
			slope_table_284<=0; 
			slope_table_285<=0; 
			slope_table_286<=0; 
			slope_table_287<=0; 
			slope_table_288<=0; 
			slope_table_289<=0; 
			slope_table_290<=0; 
			slope_table_291<=0; 
			slope_table_292<=0; 
			slope_table_293<=0; 
			slope_table_294<=0; 
			slope_table_295<=0; 
			slope_table_296<=0; 
			slope_table_297<=0; 
			slope_table_298<=0; 
			slope_table_299<=0; 
			slope_table_300<=0; 
			slope_table_301<=0; 
			slope_table_302<=0; 
			slope_table_303<=0; 
			slope_table_304<=0; 
			slope_table_305<=0; 
			slope_table_306<=0; 
			slope_table_307<=0; 
			slope_table_308<=0; 
			slope_table_309<=0; 
			slope_table_310<=0; 
			slope_table_311<=0; 
			slope_table_312<=0; 
			slope_table_313<=0; 
			slope_table_314<=0; 
			slope_table_315<=0; 
			slope_table_316<=0; 
			slope_table_317<=0; 
			slope_table_318<=0; 
			slope_table_319<=0; 
			slope_table_320<=0; 
			slope_table_321<=0; 
			slope_table_322<=0; 
			slope_table_323<=0; 
			slope_table_324<=0; 
			slope_table_325<=0; 
			slope_table_326<=0; 
			slope_table_327<=0; 
			slope_table_328<=0; 
			slope_table_329<=0; 
			slope_table_330<=0; 
			slope_table_331<=0; 
			slope_table_332<=0; 
			slope_table_333<=0; 
			slope_table_334<=0; 
			slope_table_335<=0; 
			slope_table_336<=0; 
			slope_table_337<=0; 
			slope_table_338<=0; 
			slope_table_339<=0; 
			slope_table_340<=0; 
			slope_table_341<=0; 
			slope_table_342<=0; 
			slope_table_343<=0; 
			slope_table_344<=0; 
			slope_table_345<=0; 
			slope_table_346<=0; 
			slope_table_347<=0; 
			slope_table_348<=0; 
			slope_table_349<=0; 
			slope_table_350<=0; 
			slope_table_351<=0; 
			slope_table_352<=0; 
			slope_table_353<=0; 
			slope_table_354<=0; 
			slope_table_355<=0; 
			slope_table_356<=0; 
			slope_table_357<=0; 
			slope_table_358<=0; 
			slope_table_359<=0; 
			slope_table_360<=0; 
			slope_table_361<=0; 
			slope_table_362<=0; 
			slope_table_363<=0; 
			slope_table_364<=0; 
			slope_table_365<=0; 
			slope_table_366<=0; 
			slope_table_367<=0; 
			slope_table_368<=0; 
			slope_table_369<=0; 
			slope_table_370<=0; 
			slope_table_371<=0; 
			slope_table_372<=0; 
			slope_table_373<=0; 
			slope_table_374<=0; 
			slope_table_375<=0; 
			slope_table_376<=0; 
			slope_table_377<=0; 
			slope_table_378<=0; 
			slope_table_379<=0; 
			slope_table_380<=0; 
			slope_table_381<=0; 
			slope_table_382<=0; 
			slope_table_383<=0; 
			slope_table_384<=0; 
			slope_table_385<=0; 
			slope_table_386<=0; 
			slope_table_387<=0; 
			slope_table_388<=0; 
			slope_table_389<=0; 
			slope_table_390<=0; 
			slope_table_391<=0; 
			slope_table_392<=0; 
			slope_table_393<=0; 
			slope_table_394<=0; 
			slope_table_395<=0; 
			slope_table_396<=0; 
			slope_table_397<=0; 
			slope_table_398<=0; 
			slope_table_399<=0; 
			slope_table_400<=0; 
			slope_table_401<=0; 
			slope_table_402<=0; 
			slope_table_403<=0; 
			slope_table_404<=0; 
			slope_table_405<=0; 
			slope_table_406<=0; 
			slope_table_407<=0; 
			slope_table_408<=0; 
			slope_table_409<=0; 
			slope_table_410<=0; 
			slope_table_411<=0; 
			slope_table_412<=0; 
			slope_table_413<=0; 
			slope_table_414<=0; 
			slope_table_415<=0; 
			slope_table_416<=0; 
			slope_table_417<=0; 
			slope_table_418<=0; 
			slope_table_419<=0; 
			slope_table_420<=0; 
			slope_table_421<=0; 
			slope_table_422<=0; 
			slope_table_423<=0; 
			slope_table_424<=0; 
			slope_table_425<=0; 
			slope_table_426<=0; 
			slope_table_427<=0; 
			slope_table_428<=0; 
			slope_table_429<=0; 
			slope_table_430<=0; 
			slope_table_431<=0; 
			slope_table_432<=0; 
			slope_table_433<=0; 
			slope_table_434<=0; 
			slope_table_435<=0; 
			slope_table_436<=0; 
			slope_table_437<=0; 
			slope_table_438<=0; 
			slope_table_439<=0; 
			slope_table_440<=0; 
			slope_table_441<=0; 
			slope_table_442<=0; 
			slope_table_443<=0; 
			slope_table_444<=0; 
			slope_table_445<=0; 
			slope_table_446<=0; 
			slope_table_447<=0; 
			slope_table_448<=0; 
			slope_table_449<=0; 
			slope_table_450<=0; 
			slope_table_451<=0; 
			slope_table_452<=0; 
			slope_table_453<=0; 
			slope_table_454<=0; 
			slope_table_455<=0; 
			slope_table_456<=0; 
			slope_table_457<=0; 
			slope_table_458<=0; 
			slope_table_459<=0; 
			slope_table_460<=0; 
			slope_table_461<=0; 
			slope_table_462<=0; 
			slope_table_463<=0; 
			slope_table_464<=0; 
			slope_table_465<=0; 
			slope_table_466<=0; 
			slope_table_467<=0; 
			slope_table_468<=0; 
			slope_table_469<=0; 
			slope_table_470<=0; 
			slope_table_471<=0; 
			slope_table_472<=0; 
			slope_table_473<=0; 
			slope_table_474<=0; 
			slope_table_475<=0; 
			slope_table_476<=0; 
			slope_table_477<=0; 
			slope_table_478<=0; 
			slope_table_479<=0; 
			slope_table_480<=0;
		end
		else if(rst_syn)
		begin
			slope_table_1  <=0;
			slope_table_2  <=0;
			slope_table_3  <=0;
			slope_table_4  <=0;
			slope_table_5  <=0;
			slope_table_6  <=0;
			slope_table_7  <=0;
			slope_table_8  <=0;
			slope_table_9  <=0;
			slope_table_10 <=0;
			slope_table_11 <=0;
			slope_table_12 <=0;
			slope_table_13 <=0;
			slope_table_14 <=0;
			slope_table_15 <=0;
			slope_table_16 <=0;
			slope_table_17 <=0;
			slope_table_18 <=0;
			slope_table_19 <=0;
			slope_table_20 <=0;
			slope_table_21 <=0;
			slope_table_22 <=0;
			slope_table_23 <=0;
			slope_table_24 <=0;
			slope_table_25 <=0;
			slope_table_26 <=0;
			slope_table_27 <=0;
			slope_table_28 <=0;
			slope_table_29 <=0;
			slope_table_30 <=0;
			slope_table_31 <=0;
			slope_table_32 <=0;
			slope_table_33 <=0;
			slope_table_34 <=0;
			slope_table_35 <=0;
			slope_table_36 <=0;
			slope_table_37 <=0;
			slope_table_38 <=0;
			slope_table_39 <=0;
			slope_table_40 <=0;
			slope_table_41 <=0;
			slope_table_42 <=0;
			slope_table_43 <=0;
			slope_table_44 <=0;
			slope_table_45 <=0;
			slope_table_46 <=0;
			slope_table_47 <=0;
			slope_table_48 <=0;
			slope_table_49 <=0;
			slope_table_50 <=0;
			slope_table_51 <=0;
			slope_table_52 <=0;
			slope_table_53 <=0;
			slope_table_54 <=0;
			slope_table_55 <=0;
			slope_table_56 <=0;
			slope_table_57 <=0;
			slope_table_58 <=0;
			slope_table_59 <=0;
			slope_table_60 <=0;
			slope_table_61 <=0;
			slope_table_62 <=0;
			slope_table_63 <=0;
			slope_table_64 <=0;
			slope_table_65 <=0;
			slope_table_66 <=0;
			slope_table_67 <=0;
			slope_table_68 <=0;
			slope_table_69 <=0;
			slope_table_70 <=0;
			slope_table_71 <=0;
			slope_table_72 <=0;
			slope_table_73 <=0;
			slope_table_74 <=0;
			slope_table_75 <=0;
			slope_table_76 <=0;
			slope_table_77 <=0;
			slope_table_78 <=0;
			slope_table_79 <=0;
			slope_table_80 <=0;
			slope_table_81 <=0;
			slope_table_82 <=0;
			slope_table_83 <=0;
			slope_table_84 <=0;
			slope_table_85 <=0;
			slope_table_86 <=0;
			slope_table_87 <=0;
			slope_table_88 <=0;
			slope_table_89 <=0;
			slope_table_90 <=0;
			slope_table_91 <=0;
			slope_table_92 <=0;
			slope_table_93 <=0;
			slope_table_94 <=0;
			slope_table_95 <=0;
			slope_table_96 <=0;
			slope_table_97 <=0;
			slope_table_98 <=0;
			slope_table_99 <=0;
			slope_table_100<=0; 
			slope_table_101<=0; 
			slope_table_102<=0; 
			slope_table_103<=0; 
			slope_table_104<=0; 
			slope_table_105<=0; 
			slope_table_106<=0; 
			slope_table_107<=0; 
			slope_table_108<=0; 
			slope_table_109<=0; 
			slope_table_110<=0; 
			slope_table_111<=0; 
			slope_table_112<=0; 
			slope_table_113<=0; 
			slope_table_114<=0; 
			slope_table_115<=0; 
			slope_table_116<=0; 
			slope_table_117<=0; 
			slope_table_118<=0; 
			slope_table_119<=0; 
			slope_table_120<=0; 
			slope_table_121<=0; 
			slope_table_122<=0; 
			slope_table_123<=0; 
			slope_table_124<=0; 
			slope_table_125<=0; 
			slope_table_126<=0; 
			slope_table_127<=0; 
			slope_table_128<=0; 
			slope_table_129<=0; 
			slope_table_130<=0; 
			slope_table_131<=0; 
			slope_table_132<=0; 
			slope_table_133<=0; 
			slope_table_134<=0; 
			slope_table_135<=0; 
			slope_table_136<=0; 
			slope_table_137<=0; 
			slope_table_138<=0; 
			slope_table_139<=0; 
			slope_table_140<=0; 
			slope_table_141<=0; 
			slope_table_142<=0; 
			slope_table_143<=0; 
			slope_table_144<=0; 
			slope_table_145<=0; 
			slope_table_146<=0; 
			slope_table_147<=0; 
			slope_table_148<=0; 
			slope_table_149<=0; 
			slope_table_150<=0; 
			slope_table_151<=0; 
			slope_table_152<=0; 
			slope_table_153<=0; 
			slope_table_154<=0; 
			slope_table_155<=0; 
			slope_table_156<=0; 
			slope_table_157<=0; 
			slope_table_158<=0; 
			slope_table_159<=0; 
			slope_table_160<=0; 
			slope_table_161<=0; 
			slope_table_162<=0; 
			slope_table_163<=0; 
			slope_table_164<=0; 
			slope_table_165<=0; 
			slope_table_166<=0; 
			slope_table_167<=0; 
			slope_table_168<=0; 
			slope_table_169<=0; 
			slope_table_170<=0; 
			slope_table_171<=0; 
			slope_table_172<=0; 
			slope_table_173<=0; 
			slope_table_174<=0; 
			slope_table_175<=0; 
			slope_table_176<=0; 
			slope_table_177<=0; 
			slope_table_178<=0; 
			slope_table_179<=0; 
			slope_table_180<=0; 
			slope_table_181<=0; 
			slope_table_182<=0; 
			slope_table_183<=0; 
			slope_table_184<=0; 
			slope_table_185<=0; 
			slope_table_186<=0; 
			slope_table_187<=0; 
			slope_table_188<=0; 
			slope_table_189<=0; 
			slope_table_190<=0; 
			slope_table_191<=0; 
			slope_table_192<=0; 
			slope_table_193<=0; 
			slope_table_194<=0; 
			slope_table_195<=0; 
			slope_table_196<=0; 
			slope_table_197<=0; 
			slope_table_198<=0; 
			slope_table_199<=0; 
			slope_table_200<=0; 
			slope_table_201<=0; 
			slope_table_202<=0; 
			slope_table_203<=0; 
			slope_table_204<=0; 
			slope_table_205<=0; 
			slope_table_206<=0; 
			slope_table_207<=0; 
			slope_table_208<=0; 
			slope_table_209<=0; 
			slope_table_210<=0; 
			slope_table_211<=0; 
			slope_table_212<=0; 
			slope_table_213<=0; 
			slope_table_214<=0; 
			slope_table_215<=0; 
			slope_table_216<=0; 
			slope_table_217<=0; 
			slope_table_218<=0; 
			slope_table_219<=0; 
			slope_table_220<=0; 
			slope_table_221<=0; 
			slope_table_222<=0; 
			slope_table_223<=0; 
			slope_table_224<=0; 
			slope_table_225<=0; 
			slope_table_226<=0; 
			slope_table_227<=0; 
			slope_table_228<=0; 
			slope_table_229<=0; 
			slope_table_230<=0; 
			slope_table_231<=0; 
			slope_table_232<=0; 
			slope_table_233<=0; 
			slope_table_234<=0; 
			slope_table_235<=0; 
			slope_table_236<=0; 
			slope_table_237<=0; 
			slope_table_238<=0; 
			slope_table_239<=0; 
			slope_table_240<=0; 
			slope_table_241<=0; 
			slope_table_242<=0; 
			slope_table_243<=0; 
			slope_table_244<=0; 
			slope_table_245<=0; 
			slope_table_246<=0; 
			slope_table_247<=0; 
			slope_table_248<=0; 
			slope_table_249<=0; 
			slope_table_250<=0; 
			slope_table_251<=0; 
			slope_table_252<=0; 
			slope_table_253<=0; 
			slope_table_254<=0; 
			slope_table_255<=0; 
			slope_table_256<=0; 
			slope_table_257<=0; 
			slope_table_258<=0; 
			slope_table_259<=0; 
			slope_table_260<=0; 
			slope_table_261<=0; 
			slope_table_262<=0; 
			slope_table_263<=0; 
			slope_table_264<=0; 
			slope_table_265<=0; 
			slope_table_266<=0; 
			slope_table_267<=0; 
			slope_table_268<=0; 
			slope_table_269<=0; 
			slope_table_270<=0; 
			slope_table_271<=0; 
			slope_table_272<=0; 
			slope_table_273<=0; 
			slope_table_274<=0; 
			slope_table_275<=0; 
			slope_table_276<=0; 
			slope_table_277<=0; 
			slope_table_278<=0; 
			slope_table_279<=0; 
			slope_table_280<=0; 
			slope_table_281<=0; 
			slope_table_282<=0; 
			slope_table_283<=0; 
			slope_table_284<=0; 
			slope_table_285<=0; 
			slope_table_286<=0; 
			slope_table_287<=0; 
			slope_table_288<=0; 
			slope_table_289<=0; 
			slope_table_290<=0; 
			slope_table_291<=0; 
			slope_table_292<=0; 
			slope_table_293<=0; 
			slope_table_294<=0; 
			slope_table_295<=0; 
			slope_table_296<=0; 
			slope_table_297<=0; 
			slope_table_298<=0; 
			slope_table_299<=0; 
			slope_table_300<=0; 
			slope_table_301<=0; 
			slope_table_302<=0; 
			slope_table_303<=0; 
			slope_table_304<=0; 
			slope_table_305<=0; 
			slope_table_306<=0; 
			slope_table_307<=0; 
			slope_table_308<=0; 
			slope_table_309<=0; 
			slope_table_310<=0; 
			slope_table_311<=0; 
			slope_table_312<=0; 
			slope_table_313<=0; 
			slope_table_314<=0; 
			slope_table_315<=0; 
			slope_table_316<=0; 
			slope_table_317<=0; 
			slope_table_318<=0; 
			slope_table_319<=0; 
			slope_table_320<=0; 
			slope_table_321<=0; 
			slope_table_322<=0; 
			slope_table_323<=0; 
			slope_table_324<=0; 
			slope_table_325<=0; 
			slope_table_326<=0; 
			slope_table_327<=0; 
			slope_table_328<=0; 
			slope_table_329<=0; 
			slope_table_330<=0; 
			slope_table_331<=0; 
			slope_table_332<=0; 
			slope_table_333<=0; 
			slope_table_334<=0; 
			slope_table_335<=0; 
			slope_table_336<=0; 
			slope_table_337<=0; 
			slope_table_338<=0; 
			slope_table_339<=0; 
			slope_table_340<=0; 
			slope_table_341<=0; 
			slope_table_342<=0; 
			slope_table_343<=0; 
			slope_table_344<=0; 
			slope_table_345<=0; 
			slope_table_346<=0; 
			slope_table_347<=0; 
			slope_table_348<=0; 
			slope_table_349<=0; 
			slope_table_350<=0; 
			slope_table_351<=0; 
			slope_table_352<=0; 
			slope_table_353<=0; 
			slope_table_354<=0; 
			slope_table_355<=0; 
			slope_table_356<=0; 
			slope_table_357<=0; 
			slope_table_358<=0; 
			slope_table_359<=0; 
			slope_table_360<=0; 
			slope_table_361<=0; 
			slope_table_362<=0; 
			slope_table_363<=0; 
			slope_table_364<=0; 
			slope_table_365<=0; 
			slope_table_366<=0; 
			slope_table_367<=0; 
			slope_table_368<=0; 
			slope_table_369<=0; 
			slope_table_370<=0; 
			slope_table_371<=0; 
			slope_table_372<=0; 
			slope_table_373<=0; 
			slope_table_374<=0; 
			slope_table_375<=0; 
			slope_table_376<=0; 
			slope_table_377<=0; 
			slope_table_378<=0; 
			slope_table_379<=0; 
			slope_table_380<=0; 
			slope_table_381<=0; 
			slope_table_382<=0; 
			slope_table_383<=0; 
			slope_table_384<=0; 
			slope_table_385<=0; 
			slope_table_386<=0; 
			slope_table_387<=0; 
			slope_table_388<=0; 
			slope_table_389<=0; 
			slope_table_390<=0; 
			slope_table_391<=0; 
			slope_table_392<=0; 
			slope_table_393<=0; 
			slope_table_394<=0; 
			slope_table_395<=0; 
			slope_table_396<=0; 
			slope_table_397<=0; 
			slope_table_398<=0; 
			slope_table_399<=0; 
			slope_table_400<=0; 
			slope_table_401<=0; 
			slope_table_402<=0; 
			slope_table_403<=0; 
			slope_table_404<=0; 
			slope_table_405<=0; 
			slope_table_406<=0; 
			slope_table_407<=0; 
			slope_table_408<=0; 
			slope_table_409<=0; 
			slope_table_410<=0; 
			slope_table_411<=0; 
			slope_table_412<=0; 
			slope_table_413<=0; 
			slope_table_414<=0; 
			slope_table_415<=0; 
			slope_table_416<=0; 
			slope_table_417<=0; 
			slope_table_418<=0; 
			slope_table_419<=0; 
			slope_table_420<=0; 
			slope_table_421<=0; 
			slope_table_422<=0; 
			slope_table_423<=0; 
			slope_table_424<=0; 
			slope_table_425<=0; 
			slope_table_426<=0; 
			slope_table_427<=0; 
			slope_table_428<=0; 
			slope_table_429<=0; 
			slope_table_430<=0; 
			slope_table_431<=0; 
			slope_table_432<=0; 
			slope_table_433<=0; 
			slope_table_434<=0; 
			slope_table_435<=0; 
			slope_table_436<=0; 
			slope_table_437<=0; 
			slope_table_438<=0; 
			slope_table_439<=0; 
			slope_table_440<=0; 
			slope_table_441<=0; 
			slope_table_442<=0; 
			slope_table_443<=0; 
			slope_table_444<=0; 
			slope_table_445<=0; 
			slope_table_446<=0; 
			slope_table_447<=0; 
			slope_table_448<=0; 
			slope_table_449<=0; 
			slope_table_450<=0; 
			slope_table_451<=0; 
			slope_table_452<=0; 
			slope_table_453<=0; 
			slope_table_454<=0; 
			slope_table_455<=0; 
			slope_table_456<=0; 
			slope_table_457<=0; 
			slope_table_458<=0; 
			slope_table_459<=0; 
			slope_table_460<=0; 
			slope_table_461<=0; 
			slope_table_462<=0; 
			slope_table_463<=0; 
			slope_table_464<=0; 
			slope_table_465<=0; 
			slope_table_466<=0; 
			slope_table_467<=0; 
			slope_table_468<=0; 
			slope_table_469<=0; 
			slope_table_470<=0; 
			slope_table_471<=0; 
			slope_table_472<=0; 
			slope_table_473<=0; 
			slope_table_474<=0; 
			slope_table_475<=0; 
			slope_table_476<=0; 
			slope_table_477<=0; 
			slope_table_478<=0; 
			slope_table_479<=0; 
			slope_table_480<=0;
		end
		else if(state==SHIFT_PASS_FIRST_HEADER)
		begin
			case(slope)
				1  :slope_table_1  <=slope_table_1  +pass_word_count;
				2  :slope_table_2  <=slope_table_2  +pass_word_count;
				3  :slope_table_3  <=slope_table_3  +pass_word_count;
				4  :slope_table_4  <=slope_table_4  +pass_word_count;
				5  :slope_table_5  <=slope_table_5  +pass_word_count;
				6  :slope_table_6  <=slope_table_6  +pass_word_count;
				7  :slope_table_7  <=slope_table_7  +pass_word_count;
				8  :slope_table_8  <=slope_table_8  +pass_word_count;
				9  :slope_table_9  <=slope_table_9  +pass_word_count;
				10 :slope_table_10 <=slope_table_10 +pass_word_count;
				11 :slope_table_11 <=slope_table_11 +pass_word_count;
				12 :slope_table_12 <=slope_table_12 +pass_word_count;
				13 :slope_table_13 <=slope_table_13 +pass_word_count;
				14 :slope_table_14 <=slope_table_14 +pass_word_count;
				15 :slope_table_15 <=slope_table_15 +pass_word_count;
				16 :slope_table_16 <=slope_table_16 +pass_word_count;
				17 :slope_table_17 <=slope_table_17 +pass_word_count;
				18 :slope_table_18 <=slope_table_18 +pass_word_count;
				19 :slope_table_19 <=slope_table_19 +pass_word_count;
				20 :slope_table_20 <=slope_table_20 +pass_word_count;
				21 :slope_table_21 <=slope_table_21 +pass_word_count;
				22 :slope_table_22 <=slope_table_22 +pass_word_count;
				23 :slope_table_23 <=slope_table_23 +pass_word_count;
				24 :slope_table_24 <=slope_table_24 +pass_word_count;
				25 :slope_table_25 <=slope_table_25 +pass_word_count;
				26 :slope_table_26 <=slope_table_26 +pass_word_count;
				27 :slope_table_27 <=slope_table_27 +pass_word_count;
				28 :slope_table_28 <=slope_table_28 +pass_word_count;
				29 :slope_table_29 <=slope_table_29 +pass_word_count;
				30 :slope_table_30 <=slope_table_30 +pass_word_count;
				31 :slope_table_31 <=slope_table_31 +pass_word_count;
				32 :slope_table_32 <=slope_table_32 +pass_word_count;
				33 :slope_table_33 <=slope_table_33 +pass_word_count;
				34 :slope_table_34 <=slope_table_34 +pass_word_count;
				35 :slope_table_35 <=slope_table_35 +pass_word_count;
				36 :slope_table_36 <=slope_table_36 +pass_word_count;
				37 :slope_table_37 <=slope_table_37 +pass_word_count;
				38 :slope_table_38 <=slope_table_38 +pass_word_count;
				39 :slope_table_39 <=slope_table_39 +pass_word_count;
				40 :slope_table_40 <=slope_table_40 +pass_word_count;
				41 :slope_table_41 <=slope_table_41 +pass_word_count;
				42 :slope_table_42 <=slope_table_42 +pass_word_count;
				43 :slope_table_43 <=slope_table_43 +pass_word_count;
				44 :slope_table_44 <=slope_table_44 +pass_word_count;
				45 :slope_table_45 <=slope_table_45 +pass_word_count;
				46 :slope_table_46 <=slope_table_46 +pass_word_count;
				47 :slope_table_47 <=slope_table_47 +pass_word_count;
				48 :slope_table_48 <=slope_table_48 +pass_word_count;
				49 :slope_table_49 <=slope_table_49 +pass_word_count;
				50 :slope_table_50 <=slope_table_50 +pass_word_count;
				51 :slope_table_51 <=slope_table_51 +pass_word_count;
				52 :slope_table_52 <=slope_table_52 +pass_word_count;
				53 :slope_table_53 <=slope_table_53 +pass_word_count;
				54 :slope_table_54 <=slope_table_54 +pass_word_count;
				55 :slope_table_55 <=slope_table_55 +pass_word_count;
				56 :slope_table_56 <=slope_table_56 +pass_word_count;
				57 :slope_table_57 <=slope_table_57 +pass_word_count;
				58 :slope_table_58 <=slope_table_58 +pass_word_count;
				59 :slope_table_59 <=slope_table_59 +pass_word_count;
				60 :slope_table_60 <=slope_table_60 +pass_word_count;
				61 :slope_table_61 <=slope_table_61 +pass_word_count;
				62 :slope_table_62 <=slope_table_62 +pass_word_count;
				63 :slope_table_63 <=slope_table_63 +pass_word_count;
				64 :slope_table_64 <=slope_table_64 +pass_word_count;
				65 :slope_table_65 <=slope_table_65 +pass_word_count;
				66 :slope_table_66 <=slope_table_66 +pass_word_count;
				67 :slope_table_67 <=slope_table_67 +pass_word_count;
				68 :slope_table_68 <=slope_table_68 +pass_word_count;
				69 :slope_table_69 <=slope_table_69 +pass_word_count;
				70 :slope_table_70 <=slope_table_70 +pass_word_count;
				71 :slope_table_71 <=slope_table_71 +pass_word_count;
				72 :slope_table_72 <=slope_table_72 +pass_word_count;
				73 :slope_table_73 <=slope_table_73 +pass_word_count;
				74 :slope_table_74 <=slope_table_74 +pass_word_count;
				75 :slope_table_75 <=slope_table_75 +pass_word_count;
				76 :slope_table_76 <=slope_table_76 +pass_word_count;
				77 :slope_table_77 <=slope_table_77 +pass_word_count;
				78 :slope_table_78 <=slope_table_78 +pass_word_count;
				79 :slope_table_79 <=slope_table_79 +pass_word_count;
				80 :slope_table_80 <=slope_table_80 +pass_word_count;
				81 :slope_table_81 <=slope_table_81 +pass_word_count;
				82 :slope_table_82 <=slope_table_82 +pass_word_count;
				83 :slope_table_83 <=slope_table_83 +pass_word_count;
				84 :slope_table_84 <=slope_table_84 +pass_word_count;
				85 :slope_table_85 <=slope_table_85 +pass_word_count;
				86 :slope_table_86 <=slope_table_86 +pass_word_count;
				87 :slope_table_87 <=slope_table_87 +pass_word_count;
				88 :slope_table_88 <=slope_table_88 +pass_word_count;
				89 :slope_table_89 <=slope_table_89 +pass_word_count;
				90 :slope_table_90 <=slope_table_90 +pass_word_count;
				91 :slope_table_91 <=slope_table_91 +pass_word_count;
				92 :slope_table_92 <=slope_table_92 +pass_word_count;
				93 :slope_table_93 <=slope_table_93 +pass_word_count;
				94 :slope_table_94 <=slope_table_94 +pass_word_count;
				95 :slope_table_95 <=slope_table_95 +pass_word_count;
				96 :slope_table_96 <=slope_table_96 +pass_word_count;
				97 :slope_table_97 <=slope_table_97 +pass_word_count;
				98 :slope_table_98 <=slope_table_98 +pass_word_count;
				99 :slope_table_99 <=slope_table_99 +pass_word_count;
				100:slope_table_100<=slope_table_100+pass_word_count; 
				101:slope_table_101<=slope_table_101+pass_word_count; 
				102:slope_table_102<=slope_table_102+pass_word_count; 
				103:slope_table_103<=slope_table_103+pass_word_count; 
				104:slope_table_104<=slope_table_104+pass_word_count; 
				105:slope_table_105<=slope_table_105+pass_word_count; 
				106:slope_table_106<=slope_table_106+pass_word_count; 
				107:slope_table_107<=slope_table_107+pass_word_count; 
				108:slope_table_108<=slope_table_108+pass_word_count; 
				109:slope_table_109<=slope_table_109+pass_word_count; 
				110:slope_table_110<=slope_table_110+pass_word_count; 
				111:slope_table_111<=slope_table_111+pass_word_count; 
				112:slope_table_112<=slope_table_112+pass_word_count; 
				113:slope_table_113<=slope_table_113+pass_word_count; 
				114:slope_table_114<=slope_table_114+pass_word_count; 
				115:slope_table_115<=slope_table_115+pass_word_count; 
				116:slope_table_116<=slope_table_116+pass_word_count; 
				117:slope_table_117<=slope_table_117+pass_word_count; 
				118:slope_table_118<=slope_table_118+pass_word_count; 
				119:slope_table_119<=slope_table_119+pass_word_count; 
				120:slope_table_120<=slope_table_120+pass_word_count; 
				121:slope_table_121<=slope_table_121+pass_word_count; 
				122:slope_table_122<=slope_table_122+pass_word_count; 
				123:slope_table_123<=slope_table_123+pass_word_count; 
				124:slope_table_124<=slope_table_124+pass_word_count; 
				125:slope_table_125<=slope_table_125+pass_word_count; 
				126:slope_table_126<=slope_table_126+pass_word_count; 
				127:slope_table_127<=slope_table_127+pass_word_count; 
				128:slope_table_128<=slope_table_128+pass_word_count; 
				129:slope_table_129<=slope_table_129+pass_word_count; 
				130:slope_table_130<=slope_table_130+pass_word_count; 
				131:slope_table_131<=slope_table_131+pass_word_count; 
				132:slope_table_132<=slope_table_132+pass_word_count; 
				133:slope_table_133<=slope_table_133+pass_word_count; 
				134:slope_table_134<=slope_table_134+pass_word_count; 
				135:slope_table_135<=slope_table_135+pass_word_count; 
				136:slope_table_136<=slope_table_136+pass_word_count; 
				137:slope_table_137<=slope_table_137+pass_word_count; 
				138:slope_table_138<=slope_table_138+pass_word_count; 
				139:slope_table_139<=slope_table_139+pass_word_count; 
				140:slope_table_140<=slope_table_140+pass_word_count; 
				141:slope_table_141<=slope_table_141+pass_word_count; 
				142:slope_table_142<=slope_table_142+pass_word_count; 
				143:slope_table_143<=slope_table_143+pass_word_count; 
				144:slope_table_144<=slope_table_144+pass_word_count; 
				145:slope_table_145<=slope_table_145+pass_word_count; 
				146:slope_table_146<=slope_table_146+pass_word_count; 
				147:slope_table_147<=slope_table_147+pass_word_count; 
				148:slope_table_148<=slope_table_148+pass_word_count; 
				149:slope_table_149<=slope_table_149+pass_word_count; 
				150:slope_table_150<=slope_table_150+pass_word_count; 
				151:slope_table_151<=slope_table_151+pass_word_count; 
				152:slope_table_152<=slope_table_152+pass_word_count; 
				153:slope_table_153<=slope_table_153+pass_word_count; 
				154:slope_table_154<=slope_table_154+pass_word_count; 
				155:slope_table_155<=slope_table_155+pass_word_count; 
				156:slope_table_156<=slope_table_156+pass_word_count; 
				157:slope_table_157<=slope_table_157+pass_word_count; 
				158:slope_table_158<=slope_table_158+pass_word_count; 
				159:slope_table_159<=slope_table_159+pass_word_count; 
				160:slope_table_160<=slope_table_160+pass_word_count; 
				161:slope_table_161<=slope_table_161+pass_word_count; 
				162:slope_table_162<=slope_table_162+pass_word_count; 
				163:slope_table_163<=slope_table_163+pass_word_count; 
				164:slope_table_164<=slope_table_164+pass_word_count; 
				165:slope_table_165<=slope_table_165+pass_word_count; 
				166:slope_table_166<=slope_table_166+pass_word_count; 
				167:slope_table_167<=slope_table_167+pass_word_count; 
				168:slope_table_168<=slope_table_168+pass_word_count; 
				169:slope_table_169<=slope_table_169+pass_word_count; 
				170:slope_table_170<=slope_table_170+pass_word_count; 
				171:slope_table_171<=slope_table_171+pass_word_count; 
				172:slope_table_172<=slope_table_172+pass_word_count; 
				173:slope_table_173<=slope_table_173+pass_word_count; 
				174:slope_table_174<=slope_table_174+pass_word_count; 
				175:slope_table_175<=slope_table_175+pass_word_count; 
				176:slope_table_176<=slope_table_176+pass_word_count; 
				177:slope_table_177<=slope_table_177+pass_word_count; 
				178:slope_table_178<=slope_table_178+pass_word_count; 
				179:slope_table_179<=slope_table_179+pass_word_count; 
				180:slope_table_180<=slope_table_180+pass_word_count; 
				181:slope_table_181<=slope_table_181+pass_word_count; 
				182:slope_table_182<=slope_table_182+pass_word_count; 
				183:slope_table_183<=slope_table_183+pass_word_count; 
				184:slope_table_184<=slope_table_184+pass_word_count; 
				185:slope_table_185<=slope_table_185+pass_word_count; 
				186:slope_table_186<=slope_table_186+pass_word_count; 
				187:slope_table_187<=slope_table_187+pass_word_count; 
				188:slope_table_188<=slope_table_188+pass_word_count; 
				189:slope_table_189<=slope_table_189+pass_word_count; 
				190:slope_table_190<=slope_table_190+pass_word_count; 
				191:slope_table_191<=slope_table_191+pass_word_count; 
				192:slope_table_192<=slope_table_192+pass_word_count; 
				193:slope_table_193<=slope_table_193+pass_word_count; 
				194:slope_table_194<=slope_table_194+pass_word_count; 
				195:slope_table_195<=slope_table_195+pass_word_count; 
				196:slope_table_196<=slope_table_196+pass_word_count; 
				197:slope_table_197<=slope_table_197+pass_word_count; 
				198:slope_table_198<=slope_table_198+pass_word_count; 
				199:slope_table_199<=slope_table_199+pass_word_count; 
				200:slope_table_200<=slope_table_200+pass_word_count; 
				201:slope_table_201<=slope_table_201+pass_word_count; 
				202:slope_table_202<=slope_table_202+pass_word_count; 
				203:slope_table_203<=slope_table_203+pass_word_count; 
				204:slope_table_204<=slope_table_204+pass_word_count; 
				205:slope_table_205<=slope_table_205+pass_word_count; 
				206:slope_table_206<=slope_table_206+pass_word_count; 
				207:slope_table_207<=slope_table_207+pass_word_count; 
				208:slope_table_208<=slope_table_208+pass_word_count; 
				209:slope_table_209<=slope_table_209+pass_word_count; 
				210:slope_table_210<=slope_table_210+pass_word_count; 
				211:slope_table_211<=slope_table_211+pass_word_count; 
				212:slope_table_212<=slope_table_212+pass_word_count; 
				213:slope_table_213<=slope_table_213+pass_word_count; 
				214:slope_table_214<=slope_table_214+pass_word_count; 
				215:slope_table_215<=slope_table_215+pass_word_count; 
				216:slope_table_216<=slope_table_216+pass_word_count; 
				217:slope_table_217<=slope_table_217+pass_word_count; 
				218:slope_table_218<=slope_table_218+pass_word_count; 
				219:slope_table_219<=slope_table_219+pass_word_count; 
				220:slope_table_220<=slope_table_220+pass_word_count; 
				221:slope_table_221<=slope_table_221+pass_word_count; 
				222:slope_table_222<=slope_table_222+pass_word_count; 
				223:slope_table_223<=slope_table_223+pass_word_count; 
				224:slope_table_224<=slope_table_224+pass_word_count; 
				225:slope_table_225<=slope_table_225+pass_word_count; 
				226:slope_table_226<=slope_table_226+pass_word_count; 
				227:slope_table_227<=slope_table_227+pass_word_count; 
				228:slope_table_228<=slope_table_228+pass_word_count; 
				229:slope_table_229<=slope_table_229+pass_word_count; 
				230:slope_table_230<=slope_table_230+pass_word_count; 
				231:slope_table_231<=slope_table_231+pass_word_count; 
				232:slope_table_232<=slope_table_232+pass_word_count; 
				233:slope_table_233<=slope_table_233+pass_word_count; 
				234:slope_table_234<=slope_table_234+pass_word_count; 
				235:slope_table_235<=slope_table_235+pass_word_count; 
				236:slope_table_236<=slope_table_236+pass_word_count; 
				237:slope_table_237<=slope_table_237+pass_word_count; 
				238:slope_table_238<=slope_table_238+pass_word_count; 
				239:slope_table_239<=slope_table_239+pass_word_count; 
				240:slope_table_240<=slope_table_240+pass_word_count; 
				241:slope_table_241<=slope_table_241+pass_word_count; 
				242:slope_table_242<=slope_table_242+pass_word_count; 
				243:slope_table_243<=slope_table_243+pass_word_count; 
				244:slope_table_244<=slope_table_244+pass_word_count; 
				245:slope_table_245<=slope_table_245+pass_word_count; 
				246:slope_table_246<=slope_table_246+pass_word_count; 
				247:slope_table_247<=slope_table_247+pass_word_count; 
				248:slope_table_248<=slope_table_248+pass_word_count; 
				249:slope_table_249<=slope_table_249+pass_word_count; 
				250:slope_table_250<=slope_table_250+pass_word_count; 
				251:slope_table_251<=slope_table_251+pass_word_count; 
				252:slope_table_252<=slope_table_252+pass_word_count; 
				253:slope_table_253<=slope_table_253+pass_word_count; 
				254:slope_table_254<=slope_table_254+pass_word_count; 
				255:slope_table_255<=slope_table_255+pass_word_count; 
				256:slope_table_256<=slope_table_256+pass_word_count; 
				257:slope_table_257<=slope_table_257+pass_word_count; 
				258:slope_table_258<=slope_table_258+pass_word_count; 
				259:slope_table_259<=slope_table_259+pass_word_count; 
				260:slope_table_260<=slope_table_260+pass_word_count; 
				261:slope_table_261<=slope_table_261+pass_word_count; 
				262:slope_table_262<=slope_table_262+pass_word_count; 
				263:slope_table_263<=slope_table_263+pass_word_count; 
				264:slope_table_264<=slope_table_264+pass_word_count; 
				265:slope_table_265<=slope_table_265+pass_word_count; 
				266:slope_table_266<=slope_table_266+pass_word_count; 
				267:slope_table_267<=slope_table_267+pass_word_count; 
				268:slope_table_268<=slope_table_268+pass_word_count; 
				269:slope_table_269<=slope_table_269+pass_word_count; 
				270:slope_table_270<=slope_table_270+pass_word_count; 
				271:slope_table_271<=slope_table_271+pass_word_count; 
				272:slope_table_272<=slope_table_272+pass_word_count; 
				273:slope_table_273<=slope_table_273+pass_word_count; 
				274:slope_table_274<=slope_table_274+pass_word_count; 
				275:slope_table_275<=slope_table_275+pass_word_count; 
				276:slope_table_276<=slope_table_276+pass_word_count; 
				277:slope_table_277<=slope_table_277+pass_word_count; 
				278:slope_table_278<=slope_table_278+pass_word_count; 
				279:slope_table_279<=slope_table_279+pass_word_count; 
				280:slope_table_280<=slope_table_280+pass_word_count; 
				281:slope_table_281<=slope_table_281+pass_word_count; 
				282:slope_table_282<=slope_table_282+pass_word_count; 
				283:slope_table_283<=slope_table_283+pass_word_count; 
				284:slope_table_284<=slope_table_284+pass_word_count; 
				285:slope_table_285<=slope_table_285+pass_word_count; 
				286:slope_table_286<=slope_table_286+pass_word_count; 
				287:slope_table_287<=slope_table_287+pass_word_count; 
				288:slope_table_288<=slope_table_288+pass_word_count; 
				289:slope_table_289<=slope_table_289+pass_word_count; 
				290:slope_table_290<=slope_table_290+pass_word_count; 
				291:slope_table_291<=slope_table_291+pass_word_count; 
				292:slope_table_292<=slope_table_292+pass_word_count; 
				293:slope_table_293<=slope_table_293+pass_word_count; 
				294:slope_table_294<=slope_table_294+pass_word_count; 
				295:slope_table_295<=slope_table_295+pass_word_count; 
				296:slope_table_296<=slope_table_296+pass_word_count; 
				297:slope_table_297<=slope_table_297+pass_word_count; 
				298:slope_table_298<=slope_table_298+pass_word_count; 
				299:slope_table_299<=slope_table_299+pass_word_count; 
				300:slope_table_300<=slope_table_300+pass_word_count; 
				301:slope_table_301<=slope_table_301+pass_word_count; 
				302:slope_table_302<=slope_table_302+pass_word_count; 
				303:slope_table_303<=slope_table_303+pass_word_count; 
				304:slope_table_304<=slope_table_304+pass_word_count; 
				305:slope_table_305<=slope_table_305+pass_word_count; 
				306:slope_table_306<=slope_table_306+pass_word_count; 
				307:slope_table_307<=slope_table_307+pass_word_count; 
				308:slope_table_308<=slope_table_308+pass_word_count; 
				309:slope_table_309<=slope_table_309+pass_word_count; 
				310:slope_table_310<=slope_table_310+pass_word_count; 
				311:slope_table_311<=slope_table_311+pass_word_count; 
				312:slope_table_312<=slope_table_312+pass_word_count; 
				313:slope_table_313<=slope_table_313+pass_word_count; 
				314:slope_table_314<=slope_table_314+pass_word_count; 
				315:slope_table_315<=slope_table_315+pass_word_count; 
				316:slope_table_316<=slope_table_316+pass_word_count; 
				317:slope_table_317<=slope_table_317+pass_word_count; 
				318:slope_table_318<=slope_table_318+pass_word_count; 
				319:slope_table_319<=slope_table_319+pass_word_count; 
				320:slope_table_320<=slope_table_320+pass_word_count; 
				321:slope_table_321<=slope_table_321+pass_word_count; 
				322:slope_table_322<=slope_table_322+pass_word_count; 
				323:slope_table_323<=slope_table_323+pass_word_count; 
				324:slope_table_324<=slope_table_324+pass_word_count; 
				325:slope_table_325<=slope_table_325+pass_word_count; 
				326:slope_table_326<=slope_table_326+pass_word_count; 
				327:slope_table_327<=slope_table_327+pass_word_count; 
				328:slope_table_328<=slope_table_328+pass_word_count; 
				329:slope_table_329<=slope_table_329+pass_word_count; 
				330:slope_table_330<=slope_table_330+pass_word_count; 
				331:slope_table_331<=slope_table_331+pass_word_count; 
				332:slope_table_332<=slope_table_332+pass_word_count; 
				333:slope_table_333<=slope_table_333+pass_word_count; 
				334:slope_table_334<=slope_table_334+pass_word_count; 
				335:slope_table_335<=slope_table_335+pass_word_count; 
				336:slope_table_336<=slope_table_336+pass_word_count; 
				337:slope_table_337<=slope_table_337+pass_word_count; 
				338:slope_table_338<=slope_table_338+pass_word_count; 
				339:slope_table_339<=slope_table_339+pass_word_count; 
				340:slope_table_340<=slope_table_340+pass_word_count; 
				341:slope_table_341<=slope_table_341+pass_word_count; 
				342:slope_table_342<=slope_table_342+pass_word_count; 
				343:slope_table_343<=slope_table_343+pass_word_count; 
				344:slope_table_344<=slope_table_344+pass_word_count; 
				345:slope_table_345<=slope_table_345+pass_word_count; 
				346:slope_table_346<=slope_table_346+pass_word_count; 
				347:slope_table_347<=slope_table_347+pass_word_count; 
				348:slope_table_348<=slope_table_348+pass_word_count; 
				349:slope_table_349<=slope_table_349+pass_word_count; 
				350:slope_table_350<=slope_table_350+pass_word_count; 
				351:slope_table_351<=slope_table_351+pass_word_count; 
				352:slope_table_352<=slope_table_352+pass_word_count; 
				353:slope_table_353<=slope_table_353+pass_word_count; 
				354:slope_table_354<=slope_table_354+pass_word_count; 
				355:slope_table_355<=slope_table_355+pass_word_count; 
				356:slope_table_356<=slope_table_356+pass_word_count; 
				357:slope_table_357<=slope_table_357+pass_word_count; 
				358:slope_table_358<=slope_table_358+pass_word_count; 
				359:slope_table_359<=slope_table_359+pass_word_count; 
				360:slope_table_360<=slope_table_360+pass_word_count; 
				361:slope_table_361<=slope_table_361+pass_word_count; 
				362:slope_table_362<=slope_table_362+pass_word_count; 
				363:slope_table_363<=slope_table_363+pass_word_count; 
				364:slope_table_364<=slope_table_364+pass_word_count; 
				365:slope_table_365<=slope_table_365+pass_word_count; 
				366:slope_table_366<=slope_table_366+pass_word_count; 
				367:slope_table_367<=slope_table_367+pass_word_count; 
				368:slope_table_368<=slope_table_368+pass_word_count; 
				369:slope_table_369<=slope_table_369+pass_word_count; 
				370:slope_table_370<=slope_table_370+pass_word_count; 
				371:slope_table_371<=slope_table_371+pass_word_count; 
				372:slope_table_372<=slope_table_372+pass_word_count; 
				373:slope_table_373<=slope_table_373+pass_word_count; 
				374:slope_table_374<=slope_table_374+pass_word_count; 
				375:slope_table_375<=slope_table_375+pass_word_count; 
				376:slope_table_376<=slope_table_376+pass_word_count; 
				377:slope_table_377<=slope_table_377+pass_word_count; 
				378:slope_table_378<=slope_table_378+pass_word_count; 
				379:slope_table_379<=slope_table_379+pass_word_count; 
				380:slope_table_380<=slope_table_380+pass_word_count; 
				381:slope_table_381<=slope_table_381+pass_word_count; 
				382:slope_table_382<=slope_table_382+pass_word_count; 
				383:slope_table_383<=slope_table_383+pass_word_count; 
				384:slope_table_384<=slope_table_384+pass_word_count; 
				385:slope_table_385<=slope_table_385+pass_word_count; 
				386:slope_table_386<=slope_table_386+pass_word_count; 
				387:slope_table_387<=slope_table_387+pass_word_count; 
				388:slope_table_388<=slope_table_388+pass_word_count; 
				389:slope_table_389<=slope_table_389+pass_word_count; 
				390:slope_table_390<=slope_table_390+pass_word_count; 
				391:slope_table_391<=slope_table_391+pass_word_count; 
				392:slope_table_392<=slope_table_392+pass_word_count; 
				393:slope_table_393<=slope_table_393+pass_word_count; 
				394:slope_table_394<=slope_table_394+pass_word_count; 
				395:slope_table_395<=slope_table_395+pass_word_count; 
				396:slope_table_396<=slope_table_396+pass_word_count; 
				397:slope_table_397<=slope_table_397+pass_word_count; 
				398:slope_table_398<=slope_table_398+pass_word_count; 
				399:slope_table_399<=slope_table_399+pass_word_count; 
				400:slope_table_400<=slope_table_400+pass_word_count; 
				401:slope_table_401<=slope_table_401+pass_word_count; 
				402:slope_table_402<=slope_table_402+pass_word_count; 
				403:slope_table_403<=slope_table_403+pass_word_count; 
				404:slope_table_404<=slope_table_404+pass_word_count; 
				405:slope_table_405<=slope_table_405+pass_word_count; 
				406:slope_table_406<=slope_table_406+pass_word_count; 
				407:slope_table_407<=slope_table_407+pass_word_count; 
				408:slope_table_408<=slope_table_408+pass_word_count; 
				409:slope_table_409<=slope_table_409+pass_word_count; 
				410:slope_table_410<=slope_table_410+pass_word_count; 
				411:slope_table_411<=slope_table_411+pass_word_count; 
				412:slope_table_412<=slope_table_412+pass_word_count; 
				413:slope_table_413<=slope_table_413+pass_word_count; 
				414:slope_table_414<=slope_table_414+pass_word_count; 
				415:slope_table_415<=slope_table_415+pass_word_count; 
				416:slope_table_416<=slope_table_416+pass_word_count; 
				417:slope_table_417<=slope_table_417+pass_word_count; 
				418:slope_table_418<=slope_table_418+pass_word_count; 
				419:slope_table_419<=slope_table_419+pass_word_count; 
				420:slope_table_420<=slope_table_420+pass_word_count; 
				421:slope_table_421<=slope_table_421+pass_word_count; 
				422:slope_table_422<=slope_table_422+pass_word_count; 
				423:slope_table_423<=slope_table_423+pass_word_count; 
				424:slope_table_424<=slope_table_424+pass_word_count; 
				425:slope_table_425<=slope_table_425+pass_word_count; 
				426:slope_table_426<=slope_table_426+pass_word_count; 
				427:slope_table_427<=slope_table_427+pass_word_count; 
				428:slope_table_428<=slope_table_428+pass_word_count; 
				429:slope_table_429<=slope_table_429+pass_word_count; 
				430:slope_table_430<=slope_table_430+pass_word_count; 
				431:slope_table_431<=slope_table_431+pass_word_count; 
				432:slope_table_432<=slope_table_432+pass_word_count; 
				433:slope_table_433<=slope_table_433+pass_word_count; 
				434:slope_table_434<=slope_table_434+pass_word_count; 
				435:slope_table_435<=slope_table_435+pass_word_count; 
				436:slope_table_436<=slope_table_436+pass_word_count; 
				437:slope_table_437<=slope_table_437+pass_word_count; 
				438:slope_table_438<=slope_table_438+pass_word_count; 
				439:slope_table_439<=slope_table_439+pass_word_count; 
				440:slope_table_440<=slope_table_440+pass_word_count; 
				441:slope_table_441<=slope_table_441+pass_word_count; 
				442:slope_table_442<=slope_table_442+pass_word_count; 
				443:slope_table_443<=slope_table_443+pass_word_count; 
				444:slope_table_444<=slope_table_444+pass_word_count; 
				445:slope_table_445<=slope_table_445+pass_word_count; 
				446:slope_table_446<=slope_table_446+pass_word_count; 
				447:slope_table_447<=slope_table_447+pass_word_count; 
				448:slope_table_448<=slope_table_448+pass_word_count; 
				449:slope_table_449<=slope_table_449+pass_word_count; 
				450:slope_table_450<=slope_table_450+pass_word_count; 
				451:slope_table_451<=slope_table_451+pass_word_count; 
				452:slope_table_452<=slope_table_452+pass_word_count; 
				453:slope_table_453<=slope_table_453+pass_word_count; 
				454:slope_table_454<=slope_table_454+pass_word_count; 
				455:slope_table_455<=slope_table_455+pass_word_count; 
				456:slope_table_456<=slope_table_456+pass_word_count; 
				457:slope_table_457<=slope_table_457+pass_word_count; 
				458:slope_table_458<=slope_table_458+pass_word_count; 
				459:slope_table_459<=slope_table_459+pass_word_count; 
				460:slope_table_460<=slope_table_460+pass_word_count; 
				461:slope_table_461<=slope_table_461+pass_word_count; 
				462:slope_table_462<=slope_table_462+pass_word_count; 
				463:slope_table_463<=slope_table_463+pass_word_count; 
				464:slope_table_464<=slope_table_464+pass_word_count; 
				465:slope_table_465<=slope_table_465+pass_word_count; 
				466:slope_table_466<=slope_table_466+pass_word_count; 
				467:slope_table_467<=slope_table_467+pass_word_count; 
				468:slope_table_468<=slope_table_468+pass_word_count; 
				469:slope_table_469<=slope_table_469+pass_word_count; 
				470:slope_table_470<=slope_table_470+pass_word_count; 
				471:slope_table_471<=slope_table_471+pass_word_count; 
				472:slope_table_472<=slope_table_472+pass_word_count; 
				473:slope_table_473<=slope_table_473+pass_word_count; 
				474:slope_table_474<=slope_table_474+pass_word_count; 
				475:slope_table_475<=slope_table_475+pass_word_count; 
				476:slope_table_476<=slope_table_476+pass_word_count; 
				477:slope_table_477<=slope_table_477+pass_word_count; 
				478:slope_table_478<=slope_table_478+pass_word_count; 
				479:slope_table_479<=slope_table_479+pass_word_count; 
				480:slope_table_480<=slope_table_480+pass_word_count;//}}}
			endcase
		end
	end
	always@(*)
	begin
		if(fifo_group)
		begin
			case(pass_number)
				0:fifo_out=dout_plane_sp_0;
    			1:fifo_out=dout_plane_mp_0;
    			2:fifo_out=dout_plane_cp_0;
				default:fifo_out=0;
			endcase
		end
		else
		begin
			case(pass_number)
				0:fifo_out=dout_plane_sp_1;
    			1:fifo_out=dout_plane_mp_1;
    			2:fifo_out=dout_plane_cp_1;
				default:fifo_out=0;
			endcase
		end
	end
	always@(*)
	begin
		if(fifo_group) 
		begin
			case(pass_number) 
   				0:empty=empty_plane_sp_0;
    			1:empty=empty_plane_mp_0;
    			2:empty=empty_plane_cp_0;
				default:empty=0;
			endcase 
		end
		else
		begin
			case(pass_number)
 				0:empty=empty_plane_sp_1;
    			1:empty=empty_plane_mp_1;
    			2:empty=empty_plane_cp_1;
				default:empty=0;
			endcase
		end
	end

	always@(*)
	begin
		if(fifo_group)
		begin
			case(pass_number)
    			0: pass_error=pass_error_plane_sp_0_reg;
    			1: pass_error=pass_error_plane_mp_0_reg;
    			2: pass_error=pass_error_plane_cp_0_reg;
  				default:pass_error=0;
			endcase
		end
		else
		begin	
			case(pass_number)
				0: pass_error=pass_error_plane_sp_1_reg;
				1: pass_error=pass_error_plane_mp_1_reg;
				2: pass_error=pass_error_plane_cp_1_reg;
  				default:pass_error=0;
			endcase
		end
	end


	always@(*)//pass_word_count
	begin
		if(fifo_group)
		begin
			case(pass_number)
   				0:pass_word_count=rd_data_count_plane_sp_0;
    			1:pass_word_count=rd_data_count_plane_mp_0;
    			2:pass_word_count=rd_data_count_plane_cp_0;
				default:pass_word_count=0;
			endcase
		end
		else
		begin
			case(pass_number)
 				0:pass_word_count=rd_data_count_plane_sp_1;
    			1:pass_word_count=rd_data_count_plane_mp_1;
    			2:pass_word_count=rd_data_count_plane_cp_1;
				default:pass_word_count=0;
			endcase
		end
	end


	always@(posedge rd_clk or negedge rst)
	begin
	    if(!rst)
			distoration_tran<=0;
		else if(rst_syn)
			distoration_tran<=0;
		else if(state==CAL_SLOPE_1)
		begin
			if(zero_error_pass)
				distoration_tran<=480;
			else
				distoration_tran<=table_output+(exponent<<4);
		end
	end
	always@(posedge rd_clk or negedge rst)
	begin
	    if(!rst) 
			pass_length_tran<=0;
		else if(rst_syn)
			pass_length_tran<=0;
		else if(state==CAL_SLOPE_2)
		begin
			if(zero_error_pass)
				pass_length_tran<=0;
			else pass_length_tran<=table_output+(exponent<<4);
		end
	end
	always@(posedge rd_clk or negedge rst)
	begin
	    if(!rst)
			slope<=0;
		else if(rst_syn)
			slope<=0;
		else if(state==PASS_OVER)
			slope<=0;
		else if(state==CAL_SLOPE_3)
		begin
			if(distoration_tran>=pass_length_tran)
				slope<=distoration_tran-pass_length_tran;
			else slope<=0;
		end
	end
	

	
	always@(posedge wr_clk or negedge rst)
	begin
	    if(!rst) 
		begin
			pass_error_plane_sp_0_reg<=0;  
			pass_error_plane_mp_0_reg<=0;
			pass_error_plane_cp_0_reg<=0;
			pass_error_plane_sp_1_reg<=0;
			pass_error_plane_mp_1_reg<=0;
			pass_error_plane_cp_1_reg<=0;
		end
		else if(rst_syn)
		begin			
			pass_error_plane_sp_0_reg<=0;  
			pass_error_plane_mp_0_reg<=0;
			pass_error_plane_cp_0_reg<=0;
			pass_error_plane_sp_1_reg<=0;
			pass_error_plane_mp_1_reg<=0;
			pass_error_plane_cp_1_reg<=0;
		end
		else if(flush_over)
		begin
			if(!fifo_group)
			begin
				pass_error_plane_sp_0_reg<=pass_error_plane_sp;
				pass_error_plane_mp_0_reg<=pass_error_plane_mp;
				pass_error_plane_cp_0_reg<=pass_error_plane_cp;
			end
			else 
			begin
				pass_error_plane_sp_1_reg<=pass_error_plane_sp;
				pass_error_plane_mp_1_reg<=pass_error_plane_mp;
				pass_error_plane_cp_1_reg<=pass_error_plane_cp;
			end
		end



	end
	
	always@(*)//////////// look up table for calculating the slope
	begin
	    case(table_input)
			0  :  table_output=0 ; //{{{
			1  :  table_output=0 ;
			2  :  table_output=0 ;
			3  :  table_output=0 ;
			4  :  table_output=0 ;
			5  :  table_output=0 ;
			6  :  table_output=1 ;
			7  :  table_output=1 ;
			8  :  table_output=1 ;
			9  :  table_output=1 ;
			10 :  table_output=1 ;
			11 :  table_output=1 ;
			12 :  table_output=1 ;
			13 :  table_output=1 ;
			14 :  table_output=1 ;
			15 :  table_output=1 ;
			16 :  table_output=1 ;
			17 :  table_output=1 ;
			18 :  table_output=2 ;
			19 :  table_output=2 ;
			20 :  table_output=2 ;
			21 :  table_output=2 ;
			22 :  table_output=2 ;
			23 :  table_output=2 ;
			24 :  table_output=2 ;
			25 :  table_output=2 ;
			26 :  table_output=2 ;
			27 :  table_output=2 ;
			28 :  table_output=2 ;
			29 :  table_output=2 ;
			30 :  table_output=3 ;
			31 :  table_output=3 ;
			32 :  table_output=3 ;
			33 :  table_output=3 ;
			34 :  table_output=3 ;
			35 :  table_output=3 ;
			36 :  table_output=3 ;
			37 :  table_output=3 ;
			38 :  table_output=3 ;
			39 :  table_output=3 ;
			40 :  table_output=3 ;
			41 :  table_output=3 ;
			42 :  table_output=4 ;
			43 :  table_output=4 ;
			44 :  table_output=4 ;
			45 :  table_output=4 ;
			46 :  table_output=4 ;
			47 :  table_output=4 ;
			48 :  table_output=4 ;
			49 :  table_output=4 ;
			50 :  table_output=4 ;
			51 :  table_output=4 ;
			52 :  table_output=4 ;
			53 :  table_output=4 ;
			54 :  table_output=4 ;
			55 :  table_output=4 ;
			56 :  table_output=5 ;
			57 :  table_output=5 ;
			58 :  table_output=5 ;
			59 :  table_output=5 ;
			60 :  table_output=5 ;
			61 :  table_output=5 ;
			62 :  table_output=5 ;
			63 :  table_output=5 ;
			64 :  table_output=5 ;
			65 :  table_output=5 ;
			66 :  table_output=5 ;
			67 :  table_output=5 ;
			68 :  table_output=5 ;
			69 :  table_output=6 ;
			70 :  table_output=6 ;
			71 :  table_output=6 ;
			72 :  table_output=6 ;
			73 :  table_output=6 ;
			74 :  table_output=6 ;
			75 :  table_output=6 ;
			76 :  table_output=6 ;
			77 :  table_output=6 ;
			78 :  table_output=6 ;
			79 :  table_output=6 ;
			80 :  table_output=6 ;
			81 :  table_output=6 ;
			82 :  table_output=6 ;
			83 :  table_output=6 ;
			84 :  table_output=7 ;
			85 :  table_output=7 ;
			86 :  table_output=7 ;
			87 :  table_output=7 ;
			88 :  table_output=7 ;
			89 :  table_output=7 ;
			90 :  table_output=7 ;
			91 :  table_output=7 ;
			92 :  table_output=7 ;
			93 :  table_output=7 ;
			94 :  table_output=7 ;
			95 :  table_output=7 ;
			96 :  table_output=7 ;
			97 :  table_output=7 ;
			98 :  table_output=7 ;
			99 :  table_output=8 ;
			100:  table_output=8 ;
			101:  table_output=8 ;
			102:  table_output=8 ;
			103:  table_output=8 ;
			104:  table_output=8 ;
			105:  table_output=8 ;
			106:  table_output=8 ;
			107:  table_output=8 ;
			108:  table_output=8 ;
			109:  table_output=8 ;
			110:  table_output=8 ;
			111:  table_output=8 ;
			112:  table_output=8 ;
			113:  table_output=8 ;
			114:  table_output=9 ;
			115:  table_output=9 ;
			116:  table_output=9 ;
			117:  table_output=9 ;
			118:  table_output=9 ;
			119:  table_output=9 ;
			120:  table_output=9 ;
			121:  table_output=9 ;
			122:  table_output=9 ;
			123:  table_output=9 ;
			124:  table_output=9 ;
			125:  table_output=9 ;
			126:  table_output=9 ;
			127:  table_output=9 ;
			128:  table_output=9 ;  
			129:  table_output=9 ;   
			130:  table_output=9 ;   
			131:  table_output=10;   
			132:  table_output=10;   
			133:  table_output=10;   
			134:  table_output=10;   
			135:  table_output=10;   
			136:  table_output=10;   
			137:  table_output=10;   
			138:  table_output=10;   
			139:  table_output=10;   
			140:  table_output=10;   
			141:  table_output=10;   
			142:  table_output=10;   
			143:  table_output=10;   
			144:  table_output=10;   
			145:  table_output=10;   
			146:  table_output=10;   
			147:  table_output=10;   
			148:  table_output=11;   
			149:  table_output=11;   
			150:  table_output=11;   
			151:  table_output=11;   
			152:  table_output=11;   
			153:  table_output=11;   
			154:  table_output=11;   
			155:  table_output=11;   
			156:  table_output=11;   
			157:  table_output=11;   
			158:  table_output=11;   
			159:  table_output=11;   
			160:  table_output=11;   
			161:  table_output=11;   
			162:  table_output=11;   
			163:  table_output=11;   
			164:  table_output=11;   
			165:  table_output=11;   
			166:  table_output=12;   
			167:  table_output=12;   
			168:  table_output=12;   
			169:  table_output=12;   
			170:  table_output=12;   
			171:  table_output=12;   
			172:  table_output=12;   
			173:  table_output=12;   
			174:  table_output=12;   
			175:  table_output=12;   
			176:  table_output=12;   
			177:  table_output=12;   
			178:  table_output=12;   
			179:  table_output=12;   
			180:  table_output=12;   
			181:  table_output=12;   
			182:  table_output=12;   
			183:  table_output=12;   
			184:  table_output=13;   
			185:  table_output=13;   
			186:  table_output=13;   
			187:  table_output=13;   
			188:  table_output=13;   
			189:  table_output=13;   
			190:  table_output=13;   
			191:  table_output=13;   
			192:  table_output=13;   
			193:  table_output=13;   
			194:  table_output=13;   
			195:  table_output=13;   
			196:  table_output=13;   
			197:  table_output=13;   
			198:  table_output=13;   
			199:  table_output=13;   
			200:  table_output=13;   
			201:  table_output=13;   
			202:  table_output=13;   
			203:  table_output=13;   
			204:  table_output=14;   
			205:  table_output=14;   
			206:  table_output=14;   
			207:  table_output=14;   
			208:  table_output=14;   
			209:  table_output=14;   
			210:  table_output=14;   
			211:  table_output=14;   
			212:  table_output=14;   
			213:  table_output=14;   
			214:  table_output=14;   
			215:  table_output=14;   
			216:  table_output=14;   
			217:  table_output=14;   
			218:  table_output=14;   
			219:  table_output=14;   
			220:  table_output=14;   
			221:  table_output=14;   
			222:  table_output=14;   
			223:  table_output=14;   
			224:  table_output=15;   
			225:  table_output=15;   
			226:  table_output=15;   
			227:  table_output=15;   
			228:  table_output=15;   
			229:  table_output=15;   
			230:  table_output=15;   
			231:  table_output=15;   
			232:  table_output=15;   
			233:  table_output=15;   
			234:  table_output=15;   
			235:  table_output=15;   
			236:  table_output=15;   
			237:  table_output=15;   
			238:  table_output=15;   
			239:  table_output=15;   
			240:  table_output=15;   
			241:  table_output=15;   
			242:  table_output=15;   
			243:  table_output=15;   
			244:  table_output=15;   
			245:  table_output=15;   
			246:  table_output=16;   
			247:  table_output=16;   
			248:  table_output=16;   
			249:  table_output=16;   
			250:  table_output=16;   
			251:  table_output=16;   
			252:  table_output=16;   
			253:  table_output=16;   
			254:  table_output=16;   
			255:  table_output=16;   //}}}
			default:table_output=0 ;
		endcase
	end

	always@(*)
	begin
	    case(state)
			CAL_SLOPE_1:table_input=rears_pass_error;
			CAL_SLOPE_2:table_input=rears_pass_word_count;
			default:table_input=0;
		endcase
	end

	always@(posedge rd_clk or negedge rst)
	begin
	    if(!rst)
			pass_number<=0;
		else if(rst_syn)
			pass_number<=0;
		else 
			begin
				case(state)
					FIND_FIRST_PASS:
					begin
						case(empty_combo)
							3'b111:pass_number<=3;
							3'b110:pass_number<=2;
							3'b100:pass_number<=1;
							3'b000:pass_number<=0;
							//default:$display("fifo data not written over!");
						endcase                                                     
					end
					NEXT_PASS:pass_number<=pass_number+1;
					PASS_OVER:pass_number<=0;
				endcase
			end

	end

	always@(posedge wr_clk or negedge rst)
	begin
	    if(!rst) 
			fifo_group<=0;
		else if(rst_syn)
			fifo_group<=0;
		else if(flush_over)
			fifo_group<=!fifo_group;
	end
	
	/***** wire internal *****/
	assign zero_error_pass=(pass_error==0)&&(pass_number!=3);
	assign last_codeblock=codeblock_counter==47;
	assign byte_full=byte_counter>=target_byte_number;
	assign word_last_flag_plus=word_last_flag?2'b10:2'b01;//1 means double bytes and 0 means 1 byte
	assign cal_truncation_en=(state==CAL_TRUNCATION_POINT)&&(!byte_full);
	wire [4:0]shift_number=(30-exponent);
	assign pass_word_count_expanded_shifted=pass_word_count_expanded<<shift_number;
	assign pass_error_expanded_shifted=pass_error_expanded<<shift_number;
	assign rears_pass_word_count=pass_word_count_expanded_shifted[37:30];
	assign rears_pass_error=pass_error_expanded_shifted[37:30];
	assign pass_word_count_expanded={22'b0,pass_word_count[7:0],8'b0};
	assign pass_error_expanded={pass_error,8'b0};
	assign empty_combo_0={empty_plane_sp_0,empty_plane_mp_0,empty_plane_cp_0};
	assign empty_combo_1={empty_plane_sp_1,empty_plane_mp_1,empty_plane_cp_1};
	assign empty_combo=fifo_group?empty_combo_0:empty_combo_1;
	assign rd_en_plane_sp_0=(pass_number==0)&&(state==SHIFT_PASS_SECOND_HEADER||state==SHIFT_CODESTREAM)&&!empty_plane_sp_0&&fifo_group;
	assign rd_en_plane_sp_1=(pass_number==0)&&(state==SHIFT_PASS_SECOND_HEADER||state==SHIFT_CODESTREAM)&&!empty_plane_sp_1&&(!fifo_group);   
	assign rd_en_plane_mp_0=(pass_number==1)&&(state==SHIFT_PASS_SECOND_HEADER||state==SHIFT_CODESTREAM)&&!empty_plane_mp_0&&fifo_group;
	assign rd_en_plane_mp_1=(pass_number==1)&&(state==SHIFT_PASS_SECOND_HEADER||state==SHIFT_CODESTREAM)&&!empty_plane_mp_1&&(!fifo_group);   
	assign rd_en_plane_cp_0=(pass_number==2)&&(state==SHIFT_PASS_SECOND_HEADER||state==SHIFT_CODESTREAM)&&!empty_plane_cp_0&&fifo_group;
	assign rd_en_plane_cp_1=(pass_number==2)&&(state==SHIFT_PASS_SECOND_HEADER||state==SHIFT_CODESTREAM)&&!empty_plane_cp_1&&(!fifo_group);   

	
	/////////////////////// fsm
	always@(posedge rd_clk or negedge rst)
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
				if(cal_truncation_point_start) 
					nextstate=CAL_TRUNCATION_POINT;
				else if(flush_over)
					nextstate=WAITING_WRITE_OVER;	
				else if(one_codeblock_over&&flush_over_counter==0||codeblock_over_counter!=0)
					nextstate=FIND_FIRST_PASS;
				else if(last_codeblock&&codeblock_shift_over)
					nextstate=SHIFT_OVER_FLAG;
				else nextstate=IDLE;
			end
			WAITING_WRITE_OVER://to ensure the fifo data is written over
			begin
				if(time_counter==5)
					nextstate=FIND_FIRST_PASS;
				else nextstate=WAITING_WRITE_OVER;
			end
			FIND_FIRST_PASS:
				begin
					if(flush_over_counter==0||codeblock_shift_over!=0)
						nextstate=SHIFT_PASS_FIRST_HEADER;
					else
						nextstate=CAL_SLOPE_1;
				end
			CAL_SLOPE_1:nextstate=CAL_SLOPE_2;
			CAL_SLOPE_2:nextstate=CAL_SLOPE_3;
			CAL_SLOPE_3:nextstate=SHIFT_PASS_FIRST_HEADER;
			SHIFT_PASS_FIRST_HEADER:nextstate=SHIFT_PASS_SECOND_HEADER;
			SHIFT_PASS_SECOND_HEADER:
				begin
					if(pass_number==3)
					begin
						if(codeblock_over_counter!=0&&(!one_codeblock_over_reg))
							nextstate=ONE_EMPTY_CODEBLOCK_OVER;// in the case of one_codeblock_over occurs while the former codeblock still outputs
						else
							nextstate=PASS_OVER;//in the case that the codeblock outputs nothing,and all fifos are empty
					end 
					else nextstate=SHIFT_CODESTREAM;
				end
			SHIFT_CODESTREAM:
			begin
				if(empty)
				begin
					if(pass_number==2||pass_number==3)
					begin
						nextstate=PASS_OVER;
					end
					else nextstate=NEXT_PASS;
				end
				else nextstate=SHIFT_CODESTREAM;
			end
			SHIFT_OVER_FLAG:
				nextstate=IDLE;
			NEXT_PASS:nextstate=CAL_SLOPE_1;
			PASS_OVER:nextstate=IDLE;
			CAL_TRUNCATION_POINT:
			begin
				if(byte_full||(cal_truncation_en&&lram_address_wr==480))
					nextstate=CAL_TRUNCATION_POINT_OVER;
				else nextstate=CAL_TRUNCATION_POINT;
			end
			CAL_TRUNCATION_POINT_OVER:nextstate=BUFFER;
			BUFFER:nextstate=IDLE;
			ONE_EMPTY_CODEBLOCK_OVER: 
			begin
				if(codeblock_over_counter==1&&last_codeblock)
					nextstate=SHIFT_OVER_FLAG;
				else nextstate=IDLE;
			end 
			default:nextstate=IDLE;
		endcase
	end
	
	fifo_bitplane_256_16	fifo_bitplane (
		.rd_clk			(rd_clk), 
		.wr_clk			(wr_clk),
		.rst_syn			(rst_syn),
		.din			(data_from_mq),
		.pass			(pass_plane),
		.fifo_group		(fifo_group),
		.rd_data_count_sp_0(rd_data_count_plane_sp_0),
		.rd_data_count_mp_0(rd_data_count_plane_mp_0),
		.rd_data_count_cp_0(rd_data_count_plane_cp_0),
		.rd_data_count_sp_1(rd_data_count_plane_sp_1),
		.rd_data_count_mp_1(rd_data_count_plane_mp_1),
		.rd_data_count_cp_1(rd_data_count_plane_cp_1),
		.empty_sp_0		(empty_plane_sp_0),
		.empty_mp_0		(empty_plane_mp_0),
		.empty_cp_0		(empty_plane_cp_0),
		.empty_sp_1		(empty_plane_sp_1),
		.empty_mp_1		(empty_plane_mp_1),
		.empty_cp_1		(empty_plane_cp_1),
		.dout_sp_0		(dout_plane_sp_0),
		.dout_mp_0		(dout_plane_mp_0),
		.dout_cp_0		(dout_plane_cp_0),
		.dout_sp_1		(dout_plane_sp_1),
		.dout_mp_1		(dout_plane_mp_1),
		.dout_cp_1		(dout_plane_cp_1),
		.rd_en_sp_0		(rd_en_plane_sp_0),
        .rd_en_mp_0     (rd_en_plane_mp_0),
        .rd_en_cp_0     (rd_en_plane_cp_0),
        .rd_en_sp_1     (rd_en_plane_sp_1),
        .rd_en_mp_1     (rd_en_plane_mp_1),
        .rd_en_cp_1     (rd_en_plane_cp_1)
	);
endmodule
