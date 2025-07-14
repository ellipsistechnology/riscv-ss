# Test immediates:
addi x1, x1, -0x556
addi x1, x1, 0x555
lui  x1, 0xaaaaa
lui  x1, 0x55555
sw   x1, -0x556(x2)
sw   x1, 0x555(x2)
beq  x0, x0, end
beq  x0, x0, check_end
jal  x0, end
jal  x0, check_end

# Immediate Operations:
li   x1, 195
li   x2, 170
addi x3, x2, 195 # x3 = 365
andi x4, x2, 195 # x4 = 130
ori  x3, x2, 195 # x3 = 235
xori x4, x2, 195 # x4 = 105
slti x3, x1, 170 # x3 = 195 < 170 = 0
slti x4, x2, 195 # x4 = 170 < 195 = 1
slti x4, x1, 195 # x4 = 195 < 195 = 0


# Direct Operations:
add x3, x2, x1 # x3 = 365
sub x4, x1, x2 # x4 = 25
sub x3, x2, x1 # x3 = -25
and x4, x2, x1 # x4 = 130
or  x3, x2, x1 # x3 = 235
xor x4, x2, x1 # x4 = 105
slt x3, x1, x2 # x3 = 195 < 170 = 0
slt x4, x2, x1 # x4 = 170 < 195 = 1
slt x4, x1, x1 # x4 = 195 < 195 = 0

# Load Upper Immediate:
lui x4, 4096 # x4 = 16.7M

# Store/load to/from RAM:
li x1, 4
sw x4, 8(x1) # RAM[0xC] = 16.7M
lw x3, 8(x1) # x3 = 16.7M

# Add upper immediate to PC:
auipc x1, 8 # x1 = 0x00008058

# Jump and link and branch:
jal l1  # jump to l1; ra = pc+4

l2:
li x1, 123
li x2, 123
bne x1, x2, l3 # don't branch
beq x1, x2, l3 # pc = l3

l1:
jal x4, l2 # jump to l2; x1 = pc+4

l3:
beq x0, x1, l4 # don't branch
bne x0, x1, l4 # pc = l4

l5:
bge x4, x2, l6 # don't branch
bge x2, x4, l6 # pc = l6

l4:
blt x2, x4, l5 # don't branch
blt x4, x2, l5 # pc = l5

l6:
li   x2, 3
sll  x3, x1, x2 # x3 = 3d8
slli x1, x3, 2  # x1 = f60
srl  x1, x3, x2 # x1 = 7b
sra  x3, x1, x2 # x3 = f
srli x1, x4, 4  # x1 = 7
srai x3, x4, 2  # x3 = 1d

# Unsigned set less than:
sltu  x1, x2, x4 # x1 = 1
sltu  x1, x4, x2 # x1 = 0
sltiu x3, x2, 10 # x3 = 1
sltiu x3, x4, 10 # x3 = 0

# Unsigned branch:
li   x3, 0
li   x4, -1
check:
bgeu x3, x4, check_gte # don't branch then pc = C8
bltu x3, x4, check_lt  # pc = CC

check_gte:
jal check_end # pc = D8

check_lt:
li  x4, 0
li  x3, -1
jal check  # pc = C0

check_end:

# Store and load bytes and half words:
sb  x3, 2(x0) # M[2] = FF
sh  x3, 4(x0) # M[4:5] = FFFF

jalr x1, x0, 0 # pc = 0; x1 = DC
end:
nop
