class apb_drv extends uvm_driver#(apb_txn);
  `uvm_component_utils(apb_drv)
  virtual apb_if vif;
  
  function new(string name,uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db#(virtual apb_if)::get(null, "apb_drv", "vif_drv", vif);
    
  endfunction
  
  task run_phase(uvm_phase phase);
    apb_txn t;
    forever begin
      seq_item_port.get_next_item (t);
      //SETUP Phase
      vif.cb.psel <= 1'b1;
      vif.cb.penable <= 1'b0;
      @(posedge vif.pclk);
      
      //ACCESS Phase
      vif.cb.penable < = 1'b1;
      vif.cb.pwrite <= t.write;
      vif.cb.paddr <= t.addr;
      while(vif.cb.pready == 0);
      vif.cb.pwdata <= t.data;
      @(posedge vif.pclk);
      
      //Deassert phase
      
      vif.cb.psel <= 1'b0;
      vif.cb.penable <= 1'b0;
      
      
      repeat(t.idle_cycles)
        @(posedge vif.pclk);
      seq_item_port.item_done ();
    end
    
  endtask
  
endclass
