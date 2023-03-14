.model tiny
.code
org 100h

Start:		
		push offset dest
		push offset src
		push 5
		call memcpy
		add sp, 6		

		ret

;----------------------
; Get address of first occurrence of char in initial count bytes
;----------------------
;Entry:		string address
;		char
;		count
;Exit:          di = address of first occurrence if found, 0 if not found         
;Expect:	none
;Destroy:	al
;		di
;		cx
;---------------------

memcpy		proc
		push bp
		mov bp, sp

		mov cx, [bp + 4] ;cx = count
		mov si, [bp + 6] ; si = src
		mov di, [bp + 8] ; di = dest

		rep movsb

		pop bp
		ret
		endp

.data
src: db 'aaqwberbw', 0
dest: db 10h dup(?)

end  Start