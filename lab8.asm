TITLE  Lab 8: Find letters in 2D array of strings

; Name: Aryan Garg


INCLUDE Irvine32.inc

ROWS = 3
COLS = 11

printStr MACRO addr
	push edx
	mov edx, addr
	call writeString
	pop edx
ENDM

multiplyNum MACRO reg, num, out
	push eax
	mov eax, num
	mul reg
	mov out, eax
	pop eax
ENDM


.data

myArr BYTE ROWS*COLS DUP(0)
promptEnterStr BYTE "Enter a string: ", 0
promptEnterChar BYTE "Enter a character: ", 0

.code
main PROC

; 1. call fill array, pass arguments through *registers*

mov eax, OFFSET myArr
mov ebx, OFFSET promptEnterStr

call fillArr
call crlf

; 2. check return value and end the program if return value is 0
cmp eax, 0 ; eax = num of strs entered
jz endOfMain

mov ebx, eax ; store num of strs into ebx

; 3. loop to call findCount, pass arguments through *the stack*
letter:
	push eax ; push space for return val
	push OFFSET myArr ; push 2d arr
	push ebx ; push num of strs / rows to search from
	push OFFSET promptEnterChar ; push prompt
	call findCount

	pop eax ; save count num
	call WriteDec ; write count num
	call crlf

	jmp letter

endOfMain:
	exit

main ENDP

; eax = offset of arr
; ebx = offset of prompt str
; return val: eax = count
fillArr PROC
	push ecx ; save ecx
	push edx ; save edx
	push esi ; save esi

	mov ecx, ROWS ; set ecx to ROWS (used for loop iter)
	mov esi, 0 ; set esi to 0
	; esi is our currRow

fillArrLoop:
	printStr ebx ; print prompt
	push ecx ; save curr ecx val (loop iter)
	mov ecx, COLS-1 ; set ecx to max str input size (COLS-1 for null char)

	; mov edx, eax + esi*COLS ; edx should = eax + currRow*COLS * sizeof(BYTE) = eax + esi*COLS

	multiplyNum esi, COLS, edx ; edx = esi*COLS
	add edx, eax ; edx = esi*cols + eax

	; ecx now equals max chars
	; edx equals offset to the curr row in the array
	push eax ; save eax as it will get modified by readString

	; we can finally call readString
	call readString
	cmp eax, 0 ; check if eax is 0
	jz userEndFillArr ; if eax is 0, we're done

	pop eax
	pop ecx
	inc esi
	loop fillArrLoop

jmp exitFillArr

userEndFillArr:
	pop eax
	pop ecx

exitFillArr:
	push eax ; push offset to 2d arr
	push esi ; push num of rows
	call printArr ; print the array

	; set up return val
	mov eax, esi

	; restore regs
	pop esi
	pop edx
	pop ecx

	ret

fillArr ENDP

; [ebp + 8] = num of rows
; [ebp + 12] = offset to 2d arr
printArr PROC
	push ebp ; setup base pointer
	mov ebp, esp

	cmp DWORD PTR [ebp+8], 0 ; check if num of rows is 0
	jz endOfPrintArr

	push ecx ; save ecx
	push edx
	push esi

	mov ecx, [ebp + 8] ; set ecx to num of rows
	mov esi, 0

printArrLoop:
	; edx = currRow*col + [ebp+12]
	; edx = esi*COLS + [ebp+12]
	multiplyNum esi, COLS, edx
	add edx, [ebp + 12] ; edx now is offset to the curr str in the 2d arr

	printStr edx
	call crlf

	inc esi
	loop printArrLoop

	pop esi
	pop edx
	pop ecx


endOfPrintArr:
	pop ebp
	ret 4*2 ; pop out the 2 inputs (stack 4 byte aligned)

printArr ENDP


; [ebp + 8] = prompt
; [ebp + 12] = num of strs
; [ebp + 16] = offset to 2d arr
; [ebp + 20] = return val of count
findCount PROC
	push ebp ; setup base pointer
	mov ebp, esp

	push eax
	push ebx
	push ecx
	push edx
	push esi

	mov edx, 0 ; set edx to 0 (our counter)

	printStr [ebp + 8] ; print prompt
	call ReadChar ; read char into al
	call WriteChar ; print char to the screen after reading it
	call crlf

	mov ebx, eax ; ebx = al

	; the amount of bytes we iter to is COLS * [numOfStrs]
	multiplyNum DWORD PTR [ebp + 12], COLS, ecx

	mov esi, [ebp+16] ; edi = offset to str
	cld ; clear direction flag

findCountLoop:
	lodsb ; load str byte into al
	cmp al, bl ; compare al to bl (curr char to entered str)
	jnz findCountLoopJmp ; if not equal, skip inc step

	inc edx

findCountLoopJmp:
	loop findCountLoop

	mov [ebp + 20], edx

	pop esi
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop ebp

	ret 3*4 ; pop out the 3 inputs (stack 4 byte aligned)

findCount ENDP

END main
