;-------------------------------
;Prints null-terminared string
;-------------------------------
;In:		string ptr
;Out:		None
;Expect:	None
;Destroy:	rax
;		rcx
;		rdx
;		rsi
;------------------------------		
section .text
PrintStr:
		push rbp
		mov rbp, rsp
		
		xor rdx, rdx
		mov rsi, [rbp + 16]
	
.Next:				;get strlen
		cmp byte [rsi], 0
		je .Write
		inc rdx
		inc rsi
		jmp .Next

.Write:
		mov rax, 1	;write(rdi = where (1 for stdout), rsi = str ptr, rdx = count)
		mov rdi, 1
		mov rsi, [rbp + 16]
		syscall
		
		pop rbp
		ret


