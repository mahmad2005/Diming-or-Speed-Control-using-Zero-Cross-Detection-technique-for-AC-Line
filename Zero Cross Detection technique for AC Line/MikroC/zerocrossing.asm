
_VDelay_us:

;zerocrossing.c,26 :: 		void VDelay_us(unsigned time_us){
;zerocrossing.c,28 :: 		n_cyc = Clock_MHz()>>2;
	MOVLW      2
	MOVWF      R2+0
	MOVLW      0
	MOVWF      R2+1
;zerocrossing.c,29 :: 		n_cyc *= time_us>>4;
	MOVF       FARG_VDelay_us_time_us+0, 0
	MOVWF      R2+0
	MOVF       FARG_VDelay_us_time_us+1, 0
	MOVWF      R2+1
	RRF        R2+1, 1
	RRF        R2+0, 1
	BCF        R2+1, 7
	RRF        R2+1, 1
	RRF        R2+0, 1
	BCF        R2+1, 7
	RRF        R2+1, 1
	RRF        R2+0, 1
	BCF        R2+1, 7
	RRF        R2+1, 1
	RRF        R2+0, 1
	BCF        R2+1, 7
	RLF        R2+0, 1
	RLF        R2+1, 1
	BCF        R2+0, 0
;zerocrossing.c,30 :: 		while (n_cyc--) {
L_VDelay_us0:
	MOVF       R2+0, 0
	MOVWF      R0+0
	MOVF       R2+1, 0
	MOVWF      R0+1
	MOVLW      1
	SUBWF      R2+0, 1
	BTFSS      STATUS+0, 0
	DECF       R2+1, 1
	MOVF       R0+0, 0
	IORWF      R0+1, 0
	BTFSC      STATUS+0, 2
	GOTO       L_VDelay_us1
;zerocrossing.c,31 :: 		asm nop;
	NOP
;zerocrossing.c,32 :: 		asm nop;
	NOP
;zerocrossing.c,33 :: 		}
	GOTO       L_VDelay_us0
L_VDelay_us1:
;zerocrossing.c,34 :: 		}
L_end_VDelay_us:
	RETURN
; end of _VDelay_us

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;zerocrossing.c,37 :: 		void interrupt(){
;zerocrossing.c,38 :: 		if (INTCON.INTF){          //INTF flag raised, so external interrupt occured
	BTFSS      INTCON+0, 1
	GOTO       L_interrupt2
;zerocrossing.c,39 :: 		ZC = 1;
	BSF        _FlagReg+0, 0
;zerocrossing.c,40 :: 		i=0;
	CLRF       _i+0
	CLRF       _i+1
;zerocrossing.c,41 :: 		PORTC.RC5 = 0;
	BCF        PORTC+0, 5
;zerocrossing.c,42 :: 		INTCON.INTF = 0;
	BCF        INTCON+0, 1
;zerocrossing.c,43 :: 		dimCounter=0;
	CLRF       _DimCounter+0
	CLRF       _DimCounter+1
;zerocrossing.c,44 :: 		}
L_interrupt2:
;zerocrossing.c,45 :: 		if(PIR1.CCP1IF) {
	BTFSS      PIR1+0, 2
	GOTO       L_interrupt3
;zerocrossing.c,47 :: 		PIR1.CCP1IF =0;
	BCF        PIR1+0, 2
;zerocrossing.c,48 :: 		PIR1.TMR1IF =0;
	BCF        PIR1+0, 0
;zerocrossing.c,49 :: 		CompMatch = 1;
	MOVLW      1
	MOVWF      _CompMatch+0
	MOVLW      0
	MOVWF      _CompMatch+1
;zerocrossing.c,50 :: 		TMR1L=0;
	CLRF       TMR1L+0
;zerocrossing.c,51 :: 		TMR1H=0;
	CLRF       TMR1H+0
;zerocrossing.c,52 :: 		}
L_interrupt3:
;zerocrossing.c,53 :: 		}
L_end_interrupt:
L__interrupt19:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_main:

