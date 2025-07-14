`ifndef _ALUFULL_V_
`define _ALUFULL_V_

`include "status.v"
`include "Shift.v"

`define AND  4'b0000
`define OR   4'b0001
`define ADD  4'b0010
`define SUB  4'b1010
`define SUM  3'b010
`define SLT  4'b1100
`define SLTU 4'b1101
`define XOR  4'b0011
`define SRA  4'b1110
`define SRL  4'b0110
`define SR   3'b110
`define SLL  4'b0111

module ALUFull
#(parameter XLEN = 32)
(
  input[XLEN-1:0] a,
  input[XLEN-1:0] b,
  input[3:0] op,
  output[3:0] status,
  output reg[XLEN-1:0] result
);

  wire[XLEN-1:0] b_;
  wire cOut;
  wire[XLEN-1:0] sum, slt, sltu, leftShift, rightShift;
  wire lessThanUnsigned;

  // Shift modules:
  Shift #(.XLEN(XLEN), .LEFT(0)) rs(op[3], a, b, rightShift);
  Shift #(.XLEN(XLEN), .LEFT(1)) ls(1'b0,  a, b, leftShift);

  // Negate b by inverting and adding 1:
  assign b_ = {(XLEN){op[3]}} ^ b; // invert b

  // Status:
  assign status = {
    a[XLEN-1] & b_[XLEN-1] & ~result[XLEN-1] | ~a[XLEN-1] & ~b_[XLEN-1] & result[XLEN-1], // Overflow
    result[XLEN-1], // Negative
    result == 0,    // Zero
    op == `SUB ? lessThanUnsigned : cOut // Carry or less than unsigned
  };

  // Intermediate values:
  assign {cOut, sum} = a + b_ + op[3];
  assign slt[XLEN-1:1] = {(XLEN-1){1'b0}};
  assign slt[0] = sum[XLEN-1]; // TODO: Account for overflow.
  assign sltu[XLEN-1:1] = {(XLEN-1){1'b0}};
  assign sltu[0] = lessThanUnsigned;
  assign lessThanUnsigned = 
    ~a[XLEN-1] & b[XLEN-1] |  // a starts with 0, b starts with 1 .: a < b
    b[XLEN-1] & sum[XLEN-1] | // a and b both start with 1 and a - b is negative .: a < b (no overflow possible if both a & b have the same sign)
    sum[XLEN-1] & ~a[XLEN-1]; // a and b both start with 0 and a - b is negative .: a < b

  // MUX between AND, OR, ADD, XOR:
  always @(*)
    case(op[2:0])
      3'b000: result = a & b_;
      3'b001: result = a | b_;
      3'b010: result = sum;
      3'b011: result = a ^ b_;
      3'b100: result = slt;
      3'b101: result = sltu;
      3'b110: result = rightShift;
      3'b111: result = leftShift;
    endcase
  
endmodule

`endif