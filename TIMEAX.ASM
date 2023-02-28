.286
.model tiny
.code
org 100h

Start:
		cli
		xor bx, bx
		mov es, bx
		mov bx, 4*9
	
		mov ax, es:[bx]
		mov word ptr Old09Ofs, ax
		
		mov es:[bx], offset New09
		
		mov ax, es:[bx + 2]
		mov word ptr Old09Seg, ax

		mov ax, cs
		mov es:[bx + 2], ax
		
		mov bx, 4*8
	
		mov ax, es:[bx]
		mov word ptr Old08Ofs, ax
		
		mov es:[bx], offset New08
		
		mov ax, es:[bx + 2]
		mov word ptr Old08Seg, ax

		mov ax, cs
		mov es:[bx + 2], ax
		sti

		mov dx, offset EOP
		shr dx, 4
		inc dx

		mov ax, 3100h
		int 21h

New09		proc
		push ax
	
		in al, 60h
		
		cmp al, 3
		je TurnOn
		cmp al, 4
		je TurnOff
		jmp NotMyKey

TurnOn:
		mov byte ptr ShouldWrite, 1
		jmp Fin

TurnOff:
		mov byte ptr ShouldWrite, 0

Fin:
		in al, 61h
		or al, 80h
		out 61h, al
		and al, not 80h
		out 61h, al
		mov al, 20h
		out 20h, al
		
		pop ax
		iret

NotMyKey:
		pop ax

		db 0EAh
Old09Ofs:	dw 0
Old09Seg:	dw 0

		endp

New08		proc
		push ax bx es bp cx dx
	
		mov bx, 0B800h
		mov es, bx

		mov al, byte ptr ShouldWrite
		
		cmp al, 1
		jne Done

		mov bp, sp

		mov ax, [bp + 14]
		mov bx, 160d*5 + 80d
		call ax2bin

Done:
		pop dx cx bp es bx ax

		db 0EAh
Old08Ofs:	dw 0
Old08Seg:	dw 0
			endp

include ax2bin.asm

ShouldWrite:	db 0

end Start











