`include "transaction.sv";
class generator;
  mailbox gen2driv;
  transaction t1;
  event gen_scb;
  
  //constructor
  function new(mailbox gen2driv, event gen_scb);
    this.gen2driv = gen2driv;
    this.gen_scb = gen_scb;
  endfunction
  
  task run;
        t1 = new();
    repeat(10) begin

    t1.randomize();
    gen2driv.put(t1);
      $display("----------Generator-----------");
   $display("tx_data=%0d,oper=%0d,tx_start=%0d",t1.tx_data,t1.oper,t1.tx_start);
      //waiting for scoreboard completion
      @(gen_scb);
    end
  endtask
endclass