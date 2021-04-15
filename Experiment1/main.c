/*
 * GccApplication1.c
 *
 * Created: 4/8/2021 7:09:26 PM
 * Author : my
 */ 

#include <avr/io.h>
#include <avr/interrupt.h>
#define F_CPU 1000000
#include <util/delay.h>
int rot=1;
ISR(INT1_vect)
{
	if(rot!=0)
		rot=0;
	else 
	rot=1;
}
int main(void)
{
	MCUCSR = (1<<JTD);
	MCUCSR = (1<<JTD);
	GICR=1<<INT1;
	MCUCSR=MCUCSR|0b00001100;
	sei();
    DDRC=0xFF;
	DDRA=0xFF;
	int col;
	
	unsigned char start=0x04;
	while(1)
	{
	col=1;
	if(rot!=0)
	{

		start=start<<1;
		if(start==0x00)
		{
			start=0b00000001;
			
		}
		
	}
	
	PORTA=start;
	if(rot!=0)
	_delay_ms(50);
    while (col<=4) 
    {
		
		if(col==1)
		
		{
			PORTC=0x00;
			
			_delay_ms(1);
		
			/*if(rot==0)
			_delay_ms(1);
			else
			_delay_ms(1.5);*/
		}
	
		else if(col==2||col==3)
		{
				PORTC=0b01101110;
				_delay_ms(1);
	
			/*if(rot==0)
			_delay_ms(1);
			else
			_delay_ms(1.5);*/
		}
		else
		{
			PORTC=0b00001110;
			_delay_ms(1);
			/*if(rot==0)
			_delay_ms(1);
			else
			_delay_ms(1.5);*/
			break;
				
				
			
		}
	
		PORTA=PORTA<<1;
		if(PORTA==0x00)
		PORTA=0x01;
		col++;
		
		
    }
	
	}
	
}

