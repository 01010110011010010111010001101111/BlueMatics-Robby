
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 16,000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
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
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
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
	.DEF _servo_breaks=R4
	.DEF _servo_breaks_msb=R5
	.DEF _servo_value_cur=R6
	.DEF _servo_value_cur_msb=R7
	.DEF _servo_value_copy=R8
	.DEF _servo_value_copy_msb=R9
	.DEF _servo_test=R10
	.DEF _servo_test_msb=R11
	.DEF _state_info=R12
	.DEF _state_info_msb=R13

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
	JMP  _timer2_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer1_ovf_isr
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
	JMP  _twi_int_handler
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0001

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x1,0x0,0xAA,0x0
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0

_0x3:
	.DB  0x11
_0x4:
	.DB  0xA
_0x0:
	.DB  0x44,0x41,0x54,0x41,0x0,0x50,0x4F,0x53
	.DB  0x49,0x54,0x49,0x4F,0x4E,0x2D,0x53,0x45
	.DB  0x52,0x56,0x4F,0x0,0x4C,0x45,0x46,0x54
	.DB  0x3A,0x20,0x31,0x0,0x4C,0x45,0x46,0x54
	.DB  0x3A,0x20,0x30,0x0,0x20,0x52,0x49,0x47
	.DB  0x48,0x54,0x3A,0x20,0x31,0x0,0x20,0x52
	.DB  0x49,0x47,0x48,0x54,0x3A,0x20,0x30,0x0
	.DB  0x4D,0x4C,0x45,0x46,0x54,0x3A,0x20,0x31
	.DB  0x0,0x4D,0x4C,0x45,0x46,0x54,0x3A,0x20
	.DB  0x30,0x0,0x4D,0x52,0x49,0x47,0x48,0x54
	.DB  0x3A,0x31,0x0,0x4D,0x52,0x49,0x47,0x48
	.DB  0x54,0x3A,0x30,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x45,0x4E,0x43,0x4F,0x44,0x45,0x52
	.DB  0x20,0x20,0x3E,0x3E,0x0,0x3C,0x3C,0x20
	.DB  0x20,0x20,0x45,0x4E,0x43,0x4F,0x44,0x45
	.DB  0x52,0x20,0x20,0x20,0x20,0x0,0x4C,0x3A
	.DB  0x0,0x20,0x52,0x3A,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x52,0x45,0x43,0x48,0x54,0x53
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x4C,0x49,0x4E,0x4B,0x53,0x20
	.DB  0x20,0x20,0x20,0x0,0x46,0x4C,0x45,0x46
	.DB  0x54,0x3A,0x20,0x31,0x0,0x46,0x4C,0x45
	.DB  0x46,0x54,0x3A,0x20,0x30,0x0,0x46,0x52
	.DB  0x49,0x47,0x48,0x54,0x3A,0x31,0x0,0x46
	.DB  0x52,0x49,0x47,0x48,0x54,0x3A,0x30,0x0
	.DB  0x4C,0x45,0x46,0x54,0x3A,0x0,0x52,0x49
	.DB  0x47,0x48,0x54,0x3A,0x0,0x4E,0x6F,0x20
	.DB  0x4F,0x62,0x6A,0x65,0x63,0x74,0x21,0x0
	.DB  0x4F,0x62,0x6A,0x65,0x6B,0x74,0x20,0x67
	.DB  0x65,0x66,0x75,0x6E,0x64,0x65,0x6E,0x0
	.DB  0x4B,0x65,0x69,0x6E,0x20,0x4F,0x62,0x6A
	.DB  0x65,0x6B,0x74,0x0,0x20,0x20,0x4C,0x49
	.DB  0x4E,0x45,0x44,0x45,0x54,0x45,0x43,0x54
	.DB  0x4F,0x52,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x45,0x4E,0x47,0x49,0x4E,0x45
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x53,0x54,0x45,0x45,0x52,0x49
	.DB  0x4E,0x47,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x44,0x49,0x53,0x54,0x41,0x4E,0x43,0x45
	.DB  0x53,0x45,0x4E,0x53,0x4F,0x52,0x20,0x0
	.DB  0x20,0x20,0x4C,0x49,0x47,0x48,0x54,0x20
	.DB  0x53,0x45,0x4E,0x53,0x4F,0x52,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x57,0x49
	.DB  0x49,0x20,0x43,0x41,0x4D,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x49,0x52,0x20
	.DB  0x54,0x4F,0x57,0x45,0x52,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x53
	.DB  0x45,0x52,0x56,0x4F,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x55,0x4C,0x54,0x52
	.DB  0x41,0x53,0x4F,0x4E,0x49,0x43,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x46,0x4F
	.DB  0x52,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x42
	.DB  0x41,0x43,0x4B,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x4C,0x45,0x46,0x54,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x52,0x49,0x47,0x48,0x54,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x39,0x30,0xB0,0x4C,0x45,0x46,0x54
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x39,0x30,0xB0,0x52,0x49,0x47
	.DB  0x48,0x54,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x53,0x50,0x49,0x4E,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x31,0x73,0x74,0x20,0x53,0x54,0x41,0x54
	.DB  0x45,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x42,0x6C,0x75,0x65,0x4D,0x61,0x74
	.DB  0x69,0x63,0x73,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x52,0x6F,0x62,0x62,0x79,0x0,0x4F
	.DB  0x4B,0x0,0x42,0x75,0x66,0x66,0x65,0x72
	.DB  0x20,0x6F,0x76,0x65,0x72,0x66,0x6C,0x6F
	.DB  0x77,0x0,0x41,0x72,0x62,0x69,0x74,0x72
	.DB  0x61,0x74,0x69,0x6F,0x6E,0x20,0x6C,0x6F
	.DB  0x73,0x74,0x0,0x42,0x75,0x73,0x20,0x65
	.DB  0x72,0x72,0x6F,0x72,0x0,0x4E,0x41,0x43
	.DB  0x4B,0x20,0x72,0x65,0x63,0x65,0x69,0x76
	.DB  0x65,0x64,0x0,0x42,0x75,0x73,0x20,0x74
	.DB  0x69,0x6D,0x65,0x6F,0x75,0x74,0x0,0x46
	.DB  0x61,0x69,0x6C,0x0,0x55,0x6E,0x6B,0x6E
	.DB  0x6F,0x77,0x6E,0x20,0x65,0x72,0x72,0x6F
	.DB  0x72,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2060003:
	.DB  0x7
