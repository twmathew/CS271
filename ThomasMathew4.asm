
TITLE ThomasMathew4						(ThomasMathew4.asm)

; Thomas Mathew
; mathewt@onid.oregonstate.edu
; CS 271-400
; Assignment #4
; Assignment Due 2/14/16 (Used one grace Day)

; Problem Definition:
; This program calculates and diplays composite (non-prime) numbers. First, the user is instructed to enter the number of
; composites to be displayed, and is prompted to enter an integer in the range [1 .. 400]. 
; If n is out of range, the user is reprompted until s/he enters a value in the specified range. 
; The program then calculates and displays all of the composite numbers up to and including the nth composite.
; The results are displayed 10 composites per line with at least 3 spaces between the numbers.


INCLUDE Irvine32.inc

.data
    ; declare variables

    greeting1 BYTE "Hello! This is Thomas Mathew. This is Program #4.",0

    instruct0 BYTE "This program will display composite numbers.",0
    instruct1 BYTE "A composite number is simply a non-prime number.",0
    instruct2 BYTE "The program will only work for integers between 1 and 400",0
    instruct3 BYTE "How many composite numbers do you want to be shown?",0
    instruct4 BYTE "Enter a number between 1 and 400.",0
    instruct5 BYTE "The composite numbers in that range are: ",0

    output1 BYTE "You didn't enter a number between 1 and 400. Please re-run program",0
    
    goodbye1 BYTE "Thanks for using the composite numbers program! ",0

    input1 DWORD ?
    valueholder1 DWORD ?
    valueholder2 DWORD ?
    loopcount DWORD ?
    loopcount1 DWORD ?
    spacecount DWORD ?


.code
main PROC

call introduction
call getUserData
call showComposites
call farewell



exit

main ENDP

introduction PROC
;Introduce myself and display program title
     mov edx, OFFSET greeting1
     call WriteString
	call CrLf
ret
introduction ENDP

getUserData PROC
;Tell the user how the program works
	call CrLf
	mov edx, OFFSET instruct0
     call WriteString
	call CrLf
	mov edx, OFFSET instruct1
     call WriteString
	call CrLf
	call CrLf
	mov edx, OFFSET instruct2
     call WriteString
	call CrLf
;Get their input
	mov edx, OFFSET instruct3
     call WriteString
	call CrLf
	call ReadInt
	mov input1, eax
;Set values before we go to procedures
	mov valueholder1, eax
	mov eax, valueholder1
	mov valueholder2, eax
;call the "validate" subprocedure
	call validate
ret
getUserData ENDP

validate PROC
;Verify user input is in the range. If it is not, jump to error message
	mov eax, input1
	cmp input1, 400
	jg errorRange
	cmp input1, 1
	jl errorRange
;If input was valid, tell them that they will now see the numbers
	call CrLf
	mov edx, OFFSET instruct5
     call WriteString
	call CrLf
	call CrLf
;Initialite the value for spacecount, so we can display 10 numbers per line.
	mov eax, 11
	mov spacecount, eax
	mov eax, 0
ret
validate ENDP

;The showComposites procedure prints the current value. It relies on the "isComposite" to check the numbers.
showComposites PROC
showtop:

	dec spacecount
	mov eax, 0
	cmp spacecount, eax
	je spacing 

;print current value, that was found to be composite
	mov eax, valueholder2
	call WriteInt
;							only print: valueholder2

;reduce value by 1. This will be the next value we check for being composite.
	dec valueholder2
	mov eax, valueholder2
	mov valueholder1, eax

;Prevent the program from using 1 as a denominator (divisible by 1 does not make a number composite)
	mov eax, 1
	cmp valueholder1, eax
	je farewell

;Set loopCount so that "isComposite" procedure works correctly.
	mov eax, 0
	mov loopCount, eax

;Call isComposite. It will check if the current value is composite.
	call isComposite


jmp showtop

ret
showComposites  ENDP


isComposite PROC
;This procedure checks if the number is composite (whether it can be written as a product of integers)
;We use two variables. Valueholder 2 is the value being checked, and valueHolder1 is decreased by 1 on each loop
;So, we check if V2/V1 = an integer, V2/(V1-1) = and integer, V2/(V1-2) is an integer, etc etc until V1 = 1, which we do not check.
;We check this by seeing if the remainder = 0.
;If it does, then the number is composite, so we jump out of the loop. Otherwise we keep going.


topis:
;Loop counter variable, and decrease value 1. Otherwise we would just be dividing the value by itself.
	inc loopCount
	dec valueholder1

;Prevent division by 1 or less than 1
	mov eax, 1
	cmp eax, valueholder1
	je bounceback
	mov eax, 1
	cmp valueholder1, eax
	jl farewell

;Set registers and divide values
	mov eax, 0
	mov eax, valueholder2
	mov ebx, 0
	mov ebx, valueholder1
	mov edx, 0
	div ebx


;If there was no remainder, then it is composite, so jump to the other prodecure to print the current value
	mov eax, edx
	cmp eax, 0
	je showComposites

;Otherwise, keep looping

jmp topis


ret
isComposite  ENDP


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

bounceback PROC
;This program lets us avoid going to the show procedure, for when a number is prime.

		dec valueholder2
		mov eax, valueholder2
		mov valueholder1, eax
		jmp isComposite
ret
bounceback  ENDP

spacing PROC
;space every 5 numbers
		call CrLf
		call CrLf
		mov eax, 11
		mov spacecount, eax
		jmp showComposites
		exit
ret
spacing  ENDP

;Error message if input was invalid
	errorRange:
		call CrLf
		mov edx, OFFSET output1
		call WriteString
		call CrLf
exit

END main