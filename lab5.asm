TITLE  Lab 5: Calculate time difference

; Name: Aryan Garg


INCLUDE Irvine32.inc


.data
enterHour BYTE "Enter hour: ", 0
enterMinute BYTE "Enter minute: ", 0
invalidInputStr BYTE "Invalid input", 0
overflowErrStr BYTE "Overflow error: Time inputted too large", 0
mismatchErrStr BYTE "Mismatch error: Start Time > End Time", 0
hoursStr BYTE " hours, ", 0
minutesStr BYTE " minutes", 0
continueStr BYTE "Continue? (y/n): ", 0


.code
main PROC

; ch and cl stores one pair of hour / minute
; bh and bl store the other pair of hour / minute
; if SI register is 0, then we are initializing the first pair of hour / minute
; if SI register is 1, then we are initializing the second pair of hour / minute

Start:
mov si, 0

HourInput:
	mov edx, OFFSET enterHour
	call WriteString ; promps user to enter an hour
	call ReadInt ; reads hour into EAX
	cmp eax, 0
	jl InvalidInput ; if hour < 0, jump to InvalidInput
	cmp eax, 23
	jg InvalidInput ; if hour > 23, jump to InvalidInput

	mov ch, al ; stores hour into ch


MinuteInput:
	mov edx, OFFSET enterMinute
	call WriteString ; promps user to enter a minute
	call ReadInt ; reads minute into EAX
	cmp eax, 0
	jl InvalidInput ; if minute < 0, jump to InvalidInput
	cmp eax, 59
	jg InvalidInput ; if minute > 59, jump to InvalidInput
	mov cl, al ; stores minute into cl

	cmp si, 1
	je Calculate ; if si is 1, then we can move onto calculating the time difference
	; else we need to initialize the second pair of hour / minute and increment si
	mov si, 1
	mov bl, cl ; move first minute into bl
	mov bh, ch ; move first hour into bh
	jmp HourInput


Calculate:
	mov al, 60
	mul bh ; multiply first hour by 60
	jc OverflowError ; jump if overflow err

	add al, bl ; add first minute to the result
	; ax now equals the total number of minutes in the first pair of hour / minute
	jc OverflowError

	mov bl, al ; move the result into bl

	; now do the same for the other pair
	mov al, 60
	mul ch ; multiply second hour by 60
	jc OverflowError

	add al, cl ; add second minute to the result
	jc OverflowError

	mov cl, al ; move the result into cl

	; bl now contains total minutes for end pair
	; cl now contains total minutes for start pair

	sub bl, cl ; subtract the end pair from the start pair
	jc MismatchError
	; bl now contains the minute difference between the two pairs of hour / minute
	; now to convert back to number of hours and min we need to divide by 60

	mov ah, 0
	mov al, bl
	mov bl, 60
	div bl ; divide totalMin by 60


	; ah now contains the number of minutes
	; al now contains the number of hours
	mov bh, al ; set bh to num of hours
	mov bl, ah ; set bl to num of minutes

	mov eax, 0
	; now we need to print the result
	mov al, bh
	call WriteDec ; print number of hours
	mov edx, OFFSET hoursStr
	call WriteString ; print number of hours
	mov al, bl
	call WriteDec ; print number of minutes
	mov edx, OFFSET minutesStr
	call WriteString ; print number of minutes
	call Crlf

Continue:
	mov edx, OFFSET continueStr
	call WriteString ; prompt user to continue
	call ReadChar ; read user input into AL
	call WriteChar
	call Crlf
	cmp al, 'y'
	je Start ; if user input is y, then jump to start
	cmp al, 'Y'
	je Start
	cmp al, 'n'
	je EndOfProgram ; if user input is n, then jump to Exit
	cmp al, 'N'
	je EndOfProgram

	mov edx, OFFSET invalidInputStr
	call WriteString ; print invalid input
	call Crlf
	jmp Continue ; if user input is not y or n, then jump to Continue



InvalidInput:
	mov edx, OFFSET invalidInputStr
	call WriteString ; prints invalid input message
	call Crlf
	jmp HourInput ; restart input process

OverflowError:
	mov edx, OFFSET overflowErrStr
	call WriteString ; prints overflow error message
	call Crlf
	jmp Start ; restart input process

MismatchError:
	mov edx, OFFSET mismatchErrStr
	call WriteString ; prints mismatch error message
	call Crlf
	jmp Start ; restart input process

EndOfProgram:
	exit
main ENDP

END main