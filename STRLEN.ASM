.model tiny
.code
org 100h

Start:		
	;	mov ax, 0B800h
	;	mov es, ax

		push offset string
		call strlen
		add sp, 2		

		ret

;----------------------
; Get length of C-string
;----------------------
;Entry:		string address
;Exit:          ax = strlen
;Expect:	none
;Destroy:	ax
;		di
;		cx
;---------------------

strlen		proc
		push bp
		mov bp, sp

		mov al, 0 	;null terminator
		mov di, [bp + 4]	;di = string address

		mov cx, 100h	;max str len
		repne scasb	

		mov ax, di		;ax = strlen
		sub ax, [bp + 4]
		dec ax

		pop bp
		ret
		endp

include ax2dec.asm

.data
string: db 'qwe', 0

end  Start