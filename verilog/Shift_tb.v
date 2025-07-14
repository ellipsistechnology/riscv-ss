`include "Shift.v"

module Shift_tb;

    reg[31:0] a, b;
    wire[31:0] resultLeft, resultRight;
    reg arr;

    Shift #(.LEFT(0)) sr(arr, a, b, resultRight);
    Shift #(.LEFT(1)) sl(1'b0, a, b, resultLeft);

    initial begin
      $monitor("%b, %32b, %d, %32b, %32b", arr, a, b, resultLeft, resultRight);

      arr = 0; // Logical
      a = 2;
      b = 1;

      #1 a = -123;
      #1 arr = 1;
      #1 b = 2;
      #1 arr = 0;
      #1 b = 3;
      #1 arr = 1;
      #1 a = 64832;
      #1 arr = 0;
    end
endmodule