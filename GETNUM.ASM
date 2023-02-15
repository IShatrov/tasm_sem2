.model tiny
.code
org 100h

Start:		
		call GetNum		

		ret

;----------------------
; Reads decimal number from stdin and stores it
;----------------------
;Entry:		None
;Exit:          ax = read number, 0 <= ax <= 255
;Expect:	None
;Destroy:	ax
;		bx
;		cx
;		dx
;---------------------

GetNum		proc
		
??Buffer:	db 6 dup(?)

		xor cx, cx
		
		mov byte ptr ??Buffer, 4h ;max chars to read + 1
		mov dx, offset ??Buffer   ; make dx point to buffer for system call

		mov ah, 0Ah ;buffered input
		int 21h

		mov bx, offset ??Buffer
		inc bx	;make bx point to amount of chards read

		mov cl, byte ptr [bx] ;cx = amount of chars read

		add bl, cl  ;bx points to last char read
	
??Ans:		db ?
??Multiplier	db ?

		mov byte ptr offset ??Ans, 0
		mov byte ptr offset ??Multiplier, 1
		xor ax, ax
		xor dx, dx

??Next:
		mov al, byte ptr [bx]
		sub al, '0' 
		mov dl, byte ptr offset ??Multiplier

		mul dl
		add al, byte ptr offset ??Ans

		mov byte ptr offset ??Ans, al 
		dec bx

		mov al, dl
		mov dl, 0Ah
		mul dl
		mov byte ptr offset ??Multiplier, al

		loop ??Next
		
		mov al, byte ptr offset ??Ans
		xor ah, ah

		ret
		endp

end  Start