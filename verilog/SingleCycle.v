`include "ALUFull.v"
`include "ALUControl.v"
`include "Control.v"
`include "BranchLogic.v"
`include "ImmediateDecoder.v"
`include "RegisterFile.v"

module SingleCycle
#(parameter XLEN = 32)
(
  input clk,
  input[31:0] progMemData,
  output[XLEN-1:0] progMemAddress,
  output ram_rw,
  output[XLEN-1:0] ramAddress,
  inout[XLEN-1:0] ramData
);

  /*********************************/
  /* ---------- Stage 1 ---------- */
  /*********************************/

  reg[31:0] pc;
  wire[31:0] instruction;
  wire[11:0] control;
  wire[XLEN-1:0] immediate;
  wire[XLEN-1:0] pc4;
  wire[XLEN-1:0] nextPC;
  wire[XLEN-1:0] pcSrcVal;

  // Components:
  Control con(instruction, control);
  ImmediateDecoder #(.XLEN(XLEN)) immDec(instruction, immediate);

  // Continuous assignment:
  assign pc4 = pc + 4;
  assign progMemAddress = pc;
  assign instruction = progMemData;

  // Load next instruction on rising edge of the clock:
  always @(posedge clk) begin
    pc <= nextPC;
  end

  // Start programme at address 0x00000000:
  initial pc = 32'h00000000;

  /*********************************/
  /* ---------- Stage 2 ---------- */
  /*********************************/

  // ALU wires:
  wire[XLEN-1:0] alu_a, alu_b, alu_result;
  wire[3:0] alu_op;
  wire[3:0] alu_status;

  // Register wires:
  wire[XLEN-1:0] rs1_val, rs2_val;
  reg[XLEN-1:0] rd_val;

  // RAM wires:
  wire[XLEN-1:0] store_val;

  // Instruction components:
  wire[6:0] opcode;
  wire[2:0] funct3;
  wire funct7_5;
  wire[4:0] rs1, rs2, rd;

  // Control signals:
  wire[1:0] branch;
  wire write_rd, pc_src, pc_load;
  wire[1:0] rd_src, alu_src, alu_ctrl;

  // Control decode:
  assign branch   = control[`BRANCH_BITS];
  assign alu_src  = control[`ALU_SRC_BITS];
  assign ram_rw   = control[`RAM_RW_BITS];
  assign write_rd = control[`WRITE_RD_BITS];
  assign pc_src   = control[`PC_SRC_BITS];
  assign rd_src   = control[`RD_SRC_BITS];
  assign alu_ctrl = control[`ALU_CTRL_BITS];

  // Components:
  ALUFull #(.XLEN(XLEN)) alu(alu_a, alu_b, alu_op, alu_status, alu_result);
  ALUControl aluControl(alu_ctrl, funct3, funct7_5, alu_op);
  RegisterFile #(.RLEN(16),.XLEN(XLEN)) regFile(clk, write_rd, rd, rs1, rs2, rd_val, rs1_val, rs2_val);
  BranchLogic branchLogic(alu_status, branch, funct3, pc_load);

  // Instruction Decode:
  assign opcode   = instruction[6:0];
	assign funct3   = instruction[14:12];
	assign funct7_5 = instruction[30];
  assign rs1      = instruction[19:15];
  assign rs2      = instruction[24:20];
  assign rd       = instruction[11:7];

  // MUX Control:
  assign nextPC   = pc_load    ? immediate + pcSrcVal : pc4;
  assign pcSrcVal = pc_src     ? pc                   : rs1_val;
  assign alu_a    = alu_src[0] ? pc                   : rs1_val;
  assign alu_b    = alu_src[1] ? immediate            : rs2_val;
  always @(*)
    case(rd_src)
      2'b00: rd_val <= pc4;
      2'b01: rd_val <= ramData;
      2'b10: rd_val <= alu_result;
      2'b11: rd_val <= immediate;
    endcase

  // Memory I/O:
  assign ramData = ram_rw ? store_val : {(XLEN){1'bz}};
  assign ramAddress = alu_result;
  assign store_val[7:0] = rs2_val[7:0];
  assign store_val[15:8] = funct3[1:0] == 2'b00 ? 8'h00 // store byte
                                                : rs2_val[15:8]; // store half word or word
  assign store_val[XLEN-1:16] = funct3[1:0] == 2'b10 ? rs2_val[XLEN-1:16] // store word
                                                     : {(XLEN-16){1'b0}}; // store half word or byte

endmodule