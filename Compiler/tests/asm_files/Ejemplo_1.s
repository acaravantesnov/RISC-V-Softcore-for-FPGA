addi x2, x0, 256    # Guarda el valor 256 en el stack pointer (x2)
addi x6, x0, -50    # Guarda el valor -50 en el registro temporal x6
addi x7, x0, 102    # Guarda el valor 102 en el registro temporal x7
add x18, x6, x7     # -50 + 102 = 52
sub x19, x6, x7     # -50 - 102 = -152
sub x20, x7, x6     # 102 - (-50) = 152
and x21, x6, x7     # -50 and 102 = 70
or x22, x6, x7      # -50 or 102 = -18
srl x23, x6, x7     # -50 >> 6 = 67108863
slli x24, x6, 12    # -50 << 12 = -204800
xor x25, x6, x7     # -50 xor 102 = -88
sw x18, 0(x2)       # Guardar en memoria los 8 valores desde el sp
sw x19, 1(x2)
sw x20, 2(x2)
sw x21, 3(x2)
sw x22, 4(x2)
sw x23, 5(x2)
sw x24, 6(x2)
sw x25, 7(x2)