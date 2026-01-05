`include "transaction.sv"
class generator;
  mailbox gen2driv;
  transaction tr;
  event next;
  //event done;
  
  function new(mailbox gen2driv, event next);
    this.gen2driv = gen2driv;
    this.next = next;
  endfunction
  
  task main();
    repeat(20)begin
    tr = new();
    tr.randomize();
    gen2driv.put(tr);
      $display("[GEN] : Operation : %0d",tr.oper);
    @(next);
    end
    
  endtask
  
endclass