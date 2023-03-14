.model tiny
.code
org 100h

local @@

Start:		
		push offset lhs
		push offset rhs
		push 5
		call memcmp
		add sp, 6		

		ret

;----------------------
; Compare count bytes from lhs and rhs
;----------------------
;Entry:		lhs
;		rhs
;		count
;Exit:          ax = comparison result         
;Expect:	none
;Destroy:	si
;		di
;		cx
;		ax
;---------------------

memcmp		proc
		push bp
		mov bp, sp

		mov cx, [bp + 4] ;cx = count
		mov si, [bp + 6] ; si = rhs
		mov di, [bp + 8] ; di = lhs

		repe cmpsb

		je @@Equal
		ja @@Above
		jb @@Below
@@Equal:
		xor ax, ax
		jmp @@Fin

@@Above:
		mov ax, 1
		jmp @@Fin

@@Below:
		mov ax, -1
		jmp @@Fin

@@Fin:
		pop bp
		ret
		endp

.data
lhs: db 'aaaaaa', 0
rhs: db 'aaaaa', 0

end  Start