module uart_rx(clk, rst, rx, en_b, rx_data, rx_done);
  input clk,rst, rx, en_b;
  output [7:0]rx_data;
  output rx_done;
 
  
  parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
  reg [1:0] state, next_state;
  reg [2:0] bit_count;
  reg [7:0] shifter;
  

  //present state
  always@(posedge clk)begin
    if(rst)begin
      rx_done <= 0;
      rx_data <= 0;
      shifter <= 0;
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
        if(en_b)
          next_state  = DATA;
        else
          next_state = START;
      end
      DATA : begin
        if(en_b && bit_count == 7)
          next_state = STOP;
        else
          next_state = DATA;
      end
      STOP : begin
        if(en_b)
          next_state = IDLE;
        else
          next_state = STOP;
      end
  	  default: begin
        next_state = IDLE;
      end
    endcase
  end
  
  //output
  always@(*)begin
    case(state)
      IDLE : begin
        		rx_done = 0;
        		rx_data = 0;
      		end
      START : begin
        		bit_count = 0;
      		end
      DATA: begin
        if(en_b)begin
              shifter = {rx, shifter[7:1]};                
          bit_count +=1;end
      		end
      STOP: begin
        rx_data = shifter;
        rx_done = 1;end
      default: begin
        rx_done = 0
        rx_data = 0;
      end
      endcase
      end
endmodule
         
  
