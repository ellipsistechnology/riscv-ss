module HexTo7seg(
    input [3:0] val,
    output reg [0:6] segs
    );

always @(val) begin
    case(val)
    4'd0 : segs = ~7'h7e; //1111110 -> 0000001 
    4'd1 : segs = ~7'h30;
    4'd2 : segs = ~7'h6d;
    4'd3 : segs = ~7'h79;
    4'd4 : segs = ~7'h33;
    4'd5 : segs = ~7'h5b;
    4'd6 : segs = ~7'h5f;
    4'd7 : segs = ~7'h70;
    4'd8 : segs = ~7'h7f;
    4'd9 : segs = ~7'h7b;
    4'hA : segs = ~7'b1110111;
    4'hB : segs = ~7'b0011111;
    4'hC : segs = ~7'b1001110;
    4'hD : segs = ~7'b0111101;
    4'hE : segs = ~7'b1001111;
    4'hF : segs = ~7'b1000111;
    endcase;
end

endmodule