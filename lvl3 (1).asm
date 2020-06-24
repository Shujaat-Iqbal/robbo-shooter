.model large
.stack 100h
.data
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;to draw square and other rectangles
point struc
	x dw ?	;xaxis
	y dw ?	;yaxis
	sx dw ?	;size of rows and column
	sy dw ?
	color db ?	;color of pixels
point ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
p1 point <>	

	t1 dw ?	;temporary variables for loops etc.
	t2 dw ?

	xa dw ?	;quardinates of robot
	ya dw ?

	score dw 00	;score and health
	health db 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;to draw cannons
cannon struc
	xax dw ?
	yax dw ?
	clr db ?
	life db 25
cannon ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	c1 cannon <>	;cannon1
	tc cannon <>	;temporary cannon for displaying purpose

	tx db ?	;temporary x and y axis variables for displaying purpose
	ty db ?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;some strings used
	c1life db  "Cannon1",'$'
	c2life db  "Cannon2",'$'
	rlife  db  "Health",'$'
	lose   db  "You lost",'$'
	lose1  db  "Both cannons were not distroyed",'$'
	lose2  db  "on given health",'$'
	win    db  "Congratulations",'$'
	win1   db  "you won",'$'
	pa     db  "pause",'$'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;variables needed to move cannons
	cannonc db 00
	cannonc1 db 00
	cannonc01 db 00
	cannonc2 db 00
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	counter dw ?	;to print character counter,their ASCII
	asc db ?
;some other strings
	scr db "score",'$'
	lvl db "level",'$'
	level db 1
;temporary variables for checks
	t dw ?
	count1 db 00
	count2 db 00
;shoot structure for cannons and robot
shoot struc

		xax dw ?
		yax dw ?
		clr db ?

shoot ends

		ca1 shoot <>	;cannon1 shoot
		ca2 shoot <>	;cannon1 shoot2
		ca3 shoot <>	;cannon1 shoot3
		rob2 shoot <>	;cannon2 shoot
		rob shoot <>	;robot shoot

;variables for checks provided for shooting purpose
	shcount1 dw ?
	shchk1 db ?
	shchk01 db ?
	shchk2 db ?
	rchk db ?
	rchk1 db ?



;to display multidigit number like score in characters
	digitCount db 0  
	enteredNumber dw 00
	
	
	
	
	lr db 1
	
	rchk0 db ?
	rchk01 db ?
 
.code
	mov ax,@data
	mov ds,ax


Main proc

	mov ax,@data
	mov ds,ax
	;robot co-ordinates
		mov xa,125
		mov ya,25
	;cannon1 values
		mov c1.xax,25
		mov c1.yax,0
		mov c1.clr,28
;initializing all variables to zero for check purpose later
		mov shchk1,00
		mov shchk2,00
		mov shcount1,00
		
		mov count1,00
		mov count2,00
		
		mov rchk,00
		mov rchk1,00
		
		mov cannonc1,00
		mov cannonc2,00
		mov cannonc,00
;main work starts
	Repeat1:
		jmp jout
		
		Goout:
		
		call Display	;displays everything onscreen
		jout:
		;clear buffer
		mov ah,0Ch
		int 21h

			;Timer
				MOV     CX, 01h
				MOV     DX, 0;FFFFh;   CX:DX      Number of microseconds to elapse
				mov 	al,0
				MOV     AH, 86H
				INT     15H

				call Display

			;if lose
			cmp health,00
			je golose
			cmp health,60
			ja golose

		; if cannon 1 dies then cannonc1=1
			cmp C1.life,00
			je ic1
			jmp nic1

		ic1:
		
			mov cannonc1,1

		nic1:

