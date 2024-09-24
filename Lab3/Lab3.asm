/*
 * Fatima Kadum & Ahmed Al-faisal
 * 2022-11-29
 *
 *
 * lab3.asm
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
	.EQU ROLL_KEY = '2'   

;==============================================================================
; Start of program
;==============================================================================
	.CSEG         ; Kodstart, vi jobbar nu i programmets minne.
	.ORG RESET    ; Vi skriver instruktioner för addressen i RESET (address 0)
	 RJMP init    ; Hoppar till init
	.ORG PM_START ; Vi skriver instruktioner för addressen i PM_START (address 56)
	.include "delay.inc"
	.include "lcd.inc"
	.include "keyboard.inc"
	.include "Tarning.inc"
	.include "monitor.inc"
	.include "stats.inc"

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
    CALL init_stat
	CALL init_monitor

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

	SBI DDRD, 6     ; utgång
	SBI DDRD, 7     ; utgång

	LDI R25, 0XFF   ; 1 --> utgång
	OUT DDRB, R25   ; DDRB = R25
	OUT PORTB, R25  ; PORTB = R25

	CBI DDRE, 6     ; ingång

	RET             ; Return
	
;==============================================================================
; Main part of program
;============================================================================== 

main:

//början av programmet
meny:
 PRINTSTRING Hello_str  ; skriver ut welcome to dice
 RCALL delay_1_s
 RCALL lcd_clear_display
 RCALL delay_1_s
/* PRINTSTRING Press_2   ; skriver ut press 2 to roll
 RET
*/


 rollagain:
	RCALL lcd_clear_display
	PRINTSTRING Press_2

//valen man kan göra
loopDice:
   RCALL read_keyboard     ; kallar på readkeyboard
   RCALL to_ASCII          ; omvandlar till ascii
   CPI RVAL, ROLL_KEY      ; om man trycker på 2, går den till handle 2
   BREQ handle_2
   CPI RVAL, '3'
   BREQ handle_3
   CPI RVAL, '8'
   BREQ handle_8
   CPI RVAL, '9'
   BREQ handle_9
   LDI RVAL, 10
   RCALL delay_1_s
   RJMP loopDice
  
//om man väljer 2
 handle_2:
    RCALL delay_1_s
    RCALL lcd_clear_display

	PRINTSTRING Rolling         ; ska stå rolling...
    RCALL delay_1_s

	RCALL roll_dice             ; kallar på roll dice
	PUSH TEMP
	RCALL lcd_clear_display
	PRINTSTRING Value           ; står Value:
    POP TEMP

	MOV RVAL, TEMP
	LDI TEMP, CONVERT       ; konverterar till ascii
	ADD RVAL, TEMP
	RCALL lcd_write_chr     ; skriver ut värde för R16
	RCALL delay_1_s
	RJMP rollagain
	

 //om man väljer 3
  handle_3:
  RCALL showstat
  RJMP rollagain

 //om man väljer 8
  handle_8:
  RCALL clearstat
  RJMP rollagain

 //om man väljer 9
  handle_9:
  RCALL monitor
  RJMP rollagain

