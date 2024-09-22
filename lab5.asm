.ORIG x3000

    ; r0    X
    ; r1    Y
    ; r2    Address of result values (without offset)

    ; Load the input values
    ldi r0, AddrX       ; Load into r0 the value at x3100
    ldi r1, AddrY       ; Load into r1 the value at x3101

    ld r2, AddrResults  ; Set r2 to the address of the results (x3102)

    and r3, r3, #0
    and r4, r4, #0

    add r3, r0, #0
    add r4, r1, #0

    REG
    JSR Multiply

    str r5, r2, #0

    ; REG
    DEBUG

    HALT

Multiply
    and r5, r5, #0
    and r6, r6, #0
    add r3, r3, #0
    BRzp MultiplySkipPositive
    not r3, r3
    add r3, r3, #1
    not r6, r6
MultiplySkipPositive
    add r4, r4, #0
    BRzp MultiplyStart
    not r4, r4
    add r4, r4, #1
    not r6, r6
MultiplyStart
    add r4, r4, #0
    BRnz MultiplyEnd
    add r5, r5, r3
    add r4, r4, #-1
    BR MultiplyStart
MultiplyEnd
    add r6, r6, #0
    BRzp MultiplySkipNegative
    not r5, r5
    add r5, r5, #1
MultiplySkipNegative
    RET

AddrX       .FILL x3100     ; X is stored at x3100
AddrY       .FILL x3101     ; Y is stored at x3101
AddrResults .FILL x3102     ; The result values start at address x3102

.END

