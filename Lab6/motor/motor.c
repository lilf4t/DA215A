/*
 * motor.c
 *
 * Created: 2023-01-03 13:00:00
 *  Author: fatima
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
#include "motor.h"

//6.2.1
void motor_init(void) {
	DDRC |= 0xFF;  // set PC6 (digital pin 5) as output
	TCCR3A |= (1<<COM3A1); // Set OC3A (PC6) to be cleared on Compare Match
	//(Channel A)
	TCCR3A |= (1<<WGM30); // Waveform Generation Mode 5, Fast PWM (8-bit)
	TCCR3B |= (1<<WGM32);
	TCCR3B |= (1<<CS30) | (1<<CS31);  // Timer Clock, 16/64 MHz = 1/4 MHz
}

/* Set motor speed
* Parameter 'speed' is given in the format of 0-100%. */
void motor_set_speed(uint8_t speed) {
	OCR3AH = 0;    // not used
	OCR3AL = (speed * 255) / 100; // set PWM value
}