;			mov cannonc2,1


		;update detailes of cannons i.e. both dead or alive
			mov al,cannonc1
			mov ah,cannonc2
			add al,ah
			mov cannonc,al

			cmp cannonc,2
			je gowing
					
					
					
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;moves cannon1 shoots and update health

			cmp cannonc1,00
			je movec1
			jmp dnmc1

		movec1:
		
			cmp shchk1,00
			je check1
			jmp end1
		check1:

			mov ax,c1.xax
			mov bx,c1.yax
			add bx,28
			add ax,35

			mov ca1.xax,ax
			mov ca1.yax,bx
			mov ca1.clr,40

			mov shchk1,1
		end1:
		
			cmp shchk1,1
			je check2
			jmp end2
			check2:
			cmp ca1.xax,120
			jae dech
		r1:
			cmp ca1.xax,155
			jae dech1
		r:
			cmp ca1.xax,180
			jae redo
			jmp go
		redo:

			mov shchk1,00
			jmp end2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		go:
		
			add ca1.xax,3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		end2:
		
			jmp ee
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		dech:

		mov ax,ya
		sub ax,4
		mov shcount1,ax
		cmp ca1.yax,ax
		ja d2
		jmp r1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d2:
		
			add shcount1,45
			mov ax,shcount1
			cmp ca1.yax,ax
			jb de
			jmp r1
		
		dech1:
		cmp lr,1
		je decright
		jmp decleft
		
		decright:
		mov ax,ya
		sub ax,4
		mov shcount1,ax
		cmp ca1.yax,ax
		ja d
		jmp r
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d:
		
			add shcount1,65
			mov ax,shcount1
			cmp ca1.yax,ax
			jb de
			jmp r
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		decleft:
		mov ax,ya
		sub ax,25
		mov shcount1,ax
		cmp ca1.yax,ax
		ja d1
		jmp r
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d1:
		
			add shcount1,45
			mov ax,shcount1
			cmp ca1.yax,ax
			jb de
			jmp r
		
		de:

		dec health
		mov shchk1,00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ee:

		jmp nc1
		dnmc1:
		
			mov ca1.xax,00
			mov ca1.yax,00
			mov ca1.clr,00
		nc1:

		
;cannon shoot2



			cmp cannonc01,00
			je movec10
			jmp dnmc10

		movec10:
		
			cmp shchk01,00
			je check10
			jmp end10
		check10:

			mov ax,c1.xax
			mov bx,c1.yax
			add bx,12
			add ax,35

			mov ca2.xax,ax
			mov ca2.yax,bx
			mov ca2.clr,41

			mov shchk01,1
		end10:
		
			cmp shchk01,1
			je check20
			jmp end20
			check20:
			cmp ca2.xax,120
			jae dech0
		r10:
			cmp ca2.xax,155
			jae dech10
		r0:
			cmp ca2.xax,180
			jae redo0
			jmp go0
		redo0:

			mov shchk01,00
			jmp end20
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		go0:
		
			add ca2.xax,3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		end20:
		
			jmp ee0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		dech0:

		mov ax,ya
		sub ax,4
		mov shcount1,ax
		cmp ca2.yax,ax
		ja d20
		jmp r10
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d20:
		
			add shcount1,45
			mov ax,shcount1
			cmp ca2.yax,ax
			jb de0
			jmp r10
		
		dech10:
		cmp lr,1
		je decright0
		jmp decleft0
		
		decright0:
		mov ax,ya
		sub ax,4
		mov shcount1,ax
		cmp ca2.yax,ax
		ja d0
		jmp r0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d0:
		
			add shcount1,65
			mov ax,shcount1
			cmp ca2.yax,ax
			jb de0
			jmp r0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		decleft0:
		mov ax,ya
		sub ax,25
		mov shcount1,ax
		cmp ca2.yax,ax
		ja d10
		jmp r0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d10:
		
			add shcount1,45
			mov ax,shcount1
			cmp ca2.yax,ax
			jb de0
			jmp r0
		
		de0:

		dec health
		mov shchk01,00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ee0:

		jmp nc10
		dnmc10:
		
			mov ca2.xax,00
			mov ca2.yax,00
			mov ca2.clr,00
		nc10:



			cmp cannonc2,00
			je movec101
			jmp dnmc101

		movec101:
		
			cmp shchk2,00
			je check101
			jmp end101
		check101:

			mov ax,c1.xax
			mov bx,c1.yax
			add bx,44
			add ax,35

			mov ca3.xax,ax
			mov ca3.yax,bx
			mov ca3.clr,40

			mov shchk2,1
		end101:
		
			cmp shchk2,1
			je check201
			jmp end201
			check201:
			cmp ca3.xax,120
			jae dech01
		r101:
			cmp ca3.xax,155
			jae dech101
		r01:
			cmp ca3.xax,180
			jae redo01
			jmp go01
		redo01:

			mov shchk2,00
			jmp end201
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		go01:
		
			add ca3.xax,3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		end201:
		
			jmp ee01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		dech01:

		mov ax,ya
		sub ax,4
		mov shcount1,ax
		cmp ca3.yax,ax
		ja d201
		jmp r101
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d201:
		
			add shcount1,45
			mov ax,shcount1
			cmp ca3.yax,ax
			jb de01
			jmp r101
		
		dech101:
		cmp lr,1
		je decright01
		jmp decleft01
		
		decright01:
		mov ax,ya
		sub ax,4
		mov shcount1,ax
		cmp ca3.yax,ax
		ja d01
		jmp r01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d01:
		
			add shcount1,65
			mov ax,shcount1
			cmp ca3.yax,ax
			jb de01
			jmp r01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		decleft01:
		mov ax,ya
		sub ax,25
		mov shcount1,ax
		cmp ca3.yax,ax
		ja d101
		jmp r01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d101:
		
			add shcount1,45
			mov ax,shcount1
			cmp ca3.yax,ax
			jb de01
			jmp r01
		
		de01:

		dec health
		mov shchk2,00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ee01:

		jmp nc101
		dnmc101:
		
			mov ca3.xax,00
			mov ca3.yax,00
			mov ca3.clr,00
		nc101:








			cmp cannonc1,00
			je moveca1
			jmp dnmca1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		moveca1:


		