_0x2080003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _state
	.DW  _0x3*2

	.DW  0x05
	.DW  _0x17
	.DW  _0x0*2

	.DW  0x0F
	.DW  _0x27
	.DW  _0x0*2+5

	.DW  0x08
	.DW  _0x54
	.DW  _0x0*2+20

	.DW  0x08
	.DW  _0x54+8
	.DW  _0x0*2+28

	.DW  0x0A
	.DW  _0x54+16
	.DW  _0x0*2+36

	.DW  0x0A
	.DW  _0x54+26
	.DW  _0x0*2+46

	.DW  0x09
	.DW  _0x54+36
	.DW  _0x0*2+56

	.DW  0x09
	.DW  _0x54+45
	.DW  _0x0*2+65

	.DW  0x09
	.DW  _0x54+54
	.DW  _0x0*2+74

	.DW  0x09
	.DW  _0x54+63
	.DW  _0x0*2+83

	.DW  0x11
	.DW  _0x61
	.DW  _0x0*2+92

	.DW  0x11
	.DW  _0x61+17
	.DW  _0x0*2+109

	.DW  0x03
	.DW  _0x61+34
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0x61+37
	.DW  _0x0*2+129

	.DW  0x10
	.DW  _0x71
	.DW  _0x0*2+133

	.DW  0x0F
	.DW  _0x71+16
	.DW  _0x0*2+149

	.DW  0x03
	.DW  _0x71+31
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0x71+34
	.DW  _0x0*2+129

	.DW  0x08
	.DW  _0x7D
	.DW  _0x0*2+20

	.DW  0x08
	.DW  _0x7D+8
	.DW  _0x0*2+28

	.DW  0x0A
	.DW  _0x7D+16
	.DW  _0x0*2+36

	.DW  0x0A
	.DW  _0x7D+26
	.DW  _0x0*2+46

	.DW  0x09
	.DW  _0x7D+36
	.DW  _0x0*2+164

	.DW  0x09
	.DW  _0x7D+45
	.DW  _0x0*2+173

	.DW  0x09
	.DW  _0x7D+54
	.DW  _0x0*2+182

	.DW  0x09
	.DW  _0x7D+63
	.DW  _0x0*2+191

	.DW  0x06
	.DW  _0x85
	.DW  _0x0*2+200

	.DW  0x07
	.DW  _0x85+6
	.DW  _0x0*2+206

	.DW  0x03
	.DW  _0xC3
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xC3+3
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xCF
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xCF+3
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xDB
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xDB+3
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xE9
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xE9+3
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xE9+7
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xE9+10
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xE9+14
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xE9+17
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xE9+21
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xE9+24
	.DW  _0x0*2+129

	.DW  0x11
	.DW  _0x124
	.DW  _0x0*2+252

	.DW  0x10
	.DW  _0x124+17
	.DW  _0x0*2+269

	.DW  0x12
	.DW  _0x124+33
	.DW  _0x0*2+285

	.DW  0x11
	.DW  _0x124+51
	.DW  _0x0*2+303

	.DW  0x11
	.DW  _0x124+68
	.DW  _0x0*2+320

	.DW  0x10
	.DW  _0x124+85
	.DW  _0x0*2+337

	.DW  0x11
	.DW  _0x124+101
	.DW  _0x0*2+353

	.DW  0x0F
	.DW  _0x124+118
	.DW  _0x0*2+370

	.DW  0x10
	.DW  _0x124+133
	.DW  _0x0*2+385

	.DW  0x10
	.DW  _0x124+149
	.DW  _0x0*2+401

	.DW  0x12
	.DW  _0x124+165
	.DW  _0x0*2+417

	.DW  0x11
	.DW  _0x124+183
	.DW  _0x0*2+435

	.DW  0x10
	.DW  _0x124+200
	.DW  _0x0*2+452

	.DW  0x12
	.DW  _0x124+216
	.DW  _0x0*2+468

	.DW  0x11
	.DW  _0x124+234
	.DW  _0x0*2+486

	.DW  0x0D
	.DW  _0x124+251
	.DW  _0x0*2+503

	.DW  0x12
	.DW  _0x124+264
	.DW  _0x0*2+516

	.DW  0x0E
	.DW  _0x124+282
	.DW  _0x0*2+534

	.DW  0x0B
	.DW  _0x124+296
	.DW  _0x0*2+548

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x01
	.DW  _twi_result
	.DW  _0x2060003*2

	.DW  0x02
	.DW  __base_y_G104
	.DW  _0x2080003*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

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
;Version : 0.0.8
;Date    : 28.11.2017
;Author  : Viktor Lau
;Company : https://lauviktor.de
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
;//Header includes
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
;#include <string.h>
;#include <stdint.h>
;#include <stdio.h>
;#include <twi.h>
;#include <i2c.h>
;#include <io.h>
;
;#define puts lcd_puts
;//STATES
;#define state_linedetector  0
;#define state_engine  1
;#define state_engine_dir  2
;#define state_distance_sensor  3
;#define state_lightsensor  4
;#define state_wiicam  5
;#define state_irtower  6
;#define state_servo  7
;#define state_ultrasonic  8
;#define state_vor  9
;#define state_zur  10
;#define state_links  11
;#define state_rechts  12
;#define state_90links  13
;#define state_90rechts  14
;#define state_drehung  15
;#define state_meterlinksmeterrechts  16
;#define state_stop 17
;
;#include "modules/variables.h"

	.DSEG
;#include "modules/port_init.h"

	.CSEG
