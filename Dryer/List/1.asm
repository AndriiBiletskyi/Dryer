
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _time=R4

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_compa_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x42:
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x04
	.DW  _0x42*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;                        //Задание времени цикла программы
;//------------------------------------------------------------------------------
;#define CYCLE_LENGTH        600//Время в секундах цикла программы
;//------------------------------------------------------------------------------
;
;
;
;                        //Задание промежутков включения соленоида "1"
;//------------------------------------------------------------------------------
;                        //Первый промежуток
;#define VALVE_1_ON         0//Время в секундах включения соленоида "1"
;#define VALVE_1_OFF        240//Время в секундах выключения соленоида "1"
;
;                        //Второй промежуток
;#define VALVE_11_ON        540//Время в секундах включения соленоида "1"
;#define VALVE_11_OFF       600//Время в секундах выключения соленоида "1"
;//------------------------------------------------------------------------------
;
;
;
;                        //Задание промежутков включения соленоида "2"
;//------------------------------------------------------------------------------
;                        //Первый промежуток
;#define VALVE_2_ON         180//Время в секундах включения соленоида "2"
;#define VALVE_2_OFF        580//Время в секундах выключения соленоида "2"
;
;                        //Второй промежуток
;#define VALVE_22_ON        0//Время в секундах включения соленоида "2"
;#define VALVE_22_OFF       0//Время в секундах выключения соленоида "2"
;//------------------------------------------------------------------------------
;
;
;
;                        //Задание промежутков включения соленоида "2.1"
;//------------------------------------------------------------------------------
;                        //Первый промежуток
;#define VALVE_2_1_ON       180//Время в секундах включения соленоида "2.1"
;#define VALVE_2_1_OFF      540//Время в секундах выключения соленоида "2.1"
;
;                        //Второй промежуток
;#define VALVE_22_1_ON      0//Время в секундах включения соленоида "2.1"
;#define VALVE_22_1_OFF     0//Время в секундах выключения соленоида "2.1"
;//------------------------------------------------------------------------------
;
;
;                         //Задание промежутков включения соленоида "3"
;//------------------------------------------------------------------------------
;                        //Первый промежуток
;#define VALVE_3_ON         240//Время в секундах включения соленоида "3"
;#define VALVE_3_OFF        540//Время в секундах выключения соленоида "3"
;
;                        //Второй промежуток
;#define VALVE_33_ON        0//Время в секундах включения соленоида "3"
;#define VALVE_33_OFF       0//Время в секундах выключения соленоида "3"
;//------------------------------------------------------------------------------
;
;
;
;                         //Задание промежутков включения соленоида "4"
;//------------------------------------------------------------------------------
;                        //Первый промежуток
;#define VALVE_4_ON         0//Время в секундах включения соленоида "4"
;#define VALVE_4_OFF        280//Время в секундах выключения соленоида "4"
;
;                        //Второй промежуток
;#define VALVE_44_ON        480//Время в секундах включения соленоида "4"
;#define VALVE_44_OFF       600//Время в секундах выключения соленоида "4"
;//------------------------------------------------------------------------------
;
;
;                         //Задание промежутков включения соленоида "4.1"
;//------------------------------------------------------------------------------
;                        //Первый промежуток
;#define VALVE_4_1_ON       0//Время в секундах включения соленоида "4.1"
;#define VALVE_4_1_OFF      240//Время в секундах выключения соленоида "4.1"
;
;                        //Второй промежуток
;#define VALVE_44_1_ON      480//Время в секундах включения соленоида "4.1"
;#define VALVE_44_1_OFF     600//Время в секундах выключения соленоида "4.1"
;//------------------------------------------------------------------------------
;#define R1_ON       PORTC|=(1<<1)
;#define R1_OFF      PORTC&=~(1<<1)
;
;#define R2_ON       PORTC|=(1<<2)
;#define R2_OFF      PORTC&=~(1<<2)
;#define R2_1_ON     PORTC|=(1<<3)
;#define R2_1_OFF    PORTC&=~(1<<3)
;
;#define R3_ON       PORTC|=(1<<4)
;#define R3_OFF      PORTC&=~(1<<4)
;
;#define R4_ON       PORTC|=(1<<5)
;#define R4_OFF      PORTC&=~(1<<5)
;#define R4_1_ON     PORTD|=(1<<0)
;#define R4_1_OFF    PORTD&=~(1<<0)
;
;#define START       (PINB.2==0)
;#define STOP        (PINB.1==0)
;#define ON          PORTD|=(1<<2);
;#define OFF         PORTD&=~(1<<2);
;
;int time = 0;
;eeprom int time_eep = 0;
;
;void init(void);
;void valves(void);
;void buttons(void);
;interrupt [TIM1_COMPA] void timer1_compa_isr(void);
;
;void main(void)
; 0000 0073 {

	.CSEG
_main:
; 0000 0074     init();
	RCALL _init
; 0000 0075 
; 0000 0076     OFF
	CBI  0x12,2
; 0000 0077     while(!START){}
_0x3:
	RCALL SUBOPT_0x0
	BRNE _0x3
; 0000 0078     ON
	SBI  0x12,2
; 0000 0079 
; 0000 007A while (1)
_0x6:
; 0000 007B       {
; 0000 007C             valves();
	RCALL _valves
; 0000 007D             buttons();
	RCALL _buttons
; 0000 007E       }
	RJMP _0x6
; 0000 007F }
_0x9:
	RJMP _0x9
