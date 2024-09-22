.ORIG x3000

    ; r0    Input digit
    ; r1    Temporary values

LoopStart                   ; while (true) {
    in                      ;     r0 = getchar()

    ld r1, NegAsciiZero
    add r0, r0, r1          ;     if (r0 < '0')
    BRn Break               ;         break
    add r1, r0, #-7         ;     if (r0 > '6')
    BRzp Break              ;         break

    add r0, r0, r0          ;     r0 *= 16
    add r0, r0, r0
    add r0, r0, r0
    add r0, r0, r0

    lea r1, DayNames
    add r0, r0, r1          ;     r0 += &memory[DayNames]

    puts                    ;     print(*r0)

    BR LoopStart            ; }

Break
    HALT

NegAsciiZero .FILL #-48     ; -'0'

DayNames    ; Each name is padded to be 16 words (32 bytes)
    .STRINGZ "Sunday"
    .BLKW 9
    .STRINGZ "Monday"
    .BLKW 9
    .STRINGZ "Tuesday"
    .BLKW 8
    .STRINGZ "Wednesday"
    .BLKW 6
    .STRINGZ "Thursday"
    .BLKW 7
    .STRINGZ "Friday"
    .BLKW 9
    .STRINGZ "Saturday"
    .BLKW 7

.END

