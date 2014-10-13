
;CodeVisionAVR C Compiler V2.05.3 Professional
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int
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
	.DEF _hour=R5
	.DEF _minutes=R4
	.DEF _sec=R7
	.DEF _day=R6
	.DEF _month=R9
	.DEF _year=R8
	.DEF _weekDay=R11
	.DEF _devices=R10
	.DEF __lcd_x=R13
	.DEF __lcd_y=R12

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
	RJMP 0x00

_conv_delay_G100:
	.DB  0x64,0x0,0xC8,0x0,0x90,0x1,0x20,0x3
_bit_mask_G100:
	.DB  0xF8,0xFF,0xFC,0xFF,0xFE,0xFF,0xFF,0xFF
_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x48,0x65,0x6C,0x6C,0x6F,0x21,0x21,0x21
	.DB  0x0,0x54,0x69,0x6D,0x65,0x3A,0x20,0x25
	.DB  0x32,0x64,0x3A,0x25,0x30,0x32,0x64,0x3A
	.DB  0x25,0x30,0x32,0x64,0xA,0x0,0x44,0x61
	.DB  0x74,0x65,0x3A,0x20,0x25,0x32,0x64,0x2F
	.DB  0x25,0x30,0x32,0x64,0x2F,0x25,0x64,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

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
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Professional
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 08.06.2014
;Author  : usertt
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
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
;
;#include "ds18x20_v3.h"
;#include "ds1307_twi.h"

	.CSEG
_twi_start:
	LDI  R30,LOW(228)
	OUT  0x36,R30
_0x3:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x3
	RET
_twi_stop:
	LDI  R30,LOW(148)
	OUT  0x36,R30
	RET
_twi_write:
	ST   -Y,R26
;	_data -> Y+0
	LD   R30,Y
	OUT  0x3,R30
	LDI  R30,LOW(132)
	OUT  0x36,R30
_0x6:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0x6
	RJMP _0x20A0002
_twi_read:
	ST   -Y,R26
	ST   -Y,R17
;	_ack -> Y+1
;	_data -> R17
	LDD  R26,Y+1
	CPI  R26,LOW(0x1)
	BRNE _0x9
	LDI  R30,LOW(196)
	RJMP _0x13
_0x9:
	LDI  R30,LOW(132)
_0x13:
	OUT  0x36,R30
_0xB:
	IN   R30,0x36
	ANDI R30,LOW(0x80)
	BREQ _0xB
	IN   R17,3
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20A0005
_rtc_set_time:
	RCALL SUBOPT_0x0
;	hour -> Y+2
;	min -> Y+1
;	sec -> Y+0
	LDI  R26,LOW(0)
	RCALL _twi_write
	LD   R26,Y
	RCALL SUBOPT_0x1
	LDD  R26,Y+2
	RCALL _twi_write
	RCALL _twi_stop
	RJMP _0x20A0004
_rtc_set_date:
	RCALL SUBOPT_0x0
;	date -> Y+2
;	month -> Y+1
;	year -> Y+0
	LDI  R26,LOW(4)
	RCALL _twi_write
	LDD  R26,Y+2
	RCALL SUBOPT_0x1
	LD   R26,Y
	RCALL _twi_write
	RCALL _twi_stop
	RJMP _0x20A0004
_rtc_get_time:
	RCALL SUBOPT_0x2
;	*hour -> Y+4
;	*min -> Y+2
;	*sec -> Y+0
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x3
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0x4
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RJMP _0x20A0006
_rtc_get_date:
	RCALL SUBOPT_0x2
;	*date -> Y+4
;	*month -> Y+2
;	*year -> Y+0
	LDI  R26,LOW(4)
	RCALL SUBOPT_0x3
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x4
	LD   R26,Y
	LDD  R27,Y+1
_0x20A0006:
	ST   X,R30
	RCALL _twi_stop
	ADIW R28,6
	RET
_rtc_read:
	ST   -Y,R26
	ST   -Y,R17
;	address -> Y+1
;	data -> R17
	RCALL _twi_start
	LDI  R26,LOW(208)
	RCALL SUBOPT_0x1
	RCALL _twi_start
	LDI  R26,LOW(209)
	RCALL _twi_write
	LDI  R26,LOW(0)
	RCALL _twi_read
	MOV  R17,R30
	RCALL _twi_stop
	MOV  R30,R17
	LDD  R17,Y+0
	RJMP _0x20A0005
