module uart_tx(clk, rst, wr_en, en_b, tx_data, tx, busy);
  input clk,rst, wr_en, en_b;
  input [7:0]tx_data;
  output tx, busy;
  
  parameter IDLE = 2'b00, START = 2'b01, DATA = 2'b10, STOP = 2'b11;
  reg [1:0] state, next_state;
  reg [7:0] data;
  reg [2:0] index;
  
  //Sequential block
  always@(posedge clk)begin
    if(rst)begin
      state <= IDLE;
      tx <= 1;end
    else
      state <= next_state;
  end
  
    //Combinational block
    always@(*)begin
      case(state)
        IDLE:begin
          if(wr_en)
            next_state = START;
          else
            next_state = IDLE;
        end
        START:begin
          if(en_b)
            next_state = DATA;
          else
            next_state = START;
        end          
        DATA:begin
            if(en_b && index == 3'h7)
              next_state = STOP;
          	else
              next_state = DATA;
        end
        STOP:begin
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
  
  //Output Logic
  always@(*)begin

    case(state)
      IDLE:begin
          data = tx_data;
      	  tx = 1;
      	index = 3'h0;end
      end
      START:begin
        tx = 0;end
      DATA:begin
        if(enb)begin
          if(index !=7)begin
            index += 1;end
          tx = data[index];end
      end
      STOP:begin
        tx = 1;
      end
      default: begin
        tx = 1;
      end
    endcase
  end
  
  assign busy = (state != IDLE)? 1'b1: 1'b0;
          
endmodule
