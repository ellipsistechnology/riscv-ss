// Op Codes:
`define OC_add     0110011
`define OC_addi    0010011
`define OC_and     0110011
`define OC_andi    0010011
`define OC_auipc   0010111
`define OC_beq     1100011
`define OC_bgeu    1100011
`define OC_blt     1100011
`define OC_bltu    1100011
`define OC_bne     1100011
`define OC_ebreak  1110011
`define OC_ecall   1110011
`define OC_fence   0001111
`define OC_gbe     1100011
`define OC_jal     1101111
`define OC_jalr    1100111
`define OC_lb      0000011
`define OC_lbu     0000011
`define OC_lh      0000011
`define OC_lhu     0000011
`define OC_lui     0110111
`define OC_lw      0000011
`define OC_or      0110011
`define OC_ori     0010011
`define OC_sb      0100011
`define OC_sh      0100011
`define OC_sll     0110011
`define OC_slli    0010011
`define OC_slt     0110011
`define OC_slti    0010011
`define OC_sltiu   0010011
`define OC_sltu    0110011
`define OC_sra     0110011
`define OC_srai    0010011
`define OC_srl     0110011
`define OC_srli    0010011
`define OC_sub     0110011
`define OC_sw      0100011
`define OC_xor     0110011
`define OC_xori    0010011


// Funct3 Codes:
`define FUNCT3_add     3'b000
`define FUNCT3_addi    3'b000
`define FUNCT3_and     3'b111
`define FUNCT3_andi    3'b111
`define FUNCT3_auipc      
`define FUNCT3_beq     3'b000
`define FUNCT3_bgeu    3'b111
`define FUNCT3_blt     3'b100
`define FUNCT3_bltu    3'b110
`define FUNCT3_bne     3'b001
`define FUNCT3_ebreak  3'b000
`define FUNCT3_ecall   3'b000
`define FUNCT3_fence   3'b000
`define FUNCT3_gbe     3'b101
`define FUNCT3_jal        
`define FUNCT3_jalr    3'b000
`define FUNCT3_lb      3'b000
`define FUNCT3_lbu     3'b100
`define FUNCT3_lh      3'b001
`define FUNCT3_lhu     3'b101
`define FUNCT3_lui        
`define FUNCT3_lw      3'b010
`define FUNCT3_or      3'b110
`define FUNCT3_ori     3'b110
`define FUNCT3_sb      3'b000
`define FUNCT3_sh      3'b001
`define FUNCT3_sll     3'b001
`define FUNCT3_slli    3'b001
`define FUNCT3_slt     3'b010
`define FUNCT3_slti    3'b010
`define FUNCT3_sltiu   3'b011
`define FUNCT3_sltu    3'b011
`define FUNCT3_sra     3'b101
`define FUNCT3_srai    3'b101
`define FUNCT3_srl     3'b101
`define FUNCT3_srli    3'b101
`define FUNCT3_sub     3'b000
`define FUNCT3_sw      3'b010
`define FUNCT3_xor     3'b100
`define FUNCT3_xori    3'b100

// Funct7 Codes:
`define FUNCT7_add      0000000
`define FUNCT7_addi
`define FUNCT7_and      0000000
`define FUNCT7_andi
`define FUNCT7_auipc
`define FUNCT7_beq
`define FUNCT7_bgeu
`define FUNCT7_blt
`define FUNCT7_bltu
`define FUNCT7_bne
`define FUNCT7_ebreak
`define FUNCT7_ecall
`define FUNCT7_fence
`define FUNCT7_gbe
`define FUNCT7_jal
`define FUNCT7_jalr
`define FUNCT7_lb
`define FUNCT7_lbu
`define FUNCT7_lh
`define FUNCT7_lhu
`define FUNCT7_lui
`define FUNCT7_lw
`define FUNCT7_or       0000000
`define FUNCT7_ori
`define FUNCT7_sb
`define FUNCT7_sh
`define FUNCT7_sll      0000000
`define FUNCT7_slli     0000000
`define FUNCT7_slt      0000000
`define FUNCT7_slti
`define FUNCT7_sltiu
`define FUNCT7_sltu     0000000
`define FUNCT7_sra      0100000
`define FUNCT7_srai     0100000
`define FUNCT7_srl      0000000
`define FUNCT7_srli     0000000
`define FUNCT7_sub      0100000
`define FUNCT7_sw
`define FUNCT7_xor      0000000
`define FUNCT7_xori