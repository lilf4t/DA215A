/*
 * Fatima Kadum & Ahmed Al-faisal
 * 2022-11-17
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
	.EQU PM_START = 0x0056    ; Konstanten PM_START initieras till 56
	.DEF TEMP = R16           ; R16 definieras till TEMP
	.DEF RVAL = R24           ; R24 definieras till RVAL
	.EQU NO_KEY = 0x0F        ; Konstanten NO_KEY initieras till 0F

;==============================================================================
; Start of program
;==============================================================================
	.CSEG         ; Kodstart, vi jobbar nu i programmets minne.
	.ORG RESET    ; Vi skriver instruktioner för addressen i RESET (address 0)
	 RJMP init    ; Hoppar till init
	.ORG PM_START ; Vi skriver instruktioner för addressen i PM_START (address 56)
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

	RET             ; Return

;==============================================================================
; Main part of program
;==============================================================================
main:	
CALL read_keyboard
LSL RVAL          ; Flyttar RVAL 4 steg till vänster
LSL RVAL
LSL RVAL
LSL RVAL

OUT PORTF, RVAL   ; RVAL värdet skickas till PORTF
NOP               ; Delay
NOP
	RJMP main     ; Hoppar till main	

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


             


              