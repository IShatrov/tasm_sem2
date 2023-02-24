.model tiny
.code
org 100h

Start:		
		push offset dest
		push offset src
		push 5
		call memmove
		add sp, 6		

		ret

;----------------------
; Copy count bytes from src to dest using buffer
;----------------------
;Entry:		dest
;		src
;		count
;Exit:          none         
;Expect:	none
;Destroy:	si
;		di
;		cx
;		bx
;---------------------

memmove		proc
		push bp
		mov bp, sp

		mov bx, sp		;bx points to buffer
		sub bx, [bp + 4]

		mov cx, [bp + 4]	;copy from src to buffer
		mov si, [bp + 6]
		mov di, bx
		rep movsb

		mov cx, [bp + 4]	;copy from buffer to dest
		mov si, bx
		mov di, [bp + 8]
		rep movsb

		pop bp
		ret
		endp

.data
src: db 'aaqwberbw', 0
dest: db 10h dup(?)

end  Start