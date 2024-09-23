.ORIG x3000

    ; r0    X
    ; r1    Y
    ; r6    Address of result values (without offset) (after subroutine)

    ; Multiply:
    ; r0    Shifts left
    ; r1    (Does not modify)
    ; r6    Loop counter [14->0]
    ; r3    Product value
    ; r4    sign(X)
    ; r2    Bitmask, shifts left
    ; r5    Discarded calculation value

    ; Load the input values
    ldi r0, AddrX       ; Load into r0 the value at x3100
    ldi r1, AddrY       ; Load into r1 the value at x3101

    ; Calculate product
    JSR Multiply1       ; Modifies r0 and r1

    ld r6, AddrResults  ; Set r6 to the address of the results (x3102)
    str r3, r6, #0      ; Store the product at (x3102 + 0)

    HALT

; ---------------------------------------------------------
Multiply1                   ; Multiply1() {
    and r3, r3, #0          ;     r3 = 0
    and r4, r4, #0          ;     r4 = false
    and r2, r2, #0          ;     r2 = 14
    add r2, r2, #14         ;
    and r5, r5, #0          ;     r5 = 1
    add r5, r5, #1          ;
                            ;
    add r0, r0, #0          ;     if (r0 < 0) {
    BRzp MultiplyAfterPositive
    not r0, r0              ;         r0 = -r0
    add r0, r0, #1          ;
    not r4, r4              ;         r4 = !r4
MultiplyAfterPositive       ;     }
                            ;
    add r1, r1, #0          ;     if (r1 < 0) {
    BRzp MultiplyStart      ;
    not r1, r1              ;         r1 = -r1
    add r1, r1, #1          ;
    not r4, r4              ;         r4 = !r4
                            ;     }
MultiplyStart               ;     loop {
    add r1, r1, #0          ;         if (r2 < 0)
    BRnz MultiplyEnd        ;             break
                            ;
    and r6, r0, r5          ;         if (r0 & r5) {
    BRz MultiplyIfEnd       ;
    add r3, r3, r1          ;             r3 += r1
MultiplyIfEnd               ;         }
                            ;
    add r1, r1, r1          ;         r1 <<= 1
    add r5, r5, r5          ;         r5 <<= 1
    add r2, r2, #-1         ;         --r2
    BR MultiplyStart        ;     }
MultiplyEnd                 ;
                            ;
    add r4, r4, #0          ;     if (r4 == true) {
    BRzp MultiplyAfterNegative
    not r3, r3              ;         r3 = -r3
    add r3, r3, #1          ;
MultiplyAfterNegative       ;     }
    RET                     ; }

AddrX       .FILL x3100     ; X is stored at x3100
AddrY       .FILL x3101     ; Y is stored at x3101
AddrResults .FILL x3102     ; The result values start at address x3102

.END

