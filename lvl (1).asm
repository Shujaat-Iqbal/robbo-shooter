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
	life db 5
cannon ends
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	c1 cannon <>	;cannon1
	c2 cannon <>	;cannon2
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
	cannonc2 db 00
	cannonc01 db 00
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
		ca2 shoot <>	;cannon2 shoot
		ca3 shoot <>	;cannon1 shoot3
		rob shoot <>	;robot shoot
		rob2 shoot <>

;variables for checks provided for shooting purpose
	shcount1 dw ?
	shchk1 db ?
	shchk01 db ?
	shchk2 db ?
	rchk db ?
	rchk1 db ?
	rchk0 db ?
	rchk01 db ?


clk db ?
col dw ?
row dw ?

	lr db 1

;to display multidigit number like score in characters
	digitCount db 0  
	enteredNumber dw 00
 
.code
	mov ax,@data
	mov ds,ax


Main proc

	mov ax,@data
	mov ds,ax
	;robot co-ordinates
		mov xa,110
		mov ya,5
	;cannon1 values
		mov c1.xax,25
		mov c1.yax,0
		mov c1.clr,28
	;cannon2 values
		mov c2.xax,25
		mov c2.yax,283
		mov c2.clr,50
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

		; if cannon 1 dies then cannonc1=1
			cmp C1.life,00
			je ic1
			jmp nic1

		ic1:
		
			mov cannonc1,1

		nic1:


		; if cannon 2 dies then cannonc2=1
			cmp C2.life,00
			je ic2
			jmp nic2
			
		ic2:

			mov cannonc2,1

		nic2:

		;update detailes of cannons i.e. both dead or alive
			mov al,cannonc1
			mov ah,cannonc2
			add al,ah
			mov cannonc,al

			cmp cannonc,2
			je gowing
					
					
					
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;moves cannon1 and cannon2 shoots and update health

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
			mov cl,c1.clr
			add bx,19
			add ax,20

			mov ca1.xax,ax
			mov ca1.yax,bx
			mov ca1.clr,cl

			mov shchk1,1
		end1:
		
			cmp shchk1,1
			je check2
			jmp end2
			check2:
			cmp ca1.xax,105
			jae dech
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
		ja d
		jmp r
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d:
		
			add shcount1,45
			mov ax,shcount1
			cmp ca1.yax,ax
			jb de
			jmp r
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;cannon2
			cmp cannonc2,00
			je movec2
			jmp dnmc2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		movec2:

			cmp shchk2,00
			je check01
			jmp end01
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		check01:
			mov ax,c2.xax
			mov bx,c2.yax
			mov cl,c2.clr
			add bx,19
			add ax,20

			mov ca2.xax,ax
			mov ca2.yax,bx
			mov ca2.clr,cl;

			mov shchk2,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		end01:
		
			cmp shchk2,1
			je check02
			jmp end02
			check02:
			cmp ca2.xax,105
			jae dech1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		r1:
		
			cmp ca2.xax,180
			jae redo1
			jmp go1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		redo1:
		
		mov shchk2,00
		jmp end02
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		go1:
		
			add ca2.xax,3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		end02:
		
			jmp ee1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		dech1:
		
			mov ax,ya
			sub ax,4
			mov shcount1,ax
			cmp ca2.yax,ax
			ja d1
			jmp r1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d1:

			add shcount1,45
			mov ax,shcount1
			cmp ca2.yax,ax
			jb de1
			jmp r1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		de1:

			dec health
			mov shchk2,00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ee1:

		jmp nc2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		dnmc2:

			mov ca2.xax,00
			mov ca2.yax,00
			mov ca2.clr,00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		nc2:

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
					mov ax,c2.yax
					sub ax,36
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

;moves cannon2
			cmp cannonc2,00
			je moveca2
			jmp dnmca2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		moveca2:

					cmp count2,00
					je chk1c2
					jmp exi1
				chk1c2:

						sub C2.yax,2

				exi1:
					cmp count2,1
					je chk2c2
					jmp exi2
				chk2c2:

						add C2.yax,2

				exi2:
					mov ax,c1.yax
					add ax,36
					cmp c2.yax,ax
					jbe condi1
					jmp exi3
				condi1:
						mov count2,1
				exi3:
					cmp c2.yax,284
					jae condi2
					jmp exi4
				condi2:
						mov count2,0
				exi4:


		jmp nca2
;for dead cannon 2
	dnmca2:
		mov c2.clr,39

	nca2:


					
		;end cannons move

;robot shoot and update cannons health and score
		cmp rchk1,1
		je rshot
		jmp rns
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
		cmp rob.xax,50
		jbe rdech1
	rr1:
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
		jmp rns

	;to shoot cannon2
	rdech1:
		mov ax,c2.yax
		mov shcount1,ax
		cmp rob.yax,ax
		ja rd1
		jmp rr1
	rd1:
		add shcount1,35
		mov ax,shcount1
		cmp rob.yax,ax
		jb rde1
		jmp rr1
	rde1:
		cmp c2.life,00
		ja doh2
		jmp nh2
	doh2:
		dec c2.life
		inc score
	nh2:
		mov rchk,00
		mov rchk1,00

	rns:

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
		cmp ya,280
		jb right1
		jmp e01
	right1:
		add ya,5
		call Display
		jmp e01
	left:
		cmp ya,5
		ja left1
		jmp e01
	left1:
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
		
			jmp level2

	ngw:

jmp ngwL3

level2:

