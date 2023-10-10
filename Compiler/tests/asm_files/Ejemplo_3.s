addi x18, x0, 80    # Guarda el valor 80 en el registro x18
addi x19, x0, 100   # Guarda el valor 100 en el registro x19
addi x18, x18, 1    # x18 = x18 + 1
bne x18, x19, -4    # x18 == x19 ?
addi x7, x0, 255    # Guarda el valor 255 en el registro x7
lui x20, 1          # Direccion del GPIO
sb x7, 2(x20)       # Los 8 LSBs de TRI del GPIO a '1'
sb x18, 0(x20)      # Guarda el valor final de x18 en los 8 LSBs del GPIO
lb x8, 0(x20)       # Carga en x8 los 8 LSBs de datosOut del GPIO