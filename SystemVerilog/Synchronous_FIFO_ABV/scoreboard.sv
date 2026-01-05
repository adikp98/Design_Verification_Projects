class scoreboard;
  transaction tr;
  mailbox mon2sco;
  event next;
  bit [3:0]arr[$];
  bit [3:0]temp;
  
  function new(mailbox mon2sco,event next);
    this.mon2sco = mon2sco;
    this.next = next;
  endfunction
  
  task main();
    repeat(20) begin
    mon2sco.get(tr);
    //write check
    if(tr.wr_en == 1 && tr.rd_en == 0)begin
      if(!tr.full) begin
        arr.push_front(tr.din);
        $display("[SCB] : Data stored in FIFO");
      end
      else begin
        $display("[SCB] : FIFO is full");
        end
      end
      
      //read check
      if(tr.wr_en == 0 && tr.rd_en == 1)begin
        if(!tr.empty)begin
          temp = arr.pop_back();
          if(temp == tr.dout)
            $display("[SCB] : Data match");
          else
            $display("[SCB] : Data not match");
        end
        else
          $display("[SCB] : FIFO is empty");
      end
      
      //simultaneous write and read check
    if(tr.wr_en == 1 && tr.rd_en == 1)begin
        if(!tr.full && !tr.empty)begin
          arr.push_front(tr.din);
          $display("[SCB] : Data stored in FIFO");
          temp = arr.pop_back();
          if(temp == tr.dout)
            $display("[SCB] : Data match");
          else
            $display("[SCB] : Data mismatch, Simultaneous read and write failed");
        end
        else
          $display("[SCB] : Simultaneous read/write not possible: either full or empty");
      end
      $display("--------------------------------------------------");
      ->next;  
    end       
      
  endtask
  
endclass