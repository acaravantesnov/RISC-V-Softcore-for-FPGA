lui x20, 1          # Direccion del GPIO
lui x21, 16         # 0x100000
addi x21, x21, -1   # 0xFFFF
sh x21, 2(x20)      # 16 LSBs de TRI en '1' (salidas)
lw x22, 1(x20)      # Carga de datosIn en x22
srli x22, x22, 16   # x22 >> 16
sw x22, 0(x20)      # Guardar el desplazamiento en datosOut
jal x23, -16        # Repetir proceso