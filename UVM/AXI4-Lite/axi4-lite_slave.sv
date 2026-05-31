// Code your design here
module axi4lite_slave(
  input logic clk,
  input logic rst,
  //Write address channel
  input logic [31:0]awaddr, 
  input logic awvalid, 
  output logic awready,
  //Write channel
  input logic [31:0]wdata, 
  input logic [3:0]wstrb, 
  input logic wvalid, 
  output logic wready,
  //Write response channel
  output logic [1:0]bresp, 
  output logic bvalid, 
  input logic bready,
  //Read address channel
  input logic [31:0]araddr, 
  input logic arvalid, 
  output logic arready,
  //Read Data + response channel
  output logic [31:0]rdata, 
  output logic [1:0]rresp, 
  output logic rvalid, 
  input logic rready);
  
  //Register file
  logic [31:0]regfile[0:3];
  reg [1:0]WADDR;
  reg [1:0]RADDR;
  
  //Flags
  logic awdone;
  logic wdone;
  logic ardone;
  
  //Write logic
  always@(posedge clk)begin
    if(rst)begin
      for(int i=0;i<4;i++)begin
        regfile[i] <= 32'h00000000;
      end
      bvalid <= 1'b0;
      awready <= 1'b1;
      wready <= 1'b1;
      awdone <= 1'b0;
      wdone <= 1'b0;  
    end
    else begin
      if(awvalid && awready)begin
        WADDR <= awaddr[3:2];
        awdone <= 1'b1;
        awready <= 1'b0;
      end
      
      if(wvalid && wready)begin
        wdone <= 1'b1;
        wready <= 1'b0;
      end
      
      if(wdone && awdone)begin
        if(wstrb[0]) regfile[WADDR][7:0] <= wdata[7:0];
        if(wstrb[1]) regfile[WADDR][15:8] <= wdata[15:8];
        if(wstrb[2]) regfile[WADDR][23:16] <= wdata[23:16];
        if(wstrb[3]) regfile[WADDR][31:24] <= wdata[31:24];
        bvalid <= 1'b1;
        bresp <= 2'b00;
        awdone <= 1'b0;
      	wdone <= 1'b0;
      end
      
      if(bvalid && bready)begin
        bvalid <= 1'b0;
        awready <= 1'b1;
        wready <= 1'b1;
      end
      
    end
  end
  
  //Read logic
  always@(posedge clk)begin
    if(rst)begin
      arready <= 1'b1;
      ardone <= 1'b0;
      rvalid <= 1'b0;
    end
    else begin
      if(arvalid && arready)begin
        RADDR <= araddr[3:2];
        ardone <= 1'b1;
        arready <= 1'b0;
      end
      
      if(ardone)begin
        rdata <= regfile[RADDR];
        rvalid <= 1'b1;
        rresp <= 2'b00;
    end
      
      if(rvalid && rready)begin
        rvalid <= 1'b0;
        arready <= 1'b1;
        ardone <= 1'b0;
      end
      
      
  end
  
  
endmodule