mov c1.life,7
mov c2.life,7

	;robot co-ordinates
		mov xa,145
		mov ya,0
	;cannon1 values
		mov c1.xax,25
		mov c1.yax,0
		mov c1.clr,28
	;cannon2 values
		mov c2.xax,25
		mov c2.yax,283
		mov c2.clr,50
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
	Repeat1L2:
		jmp joutL2
		
		GooutL2:
		
		call DisplayL2	;displays everything onscreen
		joutL2:
		;clear buffer
		mov ah,0Ch
		int 21h

			;Timer
				MOV     CX, 01h
				MOV     DX, 0;FFFFh;   CX:DX      Number of microseconds to elapse
				mov 	al,0
				MOV     AH, 86H
				INT     15H

				call DisplayL2

			;if lose
			cmp health,00
			je goloseL2

		; if cannon 1 dies then cannonc1=1
			cmp C1.life,00
			je ic1L2
			jmp nic1L2

		ic1L2:
		
			mov cannonc1,1

		nic1L2:


		; if cannon 2 dies then cannonc2=1
			cmp C2.life,00
			je ic2L2
			jmp nic2L2
			
		ic2L2:

			mov cannonc2,1

		nic2L2:

		;update detailes of cannons i.e. both dead or alive
			mov al,cannonc1
			mov ah,cannonc2
			add al,ah
			mov cannonc,al

			cmp cannonc,2
			je gowingL2
					
					
					
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;moves cannon1 and cannon2 shoots and update health

			cmp cannonc1,00
			je movec1L2
			jmp dnmc1L2

		movec1L2:
		
			cmp shchk1,00
			je check1L2
			jmp end1L2
		check1L2:

			mov ax,c1.xax
			mov bx,c1.yax
			mov cl,c1.clr
			add bx,19
			add ax,20

			mov ca1.xax,ax
			mov ca1.yax,bx
			mov ca1.clr,cl

			mov shchk1,1
		end1L2:
		
			cmp shchk1,1
			je check2L2
			jmp end2L2
			check2L2:
			cmp ca1.xax,138
			jae dechL2
		rL2:
			cmp ca1.xax,180
			jae redoL2
			jmp goL2
		redoL2:

			mov shchk1,00
			jmp end2L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		goL2:
		
			add ca1.xax,3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		end2L2:
		
			jmp eeL2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		dechL2:

		mov ax,ya
		mov shcount1,ax
		cmp ca1.yax,ax
		ja dL2
		jmp rL2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		dL2:
		
			add shcount1,49
			mov ax,shcount1
			cmp ca1.yax,ax
			jb deL2
			jmp rL2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		deL2:

		dec health
		mov shchk1,00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		eeL2:

		jmp nc1L2
		dnmc1L2:
		
			mov ca1.xax,00
			mov ca1.yax,00
			mov ca1.clr,00
		nc1L2:
;cannon2
			cmp cannonc2,00
			je movec2L2
			jmp dnmc2L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		movec2L2:

			cmp shchk2,00
			je check01L2
			jmp end01L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		check01L2:
			mov ax,c2.xax
			mov bx,c2.yax
			mov cl,c2.clr
			add bx,19
			add ax,20

			mov ca2.xax,ax
			mov ca2.yax,bx
			mov ca2.clr,cl;

			mov shchk2,1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		end01L2:
		
			cmp shchk2,1
			je check02L2
			jmp end02L2
			check02L2:
			cmp ca2.xax,138
			jae dech1L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		r1L2:
		
			cmp ca2.xax,180
			jae redo1L2
			jmp go1L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		redo1L2:
		
		mov shchk2,00
		jmp end02L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		go1L2:
		
			add ca2.xax,3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		end02L2:
		
			jmp ee1L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		dech1L2:
		
			mov ax,ya
			mov shcount1,ax
			cmp ca2.yax,ax
			ja d1L2
			jmp r1L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d1L2:

			add shcount1,49
			mov ax,shcount1
			cmp ca2.yax,ax
			jb de1L2
			jmp r1L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		de1L2:

			dec health
			mov shchk2,00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ee1L2:

		jmp nc2L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		dnmc2L2:

			mov ca2.xax,00
			mov ca2.yax,00
			mov ca2.clr,00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		nc2L2:

			cmp cannonc1,00
			je moveca1L2
			jmp dnmca1L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		moveca1L2:

;move cannons
				cmp count1,00
				je chk1L2
				jmp e1L2
			chk1L2:

					add C1.yax,2
					e1L2:
					cmp count1,1
					je chk2L2
					jmp e2L2
				chk2L2:

					sub C1.yax,2
				e2L2:
					mov ax,c2.yax
					sub ax,36
					cmp c1.yax,ax
					jae con1L2
					jmp e3L2
				con1L2:
					mov count1,1
				e3L2:
					cmp c1.yax,0
					je con2L2
					jmp e4L2
				con2L2:
					mov count1,00
					e4L2:

				jmp nca1L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; for dead cannon
		dnmca1L2:
		
				mov c1.clr,39
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		nca1L2:

;moves cannon2
			cmp cannonc2,00
			je moveca2L2
			jmp dnmca2L2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		moveca2L2:

					cmp count2,00
					je chk1c2L2
					jmp exi1L2
				chk1c2L2:

						sub C2.yax,2

				exi1L2:
					cmp count2,1
					je chk2c2L2
					jmp exi2L2
				chk2c2L2:

						add C2.yax,2

				exi2L2:
					mov ax,c1.yax
					add ax,36
					cmp c2.yax,ax
					jbe condi1L2
					jmp exi3L2
				condi1L2:
						mov count2,1
				exi3L2:
					cmp c2.yax,284
					jae condi2L2
					jmp exi4L2
				condi2L2:
						mov count2,0
				exi4L2:


		jmp nca2L2
;for dead cannon 2
	dnmca2L2:
		mov c2.clr,39

	nca2L2:


					
		;end cannons move

