addi x2, x0, 256    # Guarda el valor 256 en el stack pointer
addi x6, x0, 324    # Guarda el valor 324 en el registro x6
addi x7, x6, -400   # 324 - 400 = -76
sb x6, 0(x2)        # Guarda los 8 LSBs de x6 en la dir. sp
sb x7, 1(x2)        # Guarda los 8 LSBs de x7 en la dir. sp + 1
lw x6, 0(x2)        # Carga el valor en la direción sp sobre x6
lw x7, 1(x2)        # Carga el valor en la dir. sp + 1 sobre x7
slt x18, x6, x7     # x18 = (68 < 180) ? 1 : 0