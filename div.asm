; R0 return sum 
; R1 operand 1
; R2 operand 2
.ORIG X4150

AND R0, R0 #0  ; Clears R0
ST R1 saveR1div   ; Stores value for later 
ST R2 saveR2div   ; Stores value for later
ST R3 saveR3div   ; Stores value for later
AND R3, R3, #0    ; Clear R3 to 0

ADD R1, R1, #0
BRn NR1div        ; Checks if R1 is negative. If so it increments R3 and flips it to positive
CheckNR1div
ADD R2, R2, #0    ; Checks if R2 is negative. If so it increments R3 and flips it to positive
BRn NR2div 
BR divStart  

NR1div
ADD R3, R3, #1
NOT R1, R1  
ADD R1, R1, #1 ; Flips to positive value
BR CheckNr1div

NR2div
ADD R3, R3, #1
NOT R2, R2
ADD R2, R2, #1 ; Flips to positive value

divStart
NOT R2, R2
ADD R2, R2, #1    ; Gets 2's comp (negative R2)
BRz ESCdiv        ; If R2 is 0 return nothing

divLOOP
ADD R0, R0 #1  ; Increment R0
ADD R1, R1, R2 ; Repeated Subtraction
BRp divLOOP    ; If result is positive, repeat loop
BRz ESCdiv     ; If result is exact skips decrement step

divOVER
ADD R0, R0, #-1 ; Overshoot so must decrement result

ESCdiv
LD R1 saveR1div
LD R2 saveR2div
AND R3, R3, #1 ; Checks if last bit is 0 or 1, If 1 EXACTLY 1 of the operands was negative so we must flip the result to a negative vvalue
BRp FlipNegDiv
RET

FlipNegDiv
NOT R0, R0
ADD R0, R0, #1 ; FLips result to negative because only 1 operand was negative
RET

saveR1div .FILL #0
saveR2div .FIll #0
saveR3div .FILL #0

.END

