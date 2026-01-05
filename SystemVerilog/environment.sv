`include "generator.sv"
`include "monitor.sv"
`include "driver.sv"
`include "scoreboard.sv"
class environment;
  generator gen;
  driver driv;
  monitor mon;
  scoreboard scb;
  mailbox gen2driv;
  mailbox mon2sco;
  virtual intf intff;
  event next;
  
  function new(virtual intf intff);
    this.intff = intff;
    this.next = next;
    gen2driv = new();
    mon2sco = new();
    gen = new(gen2driv,next);
    driv = new(gen2driv, intff);
    mon = new(mon2sco, intff);
    scb = new(mon2sco,next);

  endfunction
  
  task run();
    driv.reset();
    fork
    gen.main();
    driv.main();
    mon.main();
    scb.main();
    join
  endtask
  
endclass