global _start

section .text

%include "print_str.asm"
%include "print_char.asm"
%include "print_bin.asm"

_start:
		push arg2
		push arg1
		push fmtStr
		call MyPrintf
		add sp, 8*3

		mov rax, 0x3C	;exit(rdi = exit code = 0)
		xor rdi, rdi
		syscall
		
;-----------------------------------------------
;	main end
	
MyPrintf:
		push rbp
		mov rbp, rsp
		
		mov rcx, [rbp + 16]
		
		add rbp, 16 + 8		;make rbp point to 1st arg

.Continue:	
		xor rdx, rdx	
		mov rsi, rcx
.Next:
		cmp byte [rsi], 0
		je .Write
		cmp byte [rsi], '%'
		je .Write
		inc rdx
		inc rsi
		jmp .Next

.Write:
		mov rax, 1	;write(rdi = where (1 for stdout), rsi = str ptr, rdx = count)
		mov rdi, 1
		mov rsi, rcx
		push rcx
		syscall
		pop rcx
		add rcx, rdx
		
		cmp byte [rcx], 0
		je .Fin
		cmp byte [rcx], '%'
		je .Str
		
.Str:
		push rcx
		push qword [rbp]
		call PrintStr
		add sp, 8
		add rbp, 8
		pop rcx
		inc rcx
		jmp .Continue				
		
.Fin:		
		pop rbp
		ret

section .data

fmtStr: db "sussus % amogus % momogus", 0xA, 0
arg1:	db "aaa", 0
arg2:	db "bbb", 0

