// Code your testbench here
// or browse Examples
`include "test.sv";
`include "interface.sv";
module tb;
  intff intf();
  test t_h;
  
  
  //dut connection
  uart dut (.clk(intf.clk), .rst(intf.rst), .tx_data(intf.tx_data), .tx(intf.tx), .tx_done(intf.tx_done), .tx_start(intf.tx_start), .rx(intf.rx), .rx_data(intf.rx_data), .rx_done(intf.rx_done));
  
  initial begin
    intf.clk = 0;
  end
  
  //clock
  always #5intf.clk = ~intf.clk;
  
  initial begin
    t_h = new(intf);
    t_h.run();
    #1000 $finish;
  end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end
  
  //uart clock connection
  assign intf.uclktx = dut.dut1.uclk;
  assign intf.uclkrx = dut.dut2.uclk;
  
  assign intf.shifter = dut.dut2.shifter;
  assign intf.state_tx = dut.dut1.state;
  assign intf.state_rx = dut.dut2.state;
  assign intf.bit_count = dut.dut2.bit_count;
  

  
  
endmodule