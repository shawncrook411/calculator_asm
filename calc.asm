; R0 return sum 
; R1 operand 1
; R2 operand 2
.ORIG X4000

ADD R0, R1, R2
RET











; R0 return sum 
; R1 operand 1
; R2 operand 2
.ORIG X4050

ST R2 saveR2sub
NOT R2, R2
ADD R2, R2, #1
ADD R0, R1, R2
LD R2 saveR2sub
RET

saveR2sub .fill x0













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


















; R0 return sum 
; R1 operand 1
; R2 operand 2
.ORIG X4150

AND R0, R0 #0  ; Clears R0
ST R1 saveR1div   ; Stores value for later 
ST R2 saveR2div   ; Stores value for later
ST R3 saveR3div

ADD R1, R1, #0
BRn NR1div
CheckNR1div
ADD R2, R2, #0
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
ADD R2, R2, #1 ; Gets 2's comp (negative R2)
BRz ESCdiv        ; If R2 is 0 return nothing

divLOOP
ADD R0, R0 #1  ; Increment R0
ADD R1, R1, R2
BRp divLOOP
BRz ESCdiv

divOVER
ADD R0, R0, #-1

ESCdiv
LD R1 saveR1div
LD R2 saveR2div
AND R3, R3, #1 ; Checks if last bit is 0 or 1
BRp FlipNegDiv
RET

FlipNegDiv
NOT R0, R0
ADD R0, R0, #1
RET

saveR1div .FILL #0
saveR2div .FIll #0
saveR3div .FILL #0









; R0 return value
; R1 operand 1
; R2 opearnd 2

.ORIG X4200

ld r1 test1
ld r2 test2

AND R0, R0 #0  ; Clears R0
ST R1 saveR1mod   ; Stores value for later 
ST R2 saveR2mod   ; Stores value for later
ST R3 saveR3mod   ; Stores value for later

ADD R1, R1, #0
BRz ESCmodZ

NOT R2, R2
ADD R2, R2, #1 ; Gets 2's comp (negative R2)
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
add r5, r0, #0
RET

modOVER
NOT R2, R2
ADD R2, R2, #1
ADD R1, R1, R2 ; Reverses 1 subtraction
BR ESCmod

saveR1mod .FILL #0
saveR2mod .FIll #0
saveR3mod .FILL #0

test1 .FILL #0
test2 .FILL #11
.END

; Negative 3 CASES
; Nethier operand is negative - normal
; Only 1 is negative - result = dividend - result
; Both negative - result = -1 * result
