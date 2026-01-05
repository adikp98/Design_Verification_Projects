interface intf #(parameter dwidth = 4) ();
  logic clk;
  logic rst;
  logic rd_en;
  logic wr_en;
  logic [dwidth-1:0]din;
  logic [dwidth-1:0]dout;
  logic full;
  logic empty;
  
    
  //assertions
  always@(posedge clk)begin
    assert property($rose(rst) |=> (!full && empty))
    else $error("On reset FIFO should be empty not full");
      end
    
   always@(posedge clk)begin
    assert property((full && wr_en && !rd_en) |=> $stable(full))
      else $error("Full flag should remain set even if there is a write on full");
      end
      
endinterface