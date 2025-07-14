`include "SingleCycle.v"

module SingleCycle_tb;

  reg clk;

  // RAM:
  reg[31:0] ram[1023:0];
  wire[31:0] ramAddress;
  wire[31:0] ramData;
  wire ram_rw;

  // 1k words of programme memory (4kB):
  reg[31:0] progMem[1023:0];
  wire[31:0] progMemAddress;
  wire[31:0] progMemData;
  reg[319:0] assembly[1023:0]; // for storing assembly instructions for output
  wire[319:0] assemblyInstruction; // the current assembly instruction

  // Datapath:
  SingleCycle ss(clk, progMemData, progMemAddress, ram_rw, ramAddress, ramData);

  // Memory:
  assign progMemData = progMem[progMemAddress];
  assign assemblyInstruction = assembly[progMemAddress];
  assign ramData = ram_rw ? {(32){1'bz}} : ram[ramAddress];
  always @(posedge clk) if(ram_rw) ram[ramAddress] = ramData;

  // Test:
  integer i; // Loop counter.
  localparam reg1 = 0, reg2 = 1, reg3 = 2, reg4 = 3, reg5 = 4; // Registers to display during test.
  wire signed [31:0] reg1_val, reg2_val, reg3_val, reg4_val, reg5_val;

  assign reg1_val = ss.regFile.data[reg1];
  assign reg2_val = ss.regFile.data[reg2];
  assign reg3_val = ss.regFile.data[reg3];
  assign reg4_val = ss.regFile.data[reg4];
  assign reg5_val = ss.regFile.data[reg5];

  initial begin

    // Initialise register test values:
    // 1 = 123;

    // Load test programme:
    progMem[32'h00000000] <= 32'h0C300093; assembly[32'h00000000] <= "li   x1 195";
    progMem[32'h00000004] <= 32'h0AA00113; assembly[32'h00000004] <= "li   x2 170";
    progMem[32'h00000008] <= 32'h0C310193; assembly[32'h00000008] <= "addi x3 x2 195 # x3 = 365";
    progMem[32'h0000000C] <= 32'h0C317213; assembly[32'h0000000C] <= "andi x4 x2 195 # x4 = 130";
    progMem[32'h00000010] <= 32'h0C316193; assembly[32'h00000010] <= "ori  x3 x2 195 # x3 = 235";
    progMem[32'h00000014] <= 32'h0C314213; assembly[32'h00000014] <= "xori x4 x2 195 # x4 = 105";
    progMem[32'h00000018] <= 32'h0AA0A193; assembly[32'h00000018] <= "slti x3 x1 170 # x3 = 0";
    progMem[32'h0000001C] <= 32'h0C312213; assembly[32'h0000001C] <= "slti x4 x2 195 # x4 = 1";
    progMem[32'h00000020] <= 32'h0C30A213; assembly[32'h00000020] <= "slti x4 x1 195 # x4 = 0";
    progMem[32'h00000024] <= 32'h001101B3; assembly[32'h00000024] <= "add x3 x2 x1 # x3 = 365";
    progMem[32'h00000028] <= 32'h40208233; assembly[32'h00000028] <= "sub x4 x1 x2 # x4 = 25";
    progMem[32'h0000002C] <= 32'h401101B3; assembly[32'h0000002C] <= "sub x3 x2 x1 # x3 = -25";
    progMem[32'h00000030] <= 32'h00117233; assembly[32'h00000030] <= "and x4 x2 x1 # x4 = 130";
    progMem[32'h00000034] <= 32'h001161B3; assembly[32'h00000034] <= "or x3 x2 x1  # x3 = 235";
    progMem[32'h00000038] <= 32'h00114233; assembly[32'h00000038] <= "xor x4 x2 x1 # x4 = 105";
    progMem[32'h0000003C] <= 32'h0020A1B3; assembly[32'h0000003C] <= "slt x3 x1 x2 # x3 = 0";
    progMem[32'h00000040] <= 32'h00112233; assembly[32'h00000040] <= "slt x4 x2 x1 # x4 = 1";
    progMem[32'h00000044] <= 32'h0010A233; assembly[32'h00000044] <= "slt x4 x1 x1 # x4 = 0";
    progMem[32'h00000048] <= 32'h01000237; assembly[32'h00000048] <= "lui x4 4096 # x4 = 16.7M";
    progMem[32'h0000004C] <= 32'h00400093; assembly[32'h0000004C] <= "li x1 4";
    progMem[32'h00000050] <= 32'h0040A423; assembly[32'h00000050] <= "sw x4 8(x1) # RAM[0xC] = 16.7M";
    progMem[32'h00000054] <= 32'h0080A183; assembly[32'h00000054] <= "lw x3 8(x1) # x3 = 16.7M";
    progMem[32'h00000058] <= 32'h00008097; assembly[32'h00000058] <= "auipc x1 8 # x1 = 0x00008058";
    progMem[32'h0000005C] <= 32'h014000EF; assembly[32'h0000005C] <= "jal x1 20 # pc = 0x70; ra = pc+4";
    progMem[32'h00000060] <= 32'h07B00093; assembly[32'h00000060] <= "addi x1 x0 123 # li x1 123";
    progMem[32'h00000064] <= 32'h07B00113; assembly[32'h00000064] <= "addi x2 x0 123 # li x2 123";
    progMem[32'h00000068] <= 32'h00209663; assembly[32'h00000068] <= "bne x1 x2 12 # don't branch";
    progMem[32'h0000006C] <= 32'h00208463; assembly[32'h0000006C] <= "beq x1 x2 8 # pc = 0x74";
    progMem[32'h00000070] <= 32'hFF1FF26F; assembly[32'h00000070] <= "jal x4 -16 # pc = 0x60; x1 = pc+4";
    progMem[32'h00000074] <= 32'h00100863; assembly[32'h00000074] <= "beq x0 x1 16 # don't branch";
    progMem[32'h00000078] <= 32'h00101663; assembly[32'h00000078] <= "bne x0 x1 12 # pc = 0x84";
    progMem[32'h0000007C] <= 32'h00225863; assembly[32'h0000007C] <= "bge x4 x2 16 # don't branch";
    progMem[32'h00000080] <= 32'h00415663; assembly[32'h00000080] <= "bge x2 x4 12 # pc = 0x8c";
    progMem[32'h00000084] <= 32'hFE414CE3; assembly[32'h00000084] <= "blt x2 x4 -8 # don't branch";
    progMem[32'h00000088] <= 32'hFE224AE3; assembly[32'h00000088] <= "blt x4 x2 -12 # pc = 0x7c";
    progMem[32'h0000008C] <= 32'h00300113; assembly[32'h0000008C] <= "addi x2 x0 3 ";
    progMem[32'h00000090] <= 32'h002091B3; assembly[32'h00000090] <= "sll x3 x1 x2 # x3 = 3d8";
    progMem[32'h00000094] <= 32'h00219093; assembly[32'h00000094] <= "slli x1 x3 2 # x1 = f60";
    progMem[32'h00000098] <= 32'h0021D0B3; assembly[32'h00000098] <= "srl x1 x3 x2 # x1 = 7b";
    progMem[32'h0000009C] <= 32'h4020D1B3; assembly[32'h0000009C] <= "sra x3 x1 x2 # x3 = f";
    progMem[32'h000000A0] <= 32'h00425093; assembly[32'h000000A0] <= "srli x1 x4 4 # x1 = 7";
    progMem[32'h000000A4] <= 32'h40225193; assembly[32'h000000A4] <= "srai x3 x4 2 # x3 = 1d";
    progMem[32'h000000A8] <= 32'h004130B3; assembly[32'h000000A8] <= "sltu x1 x2 x4  # x1 = 1";
    progMem[32'h000000AC] <= 32'h002230B3; assembly[32'h000000AC] <= "sltu x1 x4 x2  # x1 = 0";
    progMem[32'h000000B0] <= 32'h00A13193; assembly[32'h000000B0] <= "sltiu x3 x2 10 # x3 = 1";
    progMem[32'h000000B4] <= 32'h00A23193; assembly[32'h000000B4] <= "sltiu x3 x4 10 # x3 = 0";
    progMem[32'h000000B8] <= 32'h00000193; assembly[32'h000000B8] <= "addi x3 x0 0";
    progMem[32'h000000BC] <= 32'hFFF00213; assembly[32'h000000BC] <= "addi x4 x0 -1";
    progMem[32'h000000C0] <= 32'h0041F463; assembly[32'h000000C0] <= "bgeu x3 x4 8 # don't branch then pc = C8";
    progMem[32'h000000C4] <= 32'h0041E463; assembly[32'h000000C4] <= "bltu x3 x4 8 # pc = CC";
    progMem[32'h000000C8] <= 32'h010000EF; assembly[32'h000000C8] <= "jal x1 16 # pc = D8";
    progMem[32'h000000CC] <= 32'h00000213; assembly[32'h000000CC] <= "addi x4 x0 0";
    progMem[32'h000000D0] <= 32'hFFF00193; assembly[32'h000000D0] <= "addi x3 x0 -1";
    progMem[32'h000000D4] <= 32'hFEDFF0EF; assembly[32'h000000D4] <= "jal x1 -20 # pc = C0";
    progMem[32'h000000D8] <= 32'h00300123; assembly[32'h000000D8] <= "sb x3 2(x0) # M[2] = FF";
    progMem[32'h000000DC] <= 32'h00301223; assembly[32'h000000DC] <= "sh x3 4(x0) # M[4:5] = FFFF";
    progMem[32'h000000E0] <= 32'h000000E7; assembly[32'h000000E0] <= "jalr x1 x0 0 # pc = 0; x1 = DC";
    progMem[32'h000000E4] <= 32'h00000013; assembly[32'h000000E4] <= "addi x0 x0 0";

    // Debug output:
    $display("Assembly,PC,Instruction,x%0d,x%0d,x%0d,x%0d,x%0d,rs1,rs2,rd,opcode,funct3,funct7_5,write_rd,alu_src,ram_rw,rd_src,imm;", reg1, reg2, reg3, reg4, reg5);
    $monitor("%s,0x%h,0x%h,%h,%h,%h,%h,%h,%d,%d,%d,%b,%b,%b,%b,%b,%b,%d,%d,;,%h, %b", 
        assemblyInstruction,
        ss.pc,
        ss.instruction, 
        reg1_val, reg2_val, reg3_val, reg4_val, reg5_val,
        ss.rs1, ss.rs2, ss.rd, ss.opcode, ss.funct3, ss.funct7_5, ss.write_rd, ss.alu_src, ss.ram_rw, ss.rd_src, ss.immediate,
        ss.alu.result, ss.alu.op);

    // Execute test programme:
    for(i = 0; i < 60; i = i + 1) begin
      #1 clk = 0;
      #1 clk = 1;
    end

    #1
    for(i = 0; i < 20; i = i + 1) begin
      $display("RAM[%h] = %h", i, ram[i]);
    end
  end

endmodule