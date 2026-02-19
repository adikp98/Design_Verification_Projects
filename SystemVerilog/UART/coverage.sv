class coverage;
  transaction mon_tr;
  mailbox mon2cov;
  virtual intff intf;
  
  covergroup txn_cg;
    option.per_instance = 1;
    oper_cp : coverpoint mon_tr.oper{
      bins oper_vals[] = {[0:2]};}

    tx_data_cp : coverpoint mon_tr.tx_data {
      bins zero= {8'h00};
      bins all_ones = {8'hFF};
      bins others = {[1:254]};} 

  endgroup
  
  covergroup fsm_cg@(posedge intf.uclkrx);
    coverpoint intf.state_rx{
      bins idle_to_start = (0 => 1);
      bins start_to_data = (1 => 2[*8]);
      bins data_to_stop = (2 => 3);}    
  endgroup
  
 	
  
  function new(mailbox mon2cov, virtual intff intf);
    this.mon2cov = mon2cov;
    this.intf = intf;
    txn_cg  = new();
    fsm_cg = new();
  endfunction
  
  task run();
    repeat(10) begin
    mon2cov.get(mon_tr);
      txn_cg.sample();end

    
    $display("----------Coverage Summary----------");
    $display("Transaction Coverage: %0.2f%%", txn_cg.get_coverage());
    $display("State Transition Coverage in Rx: %0.2f%%", fsm_cg.get_coverage());
  endtask
  
endclass