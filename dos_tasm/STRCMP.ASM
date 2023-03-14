.model tiny
.code
org 100h

local @@

Start:		
		push offset lhs
		push offset rhs
		call strcmp
		add sp, 4		

		ret

;----------------------
; Compare two C-strings
;----------------------
;Entry:		lhs
;		rhs
;Exit:          ax = comparison result         
;Expect:	none
;Destroy:	si
;		di
;		cx
;		ax
;---------------------

strcmp		proc
		push bp
		mov bp, sp

		push [bp + 4]	;rhs
		call strlen
		add sp, 2
		push ax

		push [bp + 6]	;lhs
		call strlen
		add sp, 2

		pop cx
		cmp ax, cx
		ja @@LenAbove
		jmp @@LenBelow

@@LenAbove:
		mov cx, ax

@@LenBelow:
		inc cx
		mov si, [bp + 4] ; si = rhs
		mov di, [bp + 6] ; di = lhs

		repe cmpsb

		je @@Equal
		ja @@Above
		jb @@Below
@@Equal:
		xor ax, ax
		jmp @@Fin

@@Above:
		mov ax, -1
		jmp @@Fin

@@Below:
		mov ax, 1
		jmp @@Fin

@@Fin:
		pop bp
		ret
		endp

.data
lhs: db 'baaa', 0
rhs: db 'aaa', 0

include strlen.asm

end  Start