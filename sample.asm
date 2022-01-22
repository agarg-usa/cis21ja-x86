; Sample file

INCLUDE Irvine32.inc


.data
arr WORD 4 DUP(4 DUP(3))
arr1 WORD 3 * 2 DUP(2)


.code
main PROC
mov esi, OFFSET arr
	
exit
main endp

END main