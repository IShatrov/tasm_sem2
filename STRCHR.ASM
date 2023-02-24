.model tiny
.code
org 100h

local @@

Start:		
		push offset string
		push 0
		call strchr
		add sp, 4		

		ret

;----------------------
; Get address of first occurrence of char in initial count bytes
;----------------------
;Entry:		string address
;		char
;Exit:          di = address of first occurrence if found, 0 if not found         
;Expect:	none
;Destroy:	al
;		di
;		cx
;---------------------

strchr		proc
		push bp
		mov bp, sp

		push [bp + 6]
		call strlen
		add sp, 2

		inc ax

		push [bp + 6]
		push [bp + 4]
		push ax
		call memchr
		add sp, 6
					
		pop bp
		ret
		endp

.data
string: db 'aaqwberbw', 0

include strlen.asm
include memchr.asm

end  Start