;robot shoot and update cannons health and score
		cmp rchk1,1
		je rshotL2
		jmp rnsL2
	rshotL2:
		cmp rchk,00
		je rcheck1L2
		jmp rend1L2
	rcheck1L2:
		mov ax,xa
		mov bx,ya
		mov cl,4
		add bx,10
		sub ax,4

		mov rob.xax,ax
		mov rob.yax,bx
		mov rob.clr,cl

		mov rchk,1
	rend1L2:
		cmp rchk,1
		je rcheck2L2
		jmp rend2L2
	rcheck2L2:
		cmp rob.xax,50
		jbe rdechL2
	rrL2:
		cmp rob.xax,50
		jbe rdech1L2
	rr1L2:
		cmp rob.xax,25
		jbe rredoL2
		jmp rgoL2
	rredoL2:
		mov rchk,00
		mov rchk1,00
		jmp rend2L2
	rgoL2:
		sub rob.xax,3
		rend2L2:
		jmp reeL2
	;to shoot cannon1
	rdechL2:
		mov ax,c1.yax
		mov shcount1,ax
		cmp rob.yax,ax
		ja rdL2
		jmp rrL2
	rdL2:
		add shcount1,35
		mov ax,shcount1
		cmp rob.yax,ax
		jb rdeL2
		jmp rrL2
	rdeL2:
		cmp c1.life,00
		ja doh1L2
		jmp nh1L2
	doh1L2:
		dec c1.life
		inc score
	nh1L2:
		mov rchk,00
		mov rchk1,00

	reeL2:
		jmp rnsL2

	;to shoot cannon2
	rdech1L2:
		mov ax,c2.yax
		mov shcount1,ax
		cmp rob.yax,ax
		ja rd1L2
		jmp rr1L2
	rd1L2:
		add shcount1,35
		mov ax,shcount1
		cmp rob.yax,ax
		jb rde1L2
		jmp rr1L2
	rde1L2:
		cmp c2.life,00
		ja doh2L2
		jmp nh2L2
	doh2L2:
		dec c2.life
		inc score
	nh2L2:
		mov rchk,00
		mov rchk1,00

	rnsL2:
;;;;;;;;;;;;;;;;;

		cmp rchk01,1
		je rshots2L2
		jmp rnss2L2
	rshots2L2:
		cmp rchk0,00
		je rcheck1s2L2
		jmp rend1s2L2
	rcheck1s2L2:
		mov ax,xa
		mov bx,ya
		mov cl,4
		add bx,38
		sub ax,4

		mov rob2.xax,ax
		mov rob2.yax,bx
		mov rob2.clr,cl

		mov rchk0,1
	rend1s2L2:
		cmp rchk0,1
		je rcheck2s2L2
		jmp rend2s2L2
	rcheck2s2L2:
		cmp rob2.xax,50
		jbe rdechs2L2
	rrs2L2:
		cmp rob2.xax,50
		jbe rdech1s2L2
	rr1s2L2:
		cmp rob2.xax,25
		jbe rredos2L2
		jmp rgos2L2
	rredos2L2:
		mov rchk0,00
		mov rchk01,00
		jmp rend2s2L2
	rgos2L2:
		sub rob2.xax,3
		rend2s2L2:
		jmp rees2L2
	;to shoot cannon1
	rdechs2L2:
		mov ax,c1.yax
		mov shcount1,ax
		cmp rob2.yax,ax
		ja rds2L2
		jmp rrs2L2
	rds2L2:
		add shcount1,35
		mov ax,shcount1
		cmp rob2.yax,ax
		jb rdes2L2
		jmp rrs2L2
	rdes2L2:
		cmp c1.life,00
		ja doh1s2L2
		jmp nh1s2L2
	doh1s2L2:
		dec c1.life
		inc score
	nh1s2L2:
		mov rchk0,00
		mov rchk01,00

	rees2L2:
		jmp rnss2L2

	;to shoot cannon2
	rdech1s2L2:
		mov ax,c2.yax
		mov shcount1,ax
		cmp rob2.yax,ax
		ja rd1s2L2
		jmp rr1s2L2
	rd1s2L2:
		add shcount1,35
		mov ax,shcount1
		cmp rob2.yax,ax
		jb rde1s2L2
		jmp rr1s2L2
	rde1s2L2:
		cmp c2.life,00
		ja doh2s2L2
		jmp nh2s2L2
	doh2s2L2:
		dec c2.life
		inc score
	nh2s2L2:
		mov rchk0,00
		mov rchk01,00

	rnss2L2:




;;;;;;;;;;;;;;;;;;;;;;;

;mov ax,01
;int 33h

;mov ax,03
;int 33h

;mov col,cx
;mov row,dx
;mov clk,bl

;;mov ax,col
;;mov bl,2
;;div bl
;;mov ah,0

;;mov col,ax
;shr col,1

;mov ax,col
;cmp ya,ax
;jb right
;ja left
;jmp e01
;right:

;cmp ya,280
;		jb right1
;		jmp e01
;	right1:

;add ya,4


;jmp e01
;left:

;cmp ya,5
;ja left1
;jmp e01
;left1:

;sub ya,4

;e01:



;cmp clk,1
;		je rsh1
;		jmp rnot1
;	rsh1:


;		mov rchk1,1

;	rnot1:
	
	
	
	
;takes input from keyboard
		mov ah,01
		int 16h

		jz GooutL2 ;for buffer purpose

; moves robot from control keys

		cmp ah,4Bh
		je leftL2
		cmp ah,4Dh
		je rightL2
		jmp e01L2
	rightL2:
		cmp ya,280
		jb right1L2
		jmp e01L2
	right1L2:
		add ya,5
		call DisplayL2
		jmp e01L2
	leftL2:
		cmp ya,5
		ja left1L2
		jmp e01L2
	left1L2:
		sub ya,5
		call DisplayL2
		jmp e01L2
	e01L2:
;

;to pause game when p is pressed
		cmp ah,19h
		je pauseL2
	resumeL2:

;check for robot to shoot
		cmp ah,21h
		je rshL2
		jmp rnotL2
	rshL2:


		mov rchk1,1

	rnotL2:



;check for robot to shoot
		cmp ah,39h
		je rsh2L2
		jmp rnot2L2
	rsh2L2:


		mov rchk01,1

	rnot2L2:

	
;terminates when escape is pressed
cmp ah,1
jne Repeat1L2

	jmp continueL2
;to pause
	pauseL2:
			mov si,00
			mov ty,12
			mov tx,15
			
		gopauseL2:
			
				mov counter,1
				mov al,pa[si]
				mov asc,al
				mov tc.clr,15
			call printchar
				inc si
				inc tx

			cmp pa[si],'$'
			jne gopauseL2

		mov ah,00
		int 16h

	cmp ah,13h
	jne pause
	je resumeL2
;resume
		continueL2:

		jmp nglL2
;if lose
		goloseL2:
			
			call Displaylost
		nglL2:

		jmp ngwL2