;//------------------------------------------------------------------
;//
;//------------------------------------------------------------------
;void buttons(void)
; 0000 0084 {
_buttons:
; 0000 0085     if(START){
	SBIC 0x16,2
	RJMP _0xA
; 0000 0086         TCCR1B = 0x0C;
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 0087         ON
	SBI  0x12,2
; 0000 0088         delay_ms(500);
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	RCALL _delay_ms
; 0000 0089     }
; 0000 008A 
; 0000 008B     if(STOP){
_0xA:
	SBIC 0x16,1
	RJMP _0xB
; 0000 008C         TCCR1B=0x00;
	LDI  R30,LOW(0)
	OUT  0x2E,R30
; 0000 008D         time_eep = time;
	RCALL SUBOPT_0x1
; 0000 008E         OFF
	CBI  0x12,2
; 0000 008F         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0090         if(STOP){
	SBIC 0x16,1
	RJMP _0xC
; 0000 0091             delay_ms(2500);
	LDI  R26,LOW(2500)
	LDI  R27,HIGH(2500)
	RCALL _delay_ms
; 0000 0092             if(STOP){
	SBIC 0x16,1
	RJMP _0xD
; 0000 0093                 R1_OFF;
	CBI  0x15,1
; 0000 0094                 R2_OFF;
	CBI  0x15,2
; 0000 0095                 R2_1_OFF;
	CBI  0x15,3
; 0000 0096                 R3_OFF;
	CBI  0x15,4
; 0000 0097                 R4_OFF;
	CBI  0x15,5
; 0000 0098                 R4_1_OFF;
	CBI  0x12,0
; 0000 0099                 time = 0;
	CLR  R4
	CLR  R5
; 0000 009A                 time_eep = time;
	RCALL SUBOPT_0x1
; 0000 009B                 while(!START){}
_0xE:
	RCALL SUBOPT_0x0
	BRNE _0xE
; 0000 009C             }
; 0000 009D         }
_0xD:
; 0000 009E     }
_0xC:
; 0000 009F }
_0xB:
	RET
