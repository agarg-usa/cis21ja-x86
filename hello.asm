; hello world in assembly

INCLUDE Irvine32.inc


.data
greeting BYTE "hello world", 0ah, 0dh, 0

.code
main PROC
	mov edx, OFFSET greeting
	call writeString
    call crlf
	exit
main ENDP
END main