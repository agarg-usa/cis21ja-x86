TITLE  Assignment 6: Use bit wise instructions

; Name: Aryan Garg

INCLUDE Irvine32.inc

.data
zeroStr BYTE "EAX is 0", 0ah, 0dh, 0
divStr BYTE "Divisible by 4", 0ah, 0dh, 0
arr WORD 1, 0f02h, -2

.code
main PROC
; Question 1 (3pts)
; In the space below, write code in 3 different ways (use 3 different instructions)
; to check whether EAX is 0, and jump to label Zero if it is, otherwise jump to Q2.
; To solve this problem you:
; - cannot use the CMP instruction or arithmetic instruction (ADD, SUB, DIV, etc.)
; - cannot change the EAX value or copy the EAX value to another register

	mov eax, 0		; change this value to test your code
	; make sure you have 3 different ways using 3 different instructions,
	; only one will run at a time

	; Way 1: using AND
	and eax, 0FFFFFFFFh
	jz Zero
	jnz Q2

	; Way 2: use TEST
	test eax, 0FFFFFFFFh
	jz Zero
	jnz Q2

	; Way 3: use XOR
	xor eax, 0
	jz Zero
	jnz Q2

	Zero :
		mov edx, OFFSET zeroStr
		call writeString
		call crlf

	Q2:
; Question 2
; You can use the following code to impress your friends,
; but first you need to figure out how it works.

	mov al, 'B'	    ; al can contain any letter of the alphabet
	xor al, ' '	    ; the second operand is a space character
	call WriteChar
	Call crlf

COMMENT !
a. (1pt) What does the code do to the letter in AL?
   (Print the letter in AL to see, then change the letter to 'B', 'd', 'R', etc.)
   A turns into a (and visa versa)
   b turns into B (and visa versa)

   The code seems to toggle the case of a character

b. (2pts) Explain how the code works. Your answer should not be a description
   of what the instruction does, such as "the code takes the value in AL
   and does an XOR with the space character."

   If we look at an ascii chart, the ascii char for space is
   20h or 0010 0000
   Since we are XOR'ing al with this, we are toglling the 6th bit of al
   This is essentially the same as adding 32 if the 5th bit is not set, or
   subtacting 32 if the 5th bit is set.

   We can see this play out with the ascii characters. If we uppercase A, the 5th bit is not set,
   so XOR ' ' is the same as adding 32. 'A' (DEC65) + 32 = 'a' (DEC 97)
   The same is true for all uppercase characters.

   For lowercase chars, you minus 32 since the 5th bit is set, so 'a' (dec 97) - 32 = 'A' (dec 65)
!

; Question 3 (4 pts)
; Write code to check whether the number in AL is divisible by 4,
; jump to label DivBy4 if it is, or go to label Q4 if it's not.
; You should not have to use the DIV or IDIV instruction.
; Hint: write out the first few integers that are divisible by 4,
; and see if you can find a pattern with them.

    mov al, 12     ; change this value to test your code

	; 4 = 0000 0100
	; 8 = 0000 1000
	; 12 = 0000 1100
	; 16 = 0001 0000
	; 20 = 0001 0100
	; 24 = 0001 1000
	; 28 = 0001 1100
	; if the first 2 bits are set, then the number is not divisible by 4
	; if the first 2 bits are not set, then the number is divisible by 4

	and al, 11b ; extract the first 2 bits
	jz DivBy4 ; if the first 2 bits are not set (00, divisble by 4), then jump to DivBy4
	jnz Q4 ; if the first 2 bits are set (10 / 01 / 11, not divisible by 4), then jump to Q4



	DivBy4:
		mov edx, OFFSET divStr
		call writeString
		call crlf

	Q4:
; Question 4 (5 pts)
; Given an array arr of 3 WORD size data, as defined in .data above,
; and ebx is initialized as shown below.
; Using ebx (not the array name), write ONE instruction (one line of code)
; to reverse the bits in the most significant byte (high byte) of
; the last 2 elements of arr.
; Reverse means turn 0 to 1 or 1 to 0.
; Your code should work with all values in arr, not just the sample data in arr

	; mov esi, OFFSET arr
	; mov ecx, 4
	; mov ebx, 2
	; call DumpMem

	mov ebx, OFFSET arr

	; 0001 0F02 FFFE is the arr
	; using DWORD ptr [ebx + 2] will read in:
	; FE FF 02 0F (little edian)
	; we want to XOR 0F and FF, getting F0 00
	; so final result: FE 00 02 F0 (little edian)
	; we can get this by XOr'ing FF00FF00h (big edian)

	xor DWORD PTR [ebx+2], 0ff00ff00h

	; mov esi, OFFSET arr
	; mov ecx, 4
	; mov ebx, 2
	; call DumpMem


	exit
main ENDP

END main
