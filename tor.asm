output macro string,x,y				;виведення рядка символів
		mov ah,02h						;код переривання 
		mov bh,0						;номер відеосторінки 
		mov dh,y						;
		mov dl,x 						;координати
		int 10h						;переміщення курсору
		mov dx,offset string
		mov ah,9
		int 21h
	endm
draw macro char,x,y,num,col		;макрос для виведення символу
		push cx
		mov ah,02h						;код переривання 
		mov bh,0						;номер відеосторінки 
		mov dh,y						;
		mov dl,x 						;координати
		int 10h							;переміщення курсору
		mov ax,char						;символ
		mov ah,0ah						;код переривання 
		mov bl,col						;колір 		
		mov cx,num						;кількість повторень 
		int 10h							;виведення символу
		pop cx
	endm
cleanpart macro					;очищення ділянки екрану
		mov ax,0600h			;код переривання 
		mov cx,0000			;лівий верхній кут
		mov dx,4318h			;правий нижній кут
		mov bh,BLACK			;колір заливки 
		int 10h					;очищення
	endm
show_all_inf macro					;відображення усієї інформації
		putNw R_big,71,14,6,RED
		putNw r,71,15,6,RED
		putNw gr_alfa,71,16,6,RED
		putNw gr_beta,71,17,6,RED
		putNw gr_gamma,71,18,6,RED
		putNw X0,71,19,6,RED
		putNw Y0,71,20,6,RED
	endm

torX macro col

 push cx
 finit
 fld fi         ;занесення в стек співпроцесора поч значення параметру фі
 fadd dfi
 fstp fi
 fld fi
 fcos
 fimul r      ;rcosfi
 fstp rcosfi
 fld  rcosfi
 fld R_big
 fadd    ;R+rcosfi
 fstp S1      ;R+rcosfi=S1
  
  fld ksi
  fadd dksi
 fstp ksi
 fld ksi
  fcos
  fstp cosksi;
  fld S1
  fld cosksi
  fmul
  frndint
  fistp X1

 
  fld ksi
  fadd dksi
 fstp ksi
 fld ksi
  fsin
  fstp sinksi
  fld S1
  fld sinksi
  fmul
  frndint
  fistp Y1

    mov cx,X1
                add cx,X0
		mov dx,Y1
                add dx,Y0
		mov ah,0Ch 			;будування точки
		mov al,col 			;колір точки
		mov bh,0 				;номер відео сторінки 
		int	10h				;виклик переривання     
pop cx
endm








	
tor macro col
 push cx
 finit

;___________________prepare_______________________
 fld fi         ;занесення в стек співпроцесора поч значення параметру фі
 fadd dfi
 fstp fi
 fld fi
 fcos
 fimul r      ;rcosfi
 fistp rcosfi
 fild  rcosfi
 fild R_big
 fadd ;R_big    ;R+rcosfi
 fstp S1      ;R+rcosfi=S1
  
 

 fld fi         ;
 fadd dfi
 fstp fi
 ;fmul rad_to_pi
 fld fi
 fsin
 fimul r          ;sinfi
 fstp S          ; rsinfi=S
 


 fld ksi       ;заносим параметр ксы
 fadd dksi
 fstp ksi
 ;fmul rad_to_pi
 fld ksi
 fsin
 fstp sinksi     ;sinksi


 fld ksi         ;заносим параметр ксы
 fadd dksi
 fstp ksi
 ;fmul rad_to_pi
 fld ksi
 fcos
 fstp cosksi     ;cosksi

 
 fld alfa
 fsin
 fstp sinalfa    ;sinalfa
 
 fld beta
 fsin
 fstp sinbeta   ;sinbeta

 fld gamma
 fsin
 fstp singamma   ;singamma 

 fld alfa
 fcos
 fstp cosalfa    ;cosalfa

 fld beta
 fcos
 fstp cosbeta    ;cosbeta

 fld gamma
 fcos
 fstp cosgamma    ;cosgamma

