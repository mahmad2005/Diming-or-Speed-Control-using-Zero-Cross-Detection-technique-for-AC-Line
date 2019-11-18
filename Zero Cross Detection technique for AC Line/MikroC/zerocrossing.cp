#line 1 "E:/Arduino Works 02.02.2017/Home_Auto_All/ZeroCross Final 01.06.2017/MikroC/zerocrossing.c"





unsigned char FlagReg;
sbit ZC at FlagReg.B0;


int i =0;
int dim = 128;

int CompMatch =0;
int CompDone =0;

int dimming = 100;

int DimFlag =0;
int DimCounter=0;
int DimTime = 0;

int isButtonPressed1 =0;
int isButtonPressed2 =0;


void VDelay_us(unsigned time_us){
 unsigned n_cyc;
 n_cyc = Clock_MHz()>>2;
 n_cyc *= time_us>>4;
 while (n_cyc--) {
 asm nop;
 asm nop;
 }
}


void interrupt(){
 if (INTCON.INTF){
 ZC = 1;
 i=0;
 PORTC.RC5 = 0;
 INTCON.INTF = 0;
 dimCounter=0;
 }
 if(PIR1.CCP1IF) {

 PIR1.CCP1IF =0;
 PIR1.TMR1IF =0;
 CompMatch = 1;
 TMR1L=0;
 TMR1H=0;
 }
}

void main() {
 PORTB = 0;
 TRISB = 0x07;
 PORTC = 0;
 TRISC = 0;
 PORTA=0;
 TRISA=0;
 TRISA.RA0=1;
 TRISA.RA1=1;

 ADCON1 =0xff;
 ADCON0 = 0;
 ADCON0.ADON = 0;



 OPTION_REG.INTEDG = 1;
 INTCON.INTF = 0;
 INTCON.INTE = 1;
 INTCON.GIE = 1;
 INTCON.PEIE = 1;




 TMR1L =0;
 TMR1H=0;

 T1CON.T1CKPS1 = 0;
 T1CON.T1CKPS0 = 0;


 T1CON.TMR1CS =0;
 T1CON.TMR1ON=1;

 PIE1.TMR1IE = 1;





 CCP1CON.CCP1M3 = 1;
 CCP1CON.CCP1M2 = 0;
 CCP1CON.CCP1M1 = 1;
 CCP1CON.CCP1M0 = 0;
 PIE1.CCP1IE =1;


 CCPR1L =0x4B;
 CCPR1H =0x00;



 while (1){


 if(CompMatch == 1) {
 CompMatch=0;
 if (ZC){
 if(i>=DimTime) {
 PORTC.RC5 = 1;
 }
 if(i>(DimTime+3)) {
 i=0;
 ZC=0;
 PORTC.RC5 =0;
 }
 else {
 i++;

 }
 }
 }



 if(RB1_bit) {
 if(isButtonPressed1 == 0) {
 DimTime = DimTime+25;
 isButtonPressed1 =1;
 PORTB.RB4=1;
 }
 }else {
 isButtonPressed1=0;
 PORTB.RB4=0;
 }

 if(RB2_bit) {
 if(isButtonPressed2 == 0) {
 DimTime = DimTime-25;
 isButtonPressed2 =1;
 PORTB.RB5=1;
 }
 }else {
 isButtonPressed2=0;
 PORTB.RB5=0;
 }



 }
}
