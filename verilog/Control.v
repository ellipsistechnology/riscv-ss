`include "opcodes.v"

`define ALU_CTRL_BITS 10:9
`define BRANCH_BITS   8:7
`define ALU_SRC_BITS  6:5
`define RAM_RW_BITS   4
`define WRITE_RD_BITS 3
`define PC_SRC_BITS   2
`define RD_SRC_BITS   1:0

//                         alu_ctrl, branch, alu_src, ram_rw, write_rd, pc_src, rd_src
`define JUMP           12'b00________01______00_______0_______0_________0_______00______
`define BRANCH         12'b00________10______00_______0_______0_________0_______00______
`define REG2ALU        12'b00________00______00_______0_______0_________0_______00______
`define IMM2ALU        12'b00________00______10_______0_______0_________0_______00______
`define PC2ALU         12'b00________00______01_______0_______0_________0_______00______
`define MEM_READ       12'b00________00______00_______0_______0_________0_______00______
`define MEM_WRITE      12'b00________00______00_______1_______0_________0_______00______
`define WRITE_RD       12'b00________00______00_______0_______1_________0_______00______
`define PC_ADD_RS      12'b00________00______00_______0_______0_________0_______00______
`define PC_ADD_PC      12'b00________00______00_______0_______0_________1_______00______
`define PC2RD          12'b00________00______00_______0_______0_________0_______00______
`define MEM2RD         12'b00________00______00_______0_______0_________0_______01______
`define ALU2RD         12'b00________00______00_______0_______0_________0_______10______
`define IMM2RD         12'b00________00______00_______0_______0_________0_______11______
`define ALU_CTRL_FUNCT 12'b11________00______00_______0_______0_________0_______00______
`define ALU_CTRL_ADD   12'b01________00______00_______0_______0_________0_______00______
`define ALU_CTRL_SUB   12'b10________00______00_______0_______0_________0_______00______
`define NOP            12'b0

// RISC-V Instructions:

// Mnemonic	Opcode	Funct3	Funct7	Format	ALU Op

`define LOAD_OP 7'b0000011
// lb	      0000011	000	    	      I      	
// lbu	    0000011	100	    	      I      	
// lh	      0000011	001	    	      I      	
// lhu	    0000011	101	    	      I      	
// lw	      0000011	010	    	      I      	

`define FENCE_OP 7'b0001111
// fence	  0001111	000	    	      I      	

`define IMM_OP 7'b0010011
// addi	    0010011	000	    	      I      	add
// andi	    0010011	111	    	      I      	and
// ori	    0010011	110	    	      I      	or
// slli	    0010011	001	    0000000 I      	?
// slti	    0010011	010	    	      I      	sub
// sltiu	  0010011	011	    	      I      	sub
// srai	    0010011	101	    0100000	I      	?
// srli	    0010011	101	    0000000	I      	?
// xori	    0010011	100	    	      I      	xor

`define AUIPC_OP 7'b0010111
// auipc	  0010111			            U      	

`define STORE_OP 7'b0100011
// sb	      0100011	000	    	      S      	
// sh	      0100011	001	    	      S      	
// sw	      0100011	010	    	      S      	

`define DIR_OP 7'b0110011
// add	    0110011	000	    0000000	R      	add
// and	    0110011	111	    0000000	R      	and
// or	      0110011	110	    0000000	R      	or
// sll	    0110011	001	    0000000	R      	?
// slt	    0110011	010	    0000000	R      	sub
// sltu	    0110011	011	    0000000	R      	sub
// sra	    0110011	101	    0100000	R      	?
// srl	    0110011	101	    0000000	R      	?
// sub	    0110011	000	    0100000	R      	sub
// xor	    0110011	100	    0000000	R      	xor

`define LUI_OP 7'b0110111
// lui	    0110111			            U      	

`define BRANCH_OP 7'b1100011
// beq	    1100011	000	    	      B      	sub
// bgeu	    1100011	111	    	      B      	sub
// blt	    1100011	100	    	      B      	sub
// bltu	    1100011	110	    	      B      	sub
// bne	    1100011	001	    	      B      	sub
// bge	    1100011	101	    	      B      	sub

`define JALR_OP 7'b1100111
// jalr	    1100111	000	    	      I      	

`define JAL_OP 7'b1101111
// jal	    1101111			            J      	

`define SYS_OP 7'b1110011
// ebreak	  1110011	000	    	      I=000000000000
// ecall	  1110011	000	    	      I=000000000001

/**
 * Decodes the RISC-V instruction and produces the control signals.
 */
module Control(
	input[31:0] instruction,
	output reg[11:0] control // branch, alu_src, ram_rw, write_rd, pc_src, alu_src, rd_src, alu_ctrl
);

	wire[6:0] opcode;
	wire[2:0] funct3;
	wire funct7_5;

	assign opcode = instruction[6:0];
	assign funct3 = instruction[14:12];

	always @(opcode, funct3) begin
		case(opcode)
			`LOAD_OP:   control <= `MEM_READ | `IMM2ALU | `MEM2RD | `ALU_CTRL_ADD | `WRITE_RD;
			// `FENCE_OP: 
			`IMM_OP:    control <= `FUNCT3_addi == funct3 ? 
				`IMM2ALU | `ALU2RD | `WRITE_RD | `ALU_CTRL_ADD :
				`IMM2ALU | `ALU2RD | `WRITE_RD | `ALU_CTRL_FUNCT;
			`AUIPC_OP:  control <= `IMM2ALU | `PC2ALU | `ALU2RD | `ALU_CTRL_ADD | `WRITE_RD;
			`STORE_OP:  control <= `MEM_WRITE | `IMM2ALU | `ALU_CTRL_ADD;
			`DIR_OP:    control <= `REG2ALU | `ALU2RD | `WRITE_RD | `ALU_CTRL_FUNCT;
			`LUI_OP:    control <= `IMM2RD | `WRITE_RD;
			`BRANCH_OP: control <= `BRANCH | `ALU_CTRL_SUB |`PC_ADD_PC;
			`JALR_OP:   control <= `PC2RD | `JUMP | `PC_ADD_RS |`WRITE_RD;
			`JAL_OP:    control <= `PC2RD | `JUMP | `PC_ADD_PC |`WRITE_RD;
			// `SYS_OP: 
			default:    control <= `NOP;
		endcase
	end

endmodule