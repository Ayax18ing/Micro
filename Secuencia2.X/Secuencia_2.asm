; PIC16F887 Configuration Bit Settings

; Assembly source line config statements

   
#include "p16f887.inc"

; CONFIG1
; __config 0x28D5
 __CONFIG _CONFIG1, _FOSC_INTRC_CLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_ON & _LVP_OFF
; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

    LIST p=16F887
    
N EQU 0xD0
cont1 EQU 0x20 
cont2 EQU 0x21
 
var1 EQU 0x22
var2 EQU 0x23
    
    ORG 0x00
    
    BSF STATUS, RP0  ;BANK 1
    MOVLW 0x71
    MOVWF OSCCON ;FREC. DE OSCILACI�N
    CLRF TRISB   ;TRISB = 0 (SALIDA)
    
    BSF STATUS,RP1   ;BANK 3
    CLRF ANSELH      ;PUERTO B DIGITAL
    
    BCF STATUS,RP0   ;BANK0
    BCF STATUS,RP1
    
INIT
    MOVLW 0x80
    MOVWF PORTB
    
    MOVLW 0x04
    MOVWF var1
    MOVWF var2
    
SEC_1
    CALL RETARDO
    CALL RETARDO
    RRF PORTB,1  ;DESPLAZAMIENTO 1 BITS
    BSF PORTB,7
    DECFSZ var1,1 ; DECREMENTA f Y SALTA L�NEA SI f=0
    GOTO SEC_1

    MOVLW 0x08
    MOVWF PORTB
    
SEC_2
    CALL RETARDO
    CALL RETARDO
    RRF PORTB,1  ;DESPLAZAMIENTO 1 BITS
    DECFSZ var2,1 ; DECREMENTA f Y SALTA L�NEA SI f=0
    GOTO SEC_2
    GOTO INIT
    
RETARDO
    MOVLW N
    MOVWF cont1
    
REP_1
    MOVLW N
    MOVWF cont2
REP_2
    DECFSZ cont2,1
    GOTO REP_2
    DECFSZ cont1,1
    GOTO REP_1
    RETURN
    
    end


