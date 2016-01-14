module initializer(clk,reset,start,SF_D,LCD_E,done);
input reset,clk,start;
output reg [3:0] SF_D;
output reg LCD_E;
output done;


   parameter  state1   = 11'b00000000001; //initial state 
   parameter  state2   = 11'b00000000010; //wait 15ms
   parameter  state3   = 11'b00000000100; //12 cycles ,x03
   parameter  state4   = 11'b00000001000; //wait 4,1ms
   parameter  state5   = 11'b00000010000; //12 cycles ,x03
   parameter  state6   = 11'b00000100000; //wait 100us
   parameter  state7   = 11'b00001000000; //12 cycles ,x03
   parameter  state8   = 11'b00010000000; //wait 40us
   parameter  state9   = 11'b00100000000; //12 cycles ,x02
   parameter  state10  = 11'b01000000000; //wait 40us
   parameter  state11  = 11'b10000000000; //done 
   
   /////////////parameters for 50mhz
   parameter C12 = 12;      //12cycles 
   parameter ms15 = 750000;  //15ms = 750000 cycles
   parameter ms4p1 = 205000; //4.1ms = 205000 cycles 
   parameter us100 = 5000;   //100us = 5000 cycles
   parameter us40 = 2000;    //40us = 2000 cycles

   reg [10:0] state = state1 ;
   reg [19:0] counter = 0;
   assign done = state[10];

   always@(posedge clk,posedge reset)
      if (reset) begin
         state <= state1 ;
      end
      else
         case (state)
             state1  : begin //initial state 
               if (start==1) begin
                  state <= state2 ;
				  SF_D<=0;
				  LCD_E<=0;				  
               end else
                  state <= state1 ;
			   counter<=0;
            end
             state2  : begin //wait 15ms
               if (counter==ms15-1) begin
				  counter<=0;
                  state <= state3;
				  SF_D<=3;
				  LCD_E<=1;	
               end else begin
                  state <= state2 ;
				counter<=counter+1;
				end
            end
             state3  : begin //12 cycles ,x03
               if (counter==C12-1) begin
				  counter<=0;
                  state <=  state4 ;		
				  LCD_E<=0;
				  SF_D<=0;				  
               end else begin
                  state <=  state3 ;
				counter<=counter+1;
				end
            end
             state4  : begin //wait 4,1ms
               if (counter==ms4p1-1) begin
				  counter<=0;
                  state <=  state5 ;
				  SF_D<=3;
				  LCD_E<=1;
               end else begin
                  state <=  state4 ;
			    counter<=counter+1;
				end
            end
            state5  : begin//12 cycles ,x03
               if (counter==C12-1) begin
				  counter<=0;
                  state <=  state6 ;
				  LCD_E<=0;
				  SF_D<=0;
               end else begin
                  state <=  state5 ;
				counter<=counter+1;
				end
            end
             state6  : begin//wait 100us
               if (counter==us100-1) begin
				  counter<=0;
                  state <=  state7 ;
				  SF_D<=3;
				  LCD_E<=1;
               end else begin
                  state <=  state6 ;
				counter<=counter+1;
				LCD_E<=0;
				end
            end
             state7  : begin//12 cycles ,x03
               if (counter==C12-1) begin
				  counter<=0;
                  state <=  state8;
				  LCD_E<=0;
				  SF_D<=0;
               end else begin
                  state <=  state7 ;
				counter<=counter+1;
				end
            end
             state8  : begin//wait 40us
               if (counter==us40-1) begin
				  counter<=0;
                  state <=  state9 ;
				  SF_D<=2;
				  LCD_E<=1;
               end else begin
                  state <=  state8 ;
				counter<=counter+1;
				LCD_E<=0;
				end
            end
             state9  : begin//12 cycles ,x02
               if (counter==C12-1) begin
				  counter<=0;
                  state <=  state10 ;
				  LCD_E<=0;
				  SF_D<=0;
               end else begin
                  state <=  state9 ;
				counter<=counter+1;
				end
            end
             state10  : begin //wait 40us
               if (counter==us40-1) begin
				  counter<=0;
                  state <=  state11 ;
				  SF_D<=0;
				  LCD_E<=0;
               end else begin
                  state <=  state10 ;
				counter<=counter+1;
				end
            end
             state11  : begin //done
               if (counter==1) begin
				  counter<=0;
                  state <=  state1 ;
				  SF_D<=0;
				  LCD_E<=0;
               end else begin
                  state <= state11 ;
			    counter<=counter+1;
				end
            end          
         endcase

 endmodule				