    ; PIC16F887 Configuration Bit Settings
    #include "p16f887.inc"

    ; CONFIG1
    __CONFIG _CONFIG1, _FOSC_INTRC_CLKOUT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_OFF & _IESO_OFF & _FCMEN_ON & _LVP_OFF
    ; CONFIG2
    __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

    LIST p=16F887

N EQU 0xFF        ; Define el valor de retardo
count  EQU 0x20    ; Contador principal
temp   EQU 0x21    ; Variable temporal para almacenar el valor a escribir
cont1  EQU 0x22    ; Variable auxiliar para retardo
cont2  EQU 0x23    ; Variable auxiliar para retardo

    ORG 0x00
    ; Configuración inicial
    BSF STATUS, RP0   ; Cambia a BANK 1
    MOVLW 0x71
    MOVWF OSCCON      ; Configura la frecuencia del oscilador
    CLRF TRISB        ; Configura PORTB como salida
    
    BSF STATUS, RP1   ; Cambia a BANK 3
    CLRF ANSELH       ; Configura PORTB como digital
    
    BCF STATUS, RP0   ; Vuelve a BANK 0
    BCF STATUS, RP1

INIT
    CLRF count        ; Inicializa el contador en 0
    CLRF temp         ; Inicializa la variable temporal en 0
    CLRF PORTB        ; Limpia el puerto B

LOOP
    ; Alternar entre más y menos significativos
    MOVF count, W     ; Mueve el contador a W
    ANDLW 0x01        ; Verifica si es par o impar (verifica el bit menos significativo)
    BTFSC STATUS, Z   ; Si es 0 (par), usar los bits menos significativos
    GOTO LSB          ; Salta a LSB si el contador es par

MSB
    ; Más significativos (bits 7-4)
    MOVF count, W     ; Mueve el contador a W
    SWAPF count, W    ; Intercambia los nibbles del contador
    ANDLW 0xF0        ; Mantén solo los bits más significativos
    MOVWF temp        ; Guarda el resultado temporalmente en `temp`
    CLRF PORTB        ; Limpia el puerto B antes de escribir
    MOVF temp, W      ; Recupera el valor en W
    MOVWF PORTB       ; Escribe el valor en PORTB
    GOTO CONTINUE     ; Salta a la siguiente iteración

LSB
    ; Menos significativos (bits 3-0)
    MOVF count, W     ; Mueve el contador a W
    ANDLW 0x0F        ; Mantén solo los bits menos significativos
    MOVWF temp        ; Guarda el resultado temporalmente en `temp`
    CLRF PORTB        ; Limpia el puerto B antes de escribir
    MOVF temp, W      ; Recupera el valor en W
    MOVWF PORTB       ; Escribe el valor en PORTB
    GOTO CONTINUE     ; Salta a la siguiente iteración

CONTINUE
    ; Incrementar el contador
    INCF count, F     ; Incrementa el contador

    ; Verificar si el contador ha llegado a 8
    MOVF count, W     ; Mueve el valor del contador a W
    SUBLW 0x08        ; Resta 8 a W (comparar si el valor es 8)
    BTFSC STATUS, Z   ; Si la bandera de cero está establecida, el resultado fue 0 (count == 8)
    GOTO RESET1        ; Si es 8, reinicia el contador

    ; Llamada a retardo
    CALL RETARDO        ; Llamada a una rutina de retardo (puedes ajustarlo)
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    GOTO LOOP         ; Repite el ciclo

RESET1
    ; Rutina de reinicio cuando el contador es 8
    CLRF count        ; Reinicia el contador a 0
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    CALL RETARDO        ; Opcional: Retardo antes de continuar
    GOTO LOOP         ; Regresa al ciclo principal

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
