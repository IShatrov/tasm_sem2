.286
.model tiny
.code
org 100h

FrameOffs = 160d*8 + 40d
FrameWidth = 12d
FrameHeight = 6

DrawReg macro StackOffset, VidOffset
		mov ax, [bp + StackOffset]
		mov bx, FrameOffs + VidOffset
		call ax2hex
		endm
		
DrawName macro NameOffset, VidOffset
		mov ah, HexClrCode
		mov si, offset NameOffset
		mov di, FrameOffs + VidOffset
		call write
		endm

local @@

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
		add dx, 18*3 + 20

		mov byte ptr ShouldWrite, 0

		mov ax, 3100h
		int 21h

New09		proc
		push ax bx cx si di es ds
	
		in al, 60h
		
		cmp al, 3
		je TurnOn
		cmp al, 4
		je TurnOff
		jmp NotMyKey

TurnOn:				
		mov ax, ds
		mov es, ax
		mov di, offset OldVidMem
		mov ax, 0B800h

		push ds

		mov ds, ax
		mov ax, FrameOffs
		mov si, ax

		mov cx, FrameHeight

SaveVid:
		push cx
		mov cx, FrameWidth
		rep movsw
		pop cx
		add ax, 160d
		mov si, ax
		loop SaveVid

		pop ds
		mov byte ptr ShouldWrite, 1

		jmp Finish

TurnOff:				
		mov byte ptr ShouldWrite, 0

		push ds

		mov si, offset OldVidMem
		mov ax, 0B800h
		mov es, ax
		mov ax, FrameOffs
		mov di, ax


		mov cx, FrameHeight

WriteVid:
		push cx
		mov cx, FrameWidth
		rep movsw
		pop cx
		add ax, 160d
		mov di, ax
		loop WriteVid

		pop ds		

Finish:
		in al, 61h
		or al, 80h
		out 61h, al
		and al, not 80h
		out 61h, al
		mov al, 20h
		out 20h, al
		
		pop ds es di si cx bx ax
		iret

NotMyKey:
		pop ds es di si cx bx ax

		db 0EAh
Old09Ofs:	dw 0
Old09Seg:	dw 0

		endp

New08		proc
		push ax bx es bp cx dx di ds

		mov bx, 0B800h
		mov es, bx

		mov al, byte ptr ShouldWrite
		
		cmp al, 1
		jne Done

		mov bp, sp

		push FrameOffs
		mov dl, FrameWidth
		mov dh, FrameHeight
		mov ah, HexClrCode
		call frame
		add sp, 2
		
		mov ax, cs
		mov ds, ax

		DrawName AxStr, 160d+2
		DrawName BxStr, 160d*2+2
		DrawName CxStr, 160d*3+2
		DrawName DxStr, 160d*4+2
		
		DrawReg 14, 160d+10d 
		DrawReg 12, 160d*2+10d
		DrawReg 6, 160d*3+10d
		DrawReg 4, 160d*4+10d

Done:
		mov al, 20h
		out 20h, al
		pop ds di dx cx bp es bx ax

		iret


		db 0EAh
Old08Ofs:	dw 0
Old08Seg:	dw 0
			endp
		
include writeln.asm
include frame.asm
include ax2hex.asm
.data
ShouldWrite:	db 0

OldVidMem: dw FrameWidth*FrameHeight DUP(0)

AxStr: db 'ax:', 0
BxStr: db 'bx:', 0
CxStr: db 'cx:', 0
DxStr: db 'dx:', 0

end Start











