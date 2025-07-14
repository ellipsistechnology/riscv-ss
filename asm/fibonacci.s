    li  a1, 0  # fibonacci param
    li  s0, 1  # constant 1
    li  s1, 63 # max output for 6 bits
    li  t0, 0x40000000 # LED address
loop:
    addi a1, a1, 1    # Next number.
    jal  fibonacci
    sb   a0, 0(t0)    # output to LEDs
    blt  a0, s1, loop # if(a0 == 63) a1 = 0
    li   a1, 0
    j    loop

fibonacci:
    addi sp, sp, -12
    sw   ra, 4(sp)  # push ra
    sw   a1, 8(sp)  # push a1
    sw   s1, 12(sp) # push s1

    bne  a1, x0, fib_1 # if(a1 == 0) return 0
    li   a0, 0
    j    fib_end

fib_1:
    bne  a1, s0, fib_n # if(a1 == 1) return 1
    li   a0, 1
    j    fib_end

fib_n:
    addi a1, a1, -1 # fibonacci(a1-1)
    jal  fibonacci
    add  s1, x0, a0 # s1 = fibonacci(a1-1)
    addi a1, a1, -1 # fibonacci(a1-2)
    jal  fibonacci
    add  a0, a0, s1 # return fibonacci(a1-1) + fibonacci(a1-2)

fib_end:
    lw   ra, 4(sp)  # pop ra
    lw   a1, 8(sp)  # pop a1
    lw   s1, 12(sp) # pop s1
    addi sp, sp, 12
    jr   ra