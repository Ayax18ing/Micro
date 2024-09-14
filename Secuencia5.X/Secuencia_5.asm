; PIC16F887 Configuration Bit Settings
#include "p16f887.inc"

; CONFIG1
 __CONFIG _CONFIG1, _FOSC_INTRC_CLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_ON & _LVP_OFF
; CONFIG2
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

    LIST p=16F887

N EQU 0xD0      ; Contador auxiliar si fuera necesario
cont1 EQU 0x20  ; Contador auxiliar 1
cont2 EQU 0x21  ; Contador auxiliar 2
cont3 EQU 0x22  ; Contador auxiliar 3
cont EQU 0x26  ; Contador auxiliar 4
var1 EQU 0x23   ; Variable 1 para bits 7-4
var2 EQU 0x24   ; Variable 2 para bits 0-3
comp EQU 0x25   ; Variable para evitar el cambio del bit B3

    ORG 0x00
    ; Configuraciones iniciales
    BSF STATUS, RP0  ; Cambia a BANK 1
    MOVLW 0x71
    MOVWF OSCCON      ; Configura la frecuencia del oscilador
    CLRF TRISB        ; Configura PORTB como salida
    
    BSF STATUS, RP1   ; Cambia a BANK 3
    CLRF ANSELH       ; Configura PORTB como digital
    
    BCF STATUS, RP0   ; Vuelve a BANK 0
    BCF STATUS, RP1

INIT
    MOVLW 0xA0        ; Carga 10100000 en var1 (bits 7 a 4)
    MOVWF var1
    MOVLW 0x01        ; Carga 00000001 en var2 (bits 0 a 3)
    MOVWF var2
    
    MOVF var2, W      ; Mueve var2 a W (bits 0-3 rotados)
    IORWF var1, 1     ; Hace OR entre W y var1 (combina var1 y var2)
    MOVF var1, W      ; Mueve var1 (combinado) a W
    MOVWF PORTB       ; Actualiza PORTB con el valor combinado
    
    MOVLW 0x03
    MOVWF cont
    MOVLW 0x04
    MOVWF cont3
    
    MOVLW 0x00
    MOVWF comp
    

; Bucle principal
SEC_1
    COMF var1, 1      ; Invierte los bits de var1
    RLF var2, 1       ; Desplaza los bits de var2 hacia la izquierda (rotación)
    
    ; ---- Concatenar var1 y var2 ----
    
    MOVF var1, W
    ANDLW 0xF0        ; Limpia los bits 3-0, dejando solo los bits 7-4 en W
    MOVWF var1
    
    MOVF var2, W
    ANDLW 0x0F        ; Limpia los bits 7-4, dejando solo los bits 3-0 en W
    MOVWF var2
    
    ; Combinar los dos valores
    IORWF var1, 1     ; Realiza OR lógico entre W y var1 (ya con los bits ajustados)
    
    MOVF var1, W      ; Mueve var1 (combinado) a W
    MOVWF PORTB       ; Actualiza PORTB con el valor combinado
    
    ; ---- Pausa y repetición ----
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    DECFSZ cont,1 ; DECREMENTA cont2 Y SALTA LÍNEA SI f=0
    GOTO SEC_1        ; Repite el ciclo infinitamente
    
    MOVLW 0x50
    MOVWF var1
    
    MOVLW 0x10
    MOVWF var2
    
SEC_2
    COMF var1, 1      ; Invierte los bits de var1
    RRF var2,1        ; Desplaza los bits de var2 hacia la izquierda (rotación)
    DECFSZ cont,1    ; DECREMENTA cont Y SALTA LÍNEA SI f=0
    
    ; ---- Concatenar var1 y var2 ----
    
    MOVF var1, W
    ANDLW 0xF0        ; Limpia los bits 3-0, dejando solo los bits 7-4 en W
    MOVWF var1
    
    MOVF var2, W
    ANDLW 0x0F        ; Limpia los bits 7-4, dejando solo los bits 3-0 en W
    MOVWF var2
    
    ; Combinar los dos valores
    IORWF var1, 1     ; Realiza OR lógico entre W y var1 (ya con los bits ajustados)
    
    MOVF var1, W      ; Mueve var1 (combinado) a W
    MOVWF PORTB       ; Actualiza PORTB con el valor combinado
    
    ; ---- Pausa y repetición ----
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    DECFSZ cont3,1 ; DECREMENTA cont3 Y SALTA LÍNEA SI f=0
    GOTO SEC_2        ; Repite el ciclo infinitamente
    BCF STATUS, C
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    CALL RETARDO        ; Opcional: Retardo antes de continuar
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

    END
