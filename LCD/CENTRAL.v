
module  centralMachine(clk,reset,instruction,RS,RW,Data_En);
input clk;
input reset;
output [3:0] instruction;
output RS,RW,Data_En;
reg rs,rw,m_sent;
reg start;
reg temp;
wire send,done,nextConfig,next,m_end;
wire [7:0] command,SF_D,data;
wire [3:0] SF_DInit,Data;
reg [7:0] cursor;
reg[25:0] min_counter;
reg start_count,cursor_pointer;
reg goto2;
/*
always@(reset)
if(reset)
start<=0;
else
start<=1;
*/

initializer Init(clk,reset,start,SF_DInit,LCD_EInit,doneInit);

configuration Config(clk,reset,nextConfig,sendConfig,SF_D,doneConfig);
   ///config in
   assign nextConfig = (done|doneInit)&state[1];   
   
message Mess(clk,reset,next,command,m_end);   
   ////message 
   assign next= done&state[3];
   

//////////////////////////////////////////////////////////////////////////////////////////////////////////
LCD_controler  Control(data,send,rs,rw,clk,reset,control_E,RSn,RWn,Data,done);
   //////////// in:
   assign send = sendConfig&state[1]|state[2]|state[3]&temp|(state[4]&(~start_count)&(~done));
   assign data = SF_D&{8{state[1]}}|set_addr&{8{state[2]}}|command&{8{state[3]}}|cursor&{8{state[4]}};
   //////////// out:
   assign RS = RSn;
   assign RW = RWn;
//////////////////////////////////////////////////////////////////////////////////////////////////////////

   parameter state1 = 5'b00001; //init 
   parameter state2 = 5'b00010; //config  
   parameter state3 = 5'b00100; //set addr 
   parameter state4 = 5'b01000; //message
   parameter state5 = 5'b10000; //cursor or space and one min 
   reg [4:0] state = state1;   
   
   parameter minC = 26'b10_1111_1010_1111_0000_1000_0000; //minute cycles 
   parameter set_addr = 8'b10000000;


      /// mux that chooses the final output 
   assign Data_En = LCD_EInit&state[0]|control_E&~state[0];
   assign instruction = SF_DInit&{4{state[0]}}|Data&~{4{state[0]}};
   
   always@(posedge clk)
	if (reset)
		min_counter<=0;
	else if(start_count)
	if(min_counter <= minC) begin
		min_counter<=min_counter+1;
		goto2<=0;
	end else begin
		min_counter<=0;
		goto2<=1;
	end
	
   always@(posedge clk)
      if (reset) begin
         state <= state1;
		 rs <= 0;
		 rw <= 0;
		 start<=0;
		 cursor_pointer<=0;
      end
      else
        case (state)
            state1 : begin//init 
               if (doneInit) begin
                  state <=  state2 ;
               end else
                  state <=  state1 ;				  
			   rs<=0;
			   rw<=0;
			   temp<=0;
			   start<=1;

            end
            state2  : begin//config  
               if (doneConfig) begin
                  state <=  state3 ;				  
				  rs<=0;
				  rw<=0;
               end else begin
                  state <=  state2 ;
				  rs<=0;
				  rw<=0;
				end
            end
            state3  : begin//set addr 
               if (done) begin					
                  state <=  state4 ;
				  rs<=1;
				  rw<=0;
                end else begin
                  state <=  state3 ;				  
				  rs<=0;
				  rw<=0;
				end
				min_counter <=0;
            end
            state4  : begin
               if (m_end==1) begin
                  state <= state5 ;
				  m_sent<=0;
				  temp<=m_sent;
				  start_count<=0;
				  cursor<=cursor_pointer?8'b01011111:8'b00100000;		
				  rs<=1;
				  rw<=0;
				end else if (next) begin
				  state <= state4;
				  temp<=m_sent;
				  start_count<=0;
				  m_sent<=1;
				  rs<=1;
				  rw<=0;
                end else begin
                  state <= state4;
				  m_sent<=0;		
				  temp<=m_sent;
				  start_count<=0;
				  rs<=1;
				  rw<=0;
				end
            end
			state5  : begin //
				if(start_count) begin
					if (goto2) begin
						state<=state3;
						cursor_pointer<=cursor_pointer+1;

					end
				end else if (done)
					start_count<=1;
				else 
				cursor<=cursor_pointer?8'b01011111:8'b00100000;				
				end
         endcase





endmodule