_adc_isr:
; .FSTART _adc_isr
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
	LDI  R31,0
	LSL  R30
	ROL  R31
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
	BRLO _0x5
	LDI  R30,LOW(0)
	STS  _input_index_S0000000000,R30
_0x5:
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
; .FEND
_ext_int4_isr:
; .FSTART _ext_int4_isr
	CALL SUBOPT_0x0
	LDS  R26,_wheelEncoderCounter_right
	LDS  R27,_wheelEncoderCounter_right+1
	CPI  R26,LOW(0x4E20)
	LDI  R30,HIGH(0x4E20)
	CPC  R27,R30
	BRGE _0x6
	LDI  R26,LOW(_wheelEncoderCounter_right)
	LDI  R27,HIGH(_wheelEncoderCounter_right)
	CALL SUBOPT_0x1
	RJMP _0x7
_0x6:
	LDI  R30,LOW(0)
	STS  _wheelEncoderCounter_right,R30
	STS  _wheelEncoderCounter_right+1,R30
_0x7:
	RJMP _0x170
; .FEND
_ext_int6_isr:
; .FSTART _ext_int6_isr
	CALL SUBOPT_0x0
	LDS  R26,_wheelEncoderCounter_left
	LDS  R27,_wheelEncoderCounter_left+1
	CPI  R26,LOW(0x4E20)
	LDI  R30,HIGH(0x4E20)
	CPC  R27,R30
	BRGE _0x8
	LDI  R26,LOW(_wheelEncoderCounter_left)
	LDI  R27,HIGH(_wheelEncoderCounter_left)
	CALL SUBOPT_0x1
	RJMP _0x9
_0x8:
	LDI  R30,LOW(0)
	STS  _wheelEncoderCounter_left,R30
	STS  _wheelEncoderCounter_left+1,R30
_0x9:
	RJMP _0x170
; .FEND
   .equ __lcd_port=0x15 ;PORTC
_port_init:
; .FSTART _port_init
	LDI  R30,LOW(138)
	OUT  0x1A,R30
	LDI  R30,LOW(2)
	OUT  0x17,R30
	LDI  R30,LOW(161)
	OUT  0x11,R30
	LDI  R30,LOW(32)
	OUT  0x2,R30
	STS  97,R30
	LDI  R26,LOW(16)
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
	LDI  R30,LOW(1)
	OUT  0x2F,R30
	LDI  R30,LOW(10)
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
	LDI  R30,LOW(4)
	OUT  0x25,R30
	LDI  R30,LOW(0)
	OUT  0x24,R30
	OUT  0x23,R30
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
	LDI  R30,LOW(69)
	OUT  0x37,R30
	LDI  R30,LOW(48)
	STS  125,R30
	sei
	RET
; .FEND
;#include "modules/ir.h"
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	CALL SUBOPT_0x0
	LDI  R30,LOW(254)
	OUT  0x32,R30
	LDS  R26,_rc5_time
	SUBI R26,-LOW(1)
	STS  _rc5_time,R26
	CPI  R26,LOW(0x44)
	BRLO _0xA
	__GETB1MN _tmp,1
	ANDI R30,LOW(0x40)
	BRNE _0xC
	__GETB1MN _tmp,1
	ANDI R30,LOW(0x20)
	BRNE _0xD
_0xC:
	RJMP _0xB
_0xD:
	CALL SUBOPT_0x2
	STS  _rc5_data,R30
	STS  _rc5_data+1,R31
_0xB:
	LDI  R30,LOW(0)
	STS  _tmp,R30
	STS  _tmp+1,R30
_0xA:
	LDI  R26,0
	SBRC R2,0
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
	BREQ _0xE
	LDI  R30,LOW(1)
	EOR  R2,R30
	LDS  R26,_rc5_time
	CPI  R26,LOW(0xB)
	BRSH _0xF
	LDI  R30,LOW(0)
	STS  _tmp,R30
	STS  _tmp+1,R30
_0xF:
	CALL SUBOPT_0x2
	SBIW R30,0
	BREQ _0x11
	LDS  R26,_rc5_time
	CPI  R26,LOW(0x2D)
	BRLO _0x10
_0x11:
	__GETB1MN _tmp,1
	ANDI R30,LOW(0x40)
	BRNE _0x13
	CALL SUBOPT_0x2
	LSL  R30
	ROL  R31
	STS  _tmp,R30
	STS  _tmp+1,R31
_0x13:
	SBRC R2,0
	RJMP _0x14
	CALL SUBOPT_0x2
	ORI  R30,1
	STS  _tmp,R30
	STS  _tmp+1,R31
_0x14:
	LDI  R30,LOW(0)
	STS  _rc5_time,R30
_0x10:
_0xE:
_0x170:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
_rc5_receive:
; .FSTART _rc5_receive
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	*ucToggle -> Y+6
;	*ucAdress -> Y+4
;	*ucData -> Y+2
;	i -> R16,R17
	cli
	__GETWRMN 16,17,0,_rc5_data
	LDI  R30,LOW(0)
	STS  _rc5_data,R30
	STS  _rc5_data+1,R30
	sei
	MOV  R0,R16
	OR   R0,R17
	BREQ _0x15
	MOVW R26,R16
	LDI  R30,LOW(11)
	CALL __LSRW12
	ANDI R30,LOW(0x1)
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ST   X,R30
	MOVW R26,R16
	LDI  R30,LOW(6)
	CALL __LSRW12
	ANDI R30,LOW(0x1F)
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	ST   X,R30
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
	MOVW R30,R16
	RJMP _0x20E0002
_0x15:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x20E0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
; .FEND

	.DSEG
_0x17:
	.BYTE 0x5

	.CSEG
_ondata:
; .FSTART _ondata
	LDI  R30,LOW(_ucToggle)
	LDI  R31,HIGH(_ucToggle)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_ucAdress)
	LDI  R31,HIGH(_ucAdress)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_ucData)
	LDI  R27,HIGH(_ucData)
	RCALL _rc5_receive
	SBIW R30,0
	BREQ _0x18
	LDS  R30,_ucData
	LDI  R31,0
	SBIW R30,0
	BRNE _0x1C
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	RJMP _0x15D
_0x1C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1D
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	RJMP _0x15D
_0x1D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1B
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
_0x15D:
	STS  _state,R30
	STS  _state+1,R31
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
_0x1B:
_0x18:
	RET
