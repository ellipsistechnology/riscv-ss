`include "ALUFull.v"
`include "opcodes.v"

`define ALU_NOP   2'b00
`define ALU_ADD   2'b01
`define ALU_SUB   2'b10
`define ALU_FUNCT 2'b11

module ALUControl(
  input[1:0] alu_ctrl,
  input[2:0] funct3,
  input funct7_5,
  output reg[3:0] alu_op
);

  always @(*)
    case(alu_ctrl)
      `ALU_FUNCT:
        case(funct3)
	        3'b000: alu_op <= {funct7_5, `SUM}; // add, sub
	        3'b001: alu_op <= `SLL; // sll
	        3'b010: alu_op <= `SLT; // slt, slti
	        3'b011: alu_op <= `SLTU; // sltu
	        3'b100: alu_op <= `XOR; // xor
	        3'b101: alu_op <= {funct7_5, `SR}; // srl, sra, srli, srai
	        3'b110: alu_op <= `OR;  // or
	        3'b111: alu_op <= `AND; // and
        endcase
			`ALU_ADD: alu_op <= `ADD; // memory operations
      `ALU_SUB: alu_op <= `SUB; // branch operations
      default: alu_op <= 0; // ALU not in use
    endcase

endmodule