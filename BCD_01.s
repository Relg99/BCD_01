
; PIC16F628A Configuration Bit Settings

; Assembly source line config statements

; CONFIG
  CONFIG  FOSC = INTOSCIO       ; Oscillator Selection bits (INTOSC oscillator: I/O function on RA6/OSC2/CLKOUT pin, I/O function on RA7/OSC1/CLKIN)
  CONFIG  WDTE = OFF            ; Watchdog Timer Enable bit (WDT disabled)
  CONFIG  PWRTE = OFF           ; Power-up Timer Enable bit (PWRT disabled)
  CONFIG  MCLRE = ON            ; RA5/MCLR/VPP Pin Function Select bit (RA5/MCLR/VPP pin function is MCLR)
  CONFIG  BOREN = OFF           ; Brown-out Detect Enable bit (BOD disabled)
  CONFIG  LVP = OFF             ; Low-Voltage Programming Enable bit (RB4/PGM pin has digital I/O function, HV on MCLR must be used for programming)
  CONFIG  CPD = OFF             ; Data EE Memory Code Protection bit (Data memory code protection off)
  CONFIG  CP = OFF              ; Flash Program Memory Code Protection bit (Code protection off)

// config statements should precede project file includes.
  
#include <xc.inc>

; When assembly code is placed in a psect, it can be manipulated as a
; whole by the linker and placed in memory.  
;
; In this example, barfunc is the program section (psect) name, 'local' means
; that the section will not be combined with other sections even if they have
; the same name.  class=CODE means the barfunc must go in the CODE container.
; PIC18 should have a delta (addressible unit size) of 1 (default) since they
; are byte addressible.  PIC10/12/16 have a delta of 2 since they are word
; addressible.  PIC18 should have a reloc (alignment) flag of 2 for any
; psect which contains executable code.  PIC10/12/16 can use the default
; reloc value of 1.  Use one of the psects below for the device you use:

psect   barfunc,local,class=CODE,delta=2 ; PIC10/12/16
; psect   barfunc,local,class=CODE,reloc=2 ; PIC18
  

    hundreds	EQU	0x0C
    tens	EQU	0x0D
    units	EQU	0x0E
  

global _bar ; extern of bar function goes in the C source file
_bar:
    CLRF	PORTA
    CLRF	PORTB
    
    MOVLW	0x07
    MOVWF	CMCON
    
    BCF		STATUS, 6	;Go to
    BSF		STATUS, 5	;Bank 1
    
    MOVLW	0x1F
    
    MOVWF	TRISA		;Set PORTA direction.
    
    MOVLW	0x00
    
    MOVWF	TRISB		;Set PORTB direction.
    
    BCF		STATUS, 6	;Change to
    BCF		STATUS, 5	;Bank 0
    
principal:
    
    CLRF	hundreds	;Clean memory
    CLRF	tens
    CLRF	units
    
    
    MOVF	PORTA,W
    MOVWF	units
    
bcd_sub10:
    
    MOVLW	10
    SUBWF	units,W
    BTFSS	STATUS,0
    GOTO	bcd_end
    
bcd_IncTen:
    
    MOVWF	units
    INCF	tens,F
    MOVF	tens,W
    MOVWF	PORTB
    
loop:
    GOTO	loop
    ;MOVLW	10
    ;SUBWF	tens,W
    ;BTFSS	STATUS,0
    ;GOTO	bcd_sub10
    
;bcd_IncHun:
    
    ;CLRF	tens
    ;INCF	hundreds,F
    ;GOTO	bcd_sub10
    
bcd_end:
    
    ;SWAPF	tens,W
    ;ADDWF	units,W
    ;MOVWF	PORTB
    
    GOTO	principal
    
    return
