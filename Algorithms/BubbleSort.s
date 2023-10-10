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

addi x29, x0, 9     # n - 1 = 9

addi x5, x0, 0      # i = 0
bge x5, x29, 68     # i < 9 ?
addi x6, x0, 0      # j = 0
sub x31, x29, x5    # 9 - i
bge x6, x31, 48     # j >= 9 - i ?
add x7, x2, x6      # x7 = sp + j
lw x18, 0(x7)       # arr[j]
lw x19, 1(x7)       # arr[j + 1]
bge x19, x18, 20    # arr[j + 1] >= arr[j] ?
add x28, x0, x18    # temp = arr[j]
add x18, x0, x19    # arr[j] = arr[j + 1]
sw x18, 0(x7)       # store arr[j]
sw x28, 1(x7)       # store temp in arr[j + 1]
addi x6, x6, 1      # j++
sub x30, x29, x5    # 9 - i
blt x6, x30, -40    # j < 9 - i ?
addi x5, x5, 1      # i++
blt x5, x29, -60    # i < 9 ?

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