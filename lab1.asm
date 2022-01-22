; Lab 1
; Name:  Aryan Garg          

; 1. Put your name above. For the rest of the quarter, you should
;   always have your name at the top of your source file
; 2. In the first_text line below, replace the -- with your name
; 3. Build and run the program to see the output window


INCLUDE Irvine32.inc

.data

first_text  BYTE  "This is Aryan's first CIS 21JA assignment", 0ah, 0dh, 0

.code
main PROC
	mov edx, OFFSET first_text
	call writeString	
	call crlf
	exit
main ENDP

END main