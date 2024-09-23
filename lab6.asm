.ORIG x3000

    ; r0    X
    ; r1    Y
    ; r2    Address of result values (without offset) (after subroutine)

    ; Multiply:
    ; r0    Shifts left
    ; r1    (Does not modify)
    ; r2    Discarded calculation value
    ; r3    Product value
    ; r4    sign(X)
    ; r5    Loop counter [14->0]
    ; r6    Bitmask, shifts left

    ; Load the input values
    ldi r0, AddrX       ; Load into r0 the value at x3100
    ldi r1, AddrY       ; Load into r1 the value at x3101

    ; Calculate product
    JSR Multiply1       ; Modifies r0 and r1

    ld r2, AddrResults  ; Set r2 to the address of the results (x3102)
    str r3, r2, #0      ; Store the product at (x3102 + 0)

    DEBUG
    HALT

; ---------------------------------------------------------
Multiply1                   ; Multiply1() {
    and r3, r3, #0          ;     r3 = 0
    and r4, r4, #0          ;     r4 = false
    and r5, r5, #0          ;     r5 = 14
    add r5, r5, #14         ;
    and r6, r6, #0          ;     r6 = 1
    add r6, r6, #1          ;
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
    add r1, r1, #0          ;         if (r5 < 0)
    BRnz MultiplyEnd        ;             break
                            ;
    and r2, r0, r6          ;         if (r0 & r6) {
    BRz MultiplyIfEnd       ;
    add r3, r3, r1          ;             r3 += r1
MultiplyIfEnd               ;         }
                            ;
    add r1, r1, r1          ;         r1 <<= 1
    add r6, r6, r6          ;         r6 <<= 1
    add r5, r5, #-1         ;         --r5
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

