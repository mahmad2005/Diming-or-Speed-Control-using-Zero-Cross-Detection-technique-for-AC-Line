//Programmer: Syed Tahmid Mahbub
//Compiler: mikroC PRO for PIC v4.60
//Target PIC: PIC16F877A
//Program for zero-cross detection
//---------------------------------------------------------------------------------------------------------
unsigned char FlagReg;
sbit ZC at FlagReg.B0;

int CompMatch =0;
int CompDone =0;

int dimming = 100;

int DimFlag =0;
int DimCounter=0;
int DimTime = 100;

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
     if (INTCON.INTF){          //INTF flag raised, so external interrupt occured
        ZC = 1;
        INTCON.INTF = 0;
        dimCounter=0;
     }
     if(PIR1.CCP1IF ==1) {
        // PORTC.RC6 ^=1;
         PIR1.CCP1IF =0;
         CompMatch = 1;
        // TMR1L=0;
       //  TMR1H=0;
     }
}

void main() {
     PORTB = 0;
     TRISB = 0x07;              //RB0 input for interrupt
     PORTC = 0;
     TRISC = 0;                 //PORTD all output
     PORTA=0;
     TRISA=0;
     TRISA.RA0=1;
     TRISA.RA1=1;

     ADCON1 =0xff;
     ADCON0 = 0;
     ADCON0.ADON = 0; // ADC off
    // ANSEL  = 0;                 // Configure AN pins as digital
   //  ANSELH = 0;

     OPTION_REG.INTEDG = 1;      //interrupt on falling edge
     INTCON.INTF = 0;           //clear interrupt flag
     INTCON.INTE = 1;           //enable external interrupt
     INTCON.GIE = 1;            //enable global interrupt

   
   
//timer setup
     TMR1L =0;
     TMR1H=0;

     T1CON.T1CKPS1 = 0;
     T1CON.T1CKPS0 = 0;
     //  T1CON.T1OSCEN = 1; //oscilator select bit.
     //  T1CON.T1INSYNC =1; // dont syncronize external clock input
     T1CON.TMR1CS =0; // timer1 Source clock. 0 = internal, 1 = external
     T1CON.TMR1ON=0;    //timer on bit

     PIE1.TMR1IE = 1; // timer overflow enable

//end timer setup
     
//compare mode system
       //CCP1CON:CCP1M3:CCP1M0_bit=1010;  // compare mode, generated software interrup on match
       CCP1CON.CCP1M3 = 1;
       CCP1CON.CCP1M2 = 0;
       CCP1CON.CCP1M1 = 1;
       CCP1CON.CCP1M0 = 0;
      PIE1.CCP1IE =1;  // CCP1 interrupt enable bit

      // CCPR1 resister who's value will be constantly checked with timer1 value
      CCPR1L =0xff;
      CCPR1H =0x00;
//compare mode end


     while (1){
           if (ZC){ //zero crossing occurred
           
           if (CompDone == 0) {
                TMR1L=0;
                TMR1H=0;
                T1CON.TMR1ON=1;
                CompDone = 1;
           }
           if(CompMatch == 1) {
             // int dimtime = (75*dimming);    // For 60Hz =>65
             // VDelay_us(dimtime);    // Wait till firing the TRIAC

              PORTC.RC0 = 1; //Send a 1ms pulse
              //PORTC.B0 = 1  both are same. b0 means pin 0 bit and rb0 register pin bit 0; rcb regiter pin 0 of port c
              delay_ms(1);
              PORTC.RC0 = 0;
              ZC = 0;
              Compdone =0;
              CompMatch =0;
              T1CON.TMR1ON=0;
              }
           }

            if(RB1_bit) {
              if(isButtonPressed1 == 0) {
                DimTime = DimTime+50;
                isButtonPressed1 =1;
                PORTA.RB4=1;
              }
            }else {
                isButtonPressed1=0;
                PORTB.RB4=0;
            }
            
            if(RB2_bit) {
              if(isButtonPressed2 == 0) {
                DimTime = DimTime-100;
                isButtonPressed2 =1;
                PORTB.RB5=1;
              }
            }else {
                isButtonPressed2=0;
                PORTB.RB5=0;
            }
           

     }
}