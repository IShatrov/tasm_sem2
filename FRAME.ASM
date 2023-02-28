.model tiny
.code
org 100h

FrameClrCode = 13h	;Colour attribute
TopLeft = 0C9h
TopRight = 0BBh
BotLeft = 0C8h
BotRight = 0BCh
Horizontal = 0CDh
Vertical = 0BAh
SpaceChar = 20h
		
local @@

Start:		
		mov ax, 0B800h
		mov es, ax

		call getnum	;x coordinate
		mov cl, 2
		mul cl
		mov word ptr offset xCoord, ax

		call getnum	;y coordinate
		mov cl, 160d
		mul cl

		add ax, word ptr offset xCoord
		mov word ptr offset FrameOffset, ax

		call getnum
		mov byte ptr offset FrameWidth, al

		call getnum
		mov dh, al	;height

		mov dl, byte ptr offset FrameWidth
		mov bx, word ptr offset FrameOffset
		
		mov si, offset DisplayString
		mov ah, FrameClrCode
		push bx
		call frame		
		add sp, 2

		ret

;----------------------
; Draw frame
;----------------------
;Entry:		Start offset
;		dl = width
;		dh = height
;		ah = color code
;		si = string offset
;Exit:          None
;Expect:	es = 0B800h
;Destroy:	ax
;		bx
;		cx
;		dx
;		si
;		di
;---------------------

frame		proc
		push bp
		mov bp, sp
		
		xor cx, cx

		sub dl, 2
		sub dh, 2

		mov di, [bp + 4]	;start offset 

		mov al, TopLeft

		mov word ptr es:[di], ax
		
		add di, 2
		mov cl, dl
		mov al, Horizontal
		rep stosw

		mov al, TopRight
		mov word ptr es:[di], ax

		mov di, [bp + 4]	;start offset
		add di, 160d
		mov cl, dh
		mov al, Vertical

		mov bx, di
@@Lines:
		mov word ptr es:[di], ax
		add di, 2
		mov al, SpaceChar

		push cx
		mov cl, dl
		rep stosw

		mov al, Vertical
		mov word ptr es:[di], ax
		pop cx
		add bx, 160d
		mov di, bx

		loop @@Lines
		
		mov al, BotLeft
		mov word ptr es:[di], ax
		add di, 2
		
		mov al, Horizontal
		mov cl, dl
		rep stosw
		
		mov al, BotRight
		mov word ptr es:[di], ax

		mov di, [bp + 4]
		add di, 160d + 2

@@WriteText:
		lodsb
		cmp al, 0
		je @@Fin
		stosw
		jmp @@WriteText

@@Fin:
		pop bp
		ret
		endp

include getnum.asm

.data
xCoord:	dw ?
FrameOffset: dw ?
FrameWidth: db ?
DisplayString: db "your ad here", 0

end  Start