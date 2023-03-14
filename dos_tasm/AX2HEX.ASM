HexClrCode = 62h	;Colour attribute
HexStartOffset = 70Eh	;Starting offset in video memory

;----------------------
; Output number in ax in hex through video memory
;----------------------
;Entry:		ax = number to print
;		bx = start offset in video memory
;Exit:          None
;Expect:	es = 0B800h
;Destroy:	bx
;		dl
;		cx
;---------------------
.code
ax2hex		proc

		mov cx, 4

@@Next:		mov word ptr offset @@CurrentOffset, bx
		mov word ptr offset @@CurrentCX, cx		

		mov bx, ax
		
		dec cx
		jz @@EndShift		
		
@@Shift:	shr bx, 4
		loop @@Shift
@@EndShift:


		and bx, 0Fh; 0000 0000 0000 1111b		

		mov cx, word ptr offset @@CurrentCX

		mov dl, byte ptr @@HexDigits[bx]

		mov bx, word ptr @@CurrentOffset

		mov byte ptr es:[bx], dl
		mov byte ptr es:[bx + 1], HexClrCode

		inc bx
		inc bx 	

		loop @@Next	

		ret

.data
@@HexDigits: db '0123456789ABCDEF'
@@CurrentOffset: dw ?
@@CurrentCX:	dw ?

		endp