/*
 * Fatima Kadum & Ahmed Al-faisal
 * 2022-11-22
 *
 *
 * lab1.asm
 * 
 * This is a very simple demo program made for the course DA215A at
 * Malmö University. The purpose of this program is:
 *	-	To test if a program can be transferred to the ATmega32U4
 *		microcontroller.
 *	-	To provide a base for further programming in "Laboration 1".
 *
 * After a successful transfer of the program, while the program is
 * running, the embedded LED on the Arduino board should be turned on.
 * The LED is connected to the D13 pin (PORTC, bit 7).
 *
 * Author:	Mathias Beckius, updated by Magnus Krampell
 *
 * Date:	2014-11-05, 2021-11-17
 */ 
 
;==============================================================================
; Definitions of registers, etc. ("constants")
;==============================================================================
	.EQU RESET = 0x0000       ; Konstanten RESET initieras till 0
	.EQU PM_START = 0x0058    ; Konstanten PM_START initieras till 56
	.DEF TEMP = R16           ; R16 definieras till TEMP
	.DEF RVAL = R24           ; R24 definieras till RVAL
	.EQU NO_KEY = 0x0F        ; Konstanten NO_KEY initieras till 0F
	.EQU CONVERT = 0x30

	;Skickar instruktioner till LCD med 39ms delay
	.MACRO LCD_INSTRUCTION
	LDI R24, @0
	RCALL lcd_write_instr
	LDI R24, 39
	RCALL delay_micros
    .ENDMACRO

;==============================================================================
; Start of program
;==============================================================================
	.CSEG         ; Kodstart, vi jobbar nu i programmets minne.
	.ORG RESET    ; Vi skriver instruktioner för addressen i RESET (address 0)
	 RJMP init    ; Hoppar till init
	.ORG PM_START ; Vi skriver instruktioner för addressen i PM_START (address 56)
	.include "delay.inc"
	.include "lcd.inc"

;==============================================================================
; Basic initializations of stack pointer, I/O pins, etc.
;==============================================================================
init:
	; Set stack pointer to point at the end of RAM.
	LDI TEMP, LOW(RAMEND)
	OUT SPL, TEMP
	LDI TEMP, HIGH(RAMEND)
	OUT SPH, TEMP
	; Initialize pins
	CALL init_pins
	CALL lcd_init
	; Jump to main part of program
	RJMP main

;==============================================================================
; Initialize I/O pins
;==============================================================================
init_pins:	
 	LDI TEMP, 0x80  ; TEMP = 80
	OUT DDRC, TEMP  ; TEMP skrivs ut på DDRC

	LDI TEMP, 0xFF  ; TEMP = 1, alltså utsignal
	OUT DDRF, TEMP  ; Skriver ut DDRF i TEMP, DDRF = TEMP
	OUT PORTF, TEMP ; Skriver ut TEMP värdet till PORTF, PORTF = TEMP

	OUT PORTB, TEMP ; Skriver ut TEMP värdet till PORTB
	OUT DDRB, TEMP  ; Skriver ut TEMP värdet till DDRB

	//lab2 börjar här
	SBI DDRD, 6     ; utgång
	SBI DDRD, 7     ; utgång

	LDI R25, 0XFF   ; 1 --> utgång
	OUT DDRB, R25   ; DDRB = R25
	OUT PORTB, R25  ; PORTB = R25

	CBI DDRE, 6     ; ingång

	RET             ; Return
	

/*
read_keyboard:	
LDI R18, 0        ; Reset counter

scan_key:
MOV R19, R18
LSL R19           ; Flyttar R19 4 steg till vänster 
LSL R19
LSL R19
LSL R19
OUT PORTB, R19    ; Set column and row
NOP               ; 12 st
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP
NOP

SBIC PINE, 6         ; Om PINE är 0 så skippas nästa steg, annars fortsätter den
RJMP return_key_val
INC R18              ; R18++
CPI R18, 12          ; Jämför värdet i R18 till värdet 12
BRNE scan_key        ; Om de inte stämmer, så hoppar den till scan_key, annars så fortsätter den
LDI R18, NO_KEY      ; No key was pressed!

return_key_val:
MOV RVAL, R18        ; R18 kopieras till RVAL
RET

*/ 
;==============================================================================
; Main part of program
;==============================================================================
 main:

/*LDI R24, 'H'
RCALL lcd_write_chr
LDI R24, 'E'
RCALL lcd_write_chr
LDI R24, 'L'
RCALL lcd_write_chr
LDI R24, 'L'
RCALL lcd_write_chr
LDI R24, 'O'
RCALL lcd_write_chr
LDI R24, '!'
RCALL lcd_write_chr
loop:
RJMP loop  
*/

/*
LCD_WRITE_CHAR 'h' 
LCD_WRITE_CHAR 'e' 
LCD_WRITE_CHAR 'l' 
LCD_WRITE_CHAR 'l' 
LCD_WRITE_CHAR 'o' 
LCD_WRITE_CHAR '!' 
*/

/*LDI R24, 0x83
RCALL lcd_write_instr
LCD_WRITE_CHAR 'h' 
LCD_WRITE_CHAR 'e' 
LCD_WRITE_CHAR 'l' 
LCD_WRITE_CHAR 'l' 
LCD_WRITE_CHAR 'o'

LDI R24, 0xC6
RCALL lcd_write_instr
LCD_WRITE_CHAR 'w' 
LCD_WRITE_CHAR 'o' 
LCD_WRITE_CHAR 'r' 
LCD_WRITE_CHAR 'l' 
LCD_WRITE_CHAR 'd'

loop:
RJMP loop     

*/

LCD_WRITE_CHAR 'K' 
LCD_WRITE_CHAR 'E' 
LCD_WRITE_CHAR 'Y' 
LCD_WRITE_CHAR ':' 

LDI R24, 0xC0
RCALL lcd_write_instr


key_release:
  LDI R27, NO_KEY

loop:
  RCALL read_keyboard

  CP RVAL, R17
  BREQ loop            ; om RVAL = R20 så går den till loop:
  MOV R17, RVAL        ; kopierar returvärdet till sista värdet

  CPI RVAL, NO_KEY     ; jämför RVAL med NO_KEY
  BREQ key_release     ; om det stämmer, så ska den gå till key_release

  CPI RVAL, 10         ; jämför RVAL med 10
  BRLO write           ; if RVAL<10, så går dentill write
  LDI TEMP, 7
  ADD RVAL, TEMP

write:
  LDI TEMP, CONVERT
  ADD RVAL, TEMP          ; konverterar RVAL till ASCII
  LCD_WRITE_REG_CHAR RVAL
  LDI R24, 250
  RCALL delay_ms
  RJMP loop

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
  LDI R24, 20
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



              