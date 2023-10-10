addi x2, x0, 256    # Set stack pointer

addi x5, x0, 6
sw x5, 0(x2)
addi x5, x0, -2000
sw x5, 1(x2)
addi x5, x0, -2
sw x5, 2(x2)
addi x5, x0, 42
sw x5, 3(x2)
addi x5, x0, 3
sw x5, 4(x2)
addi x5, x0, -221
sw x5, 5(x2)
addi x5, x0, 7
sw x5, 6(x2)
addi x5, x0, 12
sw x5, 7(x2)
addi x5, x0, 9
sw x5, 8(x2)
addi x5, x0, 33
sw x5, 9(x2)

lui x18, 3          # Dirección del Timer
lui x19, 1          # Valor a alcanzar en la cuenta
sw x19, 1(x18)      # Guardar el valor en el Timer
addi x6, x0, 5      # En y En_Interrupt
sb x6, 0(x18)       # Inicio de la cuenta al cargar Enables

addi x20, x0, 10    # n = 10

addi x6, x0, 1      # i = 1
bge x6, x20, 96     # i < 10 ?
add x28, x2, x6     # dir(arr[i]) = sp + i
lw x5, 0(x28)       # key = arr[i]
addi x7, x6, -1     # j = i - 1
addi x23, x0, -1
slt x29, x23, x7    # -1 < j ?
add x30, x2, x7     # dir(arr[j]) = sp + j
lw x24, 0(x30)      # arr[j]
slt x31, x5, x24    # key < arr[j] ?
and x18, x29, x31   # j > -1 && arr[j] > key
addi x19, x0, 1
bne x18, x19, 40    # j > -1 && arr[j] > key ?
lw x22, 0(x30)      # arr[j]
sw x22, 1(x30)      # arr[j + 1] = arr[j]
addi x7, x7, -1     # j = j - 1
slt x29, x23, x7    # -1 < j ?
add x30, x2, x7     # dir(arr[j]) = sp + j
lw x24, 0(x30)      # arr[j]
slt x31, x5, x24    # key < arr[j] ?
and x18, x29, x31   # j > -1 && arr[j] > key
beq x18, x19, -32   # j > -1 && arr[j] > key ?
sw x5, 1(x30)       # arr[j + 1] = key
addi x6, x6, 1      # i++
blt x6, x20, -88    # i < 10 ?

lui x18, 3          # Dirección del Timer
lw x17, 0(x18)      # Carga del valor cuenta

lw x18, 0(x2)
lw x19, 1(x2)
lw x20, 2(x2)
lw x21, 3(x2)
lw x22, 4(x2)
lw x23, 5(x2)
lw x24, 6(x2)
lw x25, 7(x2)
lw x26, 8(x2)
lw x27, 9(x2)

lui x8, 1           # Direccion de los GPIO
lui x9, 3           # Direccion del Timer
lw x17, 0(x9)       # Carga del valor cuenta
lui x6, 21972       # 89997312
addi x6, x6, 2688   # 89997312 + 2688 = 90 * 10^6
sw x6, 1(x9)        # Registro ARR del Timer = 90 * 10^6
addi x18, x0, 5     # En y En_interrupt
addi x19, x0, 2     # Clear
addi x28, x0, -1    # 32 bits a '1'
sh x28, 2(x8)       # 16 LSBs de TRI a '1'

addi x27, x0, 10    # 10

addi x20, x0, 0     # i = 0
add x21, x2, x20    # sp + i
lw x7, 0(x21)       # Cargar numero
sw x7, 0(x8)        # Guardar numero a los GPIO
sb x18, 0(x9)       # Inicio cuenta del Timer
beq x0, x0, 0       # Bucle para esperar 2s
sb x19, 0(x9)       # Cuenta del Timer a cero
addi x20, x20, 1    # i++
blt x20, x27, -28   # i < 10 ?
beq x20, x27, -36   # i == 10 ?