;if win
	gowingL2:
		
			jmp level3

	ngwL2:

	jmp ngwL3

level3:
	
mov c1.life,25
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
	Repeat1L3:
		jmp joutL3
		
		GooutL3:
		
		call DisplayL3	;DisplayL3s everything onscreen
		joutL3:
		;clear buffer
		mov ah,0Ch
		int 21h

			;Timer
				MOV     CX, 01h
				MOV     DX, 0;FFFFh;   CX:DX      Number of microseconds to elapse
				mov 	al,0
				MOV     AH, 86H
				INT     15H

				call DisplayL3

			;if lose
			cmp health,00
			je goloseL3
			cmp health,60
			ja goloseL3

		; if cannon 1 dies then cannonc1=1
			cmp C1.life,00
			je ic1L3
			jmp nic1L3

		ic1L3:
		
			mov cannonc1,1

		nic1L3:

;			mov cannonc2,1


		;update detailes of cannons i.e. both dead or alive
			mov al,cannonc1
			mov ah,cannonc2
			add al,ah
			mov cannonc,al

			cmp cannonc,2
			je gowingL3
					
					
					
					
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		;moves cannon1 shoots and update health

			cmp cannonc1,00
			je movec1L3
			jmp dnmc1L3

		movec1L3:
		
			cmp shchk1,00
			je check1L3
			jmp end1L3
		check1L3:

			mov ax,c1.xax
			mov bx,c1.yax
			add bx,28
			add ax,35

			mov ca1.xax,ax
			mov ca1.yax,bx
			mov ca1.clr,40

			mov shchk1,1
		end1L3:
		
			cmp shchk1,1
			je check2L3
			jmp end2L3
		check2L3:
			cmp ca1.xax,120
			jae dechL3
		r1L3:
			cmp ca1.xax,155
			jae dech1L3
		rL3:
			cmp ca1.xax,180
			jae redoL3
			jmp goL3
		redoL3:

			mov shchk1,00
			jmp end2L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		goL3:
		
			add ca1.xax,3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		end2L3:
		
			jmp eeL3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		dechL3:

		mov ax,ya
		sub ax,4
		mov shcount1,ax
		cmp ca1.yax,ax
		ja d2L3
		jmp r1L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d2L3:
		
			add shcount1,45
			mov ax,shcount1
			cmp ca1.yax,ax
			jb deL3
			jmp r1L3
		
		dech1L3:
		cmp lr,1
		je decrightL3
		jmp decleftL3
		
		decrightL3:
		mov ax,ya
		sub ax,4
		mov shcount1,ax
		cmp ca1.yax,ax
		ja dL3
		jmp rL3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		dL3:
		
			add shcount1,65
			mov ax,shcount1
			cmp ca1.yax,ax
			jb deL3
			jmp rL3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		decleftL3:
		mov ax,ya
		sub ax,25
		mov shcount1,ax
		cmp ca1.yax,ax
		ja d1L3
		jmp rL3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d1L3:
		
			add shcount1,45
			mov ax,shcount1
			cmp ca1.yax,ax
			jb deL3
			jmp rL3
		
		deL3:

		dec health
		mov shchk1,00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		eeL3:

		jmp nc1L3
		dnmc1L3:
		
			mov ca1.xax,00
			mov ca1.yax,00
			mov ca1.clr,00
		nc1L3:

		
;cannon shoot2



			cmp cannonc01,00
			je movec10L3
			jmp dnmc10L3

		movec10L3:
		
			cmp shchk01,00
			je check10L3
			jmp end10L3
		check10L3:

			mov ax,c1.xax
			mov bx,c1.yax
			add bx,12
			add ax,35

			mov ca2.xax,ax
			mov ca2.yax,bx
			mov ca2.clr,41

			mov shchk01,1
		end10L3:
		
			cmp shchk01,1
			je check20L3
			jmp end20L3
			check20L3:
			cmp ca2.xax,120
			jae dech0L3
		r10L3:
			cmp ca2.xax,155
			jae dech10L3
		r0L3:
			cmp ca2.xax,180
			jae redo0L3
			jmp go0L3
		redo0L3:

			mov shchk01,00
			jmp end20L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		go0L3:
		
			add ca2.xax,3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		end20L3:
		
			jmp ee0L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		dech0L3:

		mov ax,ya
		sub ax,4
		mov shcount1,ax
		cmp ca2.yax,ax
		ja d20L3
		jmp r10L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d20L3:
		
			add shcount1,45
			mov ax,shcount1
			cmp ca2.yax,ax
			jb de0L3
			jmp r10L3
		
		dech10L3:
		cmp lr,1
		je decright0L3
		jmp decleft0L3
		
		decright0L3:
		mov ax,ya
		sub ax,4
		mov shcount1,ax
		cmp ca2.yax,ax
		ja d0L3
		jmp r0L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d0L3:
		
			add shcount1,65
			mov ax,shcount1
			cmp ca2.yax,ax
			jb de0L3
			jmp r0L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		decleft0L3:
		mov ax,ya
		sub ax,25
		mov shcount1,ax
		cmp ca2.yax,ax
		ja d10L3
		jmp r0L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d10L3:
		
			add shcount1,45
			mov ax,shcount1
			cmp ca2.yax,ax
			jb de0L3
			jmp r0L3
		
		de0L3:

		dec health
		mov shchk01,00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ee0L3:

		jmp nc10L3
		dnmc10L3:
		
			mov ca2.xax,00
			mov ca2.yax,00
			mov ca2.clr,00
		nc10L3:



			cmp cannonc2,00
			je movec101L3
			jmp dnmc101L3

		movec101L3:
		
			cmp shchk2,00
			je check101L3
			jmp end101L3
		check101L3:

			mov ax,c1.xax
			mov bx,c1.yax
			add bx,44
			add ax,35

			mov ca3.xax,ax
			mov ca3.yax,bx
			mov ca3.clr,40

			mov shchk2,1
		end101L3:
		
			cmp shchk2,1
			je check201L3
			jmp end201L3
			check201L3:
			cmp ca3.xax,120
			jae dech01L3
		r101L3:
			cmp ca3.xax,155
			jae dech101L3
		r01L3:
			cmp ca3.xax,180
			jae redo01L3
			jmp go01L3
		redo01L3:

			mov shchk2,00
			jmp end201L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		go01L3:
		
			add ca3.xax,3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		end201L3:
		
			jmp ee01L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		dech01L3:

		mov ax,ya
		sub ax,4
		mov shcount1,ax
		cmp ca3.yax,ax
		ja d201L3
		jmp r101L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d201L3:
		
			add shcount1,45
			mov ax,shcount1
			cmp ca3.yax,ax
			jb de01L3
			jmp r101L3
		
		dech101L3:
		cmp lr,1
		je decright01L3
		jmp decleft01L3
		
		decright01L3:
		mov ax,ya
		sub ax,4
		mov shcount1,ax
		cmp ca3.yax,ax
		ja d01L3
		jmp r01L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d01L3:
		
			add shcount1,65
			mov ax,shcount1
			cmp ca3.yax,ax
			jb de01L3
			jmp r01L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		decleft01L3:
		mov ax,ya
		sub ax,25
		mov shcount1,ax
		cmp ca3.yax,ax
		ja d101L3
		jmp r01L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		d101L3:
		
			add shcount1,45
			mov ax,shcount1
			cmp ca3.yax,ax
			jb de01L3
			jmp r01L3
		
		de01L3:

		dec health
		mov shchk2,00
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		ee01L3:

		jmp nc101L3
		dnmc101L3:
		
			mov ca3.xax,00
			mov ca3.yax,00
			mov ca3.clr,00
		nc101L3:

			cmp cannonc1,00
			je moveca1L3
			jmp dnmca1L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		moveca1L3:


		
