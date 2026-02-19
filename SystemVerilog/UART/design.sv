// Code your design here
//UART Top module
`include "uart_tx.sv";
`include "uart_rx.sv";

module uart (clk,rst,tx_data,tx_start,tx,tx_done,rx,rx_data,rx_done);
  input clk,rst,tx_start,rx;
  input [7:0]tx_data;
  output tx,tx_done,rx_done;
  output [7:0]rx_data;
  
  uart_tx dut1(.clk(clk), .rst(rst), .tx_data(tx_data), .tx(tx), .tx_done(tx_done), .tx_start(tx_start));
  
  uart_rx dut2(.clk(clk), .rst(rst), .rx(rx), .rx_data(rx_data), .rx_done(rx_done));
  
endmodule