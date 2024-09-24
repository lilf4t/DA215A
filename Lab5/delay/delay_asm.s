/*
 * delay_asm.s
 *
 * Author:	Fatima Kadum & Ahmed Al-faisal
 *
 * Date:	2022-12-06
 */ 

;==============================================================================
; delay_1_micros    delay 1 µs 
;==============================================================================

.global delay_1_micros

 delay_1_micros:
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
	RET

;==============================================================================
; delay_micros    Delay of X µs
;==============================================================================

.global delay_micros

delay_micros:  
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
	DEC R24
	CPI R24, 0			; more loops to do?
	BRNE delay_micros	;	continue!
	RET

;==============================================================================
; delay_ms   delay of X ms
;==============================================================================

.global delay_ms

delay_ms:
	MOV R18, R24
loop_dms:
	LDI R24, 250
	RCALL delay_micros
	LDI R24, 250
	RCALL delay_micros
	LDI R24, 250
	RCALL delay_micros
	LDI R24, 250
	RCALL delay_micros
	DEC R18
	CPI R18, 0			; more loops to do?
	BRNE loop_dms		;	continue!
	RET

;==============================================================================
; delay_s   delay 1 sekund
;==============================================================================

.global delay_s

delay_s: 
	LDI R24, 250
	RCALL delay_ms
	LDI R24, 250
	RCALL delay_ms
	LDI R24, 250
	RCALL delay_ms
	LDI R24, 250
	RCALL delay_ms
	RET