;move cannons
				cmp count1,00
				je chk1L3
				jmp e1L3
			chk1L3:

					add C1.yax,2
					e1L3:
					cmp count1,1
					je chk2L3
					jmp e2L3
				chk2L3:

					sub C1.yax,2
				e2L3:
					mov ax,319
					sub ax,60
					cmp c1.yax,ax
					jae con1L3
					jmp e3L3
				con1L3:
					mov count1,1
				e3L3:
					cmp c1.yax,0
					je con2L3
					jmp e4L3
				con2L3:
					mov count1,00
					e4L3:

				jmp nca1L3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; for dead cannon
		dnmca1L3:
		
				mov c1.clr,39
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		nca1L3:

					
		;end cannons move

;robot shoot and update cannons health and score
		cmp rchk1,1
		je rshotL3
		jmp reeL3
	rshotL3:
		cmp rchk,00
		je rcheck1L3
		jmp rend1L3
	rcheck1L3:
		mov ax,xa
		mov bx,ya
		mov cl,45
		add bx,6
		add ax,0

		mov rob.xax,ax
		mov rob.yax,bx
		mov rob.clr,cl

		mov rchk,1
	rend1L3:
		cmp rchk,1
		je rcheck2L3
		jmp rend2L3
	rcheck2L3:
		cmp rob.xax,50
		jbe rdechL3
	rrL3:
		cmp rob.xax,25
		jbe rredoL3
		jmp rgoL3
	rredoL3:
		mov rchk,00
		mov rchk1,00
		jmp rend2L3
	rgoL3:
		sub rob.xax,3
		rend2L3:
		jmp reeL3
	;to shoot cannon1
	rdechL3:
		mov ax,c1.yax
		mov shcount1,ax
		cmp rob.yax,ax
		ja rdL3
		jmp rrL3
	rdL3:
		add shcount1,35
		mov ax,shcount1
		cmp rob.yax,ax
		jb rdeL3
		jmp rrL3
	rdeL3:
		cmp c1.life,00
		ja doh1L3
		jmp nh1L3
	doh1L3:
		dec c1.life
		inc score
	nh1L3:
		mov rchk,00
		mov rchk1,00

	reeL3:



		cmp rchk01,1
		je rshots2L3
		jmp rees2L3
	rshots2L3:
		cmp rchk0,00
		je rcheck1s2L3
		jmp rend1s2L3
	rcheck1s2L3:
		mov ax,xa
		mov bx,ya
		mov cl,45
	cmp lr,1
	je riL3
	jmp lefL3
	riL3:
		add bx,47
		add ax,35
		jmp jmpmoveL3
	lefL3:
		sub bx,16
		add ax,35
	jmpmoveL3:
		
		mov rob2.xax,ax
		mov rob2.yax,bx
		mov rob2.clr,cl

		mov rchk0,1
	rend1s2L3:
		cmp rchk0,1
		je rcheck2s2L3
		jmp rend2s2L3
	rcheck2s2L3:
		cmp rob2.xax,50
		jbe rdechs2L3
	rrs2L3:
		cmp rob2.xax,25
		jbe rredos2L3
		jmp rgos2L3
	rredos2L3:
		mov rchk0,00
		mov rchk01,00
		jmp rend2s2L3
	rgos2L3:
		sub rob2.xax,3
		rend2s2L3:
		jmp rees2L3
	;to shoot cannon1
	rdechs2L3:
		mov ax,c1.yax
		mov shcount1,ax
		cmp rob2.yax,ax
		ja rds2L3
		jmp rrs2L3
	rds2L3:
		add shcount1,35
		mov ax,shcount1
		cmp rob2.yax,ax
		jb rdes2L3
		jmp rrs2L3
	rdes2L3:
		cmp c1.life,00
		ja doh1s2L3
		jmp nh1s2L3
	doh1s2L3:
		dec c1.life
		inc score
		inc score
	nh1s2L3:
		mov rchk0,00
		mov rchk01,00

	rees2L3:

	
;takes input from keyboard
		mov ah,01
		int 16h

		jz GooutL3 ;for buffer purpose

