
#include <mega8.h>
#include <delay.h>

                        //������� ������� ����� ���������
//------------------------------------------------------------------------------
#define CYCLE_LENGTH        600//����� � �������� ����� ���������
//------------------------------------------------------------------------------



                        //������� ����������� ��������� ��������� "1"
//------------------------------------------------------------------------------
                        //������ ����������            
#define VALVE_1_ON         0//����� � �������� ��������� ��������� "1"
#define VALVE_1_OFF        240//����� � �������� ���������� ��������� "1"

                        //������ ����������
#define VALVE_11_ON        540//����� � �������� ��������� ��������� "1"
#define VALVE_11_OFF       600//����� � �������� ���������� ��������� "1"
//------------------------------------------------------------------------------



                        //������� ����������� ��������� ��������� "2"
//------------------------------------------------------------------------------
                        //������ ����������
#define VALVE_2_ON         180//����� � �������� ��������� ��������� "2"
#define VALVE_2_OFF        580//����� � �������� ���������� ��������� "2"

                        //������ ����������
#define VALVE_22_ON        0//����� � �������� ��������� ��������� "2"
#define VALVE_22_OFF       0//����� � �������� ���������� ��������� "2"
//------------------------------------------------------------------------------



                        //������� ����������� ��������� ��������� "2.1"
//------------------------------------------------------------------------------
                        //������ ����������
#define VALVE_2_1_ON       180//����� � �������� ��������� ��������� "2.1"
#define VALVE_2_1_OFF      540//����� � �������� ���������� ��������� "2.1"

                        //������ ����������
#define VALVE_22_1_ON      0//����� � �������� ��������� ��������� "2.1"
#define VALVE_22_1_OFF     0//����� � �������� ���������� ��������� "2.1"
//------------------------------------------------------------------------------


                         //������� ����������� ��������� ��������� "3"
//------------------------------------------------------------------------------
                        //������ ����������
#define VALVE_3_ON         240//����� � �������� ��������� ��������� "3"
#define VALVE_3_OFF        540//����� � �������� ���������� ��������� "3"

                        //������ ����������
#define VALVE_33_ON        0//����� � �������� ��������� ��������� "3"
#define VALVE_33_OFF       0//����� � �������� ���������� ��������� "3"
//------------------------------------------------------------------------------



                         //������� ����������� ��������� ��������� "4"
//------------------------------------------------------------------------------
                        //������ ����������
#define VALVE_4_ON         0//����� � �������� ��������� ��������� "4"
#define VALVE_4_OFF        280//����� � �������� ���������� ��������� "4"

                        //������ ����������
#define VALVE_44_ON        480//����� � �������� ��������� ��������� "4"
#define VALVE_44_OFF       600//����� � �������� ���������� ��������� "4"
//------------------------------------------------------------------------------


                         //������� ����������� ��������� ��������� "4.1"
//------------------------------------------------------------------------------
                        //������ ����������
#define VALVE_4_1_ON       0//����� � �������� ��������� ��������� "4.1"
#define VALVE_4_1_OFF      240//����� � �������� ���������� ��������� "4.1"

                        //������ ����������
#define VALVE_44_1_ON      480//����� � �������� ��������� ��������� "4.1"
#define VALVE_44_1_OFF     600//����� � �������� ���������� ��������� "4.1"
//------------------------------------------------------------------------------
#define R1_ON       PORTC|=(1<<1)
#define R1_OFF      PORTC&=~(1<<1)

#define R2_ON       PORTC|=(1<<2)
#define R2_OFF      PORTC&=~(1<<2)
#define R2_1_ON     PORTC|=(1<<3)
#define R2_1_OFF    PORTC&=~(1<<3)

#define R3_ON       PORTC|=(1<<4)
#define R3_OFF      PORTC&=~(1<<4)

#define R4_ON       PORTC|=(1<<5)
#define R4_OFF      PORTC&=~(1<<5)
#define R4_1_ON     PORTD|=(1<<0)
#define R4_1_OFF    PORTD&=~(1<<0)

