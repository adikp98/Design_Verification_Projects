module apb_master(pclk,preset,write_transfer,read_transfer,paddr,psel,penable,pwrite,pwdata,pready,prdata,addr_in,data_in);
  input pclk,preset,pready,write_transfer,read_transfer;
  input [31:0]prdata,addr_in,data_in;
  output reg psel,penable,pwrite;
  output reg [31:0]paddr,pwdata;
  
  reg [1:0] state,next_state;
  reg [31:0] mem;
  parameter IDLE = 2'b00, SETUP = 2'b01, ACCESS = 2'b10;
  
  //present state logic
  always@(posedge pclk)begin
    if(preset)
      state <= IDLE;    
    else
      state <= next_state;
  end
  
  //next_state logic
  always@(*)begin
    next_state = state;
    case(state)
      IDLE : begin
        if(write_transfer && !read_transfer)
          next_state = SETUP;
        else if(!write_transfer && read_transfer)
          next_state = SETUP;
        else
          next_state = IDLE; 
      end
      SETUP: begin
        next_state = ACCESS;
      end
      ACCESS: begin
        if(pready && (write_transfer || read_transfer) && !(write_transfer && read_transfer))
          next_state = SETUP;
        else if(pready && !(write_transfer || read_transfer))
          next_state = IDLE;
        else
          next_state = ACCESS;          
      end
      default : begin
        next_state = IDLE;
      end
    endcase
  end
  
  //output logic
  always@(posedge pclk)begin
    if(preset)begin
      psel <= 0;
      penable <= 0;
      pwrite <= 0;
      paddr <= 0;
      pwdata <= 0;end
    else begin
      case(next_state)
        IDLE : begin          
          psel <= 0;
          penable <= 0;
      	  pwrite <= 0;
      	  paddr <= 0;
      	  pwdata <= 0;
        end
        SETUP : begin
          
          psel <= 1'b1;
          penable <= 1'b0;
          if(write_transfer)begin
            pwrite <= 1'b1;
            paddr <= addr_in;
            pwdata <= data_in;end
          else if(read_transfer) begin
            pwrite <= 1'b0;
            paddr <= addr_in;end
          else
            ;
        end
        ACCESS : begin
          psel <= 1'b1;
          penable <= 1'b1;
          pwrite <= pwrite;
          paddr <= paddr;
          pwdata <= pwdata;
          if(pready && read_transfer)
            mem <= prdata;
          else
            ;          
        end
        default: begin
          psel <= 0;
          penable <= 0;
      	  pwrite <= 0;
      	  paddr <= 0;
      	  pwdata <= 0;
        end
      endcase
    end
  
  end
