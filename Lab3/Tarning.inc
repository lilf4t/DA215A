/*
 * Tarning.inc
 *
 *  Created: 2022-11-29 17:28:29
 *   Author: fatim
 */ 

roll_dice:
LDI R16, 6   ;dice have 6 values

test: 	
    NOP 
	NOP 
	RCALL read_keyboard ;key-value in RVAL
	RCALL to_ASCII
	CPI RVAL, ROLL_KEY
	BREQ roll ;yes, key 1 is still pressed
	RCALL store_stat   ; för att spara värden
	RET ;no, key is released

roll: 
     DEC R16 ;start cycle count here
     BREQ roll_dice ;R16 is zero?, start agn at 6
     RJMP test ;no, keep rolling




 