#define START       (PINB.2==0)
#define STOP        (PINB.1==0)
#define ON          PORTD|=(1<<2);
#define OFF         PORTD&=~(1<<2);

int time = 0;
eeprom int time_eep = 0;

void init(void);
void valves(void);
void buttons(void);
interrupt [TIM1_COMPA] void timer1_compa_isr(void);

void main(void)
{
    init();
                  
    OFF
    while(!START){}
    ON
    
while (1)
      {     
            valves();
            buttons();    
      }
}
//------------------------------------------------------------------
//
//------------------------------------------------------------------
void buttons(void)
{
    if(START){
        TCCR1B = 0x0C;
        ON
        delay_ms(500);
    }
    
    if(STOP){
        TCCR1B=0x00;
        time_eep = time; 
        OFF
        delay_ms(1000);
        if(STOP){ 
            delay_ms(2500);
            if(STOP){
                R1_OFF;
                R2_OFF; 
                R2_1_OFF;
                R3_OFF;
                R4_OFF;
                R4_1_OFF;
                time = 0;
                time_eep = time;
                while(!START){}
            }
        }
    }
}
//------------------------------------------------------------------
//
//------------------------------------------------------------------
void valves(void)
{
    static char R1=0;
    static char R2=0;
    static char R21=0;
    static char R3=0;
    static char R4=0;
    static char R41=0;

    if(time>=VALVE_1_ON &&  time<VALVE_1_OFF)R1=1;
    if(time>=VALVE_11_ON &&  time<VALVE_11_OFF)R1=1;
    if(R1){
        R1_ON;
    }else {
        R1_OFF;
    }
    R1=0;  

    if((time>=VALVE_2_ON) && (time<VALVE_2_OFF))R2=1;
    if((time>=VALVE_22_ON) && (time<VALVE_22_OFF))R2=1;
    if(R2){
        R2_ON;
    }else {
        R2_OFF;
    }
    R2=0;

    if((time>=VALVE_2_1_ON) && (time<VALVE_2_1_OFF))R21=1;
    if((time>=VALVE_22_1_ON) && (time<VALVE_22_1_OFF))R21=1;
    if(R21){
        R2_1_ON;
    }else {
        R2_1_OFF;
    }
    R21=0;

    if((time>=VALVE_3_ON) && (time<VALVE_3_OFF))R3=1;
    if((time>=VALVE_33_ON) && (time<VALVE_33_OFF))R3=1;
    if(R3){
        R3_ON;
    }else {
        R3_OFF;
    }
    R3=0;

    if((time>=VALVE_4_ON) && (time<VALVE_4_OFF))R4=1;
    if((time>=VALVE_44_ON) && (time<VALVE_44_OFF))R4=1;
    if(R4){
        R4_ON;
    }else {
        R4_OFF;
    }
    R4=0;
        
    if((time>=VALVE_4_1_ON) && (time<VALVE_4_1_OFF))R41=1;
    if((time>=VALVE_44_1_ON) && (time<VALVE_44_1_OFF))R41=1;
    if(R41){
        R4_1_ON;
    }else {
        R4_1_OFF;
    }
    R41=0;
}
//------------------------------------------------------------------
//
//------------------------------------------------------------------
interrupt [TIM1_COMPA] void timer1_compa_isr(void)
{
  time++;
  if(time>(CYCLE_LENGTH-1))
    time = 0;
}
//------------------------------------------------------------------
//
//------------------------------------------------------------------
void init(void)
{
    time = time_eep;
    
    PORTB=0b00000110;
    DDRB=0x00;

    PORTC=0x00;
    DDRC=0b0111110;
 
    PORTD=0x00;
    DDRD=0b00000111;

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
    TCCR1B=0x0C;
    TCNT1H=0x00;
    TCNT1L=0x00;
    ICR1H=0x00;
    ICR1L=0x00;
    OCR1AH=244;
    OCR1AL=36;
    OCR1BH=0x00;
    OCR1BL=0x00;

    // Timer(s)/Counter(s) Interrupt(s) initialization
    TIMSK=0x10;

    // Global enable interrupts
    #asm("sei")

}
//------------------------------------------------------------------
//
//------------------------------------------------------------------