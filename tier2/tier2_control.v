`timescale 1ns/1ns
module tier2_control(clk,
				rst,
				buffer_all_over,
				codestream_generate_start,
				cal_truncation_point_start,
				cal_truncation_point_over,
				codestream_generate_over,
				rst_syn

);

	input clk;
	input rst;
	input rst_syn;
	input buffer_all_over;
	input cal_truncation_point_over;
	input codestream_generate_over;


	output codestream_generate_start;
	output cal_truncation_point_start;

	parameter IDLE=0,
		BUFFERING_PASSES=1,
		CAL_TRUNCATION_POINT=2,
		GENERATING_CODESTREAM=3;


	/*********** reg ***********/
	reg [2:0]state;
	reg [2:0]nextstate;

	/********** wire ***********/
	wire codestream_generate_start;
	wire cal_truncation_point_start;

	//////////////////// reg internal
	//////////////////// wire internal
	assign codestream_generate_start=((state==CAL_TRUNCATION_POINT)&&(nextstate==GENERATING_CODESTREAM));
	assign cal_truncation_point_start=(state==CAL_TRUNCATION_POINT);
	//////////////////// FSM
	always@(posedge clk or negedge rst)
	begin
	    if(!rst)
			state<=IDLE;
		else state<=nextstate;
	end

	always@(*)
	begin
	    case(state)
			IDLE:
			begin
				if(codestream_generate_over)
					nextstate=IDLE;
				else nextstate=BUFFERING_PASSES;
			end
			BUFFERING_PASSES:
			begin
				if(buffer_all_over)
					nextstate=CAL_TRUNCATION_POINT;
				else nextstate=BUFFERING_PASSES;
			end
			CAL_TRUNCATION_POINT:
			begin
				if(cal_truncation_point_over)
					nextstate=GENERATING_CODESTREAM;
				else nextstate=CAL_TRUNCATION_POINT;
			end
			GENERATING_CODESTREAM:
			begin
				if(rst_syn)
					nextstate=IDLE;
				else nextstate=GENERATING_CODESTREAM;
			end
			default:nextstate=IDLE;

	    endcase
	end
	
	

endmodule

