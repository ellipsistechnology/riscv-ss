    # Load LED address into t1:
    lui t1, 0x40000 # LED I/O address upper

    # Initialise count to 0:
    li  t0, 0x00  # for LED output

    # Counter:
count:
    sb   t0, 0(t1) # output to LEDs
    addi t0, t0, 1 # count++
    jal  count