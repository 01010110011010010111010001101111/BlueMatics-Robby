
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 16,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: Yes
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

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
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	.DEF _wheelEncoderCounter_left=R4
	.DEF _wheelEncoderCounter_right=R6
	.DEF _i=R9
	.DEF _l=R8
	.DEF _iRisingEdge=R10
	.DEF _iFallingEdge=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _ext_int4_isr
	JMP  0x00
	JMP  _ext_int6_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _adc_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_capt_isr
	JMP  _timer3_compa_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x002A

_0x4:
	.DB  0x5E,0x1
_0x5:
	.DB  0xA0,0xF
_0x26:
	.DB  0xA
_0xAD:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x50,0x4F,0x53,0x49,0x54,0x49,0x4F,0x4E
	.DB  0x2D,0x53,0x45,0x52,0x56,0x4F,0x0,0x49
	.DB  0x52,0x2D,0x44,0x41,0x54,0x41,0x0,0x4C
	.DB  0x45,0x46,0x54,0x3A,0x20,0x31,0x0,0x4C
	.DB  0x45,0x46,0x54,0x3A,0x20,0x30,0x0,0x20
	.DB  0x52,0x49,0x47,0x48,0x54,0x3A,0x20,0x31
	.DB  0x0,0x20,0x52,0x49,0x47,0x48,0x54,0x3A
	.DB  0x20,0x30,0x0,0x4D,0x4C,0x45,0x46,0x54
	.DB  0x3A,0x20,0x31,0x0,0x4D,0x4C,0x45,0x46
	.DB  0x54,0x3A,0x20,0x30,0x0,0x4D,0x52,0x49
	.DB  0x47,0x48,0x54,0x3A,0x31,0x0,0x4D,0x52
	.DB  0x49,0x47,0x48,0x54,0x3A,0x30,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x45,0x4E,0x43,0x4F
	.DB  0x44,0x45,0x52,0x20,0x20,0x3E,0x3E,0x0
	.DB  0x3C,0x3C,0x20,0x20,0x20,0x45,0x4E,0x43
	.DB  0x4F,0x44,0x45,0x52,0x20,0x20,0x20,0x20
	.DB  0x0,0x4C,0x3A,0x0,0x20,0x52,0x3A,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x52,0x45,0x43
	.DB  0x48,0x54,0x53,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x4C,0x49,0x4E
	.DB  0x4B,0x53,0x20,0x20,0x20,0x20,0x0,0x46
	.DB  0x4C,0x45,0x46,0x54,0x3A,0x20,0x31,0x0
	.DB  0x46,0x4C,0x45,0x46,0x54,0x3A,0x20,0x30
	.DB  0x0,0x46,0x52,0x49,0x47,0x48,0x54,0x3A
	.DB  0x31,0x0,0x46,0x52,0x49,0x47,0x48,0x54
	.DB  0x3A,0x30,0x0,0x4C,0x45,0x46,0x54,0x3A
	.DB  0x0,0x52,0x49,0x47,0x48,0x54,0x3A,0x0
	.DB  0x4E,0x6F,0x20,0x4F,0x62,0x6A,0x65,0x63
	.DB  0x74,0x21,0x0,0x4F,0x62,0x6A,0x65,0x6B
	.DB  0x74,0x20,0x67,0x65,0x66,0x75,0x6E,0x64
	.DB  0x65,0x6E,0x0,0x4B,0x65,0x69,0x6E,0x20
	.DB  0x4F,0x62,0x6A,0x65,0x63,0x74,0x0,0x4E
	.DB  0x49,0x43,0x48,0x54,0x20,0x56,0x45,0x52
	.DB  0x46,0x55,0x45,0x47,0x42,0x41,0x52,0x0
	.DB  0x4C,0x49,0x4E,0x49,0x45,0x4E,0x20,0x53
	.DB  0x45,0x4E,0x53,0x4F,0x52,0x0,0x4D,0x4F
	.DB  0x54,0x4F,0x52,0x45,0x4E,0x0,0x4C,0x45
	.DB  0x4E,0x4B,0x55,0x4E,0x47,0x0,0x44,0x49
	.DB  0x53,0x54,0x41,0x4E,0x5A,0x20,0x53,0x45
	.DB  0x4E,0x53,0x4F,0x52,0x0,0x4C,0x49,0x43
	.DB  0x48,0x54,0x20,0x53,0x45,0x4E,0x53,0x4F
	.DB  0x52,0x0,0x57,0x49,0x49,0x20,0x43,0x41
	.DB  0x4D,0x0,0x49,0x52,0x20,0x54,0x4F,0x57
	.DB  0x45,0x52,0x0,0x55,0x4C,0x54,0x52,0x41
	.DB  0x53,0x43,0x48,0x41,0x4C,0x4C,0x0,0x45
	.DB  0x53,0x50,0x20,0x54,0x45,0x53,0x54,0x0
	.DB  0x54,0x45,0x53,0x54,0x20,0x2D,0x20,0x50
	.DB  0x52,0x4F,0x47,0x52,0x41,0x4D,0x4D,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  _arServos
	.DW  _0x4*2

	.DW  0x02
	.DW  _Pause
	.DW  _0x5*2

	.DW  0x0F
	.DW  _0x6
	.DW  _0x0*2

	.DW  0x01
	.DW  _state
	.DW  _0x26*2

	.DW  0x08
	.DW  _0x29
	.DW  _0x0*2+15

	.DW  0x08
	.DW  _0x2B
	.DW  _0x0*2+23

	.DW  0x08
	.DW  _0x2B+8
	.DW  _0x0*2+31

	.DW  0x0A
	.DW  _0x2B+16
	.DW  _0x0*2+39

	.DW  0x0A
	.DW  _0x2B+26
	.DW  _0x0*2+49

	.DW  0x09
	.DW  _0x2B+36
	.DW  _0x0*2+59

	.DW  0x09
	.DW  _0x2B+45
	.DW  _0x0*2+68

	.DW  0x09
	.DW  _0x2B+54
	.DW  _0x0*2+77

	.DW  0x09
	.DW  _0x2B+63
	.DW  _0x0*2+86

	.DW  0x11
	.DW  _0x38
	.DW  _0x0*2+95

	.DW  0x11
	.DW  _0x38+17
	.DW  _0x0*2+112

	.DW  0x03
	.DW  _0x38+34
	.DW  _0x0*2+129

	.DW  0x04
	.DW  _0x38+37
	.DW  _0x0*2+132

	.DW  0x10
	.DW  _0x48
	.DW  _0x0*2+136

	.DW  0x0F
	.DW  _0x48+16
	.DW  _0x0*2+152

	.DW  0x03
	.DW  _0x48+31
	.DW  _0x0*2+129

	.DW  0x04
	.DW  _0x48+34
	.DW  _0x0*2+132

	.DW  0x08
	.DW  _0x54
	.DW  _0x0*2+23

	.DW  0x08
	.DW  _0x54+8
	.DW  _0x0*2+31

	.DW  0x0A
	.DW  _0x54+16
	.DW  _0x0*2+39

	.DW  0x0A
	.DW  _0x54+26
	.DW  _0x0*2+49

	.DW  0x09
	.DW  _0x54+36
	.DW  _0x0*2+167

	.DW  0x09
	.DW  _0x54+45
	.DW  _0x0*2+176

	.DW  0x09
	.DW  _0x54+54
	.DW  _0x0*2+185

	.DW  0x09
	.DW  _0x54+63
	.DW  _0x0*2+194

	.DW  0x06
	.DW  _0x5C
	.DW  _0x0*2+203

	.DW  0x07
	.DW  _0x5C+6
	.DW  _0x0*2+209

	.DW  0x10
	.DW  _0x73
	.DW  _0x0*2+227

	.DW  0x11
	.DW  _0x75
	.DW  _0x0*2+255

	.DW  0x0E
	.DW  _0x7F
	.DW  _0x0*2+272

	.DW  0x08
	.DW  _0x7F+14
	.DW  _0x0*2+286

	.DW  0x08
	.DW  _0x7F+22
	.DW  _0x0*2+294

	.DW  0x0F
	.DW  _0x7F+30
	.DW  _0x0*2+302

	.DW  0x0D
	.DW  _0x7F+45
	.DW  _0x0*2+317

	.DW  0x08
	.DW  _0x7F+58
	.DW  _0x0*2+330

	.DW  0x09
	.DW  _0x7F+66
	.DW  _0x0*2+338

	.DW  0x06
	.DW  _0x7F+75
	.DW  _0x0*2+9

	.DW  0x0C
	.DW  _0x7F+81
	.DW  _0x0*2+347

	.DW  0x09
	.DW  _0x7F+93
	.DW  _0x0*2+359

	.DW  0x10
	.DW  _0x7F+102
	.DW  _0x0*2+368

	.DW  0x06
	.DW  0x04
	.DW  _0xAD*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

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
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.17 UL Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : BlueMatics
;Version : 0.0.1
;Date    : 16.11.2017
;Author  : Viktor Lau
;Company :
;Comments:
;
;
;Chip type               : ATmega128
;Program type            : Application
;AVR Core Clock frequency: 16,000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*******************************************************/
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdlib.h>
;#include "modules/port_init.h"

	.CSEG
