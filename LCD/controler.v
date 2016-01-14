module LCD_controler(data,send,rs_in,rw_in,clk,reset,E,RS,RW,D,done);
input [7:0] data;
input rs_in,rw_in,clk,reset,send;
output E,RS,RW,done;
output [3:0]D;
  
   reg second_nibble;
   /////////////////
   
   parameter setupC = 2;       //state one and four
   parameter holdC =12;		   //state two and five
   parameter oneusC = 50;      //state three 
   parameter fortyusC = 2000;  //state six
   /////////////////
   
   
   parameter state1 = 7'b0000001; //init 
   parameter state2 = 7'b0000010; //low nibble setup time 
   parameter state3 = 7'b0000100; //low nibble hold time
   parameter state4 = 7'b0001000; //wait one us for high nibbles
   parameter state5 = 7'b0010000; //hight nibble setup time 
   parameter state6 = 7'b0100000; //high nibble hold time 
   parameter state7 = 7'b1000000; // wait 40 us
   
   reg done;
   reg [6:0] state;
   reg [11:0] counter;
   
   assign E = state[2]|state[5]; // E = active only on hold times
   assign RS = rs_in;
   assign RW = rw_in;
   assign D = data[3:0]&~{4{~second_nibble}}|data[7:4]&{4{~second_nibble}};
   
   
   always@(posedge clk)
      if (reset) begin
         state <= state1;
      end
      else
      case (state)
            state1 : begin
               if (send) begin
                  state <= state2;
               end else
                  state <= state1;
			   second_nibble <=0;
			   counter <=0;
			   done<=0;
            end
            state2 : begin
               if (counter==setupC-1) begin
                  state <= state3;
               end else begin
                  state <= state2;				  
			   end
			   second_nibble <=0;
			   counter <= counter+1;
            end
            state3 : begin
               if (counter==setupC + holdC-1)
                  state <= state4;
               else
                  state <= state3;
			   second_nibble <=0;
			   counter <= counter+1;
            end
            state4 : begin
               if (counter==setupC + holdC +oneusC-1) begin
				  second_nibble<=1;
                  state <= state5;
               end else begin
                  state <= state4;
				  second_nibble <=0;  
			   end
			   counter <= counter+1;
            end
            state5 : begin
               if (counter==setupC + holdC +oneusC+setupC-1)
                  state <= state6;
               else
                  state <= state5;
			   counter <= counter+1;
			   second_nibble <=1;
            end
            state6 : begin
               if (counter==setupC + holdC +oneusC+setupC+holdC-1)
                  state <= state7;
               else
                  state <= state6;
			   counter <= counter+1;
			   second_nibble <=1;
            end
            state7 : begin
               if (counter==setupC + holdC +oneusC+setupC+holdC+fortyusC-1) begin
				  done<=1;
                  state <= state1;
               end else
                  state <= state7;
			   counter <= counter+1;
			   second_nibble <=1;			   
            end
         endcase

							
   
endmodule

