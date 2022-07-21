ORG 0000H
	LJMP MAIN

ORG 000BH
	LJMP TIMEROV

	LCD_data equ P2    ;LCD Data port
	LCD_rs   equ P0.0  ;LCD Register Select
	LCD_rw   equ P0.1  ;LCD Read/Write
	LCD_en   equ P0.2  ;LCD Enable

ORG 0030H
MAIN:
	ACALL START
	LJMP INTSETTINGS

ORG 0040H
START: 
	MOV P1,#0
	MOV P2,#0
	ACALL DELAY
	ACALL DELAY
	ACALL LCD_INIT
	ACALL DELAY
	MOV A,#80H
	ACALL LCD_COMMAND
	ACALL DELAY
	MOV DPTR,#my_string1
	ACALL LCD_SENDSTRNG
	ACALL DELAY
	ACALL DELAY
	MOV A,#0C0H
	ACALL LCD_COMMAND
	ACALL DELAY
	MOV DPTR,#my_string2
	ACALL LCD_SENDSTRNG
	ACALL DELAY
	ACALL DELAY
	ACALL DELAY_1S
	ACALL DELAY_1S
	MOV P1,#1FH
	ACALL DELAY
RET

ORG 00E0H
INTSETTINGS:
	MOV IE,#82H
	MOV TMOD,#01H
	MOV TL0,#07H 
	MOV TH0,#00H
	MOV R0,#00H
	SETB TR0
	
HERE: 
	MOV A,P1
	RRC A
	JC M1
	LJMP EXTINT0
	M1:
	SJMP HERE


ORG 0120H
EXTINT0:
	MOV TMOD,#00H
	CLR TR0
	MOV IE,#0
	MOV P1,#0
	MOV A,R0
	MOV B,#20H
	MUL AB
	ADD A,#60
	MOV 30H,A
	MOV A,B 
	JC O1
	SJMP O2
	O1: 
		INC A
	O2:MOV 31H,A
	MOV A,TH0 
	MOV B,#100
	DIV AB
	ADD A,30H
	MOV 30H,A
	JC Y1
	SJMP Y2
Y1: INC 31H
Y2: ACALL CONVERTDEC
	ACALL LCDEND
	LJMP MAIN



ORG 0200H
CONVERTDEC:
	MOV A,30H //d1 modulus start
	MOV B,#10
	DIV AB
	MOV R1,B
	MOV A,31H
	MOV B,#10
	DIV AB
	MOV A,#6
	MUL AB
	MOV B,#10
	DIV AB
	MOV A,R1
	ADD A,B
	MOV B,#10
	DIV AB
	MOV A,B
	ADD A,#30H
	MOV 36H,A //d1 modulus ends

	MOV A,30H //d1 division starts
	MOV B,#10
	DIV AB
	MOV R1,A
	MOV R2,B
	MOV A,31H
	MOV B,#10
	DIV AB
	MOV R3,A
	MOV R4,B
	MOV A,#6
	MUL AB
	ADD A,R2
	MOV B,#10
	DIV AB
	MOV R2,A
	MOV A,R4
	MOV B,#25
	MUL AB
	MOV R4,A //d1 division ends

	MOV A,R1 //d2 modulus starts
	MOV B,#10
	DIV AB
	MOV A,B
	ADD A,R2
	MOV 35H,A
	MOV A,R3
	MOV B,#6
	MUL AB
	MOV B,#10
	DIV AB
	MOV A,B
	ADD A,35H
	MOV 35H,A
	MOV A,R4
	MOV B,#10
	DIV AB
	MOV A,B
	ADD A,35H
	MOV B,#10
	DIV AB
	MOV A,B
	ADD A,#30H
	MOV 35H,A //d2 modulus ends

	MOV A,R1 //d2 division starts
	MOV B,#10
	DIV AB
	MOV R1,A
	MOV A,B
	ADD A,R2
	MOV R2,A
	MOV A,R3
	MOV B,#25
	MUL AB
	ADD A,R1
	MOV R1,A
	MOV A,R3
	MOV B,#6
	MUL AB
	ADD A,R2
	MOV R2,A
	MOV A,R4
	MOV B,#10
	DIV AB
	ADD A,R1
	MOV R1,A
	MOV A,B
	ADD A,R2
	MOV B,#10
	DIV AB
	ADD A,R1
	MOV R1,A //d2 division ends

	MOV A,R1 //d3,d4 modulus starts
	MOV B,#10
	DIV AB
	MOV R0,A
	MOV A,B
	ADD A,#30H
	MOV 34H,A
	MOV A,R0
	ADD A,#30H
	MOV 33H,A //d3,d4 modulus ends
RET

ORG 0300H
TIMEROV:
	CLR TR0
	MOV A,R0
	INC A
	MOV R0,A
	MOV TH0,#00H 
	MOV TL0,#05H
	SETB TR0
RETI

ORG 0400H
LCDEND:
	ACALL LCD_INIT
	ACALL DELAY
	MOV A,#80H
	ACALL LCD_COMMAND
	ACALL DELAY
	MOV DPTR,#my_string3
	ACALL LCD_SENDSTRNG
	ACALL DELAY
	ACALL DELAY
	MOV A,#0C0H
	ACALL LCD_COMMAND
	ACALL DELAY
	MOV A,33H
	ACALL lcd_senddata
	ACALL DELAY
	ACALL DELAY
	MOV A,#0C1H
	ACALL LCD_COMMAND
	ACALL DELAY
	MOV A,34H
	ACALL lcd_senddata
	ACALL DELAY
	ACALL DELAY
	MOV A,#0C2H
	ACALL LCD_COMMAND
	ACALL DELAY
	MOV A,35H
	ACALL lcd_senddata
	ACALL DELAY
	ACALL DELAY
	MOV A,#0C3H
	ACALL LCD_COMMAND
	ACALL DELAY
	MOV A,36H
	ACALL lcd_senddata
	ACALL DELAY 
	ACALL DELAY
	ACALL DELAY
	MOV A,#0C5H
	ACALL LCD_COMMAND
	ACALL DELAY
	MOV DPTR,#my_string4
	ACALL LCD_SENDSTRNG
	ACALL DELAY 
	ACALL DELAY
	
	ACALL DELAY_1S
	ACALL DELAY_1S
	ACALL DELAY_1S
	ACALL DELAY_1S
	ACALL DELAY_1S
    RET

ORG 0500H
DELAY_1S:
	MOV R1,#40
	MOV TMOD,#01H
TP:	MOV TL0,#0B1H
	MOV TH0,#30H
	SETB TR0
TP1: JNB TF0,TP1
	CLR TR0
	CLR TF0
	DJNZ R1,TP
RET

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
lcd_sendstrng:
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



ORG 0800H
my_string1: DB "Toggle SW1",00H 

my_string2: DB "if LED glows",00H 

my_string3: DB "Reaction time",00H 

my_string4: DB "milliseconds",00H

END