;//------------------------------------------------------------------
;//
;//------------------------------------------------------------------
;void valves(void)
; 0000 00A4 {
_valves:
; 0000 00A5     static char R1=0;
; 0000 00A6     static char R2=0;
; 0000 00A7     static char R21=0;
; 0000 00A8     static char R3=0;
; 0000 00A9     static char R4=0;
; 0000 00AA     static char R41=0;
; 0000 00AB 
; 0000 00AC     if(time>=VALVE_1_ON &&  time<VALVE_1_OFF)R1=1;
	RCALL SUBOPT_0x2
	BRLT _0x12
	RCALL SUBOPT_0x3
	BRLT _0x13
_0x12:
	RJMP _0x11
_0x13:
	LDI  R30,LOW(1)
	STS  _R1_S0000002000,R30
; 0000 00AD     if(time>=VALVE_11_ON &&  time<VALVE_11_OFF)R1=1;
_0x11:
	RCALL SUBOPT_0x4
	BRLT _0x15
	RCALL SUBOPT_0x5
	BRLT _0x16
_0x15:
	RJMP _0x14
_0x16:
	LDI  R30,LOW(1)
	STS  _R1_S0000002000,R30
; 0000 00AE     if(R1){
_0x14:
	LDS  R30,_R1_S0000002000
	CPI  R30,0
	BREQ _0x17
; 0000 00AF         R1_ON;
	SBI  0x15,1
; 0000 00B0     }else {
	RJMP _0x18
_0x17:
; 0000 00B1         R1_OFF;
	CBI  0x15,1
; 0000 00B2     }
_0x18:
; 0000 00B3     R1=0;
	LDI  R30,LOW(0)
	STS  _R1_S0000002000,R30
; 0000 00B4 
; 0000 00B5     if((time>=VALVE_2_ON) && (time<VALVE_2_OFF))R2=1;
	RCALL SUBOPT_0x6
	BRLT _0x1A
	LDI  R30,LOW(580)
	LDI  R31,HIGH(580)
	RCALL SUBOPT_0x7
	BRLT _0x1B
_0x1A:
	RJMP _0x19
_0x1B:
	LDI  R30,LOW(1)
	STS  _R2_S0000002000,R30
; 0000 00B6     if((time>=VALVE_22_ON) && (time<VALVE_22_OFF))R2=1;
_0x19:
	RCALL SUBOPT_0x2
	BRLT _0x1D
	RCALL SUBOPT_0x2
	BRLT _0x1E
_0x1D:
	RJMP _0x1C
_0x1E:
	LDI  R30,LOW(1)
	STS  _R2_S0000002000,R30
; 0000 00B7     if(R2){
_0x1C:
	LDS  R30,_R2_S0000002000
	CPI  R30,0
	BREQ _0x1F
; 0000 00B8         R2_ON;
	SBI  0x15,2
; 0000 00B9     }else {
	RJMP _0x20
_0x1F:
; 0000 00BA         R2_OFF;
	CBI  0x15,2
; 0000 00BB     }
_0x20:
; 0000 00BC     R2=0;
	LDI  R30,LOW(0)
	STS  _R2_S0000002000,R30
; 0000 00BD 
; 0000 00BE     if((time>=VALVE_2_1_ON) && (time<VALVE_2_1_OFF))R21=1;
	RCALL SUBOPT_0x6
	BRLT _0x22
	RCALL SUBOPT_0x4
	BRLT _0x23
_0x22:
	RJMP _0x21
_0x23:
	LDI  R30,LOW(1)
	STS  _R21_S0000002000,R30
; 0000 00BF     if((time>=VALVE_22_1_ON) && (time<VALVE_22_1_OFF))R21=1;
_0x21:
	RCALL SUBOPT_0x2
	BRLT _0x25
	RCALL SUBOPT_0x2
	BRLT _0x26
_0x25:
	RJMP _0x24
_0x26:
	LDI  R30,LOW(1)
	STS  _R21_S0000002000,R30
; 0000 00C0     if(R21){
_0x24:
	LDS  R30,_R21_S0000002000
	CPI  R30,0
	BREQ _0x27
; 0000 00C1         R2_1_ON;
	SBI  0x15,3
; 0000 00C2     }else {
	RJMP _0x28
_0x27:
; 0000 00C3         R2_1_OFF;
	CBI  0x15,3
; 0000 00C4     }
_0x28:
; 0000 00C5     R21=0;
	LDI  R30,LOW(0)
	STS  _R21_S0000002000,R30
; 0000 00C6 
; 0000 00C7     if((time>=VALVE_3_ON) && (time<VALVE_3_OFF))R3=1;
	RCALL SUBOPT_0x3
	BRLT _0x2A
	RCALL SUBOPT_0x4
	BRLT _0x2B
_0x2A:
	RJMP _0x29
_0x2B:
	LDI  R30,LOW(1)
	STS  _R3_S0000002000,R30
; 0000 00C8     if((time>=VALVE_33_ON) && (time<VALVE_33_OFF))R3=1;
_0x29:
	RCALL SUBOPT_0x2
	BRLT _0x2D
	RCALL SUBOPT_0x2
	BRLT _0x2E
_0x2D:
	RJMP _0x2C
_0x2E:
	LDI  R30,LOW(1)
	STS  _R3_S0000002000,R30
; 0000 00C9     if(R3){
_0x2C:
	LDS  R30,_R3_S0000002000
	CPI  R30,0
	BREQ _0x2F
; 0000 00CA         R3_ON;
	SBI  0x15,4
; 0000 00CB     }else {
	RJMP _0x30
_0x2F:
; 0000 00CC         R3_OFF;
	CBI  0x15,4
; 0000 00CD     }
_0x30:
; 0000 00CE     R3=0;
	LDI  R30,LOW(0)
	STS  _R3_S0000002000,R30
; 0000 00CF 
; 0000 00D0     if((time>=VALVE_4_ON) && (time<VALVE_4_OFF))R4=1;
	RCALL SUBOPT_0x2
	BRLT _0x32
	LDI  R30,LOW(280)
	LDI  R31,HIGH(280)
	RCALL SUBOPT_0x7
	BRLT _0x33
_0x32:
	RJMP _0x31
_0x33:
	LDI  R30,LOW(1)
	STS  _R4_S0000002000,R30
; 0000 00D1     if((time>=VALVE_44_ON) && (time<VALVE_44_OFF))R4=1;
_0x31:
	LDI  R30,LOW(480)
	LDI  R31,HIGH(480)
	RCALL SUBOPT_0x7
	BRLT _0x35
	RCALL SUBOPT_0x5
	BRLT _0x36
_0x35:
	RJMP _0x34
_0x36:
	LDI  R30,LOW(1)
	STS  _R4_S0000002000,R30
; 0000 00D2     if(R4){
_0x34:
	LDS  R30,_R4_S0000002000
	CPI  R30,0
	BREQ _0x37
; 0000 00D3         R4_ON;
	SBI  0x15,5
; 0000 00D4     }else {
	RJMP _0x38
_0x37:
; 0000 00D5         R4_OFF;
	CBI  0x15,5
; 0000 00D6     }
_0x38:
; 0000 00D7     R4=0;
	LDI  R30,LOW(0)
	STS  _R4_S0000002000,R30
; 0000 00D8 
; 0000 00D9     if((time>=VALVE_4_1_ON) && (time<VALVE_4_1_OFF))R41=1;
	RCALL SUBOPT_0x2
	BRLT _0x3A
	RCALL SUBOPT_0x3
	BRLT _0x3B
_0x3A:
	RJMP _0x39
_0x3B:
	LDI  R30,LOW(1)
	STS  _R41_S0000002000,R30
; 0000 00DA     if((time>=VALVE_44_1_ON) && (time<VALVE_44_1_OFF))R41=1;
_0x39:
	LDI  R30,LOW(480)
	LDI  R31,HIGH(480)
	RCALL SUBOPT_0x7
	BRLT _0x3D
	RCALL SUBOPT_0x5
	BRLT _0x3E
_0x3D:
	RJMP _0x3C
_0x3E:
	LDI  R30,LOW(1)
	STS  _R41_S0000002000,R30
; 0000 00DB     if(R41){
_0x3C:
	LDS  R30,_R41_S0000002000
	CPI  R30,0
	BREQ _0x3F
; 0000 00DC         R4_1_ON;
	SBI  0x12,0
; 0000 00DD     }else {
	RJMP _0x40
_0x3F:
; 0000 00DE         R4_1_OFF;
	CBI  0x12,0
; 0000 00DF     }
_0x40:
; 0000 00E0     R41=0;
	LDI  R30,LOW(0)
	STS  _R41_S0000002000,R30
; 0000 00E1 }
	RET