;______________________X1__________________________
 fld sinbeta
 fld cosalfa
 fmul
 fld cosgamma
 fmul
 fstp b_a_g
 
 fld sinalfa
 fld singamma
 fmul
 fstp a_g
 
 fld  b_a_g
 fld a_g
 fsub
 fstp skobka1

 fld cosbeta
 fld cosksi
 fmul
 fld cosgamma
 fmul
 fstp b_k_g

 fld sinbeta
 fld sinksi
 fmul
 fld cosgamma
 fmul
 fld sinalfa
 fmul
 fstp b_k_g_a

 fld cosalfa
 fld singamma
 fmul
 fld sinksi
 fmul
 fstp a_g_k

 fld b_k_g
 fld b_k_g_a
 fadd
 fld a_g_k
 fsub
 fstp skobka2

 fld S
 fld skobka1
 fmul
 fstp S_skobka1
 fld S1
 fld skobka2
 fmul 
 fstp S1_skobka2
  fld S_skobka1
  fld S1_skobka2
  fadd
  frndint
  fistp X1
;_____________________Y1___________________________

 
fld sinbeta
 fld cosalfa
 fmul
 fld singamma
 fmul
 fstp y_b_a_g
 
 fld sinalfa
 fld cosgamma
 fmul
 fstp y_a_g
 
 fld  b_a_g
 fld a_g
 fadd
 fstp skobka3

 fld cosalfa
 fld sinksi
 fmul
 fld cosgamma
 fmul
 fstp y_b_k_g

 fld sinalfa
 fld sinksi
 fmul
 fld sinbeta
 fmul
 fld singamma
 fmul
 fstp y_b_k_g_a

 fld cosksi
 fld singamma
 fmul
 fld cosbeta
 fmul
 fstp y_a_g_k

 fld y_b_k_g
 fld y_b_k_g_a
 fadd
 fld y_a_g_k
 fadd
 fstp skobka4

 fld S
 fld skobka3
 fmul
 fstp S_skobka3
 fld S1
 fld skobka4
 fmul 
 fstp S1_skobka4
  fld S_skobka3
  fld S1_skobka4
  fadd
  frndint
  fistp Y1

                mov cx,X1
                add cx,X0
		mov dx,Y1
                add dx,Y0
		mov ah,0Ch 			;будування точки
		mov al,col 			;колір точки
		mov bh,0 				;номер відео сторінки 
		int 10h				;виклик переривання 
		pop cx
	endm


Rad_to_grad macro _rad,_grad		;перетворення радіан в градуси 
		finit
		fld r_t_p
		fld _rad
		fmul
		frndint
		fistp _grad
	endm
Grad_to_rad macro _grad,_rad		;перетворення градусів у радіани
		finit
		fild _grad
		fdiv r_t_p		
		fstp _rad
	endm




init_video macro video				;установка відео режиму
		mov ah,0 				;код переривання 
		mov al,video 			;номер відео режиму
		int 10h 				;виклик переривання 
	endm
putNw macro num,x,y,n,col 			;макрос для виведення числа(параметри розміщуються в стеці і потім викликається процедура)
		push word ptr num
		mov bl,x
		mov bh,y
		push bx
		push n
		xor bx,bx
		mov bl,col
		push bx
		call putN
	endm
input_macro macro n,val,max,x,y,z	;макрос для введення даних з клавіатури 
		putNw val,x,y,6,YELLOW		;підсвічування жовтим виділеного числа
@rk&n:		
		mov ah,00
		int 16h				;зчитування символа з клавіатури 
		cmp al,9			;символ табуляции
		jz tab				;якщо рівно 
		cmp al,13			;повернення каретки
		jz dectab&n
		cmp al,27		
		jz exit
		cmp al,30h			;якщо ноль														
		jl @rk&n
		cmp al,3Ah
		jnl @rk&n
		sub al,30h
		cmp input_n,0
		jnz @next&n			;якщо не ривно 0
		mov input_n,1
		mov val,0
