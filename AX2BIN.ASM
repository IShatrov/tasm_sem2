BinClrCode = 29h	;Colour attribute
BinStartOffset = 64Ah	;Starting offset in video memory

;----------------------
; Output number in ax in binary through video memory
;----------------------
;Entry:		ax = number to print
;		bx = start offset
;Exit:          None
;Expect:	es = 0B800h
;Destroy:	cx
;		bx
;		dx
;---------------------
.code
ax2bin		proc

		mov cx, 10h                 ; set amount of repeats
		mov dx, 8000h               ; dx = 1000 0000 0000 0000b		

@@Next:
		test ax, dx

		jz @@WriteZero              ; if ax && dx = 0, jump
		mov byte ptr es:[bx], '1'
		mov byte ptr es:[bx + 1], BinClrCode
		jmp @@Fin
 		
@@WriteZero:
		mov byte ptr es:[bx], '0'
		mov byte ptr es:[bx  + 1], BinClrCode
		
@@Fin:
		inc bx
		inc bx
		shr dx, 1

		loop @@Next		

		ret
		endp