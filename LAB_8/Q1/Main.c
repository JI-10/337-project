#include <at89c5131.h>
#include "lcd.h"				//Header file with LCD interfacing functions
#include "MorseCode.h"	//Header file for Morse Code 

sbit LED=P0^7;
sbit P10=P1^0;
sbit P11=P1^1;
sbit P12=P1^2;
sbit P13=P1^3;

//Main function
void main(void)
{
	P1=0xFF;
	msdelay(3000);
	//Call initialization functions
	lcd_init();
	if(P10==0){
		lcd_cmd(0x80);
		msdelay(2);
		lcd_write_char('A');
		msdelay(2);
		morsea();
	}
	else if(P11==0){
		lcd_cmd(0x80);
		msdelay(2);
		lcd_write_char('B');
		msdelay(2);
		morseb();
	}
	else if(P12==0){
		lcd_cmd(0x80);
		msdelay(2);
		lcd_write_char('C');
		msdelay(2);
		morsec();
	}
	else if(P13==0){
		lcd_cmd(0x80);
		msdelay(2);
		lcd_write_char('D');
		msdelay(2);
		morsed();
	}
	else{
		lcd_cmd(0x80);
		msdelay(2);
		lcd_write_char('E');
		msdelay(2);
		morsee();
	}
	// Read input nibble here
		while(1);
}
	
	// Insert Priority Logic
	// Inside each condition, call the functions from MorseCode.h. Fill functions in MorseCode.h
	

