// Code your testbench here
// or browse Examples
`include "test.sv"
`include "interface.sv"

module sync_fifo_tb;
  intf intff();
  test t;
  
  sync_fifo dut(.clk(intff.clk),
                .rst(intff.rst),
                .rd_en(intff.rd_en),
                .wr_en(intff.wr_en),
                .din(intff.din),
                .dout(intff.dout),
                .full(intff.full),
                .empty(intff.empty));
  
  initial begin
    t = new(intff);
    t.main();  
    #1000 $finish;
  end
  
  initial begin
    intff.clk = 0;
  end
  
  always #5 intff.clk = ~intff.clk;
endmodule
  
  