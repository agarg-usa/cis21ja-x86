
INCLUDE Irvine32.inc

.data

myArr WORD 1,2,3

.code
main PROC
	mov eax, OFFSET myArr
	mov ebx, LENGTHOF myArr
	call diff
	exit
main ENDP

diff PROC
push ecx
push esi

mov esi, eax

mov cx, WORD PTR [esi]
mov eax, 2
sub ebx, 1 ; ebx -= 1 
mul ebx ; eax = 2*ebx
add ebx, esi
mov ax, WORD PTR[ebx]
sub ax, cx
jc ERR
jnc THEEND

ERR:
mov eax, -1

THEEND:
pop esi
pop ecx

diff ENDP


END main