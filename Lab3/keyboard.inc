
;==============================================================================
; Keyboard subrutin
;============================================================================== 

read_keyboard:
     LDI R18, 0
scan_key:
     MOV R19, R18
     LSL R19
     LSL R19
     LSL R19
	 LSL R19

     OUT PORTB, R19
     PUSH R18
     LDI R24, 7
     RCALL delay_ms 
     POP R18

     SBIC PINE, 6
     RJMP return_key_val
     INC R18
     CPI R18, 12
     BRNE scan_key
     LDI R18, NO_KEY

return_key_val:
     MOV RVAL, R18
     RET

map_table:
   .DB "147*2580369#" 

to_ASCII:
    LDI ZH, high(map_table <<1)   ;Initialize Z pointer 
    LDI ZL, low(map_table <<1) 
    ADD ZL, RVAL  ;Add index 
    LDI RVAL, 0x00   
    ADC ZH, RVAL  ;Add 0 to catch Carry, if present 
    LPM RVAL, Z 
    
key_release:
	LDI R17, NO_KEY	; Sista värdet blir NO-KEY
	RET

  