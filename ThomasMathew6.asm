
TITLE ThomasMathew6				(ThomasMathew6.asm)

; Thomas Mathew
; mathewt@onid.oregonstate.edu
; CS 271-400
; Assignment #6, Option A
; Assignment Due 3/13/16 

;This progam will:
;-Implement macros "getString" and "displayString". The macros will use Irvine’s ReadString to get input from
;the user, and WriteString to display output.
;-getString will display a prompt, then get the user’s keyboard input into a memory location
;-displayString will store the string in a specified memory location.
;-readVal will invoke the getString macro to get the user’s string of digits, then convert the digit string to numeric, while validating the user’s input.
;-writeVal will convert a numeric value to a string of digits, and invoke the displayString macro to produce the output.
;There will be a small test program that gets 10 valid integers from the user and stores the numeric values in an array. The program then displays the integers, their sum, and their average


INCLUDE Irvine32.inc

.data
    ; declare variables

    greeting1 BYTE "Hello! This is Thomas Mathew. This is Program #6, Option A.",0

    instruct0 BYTE "This program will ask you to input 10 unsigned integers.",0
    instruct1 BYTE "Each number input must be small enough to fit in a 32 bit register.",0
    instruct2 BYTE "Once you enter the 10 numbers, the program will display those numbers, their sum, and their average.",0
    instruct3 BYTE "Please enter an unsigned integer. ",0

    output1 BYTE "Error: Your number was too large, or it was signed. Please try again.",0
    output2 BYTE "You entered these ten numbers: ",0
    output3 BYTE "The sum of those numbers is: ",0
    output4 BYTE "The average of those numbers is: ",0
    
    goodbye1 BYTE "Thanks for using Program #6! ",0

    mystring DWORD ?
    newstring BYTE ?
    mySum	DWORD ?
    myAverage DWORD ?
    stringarray DWORD 100 DUP (?)

    loopcheck DWORD ?
    loopcheck2 DWORD ?


  GetString MACRO 
;set up 
	mov loopcheck, 0

	push OFFSET stringarray			;pass array by reference
	push ebp						;set up stack frame
	mov ebp,esp
	push ecx
	push edx

	mov ebp, esp
	mov esi, [ebp+12]				;put address of array into esi	
	mov edi, esi

inputloop:

;Get their input and verify
	mov edx, OFFSET instruct3
	call WriteString
	call CrLf
	call ReadInt
	cmp eax, 0
	jl errorRange
	cmp eax, 429496729
	jg errorRange

;Put the input into the array

	mov [edi], eax					;Put into the memory address of edi
	add edi, 4					;move edi to the next array position
			
;Check loop. If loopcheck = 10, finished.
	inc loopcheck
	mov eax, 10
	cmp loopcheck, eax
	jl inputloop
	
inputdone:

  ENDM

  DisplayString MACRO 
;This Macro displays the 10 numbers, the sum, and the average of those numbers

	call CrLf

	mov loopcheck2, 0
	sub edi, 40						;Go to the beginning of the array

	mov edx, OFFSET output2
	call WriteString
	call CrLf

displayloop:
;Display the values in the array
	mov eax, [edi]
	call WriteInt
	add edi, 4

;Check loop. If loopcheck = 10, finished.
	inc loopcheck2
	mov eax, 10
	cmp loopcheck2, eax
	jl displayloop

;Now we add the values
	call CrLf
	mov loopcheck2, 0
	sub edi, 40						;Go to the beginning of the array

addloop:
;Add the values in the array
	mov eax, [edi]
	add mySum, eax
	add edi, 4

;Check loop. If loopcheck = 10, finished.
	inc loopcheck2
	mov eax, 10
	cmp loopcheck2, eax
	jl addloop


	displaydone:
	mov edx, OFFSET output3
	call WriteString
	call CrLf
	mov eax, mySum
	call WriteInt
	call CrLf
	mov edx, OFFSET output4
	call WriteString
	call CrLf
	mov edx, 0
	mov ebx, 10
	mov eax, mySum
	div ebx
	call WriteInt
	call CrLf

  ENDM


.code
main PROC

call introduction

call readVal		

call writeVal

call farewell

exit
main ENDP


introduction PROC
;Introduce myself and describe the program
     mov edx, OFFSET greeting1
     call WriteString
	call CrLf
	mov edx, OFFSET instruct0
     call WriteString
	call CrLf
	mov edx, OFFSET instruct1
     call WriteString
	call CrLf
	mov edx, OFFSET instruct2
     call WriteString
	call CrLf

ret
introduction ENDP


readVal PROC 

;Get their input by calling the macro
	GetString					

readVal ENDP


writeVal PROC 

;Display their input, the sum, and the average using the macro
	DisplayString					 

writeVal ENDP


farewell PROC
;Thank them for using the program
		call CrLf
		call CrLf
		mov edx, OFFSET goodbye1
		call WriteString
		call CrLf
		exit
ret
farewell  ENDP

;Error message if input was invalid
	errorRange:
		mov edx, OFFSET output1
		call WriteString
		call CrLf
exit

END main