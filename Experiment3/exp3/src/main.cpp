#include<avr/io.h>
#define F_CPU 1000000
#include<avr/interrupt.h>
#include <util/delay.h>
#include <stdlib.h>
#define D4 eS_PORTD4
#define D5 eS_PORTD5
#define D6 eS_PORTD6
#define D7 eS_PORTD7
#define RS eS_PORTC6
#define EN eS_PORTC7
#include "lcd.h"
char buffer[20];
int main(void)
{
uint16_t bin;
float voltage;
DDRD = 0xFF;
DDRC = 0xFF;
ADMUX=0b01000011;
ADCSRA=0b10001101;
Lcd4_Init();
while(1)
{
    ADCSRA|=1<<ADSC;
    while(ADCSRA &(1<<ADSC))
    {}
    uint8_t bin1=ADCL;
    bin=(ADCH<<8|bin1);
    voltage=bin*0.00488;
    Lcd4_Clear();
    Lcd4_Set_Cursor(1,1);
    Lcd4_Write_String("Voltage: ");
    dtostrf(voltage, 1, 2, buffer);
    Lcd4_Write_String(buffer);
    _delay_ms(500);
    

}
}