;	address -> Y+1
;	data -> Y+0
;#include "tpr.h"
;
;#include <alcd.h>
;#include <delay.h>
;#include <stdio.h>
;
;
;// Declare your global variables here
;
;void main(void)
; 0000 0026 {
_main:
; 0000 0027 // Declare your local variables here
; 0000 0028 
; 0000 0029 // Input/Output Ports initialization
; 0000 002A // Port B initialization
; 0000 002B // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 002C // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 002D PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 002E DDRB=0x00;
	OUT  0x17,R30
; 0000 002F 
; 0000 0030 // Port C initialization
; 0000 0031 // Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0032 // State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0033 PORTC=0x00;
	OUT  0x15,R30
; 0000 0034 DDRC=0x00;
	OUT  0x14,R30
; 0000 0035 
; 0000 0036 // Port D initialization
; 0000 0037 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0038 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0039 PORTD=0x00;
	OUT  0x12,R30
; 0000 003A DDRD=0x00;
	OUT  0x11,R30
; 0000 003B 
; 0000 003C // Timer/Counter 0 initialization
; 0000 003D // Clock source: System Clock
; 0000 003E // Clock value: Timer 0 Stopped
; 0000 003F TCCR0=0x00;
	OUT  0x33,R30
; 0000 0040 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0041 
; 0000 0042 // Timer/Counter 1 initialization
; 0000 0043 // Clock source: System Clock
; 0000 0044 // Clock value: Timer1 Stopped
; 0000 0045 // Mode: Normal top=0xFFFF
; 0000 0046 // OC1A output: Discon.
; 0000 0047 // OC1B output: Discon.
; 0000 0048 // Noise Canceler: Off
; 0000 0049 // Input Capture on Falling Edge
; 0000 004A // Timer1 Overflow Interrupt: Off
; 0000 004B // Input Capture Interrupt: Off
; 0000 004C // Compare A Match Interrupt: Off
; 0000 004D // Compare B Match Interrupt: Off
; 0000 004E TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 004F TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 0050 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 0051 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 0052 ICR1H=0x00;
	OUT  0x27,R30
; 0000 0053 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0054 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0055 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0056 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0057 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0058 
; 0000 0059 // Timer/Counter 2 initialization
; 0000 005A // Clock source: System Clock
; 0000 005B // Clock value: Timer2 Stopped
; 0000 005C // Mode: Normal top=0xFF
; 0000 005D // OC2 output: Disconnected
; 0000 005E ASSR=0x00;
	OUT  0x22,R30
; 0000 005F TCCR2=0x00;
	OUT  0x25,R30
; 0000 0060 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0061 OCR2=0x00;
	OUT  0x23,R30
; 0000 0062 
; 0000 0063 // External Interrupt(s) initialization
; 0000 0064 // INT0: Off
; 0000 0065 // INT1: Off
; 0000 0066 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0067 
; 0000 0068 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0069 TIMSK=0x00;
	OUT  0x39,R30
; 0000 006A 
; 0000 006B // USART initialization
; 0000 006C // USART disabled
; 0000 006D UCSRB=0x00;
	OUT  0xA,R30
; 0000 006E 
; 0000 006F // Analog Comparator initialization
; 0000 0070 // Analog Comparator: Off
; 0000 0071 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0072 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0073 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0074 
; 0000 0075 // ADC initialization
; 0000 0076 // ADC disabled
; 0000 0077 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 0078 
; 0000 0079 // SPI initialization
; 0000 007A // SPI disabled
; 0000 007B SPCR=0x00;
	OUT  0xD,R30
; 0000 007C 
; 0000 007D // TWI initialization
; 0000 007E // TWI disabled
; 0000 007F TWCR=0x00;
	OUT  0x36,R30
; 0000 0080 
; 0000 0081 // определить устройства (опросить датчики)
; 0000 0082 devices=w1_search(0xf0,rom_code);
	LDI  R30,LOW(240)
	ST   -Y,R30
	LDI  R26,LOW(_rom_code)
	LDI  R27,HIGH(_rom_code)
	RCALL _w1_search
	MOV  R10,R30
; 0000 0083 
; 0000 0084 
; 0000 0085 // Alphanumeric LCD initialization
; 0000 0086 // Connections are specified in the
; 0000 0087 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0088 // RS - PORTD Bit 0
; 0000 0089 // RD - PORTD Bit 1
; 0000 008A // EN - PORTD Bit 2
; 0000 008B // D4 - PORTD Bit 4
; 0000 008C // D5 - PORTD Bit 5
; 0000 008D // D6 - PORTD Bit 6
; 0000 008E // D7 - PORTD Bit 7
; 0000 008F // Characters/line: 8
; 0000 0090 lcd_init(16);
	LDI  R26,LOW(16)
	RCALL _lcd_init
; 0000 0091 
; 0000 0092 /* enable interrupts so that TWI can be used */
; 0000 0093 #asm("sei")
	sei
; 0000 0094 
; 0000 0095 
; 0000 0096 // бит 7 (CH) регистра секунд DS1307 останавливает или запускает генератор
; 0000 0097 // (0 - запущен, 1 - остановлен)
; 0000 0098 rtc_get_time(&hour, &minutes, &sec);
	RCALL SUBOPT_0x5
; 0000 0099 sec &= 0b01111111;                    // принудительна€ установка 7-го бита в "0"
	LDI  R30,LOW(127)
	AND  R7,R30
; 0000 009A rtc_set_time(hour, minutes, sec);
	ST   -Y,R5
	ST   -Y,R4
	MOV  R26,R7
	RCALL _rtc_set_time
; 0000 009B 
; 0000 009C 	if (rtc_read(63) != 0x55) { // €чейка с адресом 63 - "флаг новой микросхемы RTC"
	LDI  R26,LOW(63)
	RCALL _rtc_read
	CPI  R30,LOW(0x55)
	BREQ _0xE
; 0000 009D 		rtc_set_time(0x00, 0x00, 0x00); // установка стартовых значений
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _rtc_set_time
; 0000 009E 		rtc_set_date(0x12, 0x02, 0x11);
	LDI  R30,LOW(18)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R26,LOW(17)
	RCALL _rtc_set_date
; 0000 009F 	}
; 0000 00A0 
; 0000 00A1 
; 0000 00A2 
; 0000 00A3 lcd_putsf("Hello!!!");
_0xE:
	__POINTW2FN _0x0,0
	RCALL _lcd_putsf
; 0000 00A4 
; 0000 00A5 while (1)
_0xF:
; 0000 00A6       {
; 0000 00A7      /* read the time from the RTC */
; 0000 00A8       rtc_get_time(&hour,&minutes,&sec);
	RCALL SUBOPT_0x5
; 0000 00A9 
; 0000 00AA       /* read the date from the RTC */
; 0000 00AB       rtc_get_date(&day,&month,&year);
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	RCALL SUBOPT_0x6
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	RCALL SUBOPT_0x6
	LDI  R26,LOW(8)
	LDI  R27,HIGH(8)
	RCALL _rtc_get_date
; 0000 00AC 
; 0000 00AD       /* display the time on the LCD */
; 0000 00AE       sprintf(display_buffer,"Time: %2d:%02d:%02d\n",hour,minutes,sec);
	LDI  R30,LOW(_display_buffer)
	LDI  R31,HIGH(_display_buffer)
	RCALL SUBOPT_0x6
	__POINTW1FN _0x0,9
	RCALL SUBOPT_0x6
	MOV  R30,R5
	RCALL SUBOPT_0x7
	MOV  R30,R4
	RCALL SUBOPT_0x7
	MOV  R30,R7
	RCALL SUBOPT_0x7
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
; 0000 00AF       lcd_clear();
	RCALL _lcd_clear
; 0000 00B0       lcd_puts(display_buffer);
	LDI  R26,LOW(_display_buffer)
	LDI  R27,HIGH(_display_buffer)
	RCALL _lcd_puts
; 0000 00B1 
; 0000 00B2       /* display the date on the LCD */
; 0000 00B3       sprintf(display_buffer,"Date: %2d/%02d/%d",day,month,
; 0000 00B4               2000+year);
	LDI  R30,LOW(_display_buffer)
	LDI  R31,HIGH(_display_buffer)
	RCALL SUBOPT_0x6
	__POINTW1FN _0x0,30
	RCALL SUBOPT_0x6
	MOV  R30,R6
	RCALL SUBOPT_0x7
	MOV  R30,R9
	RCALL SUBOPT_0x7
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-2000)
	SBCI R31,HIGH(-2000)
	RCALL __CWD1
	RCALL __PUTPARD1
	LDI  R24,12
	RCALL _sprintf
	ADIW R28,16
; 0000 00B5       lcd_puts(display_buffer);
	LDI  R26,LOW(_display_buffer)
	LDI  R27,HIGH(_display_buffer)
	RCALL _lcd_puts
; 0000 00B6 
; 0000 00B7 
; 0000 00B8 
; 0000 00B9 
; 0000 00BA     lcd_gotoxy(8, 0);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _lcd_gotoxy
; 0000 00BB     lcd_puts(lcd_buffer);
	LDI  R26,LOW(_lcd_buffer)
	LDI  R27,HIGH(_lcd_buffer)
	RCALL _lcd_puts
; 0000 00BC 
; 0000 00BD       delay_ms(5000); /* 0.5 second delay */
	LDI  R26,LOW(5000)
	LDI  R27,HIGH(5000)
	RCALL _delay_ms
; 0000 00BE 
; 0000 00BF       }
	RJMP _0xF
