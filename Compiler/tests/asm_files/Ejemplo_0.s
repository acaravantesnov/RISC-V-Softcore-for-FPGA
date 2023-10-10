addi x20, x0, 42
sw x20, 42(x0)
lw x21, 42(x0)
add x22, x20, x21
sub x28, x22, x21
addi x24, x0, 200
sb x24, 77(x20)
addi x25, x0, 10
srl x23, x24, x25
addi x31, x0, 2
sra x18, x21, x31
sra x19, x24, x31
beq x21, x20, 8
addi x31, x0, 69
beq x21, x22, 12
addi x30, x0, -100
bge x31, x30, 12
addi x27, x0, 24
jalr x2, 8(x22)
slt x17, x25, x27
slt x17, x27, x25
sltiu x31, x30, 5
slti x31, x30, 5
addi x16, x0, 12
addi x15, x0, 5
xor x10, x15, x16
and x9, x15, x16
andi x8, x22, 327
xori x8, x22, 327
srli x7, x24, 10
bne x15, x16, 8
bgeu x19, x20, 8
blt x19, x20, 8
bltu x19, x20, 8
sw x7, 100(x0)
lb x5, 16(x2)
or x4, x30, x22
ori x3, x30, 84
sltu x13, x25, x24
lh x1, 200(x30)
sltu x2, x28, x21
srai x2, x27, 2
addi x7, x0, -13
sw x7, 70(x0)
lbu x6, 70(x0)
lhu x5, 282(x19)
sll x11, x18, x19
slli x12, x19, 12
sh x10, -77(x6)
lui x3, 77235
auipc x9, 1048575
jal x23, 16