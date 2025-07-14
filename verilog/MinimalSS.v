`include "ALUFull.v"
`include "Control.v"
`include "ALUControl.v"

module MinimalSS(
  input clk,
  input[31:0] data,
  output[31:0] instruction_address,
  output ram_rw,
  output[31:0] ram_address,
  inout[31:0] ram_data
);

  reg[31:0] instruction; // TODO: wire
  wire[11:0] control;

  // ALU:
  reg[31:0] alu_a, alu_b; // TODO: wire
  wire[31:0] alu_result;
  wire[3:0] alu_op;
  wire[3:0] alu_status;

  // Instruction components:
  wire[6:0] opcode;
  wire[2:0] funct3;
  wire funct7_5;
  wire[4:0] rs1, rs2, rd;

  // Control signals:
  wire[1:0] branch;
  wire write_rd, pc_src, pc_load;
  wire[1:0] rd_src, alu_src, alu_ctrl;

  // Components:
  Control con(instruction, control) /* synthesis syn_keep=1 */;
  ALUFull aluFull(alu_a, alu_b, alu_op, alu_status, alu_result) /* synthesis syn_keep=1 */;
  ALUControl aluControl(alu_ctrl, funct3, funct7_5, alu_op) /* synthesis syn_keep=1 */;

  // Instruction Decode:
  assign opcode   = instruction[6:0];
	assign funct3   = instruction[14:12];
	assign funct7_5 = instruction[30];
  assign rs1      = instruction[19:15];
  assign rs2      = instruction[24:20];
  assign rd       = instruction[11:7];

  // Control decode:
  assign branch   = control[`BRANCH_BITS];
  assign alu_src  = control[`ALU_SRC_BITS];
  assign ram_rw   = control[`RAM_RW_BITS];
  assign write_rd = control[`WRITE_RD_BITS];
  assign pc_src   = control[`PC_SRC_BITS];
  assign rd_src   = control[`RD_SRC_BITS];
  assign alu_ctrl = control[`ALU_CTRL_BITS];

  // Test:
  initial begin
    instruction = 32'h001101B3; // add
    alu_a = 32'b100000;
    alu_b = 32'b000011;
  end

endmodule