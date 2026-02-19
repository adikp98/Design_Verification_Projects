
class monitor;
  mailbox mon2scb;
  mailbox mon2cov;
  transaction mon_tr;
  virtual intff intf;

  
  bit [7:0]data_tx;
  bit [7:0]data_rx;
  
  localparam RESET = 2;
  localparam WRITE = 0;
  localparam READ = 1;
  
  function new(mailbox mon2scb,mailbox mon2cov, virtual intff intf);
    this.mon2scb = mon2scb;
    this.mon2cov = mon2cov;
    this.intf = intf;
  endfunction
    
  
    task run();
      repeat(10) begin
        @(posedge intf.uclktx);
        @(posedge intf.uclktx);
        
              //reset
        if(intf.rst) begin
          mon_tr = new();
          mon_tr.oper = RESET;
          @(posedge intf.uclktx);
          mon2scb.put(mon_tr);
          mon2cov.put(mon_tr);
        end
        
        //write
      else if(intf.tx_start == 1'b1 && intf.rx == 1'b1)begin
        mon_tr = new();
        mon_tr.oper = WRITE;
        data_tx = 0;
          @(posedge intf.uclktx);
        for(int i=0;i<=7;i++)begin
          @(posedge intf.uclktx);
          data_tx[i] = intf.tx;
          //$display("data_tx=%0d",data_tx);
        end
        
         @(posedge intf.uclktx);
        mon_tr.data_tx = data_tx;
        mon2scb.put(mon_tr);
        mon2cov.put(mon_tr);
      end
        
      //read
      else if(intf.rx == 1'b0)begin
        mon_tr = new();
        mon_tr.oper = READ;
        //data_rx = 0;
//         @(posedge intf.uclkrx);
//         wait(intf.rx_done == 1);
//         @(posedge intf.uclkrx);
        @(posedge intf.uclktx);
        for(int i=0;i<=7;i++)begin
          @(posedge intf.uclktx);
          //$display("shifter=%0d",intf.shifter);
        end
        
         @(posedge intf.uclktx);

        //$display("shifter=%0d",intf.shifter);
        data_rx = intf.rx_data;
        mon_tr.data_rx = data_rx;
        mon2scb.put(mon_tr);
        mon2cov.put(mon_tr);
      end
 
        $display("--------Monitor--------");
        $display("data_tx=%0d,tx_done=%0d,rx_data=%0d,rx_done=%0d",data_tx,intf.tx_done,intf.rx_data,intf.rx_done);
      end
  
    endtask
endclass