_adc_isr:
	ST   -Y,R24
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDS  R30,_input_index_S0000000000
	LDI  R26,LOW(_adc_data)
	LDI  R27,HIGH(_adc_data)
	CALL SUBOPT_0x0
	ADD  R26,R30
	ADC  R27,R31
	IN   R30,0x4
	IN   R31,0x4+1
	ST   X+,R30
	ST   X,R31
	LDS  R26,_input_index_S0000000000
	SUBI R26,-LOW(1)
	STS  _input_index_S0000000000,R26
	CPI  R26,LOW(0x6)
	BRLO _0x3
	LDI  R30,LOW(0)
	STS  _input_index_S0000000000,R30
_0x3:
	LDS  R30,_input_index_S0000000000
	SUBI R30,-LOW(64)
	OUT  0x7,R30
	__DELAY_USB 53
	SBI  0x6,6
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R24,Y+
	RETI
_ext_int4_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RJMP _0xAC
_ext_int6_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
_0xAC:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
   .equ __lcd_port=0x15 ;PORTC
_port_init:
	LDI  R30,LOW(138)
	OUT  0x1A,R30
	LDI  R30,LOW(2)
	OUT  0x17,R30
	LDI  R30,LOW(161)
	OUT  0x11,R30
	LDI  R30,LOW(32)
	OUT  0x2,R30
	STS  97,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
	LDI  R30,LOW(64)
	OUT  0x7,R30
	LDI  R30,LOW(207)
	OUT  0x6,R30
	LDI  R30,LOW(0)
	OUT  0x20,R30
	LDI  R30,LOW(128)
	OUT  0x8,R30
	LDI  R30,LOW(0)
	STS  106,R30
	LDI  R30,LOW(17)
	OUT  0x3A,R30
	LDI  R30,LOW(80)
	OUT  0x39,R30
	LDI  R30,LOW(0)
	OUT  0x38,R30
	OUT  0x30,R30
	LDI  R30,LOW(6)
	OUT  0x33,R30
	LDI  R30,LOW(131)
	OUT  0x32,R30
	LDI  R30,LOW(0)
	OUT  0x31,R30
	OUT  0x2F,R30
	LDI  R30,LOW(11)
	OUT  0x2E,R30
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	OUT  0x27,R30
	OUT  0x26,R30
	OUT  0x2B,R30
	OUT  0x2A,R30
	OUT  0x29,R30
	OUT  0x28,R30
	STS  121,R30
	STS  120,R30
	STS  139,R30
	LDI  R30,LOW(203)
	STS  138,R30
	LDI  R30,LOW(0)
	STS  137,R30
	STS  136,R30
	STS  129,R30
	STS  128,R30
	LDI  R30,LOW(97)
	STS  135,R30
	LDI  R30,LOW(168)
	STS  134,R30
	LDI  R30,LOW(0)
	STS  133,R30
	STS  132,R30
	STS  131,R30
	STS  130,R30
	LDI  R30,LOW(17)
	OUT  0x37,R30
	LDI  R30,LOW(48)
	STS  125,R30
	sei
	RET
;
;#include <io.h>
;#include <stdio.h>
;//#include <twi.h>
;#include <i2c.h>
;#include <string.h>
;#include <stdint.h>
;
;
;
;
;
;
;#define puts lcd_puts
;
;
;/**
; *  States
; */
;
;#define state_linedetector  0
;#define state_engine  1
;#define state_engine_dir  2
;#define state_distance_sensor  3
;#define state_lightsensor  4
;#define state_wiicam  5
;#define state_irtower  6
;#define state_servo  7
;#define state_ultrasonic  8
;#define state_esp  9
;#define state_stop 10
;
;
;/*
;* Servo
;*/
;
;
;#define MAX_SERVOS 1
;#define LEFT MIDDLE-220
;#define MIDDLE 350
;#define RIGHT MIDDLE+220
;#define PERIOD 4000
;
;
;
;/*
;*IR RECEIVER
;*/
;#define RC5TIME 	1.778e-3		// 1.778msec
;#define	XTAL		16.0E6
;#define PULSE_MIN	(unsigned char)(XTAL / 512 * RC5TIME * 0.2 + 0.5)
;#define PULSE_1_2	(unsigned char)(XTAL / 512 * RC5TIME * 0.8 + 0.5)
;#define PULSE_MAX	(unsigned char)(XTAL / 512 * RC5TIME * 1.2 + 0.5)
;
;
;/*
;*ULTRASONIC
;*/
;// Declare your global variables here
;char str[17];
;unsigned int iRisingEdge, iFallingEdge;
;unsigned int iTime;
;    bit bChange2=0;
;
;/* union declaration */
;union alpha
;{
;  unsigned char byte[2];
;  unsigned int  word;
;} icr3;
;
;
;
;
;
;// Globale Variablen
;signed char arTrim[MAX_SERVOS] = {0};
;unsigned int arServos[MAX_SERVOS] = {MIDDLE};

	.DSEG
;unsigned int Pause = PERIOD;
;int ucServoNr = 0;
;int ucNr = 0;
;
;char strTemp[17] = "";
;bit bChange = 1;
;bit bPause = 0;
;bit bMerk=1;
;bit inSERVOTEST=0;
;
;
;//IR RECEIVER
;bit	          rc5_bit=1;			// bit value
;unsigned char rc5_time=0;			// count bit time
;unsigned int  rc5_data=0;			// store result
;unsigned int  tmp;
;
;unsigned char ucToggle;
;unsigned char ucAdress;
;unsigned char ucData;
;
;char s[17];
;
;
;//WIICAM
;#define slaveadress 0xB0
;#define slaveread 0xB1
;unsigned int data[16];
;void write2Byte(char, char);
;void readData(void);
;void convertdata(void);
;void wii_cam_init(void);
;
;unsigned char Wert[5];  //Feld für Wertkonvertierung LCD
;unsigned int x[4]; 	//X,Y-Koordinaten der Objekte
;unsigned int y[4];	//X: 0..1023, Y: 0..767
;unsigned char sWIICAM[4];     //S: 0..15 (Objektgröße im extended Mode)
;unsigned int temp;
;
;
;
;
;
;void fnSetServo(unsigned char ucNr, unsigned char ucValue)
; 0000 0097 {

	.CSEG
; 0000 0098   arServos[ucNr] = ucValue;
;	ucNr -> Y+1
;	ucValue -> Y+0
; 0000 0099 }
;
;
;void fnDisplay(void )
; 0000 009D {
_fnDisplay:
; 0000 009E  char str[10];
; 0000 009F   lcd_clear();
	SBIW R28,10
;	str -> Y+0
	CALL _lcd_clear
; 0000 00A0   lcd_puts("POSITION-SERVO");
	__POINTW1MN _0x6,0
	CALL SUBOPT_0x1
; 0000 00A1   lcd_gotoxy(0, 1);
	CALL SUBOPT_0x2
; 0000 00A2   itoa(arServos[ucNr]-MIDDLE, strTemp);
	CALL SUBOPT_0x3
	SUBI R30,LOW(350)
	SBCI R31,HIGH(350)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_strTemp)
	LDI  R31,HIGH(_strTemp)
	CALL SUBOPT_0x4
; 0000 00A3   lcd_puts(strTemp);
	LDI  R30,LOW(_strTemp)
	LDI  R31,HIGH(_strTemp)
	CALL SUBOPT_0x1
; 0000 00A4 }
	RJMP _0x20C0006

	.DSEG
_0x6:
	.BYTE 0xF
;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00A9 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00AA   // Reinitialize Timer 0 value
; 0000 00AB 
; 0000 00AC   //SERVO
; 0000 00AD   TCNT0=131;
	LDI  R30,LOW(131)
	OUT  0x32,R30
; 0000 00AE 
; 0000 00AF   if(!BUMPER_RIGHT&&inSERVOTEST==1){
	SBIC 0x19,6
	RJMP _0x8
	SBRC R2,4
	RJMP _0x9
_0x8:
	RJMP _0x7
_0x9:
; 0000 00B0   if((arServos[ucNr] <= 570)&&(arServos[ucNr] >=119)){
	CALL SUBOPT_0x3
	CPI  R30,LOW(0x23B)
	LDI  R26,HIGH(0x23B)
	CPC  R31,R26
	BRSH _0xB
	CPI  R30,LOW(0x77)
	LDI  R26,HIGH(0x77)
	CPC  R31,R26
	BRSH _0xC
_0xB:
	RJMP _0xA
_0xC:
; 0000 00B1     delay_ms(250);
	CALL SUBOPT_0x5
; 0000 00B2     arServos[ucNr] += 10;
	ADIW R30,10
	RJMP _0xA2
; 0000 00B3     bChange = 1;
; 0000 00B4    }else {
_0xA:
; 0000 00B5 
; 0000 00B6     delay_ms(250);
	CALL SUBOPT_0x5
; 0000 00B7     arServos[ucNr] -= 450;
	SUBI R30,LOW(450)
	SBCI R31,HIGH(450)
_0xA2:
	ST   -X,R31
	ST   -X,R30
; 0000 00B8     bChange = 1;
	SET
	BLD  R2,1
; 0000 00B9 
; 0000 00BA 
; 0000 00BB      }
; 0000 00BC   }
; 0000 00BD 
; 0000 00BE 
; 0000 00BF   //IR RECIVER
; 0000 00C0   TCNT0 = 254;					                // 2 * 256 = 512 cycle
_0x7:
	LDI  R30,LOW(254)
	OUT  0x32,R30
