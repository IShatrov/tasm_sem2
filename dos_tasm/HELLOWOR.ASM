.model tiny				;set memory model
.code					;highlight that commands are below
org 100h				;memory offset

Start:		mov ah, 9h		;puts(dx)
		mov dx, offset msg	;get address of msg
		Int 21h			;system call
		
		mov ax, 4c00h		;exit(0)
		Int 21h			;system call

msg:		db 'I hear the machine spirit`s voice\n aaa /n aaa$'	;define bytes for msg

end		Start