; 0000 00C0 }
_0x12:
	RJMP _0x12

	.CSEG
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

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	ST   -Y,R26
	IN   R30,0x12
	ANDI R30,LOW(0xF)
	MOV  R26,R30
	LD   R30,Y
	ANDI R30,LOW(0xF0)
	OR   R30,R26
	OUT  0x12,R30
	__DELAY_USB 5
	SBI  0x12,2
	__DELAY_USB 13
	CBI  0x12,2
	__DELAY_USB 13
	RJMP _0x20A0002
__lcd_write_data:
	ST   -Y,R26
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R26,Y
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 133
	RJMP _0x20A0002
_lcd_gotoxy:
	ST   -Y,R26
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	RCALL __lcd_write_data
	LDD  R13,Y+1
	LDD  R12,Y+0
_0x20A0005:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x8
	LDI  R26,LOW(12)
	RCALL __lcd_write_data
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x8
	LDI  R30,LOW(0)
	MOV  R12,R30
	MOV  R13,R30
	RET
_lcd_putchar:
	ST   -Y,R26
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020005
	LDS  R30,__lcd_maxx
	CP   R13,R30
	BRLO _0x2020004
_0x2020005:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R12
	MOV  R26,R12
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020007
	RJMP _0x20A0002
_0x2020007:
_0x2020004:
	INC  R13
	SBI  0x12,0
	LD   R26,Y
	RCALL __lcd_write_data
	CBI  0x12,0
	RJMP _0x20A0002
