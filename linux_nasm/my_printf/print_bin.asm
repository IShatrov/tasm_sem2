;-------------------------------
;Prints number binary representation with leading zeros
;-------------------------------
;In:		num to print
;Out:		None
;Expect:	None
;Destroy:	rax
;		rcx
;		rdx
;		rsi
;------------------------------		
section .text
PrintBin:
		push rbp
		mov rbp, rsp
		
		mov rcx, 0x40		;amount of repeats
		mov rdx, 1		; bit mask
		mov rax, [rbp + 16]
		
		dec rbp
	
.Next:
		test rax, rdx
		
		jz .Zero
		mov byte [rbp], '1'
		jmp .Fin

.Zero:
		mov byte [rbp], '0'
.Fin:		
		shl rdx, 1
		dec rbp
		loop .Next
		
		inc rbp

		mov rax, 1	;write(rdi = where (1 for stdout), rsi = str ptr, rdx = count)
		mov rdi, 1
		mov rsi, rbp
		mov rdx, 0x40
		syscall
		
		add rbp, 0x40
		
		pop rbp
		ret