;move cannons
				cmp count1,00
				je chk1
				jmp e1
			chk1:

					add C1.yax,2
					e1:
					cmp count1,1
					je chk2
					jmp e2
				chk2:

					sub C1.yax,2
				e2:
					mov ax,319
					sub ax,60
					cmp c1.yax,ax
					jae con1
					jmp e3
				con1:
					mov count1,1
				e3:
					cmp c1.yax,0
					je con2
					jmp e4
				con2:
					mov count1,00
					e4:

				jmp nca1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; for dead cannon
		dnmca1:
		
				mov c1.clr,39
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		nca1:

					
		;end cannons move

;robot shoot and update cannons health and score
		cmp rchk1,1
		je rshot
		jmp ree
	rshot:
		cmp rchk,00
		je rcheck1
		jmp rend1
	rcheck1:
		mov ax,xa
		mov bx,ya
		mov cl,45
		add bx,6
		add ax,0

		mov rob.xax,ax
		mov rob.yax,bx
		mov rob.clr,cl

		mov rchk,1
	rend1:
		cmp rchk,1
		je rcheck2
		jmp rend2
	rcheck2:
		cmp rob.xax,50
		jbe rdech
	rr:
		cmp rob.xax,25
		jbe rredo
		jmp rgo
	rredo:
		mov rchk,00
		mov rchk1,00
		jmp rend2
	rgo:
		sub rob.xax,3
		rend2:
		jmp ree
	;to shoot cannon1
	rdech:
		mov ax,c1.yax
		mov shcount1,ax
		cmp rob.yax,ax
		ja rd
		jmp rr
	rd:
		add shcount1,35
		mov ax,shcount1
		cmp rob.yax,ax
		jb rde
		jmp rr
	rde:
		cmp c1.life,00
		ja doh1
		jmp nh1
	doh1:
		dec c1.life
		inc score
	nh1:
		mov rchk,00
		mov rchk1,00

	ree:



		cmp rchk01,1
		je rshots2
		jmp rees2
	rshots2:
		cmp rchk0,00
		je rcheck1s2
		jmp rend1s2
	rcheck1s2:
		mov ax,xa
		mov bx,ya
		mov cl,45
	cmp lr,1
	je ri
	jmp lef
	ri:
		add bx,47
		add ax,35
		jmp jmpmove
	lef:
		sub bx,16
		add ax,35
	jmpmove:
		
		mov rob2.xax,ax
		mov rob2.yax,bx
		mov rob2.clr,cl

		mov rchk0,1
	rend1s2:
		cmp rchk0,1
		je rcheck2s2
		jmp rend2s2
	rcheck2s2:
		cmp rob2.xax,50
		jbe rdechs2
	rrs2:
		cmp rob2.xax,25
		jbe rredos2
		jmp rgos2
	rredos2:
		mov rchk0,00
		mov rchk01,00
		jmp rend2s2
	rgos2:
		sub rob2.xax,3
		rend2s2:
		jmp rees2
	;to shoot cannon1
	rdechs2:
		mov ax,c1.yax
		mov shcount1,ax
		cmp rob2.yax,ax
		ja rds2
		jmp rrs2
	rds2:
		add shcount1,35
		mov ax,shcount1
		cmp rob2.yax,ax
		jb rdes2
		jmp rrs2
	rdes2:
		cmp c1.life,00
		ja doh1s2
		jmp nh1s2
	doh1s2:
		dec c1.life
		inc score
		inc score
	nh1s2:
		mov rchk0,00
		mov rchk01,00

	rees2:

	
