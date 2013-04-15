//==================================================================================================
//  Filename      : read_sram.v
//  Created On    : 2013-04-06 18:48:16
//  Last Modified : 2013-04-06 19:00:09
//  Revision      : 
//  Author        : Tian Changsong
//
//  Description   : 
//
//
//==================================================================================================
module read_sram(/*autoport*/);
input clk;
input rst;
input data_from_sram;
input start_jpeg;

output data_to_cpu;
output address_to_cpu;

parameter IDLE=0,
READ_BEGIN=1,
READING=2,
READ_OVER=3;
/* reg */
reg [2:0]state;
reg [2:0]nextstate;
/* wire */


/*wire assign*/
always @(posedge clk or negedge rst)
begin
    if (!rst) 
    begin
        
    end
    else if () 
    begin
        
    end
end
/* fsm */


