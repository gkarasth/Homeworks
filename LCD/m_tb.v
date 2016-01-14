//**********************************************************************************************************************
// FILE DESCRIPTION
// Copyright (C) 2014, Aeronix, Inc. All Rights Reserved, All Wrongs Avenged.
//**********************************************************************************************************************
`timescale 1 ns/100 ps




module tb_;
wire [7:0] letter;
wire finish;
reg clk ,reset,next;
// Parameter/Signal Declarations

// Instance Declarations
 message mtb(clk,reset,next,letter,finish);
  
  initial begin
reset=1;
clk=0;
next=0;
#80
reset=0;
end

always #10 clk = ~clk;
always #10 next = ~next;

endmodule