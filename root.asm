; R0 return value
; R1 return value 1 - EXACT ROOT, 0 - root rounded down to nearest int is given
; R1 operand 1 (Base)
; R2 operand 2 (root)
; R3 Incrementer

; Calculates the nth root of any value by repeated exponent until a value is larger than the original value


.ORIG X4300
ST R1 saveR1root
ST R3 saveR3root
ST R4 saveR4root
ST R7 saveR7root

AND R0, R0, #0 ; Clears to 0
ADD R3, R1, #0 ; Copies R1 into R3

ADD R2, R2, #0 ; Check if Valid Root MUST BE POSITIVE
BRnz rootINVALID

AND R1, R1, #0 ; Clears R1
ADD R1, R1, #1 ; Sets R1 to 1

rootLoop
ADD R1, R1, #1 ; No point in checking root = 1, so we increment to 2 initially. 
LD R4 powSRroot
JSRR R4        ; Repeatedly checks R1^R2 until the result is GREATER THAN the value we were given.
NOT R0, R0
ADD R0, R0, #1 
ADD R0, R3, R0 ; Checks if greater than or equal by 2's complement addition and checking for zero or negative
BRz Exact      ; If 0 we found the exact value
BRn NegESCroot ; If negative, we found a value greater so the root must be one value lower
BR rootLoop    ; Repeatedly increases R1 by looping

rootINVALID
AND R1, R1, #0 ; Sets R0 to 1
ADD R1, R1, #1 ; 
BR ESCroot

NegESCroot
ADD R1, R1, #-1 ; Decrements R1 once because we overshot

ESCroot
ADD R0, R1, #0 ; Copies R1 value into R0
AND R1, R1, #0
ADD R1, R1, #2
rootExactRet
LD R3 saveR3root
LD R4 saveR4root
LD R7 saveR7root
RET

Exact
ADD R0, R1, #0 ; Copies R1 value into R0
AND R1, R1, #0
ADD R1, R1, #1
BR rootExactRet

powSRroot .FILL x4250
saveR1root .FILL #0
saveR3root .FILL #0
saveR4root .FILL #0
saveR7root .FILL #0

.END