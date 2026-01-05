// Code your design here
//sync fifo with depth 16 and width 4
module sync_fifo(clk,rst,rd_en,wr_en,full,empty,din,dout);
  parameter depth = 16, dwidth = 4;
  input clk,rst,rd_en,wr_en;
  input [dwidth-1:0]din;
  output reg [dwidth-1:0]dout;
  output full,empty;
  reg [$clog2(depth):0]count;

  
  reg [$clog2(depth)-1:0]wr_ptr;
  reg [$clog2(depth)-1:0]rd_ptr;
  
  reg [dwidth-1:0]fifo[0:depth-1];
  
  //write
  always@(posedge clk)begin
    if(rst)begin
      wr_ptr <= 0;
      rd_ptr <= 0;
      count <= 0;
    end
    
    else if(wr_en && !full)begin
      	fifo[wr_ptr] <= din;
      wr_ptr <= (wr_ptr+1)%depth;
        count <= count + 1;
      end
  
  //read

    else if(rd_en && !empty)begin
          dout <= fifo[rd_ptr];
      rd_ptr <= (rd_ptr + 1)%depth;
          count <= count - 1;
        end
    end
  
  assign full = (count == depth);
  assign empty = (count == 0);
  
  
  //assertions
  assert property(@(posedge clk) (full && wr_en && !rd_en) |=> $stable(wr_ptr)) 
    else $error("Write ptr remain set even there is a write operation on FIFO full");
    
    assert property(@(posedge clk) (count > 15) |-> full);
    assert property(@(posedge clk) (count < 16) |-> !full);
      assert property(@(posedge clk) ((count == 15) && wr_en && !rd_en) |=> full);
    
  
endmodule
    
          
  