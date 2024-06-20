; R0 return sum 
; R1 operand 1 (Base)
; R2 operand 2 (Power)
; R3 Power is Copied to
; R4 Used for loading Address of Mult SR
.ORIG X4250
ST R2 saveR2pow
ST R3 saveR3pow
ST R4 saveR4pow
ST R7 saveR7pow

LD R4 multSRpow ; Loads memory address of multiplicaton subroutine


AND R0, R0, #0 ; Clears R0
ADD R0, R0, #1 ; Base^0 = 1
ADD R3, R2, #0 ; Copies Value to R3 and checks to count how many muliplies happen
BRz ESCpow

PowerLoop
ADD R2, R0, #0 ; Copies R0 into R2 (Base). Must copy into R2 for subroutine standard
JSRR R4        ; Jumps to multiplication subroutine
ADD R3, R3, #-1; Decrements Power Counter. Once power counter reaches zero escapes
BRp PowerLoop

ESCpow
LD R2 saveR2pow
LD R3 saveR3pow
LD R4 saveR4pow
LD R7 saveR7pow
RET

saveR2pow .FILL #0
saveR3pow .FILL #0
saveR4pow .FILL #0
saveR7pow .FILL #0

multSRpow .FILL x4100 ; Value of the multiply subroutine
.END