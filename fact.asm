;R0 Result
;R1 Operand 1
;R2 


.ORIG x4400
ST R2 saveR2fact
ST R3 saveR3fact
ST R7 saveR7fact  ; Saves return address

AND R0, R0, #0
ADD R0, R0, #1 ; SETS R0 to 1 as if it was 0 initially we could never multiply our way out
ADD R1, R1, #0 ; Checks if R1 is 0, if so escapes without computing anything
BRz ESCfact

FactLoop
ADD R2, R0, #0 ; Copies Current Value to R2
LD R3, factSRmult
JSRR R3   ; Multiplies R1 * R2 -> R0
ADD R1, R1, #-1 ; Decrement as we must multiply all number until 0
BRp FactLoop
BRz ESCfact       ; Once R1 reaches 0, escape (no more multipication) DOES NOT MULTIPLY BY 0

ESCfact
LD R2 saveR2fact
LD R3 saveR3fact
LD R7 saveR7fact
RET

factSRmult .FILL x4100 ; Value of the multiply subroutine

saveR2fact .FILL #0
saveR3fact .FILL #0
saveR7fact .FILL #0
.END