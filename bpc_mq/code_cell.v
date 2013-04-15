//-----code cell ZC/SC/MRC/RLC

//-----------ZC--------------
//flag_band  0:LL 1:HL 2:LH 3:HH
module ZC(zc_CxD,
          //input
          data_v,
          flag_band,
          h0,h1,
          v0,v1,
          d0,d1,
          d2,d3);

output [5:0]zc_CxD;


input data_v;
input [1:0]flag_band;

input h0,h1,v0,v1,d0,d1,d2,d3;


wire [4:0]CX;
wire [5:0]zc_CxD={CX,data_v};



wire band_eq_1=(flag_band==1);
wire band_eq_3=(flag_band==3);

wire[1:0] h_0=h0+h1;
wire[1:0] v_0=v0+v1;
wire[2:0] diag=d0+d1+d2+d3;

wire[1:0] h=band_eq_1?v_0:h_0;
wire[1:0] v=band_eq_1?h_0:v_0;
wire[2:0] h_add_v=h_0+v_0;

wire CX_9=band_eq_3?(diag>2):(h==2);
wire CX_8=band_eq_3?((h_add_v>0)&&(diag==2)):((h==1)&&(v>0));
wire CX_7=band_eq_3?((h_add_v==0)&&(diag==2)):((h==1)&&(v==0)&&(diag>0));
wire CX_6=band_eq_3?((h_add_v>1)&&(diag==1)):((h==1)&&(v==0)&&(diag==0));
wire CX_5=band_eq_3?((h_add_v==1)&&(diag==1)):((h==0)&&(v==2));
wire CX_4=band_eq_3?((h_add_v==0)&&(diag==1)):((h==0)&&(v==1));
wire CX_3=band_eq_3?((h_add_v>1)&&(diag==0)):((h==0)&&(v==0)&&(diag>1));
wire CX_2=band_eq_3?((h_add_v==1)&&(diag==0)):((h==0)&&(v==0)&&(diag==1));
wire CX_1=band_eq_3?((h_add_v==0)&&(diag==0)):((h==0)&&(v==0)&&(diag==0));

