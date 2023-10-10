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

addi x18, x0, 10    # n = 10
addi x19, x0, 9     # n - 1 = 9

addi x5, x0, 0      # i = 0
bge x5, x19, 88     # i >= 9 ?
addi x6, x5, 0      # minIndex = i
addi x7, x5, 1      # j = i + 1
bge x7, x18, 36     # j >= 10 ?
add x20, x2, x7     # dir(arr[j]) = sp + j
lw x21, 0(x20)      # arr[j]
add x22, x2, x6     # dir(arr[minIndex]) = sp + minIndex
lw x23, 0(x22)      # arr[minIndex]
bge x21, x23, 8     # arr[j] >= arr[minIndex] ?
addi x6, x0, x7     # minIndex = j
addi x7, x7, 1      # j++
blt x7, x18, -28    # j < 10 ?
beq x6, x5, 32      # minIndex == i ?
add x28, x2, x5     # dir(arr[i]) = sp + i
lw x24, 0(x28)      # arr[i]
addi x29, x24, 0    # temp = arr[i]
add x30, x2, x6     # dir(arr[minIndex]) = sp + minIndex
lw x25, 0(x30)      # arr[minIndex]
sw x25, 0(x28)      # arr[i] = arr[minIndex]
sw x29, 0(x30)      # arr[minIndex] = temp
addi x5, x5, 1      # i++
blt x5, x19, -80    # i < 9 ?

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