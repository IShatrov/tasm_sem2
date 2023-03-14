.model tiny
.code
org 100h

Start:		
		push offset dest
		push offset src
		call memcpy
		add sp, 6		

		ret

;----------------------
; Copy C-string from src to dest
;----------------------
;Entry:		dest
;		src
;		count
;Exit:          none         
;Expect:	none
;Destroy:	si
;		di
;		cx
;		ax
;---------------------

memcpy		proc
		push bp
		mov bp, sp

		push [bp + 4]
		call strlen
		add sp, 2

		mov cx, ax
		inc cx
		mov si, [bp + 4] ; si = src
		mov di, [bp + 6] ; di = dest

		rep movsb

		pop bp
		ret
		endp

.data
src: db 'aaqwberbw', 0
dest: db 10h dup(?)

include strlen.asm

end  Start