module RightShifter
#(
  parameter XLEN = 32,
  parameter SHIFT_AMT = 1
)
(
  input arithmetic,
  input shift,
  input[XLEN-1:0] in,
  output[XLEN-1:0] result
);
  wire[SHIFT_AMT-1:0] msbs; // Most significant bits that are shifted in.
  wire[XLEN-SHIFT_AMT-1:0] lsbs; // Remaining bits that are shifted right.

  // Shift in MSB or zeros for arithmetic or logical respectively:
  assign msbs = arithmetic ? {(SHIFT_AMT){in[XLEN-1]}} : {(SHIFT_AMT){1'b0}};

  // Shift:
  assign lsbs = in[XLEN-1:SHIFT_AMT];

  // Recombine LSBs with MSBs:
  assign result = shift ? {msbs, lsbs} : in;

endmodule

module Shift
#(
  parameter XLEN = 32,
  parameter LEFT = 0
)
(
  input arithmetic,
  input[XLEN-1:0] a,
  input[XLEN-1:0] b,
  output[XLEN-1:0] result
);
  // Index width from bit-width:
  localparam width = XLEN == 32  ? 5 :
                    XLEN == 64  ? 6 :
                    XLEN == 128 ? 7 :
                    0;

  // Generate shifters for << 1, << 2, << 4, << 8, ... , << width-1:
  wire[XLEN-1:0] links[width:0]; // Each link is the output from a shift; +1 to include initial input.
  genvar i;

  assign links[0] = a;
  assign result = links[width];

  generate
    // Iterate through the bits of the shift amount:
    for(i = 0; i < width; i = i + 1) begin : shifters
      if(LEFT) begin
        assign links[i+1] = b[i] ? links[i] << 2**i : links[i];
      end
      else begin
        RightShifter #(.XLEN(XLEN), .SHIFT_AMT(2**i)) rs(arithmetic, b[i], links[i], links[i+1]);
      end
    end
  endgenerate

endmodule