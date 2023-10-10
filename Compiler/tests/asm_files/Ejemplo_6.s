lui x18, 3      # Direccion del Timer
lui x19, 24     # Valor a alcanzar = 0x18000
sw x19, 1(x18)  # Guarda el valor en registro ARR del Timer
addi x6, x0, 5  # En y En_interrupt
sb x6, 0(x18)   # Inicio de la cuenta
beq x0, x0, 0   # Bucle para detectar el final de la cuenta