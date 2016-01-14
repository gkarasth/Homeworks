//**********************************************************************************************************************
// FILE DESCRIPTION
// Copyright (C) 2014, Aeronix, Inc. All Rights Reserved, All Wrongs Avenged.
//**********************************************************************************************************************
`timescale 1 ns/100 ps
module tb_final;

reg clk,reset,start;
wire RS,RW,Data_En;
wire [3:0] instruction;
centralMachine cmtb(clk,reset,instruction,RS,RW,Data_En);

initial begin
reset=1;
clk=0;
start = 0;
#80
reset=0;
//start=1;
end

always #10 clk = ~clk;
endmodule