class driver;
  transaction tr;
  mailbox gen2driv;
  virtual intf intff;
  
  function new(mailbox gen2driv, virtual intf intff);
    this.gen2driv = gen2driv;
    this.intff = intff;
  endfunction
  
  task reset();
    intff.rst <= 1'b1;
    intff.rd_en <= 1'b0;
    intff.wr_en <= 1'b0;
    intff.din <= 0;
    @(posedge intff.clk);
    intff.rst <= 1'b0;
  endtask
  
  task read();
    @(posedge intff.clk);
    intff.rst <= 1'b0;
    intff.rd_en <= 1'b1;
    intff.wr_en <= 1'b0;
    @(posedge intff.clk);
    intff.rd_en <= 1'b0;
    $display("[DRV] : Driver read");
    @(posedge intff.clk);
  endtask
  
    task write();
    @(posedge intff.clk);
    intff.rst <= 1'b0;
    intff.rd_en <= 1'b0;
    intff.wr_en <= 1'b1;
    intff.din <= $urandom_range(1,10);
    @(posedge intff.clk);
    intff.wr_en <= 1'b0;
      $display("[DRV] : Driver write: %0d",intff.din);
    @(posedge intff.clk);  
  endtask
  
  task write_and_read();
    @(posedge intff.clk);
    intff.rst <=1'b0;
    intff.rd_en <= 1'b1;
    intff.wr_en <= 1'b1;
    intff.din <= $urandom_range(1,10);
    @(posedge intff.clk);
    intff.rd_en <= 1'b0;
    intff.wr_en <= 1'b0;
    $display("[DRV] : Simultaneous write & read: %0d",intff.din);
    @(posedge intff.clk);
  endtask
  
  task main();
    repeat(20) begin
    gen2driv.get(tr);
    if(tr.oper == 1)
      write();
    else if(tr.oper ==2)
      read();
    else if(tr.oper ==3)
      write_and_read();
    else
      reset();
    end
    
  endtask
  
endclass