; R0 return sum 
; R1 operand 1
; R2 operand 2
; R0 = R1 - R2
; R1 and R2 are returned as given

.ORIG X4050

ST R2 saveR2sub
NOT R2, R2    ; Flips R2 1's complement
ADD R2, R2, #1; 2's complement
ADD R0, R1, R2; Compute into R0
LD R2 saveR2sub ; Reload R2
RET

saveR2sub .fill x0

.END

