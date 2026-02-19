`include "environment.sv";
class test;
  virtual intff intf;
  environment env;
  
  function new(virtual intff intf);
    this.intf = intf;
    env = new(intf);
  endfunction
  
  task run;
    env.main();
  endtask
endclass