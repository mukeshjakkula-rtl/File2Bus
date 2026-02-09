module apb_slave#(parameter DATA_WIDTH = 16,
                            MEM_DEPTH = 1024,
                           // ADDR_WIDTH = $clog2(MEM_DEPTH),
			    ADDR_WIDTH = 4)(
   input wire pclk,
   input wire prst,
   input wire [ADDR_WIDTH-1:0]paddr,
   input wire [DATA_WIDTH-1:0]pwdata,
   input wire penable,
   input wire pwrite,
   input wire psel,
   input wire t_valid,

   output reg [DATA_WIDTH-1:0]prdata,
   output reg pready
);

reg [DATA_WIDTH-1:0]apb_mem[MEM_DEPTH-1:0];  // 2KB memory slave 
reg [DATA_WIDTH-1:0]apb_data_buff;
reg [ADDR_WIDTH-1:0]apb_addr_buff;
reg apb_pwrite_buff;

typedef enum logic[2:0]{IDLE = 3'b100,
			SETUP = 3'b010,
			ACCESS = 3'b001}apb_states;
apb_states state;

always@(posedge pclk) begin
  if(prst) begin
    state <= IDLE;
    pready <= 1'b0;
    prdata <= {DATA_WIDTH{1'b0}};
    apb_addr_buff <= {ADDR_WIDTH{1'b0}};
    apb_data_buff <= {DATA_WIDTH{1'b0}};
    apb_pwrite_buff <= 1'b0;
    for(integer i = 0;i<ADDR_WIDTH;i++) begin
      apb_mem[i] <= {DATA_WIDTH{1'b0}};
    end
  end else begin
    case(state) 
      IDLE : begin
         pready <= 1'b0;
         prdata <= {DATA_WIDTH{1'b0}};
         if(psel && !penable) begin
            state <= SETUP;
         end else begin
            state <= IDLE;
         end
      end //idle

      SETUP : begin
	 pready <= 1'b0;
         if(pwrite) begin
	    apb_data_buff <= pwdata;
	    apb_addr_buff <= paddr;
	    apb_pwrite_buff <= pwrite;
            if(penable) state <= ACCESS;
            else state <= SETUP;
         end else if(!pwrite) begin
            apb_data_buff <= apb_mem[paddr];
	    apb_addr_buff <= paddr;
	    apb_pwrite_buff <= pwrite;
            if(penable) state <= ACCESS;
            else state <= SETUP;      
         end
      end //setup

      ACCESS : begin
	   if(apb_pwrite_buff) begin
              apb_mem[apb_addr_buff] <= apb_data_buff;
              pready <= 1'b1;
       end else if(!apb_pwrite_buff) begin
   	      prdata <= apb_data_buff;
          pready <= 1'b1;
       end else  begin
             state <= ACCESS;
             pready <= 1'b0;
        end
        if(t_valid) state <= SETUP;
        else state <= IDLE;
     end //access

default : state <= IDLE;
    endcase
  end
end 
endmodule 


