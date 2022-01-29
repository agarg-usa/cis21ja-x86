TITLE  Lab 4: Calculate the number of coins, and predict flag values

; Don't forget this beginning documentation with your name
; Name: Aryan Garg


INCLUDE Irvine32.inc

; Part 1 (10pts)


.data

MAX = 99
changeIsStr BYTE "Change is: ", 0
centsStr BYTE " cents", 0
quartersStr BYTE " quarters, ", 0
dimesStr BYTE " dimes, ", 0
nickelsStr BYTE " nickels, ", 0
penniesStr BYTE " pennies", 0


.code
main PROC

	; using cl as my changeRemaining variable

	call randomize					; create a seed for the random number generator
	mov eax, MAX    				; set upper limit for random number to MAX
	call randomRange				; random number is returned in eax, and is 0-MAX inclusive
	; call writeDec					; print to check random number
	mov cl, al						; store random number in cl

	mov eax, 0						; set eax to 0

	mov edx, offset changeIsStr
	call writeString				; print change is:
	mov al, cl						; set al to change
	call writeDec					; print random number in eax (change)
	mov edx, offset centsStr
	call writeString				; print cents
	call Crlf						; print a new line

	; we need to divide random num (dividend, will be in AX) by 25,10,5 (divisor)

	mov al, cl						; set al to change
	mov bl, 25						; set bl to quarterSize
	div bl							; AL = change / 25, AH = change % 25
	mov cl, ah						; store change % 25 in cl
	mov ah, 0 						; set ah to 0
	; eax should now equal the number of quarters
	call writeDec					; print number of quarters
	mov edx, offset quartersStr 	; move "quarters" into edx
	call writeString				; print quarters

	mov al, cl						; set al to change
	mov bl, 10						; set bl to dimeSize
	div bl							; AL = change / 10, AH = change % 10
	mov cl, ah						; store change % 10 in cl
	mov ah, 0 						; set ah to 0
	; eax should now equal the number of dimes
	call writeDec					; print number of dimes
	mov edx, offset dimesStr	 	; move "dimes" into edx
	call writeString				; print dimes

	mov al, cl						; set al to change
	mov bl, 5						; bl is nickel size
	div bl							; AL = change / 5, AH = change % 5
	mov cl, ah						; store change % 5 in cl
	mov ah, 0 						; set ah to 0
	; eax should now equal the number of nickels
	call writeDec					; print number of nickels
	mov edx, offset nickelsStr	 	; move "nickels" into edx
	call writeString				; print nickels

	mov al, cl						; set al to change
	; al / eax is now the number of pennies remaining
	call writeDec					; print number of pennies
	mov edx, offset penniesStr	 	; move "pennies" into edx
	call writeString				; print pennies
	call Crlf						; print a new line

	exit
main ENDP

END main


COMMENT !
Part 2 (5pts)
Assume ZF, SF, CF, OF are all 0 at the start, and the 3 instructions below run one after another.
a. fill in the value of all 4 flags after each instruction runs
b. show your work to explain why CF and OF flags have those values
   Your explanation should not refer to signed or unsigned data values,
   such as "the result will be out of range" or "204 is larger than a byte"
   or "adding 2 negatives can't result in a positive"
   Instead, show your work in the same way as in the exercise 4 solution.


mov al, 70h

add al, 30h

70h = 0111 0000
30h = 0011 0000

C:111
  0111 0000
+
  0011 0000
  ---------
  1010 0000

; a. ZF = 0  SF =1  CF = 0  OF = 1
; b. explanation for CF:
	CF is set if there is any bits carried out of the MSB, but in this case nothing was carried out of the MSB so CF is 0

;    explanation for OF:
	OF is set if the Carry out XOR Carry into the MSB. In this case a 1 is carried into the MSB and nothing is carried out of the MSB, so 0 XOR 1 = 1 so OF is 1

sub al, 070h

al = 1010 0000
70h = 0111 0000
-70h = 1000 1111 + 1 = 1001 0000

C: 1
    1010 0000
+
    1001 0000
    ---------
(1) 0011 0000

; a. ZF = 0   SF = 0  CF = 0   OF = 1
; b. explanation for CF:
	for subtraction CF is set if there is NOT any bits carried out of the MSB. In this case, there is a bit carried out of
	the MSB, so CF is 0
;    explanation for OF:
	OF is still carry out of MSB XOR carry into MSB. in this case there is a carry out of the MSB but no
	carry in, so 1 XOR 0 is 1 so OF is 1

!