_lcd_puts:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2020008:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	RJMP _0x20A0003
_lcd_putsf:
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x202000B:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000D
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x202000B
_0x202000D:
_0x20A0003:
	LDD  R17,Y+0
_0x20A0004:
	ADIW R28,3
	RET
_lcd_init:
	ST   -Y,R26
	IN   R30,0x11
	ORI  R30,LOW(0xF0)
	OUT  0x11,R30
	SBI  0x11,2
	SBI  0x11,0
	SBI  0x11,1
	CBI  0x12,2
	CBI  0x12,0
	CBI  0x12,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R26,LOW(20)
	LDI  R27,0
	RCALL _delay_ms
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	LDI  R26,LOW(32)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	LDI  R26,LOW(40)
	RCALL __lcd_write_data
	LDI  R26,LOW(4)
	RCALL __lcd_write_data
	LDI  R26,LOW(133)
	RCALL __lcd_write_data
	LDI  R26,LOW(6)
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20A0002:
	ADIW R28,1
	RET
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

	.CSEG
_put_buff_G102:
	ST   -Y,R27
	ST   -Y,R26
	RCALL __SAVELOCR2
	RCALL SUBOPT_0xA
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	RCALL SUBOPT_0xA
	ADIW R26,4
	RCALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	RCALL SUBOPT_0xA
	ADIW R26,2
	RCALL SUBOPT_0xB
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0xA
	RCALL __GETW1P
	TST  R31
	BRMI _0x2040014
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
_0x2040014:
_0x2040013:
	RJMP _0x2040015
_0x2040010:
	RCALL SUBOPT_0xA
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
__print_G102:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	ADIW R30,1
	STD  Y+16,R30
	STD  Y+16+1,R31
	RCALL SUBOPT_0xC
	BRNE PC+2
	RJMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R19,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	RCALL SUBOPT_0xD
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R19,37
	BRNE _0x2040020
	RCALL SUBOPT_0xD
	RJMP _0x20400AA
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R18,LOW(0)
	LDI  R16,LOW(0)
	CPI  R19,43
	BRNE _0x2040021
	LDI  R18,LOW(43)
	RJMP _0x204001B