@next&n:	
		xor ah,ah
		mov bx,ax
		mov ax,val
		mov cx,10
		mul cx
		shld edx,edx,16
		add ax,bx
		mov dx,ax
		cmp edx,max
		jl @out&n   ;якщо менше максимального числа
		mov ax,max
		
@out&n:		mov val,ax
                
		putNw val,x,y,6,YELLOW
		ifnb <z>
			Grad_to_rad gr_alfa,alfa
			Grad_to_rad gr_beta,beta			;у випадку вводу градусів відбувається переведення в радіани
			Grad_to_rad gr_gamma,gamma
		endif
		jmp @rk&n
dectab&n:dec tab_val					;для того щоб виділення починалося з попереднього числа
		jmp BEGIN
	endm

window macro

		draw 205,65,1,19,GREEN
		draw 205,65,24,19,GREEN
		draw 201,65,1,1,GREEN
		draw 200,65,24,1,GREEN
		draw 187,79,1,1,GREEN
		draw 188,79,24,1,GREEN
		mov cl,24
@@w1:	SUB CL,1
		draw 186,79,cl,1,GREEN
		draw 186,65,cl,1,GREEN
		cmp cl,2
		jz @@next
		jmp  NEAR ptr @@w1
@@next:

		draw 204,65,13,1,GREEN
		draw 185,79,13,1,GREEN
		draw 205,66,13,13,GREEN
		draw 17,71,14,1,GREEN
		draw 17,71,15,1,GREEN
		draw 17,71,16,1,GREEN
		draw 17,71,17,1,GREEN
		draw 17,71,18,1,GREEN
		draw 17,71,19,1,GREEN
		draw 17,71,20,1,GREEN
		draw 16,78,14,1,GREEN
		draw 16,78,15,1,GREEN
		draw 16,78,16,1,GREEN
		draw 16,78,17,1,GREEN
		draw 16,78,18,1,GREEN
		draw 16,78,19,1,GREEN
		draw 16,78,20,1,GREEN
                output help1,66,2
		output help2,66,3
		output help3,66,4
		output help6,66,5
		output help5,66,6
		output help7,66,7
		output help8,66,8
		output help9,66,9
		output help10,66,10
                output inf1,66,14
		output inf2,66,15
		output inf3,66,16
		output inf4,66,17
		output inf5,66,18
		output inf6,66,19
		output inf7,66,20
		output inf8,66,23
		
endm

.model small
.stack 100h
.386

LOCALS
Mode_13=0Dh
Mode_6A=6Ah
GREEN=1010b
BLACK=0000b
YELLOW=1110b
RED=1100b
;----------------------------------------
.data
SaveMode db ?
X0 dw 100
Y0 dw 100
X1 dw 0
Y1 dw 0
fi dd 0.0
dfi dd 0.015
ksi dd 0.0
sinksi dd 0
cosksi dd 0
dksi dd 0.015
r  dw 20
R_big  dw 50
tab_val dw 0 		;номер виділеного рядка при натисканні на tab
input_n	db 0 		;змінна яка показує чи відбувається введення чисел 
alfa dd 0.0             ;кут нахилу тора відносно осі Х 
beta dd 0.0		;кут нахилу тора відносно осі Y 
gamma dd 0.0		;кут нахилу тора відносно осі Z 
gr_alfa dw 0              ;кут нахилу тора відносно осі Х 
gr_beta dw 0		;кут нахилу тора відносно осі Y 
gr_gamma dw 0		;кут нахилу тора відносно осі Z 
cosalfa dd 0              ;cosкут нахилу тора відносно осі Х 
cosbeta dd 0		;cosкут нахилу тора відносно осі Y
cosgamma dd 0	
sinalfa dd 1              ;sinкут нахилу тора відносно осі Х 
sinbeta dd 1		;sinкут нахилу тора відносно осі Y 
singamma dd 1
d_alfa  dd 0.1
d_beta dd 0.1
d_gamma dd 0.1	
rcosfi dd 0.0
S1 dd 0.0
S dd 0.0
S_skobka1 dd 0     ;тимчасові змінні
S1_skobka2 dd 0
skobka1 dd 0
skobka2 dd 0
b_a_g dd 0
a_g   dd 0
b_k_g dd 0
b_k_g_a dd 0
a_g_k  dd 0
y_b_a_g dd 0
y_a_g   dd 0
y_b_k_g dd 0
y_b_k_g_a dd 0
y_a_g_k  dd 0
S_skobka3 dd 0
S1_skobka4 dd 0
skobka3 dd 0
skobka4 dd 0
R_r dw 0
Y0_R dw 0
Y0_R1 dw 0
X0_R dw 0
X0_R1 dw 0

