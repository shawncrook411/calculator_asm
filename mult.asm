; R0 return sum 
; R1 operand 1
; R2 operand 2

.ORIG X4100

ST R1 saveR1mult   ; Saves R1
ST R2 saveR2mult   ; Saves R2
ST R3 saveR3mult   ; Saves R3

AND R3, R3, #0 ; Used for storing negative conditional

ADD R1, R1, #0
BRn NR1mult
CheckNR1mult
ADD R2, R2, #0
BRn NR2mult
CheckNr2mult

AND R0, R0, #0 ; Clears R0 to 0
ADD R1, R1, #0 
BRz ESCmult    ; Checks if R1 is 0 for 0*x = 0
ADD R2, R2, #0 ; Checks if R2 is 0 for x*0 = 0 
BRz ESCmult

MultLoop
ADD R0, R1, R0
ADD R2, R2, #-1
BRp MultLoop
BR ESCmult

NR1mult
ADD R3, R3, #1
NOT R1, R1
ADD R1, R1, #1 ; Flips to positive value
BR CheckNr1mult

NR2mult
ADD R3, R3, #1
NOT R2, R2
ADD R2, R2, #1 ; Flips to positive value
BR CheckNr2mult

FlipNegmult
NOT R0, R0
ADD R0, R0, #1
BR Unflippedmult

ESCmult
AND R3, R3, #1 ; Checks if last bit is 0 or 1
BRp FlipNegmult

Unflippedmult
LD R1 saveR1mult
LD R2 saveR2mult
LD R3 saveR3mult
ADD R5, R0, #0
RET

saveR1mult .Fill #0
saveR2mult .FILL #0
saveR3mult .FILL #0
.END
