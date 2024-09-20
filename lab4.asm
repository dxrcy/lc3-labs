.ORIG x3000

    ; r0    Loop counter
    ; r1    Variable a (also temp. loaded value)
    ; r2    Variable b
    ; r3    Temporary variable (a + b)

    getc                    ; i = getc()

    ld r1, NegAsciiZero
    add r0, r0, r1          ; i -= '0'

    and r1, r1, #0          ; a = 0
    and r2, r2, #0          ; b = 1
    add r2, r2, #1

Loop                        ; do {
    add r3, r1, r2          ;     temp = a + b
    add r2, r1, #0          ;     b = a
    add r1, r3, #0          ;     a = temp

    add r0, r0, #-1         ;     --i
    BRp Loop                ; } while (i > 0)

    sti r1, AddrResult      ; memory[AddrResult] = a

    HALT

NegAsciiZero    .FILL #-48  ; -'0'
AddrResult      .FILL x3100 ; Where to store the result

.END

