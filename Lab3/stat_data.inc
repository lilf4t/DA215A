/*
 * stat_data.inc
 *
 *  Created: 2022-12-01 09:36:06
 *   Author: fatima kadum & ahmed al-faisal
 */ 

 /* ---------------------------------------------------------------- 
DESCRIPTION 
Space in the RAM to save the results from dice throws.  
The following functions are provided below: 

store_stat
    (R24 contains the dice value) 
    The function will increment the  
    Total number of throws and the  
    number of throws with results equals R24. 

 get_stat
    (R24 gives the value for which the  
    result is retrieved. If R24 = 0, the 
    total number of throws shall be returned. 
    The result is returned in R24. 

 clear_stat 
	(no parameters in nor out) 
    Clears all data. 

*/

.DSEG				; The following applies to the RAM: 
.ORG  0x100			; Set starting 
					; address of data 
					; segment to 0x100 


total_stat:  

        .BYTE 7 ;<skapa så mycket plats som behövs.>
		.CSEG 

store_stat: 
		LDI XH, HIGH(total_stat)
		LDI XL, LOW(total_stat)
		LD R17, X   
		INC R17     ; räknar tärningskast
		ST X, R17	; sparar till minnet

		ADD XL, R16
		LDI R24, 0      
		ADC XH, R24     ; total number of throws and the number of throws = R24
		LD R17,X
		INC R17         ; räknar värdet man får på tärningskastet
		ST X, R17		; sparar det till minnet
		RET 

get_stat:
		LDI XH, HIGH(total_stat)
		LDI XL, LOW(total_stat)
		ADD XL, RVAL
		LDI RVAL, 0     ; om RVAL = 0, så ska totala nmr av kast bli returned.
		ADC XH, RVAL
		LD RVAL, X      ; resultatet returneras med X
		RET 

clear_stat:
		LDI R16, 0x00
		STS total_stat, R16
		STS total_stat+1, R16
		STS total_stat+2, R16
		STS total_stat+3, R16
		STS total_stat+4, R16
		STS total_stat+5, R16
		STS total_stat+6, R16
		RET 