; printn.asm
; an improved subroutine to print a decimal value to the console screen
; PARAMETERS:
; R0 - the decimal value to print
; RETURN VALUES:
; R0 - 0 on success, -1 on failure
; ERROR CHECKING:
; Only works on values on positive numbers
; Returns -1 if decimal value is negative
; DEPENDENCIES:  none

	.ORIG x5100
	BR printn
ToAscii	
    .FILL x30
Divisor	
    .FILL #-10000
	.FILL #-1000
	.FILL #-100
	.FILL #-10
	.FILL #-1
	.FILL #0
ErrorCode	
    .FILL #-1
SaveR1	
    .FILL #0
SaveR2	
    .FILL #0
SaveR3	
    .FILL #0
SaveR4	
    .FILL #0
SaveR7	
    .FILL #0

printn
	; save registers and return address
	ST R1, SaveR1
	ST R2, SaveR2
	ST R3, SaveR3
	ST R4, SaveR4
	ST R7, SaveR7
	ADD R0, R0, #0			; check number if negative
	BRN error						; if number < 0, error
	LEA R1, Divisor			; point to divisor
leadingZeros
	LDR R2, R1, #0
	BRZ return
	ADD R1, R1, #1			; increment pointer
	ADD R3, R0, R2			; check Divisor
	BRN leadingZeros
	ADD R1, R1, #-1
begin
	LDR R2, R1, #0			; load divisor
	BRZ return
	AND R3, R3, #0			; clear quotient
	ADD R0, r0, #0			; check value of r0
	BRZ zero						; if number = 0, print 0
again
	ADD R3, R3, #1			; increment quotient
	ADD R0, R0, R2			; subtract divisor
	BRZP again
	NOT R2, R2
	ADD R2, R2, #1			; prepare to normalize
	ADD R4, R0, R2			; normalize remainder and save
	ADD R3, R3, #-1			; normalize quotient
	BRNP print
print
	LD R0, ToAscii
	ADD R0, R0, R3			; convert quotient to ascii
	OUT									; print character
 	ADD r0, r4, #0			; copy remainder to R0
; 	BRZ return

update								; update divisor
	ADD R1, R1, #1
	BR begin

error
	LD R0, ErrorCode		; set error code
	br return

zero
	LD R0, ToAscii			; insert '0'
	OUT									; print

return
	; recover registers and return address
	LD R1, SaveR1
	LD R2, SaveR2
	LD R3, SaveR3
	LD R4, SaveR4
	LD R7, SaveR7
	RET
	.end
