// Code your testbench here
// or browse Examples
import uvm_pkg::*;
import apb_pkg::*;
module tb_top;
  logic pclk;
  always #5 pclk = ~pclk;
  apb_if vif(pclk);
  
  
  apb_slave dut(.pclk(vif.pclk),
                .prst(vif.prst),
                .psel(vif.psel),
                .penable(vif.penable),
                .pwrite(vif.pwrite),
                .pwdata(vif.pwdata),
                .prdata(vif.prdata),
                .paddr(vif.paddr),
                .pready(vif.pready),
                .pslverr(vif.pslverr));
  
  initial begin
    vif.prst = 0;
    repeat(5)@(posedge pclk)
      vif.prst = 1;
  end
  initial begin
    uvm_config_db#(virtual apb_if)::set(null, "uvm_test_top", "vif_drv", vif);
    uvm_config_db#(virtual apb_if)::set(null, "uvm_test_top", "vif_mon", vif);
  	run_test();
  end
  
                
endmodule
