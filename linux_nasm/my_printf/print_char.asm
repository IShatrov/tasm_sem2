;-------------------------------
;Prints ASCII representation of number
;-------------------------------
;In:		Char to print
;Out:		None
;Expect:	None
;Destroy:	rax
;		rcx
;		rdx
;		rsi
;------------------------------		
section .text
PrintChar:
		push rbp
		mov rbp, rsp

		mov rax, 1	;write(rdi = where (1 for stdout), rsi = str ptr, rdx = count)
		mov rdi, 1
		add rbp, 16
		mov rsi, rbp
		mov rdx, 1
		syscall
		
		pop rbp
		ret


