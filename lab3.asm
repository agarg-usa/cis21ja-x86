TITLE Lab3 3

;;;;; Q1: Don't forget to document your program
; Name:  Aryan Garg
; Date: 1/21/2022

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Answer each question below by writing code at the APPROPRIATE places in the file
;;;;; Putting your answer immediately after the question is not necessarily the correct place

;;;;; Q2: Write the directive to bring in the IO library
INCLUDE Irvine32.inc

;;;;; Q3: Create a constant called SECS_PER_MIN and initialize it to 60
SECS_PER_MIN = 60

;;;;; Q4: Create a constant called SECS_PER_DAY by using SECS_PER_MIN (of Q3) in an integer expression constant

SECS_PER_DAY = SECS_PER_MIN*60*24

;;;;; Q5: Define an array of 25 signed doublewords, use any array name you like. Initialize:
;;;;;	- the 1st element to 10
;;;;;	- the 2nd element to the hexadecimal value C2
;;;;;	- the 3rd element to the binary value 10101
;;;;;	- the 4th element to the SECS_PER_MIN constant defined in Q3
;;;;; and leave the rest of the array uninitialized.

;;;;; Q6. Define the string "Output is ", use any variable name you like.

;;;;; Q7. Define a prompt that asks the user for a negative number

;;;;; Q8. Write code to print to screen the value of eax after SECS_PER_DAY is stored in eax (first line of code below)
;;;;;     Use the string you defined in Q6 as the text explanation for your output

;;;;; Q9. Write code to prompt the user for a negative number, using the prompt string that you defined in Q7

;;;;; Q10. Write code to read in the user input, which is guaranteed to be a negative number

;;;;; Q11. Write code to print "Output is " and then echo to screen the user input number

;;;;; Q12. Write code to print "Output is " and then print the first element of the array defined in Q5
;;;;;      The output should not contain a + or - sign

;;;;; Q13. Build, run, and debug your code
;;;;; Your output should be similar to this (without the commented explanation)

;;;;; Output is 86400						    ; printing SECS_PER_DAY
;;;;; Enter a negative number: -2
;;;;; Output is -2								; echo user input number
;;;;; Output is 10 								; print first element of array
;;;;; Press any key to continue . . .

;;;;; Q14. At ourthe end of the sce file, without using semicolons (;), add a comment block
;;;;;      to show how bigData appears in memory (should be the same 8 hexadecimal values as in lab 2),
;;;;;      and explain why the data in memory looks different than the initialized value

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.data
bigData QWORD 1234567890abcdefh					; same bigData value as lab 2
myDWordArr DWORD 10, 00c2h, 10101b, SECS_PER_MIN, 20 DUP(?)
outputIsStr BYTE "Output is ", 0
enterNegNum BYTE "Enter a negative number: ", 0



.code
main PROC
	mov eax, SECS_PER_DAY						; eax = SECS_PER_DAY value
	mov edx, offset outputIsStr					; edx = outputIsStr
	call WriteString							; write outputIsStr to screen
	call WriteDec								; print SECS_PER_DAY
	call Crlf

	mov edx , offset enterNegNum				; edx = enterNegNum
	call WriteString							; write "Enter a neg number" to screen

	mov edx , offset enterNegNum				; edx = enterNegNum
	mov ecx, 10
	call ReadString								; read user input

	mov edx , offset outputIsStr				; edx = outputIsStr
	call WriteString							; write "Output is " to screen

	mov edx , offset enterNegNum				; edx = outputIsStr
	call WriteString							; write the users neg num to screen
	call Crlf

	mov edx , offset outputIsStr				; edx = outputIsStr
	call WriteString							; write "Output is " to screen
	mov eax, myDWordArr[0]						; eax = dwordarr[0]
	call WriteDec								; print first element of array
	call Crlf


	exit
main ENDP

END main

COMMENT |
bigData is ef cd ab 89 78 56 34 12
big data looks like this because of endianness
intel is little endian, so the first byte is the least significant and the last byte is the most significant
|