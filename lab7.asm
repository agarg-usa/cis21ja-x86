TITLE  Lab 7: Calculate time difference with procedures

; Name: Aryan Garg


INCLUDE Irvine32.inc

printStr MACRO strAddr
	push edx
	mov edx, strAddr
	call WriteString
	pop edx
ENDM

.data
hrStr BYTE "Enter hour (0-23): ", 0
mnStr BYTE "Enter minute (0-59): ", 0
timeErrStr BYTE "Invalid input", 0ah, 0dh, 0

diffErrStr BYTE "Invalid time difference, check your times", 0ah, 0dh, 0

hrOutStr BYTE " hours, ", 0
mnOutStr BYTE " minutes", 0ah, 0dh, 0

timeArr BYTE ?, ?		; array of: start total minutes, end total minutes
diffHr BYTE ?			; time difference, hours portion
diffMin BYTE ?			; time difference, minutes portion

.code
main PROC

top :
	; 1. read time: pass arguments through *registers*
	;; call readTime proc and pass first 3 strings and timeArr
	mov eax, OFFSET hrStr
	mov ebx, OFFSET mnStr
	mov ecx, OFFSET timeErrStr
	mov edx, OFFSET timeArr
	call readTime


	; 2. find difference: pass arguments through *the stack*
	;; call findDiff proc and pass timeArr, diffHr, diffMin
	push eax ; space for return value
	push OFFSET diffHr
	push OFFSET diffMin
	push OFFSET timeArr
	call findDiff

	pop eax ; remove return value
	cmp eax, 1 ; if findDiff returns 1, then there was an error
	je invalidDiff



	; 3. based on return value, either:
	; a) print result
	movzx eax, diffHr
	call writeDec
	printStr OFFSET hrOutStr ;; write code to use macro to print hrOutStr


	movzx eax, diffMin
	call writeDec
	printStr OFFSET mnOutStr ;; write code to use macro to print mnOutStr
	jmp theEnd

	; or b) print error message
	invalidDiff :
	printStr OFFSET diffErrStr ;; write code to use macro to print diffErrStr


	theEnd:
	jmp top      ; create infinite loop for testing

	exit
main ENDP


readTime PROC

	push ebp ; setup stack frame base pointer
	mov ebp, esp

	; push 041414141h ; ebp  - 4
	; push 042424242h ; ebp  - 8
	; push 043434343h ; ebp  - 12
	; push 044444444h ; ebp  - 16

	push esi ; save esi register, ebi - 4

	push eax ; ebp - 8 = hourStr
	push ebx ; ebp - 12 = mnStr
	push ecx ; ebp - 16 = timeErrStr
	push edx ; ebp - 20 = timeArr

	Start:
	mov si, 0

	HourInput:

		mov eax, [ebp - 8] ; move the char* hrStr at ebp-8 into eax
		printStr eax ; print hour input str

		call ReadInt ; reads hour into EAX
		cmp eax, 0
		jl InvalidInput ; if hour < 0, jump to InvalidInput
		cmp eax, 23
		jg InvalidInput ; if hour > 23, jump to InvalidInput

		mov ch, al ; stores hour into ch


	MinuteInput:
		mov eax, [ebp - 12] ; move the char* mnStr at ebp-12 into eax
		printStr eax ; print minute input str

		call ReadInt ; reads minute into EAX
		cmp eax, 0
		jl InvalidInput ; if minute < 0, jump to InvalidInput
		cmp eax, 59
		jg InvalidInput ; if minute > 59, jump to InvalidInput
		mov cl, al ; stores minute into cl

		cmp si, 1
		je Store ; if si is 1, then we got input for both times and can now store them

		; else we need to initialize the second pair of hour / minute and increment si
		mov si, 1
		mov bl, cl ; move first minute into bl
		mov bh, ch ; move first hour into bh
		jmp HourInput

	InvalidInputReset:
		mov esi, 0
	InvalidInput:
		mov eax, [ebp - 16] ; move the char* errStr at ebp-16 into eax
		printStr eax ; print error input str
		jmp HourInput ; restart input process


	Store:
		mov al, 60
		mul bh ; multiply first hour by 60
		jc InvalidInputReset ; jump if overflow err

		add al, bl ; add first minute to the result
		jc InvalidInputReset

		; al now stores the total minutes for the first pair (ebx is free for us to use)
		; we need to move this into the timeArr[0]
		; we know [ebp-20] gives us the address of timeArr[0]
		mov ebx, [ebp - 20]
		; ebx now equals the address of timeArr
		; now we set the first elem of timeArr to the total minutes
		mov [ebx + 0], al ; move the result into first element of Time Array

		; now do the same for the other pair
		mov al, 60
		mul ch ; multiply second hour by 60
		jc InvalidInputReset

		add al, cl ; add second minute to the result
		jc InvalidInputReset

		; move the result into second element of Time Array
		mov ebx, [ebp - 20]
		mov [ebx + 1], al

	; now that we are done, we need to pop back edx, ecx, ebx, eax, esi, and ebp
	pop edx
	pop ecx
	pop ebx
	pop eax
	pop esi
	pop ebp
	ret ; return from readTime

readTime ENDP


findDiff PROC
	; ebx + 4 = return address
	; ebx + 8 = timeArr
	; ebx + 12 = diffMin
	; ebx + 16 = diffHr
	; ebx + 20 = return val


	push ebp ; setup stack frame base pointer
	mov ebp, esp

	; save registers
	push eax
	push ebx
	push ecx

	mov eax, [ebp + 8] ; timeArr address

	mov bl, [eax + 0] ; first time (min)
	mov cl, [eax + 1] ; second time (min)

	sub bl, cl ; subtract the end pair from the start pair
	jc MismatchError ; if result is negative, jump to MismatchError

	; bl now contains the minute difference between the two pairs of hour / minute
	; now to convert back to number of hours and min we need to divide by 60

	mov ah, 0
	mov al, bl
	mov bl, 60
	div bl ; divide totalMin by 60

	; ah now contains the number of minutes
	; al now contains the number of hours

	mov ebx , [ebp + 16] ; diffHr address
	mov [ebx], al ; set diffHr to al

	mov ebx, [ebp + 12] ; diffHr address
	mov [ebx], ah ; set diffMin to ah
	jmp Success

MismatchError:
	mov DWORD PTR [ebp+20], 1 ; set return val to 1
	jmp Restore

Success:
	mov DWORD PTR [ebp+20], 0 ; set return val to 0

Restore:
	pop ecx
	pop ebx
	pop eax
	pop ebp
	ret 4*3 ; pop out the 3 inputs (4 bytes each)
findDiff ENDP


END main