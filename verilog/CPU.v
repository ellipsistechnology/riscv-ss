`include "SingleCycle.v"
`include "HexTo7seg.v"

module CPU(
  input clk,           // clk input
  input btnU,          // reset input
  output wire[8:0] led,// 6 LEDS pin
  output wire[0:6] seg,// 7-segment common LED cathodes
  output reg[3:0] an   // 7-segment annodes
);
  // Clock:
  reg[15:0] clk_prescaler;
  reg[3:0]  prescale_sel;
  reg[15:0] counter;
  reg[15:0] cmp_reg;
  reg interrupt;

  // Memory:
  reg[7:0]   rom[0:255];
  reg[7:0]   ram[0:255];
  reg[7:0] stack[0:255];
  reg[7:0] portA;
  wire ramEn, romEn, stackEn, ledEn;
  wire data_rw;

  // Address and data buses:
  wire[31:0] instructionAddress;
  wire[31:0] dataAddress;
  wire[31:0] instruction;
  wire[31:0] data;

  // 7-Segment Output:
  reg[3:0] segVal;
  HexTo7seg h27s(segVal, seg);
  // assign segVal = instructionAddress[3:0];
  always @(posedge clk_prescaler[10]) begin
    an = {an[0], an[3:1]}; // rotate
    case(an)

      // 4'b1110: segVal = stack[8'hf7][3:0];
      // 4'b1101: segVal = stack[8'hf7][7:4];
      // 4'b1011: segVal = stack[8'hf6][3:0];
      // 4'b0111: segVal = stack[8'hf6][7:4];

      4'b1110: segVal = portA[3:0];
      4'b1101: segVal = portA[7:4];
      4'b1011: segVal = 0;//ss.regFile.data[10][11:8];
      4'b0111: segVal = 0;//ss.regFile.data[10][15:12];

      // 4'b1110: segVal = ss.immediate[19:16];
      // 4'b1101: segVal = ss.immediate[23:20];
      // 4'b1011: segVal = ss.immediate[27:24];
      // 4'b0111: segVal = ss.immediate[31:28];

      default: segVal = 0;
    endcase
  end

  // Clock prescaling and counter:
  always @(posedge clk) clk_prescaler = clk_prescaler + 1;
  always @(posedge clk_prescaler[prescale_sel]) begin
    if(counter == cmp_reg) begin
      counter = 0;
      interrupt = 1;
    end
    else begin
      counter = counter + 1;
      interrupt = 0;
    end
  end

  // Data path:
  SingleCycle ss(interrupt, instruction, instructionAddress, data_rw, dataAddress, data);

  // Memory mapping:
  assign romEn = ~(instructionAddress[31] | instructionAddress[30]); // 0x00000000 - 0x30000000
                                                                  // io 0x40000000 - 0x7fffffff
  assign ledEn = dataAddress == 32'h40000000; // LEDs
  assign ramEn = dataAddress[31] & ~stackEn;                         // 0x80000000 - 0xfffffeff
  assign stackEn = dataAddress[31:8] == 30'hffffff;                  // 0xffffff00 - 0xffffffff

  // Access programme memory:
  assign instruction = {
    rom[instructionAddress], 
    rom[instructionAddress+1], 
    rom[instructionAddress+2], 
    rom[instructionAddress+3]
  };

  // Data read:
  assign data = data_rw ? 32'hzzzzzzzz : // writing
                stackEn ? {stack[dataAddress[7:0]], stack[dataAddress[7:0]+1], stack[dataAddress[7:0]+2], stack[dataAddress[7:0]+3]} :
                ramEn   ? {ram[dataAddress[7:0]], ram[dataAddress[7:0]+1], ram[dataAddress[7:0]+2], ram[dataAddress[7:0]+3]} :
                ledEn   ? {24'h000000, portA} :
                          32'h00000000;

  // Data write:
  always @(posedge interrupt)
    if(data_rw)
      if(ramEn)
        {ram[dataAddress[7:0]], ram[dataAddress[7:0]+1], ram[dataAddress[7:0]+2], ram[dataAddress[7:0]+3]} = data;
      else if(stackEn)
        {stack[dataAddress[7:0]], stack[dataAddress[7:0]+1], stack[dataAddress[7:0]+2], stack[dataAddress[7:0]+3]} = data;
      else if(ledEn)
        portA = data[7:0];

  // I/O:
  assign led[5:0] = portA[5:0];
  assign led[6] = interrupt;
  assign led[7] = ledEn;
  assign led[8] = instructionAddress == 32'h7c;

  initial begin
    an = 4'b1110;
    clk_prescaler = 16'h0000;
    counter = 16'h0000;
    prescale_sel = 15;
    cmp_reg = 10;
    portA = 6'b000000;
    

    //////////     Load test programme     ////////

    // Counter:
    // rom[32'h00000000] = 8'h40; rom[32'h00000001] = 8'h00; rom[32'h00000002] = 8'h03; rom[32'h00000003] = 8'h37; // 0x		lui x6 262144
    // rom[32'h00000004] = 8'h00; rom[32'h00000005] = 8'h00; rom[32'h00000006] = 8'h02; rom[32'h00000007] = 8'h93; // 0x		addi x5 x0 0
    // rom[32'h00000008] = 8'h00; rom[32'h00000009] = 8'h53; rom[32'h0000000a] = 8'h00; rom[32'h0000000b] = 8'h23; // 0x		sb x5 0(x6)
    // rom[32'h0000000c] = 8'h00; rom[32'h0000000d] = 8'h12; rom[32'h0000000e] = 8'h82; rom[32'h0000000f] = 8'h93; // 0x		addi x5 x5 1
    // rom[32'h00000010] = 8'hFF; rom[32'h00000011] = 8'h9F; rom[32'h00000012] = 8'hF0; rom[32'h00000013] = 8'hEF; // 0x		jal x1 -8

    // Fibonacci:
    rom[32'h00000000] = 8'h00; rom[32'h1] = 8'h00; rom[32'h2] = 8'h05; rom[32'h3] = 8'h93; // addi x11 x0 0
    rom[32'h00000004] = 8'h00; rom[32'h5] = 8'h10; rom[32'h6] = 8'h04; rom[32'h7] = 8'h13; // addi x8 x0 1
    rom[32'h00000008] = 8'h0F; rom[32'h9] = 8'hF0; rom[32'hA] = 8'h04; rom[32'hB] = 8'h93; // addi x9 x0 255
    rom[32'h0000000C] = 8'h40; rom[32'hD] = 8'h00; rom[32'hE] = 8'h02; rom[32'hF] = 8'hB7; // lui x5 262144
    rom[32'h00000010] = 8'h00; rom[32'h11] = 8'h02; rom[32'h12] = 8'h82; rom[32'h13] = 8'h93; // addi x5 x5 0
    rom[32'h00000014] = 8'h00; rom[32'h15] = 8'h15; rom[32'h16] = 8'h85; rom[32'h17] = 8'h93; // addi x11 x11 1
    rom[32'h00000018] = 8'h01; rom[32'h19] = 8'h40; rom[32'h1A] = 8'h00; rom[32'h1B] = 8'hEF; // jal x1 20
    rom[32'h0000001C] = 8'h00; rom[32'h1D] = 8'hA2; rom[32'h1E] = 8'h80; rom[32'h1F] = 8'h23; // sb x10 0(x5)
    rom[32'h00000020] = 8'hFE; rom[32'h21] = 8'h95; rom[32'h22] = 8'h4A; rom[32'h23] = 8'hE3; // blt x10 x9 -12
    rom[32'h00000024] = 8'h00; rom[32'h25] = 8'h00; rom[32'h26] = 8'h05; rom[32'h27] = 8'h93; // addi x11 x0 0
    rom[32'h00000028] = 8'hFE; rom[32'h29] = 8'hDF; rom[32'h2A] = 8'hF0; rom[32'h2B] = 8'h6F; // jal x0 -20
    rom[32'h0000002C] = 8'hFF; rom[32'h2D] = 8'h41; rom[32'h2E] = 8'h01; rom[32'h2F] = 8'h13; // addi x2 x2 -12
    rom[32'h00000030] = 8'h00; rom[32'h31] = 8'h11; rom[32'h32] = 8'h22; rom[32'h33] = 8'h23; // sw x1 4(x2)
    rom[32'h00000034] = 8'h00; rom[32'h35] = 8'hB1; rom[32'h36] = 8'h24; rom[32'h37] = 8'h23; // sw x11 8(x2)
    rom[32'h00000038] = 8'h00; rom[32'h39] = 8'h91; rom[32'h3A] = 8'h26; rom[32'h3B] = 8'h23; // sw x9 12(x2)
    rom[32'h0000003C] = 8'h00; rom[32'h3D] = 8'h05; rom[32'h3E] = 8'h96; rom[32'h3F] = 8'h63; // bne x11 x0 12
    rom[32'h00000040] = 8'h00; rom[32'h41] = 8'h00; rom[32'h42] = 8'h05; rom[32'h43] = 8'h13; // addi x10 x0 0
    rom[32'h00000044] = 8'h02; rom[32'h45] = 8'h80; rom[32'h46] = 8'h00; rom[32'h47] = 8'h6F; // jal x0 40
    rom[32'h00000048] = 8'h00; rom[32'h49] = 8'h85; rom[32'h4A] = 8'h96; rom[32'h4B] = 8'h63; // bne x11 x8 12
    rom[32'h0000004C] = 8'h00; rom[32'h4D] = 8'h10; rom[32'h4E] = 8'h05; rom[32'h4F] = 8'h13; // addi x10 x0 1
    rom[32'h00000050] = 8'h01; rom[32'h51] = 8'hC0; rom[32'h52] = 8'h00; rom[32'h53] = 8'h6F; // jal x0 28
    rom[32'h00000054] = 8'hFF; rom[32'h55] = 8'hF5; rom[32'h56] = 8'h85; rom[32'h57] = 8'h93; // addi x11 x11 -1
    rom[32'h00000058] = 8'hFD; rom[32'h59] = 8'h5F; rom[32'h5A] = 8'hF0; rom[32'h5B] = 8'hEF; // jal x1 -44
    rom[32'h0000005C] = 8'h00; rom[32'h5D] = 8'hA0; rom[32'h5E] = 8'h04; rom[32'h5F] = 8'hB3; // add x9 x0 x10
    rom[32'h00000060] = 8'hFF; rom[32'h61] = 8'hF5; rom[32'h62] = 8'h85; rom[32'h63] = 8'h93; // addi x11 x11 -1
    rom[32'h00000064] = 8'hFC; rom[32'h65] = 8'h9F; rom[32'h66] = 8'hF0; rom[32'h67] = 8'hEF; // jal x1 -56
    rom[32'h00000068] = 8'h00; rom[32'h69] = 8'h95; rom[32'h6A] = 8'h05; rom[32'h6B] = 8'h33; // add x10 x10 x9
    rom[32'h0000006C] = 8'h00; rom[32'h6D] = 8'h41; rom[32'h6E] = 8'h20; rom[32'h6F] = 8'h83; // lw x1 4(x2)
    rom[32'h00000070] = 8'h00; rom[32'h71] = 8'h81; rom[32'h72] = 8'h25; rom[32'h73] = 8'h83; // lw x11 8(x2)
    rom[32'h00000074] = 8'h00; rom[32'h75] = 8'hC1; rom[32'h76] = 8'h24; rom[32'h77] = 8'h83; // lw x9 12(x2)
    rom[32'h00000078] = 8'h00; rom[32'h79] = 8'hC1; rom[32'h7A] = 8'h01; rom[32'h7B] = 8'h13; // addi x2 x2 12
    rom[32'h0000007C] = 8'h00; rom[32'h7D] = 8'h00; rom[32'h7E] = 8'h80; rom[32'h7F] = 8'h67; // jalr x0 x1 0
  end

endmodule