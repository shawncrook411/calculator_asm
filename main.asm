; Calculator with basic functions and inputs!!!
; Author: Shawn Crook
; Purpose: To create a basic calculator, written in Assembly, that can be ran on LC-3
; It can take any 4-digit input for 2 operands
; It can then also take an opeartor from this list: [+ - * / % ^ ~ !] Note: ~ is given for root
; It will then display the result that was calculated
; It currently CANNOT accept negative numbers, HOWEVER the subroutines are built with negatives in mind
; The only change that would need to be made is the get_n and print_n subroutine


.ORIG x3050
BR Begin
    Prompt1 .STRINGZ "Welcome to my calculator!!\n\n\nWhat is input #1?\n"
    Prompt2 .STRINGZ "Which operater will you use? \nAdd: + \nSubtract: - \nMultiply: * \nDivide: / \nModulus: % \nPower: ^ (Base : Power)\nRoot: ~ (Base :  RootValue)\n! Factorial\n"
    Prompt3 .STRINGZ "What is input #2?\n"
    FalseOp .STRINGZ "Invalid operator used!\n"
    getn_sr .FILL x5000
    
Begin
    BR Start
Start
    LD R5 getn_sr
    LEA R0, Prompt1 ; Prompt for first input
    PUTS
    JSRR R5        ; Gets a multi-digit number and stores in R0
    ADD R4, R0, #0 ; Stores Operand1 temporarily into R4
    LEA R0, NewLine
    PUTS
    LEA R0, Prompt2 ; Prompt for operator input
    PUTS

    GETC ; Gets operator
    OUT  ; Prints operator
    ADD R3, R0, #0 ; Stores Operator Code
    LEA R0, NewLine
    PUTS

    LD R6, FactSign ; This chunk will skip the second operand if using factorial
    ADD R6, R3, R6
    BRz OPfact

    LEA R0, Prompt3 ; Prompt for second operand
    PUTS
    JSRR R5 ; Gets a multi-digit number and stores in R0
    ADD R2, R0, #0 ; Stores Operand2
    ADD R1, R4, #0 ; Restores Operand1 into R1 (getn has a return value in R1 that we are ignoring)
    LEA R0, NewLine
    PUTS
    LEA R5, OPstart
    BR CheckOp

NewLine .STRINGZ "\n"
OPstart
AddSign .FILL #-43
MinusSign .FILL #-45
MultSign .FILL #-42
DivSign .FILL #-47
ModSign .FILL #-37
PowSign .FILL #-94
RootSign .FILL #-126
FactSign .FILL #-33

; Fancy Loop!
; Essentially what is happening here is a loop is checking if R3 (the operator ASCII input)
; Is ever equal to any of the ascii character values above
; Once one is found R5 holds the ADDRESS of whichever sign was found

CheckOp
    LDR R4, R5, #0
    ADD R4, R3, R4 ; We don't care about the value in R4, just whether it is n-z-p
    BRz EndCheckOp
    LEA R4 OPstart
    ADD R4, R4, #7 ; Amount of iterations allowed, 1 per operation included. Easily adjustable
    NOT R4, R4
    ADD R4, R4, #1
    ADD R4, R5, R4 ; Checks if our loop has incremented too far
    BRz HandleFalse
    ADD R5, R5, #1
    BR CheckOp

srCODES ; Subroutine memory addresses
    srADD   .FILL x4000 
    srSUB   .FILL x4050
    srMULT  .FILL x4100
    srDIV   .FILL x4150
    srMOD   .FILL x4200
    srPOW   .FILL x4250
    srROOT  .FILL x4300
    srFACT  .FILL x4400
    srAddress .FILL x0

opFACT ; Need special case because factorial doesn't have 2 operands. Must be able to Branch directly into
    ADD R1, R4, #0
    LD R6, srFACT
    JSRR R6
    BR END

HandleFalse    ; If no matching operator is found
    LEA R0, FalseOp
    PUTS
    BR Start


; R5 now contains the address of of the fill signs
; We can subtract the starting address, opSTART, to get the OFFSET or how many places we traveled
; We can then go to the correct subroutine by knowing this offset and adding it to opCODES
; This works because the ascii sign values are in the same order as the subroutine memory address fills

EndCheckOp
    LEA R6, srCODES
    LEA R4, OPSTART
    NOT R4, R4
    ADD R4, R4, #1
    ADD R5, R5, R4
    ADD R6, R6, R5
    ST R6 srAddress ; Fancy trick to store the memory address that holds a memory address of the subroutine and then indirectly LD
    LDI R6 srAddress
    JSRR R6 ; Now that the correct memory address has been loaded into R6 we can then jump to the subroutine of the operation
    BR END

    Result .STRINGZ "Your result is: \n"
    printn_sr .FILL x5100

End
    ADD R5, R0, #0 ;Copies result into R5
    ADD R6, R0, #0 ;Copies result into R6
    LEA R0, Result
    PUTS ; Prints result Prompt

    LD R4 rootSign
    ADD R3, R3, R4
    BRz qualityPrompt  ; If using the Root Operation jumps to include prompts for "Roughly" or "Exactly" as its useful to know if we found an exact root
    qualityReturn  
    ADD R0, R6, #0 ; Copies result back
    BRz printZero
    LD R6, printn_sr ; Prints the result as a multi-digit number
    JSRR R6
    HALT ; Ends program

    ASCII .FILL #48 
    printZero
    LD R4 ASCII
    ADD R0, R0, R4
    OUT
    HALT

    qualityPrompt
    ADD R1, R1, #-1 ; If root returned with a value in R1 of 1 we know it was exactly calculated the root
    BRz printExact

    LEA R0 aboutPrompt
    PUTS
    BR qualityReturn

    printExact
    LEA R0 exactPrompt
    PUTS
    BR qualityReturn

    aboutPrompt .STRINGZ "Roughly "
    exactPrompt .STRINGZ "Exactly "
    
.END