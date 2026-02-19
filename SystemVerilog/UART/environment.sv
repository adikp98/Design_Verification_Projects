`include "generator.sv";
`include "driver.sv";
`include "monitor.sv";
`include "scoreboard.sv";
`include "coverage.sv";

class environment;
  mailbox gen2driv;
  mailbox mon2scb;
  mailbox driv2scb;
  mailbox mon2cov;
  generator gen;
  driver driv;
  monitor mon;
  scoreboard scb;
  coverage cov;
  virtual intff intf;
  event gen_scb;

  
  function new(virtual intff intf);
    this.intf = intf;
    gen2driv = new();
    mon2scb = new();
    driv2scb = new();
    mon2cov = new();
    gen = new(gen2driv, gen_scb);
    driv = new(gen2driv, driv2scb, intf);
    mon = new(mon2scb, mon2cov, intf);
    scb = new(mon2scb, driv2scb, gen_scb);
    cov = new(mon2cov, intf);
    
  endfunction
  
  task main;
    fork 
      gen.run();
      driv.run();
      mon.run();
      scb.run();
      cov.run();
    join
  endtask
  
endclass