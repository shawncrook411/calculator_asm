; R0 return value
; R1 operand 1
; R2 opearnd 2

.ORIG X4200

AND R0, R0 #0  ; Clears R0
ST R1 saveR1mod   ; Stores value for later 
ST R2 saveR2mod   ; Stores value for later
ST R3 saveR3mod   ; Stores value for later

ADD R1, R1, #0
BRz ESCmodZ

NOT R2, R2
ADD R2, R2, #1    ; Gets 2's comp (negative R2)
BRz ESCmod        ; If R2 is 0 return nothing

modLOOP
ADD R0, R0 #1  ; Increment R0
ADD R1, R1, R2
BRn modOVER
BRp modLOOP

ESCmod
ADD R0, R1, #0 ; Copies R1 into R0
ESCMODZ
LD R1 saveR1mod
LD R2 saveR2mod
RET

modOVER
NOT R2, R2
ADD R2, R2, #1
ADD R1, R1, R2 ; Reverses 1 subtraction
BR ESCmod

saveR1mod .FILL #0
saveR2mod .FIll #0
saveR3mod .FILL #0

.END