reg [3:0]CX_reg;
assign CX={1'b0,CX_reg};

//always @(CX_9 or CX_8 or CX_7 or CX_6 or CX_5 or CX_4 or CX_3 or CX_2 or CX_1)
always@(*)
  case({CX_9,CX_8,CX_7,CX_6,CX_5,CX_4,CX_3,CX_2,CX_1})
    9'b1_0000_0000:CX_reg=4'b1001;
    9'b0_1000_0000:CX_reg=4'b1000;
    9'b0_0100_0000:CX_reg=4'b0111;
    9'b0_0010_0000:CX_reg=4'b0110;
    9'b0_0001_0000:CX_reg=4'b0101;
    9'b0_0000_1000:CX_reg=4'b0100;
    9'b0_0000_0100:CX_reg=4'b0011;
    9'b0_0000_0010:CX_reg=4'b0010;
    9'b0_0000_0001:CX_reg=4'b0001;
    default:CX_reg=4'bxxxx;
  endcase

endmodule



//-------------SC-------------
module SC(sc_CxD,
          //input
          data_x,
          h0,h1,
          v0,v1,
          sign_h0,
          sign_h1,
          sign_v0,
          sign_v1);


output [5:0]sc_CxD;


input data_x;

input h0,h1,v0,v1;
input sign_h0,sign_h1,sign_v0,sign_v1;

reg [4:0]CX;
wire D;
wire [5:0]sc_CxD={CX,D};


reg [1:0]hc;

//always @(h0,sign_h0,h1,sign_h1)
always@(*)
  casez({h0,sign_h0,h1,sign_h1})
    4'b1010,
    4'b0?10,
    4'b100?:hc=2'b01;
    4'b1110,
    4'b1011,
    4'b0?0?:hc=2'b00;
    4'b1111,
    4'b0?11,
    4'b110?:hc=2'b11;
  endcase

reg [1:0]vc;

//always @(v0,sign_v0,v1,sign_v1)
always@(*)
  casez({v0,sign_v0,v1,sign_v1})
    4'b1010,
    4'b0?10,
    4'b100?:vc=2'b01;
    4'b1110,
    4'b1011,
    4'b0?0?:vc=2'b00;
    4'b1111,
    4'b0?11,
    4'b110?:vc=2'b11;
  endcase



reg XOR;
//always @(hc,vc)
always@(*)
  case({hc,vc})
    4'b0101:begin
              CX=5'b10001;
              XOR=1'b0;
            end
    4'b0100:begin
              CX=5'b10000;
              XOR=1'b0;
            end
    4'b0111:begin
              CX=5'b01111;
              XOR=1'b0;
            end
    4'b0001:begin
              CX=5'b01110;
              XOR=1'b0;
            end
    4'b0000:begin
              CX=5'b01101;
              XOR=1'b0;
            end        
    4'b0011:begin
              CX=5'b01110;
              XOR=1'b1;
            end   
    4'b1101:begin
              CX=5'b01111;
              XOR=1'b1;
            end        
    4'b1100:begin
              CX=5'b10000;
              XOR=1'b1;
            end         
    4'b1111:begin
              CX=5'b10001;
              XOR=1'b1;
            end 
    default:begin
              CX=5'bxxxxx;
              XOR=1'bx;
            end             
  endcase



assign D=data_x^XOR;

endmodule




//-----------MRC----------------
module MRC(mrc_CxD,
           //input
           data_v,
           data_mrc_first,
           h0,h1,
           v0,v1,
           d0,d1,
           d2,d3);


output [5:0]mrc_CxD;


input data_v;
input data_mrc_first;

input h0,h1,v0,v1,d0,d1,d2,d3;

wire [4:0]CX; 
wire [5:0]mrc_CxD={CX,data_v};


wire data_mrc_first_bar=~data_mrc_first;
wire hvd=(h0|h1)|(v0|v1)|(d0|d1)|(d2|d3);

assign CX={2'b01,data_mrc_first_bar,data_mrc_first,data_mrc_first&hvd};
endmodule

//-------------RLC------------------
module RLC(rlc_CxD,
           u0_CxD,
           u1_CxD,
           rlc_ac,
           u01_ac,
           //input
           data_v0,
           data_v1,
           data_v2,
           data_v3,
           cp_ac0,cp_ac1,cp_ac2,cp_ac3,
           v0,v1,
           d0,d1,d2,d3,
           h0,h1,h2,h3,
           h4,h5,h6,h7);
  output [5:0]rlc_CxD,u0_CxD,u1_CxD;
  output rlc_ac,u01_ac;
  
  input data_v0,data_v1,data_v2,data_v3;
  input cp_ac0,cp_ac1,cp_ac2,cp_ac3;
  input v0,v1;
  input d0,d1,d2,d3;
  input h0,h1,h2,h3,h4,h5,h6,h7;
  
  wire [4:0]rlc_CX,u_CX;
  reg rlc_D,u0_D,u1_D;
  wire [5:0]rlc_CxD={rlc_CX,rlc_D};
  wire [5:0]u0_CxD={u_CX,u0_D};
  wire [5:0]u1_CxD={u_CX,u1_D};
  
  wire data_all0s=~((data_v0|data_v1)|(data_v2|data_v3));
  wire rlc_ac=(cp_ac0&cp_ac1&cp_ac2&cp_ac3)&( ~((d0|d1|d2|d3)|(h0|h1|h2|h3)|(h4|h5|h6|h7)|(v0|v1)) );
  wire u01_ac=rlc_ac & (~data_all0s);
  
  assign rlc_CX=0;
  assign u_CX=18;
  //always @(data_v0,data_v1,data_v2,data_v3)
  always@(*)
    begin
      
      rlc_D=0;u0_D=0;u1_D=0;
      if(data_v0)
        rlc_D=1;
      else if(data_v1)
        begin
          rlc_D=1;
          u1_D=1;
        end
      else if(data_v2)
        begin
          rlc_D=1;
          u0_D=1;
        end
      else if(data_v3)
        begin
          rlc_D=1;
          u0_D=1;
          u1_D=1;
        end
    
    end
  
  endmodule

