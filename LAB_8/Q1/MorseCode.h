/*************************************************
 	lcd.h: Header file for 16x2 LCD interfacing  
**************************************************/
//Functions contained in this header file

void dashtone(void);																//Dash tone generator
void dottone(void);																	//Dot tone generator


void morsea(void);																	//morse code for A
void morseb(void);																	//morse code for B
void morsec(void);																	//morse code for C
void morsed(void);																	//morse code for D
void morsee(void);																	//morse code for E
//Function definitions

void dashtone(void) 
{ 
	
	unsigned i;
	for(i=0;i<716;i++){
	P0_7 = ~P0_7;
	msdelay(2); 		
		/* This function is a welcome change over the hardwork in the delay subroutines in earlier labs :D*/
	}
}
void dottone(void)
{ 
  // Similar to dashtone
	unsigned i;
	for(i=0;i<350;i++){
		P0_7 = ~P0_7;
		msdelay(2);
	}
}

void morsea(void)// .-
{
	dottone();
	msdelay(1000);
	dashtone();
}

void morseb(void)// -...
{
// Insert
	dashtone();
	msdelay(1000);
	dottone();
	msdelay(1000);
	dottone();
	msdelay(1000);
	dottone();
}
void morsec(void)// -.-.
{
// Insert
dashtone();
	msdelay(1000);
	dottone();
	msdelay(1000);
	dashtone();
	msdelay(1000);
	dottone();
}
void morsed(void)// -..
{
// Insert
dashtone();
	msdelay(1000);
	dottone();
	msdelay(1000);
	dottone();
}
void morsee(void)// .
{
// Insert
	dottone();
}