;___________const____________________
col db 9
_deg dw 4000
tenw 		dw 10;
r_t_p		dd 57.32;
help2 	db "1,3- Pixel",0Dh,0Ah,'$'
help1 	db "r - Color",0Dh,0Ah,'$'
help3 	db "a,b,c - kytu",0Dh,0Ah,'$'
help5 	db "Esc - Exit",0Dh,0Ah,'$'
help6   db "x,y,z - kytu",0Dh,0Ah,'$'
help7 	db 30," - Up",0Dh,0Ah,'$'
help8 	db 31," - Down",0Dh,0Ah,'$'
help9 	db 17," - Left",0Dh,0Ah,'$'
help10 	db 16," - Right",0Dh,0Ah,'$'
		inf1 		db "R -",0Dh,0Ah,'$'
		inf2 		db "r -",0Dh,0Ah,'$'
		inf3 		db "alfa-",0Dh,0Ah,'$'
		inf5 		db "gama-",0Dh,0Ah,'$'
		inf4 		db "beta-",0Dh,0Ah,'$'
		inf6  		db "X0-",0Dh,0Ah,'$'
		inf7 		db "Y0-",0Dh,0Ah,'$'
		inf8 		db "Tab-change",0Dh,0Ah,'$'


.code
;------------------------------------------------------
main proc
	mov ax,@data			;
	mov ds,ax ; 
	mov ah,0Fh
	int 10h
	mov SaveMode,al
	init_video Mode_13 ; Переключиться в графический режим
	window
begin: 
	 

        cleanpart
	show_all_inf
        call graf_tor      

BEGIN1:
     
		mov ah,0
      		int 16h
		
		cmp al,27
		jz exit
		cmp al,9
		jz tab
                cmp al,114
		jz color
	        cmp al,49
		jz num1
		cmp al,51
		jz num3			
		cmp al,97
		jz numa	
		cmp al,98
		jz numb	
		cmp al,99
		jz numc	
		cmp al,120
		jz numx	
		cmp al,121
		jz numy	
		cmp al,122
		jz numz
			cmp al,00
			jne begin1
			cmp ah,48h
			jz up
			
			cmp ah,50h
			jz down
			
			cmp ah,4Dh
			jz right
			
			cmp ah,4Bh
			jz left
		jmp BEGIN1


tab:		inc tab_val
		mov input_n,0
		show_all_inf
		cmp tab_val,1
		jz @a1
		cmp tab_val,2
		jz @a2
		cmp tab_val,3
		jz @a3
		cmp tab_val,4
		jz @a4
		cmp tab_val,5
		jz @a5
		;cmp tab_val,6
		;jz @a6
		;cmp tab_val,7
		;jz @a7
		mov tab_val,1
@a1:	input_macro  1,R_big,60,71,14
@a2:	input_macro  2,r,38,71,15
@a3:	input_macro  3,gr_alfa,360,71,16,1
@a4:	input_macro  4,gr_beta,360,71,17,1
@a5:	input_macro  5,gr_gamma,360,71,18,1
;@a6:    input_macro  6,X0,150,71,19
;@a7:    input_macro  7,Y0,150,71,20