; .FEND
;#include "modules/servo.h"
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	CBI  0x12,7
	__CPWRR 8,9,6,7
	BRNE _0x22
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x21
_0x22:
	MOVW R8,R6
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R4,R30
	OUT  0x24,R6
	SBI  0x12,7
	RJMP _0x26
_0x21:
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	LDI  R30,LOW(0)
	OUT  0x24,R30
_0x26:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;	str -> Y+0

	.DSEG
_0x27:
	.BYTE 0xF
;#include "modules/esp_main_func.h"

	.CSEG
_esp_states:
; .FSTART _esp_states
	CALL SUBOPT_0x3
	SBIW R26,20
	BRNE _0x28
	LDI  R30,LOW(220)
	LDI  R31,HIGH(220)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x29
	MOVW R30,R6
	ADIW R30,5
	MOVW R6,R30
_0x29:
_0x28:
	CALL SUBOPT_0x3
	SBIW R26,21
	BRNE _0x2A
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x2B
	MOVW R30,R6
	SBIW R30,5
	MOVW R6,R30
_0x2B:
_0x2A:
	CALL SUBOPT_0x3
	SBIW R26,0
	BRNE _0x2C
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	RJMP _0x15E
_0x2C:
	LDS  R30,_currstate
	LDS  R31,_currstate+1
	SBIW R30,1
_0x15E:
	STS  _state,R30
	STS  _state+1,R31
	RET
; .FEND
_esp_mainfunctions:
; .FSTART _esp_mainfunctions
	SBIC 0x0,0
	RJMP _0x2F
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x15F
_0x2F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x15F:
	STS  _line_left,R30
	STS  _line_left+1,R31
	SBIC 0x0,2
	RJMP _0x32
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x160
_0x32:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x160:
	STS  _line_mleft,R30
	STS  _line_mleft+1,R31
	SBIC 0x0,4
	RJMP _0x35
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x161
_0x35:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x161:
	STS  _line_mright,R30
	STS  _line_mright+1,R31
	SBIC 0x0,6
	RJMP _0x38
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x162
_0x38:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x162:
	STS  _line_right,R30
	STS  _line_right+1,R31
	LDS  R30,_line_left
	LDS  R31,_line_left+1
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	MOVW R22,R30
	LDS  R30,_line_mleft
	LDS  R31,_line_mleft+1
	CALL SUBOPT_0x4
	LDS  R30,_line_mright
	LDS  R31,_line_mright+1
	CALL SUBOPT_0x5
	LDS  R26,_line_right
	LDS  R27,_line_right+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _linesensorvaluetemp,R30
	STS  _linesensorvaluetemp+1,R31
	SBIC 0x16,0
	RJMP _0x3B
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x163
_0x3B:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x163:
	STS  _dist_left,R30
	STS  _dist_left+1,R31
	SBIC 0x16,2
	RJMP _0x3E
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x164
_0x3E:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x164:
	STS  _dist_fleft,R30
	STS  _dist_fleft+1,R31
	SBIC 0x16,4
	RJMP _0x41
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x165
_0x41:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x165:
	STS  _dist_fright,R30
	STS  _dist_fright+1,R31
	SBIC 0x16,6
	RJMP _0x44
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x166
_0x44:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x166:
	STS  _dist_right,R30
	STS  _dist_right+1,R31
	LDS  R30,_dist_left
	LDS  R31,_dist_left+1
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	MOVW R22,R30
	LDS  R30,_dist_fleft
	LDS  R31,_dist_fleft+1
	CALL SUBOPT_0x4
	LDS  R30,_dist_fright
	LDS  R31,_dist_fright+1
	CALL SUBOPT_0x5
	LDS  R26,_dist_right
	LDS  R27,_dist_right+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _distanzsensorvaluetemp,R30
	STS  _distanzsensorvaluetemp+1,R31
	RET
; .FEND
;#include "modules/wiicam.h"
_wii_cam_init:
; .FSTART _wii_cam_init
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _write2Byte
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDI  R26,LOW(8)
	RCALL _write2Byte
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R26,LOW(144)
	RCALL _write2Byte
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R26,LOW(192)
	RCALL _write2Byte
	LDI  R30,LOW(26)
	ST   -Y,R30
	LDI  R26,LOW(64)
	RCALL _write2Byte
	LDI  R30,LOW(51)
	ST   -Y,R30
	LDI  R26,LOW(51)
	RCALL _write2Byte
	LDI  R26,LOW(100)
	LDI  R27,0
	CALL _delay_ms
	RET
; .FEND
_write2Byte:
; .FSTART _write2Byte
	ST   -Y,R26
;	b1 -> Y+1
;	b2 -> Y+0
	CALL _i2c_start
	LDI  R26,LOW(176)
	CALL _i2c_write
	LDD  R26,Y+1
	CALL _i2c_write
	LD   R26,Y
	CALL _i2c_write
	CALL _i2c_stop
	LDI  R26,LOW(10)
	LDI  R27,0
	CALL _delay_ms
	ADIW R28,2
	RET
; .FEND
;	i -> R17
;	i -> R16,R17
;#include "modules/ultrasonic.h"
_timer3_capt_isr:
; .FSTART _timer3_capt_isr
	CALL SUBOPT_0x0
	LDS  R30,128
	STS  _icr3,R30
	LDS  R30,129
	__PUTB1MN _icr3,1
	SBIS 0x1,7
	RJMP _0x4D
	LDS  R30,_icr3
	LDS  R31,_icr3+1
	STS  _iRisingEdge,R30
	STS  _iRisingEdge+1,R31
	LDS  R30,138
	ANDI R30,0xBF
	STS  138,R30
	RJMP _0x4E
