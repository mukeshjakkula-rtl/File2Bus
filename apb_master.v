//this apb is modified according to the design requirements 

module apb_master#(
	parameter DATA_WIDTH = 16,
		  MEM_DEPTH = 1024,
		  //ADDR_WIDTH = $clog2(MEM_DEPTH
                  ADDR_WIDTH = 4)(
	input wire pclk,
	input wire prst,
	input wire t_valid,
	input wire pready,
	input wire pwrite_in,
	input wire [1:0]psel_in,
	input wire [DATA_WIDTH-1 : 0]pwdata_in,
	input wire [ADDR_WIDTH-1 : 0]paddr_in,
	input wire [DATA_WIDTH-1 : 0]prdata,

	output reg [DATA_WIDTH-1 : 0]pwdata,
	output reg [ADDR_WIDTH-1 : 0]paddr,
	output reg pwrite,
        output reg psel1,psel2,psel3,psel4,  //assuming multiple apb_slaves
	output reg penable,
        output reg ready // used to only take the data in the setup state only 
);

wire [3:0]psel_d_out; // output of the apb_slave decoder in master
reg [DATA_WIDTH-1:0]prdata_buff;
typedef enum logic[2:0]{IDLE = 3'b100,
			SETUP = 3'b010,
			ACCESS = 3'b001} apb_states;
apb_states state;


  always@(posedge pclk) begin
    if(prst) begin
	state <= IDLE;
	pwdata <= {DATA_WIDTH{1'b0}};
	paddr <= {ADDR_WIDTH{1'b0}};
	penable <= 1'b0;
	psel1 <= 1'b0;
	psel2 <= 1'b0;
        psel3 <= 1'b0;
        psel4 <= 1'b0;
	pwrite <= 1'b0;
        ready <= 1'b0;
    end else begin
	case(state) 
	  IDLE : begin
	     psel1 <= 1'b0;
	     psel2 <= 1'b0;
             psel3 <= 1'b0;
             psel4 <= 1'b0;
	     penable <= 1'b0;
             ready <= 1'b0;
	     if(t_valid) state <= SETUP;
	     else state <= IDLE;
	  end // idle

	  SETUP : begin
		{psel4,psel3,psel2,psel1} <= psel_d_out;
		penable <= 1'b0;
		pwrite <= pwrite_in;
		paddr <= paddr_in;
		pwdata <= pwdata_in;
                ready <= 1'b1;
                if(psel_d_out == 4'b000) state <= SETUP;
		else state <= ACCESS;
	  end //setup

	  ACCESS : begin
		penable <= 1'b1;
		ready <= 1'b0;
		prdata_buff <= prdata;	
		if(pready && t_valid) begin
		   state <= SETUP;
		   prdata_buff <= prdata;
		end else if(pready && !t_valid) begin
		   state <= IDLE;
		   prdata_buff <= prdata;
		end else if(!pready) state <= ACCESS;
	     end //access
        default : state <= IDLE;
	endcase
    end   
  end 

   decoder f1(.in(psel_in), .out({psel_d_out})); // slave address decoder 

endmodule 


module decoder(
   input wire [1:0]in,
   output reg[3:0]out);

  always@(*) begin
     case(in) 
	2'b00 : out = 4'b0000;
	2'b01 : out = 4'b0001;
	2'b10 : out = 4'b0010;
	2'b11 : out = 4'b0100;
     endcase
  end 
endmodule 
