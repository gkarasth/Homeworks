`timescale 1ns / 1ps
module testbench;
reg reset,clk;
wire done,finish,rs,rw,E,RS,RW;
reg send;
wire [7:0] data; 
wire [3:0] D;
LCD_controler test(data,send,rs,rw,clk,reset,E,RS,RW,D,done);
//initializer initest(clk,reset,send,SF_D,LCD_E);
configuration conftest(clk,reset,done,data,finish);

initial begin
reset=1;
clk=0;
send = 0;
#80
reset=0;
send =1;
end

always #10 clk = ~clk;

endmodule