color: 
	add col,1
        jmp begin

num3:	
		cmp _deg,29000
		jg begin1      ;якщо быльше
		add _deg,1000
		jmp BEGIN
num1:	
		cmp _deg,1001
		jl begin1     ;  якщо менше
		sub _deg,1000
		jmp BEGIN

numa:	
		cmp gr_alfa,360
		jg BEGIN1
		fld alfa
  		fadd d_alfa
		fstp alfa
		Rad_to_grad alfa,gr_alfa ;кут
		jmp BEGIN
numb:
		cmp gr_beta,360
		jg BEGIN1
		fld beta
		fadd d_beta
		fstp beta
		Rad_to_grad beta,gr_beta ;кут
		jmp BEGIN
numc:
		cmp gr_gamma,360
		jg BEGIN1
		fld gamma
		fadd d_gamma
		fstp gamma
		Rad_to_grad gamma,gr_gamma ;кут
		jmp BEGIN

numx:
		cmp gr_alfa,5
		jle BEGIN1
		fld alfa
		fsub d_alfa
		fstp alfa
		Rad_to_grad alfa,gr_alfa ;кут
		jmp BEGIN
numy:
		cmp gr_beta,5
		jle BEGIN1
		fld beta
		fsub d_beta
		fst beta
		Rad_to_grad beta,gr_beta ;кут
		jmp BEGIN
numz:
		cmp gr_gamma,5
		jle BEGIN1
		fld gamma
		fsub d_gamma
		fst gamma
		Rad_to_grad gamma,gr_gamma ;кут
		jmp BEGIN

up:
	fild R_big
	fild r
	fadd 
	fistp R_r
	fild Y0
	fild R_r
	fsub 
	fistp Y0_R
	sub Y0_R,5
	mov ax,Y0_R	
	cmp ax,0
	jl BEGIN1
	sub Y0,5
	jmp BEGIN
	

down:
	fild R_big
	fild r
	fadd 
	fistp R_r
	fild Y0
	fild R_r
	fadd 
	fistp Y0_R1
	add Y0_R1,5
	mov ax,Y0_R1	
	cmp ax,195
	jg BEGIN1
	add Y0,5
	jmp BEGIN

left:
	fild R_big
	fild r
	fadd 
	fistp R_r
	fild X0
	fild R_r
	fsub 
	fistp X0_R
	sub X0_R,5
	mov ax,X0_R	
	cmp ax,0
	jl BEGIN1
	sub X0,5
	jmp BEGIN

right:
	fild R_big
	fild r
	fadd 
	fistp R_r
	fild X0
	fild R_r
	fadd 
	fistp X0_R1
	add X0_R1,5
	mov ax,X0_R1	
	cmp ax,195
	jg BEGIN1
	add X0,5
	jmp BEGIN


exit:	init_video saveMode
		mov ax,4c00h
		int 21h

main endp
;-----------------------------------------------------------
graf_tor proc near
		mov fi,0
		mov cx,_deg
beginpr:        tor col
		cmp cx,1
		jz ex
		sub cx,1
jmp beginpr
ex:		
ret

graf_tor endp
;---------------------------------------------------------
putN proc near				;процедура для виведення числа
		push bp
		mov bp,sp
		mov cx,[bp+6]
		mov ax,[bp+10]
@@a:	xor dx,dx
		div tenw
		push ax
		add dx,30h
		push dx					;занесення символу в стек
		mov ah,02h				;код переривання 
		mov bh,0				;номер відеосторінки 
		mov dx,[bp+8]			;координати
		add dl,cl
		int 10h					;переміщення курсору
		pop ax					;символ
		mov ah,0ah				;код переривання 
		mov bx,[bp+4]				;колір 
		push cx
		mov cx,1				;кількість повторень 
		int 10h					;виведення символу
		pop cx
		pop ax
		loop @@a
@@exit:	pop bp
		ret 8
putN endp
;----------------------------------------------------------------	
end main