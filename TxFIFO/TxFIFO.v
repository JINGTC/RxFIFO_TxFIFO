module TxFIFO(PSEL_TX,PWRITE_TX,PWDATA_TX,CLEAR_B_TX,PCLK_TX,TxData,SSPTXINTR);

input PSEL_TX;//select this part
input PWRITE_TX;//read/write, 1->write,0->read
input [7:0]PWDATA_TX;//tran data
input CLEAR_B_TX;//low->reset
input PCLK_TX;//clock

output [7:0]TxData;
output SSPTXINTR;

reg [7:0]TxData;
reg [7:0]temp[0:3];
reg [1:0]dis_c;
reg SSPTXINTR;
reg [1:0]ded_c;
reg [1:0]countdown;
reg last_elem;

always @(posedge PCLK_TX)

begin
if(PSEL_TX==1'b1)
begin
/////the reset////////
if(~CLEAR_B_TX)
begin
TxData=8'b00000000;
temp[0]=8'b00000000;
temp[1]=8'b00000000;
temp[2]=8'b00000000;
temp[3]=8'b00000000;
dis_c=2'b00;
ded_c=2'b00;
SSPTXINTR=1'b0;
countdown=2'b00;
last_elem=0;
end
/////////////////////
if(CLEAR_B_TX)
begin
/////write data///////
if(PWRITE_TX==1'b1)
begin


if((dis_c<=2'b11)&&(!(SSPTXINTR)))

begin

temp[dis_c]=PWDATA_TX;

if(dis_c==2'b11)
begin
SSPTXINTR=1'b1;
end

if(dis_c<=2'b10)
begin
dis_c=dis_c+1;
SSPTXINTR=1'b0;
end

end

end
/////////////////////
//////read data//////
else if(PWRITE_TX==0)
begin


if(dis_c>=2'b00)

begin

if(((dis_c==2'b00))&&last_elem)

begin
TxData=8'b00000000;
countdown=0;
end

if(dis_c>=2'b01)
begin
last_elem=1'b0;
end

if(!last_elem)
begin
ded_c=countdown;
TxData=temp[ded_c];

if(dis_c==2'b00)
begin
last_elem=1'b1;
end

if(dis_c!=2'b00)
begin
dis_c=dis_c-1;
countdown=countdown+1'b1;
end

end

SSPTXINTR=1'b0;

end

end
/////////////////////

end

end

end


endmodule