_0x4D:
	LDS  R30,_icr3
	LDS  R31,_icr3+1
	STS  _iFallingEdge,R30
	STS  _iFallingEdge+1,R31
	LDS  R30,138
	ORI  R30,0x40
	STS  138,R30
	LDS  R26,_iRisingEdge
	LDS  R27,_iRisingEdge+1
	LDS  R30,_iFallingEdge
	LDS  R31,_iFallingEdge+1
	SUB  R30,R26
	SBC  R31,R27
	CALL __LSLW2
	STS  _iTime,R30
	STS  _iTime+1,R31
	SET
	BLD  R2,2
_0x4E:
	RJMP _0x16F
; .FEND
_timer3_compa_isr:
; .FSTART _timer3_compa_isr
	ST   -Y,R24
	ST   -Y,R30
	IN   R30,SREG
	SBI  0x18,1
	__DELAY_USB 53
	CBI  0x18,1
	OUT  SREG,R30
	LD   R30,Y+
	LD   R24,Y+
	RETI
; .FEND
;#include "modules/states/states.h"

	.DSEG
_0x54:
	.BYTE 0x48

	.CSEG
;	str -> Y+0

	.DSEG
_0x61:
	.BYTE 0x29

	.CSEG
;	str -> Y+0

	.DSEG
_0x71:
	.BYTE 0x26

	.CSEG

	.DSEG
_0x7D:
	.BYTE 0x48

	.CSEG
;	right -> R16,R17
;	left -> R18,R19
;	str -> Y+4

	.DSEG
_0x85:
	.BYTE 0xD

	.CSEG
;	iWII -> R17

	.DSEG
_0xC3:
	.BYTE 0x7

	.CSEG

	.DSEG
_0xCF:
	.BYTE 0x7

	.CSEG

	.DSEG
_0xDB:
	.BYTE 0x7

	.CSEG

	.DSEG
_0xE9:
	.BYTE 0x1C

	.CSEG

	.DSEG
_0x124:
	.BYTE 0x133
;#include "modules/esp.h"

	.CSEG
_slave_rx_handler:
; .FSTART _slave_rx_handler
	ST   -Y,R26
;	rx_complete -> Y+0
	LDS  R30,_twi_result
	CPI  R30,0
	BRNE _0x146
	SET
	BLD  R2,1
	RJMP _0x147
_0x146:
	CLT
	BLD  R2,1
	LDI  R30,LOW(0)
	JMP  _0x20E0001
_0x147:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x148
	LDI  R30,LOW(0)
	JMP  _0x20E0001
_0x148:
	LDS  R26,_twi_rx_index
	LDI  R30,LOW(15)
	CALL __LTB12U
	JMP  _0x20E0001
; .FEND
_slave_tx_handler:
; .FSTART _slave_tx_handler
	ST   -Y,R26
;	tx_complete -> Y+0
	LD   R30,Y
	CPI  R30,0
	BREQ PC+2
	RJMP _0x149
	LDS  R30,_linesensorvaluetemp
	STS  _tx_buffer,R30
	LDS  R30,_distanzsensorvaluetemp
	__PUTB1MN _tx_buffer,1
	__GETW1MN _adc_data,2
	__PUTW1MN _tx_buffer,2
	__GETW1MN _adc_data,6
	__PUTW1MN _tx_buffer,4
	LDS  R30,_wheelEncoderCounter_left
	LDS  R31,_wheelEncoderCounter_left+1
	__PUTW1MN _tx_buffer,6
	LDS  R30,_wheelEncoderCounter_right
	LDS  R31,_wheelEncoderCounter_right+1
	__PUTW1MN _tx_buffer,8
	LDS  R30,_wiicamobject
	__PUTB1MN _tx_buffer,10
	LDS  R30,_ucData
	__PUTB1MN _tx_buffer,11
	__PUTBMRN _tx_buffer,12,6
	LDS  R30,_iTime
	LDS  R31,_iTime+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4250CCCD
	CALL __DIVF21
	__POINTW2MN _tx_buffer,13
	CALL __CFD1U
	ST   X,R30
	LDS  R30,_iTemp
	__PUTB1MN _tx_buffer,14
	LDI  R30,LOW(15)
	JMP  _0x20E0001
_0x149:
	SBRS R2,1
	RJMP _0x14A
	__GETB1MN _rx_buffer,14
	LDI  R31,0
	STS  _currstate,R30
	STS  _currstate+1,R31
_0x14A:
	LDI  R30,LOW(0)
	JMP  _0x20E0001
; .FEND
_twiinit:
; .FSTART _twiinit
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(80)
	ST   -Y,R30
	LDI  R30,LOW(_rx_buffer)
	LDI  R31,HIGH(_rx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(_tx_buffer)
	LDI  R31,HIGH(_tx_buffer)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(_slave_rx_handler)
	LDI  R31,HIGH(_slave_rx_handler)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_slave_tx_handler)
	LDI  R27,HIGH(_slave_tx_handler)
	CALL _twi_slave_init
	RET
