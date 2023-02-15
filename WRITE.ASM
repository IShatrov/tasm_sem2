.model tiny
.code
org 100h

Start:		
	mov ax, 0b800h		      ;store address of display segment at es
	mov es, ax

	mov bx, 80h                   ;save # of letters in cl
	mov cl, byte ptr [bx]
	dec cl 

	mov dh, 0CBh		      ;save initial colour attribute at dh	

	xor bx, bx		      ;bx = 0

WriteChar:		
	mov dl, byte ptr [bx + 82h]   ;dl = str[bx]
	
	mov al, 2h		      ;ax = 2*bx
	mul bl

	xchg ax, bx		      ;ax, bx = bx, ax

	mov byte ptr es:[bx + 7D0h], dl		;save letter
	mov byte ptr es:[bx + 7D1h], dh		;save colour attribute

	xchg ax, bx		      ;ax, bx = bx, ax
	
	inc bx			      ;bx++
	inc dh			      ;dh++

	loop WriteChar		      ;while(cl > 0)

	mov ax, 4c00h		      ;exit(0)
	int 21h


end	Start