; moves robot from control keys
		;cmp ah,48h
		;je up
		cmp ah,4Bh
		je leftL3
		cmp ah,4Dh
		je rightL3
		;cmp ah,50h
		;je down
		jmp e01L3
		;up:
		;dec xa;
		;call DisplayL3
		;jmp e1

		;down:
		;inc xa;
		;call DisplayL3
		;jmp e1
	rightL3:
		cmp ya,265
		jb right1L3
		jmp e01L3
	right1L3:
		mov lr,1
		add ya,5
		call DisplayL3
		jmp e01L3
	leftL3:
		cmp ya,20
		ja left1L3
		jmp e01L3
	left1L3:
		mov lr,0
		sub ya,5
		call DisplayL3
		jmp e01L3
	e01L3:


;to pause game when p is pressed
		cmp ah,19h
		je pauseL3
	resumeL3:

;check for robot to shoot
		cmp ah,21h
		je rshL3
		jmp rnotL3
	rshL3:

	
	
		mov rchk1,1

	rnotL3:
	
;check for robot to shoot
		cmp ah,39h
		je rsh2L3
		jmp rnot2L3
	rsh2L3:


		mov rchk01,1

	rnot2L3:


;terminates when escape is pressed
cmp ah,1
jne Repeat1L3

	jmp continueL3
;to pause
	pauseL3:
			mov si,00
			mov ty,12
			mov tx,15
			
		gopauseL3:
			
				mov counter,1
				mov al,pa[si]
				mov asc,al
				mov tc.clr,15
			call printchar
				inc si
				inc tx

			cmp pa[si],'$'
			jne gopauseL3

		mov ah,00
		int 16h

	cmp ah,13h
	jne pauseL3
	je resumeL3
;resume
		continueL3:

		jmp nglL3
;if lose
		goloseL3:
			
			call Displaylost
		nglL3:

		jmp ngwL3
;if win
	gowingL3:
		
			call Displaywin

	ngwL3:





	
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

;updates DisplayL3 while playing
DisplayL3 proc

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
	je printrshL3
	jmp notprL3

		printrshL3:
			mov p1.sx,3	;rows
			mov p1.sy,1	;cols
			mov ax,rob.xax
			mov bx,rob.yax
			mov cl,rob.clr
			mov p1.x,ax
			mov p1.y,bx
			mov p1.color,cl
	call filling

	notprL3:

	
	
