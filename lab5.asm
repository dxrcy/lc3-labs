.ORIG x3000

    ; r0    X
    ; r1    Y
    ; r2    Address of result values (without offset)

    ; Multiply:
    ; r0    Decrements to zero
    ; r1    (Does not modify)
    ; r2    (Does not modify)
    ; r3    Product value
    ; r4    abs(X)

    ; Divide:
    ; r0    Modulus value
    ; r1    (Does not modify)
    ; r2    (Does not modify)
    ; r3    Quotient value
    ; r4    -Y
    ; r5    Discarded calculation value

    ; Load the input values
    ldi r0, AddrX       ; Load into r0 the value at x3100
    ldi r1, AddrY       ; Load into r1 the value at x3101

    ld r2, AddrResults  ; Set r2 to the address of the results (x3102)

    ; Calculate product
    JSR Multiply        ; Modifies r0 and r1
    str r3, r2, #0      ; Store the product at (x3102 + 0)

    ; Load the input values again
    ldi r0, AddrX
    ldi r1, AddrY

    ; Calculate quotient and modulus (remainder)
    JSR Divide          ; Modifies r0
    str r3, r2, #1      ; Store the quotient at (x3102 + 1)
    str r0, r2, #2      ; Store the modulus at (x3102 + 2)

    HALT

; ---------------------------------------------------------
Multiply                    ; Multiply() {
    and r3, r3, #0          ;     r3 = 0
    and r4, r4, #0          ;     r4 = false
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
    add r1, r1, #0          ;         if (r1 <= 0)
    BRnz MultiplyEnd        ;             break
                            ;
    add r3, r3, r0          ;         r3 += r0
    add r1, r1, #-1         ;         --r1
                            ;
    BR MultiplyStart        ;     }
MultiplyEnd                 ;
                            ;
    add r4, r4, #0          ;     if (r4 == true) {
    BRzp MultiplyAfterNegative
    not r3, r3              ;         r3 = -r3
    add r3, r3, #1          ;
MultiplyAfterNegative       ;     }
    RET                     ; }

; ---------------------------------------------------------
Divide                      ; Divide() {
    and r3, r3, #0          ;     r3 = 0
    and r4, r4, #0          ;     r4 = 0
                            ;
    add r0, r0, #0          ;     if (r0 < 0)
    BRn DivideCheckFailed   ;        || r1 <= 0) {
    add r1, r1, #0          ;
    BRnz DivideCheckFailed  ;
    BRp DivideAfterCheck    ;
DivideCheckFailed           ;
    and r0, r0, #0          ;         r0 = 0
    RET                     ;         return
DivideAfterCheck            ;     }
                            ;
    not r4, r1              ;     r4 = -r1
    add r4, r4, #1          ;
                            ;
DivideStart                 ;     loop {
    add r5, r0, r4          ;         if (r0 <= r1)
    BRn DivideEnd           ;            break
                            ;
    add r0, r0, r4          ;         r0 -= r1
    add r3, r3, #1          ;         ++r3
                            ;
    BR DivideStart          ;    }
DivideEnd                   ;
    RET                     ; }

AddrX       .FILL x3100     ; X is stored at x3100
AddrY       .FILL x3101     ; Y is stored at x3101
AddrResults .FILL x3102     ; The result values start at address x3102

.END

