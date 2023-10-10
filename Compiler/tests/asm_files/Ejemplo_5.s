addi x2, x0, 256    # Guarda el valor 256 en el stack pointer
addi x18, x0, -1000 # Guarda el valor -1000 en el registro x18
sw x18, 0(x2)       # Guarda el valor del registro x18 en el stack
lw x19, 0(x2)       # Carga los 32 bits del stack al registro x19
sh x19, 1(x2)       # Guarda los 16 LSBs de x19 en el stack
lh x20, 1(x2)       # Carga los 16 LSBs del stack al registro x20
sb x20, 2(x2)       # Guarda los 8 LSBs de x20 en el stack
lb x21, 2(x2)       # Carga los 8 LSBs del stack al registro x21