;takes input from keyboard
		mov ah,01
		int 16h

		jz Goout ;for buffer purpose

; moves robot from control keys
		;cmp ah,48h
		;je up
		cmp ah,4Bh
		je left
		cmp ah,4Dh
		je right
		;cmp ah,50h
		;je down
		jmp e01
		;up:
		;dec xa;
		;call Display
		;jmp e1

		;down:
		;inc xa;
		;call Display
		;jmp e1
	right:
		cmp ya,265
		jb right1
		jmp e01
	right1:
		mov lr,1
		add ya,5
		call Display
		jmp e01
	left:
		cmp ya,20
		ja left1
		jmp e01
	left1:
		mov lr,0
		sub ya,5
		call Display
		jmp e01
	e01:


;to pause game when p is pressed
		cmp ah,19h
		je pause
	resume:

;check for robot to shoot
		cmp ah,21h
		je rsh
		jmp rnot
	rsh:

	
	
		mov rchk1,1

	rnot:
	
;check for robot to shoot
		cmp ah,39h
		je rsh2
		jmp rnot2
	rsh2:


		mov rchk01,1

	rnot2:


;terminates when escape is pressed
cmp ah,1
jne Repeat1

	jmp continue
;to pause
	pause:
			mov si,00
			mov ty,12
			mov tx,15
			
		gopause:
			
				mov counter,1
				mov al,pa[si]
				mov asc,al
				mov tc.clr,15
			call printchar
				inc si
				inc tx

			cmp pa[si],'$'
			jne gopause

		mov ah,00
		int 16h

	cmp ah,13h
	jne pause
	je resume
;resume
		continue:

		jmp ngl
;if lose
		golose:
			
			call Displaylost
		ngl:

		jmp ngw
;if win
	gowing:
		
			call Displaywin

	ngw:
;interrupts
			mov ah,00h
			int 16h
			
mov ax,4c00h
int 21h

Main endp

;if win display screen
Displaywin proc

;------- screen selection---  
mov ah,0
mov al,13h
int 10h

	mov si,00

	mov ty,5
	mov tx,13
	goverw:
		mov counter,1
		mov al,win[si]
		mov asc,al
		mov tc.clr,15
		call printchar
		inc si
		inc tx

	cmp win[si],'$'
	jne goverw


		mov si,00

	mov ty,12
	mov tx,13
	goverw1:
		mov counter,1
		mov al,win1[si]
		mov asc,al
		mov tc.clr,15
		call printchar
		inc si
		inc tx

	cmp win1[si],'$'
	jne goverw1


ret
Displaywin endp

;if lose display screen
Displaylost proc

;------- screen selection---  
mov ah,0
mov al,13h
int 10h

	mov si,00

	mov ty,12
	mov tx,7
	gover:
		mov counter,1
		mov al,lose[si]
		mov asc,al
		mov tc.clr,15
		call printchar
		inc si
		inc tx

	cmp lose[si],'$'
	jne gover



	mov si,00

	mov ty,13
	mov tx,5
	gover1:
		mov counter,1
		mov al,lose1[si]
		mov asc,al
		mov tc.clr,15
		call printchar
		inc si
		inc tx

	cmp lose1[si],'$'
	jne gover1


	mov si,00

	mov ty,14
	mov tx,5
	gover2:
		mov counter,1
		mov al,lose2[si]
		mov asc,al
		mov tc.clr,15
		call printchar
		inc si
		inc tx

	cmp lose2[si],'$'
	jne gover2


ret
Displaylost endp

;updates display while playing
Display proc

;------- screen selection---  
	mov ah,0
	mov al,13h
	int 10h
   
;--- Change Background----------

		;mov ah, 06h ; Function Number
		;mov al, 0   
		;mov ch, 3  ;Upper Row number/ Y axis of first point
		;mov cl,00  ;Left column number/ X axis of first point
		;mov dh, 22 ;Lower Row number/ Y axis of second point
		;mov dl, 39 ;Right column number/ X axis of second point
		;mov bh, 3 ; color number
		;int 10h
	;mov p1.sx,160	;rows
	;mov p1.sy,320	;cols
	;mov p1.x,25
	;mov p1.y,00
	;mov p1.color,3
	;call filling

;draw fire of cannon1
		mov p1.sx,3	;rows
		mov p1.sy,4	;cols
		mov ax,ca1.xax
		mov bx,ca1.yax
		mov cl,ca1.clr
		mov p1.x,ax
		mov p1.y,bx
		mov p1.color,cl
	call filling

