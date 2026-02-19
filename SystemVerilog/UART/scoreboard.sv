
class scoreboard;
  mailbox driv2scb;
  mailbox mon2scb;
  transaction driv_tr, mon_tr;
  event gen_scb;//event trigger to generator
  
  
  function new(mailbox mon2scb, mailbox driv2scb, event gen_scb);
    this.mon2scb = mon2scb;
    this.driv2scb = driv2scb;
    this.gen_scb = gen_scb;
  endfunction
  
  task run();
    repeat(10) begin
      fork
    driv2scb.get(driv_tr);
    mon2scb.get(mon_tr);
      join
      $display("----------Scoreboard-----------");
      if(mon_tr.oper == driv_tr.oper && driv_tr.oper == 2)begin
        $display("Reset done");
//         $display("tx_data = %0d, tx_done = %0d, rx_done = %0d",t2.tx_data, t2.tx_done, t2.rx_done);
      end
        
      else if(mon_tr.oper == driv_tr.oper && driv_tr.oper!=2)begin
        if(mon_tr.oper == 0)begin //Write
          if(mon_tr.data_tx == driv_tr.data_tx)begin
            $display("Data Matched");  
            $display("mon_tr.data_tx=%0d,driv_tr.data_tx=%0d",mon_tr.data_tx,driv_tr.data_tx);end
          else begin
            $display("Data not Matched");
            $display("mon_tr.data_tx=%0d,driv_tr.data_tx=%0d",mon_tr.data_tx,driv_tr.data_tx);end
        end
        else if(mon_tr.oper == 1)begin //Read
          if(mon_tr.data_rx == driv_tr.data_rx)begin
			$display("Data Matched");  
            $display("mon_tr.data_rx=%0d,driv_tr.data_rx=%0d",mon_tr.data_rx,driv_tr.data_rx);end
          else begin
            $display("Data not Matched");
            $display("mon_tr.data_rx=%0d,driv_tr.data_rx=%0d",mon_tr.data_rx,driv_tr.data_rx);end
        end
      end
   
      $display("###############################");
    -> gen_scb;
    end
      
  endtask
endclass