class apb_txn extends uvm_sequence_item;
  `uvm_object_utils(apb_txn)
  rand bit write;
  rand bit [7:0]addr;
  rand bit [31:0]data;
  bit [31:0]rdata;
  rand int idle_cycles;
  
  constraint c1{idle_cycle inside {[0:4]};}
  
  function new(string name, uvm_component parent);
    super.new(name,parent);
  endfunction
  
endclass
