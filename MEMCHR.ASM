.model tiny
.code
org 100h

Start:		
		push offset string
		push 'b'
		push 3
		call memchr
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

memchr		proc
		push bp
		mov bp, sp

		mov al, [bp + 6] 	;al = char
		mov di, [bp + 8]	;di = string address

		mov cx, [bp + 4]	;cx = count
		repne scasb	

		jz @@Found
		jnz @@NotFound

@@Found:
		dec di
		jmp @@Fin

@@NotFound:
		xor di, di
		jmp @@Fin

@@Fin:
		pop bp
		ret
		endp

.data
string: db 'aaqwberbw', 0

end  Start