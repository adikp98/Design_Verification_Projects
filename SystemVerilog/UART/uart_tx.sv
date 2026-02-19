// Code your design here

module uart_tx#(clock_freq = 10000000, baud_rate = 9600)(clk, rst, tx_start, tx_data, tx, tx_done);
  input clk,rst, tx_start;
  input [7:0]tx_data;
  output reg tx, tx_done;
  

  reg uclk = 0;
  parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
  reg [1:0] state, next_state;
  reg [7:0] data = 0;
  reg [3:0] index;
  
  localparam int cycles = clock_freq/baud_rate;
  int count = 0;
  
  //baud clock
  always@(posedge clk)begin
    if(count < cycles/2)begin
      count <= count + 1;end
    else begin
     count <= 0;
      uclk <= ~uclk;      
  	end
   end
  
  //Sequential block
  always@(posedge uclk)begin
    if(rst)begin
      state <= IDLE;
    end
    else
      state <= next_state;
  end
  
    //Combinational block
    always@(*)begin
      case(state)
        IDLE:begin
          if(tx_start)
            next_state = START;
          else
            next_state = IDLE;
        end
        START:begin
            next_state = DATA;
        end          
        DATA:begin
          if(index == 4'h8)
              next_state = STOP;
          	else
              next_state = DATA;
        end
        STOP:begin
            next_state = IDLE;
        end
        default: begin
          next_state = IDLE;
        end
        endcase
        end
  
  //Output Logic
    always@(posedge uclk)begin
      if(rst)begin
        tx <= 1;
        tx_done <= 0;
        index <= 4'h0;
      data <= 0;end
	  else begin 
//         if(next_state == IDLE && tx_start)
//           data <= tx_data;
        
        case(next_state)
      IDLE:begin
      	  tx <= 1;
        tx_done <= 0;
      	index <= 4'h0;  
        
      end
      START:begin
        tx <= 0;
      	tx_done <= 0;
        index <= 4'h0;
        data <= tx_data;
      end
      DATA:begin
          tx <= data[index];
            index <= index+ 1;
      end
      STOP:begin
        tx <= 1;
        tx_done <= 1;
      end
      default: begin
        tx <= 1;
      end
    endcase
      end
  end
  

          
endmodule