; 0000 00C1   if( ++rc5_time > PULSE_MAX )                  // count pulse time
	LDS  R26,_rc5_time
	SUBI R26,-LOW(1)
	STS  _rc5_time,R26
	CPI  R26,LOW(0x44)
	BRLO _0xE
; 0000 00C2   {
; 0000 00C3     if( !(tmp & 0x4000) && (tmp & 0x2000) )	    // only if 14 bits received
	__GETB1MN _tmp,1
	ANDI R30,LOW(0x40)
	BRNE _0x10
	__GETB1MN _tmp,1
	ANDI R30,LOW(0x20)
	BRNE _0x11
_0x10:
	RJMP _0xF
_0x11:
; 0000 00C4       rc5_data = tmp;
	CALL SUBOPT_0x6
	STS  _rc5_data,R30
	STS  _rc5_data+1,R31
; 0000 00C5       tmp = 0;
_0xF:
	LDI  R30,LOW(0)
	STS  _tmp,R30
	STS  _tmp+1,R30
; 0000 00C6   }
; 0000 00C7   if (rc5_bit != REMOTE_CONTROL)                       // change detect
_0xE:
	LDI  R26,0
	SBRC R2,5
	LDI  R26,1
	LDI  R30,0
	SBIC 0x19,2
	LDI  R30,1
	LDI  R27,0
	LDI  R31,0
	SBRC R30,7
	SER  R31
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x12
; 0000 00C8   {
; 0000 00C9       rc5_bit = !rc5_bit;	                    // 0x00 -> 0xFF -> 0x00
	LDI  R30,LOW(32)
	EOR  R2,R30
; 0000 00CA       if( rc5_time < PULSE_MIN )			    // too short
	LDS  R26,_rc5_time
	CPI  R26,LOW(0xB)
	BRSH _0x13
; 0000 00CB       tmp = 0;
	LDI  R30,LOW(0)
	STS  _tmp,R30
	STS  _tmp+1,R30
; 0000 00CC     if( !tmp || rc5_time > PULSE_1_2 )          // start or long pulse time
_0x13:
	CALL SUBOPT_0x6
	SBIW R30,0
	BREQ _0x15
	LDS  R26,_rc5_time
	CPI  R26,LOW(0x2D)
	BRLO _0x14
_0x15:
; 0000 00CD     {
; 0000 00CE       if( !(tmp & 0x4000) )			            // not to many bits
	__GETB1MN _tmp,1
	ANDI R30,LOW(0x40)
	BRNE _0x17
; 0000 00CF       tmp = tmp << 1;				            // shift
	CALL SUBOPT_0x6
	LSL  R30
	ROL  R31
	STS  _tmp,R30
	STS  _tmp+1,R31
; 0000 00D0       if(!rc5_bit)		                        // inverted bit
_0x17:
	SBRC R2,5
	RJMP _0x18
; 0000 00D1       tmp = tmp | 1;				            // insert new bit
	CALL SUBOPT_0x6
	ORI  R30,1
	STS  _tmp,R30
	STS  _tmp+1,R31
; 0000 00D2       rc5_time = 0;				                // count next pulse time
_0x18:
	LDI  R30,LOW(0)
	STS  _rc5_time,R30
; 0000 00D3     }
; 0000 00D4   }
_0x14:
; 0000 00D5 
; 0000 00D6  }
_0x12:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;
;// Timer1 output compare A interrupt service routine
;interrupt [TIM1_COMPA] void timer1_compa_isr(void)
; 0000 00DC {
_timer1_compa_isr:
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00DD 
; 0000 00DE //SERVO
; 0000 00DF   if (!bPause)
	SBRC R2,2
	RJMP _0x19
; 0000 00E0   {
; 0000 00E1     OCR1A = arServos[ucServoNr]+arTrim[ucServoNr];
	LDS  R30,_ucServoNr
	LDS  R31,_ucServoNr+1
	LDI  R26,LOW(_arServos)
	LDI  R27,HIGH(_arServos)
	LSL  R30
	ROL  R31
	CALL SUBOPT_0x7
	MOVW R26,R30
	LDS  R30,_ucServoNr
	LDS  R31,_ucServoNr+1
	SUBI R30,LOW(-_arTrim)
	SBCI R31,HIGH(-_arTrim)
	LD   R30,Z
	LDI  R31,0
	SBRC R30,7
	SER  R31
	ADD  R30,R26
	ADC  R31,R27
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00E2     SERVO = (1<<ucServoNr);
	LDS  R30,_ucServoNr
	LDI  R26,LOW(1)
	CALL __LSLB12
	CPI  R30,0
	BRNE _0x1A
	CBI  0x12,7
	RJMP _0x1B
_0x1A:
	SBI  0x12,7
_0x1B:
; 0000 00E3     Pause -= OCR1A;
	IN   R30,0x2A
	IN   R31,0x2A+1
	LDS  R26,_Pause
	LDS  R27,_Pause+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _Pause,R26
	STS  _Pause+1,R27
; 0000 00E4     if (++ucServoNr>=MAX_SERVOS)
	LDI  R26,LOW(_ucServoNr)
	LDI  R27,HIGH(_ucServoNr)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	BRLT _0x1C
; 0000 00E5     {
; 0000 00E6       ucServoNr = 0;
	LDI  R30,LOW(0)
	STS  _ucServoNr,R30
	STS  _ucServoNr+1,R30
; 0000 00E7       bPause = 1;
	SET
	BLD  R2,2
; 0000 00E8     }
; 0000 00E9   }
_0x1C:
; 0000 00EA   else
	RJMP _0x1D
_0x19:
; 0000 00EB   {
; 0000 00EC     OCR1A = Pause;
	LDS  R30,_Pause
	LDS  R31,_Pause+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00ED     SERVO = 0;
	CBI  0x12,7
; 0000 00EE     bPause = 0;
	CLT
	BLD  R2,2
; 0000 00EF     Pause = PERIOD;
	LDI  R30,LOW(4000)
	LDI  R31,HIGH(4000)
	STS  _Pause,R30
	STS  _Pause+1,R31
; 0000 00F0   }
_0x1D:
; 0000 00F1 
; 0000 00F2 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
;
;
;
;
;// Timer3 input capture interrupt service routine
;interrupt [TIM3_CAPT] void timer3_capt_isr(void)
; 0000 00F9 {
_timer3_capt_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00FA   icr3.byte[0] = ICR3L;
	LDS  R30,128
	STS  _icr3,R30
; 0000 00FB   icr3.byte[1] = ICR3H;
	LDS  R30,129
	__PUTB1MN _icr3,1
; 0000 00FC   if (ECHO)
	SBIS 0x1,7
	RJMP _0x20
; 0000 00FD   {
; 0000 00FE     // Rising Edge of ECHO
; 0000 00FF     iRisingEdge = icr3.word;
	__GETWRMN 10,11,0,_icr3
; 0000 0100     // Capture next Input on falling edge
; 0000 0101     TCCR3B &= ~(1<<ICES3);
	LDS  R30,138
	ANDI R30,0xBF
	STS  138,R30
; 0000 0102   }
; 0000 0103   else
	RJMP _0x21
_0x20:
; 0000 0104   {
; 0000 0105     // Faling Edge of ECHO
; 0000 0106     iFallingEdge = icr3.word;
	__GETWRMN 12,13,0,_icr3
; 0000 0107      // Capture next Input on rising edge
; 0000 0108     TCCR3B |= (1<<ICES3);
	LDS  R30,138
	ORI  R30,0x40
	STS  138,R30
; 0000 0109     // Calculate length of ECHO (time per count is 4 us)
; 0000 010A     iTime = (iFallingEdge-iRisingEdge)*4;
	MOVW R26,R12
	SUB  R26,R10
	SBC  R27,R11
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL __MULW12U
	STS  _iTime,R30
	STS  _iTime+1,R31
; 0000 010B     bChange2 = 1;
	SET
	BLD  R2,0
; 0000 010C   }
_0x21:
; 0000 010D }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;// Timer3 output compare A interrupt service routine
;interrupt [TIM3_COMPA] void timer3_compa_isr(void)
; 0000 0112 {
_timer3_compa_isr:
	ST   -Y,R24
	ST   -Y,R30
	IN   R30,SREG
; 0000 0113   // Trigger is fired every 100 ms
; 0000 0114   TRIGGER = 1;
	SBI  0x18,1
; 0000 0115   delay_us(10);
	__DELAY_USB 53
; 0000 0116   TRIGGER = 0;
	CBI  0x18,1
; 0000 0117 }
	OUT  SREG,R30
	LD   R30,Y+
	LD   R24,Y+
	RETI
;
;
;
;
;
;
;int state = state_stop;

	.DSEG
;int state_info = 0;
;
;int engine_dir = 0;
;
;
;  int leftCounter = 0;
;  int rightCounter = 0;
;  int leftEnc = 0;
;  int rightEnc = 0;
;
;
;
;
;int rc5_receive(unsigned char *ucToggle, unsigned char *ucAdress, unsigned char *ucData)
; 0000 012D {

	.CSEG
_rc5_receive:
; 0000 012E   unsigned int i;
; 0000 012F 
; 0000 0130   #asm("cli")
	ST   -Y,R17
	ST   -Y,R16
;	*ucToggle -> Y+6
;	*ucAdress -> Y+4
;	*ucData -> Y+2
;	i -> R16,R17
	cli
; 0000 0131   i = rc5_data;			                    // read two bytes from interrupt !
	__GETWRMN 16,17,0,_rc5_data
; 0000 0132   rc5_data = 0;
	LDI  R30,LOW(0)
	STS  _rc5_data,R30
	STS  _rc5_data+1,R30
; 0000 0133   #asm("sei")
	sei
; 0000 0134   if( i )
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x27
; 0000 0135   {
; 0000 0136     *ucToggle = i >> 11 & 1;
	MOVW R26,R16
	LDI  R30,LOW(11)
	CALL __LSRW12
	ANDI R30,LOW(0x1)
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
; 0000 0137     *ucAdress = i >> 6 & 0x1F;
	MOVW R26,R16
	LDI  R30,LOW(6)
	CALL __LSRW12
	ANDI R30,LOW(0x1F)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
; 0000 0138     *ucData = (i & 0x3F) | (~i >> 7 & 0x40);
	MOV  R30,R16
	ANDI R30,LOW(0x3F)
	MOV  R26,R30
	MOVW R30,R16
	COM  R30
	COM  R31
	CALL __LSRW3
	CALL __LSRW4
	ANDI R30,LOW(0x40)
	OR   R30,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ST   X,R30
; 0000 0139     return i;
	MOVW R30,R16
	RJMP _0x20C0007
; 0000 013A   }
; 0000 013B   else
_0x27:
; 0000 013C     return 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
; 0000 013D }
_0x20C0007:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
;
;
;
;
;void rc5_display(void)
; 0000 0143 {
_rc5_display:
; 0000 0144   lcd_clear();
	CALL _lcd_clear
; 0000 0145   puts("IR-DATA");
	__POINTW1MN _0x29,0
	CALL SUBOPT_0x1
; 0000 0146   lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0147   lcd_putchar('0'+ucToggle);	            // Toggle Bit
	LDS  R30,_ucToggle
	SUBI R30,-LOW(48)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0148   lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0149   itoa(ucAdress , s);	                    // Device address
	LDS  R30,_ucAdress
	CALL SUBOPT_0x8
; 0000 014A   lcd_puts(s);
	LDI  R30,LOW(_s)
	LDI  R31,HIGH(_s)
	CALL SUBOPT_0x1
; 0000 014B   lcd_putchar(' ');
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 014C   itoa(ucData, s);                          // Key Code
	LDS  R30,_ucData
	CALL SUBOPT_0x8
; 0000 014D   lcd_puts(s);
	LDI  R30,LOW(_s)
	LDI  R31,HIGH(_s)
	RJMP _0x20C0005
; 0000 014E }

	.DSEG
_0x29:
	.BYTE 0x8
;
;
;
;
;
;
;
;
;
;
;
;
;
;  void STATE_LINE_SENSOR(){
; 0000 015C void STATE_LINE_SENSOR(){

	.CSEG
_STATE_LINE_SENSOR:
; 0000 015D          lcd_clear();
	CALL _lcd_clear
; 0000 015E 
; 0000 015F    if(!LINE_DETECTOR_LEFT)
	SBIC 0x0,0
	RJMP _0x2A
; 0000 0160      lcd_puts("LEFT: 1");
	__POINTW1MN _0x2B,0
	RJMP _0xA3
; 0000 0161    else
_0x2A:
; 0000 0162      lcd_puts("LEFT: 0");
	__POINTW1MN _0x2B,8
_0xA3:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0163    if(!LINE_DETECTOR_RIGHT)
	SBIC 0x0,6
	RJMP _0x2D
; 0000 0164      lcd_puts(" RIGHT: 1");
	__POINTW1MN _0x2B,16
	RJMP _0xA4
; 0000 0165    else
_0x2D:
; 0000 0166      lcd_puts(" RIGHT: 0");
	__POINTW1MN _0x2B,26
_0xA4:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0167 
; 0000 0168    lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0169 
; 0000 016A    if(!LINE_DETECTOR_MID_LEFT)
	SBIC 0x0,2
	RJMP _0x2F
; 0000 016B      lcd_puts("MLEFT: 1");
	__POINTW1MN _0x2B,36
	RJMP _0xA5
; 0000 016C    else
_0x2F:
; 0000 016D      lcd_puts("MLEFT: 0");
	__POINTW1MN _0x2B,45
_0xA5:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 016E    if(!LINE_DETECTOR_MID_RIGHT)
	SBIC 0x0,4
	RJMP _0x31
; 0000 016F      lcd_puts("MRIGHT:1");
	__POINTW1MN _0x2B,54
	RJMP _0xA6
; 0000 0170    else
_0x31:
; 0000 0171      lcd_puts("MRIGHT:0");
	__POINTW1MN _0x2B,63
_0xA6:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0172  }
	RET

	.DSEG
_0x2B:
	.BYTE 0x48
;
;
;
;  void STATE_ENGINE(){
; 0000 0176 void STATE_ENGINE(){

	.CSEG
_STATE_ENGINE:
; 0000 0177  char str[10];
; 0000 0178       ENGINE_ENABLE_RIGHT = 1;
	CALL SUBOPT_0x9
;	str -> Y+0
; 0000 0179       ENGINE_ENABLE_LEFT = 1;
; 0000 017A              lcd_clear();
; 0000 017B       if(engine_dir == 0){
	BRNE _0x37
; 0000 017C         lcd_puts("     ENCODER  >>");
	__POINTW1MN _0x38,0
	CALL SUBOPT_0x1
; 0000 017D         ENGINE_DIRECTION_LEFT = 0;
	CBI  0x1B,7
; 0000 017E         ENGINE_DIRECTION_RIGHT = 0;
	CBI  0x1B,5
; 0000 017F         }
; 0000 0180       else{
	RJMP _0x3D
_0x37:
; 0000 0181         lcd_puts("<<   ENCODER    ");
	__POINTW1MN _0x38,17
	CALL SUBOPT_0x1
; 0000 0182         ENGINE_DIRECTION_LEFT = 1;
	SBI  0x1B,7
; 0000 0183         ENGINE_DIRECTION_RIGHT = 1;
	SBI  0x1B,5
; 0000 0184         }
_0x3D:
; 0000 0185          lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0186          puts("L:");
	__POINTW1MN _0x38,34
	CALL SUBOPT_0x1
; 0000 0187          itoa(wheelEncoderCounter_left,str);
	CALL SUBOPT_0xA
; 0000 0188          puts(str);
	CALL SUBOPT_0xB
; 0000 0189          puts(" R:");
	__POINTW1MN _0x38,37
	CALL SUBOPT_0x1
; 0000 018A          itoa(wheelEncoderCounter_right,str);
	CALL SUBOPT_0xC
; 0000 018B          puts(str);
	CALL SUBOPT_0xB
; 0000 018C        if(!BUMPER_RIGHT){
	SBIC 0x19,6
	RJMP _0x42
; 0000 018D        delay_ms(250);
	CALL SUBOPT_0xD
; 0000 018E        engine_dir = !engine_dir;
; 0000 018F        }
; 0000 0190  }
_0x42:
	RJMP _0x20C0006

	.DSEG
_0x38:
	.BYTE 0x29
;
;   void STATE_ENGINE_DIR(){
; 0000 0192 void STATE_ENGINE_DIR(){

	.CSEG
_STATE_ENGINE_DIR:
; 0000 0193  char str[10];
; 0000 0194       ENGINE_ENABLE_RIGHT = 1;
	CALL SUBOPT_0x9
;	str -> Y+0
; 0000 0195       ENGINE_ENABLE_LEFT = 1;
; 0000 0196       lcd_clear();
; 0000 0197       if(engine_dir == 0){
	BRNE _0x47
; 0000 0198         lcd_puts("     RECHTS    ");
	__POINTW1MN _0x48,0
	CALL SUBOPT_0x1
; 0000 0199         ENGINE_DIRECTION_LEFT = 0;
	CBI  0x1B,7
; 0000 019A         ENGINE_DIRECTION_RIGHT = 1;
	SBI  0x1B,5
; 0000 019B         }
; 0000 019C       else{
	RJMP _0x4D
_0x47:
; 0000 019D         lcd_puts("     LINKS    ");
	__POINTW1MN _0x48,16
	CALL SUBOPT_0x1
; 0000 019E         ENGINE_DIRECTION_LEFT = 1;
	SBI  0x1B,7
; 0000 019F         ENGINE_DIRECTION_RIGHT = 0;
	CBI  0x1B,5
; 0000 01A0         }
_0x4D:
; 0000 01A1          lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 01A2          puts("L:");
	__POINTW1MN _0x48,31
	CALL SUBOPT_0x1
; 0000 01A3          itoa(wheelEncoderCounter_left,str);
	CALL SUBOPT_0xA
; 0000 01A4          puts(str);
	CALL SUBOPT_0xB
; 0000 01A5          puts(" R:");
	__POINTW1MN _0x48,34
	CALL SUBOPT_0x1
; 0000 01A6          itoa(wheelEncoderCounter_right,str);
	CALL SUBOPT_0xC
; 0000 01A7          puts(str);
	CALL SUBOPT_0xB
; 0000 01A8        if(!BUMPER_RIGHT){
	SBIC 0x19,6
	RJMP _0x52
; 0000 01A9        delay_ms(250);
	CALL SUBOPT_0xD
; 0000 01AA        engine_dir = !engine_dir;
; 0000 01AB        }
; 0000 01AC  }
_0x52:
_0x20C0006:
	ADIW R28,10
	RET

	.DSEG
_0x48:
	.BYTE 0x26
;
;
;
;
; void STATE_DISTANCE_SENSOR(){
; 0000 01B1 void STATE_DISTANCE_SENSOR(){

	.CSEG
_STATE_DISTANCE_SENSOR:
; 0000 01B2    lcd_clear();
	CALL _lcd_clear
; 0000 01B3 
; 0000 01B4    if(!DISTANCE_SENSOR_LEFT)
	SBIC 0x16,0
	RJMP _0x53
; 0000 01B5      lcd_puts("LEFT: 1");
	__POINTW1MN _0x54,0
	RJMP _0xA7
; 0000 01B6    else
_0x53:
; 0000 01B7      lcd_puts("LEFT: 0");
	__POINTW1MN _0x54,8
_0xA7:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01B8    if(!DISTANCE_SENSOR_RIGHT)
	SBIC 0x16,6
	RJMP _0x56
; 0000 01B9      lcd_puts(" RIGHT: 1");
	__POINTW1MN _0x54,16
	RJMP _0xA8
; 0000 01BA    else
_0x56:
; 0000 01BB      lcd_puts(" RIGHT: 0");
	__POINTW1MN _0x54,26
_0xA8:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01BC 
; 0000 01BD    lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 01BE 
; 0000 01BF    if(!DISTANCE_SENSOR_FRONT_LEFT)
	SBIC 0x16,2
	RJMP _0x58
; 0000 01C0      lcd_puts("FLEFT: 1");
	__POINTW1MN _0x54,36
	RJMP _0xA9
; 0000 01C1    else
_0x58:
; 0000 01C2      lcd_puts("FLEFT: 0");
	__POINTW1MN _0x54,45
_0xA9:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01C3    if(!DISTANCE_SENSOR_FRONT_RIGHT)
	SBIC 0x16,4
	RJMP _0x5A
; 0000 01C4      lcd_puts("FRIGHT:1");
	__POINTW1MN _0x54,54
	RJMP _0xAA
; 0000 01C5    else
_0x5A:
; 0000 01C6      lcd_puts("FRIGHT:0");
	__POINTW1MN _0x54,63
_0xAA:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 01C7  }
	RET

	.DSEG
_0x54:
	.BYTE 0x48
;
;
;
; void STATE_LIGHTSENSOR(){
; 0000 01CB void STATE_LIGHTSENSOR(){

	.CSEG
_STATE_LIGHTSENSOR:
; 0000 01CC  int right = LIGHT_SENSOR_RIGHT;
; 0000 01CD  int left = LIGHT_SENSOR_LEFT;
; 0000 01CE  char str[10];
; 0000 01CF  lcd_clear();
	SBIW R28,10
	CALL __SAVELOCR4
;	right -> R16,R17
;	left -> R18,R19
;	str -> Y+4
	__GETW1MN _adc_data,6
	MOVW R16,R30
	__GETW1MN _adc_data,2
	MOVW R18,R30
	CALL _lcd_clear
; 0000 01D0     puts("LEFT:");
	__POINTW1MN _0x5C,0
	CALL SUBOPT_0x1
; 0000 01D1     itoa(left,str);
	ST   -Y,R19
	ST   -Y,R18
	MOVW R30,R28
	ADIW R30,6
	CALL SUBOPT_0x4
; 0000 01D2     puts(str);
	MOVW R30,R28
	ADIW R30,4
	CALL SUBOPT_0x1
; 0000 01D3     lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 01D4     puts("RIGHT:");
	__POINTW1MN _0x5C,6
	CALL SUBOPT_0x1
; 0000 01D5     itoa(right,str);
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	CALL SUBOPT_0x4
; 0000 01D6     puts(str);
	MOVW R30,R28
	ADIW R30,4
	CALL SUBOPT_0x1
; 0000 01D7  }
	CALL __LOADLOCR4
	ADIW R28,14
	RET

	.DSEG
_0x5C:
	.BYTE 0xD
;
;
; void STATE_WIICAM(){
; 0000 01DA void STATE_WIICAM(){

	.CSEG
_STATE_WIICAM:
; 0000 01DB         readData();
	RCALL _readData
; 0000 01DC         convertdata();
	RCALL _convertdata
; 0000 01DD         lcd_clear();
	CALL _lcd_clear
; 0000 01DE         //Anzeige der Blobs als X/X-Wertepaare
; 0000 01DF         for(i=0; i<4; i++){
	CLR  R9
_0x5E:
	LDI  R30,LOW(4)
	CP   R9,R30
	BRLO PC+3
	JMP _0x5F
; 0000 01E0        	 	if (i<2){           //erste Zeile: Blob 1 und 2
	LDI  R30,LOW(2)
	CP   R9,R30
	BRSH _0x60
; 0000 01E1        	 	   if(x[i]==1023||y[i]==1023){
	CALL SUBOPT_0xE
	CALL SUBOPT_0x7
	CPI  R30,LOW(0x3FF)
	LDI  R26,HIGH(0x3FF)
	CPC  R31,R26
	BREQ _0x62
	CALL SUBOPT_0xF
	CALL SUBOPT_0x7
	CPI  R30,LOW(0x3FF)
	LDI  R26,HIGH(0x3FF)
	CPC  R31,R26
	BRNE _0x61
_0x62:
; 0000 01E2        	 	        lcd_gotoxy(20 * (i), 0);
	CALL SUBOPT_0x10
; 0000 01E3            		lcd_putsf("No Object!");
	CALL SUBOPT_0x11
; 0000 01E4           		}
; 0000 01E5        	 	   else{
	RJMP _0x64
_0x61:
; 0000 01E6        	 		itoa( x[i]-512, Wert);  //konvertiert die int-Ausgabe des Empfängers in char-Array
	CALL SUBOPT_0xE
	CALL SUBOPT_0x7
	CALL SUBOPT_0x12
; 0000 01E7           		lcd_gotoxy(20 * (i), 0);
	CALL SUBOPT_0x10
; 0000 01E8            		lcd_puts(Wert);
	CALL SUBOPT_0x13
; 0000 01E9            		itoa( y[i]-374, Wert);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x7
	CALL SUBOPT_0x14
; 0000 01EA            		lcd_gotoxy(20 * (i)+ 8, 0);
	MOV  R30,R9
	LDI  R26,LOW(20)
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(8)
	CALL SUBOPT_0x15
; 0000 01EB            		lcd_puts(Wert);
; 0000 01EC            		itoa( sWIICAM[i], Wert);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 01ED            		lcd_gotoxy(20 * (i)+ 16, 0);
	MOV  R30,R9
	LDI  R26,LOW(20)
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(16)
	CALL SUBOPT_0x15
; 0000 01EE            		lcd_puts(Wert);
; 0000 01EF            		}
_0x64:
; 0000 01F0                }
; 0000 01F1                else
	RJMP _0x65
_0x60:
; 0000 01F2                {
; 0000 01F3                    if(x[i]==1023||y[i]==1023){
	CALL SUBOPT_0xE
	CALL SUBOPT_0x7
	CPI  R30,LOW(0x3FF)
	LDI  R26,HIGH(0x3FF)
	CPC  R31,R26
	BREQ _0x67
	CALL SUBOPT_0xF
	CALL SUBOPT_0x7
	CPI  R30,LOW(0x3FF)
	LDI  R26,HIGH(0x3FF)
	CPC  R31,R26
	BRNE _0x66
_0x67:
; 0000 01F4        	 	        lcd_gotoxy(20 * (i-2), 1);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 01F5            		lcd_putsf("No Object!");
	CALL SUBOPT_0x11
; 0000 01F6           		}
; 0000 01F7           	   else{                   //zweite Zeile: Blob 3 und 4
	RJMP _0x69
_0x66:
; 0000 01F8                 	itoa( x[i]-512, Wert);
	CALL SUBOPT_0xE
	CALL SUBOPT_0x7
	CALL SUBOPT_0x12
; 0000 01F9           		lcd_gotoxy(20 * (i-2), 1);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x18
; 0000 01FA            		lcd_puts(Wert);
	CALL SUBOPT_0x13
; 0000 01FB                		itoa( y[i]-374, Wert);
	CALL SUBOPT_0xF
	CALL SUBOPT_0x7
	CALL SUBOPT_0x14
; 0000 01FC            		lcd_gotoxy(20 * (i-2)+ 8, 1);
	CALL SUBOPT_0x16
	SBIW R30,2
	LDI  R26,LOW(20)
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(8)
	CALL SUBOPT_0x19
; 0000 01FD            		lcd_puts(Wert);
; 0000 01FE                		itoa( sWIICAM[i], Wert);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 01FF            		lcd_gotoxy(20 * (i-2)+ 16, 1);
	CALL SUBOPT_0x16
	SBIW R30,2
	LDI  R26,LOW(20)
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(16)
	CALL SUBOPT_0x19
; 0000 0200            		lcd_puts(Wert);
; 0000 0201            		}
_0x69:
; 0000 0202                }
_0x65:
; 0000 0203           }
	INC  R9
	RJMP _0x5E
_0x5F:
; 0000 0204 
; 0000 0205 	delay_ms(30);
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x1A
; 0000 0206 	WII_CAM_SCL = !WII_CAM_SCL;
	SBIS 0x18,3
	RJMP _0x6A
	CBI  0x18,3
	RJMP _0x6B
_0x6A:
	SBI  0x18,3
_0x6B:
; 0000 0207  }
	RET
;
;
; void STATE_IRTOWER(){
; 0000 020A void STATE_IRTOWER(){
_STATE_IRTOWER:
; 0000 020B     #ifndef DEBUG
; 0000 020C       rc5_display();
	RCALL _rc5_display
; 0000 020D     #endif
; 0000 020E 
; 0000 020F     if(rc5_receive(&ucToggle, &ucAdress, &ucData))
	LDI  R30,LOW(_ucToggle)
	LDI  R31,HIGH(_ucToggle)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucAdress)
	LDI  R31,HIGH(_ucAdress)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucData)
	LDI  R31,HIGH(_ucData)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _rc5_receive
	SBIW R30,0
	BREQ _0x6C
; 0000 0210     {
; 0000 0211       switch (ucData)
	LDS  R30,_ucData
	LDI  R31,0
; 0000 0212       {
; 0000 0213         case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x6F
; 0000 0214           //PORTE.0 = !PORTE.0;
; 0000 0215           delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x1A
; 0000 0216           break;
; 0000 0217       }
_0x6F:
; 0000 0218     }
; 0000 0219  }
_0x6C:
	RET
;
;
;  void STATE_SERVO(){
; 0000 021C void STATE_SERVO(){
_STATE_SERVO:
; 0000 021D     lcd_clear();
	CALL _lcd_clear
; 0000 021E       fnDisplay();
	RCALL _fnDisplay
; 0000 021F       bChange = 0;
	CLT
	BLD  R2,1
; 0000 0220       delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP _0x20C0004
; 0000 0221  }
;
;
;  void STATE_ULTRASONIC(){
; 0000 0224 void STATE_ULTRASONIC(){
_STATE_ULTRASONIC:
; 0000 0225 
; 0000 0226        if (bChange2)
	SBRS R2,0
	RJMP _0x71
; 0000 0227     {
; 0000 0228       lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0229       if (iTime <= 6000)
	LDS  R26,_iTime
	LDS  R27,_iTime+1
	CPI  R26,LOW(0x1771)
	LDI  R30,HIGH(0x1771)
	CPC  R27,R30
	BRSH _0x72
; 0000 022A       {
; 0000 022B       lcd_clear();
	CALL _lcd_clear
; 0000 022C         lcd_puts("Objekt gefunden");
	__POINTW1MN _0x73,0
	CALL SUBOPT_0x1
; 0000 022D       }
; 0000 022E 
; 0000 022F       else
	RJMP _0x74
_0x72:
; 0000 0230       {
; 0000 0231       lcd_clear();
	CALL _lcd_clear
; 0000 0232         lcd_putsf("Kein Object");
	__POINTW1FN _0x0,243
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0233       }
_0x74:
; 0000 0234       bChange2 = 0;
	CLT
	BLD  R2,0
; 0000 0235     }
; 0000 0236       }
_0x71:
	RET

	.DSEG
_0x73:
	.BYTE 0x10
;
; void STATE_ESP(){
; 0000 0238 void STATE_ESP(){

	.CSEG
_STATE_ESP:
; 0000 0239     lcd_clear();
	CALL _lcd_clear
; 0000 023A     puts("NICHT VERFUEGBAR");
	__POINTW1MN _0x75,0
_0x20C0005:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 023B     //twi_slave_init();
; 0000 023C 
; 0000 023D  }
	RET

	.DSEG
_0x75:
	.BYTE 0x11
;
;
;
;
;void STATE_MACHINE(){
; 0000 0242 void STATE_MACHINE(){

	.CSEG
_STATE_MACHINE:
; 0000 0243 
; 0000 0244         ENGINE_ENABLE_RIGHT = 0;
	CBI  0x1B,1
; 0000 0245         ENGINE_ENABLE_LEFT = 0;
	CBI  0x1B,3
; 0000 0246 
; 0000 0247        switch(state){
	LDS  R30,_state
	LDS  R31,_state+1
; 0000 0248 
; 0000 0249        case state_linedetector:
	SBIW R30,0
	BRNE _0x7D
; 0000 024A               if(state_info == 0){
	CALL SUBOPT_0x1B
	BRNE _0x7E
; 0000 024B                 lcd_puts("LINIEN SENSOR");
	__POINTW1MN _0x7F,0
	CALL SUBOPT_0x1
; 0000 024C                 delay_ms(1000);
	CALL SUBOPT_0x1C
; 0000 024D                 lcd_clear();
	CALL SUBOPT_0x1D
; 0000 024E                 state_info = 1;
; 0000 024F                 }
; 0000 0250               STATE_LINE_SENSOR();
_0x7E:
	RCALL _STATE_LINE_SENSOR
; 0000 0251        break;
	RJMP _0x7C
; 0000 0252 
; 0000 0253 
; 0000 0254        case state_engine:
_0x7D:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x80
; 0000 0255               if(state_info == 0){
	CALL SUBOPT_0x1B
	BRNE _0x81
; 0000 0256                 lcd_puts("MOTOREN");
	__POINTW1MN _0x7F,14
	CALL SUBOPT_0x1
; 0000 0257                 delay_ms(1000);
	CALL SUBOPT_0x1C
; 0000 0258                 lcd_clear();
	CALL SUBOPT_0x1D
; 0000 0259                 state_info = 1;
; 0000 025A                 }
; 0000 025B               STATE_ENGINE();
_0x81:
	RCALL _STATE_ENGINE
; 0000 025C        break;
	RJMP _0x7C
; 0000 025D 
; 0000 025E        case state_engine_dir:
_0x80:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x82
; 0000 025F               if(state_info == 0){
	CALL SUBOPT_0x1B
	BRNE _0x83
; 0000 0260                 lcd_puts("LENKUNG");
	__POINTW1MN _0x7F,22
	CALL SUBOPT_0x1
; 0000 0261                 delay_ms(1000);
	CALL SUBOPT_0x1C
; 0000 0262                 lcd_clear();
	CALL SUBOPT_0x1D
; 0000 0263                 state_info = 1;
; 0000 0264                 }
; 0000 0265               STATE_ENGINE_DIR();
_0x83:
	RCALL _STATE_ENGINE_DIR
; 0000 0266        break;
	RJMP _0x7C
; 0000 0267 
; 0000 0268        case state_distance_sensor:
_0x82:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x84
; 0000 0269               if(state_info == 0){
	CALL SUBOPT_0x1B
	BRNE _0x85
; 0000 026A                 lcd_puts("DISTANZ SENSOR");
	__POINTW1MN _0x7F,30
	CALL SUBOPT_0x1
; 0000 026B                 delay_ms(1000);
	CALL SUBOPT_0x1C
; 0000 026C                 lcd_clear();
	CALL SUBOPT_0x1D
; 0000 026D                 state_info = 1;
; 0000 026E                 }
; 0000 026F               STATE_DISTANCE_SENSOR();
_0x85:
	RCALL _STATE_DISTANCE_SENSOR
; 0000 0270        break;
	RJMP _0x7C
; 0000 0271 
; 0000 0272        case state_lightsensor:
_0x84:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x86
; 0000 0273               if(state_info == 0){
	CALL SUBOPT_0x1B
	BRNE _0x87
; 0000 0274                   lcd_puts("LICHT SENSOR");
	__POINTW1MN _0x7F,45
	CALL SUBOPT_0x1
; 0000 0275                   delay_ms(1000);
	CALL SUBOPT_0x1C
; 0000 0276                   lcd_clear();
	CALL SUBOPT_0x1D
; 0000 0277                   state_info = 1;
; 0000 0278                 }
; 0000 0279               STATE_LIGHTSENSOR();
_0x87:
	RCALL _STATE_LIGHTSENSOR
; 0000 027A        break;
	RJMP _0x7C
; 0000 027B 
; 0000 027C        case state_wiicam:
_0x86:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x88
; 0000 027D                 if(state_info == 0){
	CALL SUBOPT_0x1B
	BRNE _0x89
; 0000 027E                 lcd_puts("WII CAM");
	__POINTW1MN _0x7F,58
	CALL SUBOPT_0x1
; 0000 027F                 delay_ms(1000);
	CALL SUBOPT_0x1C
; 0000 0280                 lcd_clear();
	CALL SUBOPT_0x1D
; 0000 0281                 state_info = 1;
; 0000 0282                 }
; 0000 0283               STATE_WIICAM();
_0x89:
	RCALL _STATE_WIICAM
; 0000 0284        break;
	RJMP _0x7C
; 0000 0285 
; 0000 0286        case state_irtower:
_0x88:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x8A
; 0000 0287                 if(state_info == 0){
	CALL SUBOPT_0x1B
	BRNE _0x8B
; 0000 0288                 lcd_puts("IR TOWER");
	__POINTW1MN _0x7F,66
	CALL SUBOPT_0x1
; 0000 0289                 delay_ms(1000);
	CALL SUBOPT_0x1C
; 0000 028A                 lcd_clear();
	CALL SUBOPT_0x1D
; 0000 028B                 state_info = 1;
; 0000 028C                 }
; 0000 028D               STATE_IRTOWER();
_0x8B:
	RCALL _STATE_IRTOWER
; 0000 028E        break;
	RJMP _0x7C
; 0000 028F 
; 0000 0290        case state_servo:
_0x8A:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x8C
; 0000 0291                 if(state_info == 0){
	CALL SUBOPT_0x1B
	BRNE _0x8D
; 0000 0292                 lcd_puts("SERVO");
	__POINTW1MN _0x7F,75
	CALL SUBOPT_0x1
; 0000 0293                 delay_ms(1000);
	CALL SUBOPT_0x1C
; 0000 0294                 lcd_clear();
	CALL SUBOPT_0x1D
; 0000 0295                 state_info = 1;
; 0000 0296                 }
; 0000 0297               STATE_SERVO();
_0x8D:
	RCALL _STATE_SERVO
; 0000 0298        break;
	RJMP _0x7C
; 0000 0299 
; 0000 029A        case state_ultrasonic:
_0x8C:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x8E
; 0000 029B                 if(state_info == 0){
	CALL SUBOPT_0x1B
	BRNE _0x8F
; 0000 029C                 lcd_puts("ULTRASCHALL");
	__POINTW1MN _0x7F,81
	CALL SUBOPT_0x1
; 0000 029D                 delay_ms(1000);
	CALL SUBOPT_0x1C
; 0000 029E                 lcd_clear();
	CALL SUBOPT_0x1D
; 0000 029F                 state_info = 1;
; 0000 02A0                 }
; 0000 02A1               STATE_ULTRASONIC();
_0x8F:
	RCALL _STATE_ULTRASONIC
; 0000 02A2        break;
	RJMP _0x7C
; 0000 02A3 
; 0000 02A4               case state_esp:
_0x8E:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x92
; 0000 02A5                 if(state_info == 0){
	CALL SUBOPT_0x1B
	BRNE _0x91
; 0000 02A6                 lcd_puts("ESP TEST");
	__POINTW1MN _0x7F,93
	CALL SUBOPT_0x1
; 0000 02A7                 delay_ms(1000);
	CALL SUBOPT_0x1C
; 0000 02A8                 lcd_clear();
	CALL SUBOPT_0x1D
; 0000 02A9                 state_info = 1;
; 0000 02AA 
; 0000 02AB                 }
; 0000 02AC               STATE_ESP();
_0x91:
	RCALL _STATE_ESP
; 0000 02AD        break;
	RJMP _0x7C
; 0000 02AE 
; 0000 02AF 
; 0000 02B0        default:
_0x92:
; 0000 02B1           lcd_clear();
	CALL _lcd_clear
; 0000 02B2            lcd_puts("TEST - PROGRAMM");
	__POINTW1MN _0x7F,102
	CALL SUBOPT_0x1
; 0000 02B3       }
_0x7C:
; 0000 02B4        delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP _0x20C0004
; 0000 02B5 }

	.DSEG
_0x7F:
	.BYTE 0x76
;
;
;
;
;
;
;
;
;void main(void)
; 0000 02BF {

	.CSEG
_main:
; 0000 02C0 
; 0000 02C1 // I2C Bus initialization
; 0000 02C2 i2c_init();
	CALL _i2c_init
; 0000 02C3 //Kamera initialisieren
; 0000 02C4 wii_cam_init();
	RCALL _wii_cam_init
; 0000 02C5 
; 0000 02C6 port_init();
	RCALL _port_init
; 0000 02C7 
; 0000 02C8 while (1)
_0x93:
; 0000 02C9       {
; 0000 02CA            STATE_MACHINE();
	RCALL _STATE_MACHINE
; 0000 02CB 
; 0000 02CC        if(!BUMPER_LEFT){
	SBIC 0x19,4
	RJMP _0x96
; 0000 02CD        delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x1A
; 0000 02CE        lcd_clear();
	CALL _lcd_clear
; 0000 02CF 
; 0000 02D0        if(state+1 > state_stop) {
	LDS  R26,_state
	LDS  R27,_state+1
	ADIW R26,1
	SBIW R26,11
	BRLT _0x97
; 0000 02D1        state = 0;
	LDI  R30,LOW(0)
	STS  _state,R30
	STS  _state+1,R30
; 0000 02D2        }
; 0000 02D3        else {
	RJMP _0x98
_0x97:
; 0000 02D4        state++;
	LDI  R26,LOW(_state)
	LDI  R27,HIGH(_state)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 02D5        if (state==7){
	LDS  R26,_state
	LDS  R27,_state+1
	SBIW R26,7
	BRNE _0x99
; 0000 02D6              inSERVOTEST=1;
	SET
	RJMP _0xAB
; 0000 02D7        }else{
_0x99:
; 0000 02D8         inSERVOTEST=0;
	CLT
_0xAB:
	BLD  R2,4
; 0000 02D9        }
; 0000 02DA        }
_0x98:
; 0000 02DB 
; 0000 02DC        state_info = 0;
	LDI  R30,LOW(0)
	STS  _state_info,R30
	STS  _state_info+1,R30
; 0000 02DD       }
; 0000 02DE 
; 0000 02DF 
; 0000 02E0 }
_0x96:
	RJMP _0x93
; 0000 02E1 
; 0000 02E2 }
_0x9B:
	RJMP _0x9B
;
;void wii_cam_init(void)
; 0000 02E5 {
_wii_cam_init:
; 0000 02E6  //Kamera initialisieren
; 0000 02E7 	write2Byte(0x30,0x01);        	//Camera on
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _write2Byte
; 0000 02E8 	write2Byte(0x30,0x08);         	//set sensitivity Block 1 und 2
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	RCALL _write2Byte
; 0000 02E9 	write2Byte(0x06,0x90);          //sensitivity part1
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(144)
	ST   -Y,R30
	RCALL _write2Byte
; 0000 02EA 	write2Byte(0x08,0xC0);          //sensitivity part2
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(192)
	ST   -Y,R30
	RCALL _write2Byte
; 0000 02EB 	write2Byte(0x1A,0x40);
	LDI  R30,LOW(26)
	ST   -Y,R30
	LDI  R30,LOW(64)
	ST   -Y,R30
	RCALL _write2Byte
; 0000 02EC 	write2Byte(0x33,0x33);          //setting Mode : hier extended
	LDI  R30,LOW(51)
	ST   -Y,R30
	ST   -Y,R30
	RCALL _write2Byte
; 0000 02ED 	delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
_0x20C0004:
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 02EE }
	RET
;
;
;void write2Byte(char b1, char b2)
; 0000 02F2 {
_write2Byte:
; 0000 02F3   	i2c_start();
;	b1 -> Y+1
;	b2 -> Y+0
	CALL SUBOPT_0x1E
; 0000 02F4         i2c_write(slaveadress); //I2C-Adresse der Kamera, hier 0xBO
; 0000 02F5         i2c_write(b1);
	LDD  R30,Y+1
	ST   -Y,R30
	CALL _i2c_write
; 0000 02F6         i2c_write(b2);
	LD   R30,Y
	ST   -Y,R30
	CALL _i2c_write
; 0000 02F7         i2c_stop();
	CALL _i2c_stop
; 0000 02F8         delay_ms(10);
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x1A
; 0000 02F9 }
	JMP  _0x20C0003
;
;void readData(void)
; 0000 02FC {
_readData:
; 0000 02FD  	unsigned char i=0;
; 0000 02FE  	i2c_start();
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	CALL SUBOPT_0x1E
; 0000 02FF         i2c_write(slaveadress); //I2C-Adresse der Kamera
; 0000 0300         i2c_write(0x36);
	LDI  R30,LOW(54)
	ST   -Y,R30
	CALL _i2c_write
; 0000 0301         i2c_stop();
	CALL _i2c_stop
; 0000 0302         delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x1A
; 0000 0303         i2c_start();
	CALL _i2c_start
; 0000 0304         i2c_write(slaveread); //I2C-Adresse der Kamera Lesemodus 0xB1
	LDI  R30,LOW(177)
	ST   -Y,R30
	CALL _i2c_write
; 0000 0305         for(i=0; i<15; i++){
	LDI  R17,LOW(0)
_0x9D:
	CPI  R17,15
	BRSH _0x9E
; 0000 0306    	   	data[i]=i2c_read(1);
	MOV  R30,R17
	LDI  R26,LOW(_data)
	LDI  R27,HIGH(_data)
	CALL SUBOPT_0x0
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _i2c_read
	POP  R26
	POP  R27
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0307         }
	SUBI R17,-1
	RJMP _0x9D
_0x9E:
; 0000 0308         data[15]=i2c_read(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _i2c_read
	__POINTW2MN _data,30
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
; 0000 0309         i2c_stop();
	CALL _i2c_stop
; 0000 030A }
	LD   R17,Y+
	RET
;
;void convertdata(void)
; 0000 030D {
_convertdata:
; 0000 030E     int i=0;
; 0000 030F     for(i=0; i<4; i++) {
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
	__GETWRN 16,17,0
_0xA0:
	__CPWRN 16,17,4
	BRLT PC+3
	JMP _0xA1
; 0000 0310  	temp= (data[3+3*i]&0x30)<<4;
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	ANDI R30,LOW(0x30)
	ANDI R31,HIGH(0x30)
	CALL __LSLW4
	STS  _temp,R30
	STS  _temp+1,R31
; 0000 0311  	x[i]=data[1+3*i]+temp;
	MOVW R30,R16
	LDI  R26,LOW(_x)
	LDI  R27,HIGH(_x)
	CALL SUBOPT_0x21
	MOVW R26,R30
	LSL  R26
	ROL  R27
	__ADDW2MN _data,2
	CALL SUBOPT_0x22
; 0000 0312  	temp= (data[3+3*i]&0xC0)<<2;
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	ANDI R30,LOW(0xC0)
	ANDI R31,HIGH(0xC0)
	CALL __LSLW2
	STS  _temp,R30
	STS  _temp+1,R31
; 0000 0313  	y[i]=data[2+3*i]+temp;
	MOVW R30,R16
	LDI  R26,LOW(_y)
	LDI  R27,HIGH(_y)
	CALL SUBOPT_0x21
	MOVW R26,R30
	LSL  R26
	ROL  R27
	__ADDW2MN _data,4
	CALL SUBOPT_0x22
; 0000 0314  	s[i]=data[3+3*i]&0x0F;
	MOVW R30,R16
	SUBI R30,LOW(-_s)
	SBCI R31,HIGH(-_s)
	MOVW R22,R30
	CALL SUBOPT_0x1F
	MOVW R26,R30
	LSL  R26
	ROL  R27
	__ADDW2MN _data,6
	LD   R30,X
	ANDI R30,LOW(0xF)
	MOVW R26,R22
	ST   X,R30
; 0000 0315        }
	__ADDWRN 16,17,1
	RJMP _0xA0
_0xA1:
; 0000 0316 }
	LD   R16,Y+
	LD   R17,Y+
	RET

	.CSEG
_itoa:
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret

	.DSEG

	.CSEG
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G101:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0001
__lcd_read_nibble_G101:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
    andi  r30,0xf0
	RET
_lcd_read_byte0_G101:
	CALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0003:
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2020004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0001
_lcd_puts:
	ST   -Y,R17
_0x2020005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020005
_0x2020007:
	RJMP _0x20C0002
_lcd_putsf:
	ST   -Y,R17
_0x2020008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
_0x20C0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G101:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G101:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x24
	LDI  R30,LOW(4)
	CALL SUBOPT_0x24
	LDI  R30,LOW(133)
	CALL SUBOPT_0x24
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x20C0001
_0x202000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0001:
	ADIW R28,1
	RET
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_adc_data:
	.BYTE 0xC
_input_index_S0000000000:
	.BYTE 0x1
_iTime:
	.BYTE 0x2
_icr3:
	.BYTE 0x2
_arTrim:
	.BYTE 0x1
_arServos:
	.BYTE 0x2
_Pause:
	.BYTE 0x2
_ucServoNr:
	.BYTE 0x2
_ucNr:
	.BYTE 0x2
_strTemp:
	.BYTE 0x11
_rc5_time:
	.BYTE 0x1
_rc5_data:
	.BYTE 0x2
_tmp:
	.BYTE 0x2
_ucToggle:
	.BYTE 0x1
_ucAdress:
	.BYTE 0x1
_ucData:
	.BYTE 0x1
_s:
	.BYTE 0x11
_data:
	.BYTE 0x20
_Wert:
	.BYTE 0x5
_x:
	.BYTE 0x8
_y:
	.BYTE 0x8
_sWIICAM:
	.BYTE 0x4
_temp:
	.BYTE 0x2
_state:
	.BYTE 0x2
_state_info:
	.BYTE 0x2
_engine_dir:
	.BYTE 0x2
__seed_G100:
	.BYTE 0x4
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x0:
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 38 TIMES, CODE SIZE REDUCTION:71 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3:
	LDS  R30,_ucNr
	LDS  R31,_ucNr+1
	LDI  R26,LOW(_arServos)
	LDI  R27,HIGH(_arServos)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDS  R30,_ucNr
	LDS  R31,_ucNr+1
	LDI  R26,LOW(_arServos)
	LDI  R27,HIGH(_arServos)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X+
	LD   R31,X+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDS  R30,_tmp
	LDS  R31,_tmp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_s)
	LDI  R31,HIGH(_s)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	SBIW R28,10
	SBI  0x1B,1
	SBI  0x1B,3
	CALL _lcd_clear
	LDS  R30,_engine_dir
	LDS  R31,_engine_dir+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	ST   -Y,R5
	ST   -Y,R4
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	MOVW R30,R28
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	ST   -Y,R7
	ST   -Y,R6
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDS  R30,_engine_dir
	LDS  R31,_engine_dir+1
	CALL __LNEGW1
	LDI  R31,0
	STS  _engine_dir,R30
	STS  _engine_dir+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
	MOV  R30,R9
	LDI  R26,LOW(_x)
	LDI  R27,HIGH(_x)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	MOV  R30,R9
	LDI  R26,LOW(_y)
	LDI  R27,HIGH(_y)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	MOV  R30,R9
	LDI  R26,LOW(20)
	MULS R30,R26
	ST   -Y,R0
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	__POINTW1FN _0x0,216
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	SUBI R30,LOW(512)
	SBCI R31,HIGH(512)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_Wert)
	LDI  R31,HIGH(_Wert)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(_Wert)
	LDI  R31,HIGH(_Wert)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	SUBI R30,LOW(374)
	SBCI R31,HIGH(374)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_Wert)
	LDI  R31,HIGH(_Wert)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	MOV  R30,R9
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17:
	SUBI R30,LOW(-_sWIICAM)
	SBCI R31,HIGH(-_sWIICAM)
	LD   R30,Z
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_Wert)
	LDI  R31,HIGH(_Wert)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	SBIW R30,2
	LDI  R26,LOW(20)
	MULS R30,R26
	ST   -Y,R0
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1A:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x1B:
	LDS  R30,_state_info
	LDS  R31,_state_info+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x1D:
	CALL _lcd_clear
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _state_info,R30
	STS  _state_info+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	CALL _i2c_start
	LDI  R30,LOW(176)
	ST   -Y,R30
	JMP  _i2c_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	MOVW R30,R16
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	MOVW R26,R30
	LSL  R26
	ROL  R27
	__ADDW2MN _data,6
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	MOVW R22,R30
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x22:
	CALL __GETW1P
	LDS  R26,_temp
	LDS  R27,_temp+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G101


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,27
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,53
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__LSRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSRW12R
__LSRW12L:
	LSR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRW12L
__LSRW12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSRW4:
	LSR  R31
	ROR  R30
__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
	RET

__LNEGW1:
	OR   R30,R31
	LDI  R30,1
	BREQ __LNEGW1F
	LDI  R30,0
__LNEGW1F:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
