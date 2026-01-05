class monitor;
  transaction tr;
  mailbox mon2sco;
  virtual intf intff;
  
  function new(mailbox mon2sco, virtual intf intff);
    this.mon2sco = mon2sco;
    this.intff = intff;
  endfunction
  
  task main();
    repeat(20) begin
    tr = new();
    @(posedge intff.clk);
    @(posedge intff.clk);
    tr.rd_en = intff.rd_en;
    tr.wr_en = intff.wr_en;
    tr.din = intff.din;
    tr.full = intff.full;
    tr.empty = intff.empty;
    @(posedge intff.clk);
    tr.dout = intff.dout;
      $display("[MON] : rd_en=%0d, wr_en=%0d, din=%0d, full=%0d, empty=%0d, dout=%0d",tr.rd_en,tr.wr_en,tr.din,tr.full,tr.empty,tr.dout);
    mon2sco.put(tr);
    end
  endtask
     
endclass