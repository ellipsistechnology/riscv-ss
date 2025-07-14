`include "CPU.v"

module CPU_tb;

  reg clk, rst_n;
  wire[8:0] leds;
  wire[6:0] seg;
  wire[3:0] an;

  CPU cpu(clk, rst_n, leds, seg, an);

  integer i;
  wire pre_clk;
  assign pre_clk = cpu.clk_prescaler[cpu.prescale_sel];
  initial begin
    clk = 0;
    rst_n = 1;

    $monitor("0x%h, 0x%h, %9b, %b, %h, %h", cpu.instructionAddress, cpu.instruction ,leds, cpu.data_rw, cpu.dataAddress, cpu.ledEn);//, cpu.ss.regFile.data[5], cpu.ss.regFile.data[6]);
    // $monitor("%6b", leds[5:0]);

    for(i = 0; i < 200; i = i + 1) begin
      #1
      clk = 1;
      #1
      clk = 0;
    end

    // Memory dump:
    // for(i = 240; i < 256; i = i + 1) begin
    //   $display("stack[0xffffff%0h] = 0x%h", i, cpu.stack[i]);
    // end
  end

endmodule