;zerocrossing.c,55 :: 		void main() {
;zerocrossing.c,56 :: 		PORTB = 0;
	CLRF       PORTB+0
;zerocrossing.c,57 :: 		TRISB = 0x07;              //RB0 input for interrupt
	MOVLW      7
	MOVWF      TRISB+0
;zerocrossing.c,58 :: 		PORTC = 0;
	CLRF       PORTC+0
;zerocrossing.c,59 :: 		TRISC = 0;                 //PORTD all output
	CLRF       TRISC+0
;zerocrossing.c,60 :: 		PORTA=0;
	CLRF       PORTA+0
;zerocrossing.c,61 :: 		TRISA=0;
	CLRF       TRISA+0
;zerocrossing.c,62 :: 		TRISA.RA0=1;
	BSF        TRISA+0, 0
;zerocrossing.c,63 :: 		TRISA.RA1=1;
	BSF        TRISA+0, 1
;zerocrossing.c,65 :: 		ADCON1 =0xff;
	MOVLW      255
	MOVWF      ADCON1+0
;zerocrossing.c,66 :: 		ADCON0 = 0;
	CLRF       ADCON0+0
;zerocrossing.c,67 :: 		ADCON0.ADON = 0; // ADC off
	BCF        ADCON0+0, 0
;zerocrossing.c,71 :: 		OPTION_REG.INTEDG = 1;      //interrupt on falling edge
	BSF        OPTION_REG+0, 6
;zerocrossing.c,72 :: 		INTCON.INTF = 0;           //clear interrupt flag
	BCF        INTCON+0, 1
;zerocrossing.c,73 :: 		INTCON.INTE = 1;           //enable external interrupt
	BSF        INTCON+0, 4
;zerocrossing.c,74 :: 		INTCON.GIE = 1;            //enable global interrupt
	BSF        INTCON+0, 7
;zerocrossing.c,75 :: 		INTCON.PEIE = 1; // enable periferal interrupt
	BSF        INTCON+0, 6
;zerocrossing.c,80 :: 		TMR1L =0;
	CLRF       TMR1L+0
;zerocrossing.c,81 :: 		TMR1H=0;
	CLRF       TMR1H+0
;zerocrossing.c,83 :: 		T1CON.T1CKPS1 = 0;
	BCF        T1CON+0, 5
;zerocrossing.c,84 :: 		T1CON.T1CKPS0 = 0;
	BCF        T1CON+0, 4
;zerocrossing.c,87 :: 		T1CON.TMR1CS =0; // timer1 Source clock. 0 = internal, 1 = external
	BCF        T1CON+0, 1
;zerocrossing.c,88 :: 		T1CON.TMR1ON=1;    //timer on bit
	BSF        T1CON+0, 0
;zerocrossing.c,90 :: 		PIE1.TMR1IE = 1; // timer overflow enable
	BSF        PIE1+0, 0
;zerocrossing.c,96 :: 		CCP1CON.CCP1M3 = 1;
	BSF        CCP1CON+0, 3
;zerocrossing.c,97 :: 		CCP1CON.CCP1M2 = 0;
	BCF        CCP1CON+0, 2
;zerocrossing.c,98 :: 		CCP1CON.CCP1M1 = 1;
	BSF        CCP1CON+0, 1
;zerocrossing.c,99 :: 		CCP1CON.CCP1M0 = 0;
	BCF        CCP1CON+0, 0
;zerocrossing.c,100 :: 		PIE1.CCP1IE =1;  // CCP1 interrupt enable bit
	BSF        PIE1+0, 2
;zerocrossing.c,103 :: 		CCPR1L =0x4B;
	MOVLW      75
	MOVWF      CCPR1L+0
;zerocrossing.c,104 :: 		CCPR1H =0x00;
	CLRF       CCPR1H+0
;zerocrossing.c,108 :: 		while (1){
L_main4:
;zerocrossing.c,111 :: 		if(CompMatch == 1) {
	MOVLW      0
	XORWF      _CompMatch+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main21
	MOVLW      1
	XORWF      _CompMatch+0, 0
L__main21:
	BTFSS      STATUS+0, 2
	GOTO       L_main6
;zerocrossing.c,112 :: 		CompMatch=0;
	CLRF       _CompMatch+0
	CLRF       _CompMatch+1
;zerocrossing.c,113 :: 		if (ZC){ //zero crossing occurred
	BTFSS      _FlagReg+0, 0
	GOTO       L_main7
;zerocrossing.c,114 :: 		if(i>=DimTime) {
	MOVLW      128
	XORWF      _i+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _DimTime+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main22
	MOVF       _DimTime+0, 0
	SUBWF      _i+0, 0
L__main22:
	BTFSS      STATUS+0, 0
	GOTO       L_main8
;zerocrossing.c,115 :: 		PORTC.RC5 = 1;
	BSF        PORTC+0, 5
;zerocrossing.c,116 :: 		}
L_main8:
;zerocrossing.c,117 :: 		if(i>(DimTime+3)) {
	MOVLW      3
	ADDWF      _DimTime+0, 0
	MOVWF      R1+0
	MOVF       _DimTime+1, 0
	BTFSC      STATUS+0, 0
	ADDLW      1
	MOVWF      R1+1
	MOVLW      128
	XORWF      R1+1, 0
	MOVWF      R0+0
	MOVLW      128
	XORWF      _i+1, 0
	SUBWF      R0+0, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main23
	MOVF       _i+0, 0
	SUBWF      R1+0, 0
L__main23:
	BTFSC      STATUS+0, 0
	GOTO       L_main9
;zerocrossing.c,118 :: 		i=0;
	CLRF       _i+0
	CLRF       _i+1
;zerocrossing.c,119 :: 		ZC=0;
	BCF        _FlagReg+0, 0
;zerocrossing.c,120 :: 		PORTC.RC5 =0;
	BCF        PORTC+0, 5
;zerocrossing.c,121 :: 		}
	GOTO       L_main10
L_main9:
;zerocrossing.c,123 :: 		i++;
	INCF       _i+0, 1
	BTFSC      STATUS+0, 2
	INCF       _i+1, 1
;zerocrossing.c,125 :: 		}
L_main10:
;zerocrossing.c,126 :: 		}
L_main7:
;zerocrossing.c,127 :: 		}
L_main6:
;zerocrossing.c,131 :: 		if(RB1_bit) {
	BTFSS      RB1_bit+0, BitPos(RB1_bit+0)
	GOTO       L_main11
;zerocrossing.c,132 :: 		if(isButtonPressed1 == 0) {
	MOVLW      0
	XORWF      _isButtonPressed1+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main24
	MOVLW      0
	XORWF      _isButtonPressed1+0, 0
L__main24:
	BTFSS      STATUS+0, 2
	GOTO       L_main12
;zerocrossing.c,133 :: 		DimTime = DimTime+25;
	MOVLW      25
	ADDWF      _DimTime+0, 1
	BTFSC      STATUS+0, 0
	INCF       _DimTime+1, 1
;zerocrossing.c,134 :: 		isButtonPressed1 =1;
	MOVLW      1
	MOVWF      _isButtonPressed1+0
	MOVLW      0
	MOVWF      _isButtonPressed1+1
;zerocrossing.c,135 :: 		PORTB.RB4=1;
	BSF        PORTB+0, 4
;zerocrossing.c,136 :: 		}
L_main12:
;zerocrossing.c,137 :: 		}else {
	GOTO       L_main13
L_main11:
;zerocrossing.c,138 :: 		isButtonPressed1=0;
	CLRF       _isButtonPressed1+0
	CLRF       _isButtonPressed1+1
;zerocrossing.c,139 :: 		PORTB.RB4=0;
	BCF        PORTB+0, 4
;zerocrossing.c,140 :: 		}
L_main13:
;zerocrossing.c,142 :: 		if(RB2_bit) {
	BTFSS      RB2_bit+0, BitPos(RB2_bit+0)
	GOTO       L_main14
;zerocrossing.c,143 :: 		if(isButtonPressed2 == 0) {
	MOVLW      0
	XORWF      _isButtonPressed2+1, 0
	BTFSS      STATUS+0, 2
	GOTO       L__main25
	MOVLW      0
	XORWF      _isButtonPressed2+0, 0
L__main25:
	BTFSS      STATUS+0, 2
	GOTO       L_main15
;zerocrossing.c,144 :: 		DimTime = DimTime-25;
	MOVLW      25
	SUBWF      _DimTime+0, 1
	BTFSS      STATUS+0, 0
	DECF       _DimTime+1, 1
;zerocrossing.c,145 :: 		isButtonPressed2 =1;
	MOVLW      1
	MOVWF      _isButtonPressed2+0
	MOVLW      0
	MOVWF      _isButtonPressed2+1
;zerocrossing.c,146 :: 		PORTB.RB5=1;
	BSF        PORTB+0, 5
;zerocrossing.c,147 :: 		}
L_main15:
;zerocrossing.c,148 :: 		}else {
	GOTO       L_main16
L_main14:
;zerocrossing.c,149 :: 		isButtonPressed2=0;
	CLRF       _isButtonPressed2+0
	CLRF       _isButtonPressed2+1
;zerocrossing.c,150 :: 		PORTB.RB5=0;
	BCF        PORTB+0, 5
;zerocrossing.c,151 :: 		}
L_main16:
;zerocrossing.c,155 :: 		}
	GOTO       L_main4
;zerocrossing.c,156 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
