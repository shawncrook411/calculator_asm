; getn.asm
; Bruce Embry
; an improved subroutine to input a non-negative decimal integer from the keyboard
; PARAMETERS: None
; RETURN VALUE:  R0 - the number input
; ERROR CODES: R1 - 0 (success), -1 (overflow), -2 (character error)
; DEPENDENCIES: none other than usual TRAP CODES

  .ORIG X5000
  BR getn
ToValue .FILL X-30
Multiplier .FILL #9
ValueCode .FILL #-1
CharacterCode .FILL #-2
SaveR2 .FILL #0
SaveR3 .FILL #0
SaveR7 .FILL #0

getn
  ST R2, SaveR2
  ST R3, SaveR3
  ST R7, SaveR7
  AND R1, R1, #0          ; clear for final value
Loop
  GETC
  OUT
  ADD R2, R0, #-10        ; check for newline
  BRZ Done
  ADD R1, R1, #0          ; don't multiply if value is zero
  BRZ Skip
  LD R3, Multiplier         ; set multiplier
  ADD R2, R1, #0          ; copy multiplicand
Mult
  ADD R1, R1, R2
  ADD R3, R3, #-1
  BRP Mult
  ADD R1, R1, #0          ; check for overflow
  BRN ValueError
Skip
  LD R2, ToValue
  ADD R0, R0, R2
  BRN CharacterError
  ADD R2, R0, #-9
  BRP CharacterError
  ADD R1, R1, R0
  BR Loop
Done
  ADD R0, R1, #0
  AND R1, R1, #0
  BR Return
ValueError
  LD R1, ValueCode
  BR Return
CharacterError
  LD R1, CharacterCode
Return
  LD R2, SaveR2
  LD R3, SaveR3
  LD R7, SaveR7
  RET
  .END
