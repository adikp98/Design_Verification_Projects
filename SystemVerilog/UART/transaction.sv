class transaction;
  rand bit [7:0] tx_data;
  rand bit tx_start;
  rand bit [1:0] oper;
  bit tx_done;
  bit rx_done;
  bit [7:0]data_tx;
  bit [7:0]data_rx;
  bit first_item = 1;
  
  //write = 0, read = 1, reset = 2
 //first give reset and remaining random reads, writes
  constraint c1{
    if (first_item == 1)
      oper == 2;
  	else 
      oper inside {[0:1]};}
      //oper == 1;}
  
  constraint c2{tx_data inside {[0:255]};}
  function void post_randomize();
    first_item = 0;
  endfunction
  

endclass