
class driver;
  mailbox gen2driv;
  mailbox driv2scb;// this mailbox will send data from driver to scoreboard for reference values
  transaction t1, driv_tr;
  virtual intff intf;
  bit [7:0]data_rx = 0;
  bit temp;
  
  localparam WRITE = 0;
  localparam READ = 1;
  localparam RESET = 2;
  localparam WRITE_READ = 3;
    
  function new(mailbox gen2driv, mailbox driv2scb, virtual intff intf);
    this.driv2scb = driv2scb; 
    this.gen2driv = gen2driv;
      this.intf = intf;
    endfunction
  
  //reset task
  task reset();
    driv_tr = new;
    intf.rst <= 1'b1;
    intf.tx_start <= 1'b0;
    intf.tx_data <= 0;
    intf.rx <= 1'b1;
    @(posedge intf.uclktx);
    intf.rst <= 1'b0;
    driv_tr.oper = RESET;
    driv2scb.put(driv_tr);
  endtask
  
  //write task
  task write();
    driv_tr = new;
    driv_tr.oper = WRITE;
    intf.rst <= 1'b0;
    intf.tx_start <= 1'b1;
    intf.rx <= 1'b1;
    intf.tx_data <= t1.tx_data;
    @(posedge intf.uclktx);
    @(posedge intf.uclktx);
    intf.tx_start <= 1'b0;
    wait(intf.tx_done == 1);
    driv_tr.data_tx = intf.tx_data;
    driv2scb.put(driv_tr);
  endtask
  
  //read task
  task read();
    driv_tr = new;
    driv_tr.oper = READ;
    data_rx <= 0;
    intf.rst <= 1'b0;
    intf.tx_start <= 1'b0;
    intf.rx <= 1'b0;
    @(negedge intf.uclkrx);

    for(int i=0;i<=7;i++)begin
      temp = $urandom;
      @(negedge intf.uclkrx);
      intf.rx <= temp;
      data_rx[i] <= temp;
    end
    wait(intf.rx_done == 1);
    intf.rx <= 1'b1;
    //$display("rx=%0d,data_rx=%0d",intf.rx,data_rx);
    driv_tr.data_rx = data_rx;
    driv2scb.put(driv_tr);
  endtask
  
  task write_read();
    write();
    read();
  endtask
    
    
  
  task run();
    repeat(10) begin
      gen2driv.get(t1);
      @(posedge intf.uclktx);
      
      //write

      if(t1.oper == WRITE)begin
        write();
   
      end

      //read
      else if(t1.oper == READ)begin
        read();
      end

      //reset
      else if(t1.oper == RESET)begin
        reset();end
        
        else if(t1.oper == WRITE_READ)begin
          write_read();
        end
        

      $display("--------Driver--------"); $display("oper=%0d,rst=%0d,tx_start=%0d,tx_data=%0d,data_rx=%0d",t1.oper,intf.rst,t1.tx_start,t1.tx_data,data_rx);
    end
 	
  endtask
endclass