module configuration(clk,reset,next,send,SF_D,done);
input clk,reset,next;
output [7:0] SF_D;
output done;
output reg send;


   parameter state1  = 7'b0000001; //initial state
   parameter state2  = 7'b0000010; //Function Set
   parameter state3  = 7'b0000100; //Entry Set
   parameter state4  = 7'b0001000; //Set Display
   parameter state5  = 7'b0010000; //Clear Display
   parameter state6  = 7'b0100000; //wait 1,84ms == 82000 cycles 
   parameter state7  = 7'b1000000; //done 
   //////
  
   parameter C82000 = 82000;
   parameter Function_set =  8'b00101000;  //0x28
   parameter Entry_set =     8'b00000110;  //0x06
   parameter Display_setON = 8'b00001100;  //0x0C
   parameter Clear_display = 8'b00000001;  //0x01
   
	reg [6:0] state;
	reg [19:0] counter;
	
   assign done = state[6];
   assign SF_D = {8{state[1]}}&(Function_set)|{8{state[2]}}&(Entry_set)|{8{state[3]}}&(Display_setON)|{8{state[4]}}&(Clear_display);


   always@(posedge clk)
      if (reset) begin
         state <= state1 ;
      end
      else
         case (state)
            state1  : begin //initial state
               if (next) begin 
				  send<=1;
                  state <= state2 ;
               end else
                  state <= state1 ;
				  counter<=0;
				  send<=0;
				  end
            state2  : begin //Function Set 0x28
               if (next) begin 
				  send<=1;
                  state <= state3 ;
               end else
                  state <= state2 ;
				  send<=1;
            end
            state3  : begin //Entry Set 0x06
               if (next) begin 
				  send<=1;
                  state <= state4 ;
               end else
                  state <= state3 ;
				  send<=1;
            end
            state4  : begin //Set Display 0x0C
               if (next) begin 
				  send<=1;
                  state <= state5 ;
               end else
                  state <= state4 ;
				  send<=1;
            end
            state5  : begin //Clear Display 0x01
               if (next)
                  state <= state6 ;
               else
                  state <= state5 ;
				  send<=0;
            end
            state6  : begin //wait 1,84ms == 82000cycles 
               if (counter==C82000-1)
                  state <= state7;
               else
                  state <= state6;
				  counter<=counter+1;
				  send<=0;
            end
            state7  : begin
               if (state[6])
                  state <= state1;
               else
                  state <= state7;
				  send<=0;
            end
         endcase

  
							
endmodule