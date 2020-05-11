module RxFIFO_tb;

reg PSEL_RX, PWRITE_RX, CLEAR_B_RX, PCLK_RX;
reg [7:0]RxData;
wire [7:0]PRDATA_RX;
wire SSPRXINTR;

RxFIFO U0(.PSEL_RX(PSEL_RX),.PWRITE_RX(PWRITE_RX),.CLEAR_B_RX(CLEAR_B_RX),.PCLK_RX(PCLK_RX),.RxData(RxData),.PRDATA_RX(PRDATA_RX),.SSPRXINTR(SSPRXINTR));

initial begin
$dumpfile("RxFIFO.v");
$dumpvars;
end

always
#5 PCLK_RX=!PCLK_RX;

initial begin
PSEL_RX=1;
PWRITE_RX=1;
RxData=8'b00000000;
CLEAR_B_RX=0;
PCLK_RX=0;

#10
CLEAR_B_RX=1'b1;
RxData=8'b00000001;
#10
RxData=8'b00000010;
#10
RxData=8'b00000011;
#10
RxData=8'b00000101;
#10
RxData=8'b00000110;
#10
PWRITE_RX=1'b0;
#10
#10
#10
#10
#10
CLEAR_B_RX=0;

#40
$finish;
end


endmodule
