ORG 0000H
	LJMP MAIN

ORG 001BH
	LJMP ISR

ORG 002FH
MAIN:

LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

start:
      mov P2,#00h
      mov P1,#00h
	  ;initial delay for lcd power up

	;here1:setb p1.0
      	  acall delay
	;clr p1.0
	  acall delay
	;sjmp here1


	  acall lcd_init      ;initialise LCD
	
	  acall delay
	  acall delay
	  acall delay
	  mov a,#80h		 ;Put cursor on first row,5 column
	  acall lcd_command	 ;send command to LCD
	  acall delay
	  mov   dptr,#my_string   ;Load DPTR with sring1 Addr
	  acall lcd_sendstring	   ;call text strings sending routine
	  acall delay 

MOV IE,#88H
MOV TMOD,#11H
MOV R5,#3CH
MOV R4,#0ADH


MOV R1,#50H
CLR P0.7
SETB TR1
G:
JB TR1,Y11		//0hz
SJMP Y12
Y11:SJMP G
Y12: NOP   //silence - 2s


MOV R1,#1EH
MOV R3,#0EEH
MOV R2,#46H  //220Hz
SETB TR1
ACALL FREQ //N1-750ms

MOV R1,#1EH
MOV R3,#0F0H
MOV R2,#37H  //247hz
SETB TR1
ACALL FREQ //N2-750ms

MOV R1,#1EH
MOV R3,#0F2H
MOV R2,#0BEH  //294hz
SETB TR1
ACALL FREQ //N3-750ms

MOV R1,#1EH
MOV R3,#0F0H
MOV R2,#37H  //247hz
SETB TR1
ACALL FREQ //N2-750ms



MOV R1,#28H
MOV R3,#0F5H
MOV R2,#78H   //370hz
SETB TR1
ACALL FREQ //N4-1000ms


MOV R1,#14H
CLR P0.7
SETB TR1
HERE:
JB TR1,Y1		//0hz
SJMP Y2
Y1:SJMP HERE
Y2: NOP   //silence - 1000ms



MOV R1,#28H
MOV R3,#0F5H
MOV R2,#78H		//370hz
SETB TR1
ACALL FREQ //N4-1000ms

MOV R1,#28H
MOV R3,#0F4H
MOV R2,#31H		//330hz
SETB TR1
ACALL FREQ //N5-1000ms

LJMP MAIN
;------------------------LCD Initialisation routine----------------------------------------------------
lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret





FREQ: 
    CPL P0.7         //1
	ACALL del   	//2
	JNB TR1,U1		//2
	SJMP FREQ        //2
U1: RET             //2
	
del:
	MOV TH0,03H		//2
	MOV TL0,02H		//2
	SETB TR0	 	//1
D1: JNB TF0,D1		//2
	CLR TR0			//1
	CLR TF0			//1
RET					//2


ORG 5000H
ISR:
	MOV TH1,05H
	MOV TL1,04H
	DJNZ R1,M1
	CLR TR1
M1: RETI

ORG 3000H
	my_string: DB "ROLLING TIME *_*",00H
END

































