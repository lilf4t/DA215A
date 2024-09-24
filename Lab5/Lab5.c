/*
 * $safeprojectname$.c
 *
 * Created: 2022-12-13 13:33:33
 * Author : Fatima Kadum & Ahmed Al-Faisal
 */ 

#include <avr/io.h>
#include "hmi/hmi.h"
#include "temp/temp.h"
#include "numkey/numkey.h"
#include <stdio.h>
#include "lcd/lcd.h"
#include "common.h"
#include "delay/delay.h"

	//uppgift 5.2.2
	enum state
	{
		SHOW_TEMP_C,
		SHOW_TEMP_F,
		SHOW_TEMP_CF
	};
	
	//5.2.3
	typedef enum state state_t;
	

int main(void)
{
	//5.2.4
	hmi_init();
	numkey_init();
	temp_init();
	
	
	//char key;
	char temp_str[17];
	char str[] = "temperature";  //visade konstiga tecken så vi gjorde det till en array och det fungerade
	
	//5.2.5
	state_t current_state = SHOW_TEMP_C;
	state_t next_state = SHOW_TEMP_C;
	
    /* Replace with your application code */
    while (1) 
    {
		
		//5.2.7
		switch(current_state) {
		case SHOW_TEMP_C:
		     sprintf(temp_str, "%u%cC", temp_read_celsius(), 0xDF); 
		      
		   break;
			 
	    case SHOW_TEMP_F:
	         sprintf(temp_str, "%u%cF", temp_read_fahrenheit(), 0xDF);
	         break;
		
		case SHOW_TEMP_CF:
		     sprintf(temp_str, "%u%cC, %u%cF", temp_read_celsius(), 0xDF, temp_read_fahrenheit(), 0xDF);
		     break;
    }
	
	char key = numkey_read();
	output_msg(str, temp_str,0);
	 switch(key) {
		 
		 case '1':
		 next_state = SHOW_TEMP_C;
		 break;
		 
		 case '2':
		 next_state = SHOW_TEMP_F;
		 break;
		 
		 case '3':
		 next_state = SHOW_TEMP_CF;
		 break;
	 }
	 current_state = next_state;    //så att den sparas
  } 
}