_0x2040021:
	CPI  R19,32
	BRNE _0x2040022
	LDI  R18,LOW(32)
	RJMP _0x204001B
_0x2040022:
	RJMP _0x2040023
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040024
_0x2040023:
	CPI  R19,48
	BRNE _0x2040025
	ORI  R16,LOW(16)
	LDI  R17,LOW(5)
	RJMP _0x204001B
_0x2040025:
	RJMP _0x2040026
_0x2040024:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x204001B
_0x2040026:
	MOV  R30,R19
	CPI  R30,LOW(0x63)
	BRNE _0x204002B
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xE
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x10
	RJMP _0x204002C
_0x204002B:
	CPI  R30,LOW(0x73)
	BRNE _0x204002E
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
_0x204002F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2040031
	RCALL SUBOPT_0xD
	RJMP _0x204002F
_0x2040031:
	RJMP _0x204002C
_0x204002E:
	CPI  R30,LOW(0x70)
	BRNE _0x2040033
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
_0x2040034:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RCALL SUBOPT_0xC
	BREQ _0x2040036
	RCALL SUBOPT_0xD
	RJMP _0x2040034
_0x2040036:
	RJMP _0x204002C
_0x2040033:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(1)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	RJMP _0x20400AB
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(2)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2040052
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
_0x20400AB:
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBRS R16,0
	RJMP _0x2040042
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x13
	TST  R21
	BRPL _0x2040043
	MOVW R30,R20
	RCALL __ANEGW1
	MOVW R20,R30
	LDI  R18,LOW(45)
_0x2040043:
	CPI  R18,0
	BREQ _0x2040044
	ST   -Y,R18
	RCALL SUBOPT_0x10
_0x2040044:
	RJMP _0x2040045
_0x2040042:
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x13
_0x2040045:
_0x2040047:
	LDI  R19,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2040049:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	CP   R20,R30
	CPC  R21,R31
	BRLO _0x204004B
	SUBI R19,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	__SUBWRR 20,21,26,27
	RJMP _0x2040049
_0x204004B:
	SBRC R16,4
	RJMP _0x204004D
	CPI  R19,49
	BRSH _0x204004D
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x204004C
_0x204004D:
	ORI  R16,LOW(16)
	CPI  R19,58
	BRLO _0x204004F
	SBRS R16,1
	RJMP _0x2040050
	SUBI R19,-LOW(7)
	RJMP _0x2040051
_0x2040050:
	SUBI R19,-LOW(39)
_0x2040051:
_0x204004F:
	RCALL SUBOPT_0xD
_0x204004C:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRSH _0x2040047
_0x2040052:
_0x204002C:
_0x20400AA:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,18
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x14
	SBIW R30,0
	BRNE _0x2040053
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0001
_0x2040053:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x14
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x6
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	RCALL SUBOPT_0x6
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0001:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG

	.CSEG

	.DSEG
___ds18x20_scratch_pad:
	.BYTE 0x9
_lcd_buffer:
	.BYTE 0x8
_display_buffer:
	.BYTE 0x11
_rom_code:
	.BYTE 0x24
__base_y_G101:
	.BYTE 0x4
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	RCALL _twi_start
	LDI  R26,LOW(208)
	RJMP _twi_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	RCALL _twi_write
	LDD  R26,Y+1
	RJMP _twi_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	ST   -Y,R27
	ST   -Y,R26
	RCALL _twi_start
	LDI  R26,LOW(208)
	RJMP _twi_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	RCALL _twi_write
	RCALL _twi_start
	LDI  R26,LOW(209)
	RCALL _twi_write
	LDI  R26,LOW(1)
	RJMP _twi_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	ST   X,R30
	LDI  R26,LOW(1)
	RCALL _twi_read
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
	LDI  R26,LOW(0)
	RJMP _twi_read

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	RJMP _rtc_get_time

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x7:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	RCALL __lcd_write_data
	LDI  R26,LOW(3)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(48)
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 200
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	SBIW R30,1
	LPM  R30,Z
	MOV  R19,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xD:
	ST   -Y,R19
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	SBIW R30,4
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDD  R26,Y+11
	LDD  R27,Y+11+1
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	RCALL SUBOPT_0xE
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	ADIW R26,4
	LD   R20,X+
	LD   R21,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

	.equ __w1_port=0x15
	.equ __w1_bit=0x00

