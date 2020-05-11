module RxFIFO(PSEL_RX,PWRITE_RX,CLEAR_B_RX,PCLK_RX,RxData,PRDATA_RX,SSPRXINTR);
input PSEL_RX;
input PWRITE_RX;
input CLEAR_B_RX;
input PCLK_RX;
input [7:0]RxData;

output [7:0]PRDATA_RX;
output SSPRXINTR;

reg [7:0]PRDATA_RX;
reg SSPRXINTR;
reg [7:0]mem[0:3];
reg [1:0]coun_c;
reg [1:0]in_number;
reg [1:0]count_down;
reg flag_last_elem;

always @(posedge PCLK_RX)

begin
///////sel?////
if(PSEL_RX==1'b1)
begin
///////////////
///clear///////
if(~CLEAR_B_RX)
begin
PRDATA_RX=8'b00000000;
mem[0]=8'b00000000;
mem[1]=8'b00000000;
mem[2]=8'b00000000;
mem[3]=8'b00000000;
coun_c=2'b00;
SSPRXINTR=1'b0;
in_number=2'b00;
count_down=2'b00;
flag_last_elem=0;
end
///////no clear////////
if(CLEAR_B_RX)
begin
/////write//////
if(PWRITE_RX==1'b1)
begin

if((coun_c<=2'b11)&&(!(SSPRXINTR)))
begin
mem[coun_c]=RxData;

///full?///
if(coun_c==2'b11)
begin
SSPRXINTR=1'b1;
end
////////////////
//no full//
if(coun_c<=2'b10)
begin
coun_c=coun_c+1'b1;
SSPRXINTR=1'b0;
end
///////////
end

end

/////////////
///read data//
else if(PWRITE_RX==0)
begin

if(coun_c>=2'b00)

begin
///This is the last element////
if((coun_c==2'b00)&&flag_last_elem)

begin
PRDATA_RX=8'b00000000;
count_down=0;
end

////no last///
if(coun_c>=2'b01)
begin
flag_last_elem=1'b0;
end
/////////////////

if(!flag_last_elem)
begin
in_number=count_down;
PRDATA_RX=mem[in_number];
/////the last one yet///
if(coun_c==2'b00)
begin
flag_last_elem=1'b1;
end
/////no last one////
if(coun_c!=2'b00)
begin
coun_c=coun_c-1'b1;
count_down=count_down+1'b1;
end
/////////////////////////
end

SSPRXINTR=1'b0;

end

end

end

end

end

endmodule
