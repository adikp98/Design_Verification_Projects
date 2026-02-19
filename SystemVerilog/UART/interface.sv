interface intff;
  logic [7:0]shifter;
  logic [1:0] state_tx;
  logic [1:0] state_rx;
  logic clk;
  logic rst;
  logic rx;
  logic uclktx;
  logic uclkrx;
  logic [7:0]rx_data;
  logic [3:0] bit_count;
  logic rx_done;
  logic tx_start;
  logic [7:0]tx_data;
  logic tx;
  logic tx_done;
  
  
//////////Assertions/////////////
  
  //Read
  //(1) transition from idle to start
property p_idle_to_start;
  @(posedge uclkrx)
  disable iff (rst)
  (state_rx == 0 && rx == 0 |=> state_rx == 1);
endproperty
  
  assert property(p_idle_to_start)
    $display("Assertion 1 : Pass at %0t",$time);
    else
      $display("Assertion 1 : Fail at %0t",$time);
 
  //(2) transition from start to data
   property p_start_to_data;
     @(posedge uclkrx)
     disable iff(rst)
     (state_rx == 1)|=> state_rx == 2'b10;
   endproperty
    
    assert property(p_start_to_data)
      $display("Assertion 2 : Pass at %0t",$time);
    else
      $display("Assertion 2 : Fail at %0t",$time);
      
      
      //(3) transition from data to stop
      property checking_rxdone_in_stop;
        @(posedge uclkrx)
        disable iff(rst)
        (rx_done == 1 |-> state_rx == 2'b11);
      endproperty
      
      assert property(checking_rxdone_in_stop)
        $display("Assertion 3: Pass at %0t",$time);
        else
          $display("Assertion 3: Fail at %0t",$time);
        
        //(4) stop bit(rx_done) to remain high after the frame
        property stop_high_after_frame;
          @(posedge uclkrx)
          disable iff(rst)
          ((state_rx == 2 && bit_count == 8) |=> rx_done == 1);
        endproperty
        
        assert property(stop_high_after_frame)
          $display("Assertion 4: Pass at %0t",$time);
        else
          $display("Assertion 4: Fail at %0t",$time);
          
          //(5) start state to have rx bit as zero
          property start_state_rx_value;
            @(posedge uclkrx)
            disable iff(rst)
            (state_rx == 1 |-> $past(rx == 0));
          endproperty
          
        assert property(start_state_rx_value)
          $display("Assertion 5: Pass at %0t",$time);
        else
          $display("Assertion 5: Fail at %0t",$time);
          
       ///////////////////////////////

endinterface



  
  