;//------------------------------------------------------------------
;//
;//------------------------------------------------------------------
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 00E6 {
_timer1_compa_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00E7   time++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 00E8   if(time>(CYCLE_LENGTH-1))
	LDI  R30,LOW(599)
	LDI  R31,HIGH(599)
	CP   R30,R4
	CPC  R31,R5
	BRGE _0x41
; 0000 00E9     time = 0;
	CLR  R4
	CLR  R5
; 0000 00EA }
_0x41:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;//------------------------------------------------------------------
;//
;//------------------------------------------------------------------
;void init(void)
; 0000 00EF {
_init:
; 0000 00F0     time = time_eep;
	LDI  R26,LOW(_time_eep)
	LDI  R27,HIGH(_time_eep)
	RCALL __EEPROMRDW
	MOVW R4,R30
; 0000 00F1 
; 0000 00F2     PORTB=0b00000110;
	LDI  R30,LOW(6)
	OUT  0x18,R30
; 0000 00F3     DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 00F4 
; 0000 00F5     PORTC=0x00;
	OUT  0x15,R30
; 0000 00F6     DDRC=0b0111110;
	LDI  R30,LOW(62)
	OUT  0x14,R30
; 0000 00F7 
; 0000 00F8     PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 00F9     DDRD=0b00000111;
	LDI  R30,LOW(7)
	OUT  0x11,R30
; 0000 00FA 
; 0000 00FB     // Timer/Counter 1 initialization
; 0000 00FC     // Clock source: System Clock
; 0000 00FD     // Clock value: Timer1 Stopped
; 0000 00FE     // Mode: Normal top=0xFFFF
; 0000 00FF     // OC1A output: Discon.
; 0000 0100     // OC1B output: Discon.
; 0000 0101     // Noise Canceler: Off
; 0000 0102     // Input Capture on Falling Edge
; 0000 0103     // Timer1 Overflow Interrupt: Off
; 0000 0104     // Input Capture Interrupt: Off
; 0000 0105     // Compare A Match Interrupt: Off
; 0000 0106     // Compare B Match Interrupt: Off
; 0000 0107     TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0108     TCCR1B=0x0C;
	LDI  R30,LOW(12)
	OUT  0x2E,R30
; 0000 0109     TCNT1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x2D,R30
; 0000 010A     TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 010B     ICR1H=0x00;
	OUT  0x27,R30
; 0000 010C     ICR1L=0x00;
	OUT  0x26,R30
; 0000 010D     OCR1AH=244;
	LDI  R30,LOW(244)
	OUT  0x2B,R30
; 0000 010E     OCR1AL=36;
	LDI  R30,LOW(36)
	OUT  0x2A,R30
; 0000 010F     OCR1BH=0x00;
	LDI  R30,LOW(0)
	OUT  0x29,R30
; 0000 0110     OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0111 
; 0000 0112     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0113     TIMSK=0x10;
	LDI  R30,LOW(16)
	OUT  0x39,R30
; 0000 0114 
; 0000 0115     // Global enable interrupts
; 0000 0116     #asm("sei")
	sei
; 0000 0117 
; 0000 0118 }
	RET
;//------------------------------------------------------------------
;//
;//------------------------------------------------------------------

	.ESEG
_time_eep:
	.DB  0x0,0x0

	.DSEG
_R1_S0000002000:
	.BYTE 0x1
_R2_S0000002000:
	.BYTE 0x1
_R21_S0000002000:
	.BYTE 0x1
_R3_S0000002000:
	.BYTE 0x1
_R4_S0000002000:
	.BYTE 0x1
_R41_S0000002000:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R26,0
	SBIC 0x16,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	MOVW R30,R4
	LDI  R26,LOW(_time_eep)
	LDI  R27,HIGH(_time_eep)
	RCALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x2:
	CLR  R0
	CP   R4,R0
	CPC  R5,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(240)
	LDI  R31,HIGH(240)
	CP   R4,R30
	CPC  R5,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(540)
	LDI  R31,HIGH(540)
	CP   R4,R30
	CPC  R5,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	CP   R4,R30
	CPC  R5,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CP   R4,R30
	CPC  R5,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CP   R4,R30
	CPC  R5,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

;END OF CODE MARKER
__END_OF_CODE:
