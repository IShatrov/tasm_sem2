DecClrCode = 1Eh	;Colour attribute
DecStartOffset = 9DEh	;Starting offset in video memory

;----------------------
; Output number in ax in decimal through video memory
;----------------------
;Entry:		ax = number to print
;		bx = start offset in video memory
;Exit:          None
;Expect:	es = 0B800h
;Destroy:	ax
;		bx
;		cx
;		dx
;---------------------
.code
ax2dec		proc
		
		mov cx, 0Ah; number to divide by

@@Next:
		xor dx, dx
		div cx

		add dx, '0'
		
		mov byte ptr es:[bx], dl
		mov byte ptr es:[bx + 1], DecClrCode

		dec bx
		dec bx

		cmp ax, 0

		jne @@Next

		ret
		endp