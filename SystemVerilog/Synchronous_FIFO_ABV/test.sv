`include "environment.sv"
class test;
  environment env;
  virtual intf intff;
  
  function new(virtual intf intff);
    this.intff = intff;
    env = new(intff);
  endfunction
  
  task main();
    env.run();
  endtask
endclass