;draw fire of cannon1 shhot2
		mov p1.sx,3	;rows
		mov p1.sy,4	;cols
		mov ax,ca2.xax
		mov bx,ca2.yax
		mov cl,ca2.clr
		mov p1.x,ax
		mov p1.y,bx
		mov p1.color,cl
	call filling

;draw fire of cannon1 shhot2
		mov p1.sx,3	;rows
		mov p1.sy,4	;cols
		mov ax,ca3.xax
		mov bx,ca3.yax
		mov cl,ca3.clr
		mov p1.x,ax
		mov p1.y,bx
		mov p1.color,cl
	call filling
	
;draw fire of robot after some checks
	cmp rchk1,1
	je printrsh
	jmp notpr

		printrsh:
			mov p1.sx,3	;rows
			mov p1.sy,1	;cols
			mov ax,rob.xax
			mov bx,rob.yax
			mov cl,rob.clr
			mov p1.x,ax
			mov p1.y,bx
			mov p1.color,cl
	call filling

	notpr:

	
	
;draw fire of robot after some checks
	cmp rchk01,1
	je printrsh1
	jmp notpr1

		printrsh1:
			mov p1.sx,3	;rows
			mov p1.sy,4	;cols
			mov ax,rob2.xax
			mov bx,rob2.yax
			mov cl,rob2.clr
			mov p1.x,ax
			mov p1.y,bx
			mov p1.color,cl
	call filling

	notpr1:


	cmp lr,1
	je dr
	jmp dle
	dr:
		call drawrobor;draws robot
		jmp dend
	dle:
		call drawrobol
	dend:
		
	;draws cannon1
			mov ax,c1.xax
			mov bx,c1.yax
			mov cl,c1.clr
			mov tc.xax,ax
			mov tc.yax,bx
			mov tc.clr,cl

		call drawcannon

		mov tc.clr,0  
		call printchar  

