addi x6, x0, 1      # Guarda el valor 1 en el registro x6
csrrw x18, 0, x6    # Carga al csr 0 el valor en x6, y viceversa
csrrsi x19, 0, 4    # Activa el bit 2 del csr 0
csrrsi x20, 0, 16   # Activa el bit 4 del csr 0
csrrci x21, 0, 16   # Limpia el bit 4 del csr 0
csrrci x22, 0, 4    # Limpia el bit 2 del csr 0
csrrci x23, 0, 1    # Limpia el bit 0 del csr 0