;draw fire of robot after some checks
	cmp rchk01,1
	je printrsh1L3
	jmp notpr1L3

		printrsh1L3:
			mov p1.sx,3	;rows
			mov p1.sy,4	;cols
			mov ax,rob2.xax
			mov bx,rob2.yax
			mov cl,rob2.clr
			mov p1.x,ax
			mov p1.y,bx
			mov p1.color,cl
	call filling

	notpr1L3:


	cmp lr,1
	je drL3
	jmp dleL3
	drL3:
		call drawroborL3;draws robot
		jmp dendL3
	dleL3:
		call drawrobolL3
	dendL3:
		
	;draws cannon1
			mov ax,c1.xax
			mov bx,c1.yax
			mov cl,c1.clr
			mov tc.xax,ax
			mov tc.yax,bx
			mov tc.clr,cl

		call drawcannonL3

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
			can1L3:
				mov counter,1
				mov al,c1life[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				dec t1
				inc tx

			cmp t1,00
			ja can1L3

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
			rlL3:
				mov counter,1
				mov al,rlife[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				inc tx

			cmp rlife[si],'$'
			jne rlL3

			mov si,00
;prints score
			mov ty,24
			mov tx,25
			scL3:
				mov counter,1
				mov al,scr[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				inc tx
			cmp scr[si],'$'
			jne scL3
;prints score in double digit
			mov ty,24
			mov tx,33


		 mov ax, score
		 mov enteredNumber,ax

		 BreakItL3:
				 mov ax,enteredNumber
				 mov dx,0      ;AX= Quotient, DX= Remainder
				 mov bx,10
				 div bx   
				 push dx      ;Dx: Remainder   
				 inc digitCount
				 mov enteredNumber,ax
				 cmp enteredNumber,0
			je DisplayItL3 

		 jmp BreakItL3

;Printing all digits from stack
		 
		 DisplayItL3: 
				 cmp digitCount,0
				 je exitpL3
				 dec digitCount 
				 pop dx
				 add dl,48
				mov counter,1
				 mov asc,dl
				 mov tc.clr,15
				 inc tx
			 call printchar
		 
			jmp DisplayItL3
		 
		 
		 exitpL3:

;prints level
			mov si,00

			mov ty,24
			mov tx,15

			lvL3:
				mov counter,1
				mov al,lvl[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				inc tx

			cmp lvl[si],'$'
			jne lvL3
			
			
			mov ty,24
			mov tx,22
			mov counter,1
			mov al,level
			mov asc,al
			add asc,48
			mov tc.clr,1
		call printchar

ret
DisplayL3 endp
;DisplayL3 ends


;updates display while playing
DisplayL2 proc

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
		mov p1.sy,2	;cols
		mov ax,ca1.xax
		mov bx,ca1.yax
		mov cl,ca1.clr
		mov p1.x,ax
		mov p1.y,bx
		mov p1.color,cl
	call filling

;draw fire of cannon2
		mov p1.sx,3	;rows
		mov p1.sy,2	;cols
		mov ax,ca2.xax
		mov bx,ca2.yax
		mov cl,ca2.clr
		mov p1.x,ax
		mov p1.y,bx
		mov p1.color,cl
	call filling

;draw fire of robot after some checks
	cmp rchk1,1
	je printrshL2
	jmp notprL2

		printrshL2:
			mov p1.sx,3	;rows
			mov p1.sy,2	;cols
			mov ax,rob.xax
			mov bx,rob.yax
			mov cl,rob.clr
			mov p1.x,ax
			mov p1.y,bx
			mov p1.color,cl
	call filling

	notprL2:

	
	cmp rchk01,1
	je printrsh2L2
	jmp notpr2L2

		printrsh2L2:
			mov p1.sx,3	;rows
			mov p1.sy,2	;cols
			mov ax,rob2.xax
			mov bx,rob2.yax
			mov cl,rob2.clr
			mov p1.x,ax
			mov p1.y,bx
			mov p1.color,cl
	call filling

	notpr2L2:


	
		call drawroboL2;draws robot

	;draws cannon1
			mov ax,c1.xax
			mov bx,c1.yax
			mov cl,c1.clr
			mov tc.xax,ax
			mov tc.yax,bx
			mov tc.clr,cl

		call drawcannon

	;draws cannon2
		mov ax,c2.xax
		mov bx,c2.yax
		mov cl,c2.clr
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
			can1L2:
				mov counter,1
				mov al,c1life[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				dec t1
				inc tx

			cmp t1,00
			ja can1L2

		mov p1.sx,9	;rows
		mov p1.sy,58	;cols
		mov p1.x,7
		mov p1.y,71
		mov p1.color,15
	call pixel



;draws cannon2 life
			mov t1,7
			mov si,00

			mov ty,1
			mov tx,32
			mov al,c2.life
			mov ah,0
			mov counter,ax
			mov asc,219
			mov al,c2.clr
			mov tc.clr,al
		call printchar

			mov ty,1
			mov tx,24
			can2L2:
				mov counter,1
				mov al,c2life[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				dec t1
				inc tx

			cmp t1,00
			ja can2L2

		mov p1.sx,9	;rows
		mov p1.sy,58	;cols
		mov p1.x,7
		mov p1.y,255
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
			rlL2:
				mov counter,1
				mov al,rlife[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				inc tx

			cmp rlife[si],'$'
			jne rlL2

			mov si,00
;prints score
			mov ty,24
			mov tx,25
			scL2:
				mov counter,1
				mov al,scr[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				inc tx
			cmp scr[si],'$'
			jne scL2
;prints score in double digit
			mov ty,24
			mov tx,33


		 mov ax, score
		 mov enteredNumber,ax

		 BreakItL2:
				 mov ax,enteredNumber
				 mov dx,0      ;AX= Quotient, DX= Remainder
				 mov bx,10
				 div bx   
				 push dx      ;Dx: Remainder   
				 inc digitCount
				 mov enteredNumber,ax
				 cmp enteredNumber,0
			je DisplayItL2 

		 jmp BreakItL2

;Printing all digits from stack
		 
		 DisplayItL2: 
				 cmp digitCount,0
				 je exitpL2
				 dec digitCount 
				 pop dx
				 add dl,48
				mov counter,1
				 mov asc,dl
				 mov tc.clr,15
				 inc tx
			 call printchar
		 
			jmp DisplayItL2
		 
		 
		 exitpL2:

;prints level
			mov si,00

			mov ty,24
			mov tx,15

			lvL2:
				mov counter,1
				mov al,lvl[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				inc tx

			cmp lvl[si],'$'
			jne lvL2
			
			
			mov ty,24
			mov tx,22
			mov counter,1
			mov al,level
			mov asc,al
			add asc,48
			mov tc.clr,1
		call printchar
ret
DisplayL2 endp
;display ends


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
		mov p1.sy,2	;cols
		mov ax,ca1.xax
		mov bx,ca1.yax
		mov cl,ca1.clr
		mov p1.x,ax
		mov p1.y,bx
		mov p1.color,cl
	call filling

;draw fire of cannon2
		mov p1.sx,3	;rows
		mov p1.sy,2	;cols
		mov ax,ca2.xax
		mov bx,ca2.yax
		mov cl,ca2.clr
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

		call drawrobo;draws robot

	;draws cannon1
			mov ax,c1.xax
			mov bx,c1.yax
			mov cl,c1.clr
			mov tc.xax,ax
			mov tc.yax,bx
			mov tc.clr,cl

		call drawcannon

	;draws cannon2
		mov ax,c2.xax
		mov bx,c2.yax
		mov cl,c2.clr
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
		mov p1.sy,42	;cols
		mov p1.x,7
		mov p1.y,71
		mov p1.color,15
	call pixel



;draws cannon2 life
			mov t1,7
			mov si,00

			mov ty,1
			mov tx,32
			mov al,c2.life
			mov ah,0
			mov counter,ax
			mov asc,219
			mov al,c2.clr
			mov tc.clr,al
		call printchar

			mov ty,1
			mov tx,24
			can2:
				mov counter,1
				mov al,c2life[si]
				mov asc,al
				mov tc.clr,15
				call printchar
				inc si
				dec t1
				inc tx

			cmp t1,00
			ja can2

		mov p1.sx,9	;rows
		mov p1.sy,42	;cols
		mov p1.x,7
		mov p1.y,255
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

		mov p1.sx,7	;rows
		mov p1.sy,7	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,4
		mov p1.color,26

	call filling

		mov p1.sx,15	;rows
		mov p1.sy,1	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.y,8
		mov p1.color,26
	call filling

		mov p1.sx,13	;rows
		mov p1.sy,2	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.y,10
		mov bl,tc.clr
		mov p1.color,bl
	call filling

		mov p1.sx,11	;rows
		mov p1.sy,2	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.y,12
		mov bl,tc.clr
		mov p1.color,bl
	call filling

		mov p1.sx,5	;rows
		mov p1.sy,2	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,2
		add p1.y,14
		mov bl,tc.clr
		mov p1.color,bl
	call filling

		mov p1.sx,13	;rows
		mov p1.sy,4	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,4
		add p1.y,16
		mov bl,tc.clr
		mov p1.color,bl
	call filling



		mov p1.sx,7	;rows
		mov p1.sy,7	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.y,29
		add p1.x,4
		mov p1.color,26
	call filling

		mov p1.sx,15	;rows
		mov p1.sy,1	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.y,27
		mov p1.color,26
	call filling

		mov p1.sx,13	;rows
		mov p1.sy,2	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.y,24
		mov bl,tc.clr
		mov p1.color,bl
	call filling

		mov p1.sx,11	;rows
		mov p1.sy,2	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.y,22
		mov bl,tc.clr
		mov p1.color,bl
	call filling

		mov p1.sx,5	;rows
		mov p1.sy,2	;cols
		mov ax,tc.xax
		mov bx,tc.yax
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,2
		add p1.y,20
		mov bl,tc.clr
		mov p1.color,bl
	call filling

ret
drawcannon endp
;cannon display ends



;draws robot2 through 2 functions same as cannons
drawroboL2 proc


		mov p1.sx,16	;rows
		mov p1.sy,30	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,10
		add p1.y,10
		mov p1.color,1
	call filling

	;	mov p1.sx,20	;rows
	;	mov p1.sy,35	;cols
	;	mov ax,xa
	;	mov bx,ya
	;	add ax,15
	;	mov p1.x,ax
	;	mov p1.y,bx
	;	add p1.y,30
	;	mov p1.color,5
	;call pixel

		mov p1.sx,10	;rows
		mov p1.sy,24	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.y,13
		mov p1.color,1
	call filling



		mov p1.sx,2	;rows
		mov p1.sy,16	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,5
		add p1.y,17
		mov p1.color,15
	call filling
	
		mov p1.sx,2	;rows
		mov p1.sy,16	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		sub p1.x,2
		add p1.y,17
		mov p1.color,1
	call filling
	
		mov p1.sx,2	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		sub p1.x,4
		add p1.y,21
		mov p1.color,1
	call filling
	
		mov p1.sx,2	;rows
		mov p1.sy,2	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,5
		add p1.y,28
		mov p1.color,0
	call filling
	
		mov p1.sx,2	;rows
		mov p1.sy,2	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,5
		add p1.y,20
		mov p1.color,0
	call filling
	
		mov p1.sx,2	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,3
		add p1.y,22
		mov p1.color,0
	call filling
	
		mov p1.sx,2	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,15
		add p1.y,4
		mov p1.color,4
	call filling
	
		mov p1.sx,2	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,13
		add p1.y,0
		mov p1.color,4
	call filling
	
		mov p1.sx,2	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,17
		add p1.y,0
		mov p1.color,4
	call filling
	
		mov p1.sx,2	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,15
		add p1.y,40
		mov p1.color,4
	call filling
	
		mov p1.sx,2	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,13
		add p1.y,46
		mov p1.color,4
	call filling
	
		mov p1.sx,2	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,17
		add p1.y,46
		mov p1.color,4
	call filling
	
		mov p1.sx,6	;rows
		mov p1.sy,2	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,26
		add p1.y,16
		mov p1.color,4
	call filling
	
		mov p1.sx,6	;rows
		mov p1.sy,2	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,26
		add p1.y,32
		mov p1.color,4
	call filling
	
		mov p1.sx,3	;rows
		mov p1.sy,30	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,32
		add p1.y,10
		mov p1.color,4
	call filling
	
		mov p1.sx,8	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,29
		add p1.y,4
		mov p1.color,4
	call filling
	
		mov p1.sx,1	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,28
		add p1.y,5
		mov p1.color,4
	call filling
	
		mov p1.sx,1	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,37
		add p1.y,5
		mov p1.color,4
	call filling
	
		mov p1.sx,8	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,29
		add p1.y,40
		mov p1.color,4
	call filling
	
		mov p1.sx,1	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,28
		add p1.y,41
		mov p1.color,4
	call filling
	
		mov p1.sx,1	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,37
		add p1.y,41
		mov p1.color,4
	call filling
	
		mov p1.sx,4	;rows
		mov p1.sy,2	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		sub p1.x,4
		add p1.y,10
		mov p1.color,4
	call filling
	
		mov p1.sx,2	;rows
		mov p1.sy,12	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		sub p1.x,6
		add p1.y,4
		mov p1.color,4
	call filling
	
		mov p1.sx,4	;rows
		mov p1.sy,2	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		sub p1.x,4
		add p1.y,37
		mov p1.color,4
	call filling
	
		mov p1.sx,2	;rows
		mov p1.sy,12	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		sub p1.x,6
		add p1.y,35
		mov p1.color,4
	call filling

ret
drawroboL2 endp
;robot display ends



;draws cannon through two functions disscused later
drawcannonL3 proc

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
drawcannonL3 endp
;cannon DisplayL3 ends

;draws robot through 2 functions same as cannons
drawrobolL3 proc

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
drawrobolL3 endp




drawroborL3 proc

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
drawroborL3 endp

;robot DisplayL3 ends


;draws robot through 2 functions same as cannons
drawrobo proc

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

		mov p1.sx,6	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,42
		sub p1.y,3
		mov p1.color,29
	call filling


		mov p1.sx,7	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,49
		sub p1.y,2
		mov p1.color,45
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,56
		sub p1.y,4
		mov p1.color,45
	call pixel

		mov p1.sx,1	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,63
		sub p1.y,1
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


		mov p1.sx,6	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,42
		add p1.y,32
		mov p1.color,29
	call filling


		mov p1.sx,7	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,49
		add p1.y,33
		mov p1.color,45
	call filling

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,56
		add p1.y,31
		mov p1.color,45
	call pixel

		mov p1.sx,1	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,63
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

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,52
		add p1.y,8
		mov p1.color,45
	call pixel

		mov p1.sx,6	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,53
		add p1.y,9
		mov p1.color,29
	call filling

		mov p1.sx,5	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,60
		add p1.y,10
		mov p1.color,45
	call filling

		mov p1.sx,7	;rows
		mov p1.sy,12	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,65
		add p1.y,4
		mov p1.color,45
	call pixel

		mov p1.sx,5	;rows
		mov p1.sy,10	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,66
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

		mov p1.sx,8	;rows
		mov p1.sy,8	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,52
		add p1.y,19
		mov p1.color,45
	call pixel

		mov p1.sx,6	;rows
		mov p1.sy,6	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,53
		add p1.y,20
		mov p1.color,29
	call filling

		mov p1.sx,5	;rows
		mov p1.sy,4	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,60
		add p1.y,21
		mov p1.color,45
	call filling

		mov p1.sx,7	;rows
		mov p1.sy,12	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,65
		add p1.y,19
		mov p1.color,45
	call pixel

		mov p1.sx,5	;rows
		mov p1.sy,10	;cols
		mov ax,xa
		mov bx,ya
		mov p1.x,ax
		mov p1.y,bx
		add p1.x,66
		add p1.y,20
		mov p1.color,29
	call filling

ret
drawrobo endp
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