;draws cannon1 life
			mov t1,7
			mov si,00

			mov ty,1
			mov tx,9
			mov al,c1.life
			mov ah,0
			mov counter,ax
			mov asc,219
			mov al,c1.clr
			mov tc.clr,al
		call printchar

			mov ty,1
			mov tx,1
			can1:
				mov counter,1
				mov al,c1life[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				dec t1
				inc tx

			cmp t1,00
			ja can1

		mov p1.sx,9	;rows
		mov p1.sy,202	;cols
		mov p1.x,7
		mov p1.y,71
		mov p1.color,15
	call pixel


;prints health
			mov si,00

			mov ty,24
			mov tx,8
			mov al,health
			mov ah,0
			mov counter,ax
			mov asc,3
			mov tc.clr,42
		call printchar

			mov ty,24
			mov tx,1
			rl:
				mov counter,1
				mov al,rlife[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				inc tx

			cmp rlife[si],'$'
			jne rl

			mov si,00
;prints score
			mov ty,24
			mov tx,25
			sc:
				mov counter,1
				mov al,scr[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				inc tx
			cmp scr[si],'$'
			jne sc
;prints score in double digit
			mov ty,24
			mov tx,33


		 mov ax, score
		 mov enteredNumber,ax

		 BreakIt:
				 mov ax,enteredNumber
				 mov dx,0      ;AX= Quotient, DX= Remainder
				 mov bx,10
				 div bx   
				 push dx      ;Dx: Remainder   
				 inc digitCount
				 mov enteredNumber,ax
				 cmp enteredNumber,0
			je DisplayIt 

		 jmp BreakIt

;Printing all digits from stack
		 
		 DisplayIt: 
				 cmp digitCount,0
				 je exitp
				 dec digitCount 
				 pop dx
				 add dl,48
				mov counter,1
				 mov asc,dl
				 mov tc.clr,15
				 inc tx
			 call printchar
		 
			jmp DisplayIt
		 
		 
		 exitp:

;prints level
			mov si,00

			mov ty,24
			mov tx,15

			lv:
				mov counter,1
				mov al,lvl[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				inc tx

			cmp lvl[si],'$'
			jne lv
			
			
			mov ty,24
			mov tx,22
			mov counter,1
			mov al,level
			mov asc,al
			add asc,48
			mov tc.clr,1
		call printchar

ret
Display endp
;display ends


;prints each character with given color,coordinates and ASCII of a character

printchar proc

;---- Cusor Position------------

		mov ah,02; Function Number
		mov dh,ty;Row Number
		mov dl,tx;Column Number
		int 10h
	
;--------- Print Character------
		mov ah, 09h ; Function Number
			mov al, Asc ; Character to print
		mov cx,counter    ; Count to Display character
		mov bh,00    
		mov bl,tc.clr    ; Color
			int 10h
ret 
printchar endp

;draws cannon through two functions disscused later
drawcannon proc

		mov p1.sx,2	;rows
		mov p1.sy,8	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,4
		add p1.y,4
		mov p1.color,40
	call filling

		mov p1.sx,2	;rows
		mov p1.sy,8	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,2
		add p1.y,4
		mov p1.color,42
	call filling

		mov p1.sx,1	;rows
		mov p1.sy,8	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,1
		add p1.y,4
		mov p1.color,44
	call filling
	
		mov p1.sx,1	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,0
		add p1.y,8
		mov p1.color,44
	call filling

	


		mov p1.sx,2	;rows
		mov p1.sy,8	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,4
		add p1.y,48
		mov p1.color,40
	call filling

		mov p1.sx,2	;rows
		mov p1.sy,8	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,2
		add p1.y,48
		mov p1.color,42
	call filling

		mov p1.sx,1	;rows
		mov p1.sy,8	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,1
		add p1.y,48
		mov p1.color,44
	call filling
	
		mov p1.sx,1	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,0
		add p1.y,48
		mov p1.color,44
	call filling



		mov p1.sx,2	;rows
		mov p1.sy,12	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,3
		add p1.y,24
		mov p1.color,40
	call filling

		mov p1.sx,2	;rows
		mov p1.sy,12	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,1
		add p1.y,24
		mov p1.color,42
	call filling

		mov p1.sx,1	;rows
		mov p1.sy,12	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,0
		add p1.y,24
		mov p1.color,44
	call filling
	
		mov p1.sx,17	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,6
		mov p1.color,40

	call filling

		mov p1.sx,4	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,8
		add p1.y,4
		mov bl,tc.clr
		mov p1.color,bl
	call filling

		mov p1.sx,4	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,10
		add p1.y,8
		mov bl,tc.clr
		mov p1.color,bl
	call filling

		mov p1.sx,17	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,12
		add p1.y,12
		mov p1.color,41
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,8
		add p1.y,16
		mov bl,tc.clr
		mov p1.color,bl
	call filling

		mov p1.sx,10	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,8
		add p1.y,20
		mov bl,tc.clr
		mov p1.color,bl
	call filling



		mov p1.sx,25	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.y,24
		add p1.x,10
		mov p1.color,39
	call filling

		mov p1.sx,35	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.y,28
		add p1.x,6
		mov p1.color,40
	call filling

	
	
		mov p1.sx,17	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,6
		add p1.y,56
		mov p1.color,40

	call filling

		mov p1.sx,4	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,8
		add p1.y,52
		mov bl,tc.clr
		mov p1.color,bl
	call filling

		mov p1.sx,4	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,10
		add p1.y,48
		mov bl,tc.clr
		mov p1.color,bl
	call filling

		mov p1.sx,17	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,12
		add p1.y,44
		mov p1.color,41
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,8
		add p1.y,40
		mov bl,tc.clr
		mov p1.color,bl
	call filling

		mov p1.sx,10	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,8
		add p1.y,36
		mov bl,tc.clr
		mov p1.color,bl
	call filling



		mov p1.sx,25	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.y,32
		add p1.x,10
		mov p1.color,39
	call filling
ret
drawcannon endp
;cannon display ends

;draws robot through 2 functions same as cannons
drawrobol proc

		mov p1.sx,1	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		sub p1.x,1
		add p1.y,4
		mov p1.color,26
	call filling

		mov p1.sx,3	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		sub p1.x,2
		add p1.y,3
		mov p1.color,45
	call pixel

		mov p1.sx,6	;rows
		mov p1.sy,1	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		sub p1.x,7
		add p1.y,6
		mov p1.color,45
	call filling

		mov p1.sx,20	;rows
		mov p1.sy,35	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		mov p1.color,45
	call pixel

		mov p1.sx,18	;rows
		mov p1.sy,33	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,1
		add p1.y,1
		mov p1.color,26
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,2
		add p1.y,2
		mov p1.color,45
	call pixel


		mov p1.sx,6	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,3
		add p1.y,3
		mov p1.color,75
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,2
		add p1.y,25
		mov p1.color,45
	call pixel

		mov p1.sx,6	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,3
		add p1.y,26
		mov p1.color,75
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,13	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,9
		add p1.y,11
		mov p1.color,45
	call pixel


		mov p1.sx,6	;rows
		mov p1.sy,11	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,10
		add p1.y,12
		mov p1.color,29
	call filling


		mov p1.sx,18	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,1
		sub p1.y,5
		mov p1.color,45
	call pixel

		mov p1.sx,16	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,2
		sub p1.y,4
		mov p1.color,29
	call filling


		mov p1.sx,18	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,1
		add p1.y,34
		mov p1.color,45
	call pixel

		mov p1.sx,16	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,2
		add p1.y,35
		mov p1.color,29
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,10	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,19
		add p1.y,13
		mov p1.color,45
	call pixel

		mov p1.sx,6	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,20
		add p1.y,14
		mov p1.color,29
	call filling

		mov p1.sx,21	;rows
		mov p1.sy,23	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,26
		add p1.y,6
		mov p1.color,45
	call pixel

		mov p1.sx,19	;rows
		mov p1.sy,21	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,27
		add p1.y,7
		mov p1.color,26
	call filling

		mov p1.sx,3	;rows
		mov p1.sy,3	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,29
		add p1.y,4
		mov p1.color,45
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,26
		sub p1.y,4
		mov p1.color,45
	call pixel

		mov p1.sx,6	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,27
		sub p1.y,3
		mov p1.color,29
	call filling

		mov p1.sx,7	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,34
		sub p1.y,2
		mov p1.color,45
	call filling

		mov p1.sx,4	;rows
		mov p1.sy,10	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,41
		sub p1.y,8
		mov p1.color,45
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,39
		sub p1.y,16
		mov p1.color,45
	call pixel

		mov p1.sx,1	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,39
		sub p1.y,15
		mov p1.color,3
	call filling

		mov p1.sx,3	;rows
		mov p1.sy,3	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,29
		add p1.y,29
		mov p1.color,45
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,26
		add p1.y,31
		mov p1.color,45
	call pixel

		mov p1.sx,6	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,27
		add p1.y,32
		mov p1.color,29
	call filling


		mov p1.sx,7	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,34
		add p1.y,33
		mov p1.color,45
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,41
		add p1.y,31
		mov p1.color,45
	call pixel

		mov p1.sx,1	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,48
		add p1.y,32
		mov p1.color,3
	call filling

		mov p1.sx,5	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,47
		add p1.y,10
		mov p1.color,45
	call filling

		mov p1.sx,7	;rows
		mov p1.sy,12	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,52
		add p1.y,4
		mov p1.color,45
	call pixel

		mov p1.sx,5	;rows
		mov p1.sy,10	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,53
		add p1.y,5
		mov p1.color,29
	call filling

		mov p1.sx,5	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,47
		add p1.y,21
		mov p1.color,45
	call filling

		mov p1.sx,7	;rows
		mov p1.sy,12	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,52
		add p1.y,19
		mov p1.color,45
	call pixel

		mov p1.sx,5	;rows
		mov p1.sy,10	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,53
		add p1.y,20
		mov p1.color,29
	call filling

ret
drawrobol endp




drawrobor proc

		mov p1.sx,1	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		sub p1.x,1
		add p1.y,4
		mov p1.color,26
	call filling

		mov p1.sx,3	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		sub p1.x,2
		add p1.y,3
		mov p1.color,45
	call pixel

		mov p1.sx,6	;rows
		mov p1.sy,1	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		sub p1.x,7
		add p1.y,6
		mov p1.color,45
	call filling

		mov p1.sx,20	;rows
		mov p1.sy,35	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		mov p1.color,45
	call pixel

		mov p1.sx,18	;rows
		mov p1.sy,33	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,1
		add p1.y,1
		mov p1.color,26
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,2
		add p1.y,2
		mov p1.color,45
	call pixel


		mov p1.sx,6	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,3
		add p1.y,3
		mov p1.color,75
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,2
		add p1.y,25
		mov p1.color,45
	call pixel

		mov p1.sx,6	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,3
		add p1.y,26
		mov p1.color,75
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,13	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,9
		add p1.y,11
		mov p1.color,45
	call pixel


		mov p1.sx,6	;rows
		mov p1.sy,11	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,10
		add p1.y,12
		mov p1.color,29
	call filling


		mov p1.sx,18	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,1
		sub p1.y,5
		mov p1.color,45
	call pixel

		mov p1.sx,16	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,2
		sub p1.y,4
		mov p1.color,29
	call filling


		mov p1.sx,18	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,1
		add p1.y,34
		mov p1.color,45
	call pixel

		mov p1.sx,16	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,2
		add p1.y,35
		mov p1.color,29
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,10	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,19
		add p1.y,13
		mov p1.color,45
	call pixel

		mov p1.sx,6	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,20
		add p1.y,14
		mov p1.color,29
	call filling

		mov p1.sx,21	;rows
		mov p1.sy,23	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,26
		add p1.y,6
		mov p1.color,45
	call pixel

		mov p1.sx,19	;rows
		mov p1.sy,21	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,27
		add p1.y,7
		mov p1.color,26
	call filling

		mov p1.sx,3	;rows
		mov p1.sy,3	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,29
		add p1.y,4
		mov p1.color,45
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,26
		sub p1.y,4
		mov p1.color,45
	call pixel

		mov p1.sx,6	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,27
		sub p1.y,3
		mov p1.color,29
	call filling

		mov p1.sx,7	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,34
		sub p1.y,2
		mov p1.color,45
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,41
		sub p1.y,4
		mov p1.color,45
	call pixel

		mov p1.sx,1	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,48
		sub p1.y,3
		mov p1.color,3
	call filling

		mov p1.sx,3	;rows
		mov p1.sy,3	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,29
		add p1.y,29
		mov p1.color,45
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,26
		add p1.y,31
		mov p1.color,45
	call pixel

		mov p1.sx,6	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,27
		add p1.y,32
		mov p1.color,29
	call filling


		mov p1.sx,7	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,34
		add p1.y,33
		mov p1.color,45
	call filling

		mov p1.sx,4	;rows
		mov p1.sy,10	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,41
		add p1.y,33
		mov p1.color,45
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,39
		add p1.y,43
		mov p1.color,45
	call pixel

		mov p1.sx,1	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,39
		add p1.y,46
		mov p1.color,3
	call filling

		mov p1.sx,5	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,47
		add p1.y,10
		mov p1.color,45
	call filling

		mov p1.sx,7	;rows
		mov p1.sy,12	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,52
		add p1.y,4
		mov p1.color,45
	call pixel

		mov p1.sx,5	;rows
		mov p1.sy,10	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,53
		add p1.y,5
		mov p1.color,29
	call filling

		mov p1.sx,5	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,47
		add p1.y,21
		mov p1.color,45
	call filling

		mov p1.sx,7	;rows
		mov p1.sy,12	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,52
		add p1.y,19
		mov p1.color,45
	call pixel

		mov p1.sx,5	;rows
		mov p1.sy,10	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,53
		add p1.y,20
		mov p1.color,29
	call filling

ret
drawrobor endp

;robot display ends

;draws rectangle
pixel proc
		mov ax,p1.sx
		mov t1,ax
		mov dx,p1.x
		mov cx,p1.y
		loop01:
			mov al,p1.color
			mov ah,0Ch
			int 10h
			inc dx

			dec t1
		cmp t1,00
		ja loop01

		mov ax,p1.sx
		mov t1,ax
		mov dx,p1.x
		mov cx,p1.y
		add cx,p1.sy
		dec cx
		loop02:
			mov al,p1.color
			mov ah,0Ch
			int 10h
			inc dx

			dec t1
		cmp t1,00
		ja loop02

		mov ax,p1.sy
		mov t1,ax
		mov dx,p1.x
		mov cx,p1.y
		loop03:
			mov al,p1.color
			mov ah,0Ch
			int 10h
			inc cx

			dec t1
		cmp t1,00
		ja loop03

		mov ax,p1.sy
		mov t1,ax
		mov dx,p1.x
		mov cx,p1.y
		add dx,p1.sx
		dec dx
		loop04:
			mov al,p1.color
			mov ah,0Ch
			int 10h
			inc cx

			dec t1
		cmp t1,00
		ja loop04


ret
pixel endp

;draws rectangle filled with pixels
filling proc

		mov ax,p1.sy
		mov t1,ax
		mov cx,p1.y
		label1:
			mov dx,p1.x
			mov ax,p1.sx
			mov t2,ax

		label2:
			mov al,p1.color
			mov ah,0Ch
			int 10h
			inc dx
			dec t2
		cmp t2,00
		ja label2

		dec t1
		inc cx
		cmp t1,00
		ja label1

ret
filling endp


end