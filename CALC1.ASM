.model tiny
.code
org 100h

locals @@

Start:
	mov ax, 0B800h
	mov es, ax

	call getnum
	mov byte ptr num1, al
	
	call getnum
	mov byte ptr num2, al

	mov al, byte ptr num1 ;get sum and output in 3 systems
	add al, byte ptr num2	
	mov bx, 64Ah
	call ax2bin
	mov bx, 70Eh
	call ax2hex
	mov bx, 9DEh
	call ax2dec

	mov al, byte ptr num1
	sub al, byte ptr num2
	mov bx, 6EAh
	call ax2bin
	mov bx, 7AEh
	call ax2hex
	mov bx, 0A7Eh
	call ax2dec

	mov al, byte ptr num1
	mov bl, byte ptr num2
	mul bl
	mov bx, 6EAh + 160d
	call ax2bin
	mov bx, 7AEh + 160d
	call ax2hex
	mov bx, 0A7Eh + 160d
	call ax2dec

	mov al, byte ptr num1
	mov bl, byte ptr num2
	div bl
	xor ah, ah
	mov bx, 6EAh + 320d
	call ax2bin
	mov bx, 7AEh + 320d
	call ax2hex
	mov bx, 0A7Eh + 320d
	call ax2dec
	
	ret

include ax2bin.asm
include ax2hex.asm
include ax2dec.asm
include getnum.asm

.data
num1: db ?
num2: db ?

end Start