; .FEND
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0044 {
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	CALL SUBOPT_0x0
; 0000 0045   // Reinitialize Timer 1 value
; 0000 0046   TCNT1L=0x9C;
	LDI  R30,LOW(156)
	OUT  0x2C,R30
; 0000 0047   ipwmcounter++;
	LDI  R26,LOW(_ipwmcounter)
	LDI  R27,HIGH(_ipwmcounter)
	CALL SUBOPT_0x1
; 0000 0048 
; 0000 0049   if (ipwmcounter>255)
	CALL SUBOPT_0x6
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x14B
; 0000 004A     ipwmcounter=0;
	LDI  R30,LOW(0)
	STS  _ipwmcounter,R30
	STS  _ipwmcounter+1,R30
; 0000 004B 
; 0000 004C 
; 0000 004D 
; 0000 004E  if(ipwmcounter >= ipwmcompareleft){
_0x14B:
	LDS  R30,_ipwmcompareleft
	LDS  R31,_ipwmcompareleft+1
	CALL SUBOPT_0x6
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x14C
; 0000 004F  ENGINE_ENABLE_LEFT=0;
	CBI  0x1B,3
; 0000 0050   }else{
	RJMP _0x14F
_0x14C:
; 0000 0051   ENGINE_ENABLE_LEFT=1;
	SBI  0x1B,3
; 0000 0052   }
_0x14F:
; 0000 0053 
; 0000 0054  if(ipwmcounter >= ipwmcompareright){
	LDS  R30,_ipwmcompareright
	LDS  R31,_ipwmcompareright+1
	CALL SUBOPT_0x6
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x152
; 0000 0055  ENGINE_ENABLE_RIGHT=0;
	CBI  0x1B,1
; 0000 0056   }else{
	RJMP _0x155
_0x152:
; 0000 0057   ENGINE_ENABLE_RIGHT=1;}
	SBI  0x1B,1
_0x155:
; 0000 0058 }
_0x16F:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;
;void main(void)
; 0000 005C {
_main:
; .FSTART _main
; 0000 005D // Ports initialisieren
; 0000 005E port_init();
	RCALL _port_init
; 0000 005F //Other inits
; 0000 0060 i2c_init();
	CALL _i2c_init
; 0000 0061 wii_cam_init();
	RCALL _wii_cam_init
; 0000 0062 twiinit();
	RCALL _twiinit
; 0000 0063 
; 0000 0064 while (1)
_0x158:
; 0000 0065       {
; 0000 0066       //STATE_MACHINE();
; 0000 0067       ipwmcompareleft=0;
	LDI  R30,LOW(0)
	STS  _ipwmcompareleft,R30
	STS  _ipwmcompareleft+1,R30
; 0000 0068       ipwmcompareright=0;
	STS  _ipwmcompareright,R30
	STS  _ipwmcompareright+1,R30
; 0000 0069 
; 0000 006A       esp_states();
	RCALL _esp_states
; 0000 006B       if (!BUMPER_RIGHT)state=16;
	SBIC 0x19,6
	RJMP _0x15B
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	STS  _state,R30
	STS  _state+1,R31
; 0000 006C       ondata();
_0x15B:
	RCALL _ondata
; 0000 006D       esp_mainfunctions();
	RCALL _esp_mainfunctions
; 0000 006E 
; 0000 006F 
; 0000 0070 
; 0000 0071       }
	RJMP _0x158
; 0000 0072 }
_0x15C:
	RJMP _0x15C
; .FEND

	.CSEG

	.DSEG

	.CSEG

	.CSEG
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

	.DSEG

	.CSEG
_twi_slave_init:
; .FSTART _twi_slave_init
	ST   -Y,R27
	ST   -Y,R26
	SET
	BLD  R2,4
	LDI  R30,LOW(7)
	STS  _twi_result,R30
	LDD  R30,Y+7
	LDD  R31,Y+7+1
	STS  _twi_rx_buffer_G103,R30
	STS  _twi_rx_buffer_G103+1,R31
	LDD  R30,Y+6
	STS  _twi_rx_buffer_size_G103,R30
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	STS  _twi_tx_buffer_G103,R30
	STS  _twi_tx_buffer_G103+1,R31
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	STS  _twi_slave_rx_handler_G103,R30
	STS  _twi_slave_rx_handler_G103+1,R31
	LD   R30,Y
	LDD  R31,Y+1
	STS  _twi_slave_tx_handler_G103,R30
	STS  _twi_slave_tx_handler_G103+1,R31
	SBI  0x12,1
	SBI  0x12,0
	LDD  R30,Y+10
	CPI  R30,0
	BREQ _0x2060012
	LDI  R30,LOW(1)
	RJMP _0x2060066
_0x2060012:
	LDD  R30,Y+9
	LSL  R30
_0x2060066:
	STS  114,R30
	LDS  R30,116
	ANDI R30,LOW(0x80)
	ORI  R30,LOW(0x45)
	STS  116,R30
	ADIW R28,11
	RET
; .FEND
_twi_int_handler:
; .FSTART _twi_int_handler
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
	CALL __SAVELOCR6
	LDS  R17,_twi_rx_index
	LDS  R16,_twi_tx_index
	LDS  R19,_bytes_to_tx_G103
	LDS  R18,_twi_result
	MOV  R30,R17
	LDS  R26,_twi_rx_buffer_G103
	LDS  R27,_twi_rx_buffer_G103+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	MOVW R20,R30
	LDS  R30,113
	ANDI R30,LOW(0xF8)
	CPI  R30,LOW(0x8)
	BRNE _0x2060017
	LDI  R18,LOW(0)
	RJMP _0x2060018
_0x2060017:
	CPI  R30,LOW(0x10)
	BRNE _0x2060019
_0x2060018:
	LDS  R30,_slave_address_G103
	RJMP _0x2060067
_0x2060019:
	CPI  R30,LOW(0x18)
	BREQ _0x206001D
	CPI  R30,LOW(0x28)
	BRNE _0x206001E
_0x206001D:
	CP   R16,R19
	BRSH _0x206001F
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G103
	LDS  R27,_twi_tx_buffer_G103+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
_0x2060067:
	STS  115,R30
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  116,R30
	RJMP _0x2060020
_0x206001F:
	LDS  R30,_bytes_to_rx_G103
	CP   R17,R30
	BRSH _0x2060021
	LDS  R30,_slave_address_G103
	ORI  R30,1
	STS  _slave_address_G103,R30
	CLT
	BLD  R2,3
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xA0)
	STS  116,R30
	RJMP _0x2060016
_0x2060021:
	RJMP _0x2060022
_0x2060020:
	RJMP _0x2060016
_0x206001E:
	CPI  R30,LOW(0x50)
	BRNE _0x2060023
	LDS  R30,115
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2060024
_0x2060023:
	CPI  R30,LOW(0x40)
	BRNE _0x2060025
_0x2060024:
	LDS  R30,_bytes_to_rx_G103
	SUBI R30,LOW(1)
	CP   R17,R30
	BRLO _0x2060026
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x2060068
_0x2060026:
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x2060068:
	STS  116,R30
	RJMP _0x2060016
