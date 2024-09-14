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
cont3 EQU 0x22
 
var1 EQU 0x23
var2 EQU 0x24
 
    ORG	0x00

    ;BANCO 1
    BSF STATUS, RP0
    MOVLW 0x71
    MOVWF OSCCON ;FREC. DE OSCILACIÓN
    CLRF TRISB ; TODO EL PUERTO COMO SALIDA
    
    ;BANCO 3 / PUERTO DIGITAL CON CLRF PARA ANSELH
    BSF STATUS, RP1
    CLRF ANSELH
    
    ;BANCO 0
    BCF STATUS, RP0
    BCF STATUS, RP1
    
INIT_SEC_1    
    MOVLW 0x80 ; Más significativo
    MOVWF var1
    
    MOVLW 0x01 ; Menos significativo
    MOVWF var2
    
    MOVLW 0x08 ; El contador llega a 8
    MOVWF cont3
    
SEC_1
    MOVF var1,0 ; Mover el contenido del archivo a W o a sí mismo
    IORWF var2,0
    MOVWF PORTB
    
    CALL RETARDO
    CALL RETARDO
    
    BCF STATUS, C ; Quito el carry que puede surgir de la secuencia
    RRF var1 ; Muevo a la derecha mi variable en el bit más significativo
    BCF STATUS, C ; Quito el carry que puede surgir de la secuencia
    RLF var2 ; Muevo a la izquierda mi variable en el bit menos significativo
    DECFSZ cont3,1
    GOTO SEC_1
    GOTO INIT_SEC_1 
   
    
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
    
    END


