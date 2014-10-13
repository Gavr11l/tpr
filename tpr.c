/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Professional
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 08.06.2014
Author  : usertt
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>

#include "ds18x20_v3.h"  
#include "ds1307_twi.h"
#include "tpr.h"

#include <alcd.h>
#include <delay.h>
#include <stdio.h>


// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0x00;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// определить устройства (опросить датчики)
devices=w1_search(0xf0,rom_code);


// Alphanumeric LCD initialization
// Connections are specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTD Bit 0
// RD - PORTD Bit 1
// EN - PORTD Bit 2
// D4 - PORTD Bit 4
// D5 - PORTD Bit 5
// D6 - PORTD Bit 6
// D7 - PORTD Bit 7
// Characters/line: 8
lcd_init(16);

/* enable interrupts so that TWI can be used */
#asm("sei")


// бит 7 (CH) регистра секунд DS1307 останавливает или запускает генератор
// (0 - запущен, 1 - остановлен)
rtc_get_time(&hour, &minutes, &sec);
sec &= 0b01111111;                    // принудительна€ установка 7-го бита в "0"
rtc_set_time(hour, minutes, sec); 

	if (rtc_read(63) != 0x55) { // €чейка с адресом 63 - "флаг новой микросхемы RTC"
		rtc_set_time(0x00, 0x00, 0x00); // установка стартовых значений
		rtc_set_date(0x12, 0x02, 0x11);
	}



lcd_putsf("Hello!!!");

while (1)
      {
     /* read the time from the RTC */
      rtc_get_time(&hour,&minutes,&sec);
      
      /* read the date from the RTC */
      rtc_get_date(&day,&month,&year);
      
      /* display the time on the LCD */
      sprintf(display_buffer,"Time: %2d:%02d:%02d\n",hour,minutes,sec);
      lcd_clear();
      lcd_puts(display_buffer);
      
      /* display the date on the LCD */
      sprintf(display_buffer,"Date: %2d/%02d/%d",day,month,
              2000+year);
      lcd_puts(display_buffer);
        
      


    lcd_gotoxy(8, 0);
    lcd_puts(lcd_buffer); 

      delay_ms(5000); /* 0.5 second delay */

      }
}
