`include "alu.v"

`define XLEN 32

module ALU_tb;

  reg[`XLEN-1:0] a, b;
  reg c;
  reg[2:0] alu_op;
  wire[3:0] status;
  wire signed [`XLEN-1:0] result;

  ALU #(.XLEN(`XLEN)) alu(a, b, c, alu_op, status, result);

  integer i = 0;

  initial begin

    a = 0;
    b = 0;
    c = 0;
    alu_op = `ADD;

    // Test ADD with Fibonacci:
    a = 1;
    b = 1;

    for(i = 0; i < 10; i = i + 1) begin
      a = a + b;
      #1
      $display("%d [%b] %d = %d [%b]", a, alu_op, b, result, status);
      b = a + b;
      #1
      $display("%d [%b] %d = %d [%b]", a, alu_op, b, result, status);
    end

    // Carry out:
    a = {(`XLEN){1'b1}}; // max unsigned number
    b = 1;
    #1
    $display("%d [%b] %d = %d [%b]", a, alu_op, b, result, status);

    // Test SUB:
    a = 0;
    b = 0;
    alu_op = `SUB;

    for(i = 0; i < 100; i = i + 9) begin
      a = i*i;
      b = i;
      #1
      $display("%d [%b] %d = %d [%b]", a, alu_op, b, result, status);
    end

    // Test OR:
    a = 0;
    b = 0;
    alu_op = `OR;

    for(i = 0; i < 100; i = i + 9) begin
      a = i*i;
      b = i;
      #1
      $display("%b [%b] %b = %b [%b]", a, alu_op, b, result, status);
    end

    // Test AND:
    a = 0;
    b = 0;
    alu_op = `AND;

    for(i = 0; i < 100; i = i + 9) begin
      a = i*i;
      b = i;
      #1
      $display("%b [%b] %b = %b [%b]", a, alu_op, b, result, status);
    end

    // Test XOR:
    a = 0;
    b = 0;
    alu_op = `XOR;

    for(i = 0; i < 100; i = i + 9) begin
      a = i*i;
      b = i;
      #1
      $display("%b [%b] %b = %b [%b]", a, alu_op, b, result, status);
    end

  end

endmodule