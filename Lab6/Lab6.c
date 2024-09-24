/*
 * $safeprojectname$.c
 *
 * Created: 2022-12-15 10:53:54
 * Author : fatima kadum & ahmed al-faisal
 */ 


#include <avr/io.h>
#include "hmi/hmi.h"
#include "regulator/regulator.h"
#include "numkey/numkey.h"
#include <stdio.h>
#include "lcd/lcd.h"
#include "common.h"
#include "delay/delay.h"
#include "motor/motor.h"



enum state
{
	MOTOR_OFF,
	MOTOR_ON,
	MOTOR_RUNNING
};


typedef enum state state_t;

int main(void)
{
	
	hmi_init();
	numkey_init();
	motor_init();
	regulator_init();
	
    char key;
	char regulator;
	char regulator_str[17];
	char off[] = "Motor off";
	char on[] = "Motor on";
	char running[] = "Motor running";
	
	
	state_t current_state = MOTOR_OFF;
	state_t next_state;
	
	/* Replace with your application code */

		while(1) {
			key = numkey_read();
		
			   switch(current_state){
			      case MOTOR_OFF:
					  if((key == '2') && (regulator_read() == 0)) {
						  next_state = MOTOR_ON;
					  }
					  sprintf(regulator_str, "%u%%", regulator_read());
					  output_msg(off, regulator_str,0);
					  motor_set_speed(0);
					  break;
					  
					  case MOTOR_ON:
					  if (key == '1')
					  {
						  next_state= MOTOR_OFF;
					  }
					  else if (regulator_read() > 0)
					  {
						  next_state = MOTOR_RUNNING;
					  }
					  sprintf(regulator_str, "%u%%", regulator_read());
					  output_msg(on, regulator_str,0);
					  break;
					  
					  case MOTOR_RUNNING:
					  if (key == '1')
					  {
						  next_state = MOTOR_OFF;
					  }
					  sprintf(regulator_str, "%u%%", regulator_read());
					  output_msg(running, regulator_str,0);
					  motor_set_speed(regulator_read());
					  break;
				  }
				  current_state = next_state;
			  }
	    }
	