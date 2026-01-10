module baudrate_generator(clk,rst, tx_en, rx_en);
  //We are assuming clock frequency as 50 Mhz
  // assume baud rate as 9600
  input clk, rst;
  output tx_en,rx_en;
  
  reg [12:0]baud_tx_counter;
  reg [8:0]baud_rx_counter;
  wire baud_tx_done, baud_rx_done;
  
  //TX baud rate generator
  always@(posedge clk)begin
    if(rst)
      baud_tx_counter <= 0;
    else if(baud_tx_done)
      baud_tx_counter <= 0;
    else
      baud_tx_counter <= baud_tx_counter + 1'b1;
  end
  
  
  //RX baud rate generator
    always@(posedge clk)begin
    if(rst)
      baud_rx_counter <= 0;
      else if(baud_rx_done)
      baud_rx_counter <= 0;
    else
      baud_rx_counter <= baud_rx_counter + 1'b1;
  end
  
  assign baud_tx_done = (baud_tx_counter == 5208)? 1'b1: 1'b0;
  assign baud_rx_done = (baud_rx_counter == 325)? 1'b1: 1'b0;
  assign tx_en = (baud_tx_done == 1'b1)?1'b1 : 1'b0;
  assign rx_en = (baud_rx_done == 1'b1)?1'b1 : 1'b0;
  
endmodule
