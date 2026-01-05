class transaction #(parameter dwidth = 4);
  rand bit [1:0] oper;
  bit rd_en;
  bit wr_en;
  bit [dwidth-1:0] din;
  bit [dwidth-1:0] dout;
  bit full;
  bit empty;
  
  constraint c1{oper dist{1:=80, 2:=20, 3:=0 };}
endclass
  