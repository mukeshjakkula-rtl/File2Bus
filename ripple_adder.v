module ripple_adder#(DATA_WIDTH = 16)(
 input wire [DATA_WIDTH-1:0]A,B,
 output wire [DATA_WIDTH:0]S_out);

 wire [DATA_WIDTH:0]c_w;
 wire [DATA_WIDTH-1:0]S;

 assign c_w[0] = 1'b0;
 assign S_out = {c_w[DATA_WIDTH],S};

 generate 
    genvar i;
	for( i = 0;i < DATA_WIDTH;i= i + 1) begin
	    add fa(.a(A[i]),
		     .b(B[i]),
		     .c(c_w[i]),
		     .s(S[i]),
		     .cout(c_w[i+1]));
	end 
 endgenerate 
endmodule

module add(
   input wire a,b,c,
   output wire s,
   output wire cout);

 assign s = a^b^c;
 assign cout = (a&b)|(b&c)|(c&a);
endmodule 