_0x2060025:
	CPI  R30,LOW(0x58)
	BRNE _0x2060028
	LDS  R30,115
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	RJMP _0x2060029
_0x2060028:
	CPI  R30,LOW(0x20)
	BRNE _0x206002A
_0x2060029:
	RJMP _0x206002B
_0x206002A:
	CPI  R30,LOW(0x30)
	BRNE _0x206002C
_0x206002B:
	RJMP _0x206002D
_0x206002C:
	CPI  R30,LOW(0x48)
	BRNE _0x206002E
_0x206002D:
	CPI  R18,0
	BRNE _0x206002F
	SBRS R2,3
	RJMP _0x2060030
	CP   R16,R19
	BRLO _0x2060032
	RJMP _0x2060033
_0x2060030:
	LDS  R30,_bytes_to_rx_G103
	CP   R17,R30
	BRSH _0x2060034
_0x2060032:
	LDI  R18,LOW(4)
_0x2060034:
_0x2060033:
_0x206002F:
_0x2060022:
	RJMP _0x2060069
_0x206002E:
	CPI  R30,LOW(0x38)
	BRNE _0x2060037
	LDI  R18,LOW(2)
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x206006A
_0x2060037:
	CPI  R30,LOW(0x68)
	BREQ _0x206003A
	CPI  R30,LOW(0x78)
	BRNE _0x206003B
_0x206003A:
	LDI  R18,LOW(2)
	RJMP _0x206003C
_0x206003B:
	CPI  R30,LOW(0x60)
	BREQ _0x206003F
	CPI  R30,LOW(0x70)
	BRNE _0x2060040
_0x206003F:
	LDI  R18,LOW(0)
_0x206003C:
	LDI  R17,LOW(0)
	CLT
	BLD  R2,3
	LDS  R30,_twi_rx_buffer_size_G103
	CPI  R30,0
	BRNE _0x2060041
	LDI  R18,LOW(1)
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	RJMP _0x206006B
_0x2060041:
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
_0x206006B:
	STS  116,R30
	RJMP _0x2060016
_0x2060040:
	CPI  R30,LOW(0x80)
	BREQ _0x2060044
	CPI  R30,LOW(0x90)
	BRNE _0x2060045
_0x2060044:
	SBRS R2,3
	RJMP _0x2060046
	LDI  R18,LOW(1)
	RJMP _0x2060047
_0x2060046:
	LDS  R30,115
	MOVW R26,R20
	ST   X,R30
	SUBI R17,-LOW(1)
	LDS  R30,_twi_rx_buffer_size_G103
	CP   R17,R30
	BRSH _0x2060048
	LDS  R30,_twi_slave_rx_handler_G103
	LDS  R31,_twi_slave_rx_handler_G103+1
	SBIW R30,0
	BRNE _0x2060049
	LDI  R18,LOW(6)
	RJMP _0x2060047
_0x2060049:
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_rx_handler_G103,0
	CPI  R30,0
	BREQ _0x206004A
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  116,R30
	RJMP _0x2060016
_0x206004A:
	RJMP _0x206004B
_0x2060048:
	SET
	BLD  R2,3
_0x206004B:
	RJMP _0x206004C
_0x2060045:
	CPI  R30,LOW(0x88)
	BRNE _0x206004D
_0x206004C:
	RJMP _0x206004E
_0x206004D:
	CPI  R30,LOW(0x98)
	BRNE _0x206004F
_0x206004E:
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
	STS  116,R30
	RJMP _0x2060016
_0x206004F:
	CPI  R30,LOW(0xA0)
	BRNE _0x2060050
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  116,R30
	SET
	BLD  R2,4
	LDS  R30,_twi_slave_rx_handler_G103
	LDS  R31,_twi_slave_rx_handler_G103+1
	SBIW R30,0
	BREQ _0x2060051
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_rx_handler_G103,0
	RJMP _0x2060052
_0x2060051:
	LDI  R18,LOW(6)
_0x2060052:
	RJMP _0x2060016
_0x2060050:
	CPI  R30,LOW(0xB0)
	BRNE _0x2060053
	LDI  R18,LOW(2)
	RJMP _0x2060054
_0x2060053:
	CPI  R30,LOW(0xA8)
	BRNE _0x2060055
_0x2060054:
	LDS  R30,_twi_slave_tx_handler_G103
	LDS  R31,_twi_slave_tx_handler_G103+1
	SBIW R30,0
	BREQ _0x2060056
	LDI  R26,LOW(0)
	__CALL1MN _twi_slave_tx_handler_G103,0
	MOV  R19,R30
	CPI  R30,0
	BREQ _0x2060058
	LDI  R18,LOW(0)
	RJMP _0x2060059
_0x2060056:
_0x2060058:
	LDI  R18,LOW(6)
	RJMP _0x2060047
_0x2060059:
	LDI  R16,LOW(0)
	CLT
	BLD  R2,3
	RJMP _0x206005A
_0x2060055:
	CPI  R30,LOW(0xB8)
	BRNE _0x206005B
_0x206005A:
	SBRS R2,3
	RJMP _0x206005C
	LDI  R18,LOW(1)
	RJMP _0x2060047
_0x206005C:
	MOV  R30,R16
	SUBI R16,-1
	LDS  R26,_twi_tx_buffer_G103
	LDS  R27,_twi_tx_buffer_G103+1
	LDI  R31,0
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	STS  115,R30
	CP   R16,R19
	BRSH _0x206005D
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	RJMP _0x206006C
_0x206005D:
	SET
	BLD  R2,3
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,0x80
_0x206006C:
	STS  116,R30
	RJMP _0x2060016
_0x206005B:
	CPI  R30,LOW(0xC0)
	BREQ _0x2060060
	CPI  R30,LOW(0xC8)
	BRNE _0x2060061
