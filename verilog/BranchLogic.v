`include "status.v"

`define JUMP_OP   2'b01
`define BRANCH_OP 2'b10

`define BRANCH_beq  3'b000
`define BRANCH_bne  3'b001
`define BRANCH_blt  3'b100
`define BRANCH_bge  3'b101
`define BRANCH_bltu 3'b110
`define BRANCH_bgeu 3'b111

/**
 * Determines if the PC should load from a calculated address or increment (PC + 4).
 *
 * status:  ALU status based on the result of a - b.
 * op:      Branch operation determined by the control module.
 * funct3:  Instruction funct3 code used to determine the branch condition.
 * pc_load: If true, indicates that the PC should load from the calculated next instruction address.
 * 
 * op codes:
 *   JUMP_OP: Unconditional jump (pc_load = 1).
 *   BRANCH_OP: Conditional branch based on ALU status.
 *     BRANCH_beq:  Z
 *     BRANCH_bge:  ~(Z ^ V)
 *     BRANCH_bgeu: ~C
 *     BRANCH_blt:  Z ^ V
 *     BRANCH_bltu: C
 *     BRANCH_bne:  ~Z
 * 
 * Note that the C status is set according to a < b in the ALU for subtract operations.
 */
module BranchLogic(
    input[3:0] status,
    input[1:0] op,
    input[2:0] funct3,
    output reg pc_load
);

always @(*)
    case(op)
        `JUMP_OP: pc_load <= 1; // Unconditional branch/jump.
        `BRANCH_OP: case(funct3)
            `BRANCH_beq:  pc_load <=  status[`Z_STATUS];
            `BRANCH_bge:  pc_load <= ~(status[`N_STATUS] ^ status[`V_STATUS]);
            `BRANCH_bgeu: pc_load <= ~status[`C_STATUS];
            `BRANCH_blt:  pc_load <=  status[`N_STATUS] ^ status[`V_STATUS]; 
            `BRANCH_bltu: pc_load <=  status[`C_STATUS];
            `BRANCH_bne:  pc_load <= ~status[`Z_STATUS];
        endcase
        default: pc_load <= 0; // Not a branch or jump.
    endcase

endmodule