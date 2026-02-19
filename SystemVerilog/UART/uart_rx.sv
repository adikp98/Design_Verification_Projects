// Code your design here
// or browse Examples
module uart_rx#(clock_freq = 10000000, baud_rate = 9600)(clk, rst, rx, rx_data, rx_done);
  input clk,rst, rx;
  output reg [7:0]rx_data;
  output reg rx_done;
 
  
  parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
  reg [1:0] state, next_state;
  reg [3:0] bit_count;
  reg [7:0] shifter;
  int count = 0;
  int cycles = clock_freq/baud_rate;
  reg uclk = 0;
  
	//baud clock
  always@(posedge clk)begin
    if(count < cycles/2)begin
      count <= count + 1;end
    else begin
     count <= 0;
      uclk <= ~uclk;      
  	end
   end
  
  //present state
  always@(posedge uclk)begin
    if(rst)begin
      state <= IDLE;
    end   
    else
      state <= next_state;
  end
  
  //next_state
  always@(*)begin
    
    case(state)
      IDLE : begin
        if(rx == 0)
          next_state = START;
        else
          next_state = IDLE;
      end
      START : begin
          next_state  = DATA;
      end
      DATA : begin
        if(bit_count == 4'd8)
          next_state = STOP;
        else
          next_state = DATA;
      end
      STOP : begin
          next_state = IDLE;
      end
  	  default: begin
        next_state = IDLE;
      end
    endcase
  end
  
  //output
  always@(posedge uclk)begin
    if(rst)begin
      rx_done <= 0;
      rx_data <= 0;
      shifter <= 0;
      bit_count <= 0;
    end
    
    else begin
      case(next_state)
      IDLE : begin
        		rx_done <= 0;
      			rx_data <= 0;
      		end
      START : begin
        		shifter <= 0;
        		bit_count <= 0;
      		end
      DATA: begin
              shifter <= {rx, shifter[7:1]};                
          	  bit_count <= bit_count + 1;
      		end
      STOP: begin
        rx_data <= shifter;
        rx_done <= 1;
        end
      default: begin
        rx_done <= 0;
        rx_data <= 0;
      end
      endcase
      end
  end
endmodule
         
  