.model tiny
.code
org 100h

FrameClrCode = 1Eh	;Colour attribute
TopLeft = 0C9h
TopRight = 0BBh
BotLeft = 0C8h
BotRight = 0BCh
Horizontal = 0CDh
Vertical = 0BAh

PutChar macro char, incr
		mov byte ptr es:[bx], char
;		mov byte ptr es:[bx + 1], FrameClrCode
		add bx, incr
		endm
		
local @@

Start:		
		mov ax, 0B800h
		mov es, ax

		call getnum	;x coordinate
		mov cl, 2
		mul cl
		mov word ptr offset xCoord, ax

		call getnum	;y coordinate
		mov cl, 0A0h
		mul cl

		add ax, word ptr offset xCoord
		mov word ptr offset FrameOffset, ax

		call getnum
		mov byte ptr offset FrameWidth, al

		call getnum
		mov dh, al	;height

		mov dl, byte ptr offset FrameWidth
		mov bx, word ptr offset FrameOffset

		call frame		

		ret

;----------------------
; Draw frame
;----------------------
;Entry:		bx = top left corner offset in video memory
;		dl = width
;		dh = height
;Exit:          None
;Expect:	es = 0B800h
;Destroy:	ax
;		bx
;		cx
;		dx
;---------------------

frame		proc
		
		xor cx, cx

		sub dl, 2
		sub dh, 2
		
		PutChar TopLeft, 2

		mov cl, dl

@@DrawHoriz1:	
		PutChar Horizontal, 2
		loop @@DrawHoriz1  

		PutChar TopRight, 0A0h
		
		mov cl, dh
		
@@DrawVert1:	
		PutChar Vertical, 0A0h
		loop @@DrawVert1 

		PutChar BotRight, -2
		
		mov cl, dl

@@DrawHoriz2:	
		PutChar Horizontal, -2
		loop @@DrawHoriz2

		PutChar BotLeft, -0A0h
		
		mov cl, dh
		
@@DrawVert2:	
		PutChar Vertical, -0A0h
		loop @@DrawVert2 

		ret
		endp

include getnum.asm

.data
xCoord:	dw ?
FrameOffset: dw ?
FrameWidth: db ?

end  Start