_w1_init:
	clr  r30
	cbi  __w1_port,__w1_bit
	sbi  __w1_port-1,__w1_bit
	__DELAY_USW 0x3C0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x25
	sbis __w1_port-2,__w1_bit
	ret
	__DELAY_USB 0xCB
	sbis __w1_port-2,__w1_bit
	ldi  r30,1
	__DELAY_USW 0x30C
	ret

__w1_read_bit:
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x1D
	clc
	sbic __w1_port-2,__w1_bit
	sec
	ror  r30
	__DELAY_USB 0xD5
	ret

__w1_write_bit:
	clt
	sbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x5
	sbrc r23,0
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0x23
	sbic __w1_port-2,__w1_bit
	rjmp __w1_write_bit0
	sbrs r23,0
	rjmp __w1_write_bit1
	ret
__w1_write_bit0:
	sbrs r23,0
	ret
__w1_write_bit1:
	__DELAY_USB 0xC8
	cbi  __w1_port-1,__w1_bit
	__DELAY_USB 0xD
	set
	ret

_w1_write:
	mov  r23,r26
	ldi  r22,8
	clr  r30
__w1_write0:
	rcall __w1_write_bit
	brtc __w1_write1
	ror  r23
	dec  r22
	brne __w1_write0
	inc  r30
__w1_write1:
	ret

_w1_search:
	push r20
	push r21
	clr  r1
	clr  r20
__w1_search0:
	mov  r0,r1
	clr  r1
	rcall _w1_init
	tst  r30
	breq __w1_search7
	push r26
	ld   r26,y
	rcall _w1_write
	pop  r26
	ldi  r21,1
__w1_search1:
	cp   r21,r0
	brsh __w1_search6
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search2
	rcall __w1_read_bit
	sbrc r30,7
	rjmp __w1_search3
	rcall __sel_bit
	and  r24,r25
	brne __w1_search3
	mov  r1,r21
	rjmp __w1_search3
__w1_search2:
	rcall __w1_read_bit
__w1_search3:
	rcall __sel_bit
	and  r24,r25
	ldi  r23,0
	breq __w1_search5
__w1_search4:
	ldi  r23,1
__w1_search5:
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search6:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search9
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search8
__w1_search7:
	mov  r30,r20
	pop  r21
	pop  r20
	adiw r28,1
	ret
__w1_search8:
	set
	rcall __set_bit
	rjmp __w1_search4
__w1_search9:
	rcall __w1_read_bit
	sbrs r30,7
	rjmp __w1_search10
	rjmp __w1_search11
__w1_search10:
	cp   r21,r0
	breq __w1_search12
	mov  r1,r21
__w1_search11:
	clt
	rcall __set_bit
	clr  r23
	rcall __w1_write_bit
	rjmp __w1_search13
__w1_search12:
	set
	rcall __set_bit
	ldi  r23,1
	rcall __w1_write_bit
__w1_search13:
	inc  r21
	cpi  r21,65
	brlt __w1_search1
	rcall __w1_read_bit
	rol  r30
	rol  r30
	andi r30,1
	adiw r26,8
	st   x,r30
	sbiw r26,8
	inc  r20
	tst  r1
	breq __w1_search7
	ldi  r21,9
__w1_search14:
	ld   r30,x
	adiw r26,9
	st   x,r30
	sbiw r26,8
	dec  r21
	brne __w1_search14
	rjmp __w1_search0

__sel_bit:
	mov  r30,r21
	dec  r30
	mov  r22,r30
	lsr  r30
	lsr  r30
	lsr  r30
	clr  r31
	add  r30,r26
	adc  r31,r27
	ld   r24,z
	ldi  r25,1
	andi r22,7
__sel_bit0:
	breq __sel_bit1
	lsl  r25
	dec  r22
	rjmp __sel_bit0
__sel_bit1:
	ret

__set_bit:
	rcall __sel_bit
	brts __set_bit2
	com  r25
	and  r24,r25
	rjmp __set_bit3
__set_bit2:
	or   r24,r25
__set_bit3:
	st   z,r24
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