_0x2060060:
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xC0)
	STS  116,R30
	LDS  R30,_twi_slave_tx_handler_G103
	LDS  R31,_twi_slave_tx_handler_G103+1
	SBIW R30,0
	BREQ _0x2060062
	LDI  R26,LOW(1)
	__CALL1MN _twi_slave_tx_handler_G103,0
_0x2060062:
	RJMP _0x2060035
_0x2060061:
	CPI  R30,0
	BRNE _0x2060016
	LDI  R18,LOW(3)
_0x2060047:
_0x2060069:
	LDS  R30,116
	ANDI R30,LOW(0xF)
	ORI  R30,LOW(0xD0)
_0x206006A:
	STS  116,R30
_0x2060035:
	SET
	BLD  R2,4
_0x2060016:
	STS  _twi_rx_index,R17
	STS  _twi_tx_index,R16
	STS  _twi_result,R18
	STS  _bytes_to_tx_G103,R19
	CALL __LOADLOCR6
	ADIW R28,6
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
; .FEND
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G104:
; .FSTART __lcd_delay_G104
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
; .FEND
__lcd_ready:
; .FSTART __lcd_ready
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G104
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G104
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G104
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G104
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
; .FEND
__lcd_write_nibble_G104:
; .FSTART __lcd_write_nibble_G104
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G104
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G104
	RET
; .FEND
__lcd_write_data:
; .FSTART __lcd_write_data
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G104
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G104
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20E0001
; .FEND
__lcd_read_nibble_G104:
; .FSTART __lcd_read_nibble_G104
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G104
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G104
    andi  r30,0xf0
	RET
; .FEND
_lcd_read_byte0_G104:
; .FSTART _lcd_read_byte0_G104
	CALL __lcd_delay_G104
	RCALL __lcd_read_nibble_G104
    mov   r26,r30
	RCALL __lcd_read_nibble_G104
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
; .FEND
_lcd_clear:
; .FSTART _lcd_clear
	CALL __lcd_ready
	LDI  R26,LOW(2)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(12)
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R26,LOW(1)
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
; .FEND
__long_delay_G104:
; .FSTART __long_delay_G104
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
; .FEND
__lcd_init_write_G104:
; .FSTART __lcd_init_write_G104
	ST   -Y,R26
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G104
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20E0001
; .FEND
_lcd_init:
; .FSTART _lcd_init
	ST   -Y,R26
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G104,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G104,3
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	CALL SUBOPT_0x7
	RCALL __long_delay_G104
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G104
	RCALL __long_delay_G104
	LDI  R26,LOW(40)
	CALL SUBOPT_0x8
	LDI  R26,LOW(4)
	CALL SUBOPT_0x8
	LDI  R26,LOW(133)
	CALL SUBOPT_0x8
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G104
	CPI  R30,LOW(0x5)
	BREQ _0x208000B
	LDI  R30,LOW(0)
	RJMP _0x20E0001
_0x208000B:
	CALL __lcd_ready
	LDI  R26,LOW(6)
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x20E0001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG

	.DSEG
_twi_tx_index:
	.BYTE 0x1
_twi_rx_index:
	.BYTE 0x1
_twi_result:
	.BYTE 0x1
_strTemp:
	.BYTE 0x11
_engine_dir:
	.BYTE 0x2
_wiicamobject:
	.BYTE 0x2
_str:
	.BYTE 0x11
_currstate:
	.BYTE 0x2
_state:
	.BYTE 0x2
_line_left:
	.BYTE 0x2
_line_mleft:
	.BYTE 0x2
_line_mright:
	.BYTE 0x2
_line_right:
	.BYTE 0x2
_dist_left:
	.BYTE 0x2
_dist_fleft:
	.BYTE 0x2
_dist_fright:
	.BYTE 0x2
_dist_right:
	.BYTE 0x2
_linesensorvaluetemp:
	.BYTE 0x2
_distanzsensorvaluetemp:
	.BYTE 0x2
_ipwmcounter:
	.BYTE 0x2
_ipwmcompareleft:
	.BYTE 0x2
_ipwmcompareright:
	.BYTE 0x2
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
_iTemp:
	.BYTE 0x2
_rx_buffer:
	.BYTE 0xF
_tx_buffer:
	.BYTE 0xF
_strULTRA:
	.BYTE 0x11
_iRisingEdge:
	.BYTE 0x2
_iFallingEdge:
	.BYTE 0x2
_iTime:
	.BYTE 0x2
_icr3:
	.BYTE 0x2
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
_adc_data:
	.BYTE 0xC
_input_index_S0000000000:
	.BYTE 0x1
_wheelEncoderCounter_left:
	.BYTE 0x2
_wheelEncoderCounter_right:
	.BYTE 0x2
__seed_G100:
	.BYTE 0x4
_slave_address_G103:
	.BYTE 0x1
_twi_tx_buffer_G103:
	.BYTE 0x2
_bytes_to_tx_G103:
	.BYTE 0x1
_twi_rx_buffer_G103:
	.BYTE 0x2
_bytes_to_rx_G103:
	.BYTE 0x1
_twi_rx_buffer_size_G103:
	.BYTE 0x1
_twi_slave_rx_handler_G103:
	.BYTE 0x2
_twi_slave_tx_handler_G103:
	.BYTE 0x2
__base_y_G104:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x0:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDS  R30,_tmp
	LDS  R31,_tmp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDS  R26,_currstate
	LDS  R27,_currstate+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	__ADDWRR 22,23,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R26,_ipwmcounter
	LDS  R27,_ipwmcounter+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	CALL __long_delay_G104
	LDI  R26,LOW(48)
	JMP  __lcd_init_write_G104

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	CALL __lcd_write_data
	JMP  __long_delay_G104


	.CSEG
	.equ __sda_bit=5
	.equ __scl_bit=3
	.equ __i2c_port=0x18 ;PORTB
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
	mov  r23,r26
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
	ldi  r23,8
__i2c_write0:
	lsl  r26
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
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LTB12U:
	CP   R26,R30
	LDI  R30,1
	BRLO __LTB12U1
	CLR  R30
__LTB12U1:
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
