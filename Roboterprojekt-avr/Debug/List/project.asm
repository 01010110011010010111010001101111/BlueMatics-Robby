
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
	.DB  0x13
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
	.DB  0x20,0x20,0x32,0x6E,0x64,0x20,0x53,0x54
	.DB  0x41,0x54,0x45,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x20,0x33,0x72,0x64,0x20
	.DB  0x53,0x54,0x41,0x54,0x45,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x42,0x6C,0x75
	.DB  0x65,0x4D,0x61,0x74,0x69,0x63,0x73,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x52,0x6F,0x62
	.DB  0x62,0x79,0x0,0x4F,0x4B,0x0,0x42,0x75
	.DB  0x66,0x66,0x65,0x72,0x20,0x6F,0x76,0x65
	.DB  0x72,0x66,0x6C,0x6F,0x77,0x0,0x41,0x72
	.DB  0x62,0x69,0x74,0x72,0x61,0x74,0x69,0x6F
	.DB  0x6E,0x20,0x6C,0x6F,0x73,0x74,0x0,0x42
	.DB  0x75,0x73,0x20,0x65,0x72,0x72,0x6F,0x72
	.DB  0x0,0x4E,0x41,0x43,0x4B,0x20,0x72,0x65
	.DB  0x63,0x65,0x69,0x76,0x65,0x64,0x0,0x42
	.DB  0x75,0x73,0x20,0x74,0x69,0x6D,0x65,0x6F
	.DB  0x75,0x74,0x0,0x46,0x61,0x69,0x6C,0x0
	.DB  0x55,0x6E,0x6B,0x6E,0x6F,0x77,0x6E,0x20
	.DB  0x65,0x72,0x72,0x6F,0x72,0x0
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
	.DW  _0x5D
	.DW  _0x0*2+92

	.DW  0x11
	.DW  _0x5D+17
	.DW  _0x0*2+109

	.DW  0x03
	.DW  _0x5D+34
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0x5D+37
	.DW  _0x0*2+129

	.DW  0x10
	.DW  _0x69
	.DW  _0x0*2+133

	.DW  0x0F
	.DW  _0x69+16
	.DW  _0x0*2+149

	.DW  0x03
	.DW  _0x69+31
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0x69+34
	.DW  _0x0*2+129

	.DW  0x08
	.DW  _0x75
	.DW  _0x0*2+20

	.DW  0x08
	.DW  _0x75+8
	.DW  _0x0*2+28

	.DW  0x0A
	.DW  _0x75+16
	.DW  _0x0*2+36

	.DW  0x0A
	.DW  _0x75+26
	.DW  _0x0*2+46

	.DW  0x09
	.DW  _0x75+36
	.DW  _0x0*2+164

	.DW  0x09
	.DW  _0x75+45
	.DW  _0x0*2+173

	.DW  0x09
	.DW  _0x75+54
	.DW  _0x0*2+182

	.DW  0x09
	.DW  _0x75+63
	.DW  _0x0*2+191

	.DW  0x06
	.DW  _0x7D
	.DW  _0x0*2+200

	.DW  0x07
	.DW  _0x7D+6
	.DW  _0x0*2+206

	.DW  0x03
	.DW  _0xA7
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xA7+3
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xAF
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xAF+3
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0x1E1
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0x1E1+3
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0x1EB
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0x1EB+3
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0x1EB+7
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0x1EB+10
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0x1EB+14
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0x1EB+17
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0x1EB+21
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0x1EB+24
	.DW  _0x0*2+129

	.DW  0x11
	.DW  _0x216
	.DW  _0x0*2+252

	.DW  0x10
	.DW  _0x216+17
	.DW  _0x0*2+269

	.DW  0x12
	.DW  _0x216+33
	.DW  _0x0*2+285

	.DW  0x11
	.DW  _0x216+51
	.DW  _0x0*2+303

	.DW  0x11
	.DW  _0x216+68
	.DW  _0x0*2+320

	.DW  0x10
	.DW  _0x216+85
	.DW  _0x0*2+337

	.DW  0x11
	.DW  _0x216+101
	.DW  _0x0*2+353

	.DW  0x0F
	.DW  _0x216+118
	.DW  _0x0*2+370

	.DW  0x10
	.DW  _0x216+133
	.DW  _0x0*2+385

	.DW  0x10
	.DW  _0x216+149
	.DW  _0x0*2+401

	.DW  0x12
	.DW  _0x216+165
	.DW  _0x0*2+417

	.DW  0x11
	.DW  _0x216+183
	.DW  _0x0*2+435

	.DW  0x10
	.DW  _0x216+200
	.DW  _0x0*2+452

	.DW  0x12
	.DW  _0x216+216
	.DW  _0x0*2+468

	.DW  0x11
	.DW  _0x216+234
	.DW  _0x0*2+486

	.DW  0x0D
	.DW  _0x216+251
	.DW  _0x0*2+503

	.DW  0x12
	.DW  _0x216+264
	.DW  _0x0*2+516

	.DW  0x12
	.DW  _0x216+282
	.DW  _0x0*2+534

	.DW  0x12
	.DW  _0x216+300
	.DW  _0x0*2+552

	.DW  0x0E
	.DW  _0x216+318
	.DW  _0x0*2+570

	.DW  0x0B
	.DW  _0x216+332
	.DW  _0x0*2+584

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
;#define state_2  17
;#define state_3  18
;#define state_stop 19
;
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
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x4E20)
	LDI  R30,HIGH(0x4E20)
	CPC  R27,R30
	BRGE _0x6
	LDI  R26,LOW(_wheelEncoderCounter_right)
	LDI  R27,HIGH(_wheelEncoderCounter_right)
	CALL SUBOPT_0x2
	RJMP _0x7
_0x6:
	CALL SUBOPT_0x3
_0x7:
	RJMP _0x26B
; .FEND
_ext_int6_isr:
; .FSTART _ext_int6_isr
	CALL SUBOPT_0x0
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x4E20)
	LDI  R30,HIGH(0x4E20)
	CPC  R27,R30
	BRGE _0x8
	LDI  R26,LOW(_wheelEncoderCounter_left)
	LDI  R27,HIGH(_wheelEncoderCounter_left)
	CALL SUBOPT_0x2
	RJMP _0x9
_0x8:
	CALL SUBOPT_0x5
_0x9:
	RJMP _0x26B
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
	LDI  R30,LOW(84)
	OUT  0x2,R30
	LDI  R30,LOW(32)
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
	CALL SUBOPT_0x6
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
	CALL SUBOPT_0x6
	SBIW R30,0
	BREQ _0x11
	LDS  R26,_rc5_time
	CPI  R26,LOW(0x2D)
	BRLO _0x10
_0x11:
	__GETB1MN _tmp,1
	ANDI R30,LOW(0x40)
	BRNE _0x13
	CALL SUBOPT_0x6
	LSL  R30
	ROL  R31
	STS  _tmp,R30
	STS  _tmp+1,R31
_0x13:
	SBRC R2,0
	RJMP _0x14
	CALL SUBOPT_0x6
	ORI  R30,1
	STS  _tmp,R30
	STS  _tmp+1,R31
_0x14:
	LDI  R30,LOW(0)
	STS  _rc5_time,R30
_0x10:
_0xE:
	RJMP _0x26B
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
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20E0003
_0x15:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	LDD  R17,Y+1
	LDD  R16,Y+0
	RJMP _0x20E0003
; .FEND
_rc5_display:
; .FSTART _rc5_display
	CALL _lcd_clear
	__POINTW2MN _0x17,0
	CALL SUBOPT_0x7
	LDS  R26,_ucToggle
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
	LDI  R26,LOW(32)
	CALL _lcd_putchar
	LDS  R30,_ucAdress
	CALL SUBOPT_0x8
	LDI  R26,LOW(32)
	CALL _lcd_putchar
	LDS  R30,_ucData
	CALL SUBOPT_0x8
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
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	RJMP _0x252
_0x1C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1D
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	RJMP _0x252
_0x1D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1B
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
_0x252:
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
_fnDisplay:
; .FSTART _fnDisplay
	SBIW R28,10
;	str -> Y+0
	CALL _lcd_clear
	__POINTW2MN _0x27,0
	CALL SUBOPT_0x7
	MOVW R30,R6
	SUBI R30,LOW(170)
	SBCI R31,HIGH(170)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_strTemp)
	LDI  R27,HIGH(_strTemp)
	CALL _itoa
	LDI  R26,LOW(_strTemp)
	LDI  R27,HIGH(_strTemp)
	CALL _lcd_puts
	RJMP _0x20E0007
; .FEND

	.DSEG
_0x27:
	.BYTE 0xF
;#include "modules/esp_main_func.h"

	.CSEG
_esp_states:
; .FSTART _esp_states
	CALL SUBOPT_0x9
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
	CALL SUBOPT_0x9
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
	CALL SUBOPT_0x9
	SBIW R26,0
	BRNE _0x2C
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	RJMP _0x253
_0x2C:
	LDS  R30,_currstate
	LDS  R31,_currstate+1
	SBIW R30,1
_0x253:
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
	RJMP _0x254
_0x2F:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x254:
	STS  _line_left,R30
	STS  _line_left+1,R31
	SBIC 0x0,2
	RJMP _0x32
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x255
_0x32:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x255:
	STS  _line_mleft,R30
	STS  _line_mleft+1,R31
	SBIC 0x0,4
	RJMP _0x35
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x256
_0x35:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x256:
	STS  _line_mright,R30
	STS  _line_mright+1,R31
	SBIC 0x0,6
	RJMP _0x38
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x257
_0x38:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x257:
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
	CALL SUBOPT_0xA
	LDS  R30,_line_mright
	LDS  R31,_line_mright+1
	CALL SUBOPT_0xB
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
	RJMP _0x258
_0x3B:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x258:
	STS  _dist_left,R30
	STS  _dist_left+1,R31
	SBIC 0x16,2
	RJMP _0x3E
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x259
_0x3E:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x259:
	STS  _dist_fleft,R30
	STS  _dist_fleft+1,R31
	SBIC 0x16,4
	RJMP _0x41
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x25A
_0x41:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x25A:
	STS  _dist_fright,R30
	STS  _dist_fright+1,R31
	SBIC 0x16,6
	RJMP _0x44
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x25B
_0x44:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x25B:
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
	CALL SUBOPT_0xA
	LDS  R30,_dist_fright
	LDS  R31,_dist_fright+1
	CALL SUBOPT_0xB
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
	RJMP _0x20E0005
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
_readData:
; .FSTART _readData
	ST   -Y,R17
;	i -> R17
	LDI  R17,0
	CALL _i2c_start
	LDI  R26,LOW(176)
	CALL _i2c_write
	LDI  R26,LOW(54)
	CALL _i2c_write
	CALL _i2c_stop
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	CALL _i2c_start
	LDI  R26,LOW(177)
	CALL _i2c_write
	LDI  R17,LOW(0)
_0x48:
	CPI  R17,15
	BRSH _0x49
	MOV  R30,R17
	LDI  R26,LOW(_data)
	LDI  R27,HIGH(_data)
	LDI  R31,0
	CALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	LDI  R26,LOW(1)
	CALL _i2c_read
	POP  R26
	POP  R27
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
	SUBI R17,-1
	RJMP _0x48
_0x49:
	LDI  R26,LOW(0)
	CALL _i2c_read
	__POINTW2MN _data,30
	LDI  R31,0
	ST   X+,R30
	ST   X,R31
	CALL _i2c_stop
	RJMP _0x20E0006
; .FEND
_convertdata:
; .FSTART _convertdata
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
	__GETWRN 16,17,0
_0x4B:
	__CPWRN 16,17,4
	BRLT PC+2
	RJMP _0x4C
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	ANDI R30,LOW(0x30)
	ANDI R31,HIGH(0x30)
	CALL __LSLW4
	STS  _temp,R30
	STS  _temp+1,R31
	MOVW R30,R16
	LDI  R26,LOW(_x)
	LDI  R27,HIGH(_x)
	CALL SUBOPT_0xC
	MOVW R22,R30
	CALL SUBOPT_0xD
	MOVW R26,R30
	LSL  R26
	ROL  R27
	__ADDW2MN _data,2
	CALL SUBOPT_0xF
	CALL SUBOPT_0xD
	CALL SUBOPT_0xE
	ANDI R30,LOW(0xC0)
	ANDI R31,HIGH(0xC0)
	CALL __LSLW2
	STS  _temp,R30
	STS  _temp+1,R31
	MOVW R30,R16
	LDI  R26,LOW(_y)
	LDI  R27,HIGH(_y)
	CALL SUBOPT_0xC
	MOVW R22,R30
	CALL SUBOPT_0xD
	MOVW R26,R30
	LSL  R26
	ROL  R27
	__ADDW2MN _data,4
	CALL SUBOPT_0xF
	MOVW R30,R16
	SUBI R30,LOW(-_sWIICAM)
	SBCI R31,HIGH(-_sWIICAM)
	MOVW R22,R30
	CALL SUBOPT_0xD
	MOVW R26,R30
	LSL  R26
	ROL  R27
	__ADDW2MN _data,6
	LD   R30,X
	ANDI R30,LOW(0xF)
	MOVW R26,R22
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0x4B
_0x4C:
	LD   R16,Y+
	LD   R17,Y+
	RET
; .FEND
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
_0x26B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
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
_STATE_LINE_SENSOR:
; .FSTART _STATE_LINE_SENSOR
	CALL _lcd_clear
	SBIC 0x0,0
	RJMP _0x53
	__POINTW2MN _0x54,0
	RJMP _0x25C
_0x53:
	__POINTW2MN _0x54,8
_0x25C:
	CALL _lcd_puts
	SBIC 0x0,6
	RJMP _0x56
	__POINTW2MN _0x54,16
	RJMP _0x25D
_0x56:
	__POINTW2MN _0x54,26
_0x25D:
	CALL _lcd_puts
	CALL SUBOPT_0x10
	SBIC 0x0,2
	RJMP _0x58
	__POINTW2MN _0x54,36
	RJMP _0x25E
_0x58:
	__POINTW2MN _0x54,45
_0x25E:
	CALL _lcd_puts
	SBIC 0x0,4
	RJMP _0x5A
	__POINTW2MN _0x54,54
	RJMP _0x25F
_0x5A:
	__POINTW2MN _0x54,63
_0x25F:
	CALL _lcd_puts
	RET
; .FEND

	.DSEG
_0x54:
	.BYTE 0x48

	.CSEG
_STATE_ENGINE:
; .FSTART _STATE_ENGINE
	SBIW R28,17
;	str -> Y+0
	CALL SUBOPT_0x11
	BRNE _0x5C
	__POINTW2MN _0x5D,0
	CALL _lcd_puts
	CBI  0x1B,7
	CBI  0x1B,5
	RJMP _0x62
_0x5C:
	__POINTW2MN _0x5D,17
	CALL _lcd_puts
	SBI  0x1B,7
	SBI  0x1B,5
_0x62:
	CALL SUBOPT_0x10
	__POINTW2MN _0x5D,34
	CALL SUBOPT_0x12
	__POINTW2MN _0x5D,37
	CALL SUBOPT_0x13
	SBIC 0x19,6
	RJMP _0x67
	CALL SUBOPT_0x14
_0x67:
	ADIW R28,17
	RET
; .FEND

	.DSEG
_0x5D:
	.BYTE 0x29

	.CSEG
_STATE_ENGINE_DIR:
; .FSTART _STATE_ENGINE_DIR
	SBIW R28,10
;	str -> Y+0
	CALL SUBOPT_0x11
	BRNE _0x68
	__POINTW2MN _0x69,0
	CALL _lcd_puts
	CBI  0x1B,7
	SBI  0x1B,5
	RJMP _0x6E
_0x68:
	__POINTW2MN _0x69,16
	CALL _lcd_puts
	SBI  0x1B,7
	CBI  0x1B,5
_0x6E:
	CALL SUBOPT_0x10
	__POINTW2MN _0x69,31
	CALL SUBOPT_0x12
	__POINTW2MN _0x69,34
	CALL SUBOPT_0x13
	SBIC 0x19,6
	RJMP _0x73
	CALL SUBOPT_0x14
_0x73:
_0x20E0007:
	ADIW R28,10
	RET
; .FEND

	.DSEG
_0x69:
	.BYTE 0x26

	.CSEG
_STATE_DISTANCE_SENSOR:
; .FSTART _STATE_DISTANCE_SENSOR
	CALL _lcd_clear
	SBIC 0x16,0
	RJMP _0x74
	__POINTW2MN _0x75,0
	RJMP _0x260
_0x74:
	__POINTW2MN _0x75,8
_0x260:
	CALL _lcd_puts
	SBIC 0x16,6
	RJMP _0x77
	__POINTW2MN _0x75,16
	RJMP _0x261
_0x77:
	__POINTW2MN _0x75,26
_0x261:
	CALL _lcd_puts
	CALL SUBOPT_0x10
	SBIC 0x16,2
	RJMP _0x79
	__POINTW2MN _0x75,36
	RJMP _0x262
_0x79:
	__POINTW2MN _0x75,45
_0x262:
	CALL _lcd_puts
	SBIC 0x16,4
	RJMP _0x7B
	__POINTW2MN _0x75,54
	RJMP _0x263
_0x7B:
	__POINTW2MN _0x75,63
_0x263:
	CALL _lcd_puts
	RET
; .FEND

	.DSEG
_0x75:
	.BYTE 0x48

	.CSEG
_STATE_LIGHTSENSOR:
; .FSTART _STATE_LIGHTSENSOR
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
	__POINTW2MN _0x7D,0
	CALL _lcd_puts
	ST   -Y,R19
	ST   -Y,R18
	CALL SUBOPT_0x15
	CALL SUBOPT_0x7
	__POINTW2MN _0x7D,6
	CALL _lcd_puts
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x15
	CALL _lcd_puts
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; .FEND

	.DSEG
_0x7D:
	.BYTE 0xD

	.CSEG
_STATE_WIICAM:
; .FSTART _STATE_WIICAM
	ST   -Y,R17
;	iWII -> R17
	LDI  R17,0
	RCALL _readData
	RCALL _convertdata
	CALL _lcd_clear
	LDI  R17,LOW(0)
_0x7F:
	CPI  R17,4
	BRLO PC+2
	RJMP _0x80
	CPI  R17,2
	BRSH _0x81
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x3FF)
	LDI  R26,HIGH(0x3FF)
	CPC  R31,R26
	BREQ _0x83
	CALL SUBOPT_0x17
	CPI  R30,LOW(0x3FF)
	LDI  R26,HIGH(0x3FF)
	CPC  R31,R26
	BRNE _0x82
_0x83:
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	RJMP _0x85
_0x82:
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1C
	LDI  R26,LOW(20)
	MULS R17,R26
	MOVW R30,R0
	SUBI R30,-LOW(8)
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1E
	LDI  R26,LOW(20)
	MULS R17,R26
	MOVW R30,R0
	SUBI R30,-LOW(16)
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1F
_0x85:
	RJMP _0x86
_0x81:
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x3FF)
	LDI  R26,HIGH(0x3FF)
	CPC  R31,R26
	BREQ _0x88
	CALL SUBOPT_0x17
	CPI  R30,LOW(0x3FF)
	LDI  R26,HIGH(0x3FF)
	CPC  R31,R26
	BRNE _0x87
_0x88:
	CALL SUBOPT_0x20
	CALL SUBOPT_0x19
	RJMP _0x8A
_0x87:
	CALL SUBOPT_0x16
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1C
	MOV  R30,R17
	SUBI R30,LOW(2)
	LDI  R26,LOW(20)
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(8)
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1E
	MOV  R30,R17
	SUBI R30,LOW(2)
	LDI  R26,LOW(20)
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(16)
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1F
_0x8A:
_0x86:
	SUBI R17,-1
	RJMP _0x7F
_0x80:
	LDI  R26,LOW(30)
	LDI  R27,0
	CALL _delay_ms
	SBIS 0x18,3
	RJMP _0x8B
	CBI  0x18,3
	RJMP _0x8C
_0x8B:
	SBI  0x18,3
_0x8C:
_0x20E0006:
	LD   R17,Y+
	RET
; .FEND
_STATE_IRTOWER:
; .FSTART _STATE_IRTOWER
	RCALL _rc5_display
	RET
; .FEND
_STATE_SERVO:
; .FSTART _STATE_SERVO
	CALL _lcd_clear
	RCALL _fnDisplay
	LDI  R26,LOW(200)
_0x20E0005:
	LDI  R27,0
	CALL _delay_ms
	RET
; .FEND
_STATE_ULTRASONIC:
; .FSTART _STATE_ULTRASONIC
	SBRS R2,2
	RJMP _0x8D
	CALL SUBOPT_0x10
	LDS  R26,_iTime
	LDS  R27,_iTime+1
	CPI  R26,LOW(0x1771)
	LDI  R30,HIGH(0x1771)
	CPC  R27,R30
	BRSH _0x8E
	CALL _lcd_clear
	__POINTW2FN _0x0,224
	CALL _lcd_putsf
	CALL SUBOPT_0x10
	CALL SUBOPT_0x22
	CALL __CFD1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_strULTRA)
	LDI  R27,HIGH(_strULTRA)
	CALL _itoa
	LDI  R26,LOW(_strULTRA)
	LDI  R27,HIGH(_strULTRA)
	CALL _lcd_puts
	RJMP _0x8F
_0x8E:
	CALL _lcd_clear
	__POINTW2FN _0x0,240
	CALL _lcd_putsf
_0x8F:
	CLT
	BLD  R2,2
_0x8D:
	RET
; .FEND
_STATE_VOR:
; .FSTART _STATE_VOR
	CALL SUBOPT_0x23
	RJMP _0x20E0004
; .FEND
_STATE_ZUR:
; .FSTART _STATE_ZUR
	CALL SUBOPT_0x23
	SBI  0x1B,7
	SBI  0x1B,5
	RET
; .FEND
_STATE_LINKS:
; .FSTART _STATE_LINKS
	CALL SUBOPT_0x24
	RJMP _0x20E0004
; .FEND
_STATE_RECHTS:
; .FSTART _STATE_RECHTS
	CALL SUBOPT_0x25
_0x20E0004:
	CBI  0x1B,7
	CBI  0x1B,5
	RET
; .FEND
_STATE_90RECHTS:
; .FSTART _STATE_90RECHTS
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3
_0xA1:
	CALL SUBOPT_0x24
	CALL SUBOPT_0x26
	__POINTW2MN _0xA7,0
	CALL SUBOPT_0x27
	__POINTW2MN _0xA7,3
	CALL SUBOPT_0x28
	CALL SUBOPT_0x1
	SBIW R26,17
	BRLT _0xA1
	RET
; .FEND

	.DSEG
_0xA7:
	.BYTE 0x7

	.CSEG
_STATE_90LINKS:
; .FSTART _STATE_90LINKS
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3
_0xA9:
	CALL SUBOPT_0x25
	CALL SUBOPT_0x29
	__POINTW2MN _0xAF,0
	CALL SUBOPT_0x27
	__POINTW2MN _0xAF,3
	CALL SUBOPT_0x28
	CALL SUBOPT_0x4
	SBIW R26,17
	BRLT _0xA9
	RET
; .FEND

	.DSEG
_0xAF:
	.BYTE 0x7

	.CSEG
_movement:
; .FSTART _movement
	ST   -Y,R27
	ST   -Y,R26
;	left -> Y+6
;	right -> Y+4
;	dir_left -> Y+2
;	dir_right -> Y+0
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	STS  _ipwmcompareleft,R30
	STS  _ipwmcompareleft+1,R31
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	STS  _ipwmcompareright,R30
	STS  _ipwmcompareright+1,R31
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0xB0
	CBI  0x1B,7
	RJMP _0xB1
_0xB0:
	SBI  0x1B,7
_0xB1:
	LD   R30,Y
	CPI  R30,0
	BRNE _0xB2
	CBI  0x1B,5
	RJMP _0xB3
_0xB2:
	SBI  0x1B,5
_0xB3:
_0x20E0003:
	ADIW R28,8
	RET
; .FEND
_detector:
; .FSTART _detector
	SBIS 0x19,4
	RJMP _0xB5
	SBIS 0x19,6
	RJMP _0xB5
	SBIS 0x16,0
	RJMP _0xB5
	SBIS 0x16,6
	RJMP _0xB5
	SBIS 0x16,2
	RJMP _0xB5
	SBIC 0x16,4
	RJMP _0xB6
_0xB5:
	RJMP _0xB4
_0xB6:
	LDI  R30,LOW(0)
	STS  _detector_value,R30
	STS  _detector_value+1,R30
_0xB4:
	SBIS 0x19,4
	RJMP _0xB8
	SBIS 0x19,6
	RJMP _0xB8
	SBIS 0x16,0
	RJMP _0xB8
	SBIS 0x16,6
	RJMP _0xB8
	SBIS 0x16,2
	RJMP _0xB8
	SBIS 0x16,4
	RJMP _0xB9
_0xB8:
	RJMP _0xB7
_0xB9:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x2A
_0xB7:
	SBIS 0x19,4
	RJMP _0xBB
	SBIS 0x19,6
	RJMP _0xBB
	SBIS 0x16,0
	RJMP _0xBB
	SBIS 0x16,6
	RJMP _0xBB
	SBIC 0x16,2
	RJMP _0xBB
	SBIC 0x16,4
	RJMP _0xBC
_0xBB:
	RJMP _0xBA
_0xBC:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x2A
_0xBA:
	SBIS 0x19,4
	RJMP _0xBE
	SBIS 0x19,6
	RJMP _0xBE
	SBIS 0x16,0
	RJMP _0xBE
	SBIC 0x16,6
	RJMP _0xBE
	SBIS 0x16,2
	RJMP _0xBE
	SBIC 0x16,4
	RJMP _0xBF
_0xBE:
	RJMP _0xBD
_0xBF:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x2A
_0xBD:
	SBIS 0x19,4
	RJMP _0xC1
	SBIS 0x19,6
	RJMP _0xC1
	SBIC 0x16,0
	RJMP _0xC1
	SBIS 0x16,6
	RJMP _0xC1
	SBIS 0x16,2
	RJMP _0xC1
	SBIC 0x16,4
	RJMP _0xC2
_0xC1:
	RJMP _0xC0
_0xC2:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x2A
_0xC0:
	SBIS 0x19,4
	RJMP _0xC4
	SBIC 0x19,6
	RJMP _0xC4
	SBIS 0x16,0
	RJMP _0xC4
	SBIS 0x16,6
	RJMP _0xC4
	SBIS 0x16,2
	RJMP _0xC4
	SBIC 0x16,4
	RJMP _0xC5
_0xC4:
	RJMP _0xC3
_0xC5:
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x2A
_0xC3:
	SBIC 0x19,4
	RJMP _0xC7
	SBIS 0x19,6
	RJMP _0xC7
	SBIS 0x16,0
	RJMP _0xC7
	SBIS 0x16,6
	RJMP _0xC7
	SBIS 0x16,2
	RJMP _0xC7
	SBIC 0x16,4
	RJMP _0xC8
_0xC7:
	RJMP _0xC6
_0xC8:
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x2A
_0xC6:
	SBIS 0x19,4
	RJMP _0xCA
	SBIS 0x19,6
	RJMP _0xCA
	SBIS 0x16,0
	RJMP _0xCA
	SBIS 0x16,6
	RJMP _0xCA
	SBIC 0x16,2
	RJMP _0xCA
	SBIS 0x16,4
	RJMP _0xCB
_0xCA:
	RJMP _0xC9
_0xCB:
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x2A
_0xC9:
	SBIS 0x19,4
	RJMP _0xCD
	SBIS 0x19,6
	RJMP _0xCD
	SBIS 0x16,0
	RJMP _0xCD
	SBIC 0x16,6
	RJMP _0xCD
	SBIC 0x16,2
	RJMP _0xCD
	SBIC 0x16,4
	RJMP _0xCE
_0xCD:
	RJMP _0xCC
_0xCE:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x2A
_0xCC:
	SBIS 0x19,4
	RJMP _0xD0
	SBIS 0x19,6
	RJMP _0xD0
	SBIC 0x16,0
	RJMP _0xD0
	SBIC 0x16,6
	RJMP _0xD0
	SBIS 0x16,2
	RJMP _0xD0
	SBIC 0x16,4
	RJMP _0xD1
_0xD0:
	RJMP _0xCF
_0xD1:
	LDI  R30,LOW(9)
	LDI  R31,HIGH(9)
	CALL SUBOPT_0x2A
_0xCF:
	SBIS 0x19,4
	RJMP _0xD3
	SBIC 0x19,6
	RJMP _0xD3
	SBIC 0x16,0
	RJMP _0xD3
	SBIS 0x16,6
	RJMP _0xD3
	SBIS 0x16,2
	RJMP _0xD3
	SBIC 0x16,4
	RJMP _0xD4
_0xD3:
	RJMP _0xD2
_0xD4:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x2A
_0xD2:
	SBIC 0x19,4
	RJMP _0xD6
	SBIC 0x19,6
	RJMP _0xD6
	SBIS 0x16,0
	RJMP _0xD6
	SBIS 0x16,6
	RJMP _0xD6
	SBIS 0x16,2
	RJMP _0xD6
	SBIC 0x16,4
	RJMP _0xD7
_0xD6:
	RJMP _0xD5
_0xD7:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x2A
_0xD5:
	SBIS 0x19,4
	RJMP _0xD9
	SBIS 0x19,6
	RJMP _0xD9
	SBIS 0x16,0
	RJMP _0xD9
	SBIC 0x16,6
	RJMP _0xD9
	SBIC 0x16,2
	RJMP _0xD9
	SBIS 0x16,4
	RJMP _0xDA
_0xD9:
	RJMP _0xD8
_0xDA:
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	CALL SUBOPT_0x2A
_0xD8:
	SBIS 0x19,4
	RJMP _0xDC
	SBIS 0x19,6
	RJMP _0xDC
	SBIC 0x16,0
	RJMP _0xDC
	SBIC 0x16,6
	RJMP _0xDC
	SBIC 0x16,2
	RJMP _0xDC
	SBIC 0x16,4
	RJMP _0xDD
_0xDC:
	RJMP _0xDB
_0xDD:
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	CALL SUBOPT_0x2A
_0xDB:
	SBIS 0x19,4
	RJMP _0xDF
	SBIC 0x19,6
	RJMP _0xDF
	SBIC 0x16,0
	RJMP _0xDF
	SBIC 0x16,6
	RJMP _0xDF
	SBIS 0x16,2
	RJMP _0xDF
	SBIC 0x16,4
	RJMP _0xE0
_0xDF:
	RJMP _0xDE
_0xE0:
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	CALL SUBOPT_0x2A
_0xDE:
	SBIC 0x19,4
	RJMP _0xE2
	SBIC 0x19,6
	RJMP _0xE2
	SBIC 0x16,0
	RJMP _0xE2
	SBIS 0x16,6
	RJMP _0xE2
	SBIS 0x16,2
	RJMP _0xE2
	SBIC 0x16,4
	RJMP _0xE3
_0xE2:
	RJMP _0xE1
_0xE3:
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x2A
_0xE1:
	SBIS 0x19,4
	RJMP _0xE5
	SBIS 0x19,6
	RJMP _0xE5
	SBIC 0x16,0
	RJMP _0xE5
	SBIC 0x16,6
	RJMP _0xE5
	SBIC 0x16,2
	RJMP _0xE5
	SBIS 0x16,4
	RJMP _0xE6
_0xE5:
	RJMP _0xE4
_0xE6:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	CALL SUBOPT_0x2A
_0xE4:
	SBIS 0x19,4
	RJMP _0xE8
	SBIC 0x19,6
	RJMP _0xE8
	SBIC 0x16,0
	RJMP _0xE8
	SBIC 0x16,6
	RJMP _0xE8
	SBIC 0x16,2
	RJMP _0xE8
	SBIC 0x16,4
	RJMP _0xE9
_0xE8:
	RJMP _0xE7
_0xE9:
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x2A
_0xE7:
	SBIC 0x19,4
	RJMP _0xEB
	SBIC 0x19,6
	RJMP _0xEB
	SBIC 0x16,0
	RJMP _0xEB
	SBIC 0x16,6
	RJMP _0xEB
	SBIS 0x16,2
	RJMP _0xEB
	SBIC 0x16,4
	RJMP _0xEC
_0xEB:
	RJMP _0xEA
_0xEC:
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	CALL SUBOPT_0x2A
_0xEA:
	SBIS 0x19,4
	RJMP _0xEE
	SBIC 0x19,6
	RJMP _0xEE
	SBIC 0x16,0
	RJMP _0xEE
	SBIC 0x16,6
	RJMP _0xEE
	SBIC 0x16,2
	RJMP _0xEE
	SBIS 0x16,4
	RJMP _0xEF
_0xEE:
	RJMP _0xED
_0xEF:
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	CALL SUBOPT_0x2A
_0xED:
	SBIC 0x19,4
	RJMP _0xF1
	SBIC 0x19,6
	RJMP _0xF1
	SBIC 0x16,0
	RJMP _0xF1
	SBIC 0x16,6
	RJMP _0xF1
	SBIC 0x16,2
	RJMP _0xF1
	SBIC 0x16,4
	RJMP _0xF2
_0xF1:
	RJMP _0xF0
_0xF2:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x2A
_0xF0:
	SBIC 0x19,4
	RJMP _0xF4
	SBIC 0x19,6
	RJMP _0xF4
	SBIC 0x16,0
	RJMP _0xF4
	SBIC 0x16,6
	RJMP _0xF4
	SBIC 0x16,2
	RJMP _0xF4
	SBIS 0x16,4
	RJMP _0xF5
_0xF4:
	RJMP _0xF3
_0xF5:
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	CALL SUBOPT_0x2A
_0xF3:
	SBIS 0x19,4
	RJMP _0xF7
	SBIS 0x19,6
	RJMP _0xF7
	SBIS 0x16,0
	RJMP _0xF7
	SBIC 0x16,6
	RJMP _0xF7
	SBIS 0x16,2
	RJMP _0xF7
	SBIS 0x16,4
	RJMP _0xF8
_0xF7:
	RJMP _0xF6
_0xF8:
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	CALL SUBOPT_0x2A
_0xF6:
	SBIS 0x19,4
	RJMP _0xFA
	SBIS 0x19,6
	RJMP _0xFA
	SBIC 0x16,0
	RJMP _0xFA
	SBIS 0x16,6
	RJMP _0xFA
	SBIC 0x16,2
	RJMP _0xFA
	SBIC 0x16,4
	RJMP _0xFB
_0xFA:
	RJMP _0xF9
_0xFB:
	LDI  R30,LOW(23)
	LDI  R31,HIGH(23)
	CALL SUBOPT_0x2A
_0xF9:
	SBIS 0x19,4
	RJMP _0xFD
	SBIC 0x19,6
	RJMP _0xFD
	SBIS 0x16,0
	RJMP _0xFD
	SBIC 0x16,6
	RJMP _0xFD
	SBIS 0x16,2
	RJMP _0xFD
	SBIC 0x16,4
	RJMP _0xFE
_0xFD:
	RJMP _0xFC
_0xFE:
	LDI  R30,LOW(24)
	LDI  R31,HIGH(24)
	CALL SUBOPT_0x2A
_0xFC:
	SBIC 0x19,4
	RJMP _0x100
	SBIS 0x19,6
	RJMP _0x100
	SBIC 0x16,0
	RJMP _0x100
	SBIS 0x16,6
	RJMP _0x100
	SBIS 0x16,2
	RJMP _0x100
	SBIC 0x16,4
	RJMP _0x101
_0x100:
	RJMP _0xFF
_0x101:
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	CALL SUBOPT_0x2A
_0xFF:
	SBIS 0x19,4
	RJMP _0x103
	SBIS 0x19,6
	RJMP _0x103
	SBIC 0x16,0
	RJMP _0x103
	SBIS 0x16,6
	RJMP _0x103
	SBIS 0x16,2
	RJMP _0x103
	SBIS 0x16,4
	RJMP _0x104
_0x103:
	RJMP _0x102
_0x104:
	LDI  R30,LOW(26)
	LDI  R31,HIGH(26)
	CALL SUBOPT_0x2A
_0x102:
	SBIS 0x19,4
	RJMP _0x106
	SBIC 0x19,6
	RJMP _0x106
	SBIS 0x16,0
	RJMP _0x106
	SBIS 0x16,6
	RJMP _0x106
	SBIC 0x16,2
	RJMP _0x106
	SBIC 0x16,4
	RJMP _0x107
_0x106:
	RJMP _0x105
_0x107:
	LDI  R30,LOW(27)
	LDI  R31,HIGH(27)
	CALL SUBOPT_0x2A
_0x105:
	SBIC 0x19,4
	RJMP _0x109
	SBIS 0x19,6
	RJMP _0x109
	SBIS 0x16,0
	RJMP _0x109
	SBIC 0x16,6
	RJMP _0x109
	SBIS 0x16,2
	RJMP _0x109
	SBIC 0x16,4
	RJMP _0x10A
_0x109:
	RJMP _0x108
_0x10A:
	LDI  R30,LOW(28)
	LDI  R31,HIGH(28)
	CALL SUBOPT_0x2A
_0x108:
	SBIS 0x19,4
	RJMP _0x10C
	SBIC 0x19,6
	RJMP _0x10C
	SBIS 0x16,0
	RJMP _0x10C
	SBIS 0x16,6
	RJMP _0x10C
	SBIS 0x16,2
	RJMP _0x10C
	SBIS 0x16,4
	RJMP _0x10D
_0x10C:
	RJMP _0x10B
_0x10D:
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	CALL SUBOPT_0x2A
_0x10B:
	SBIC 0x19,4
	RJMP _0x10F
	SBIS 0x19,6
	RJMP _0x10F
	SBIS 0x16,0
	RJMP _0x10F
	SBIS 0x16,6
	RJMP _0x10F
	SBIC 0x16,2
	RJMP _0x10F
	SBIC 0x16,4
	RJMP _0x110
_0x10F:
	RJMP _0x10E
_0x110:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x2A
_0x10E:
	SBIC 0x19,4
	RJMP _0x112
	SBIS 0x19,6
	RJMP _0x112
	SBIS 0x16,0
	RJMP _0x112
	SBIS 0x16,6
	RJMP _0x112
	SBIS 0x16,2
	RJMP _0x112
	SBIS 0x16,4
	RJMP _0x113
_0x112:
	RJMP _0x111
_0x113:
	LDI  R30,LOW(31)
	LDI  R31,HIGH(31)
	CALL SUBOPT_0x2A
_0x111:
	SBIC 0x19,4
	RJMP _0x115
	SBIC 0x19,6
	RJMP _0x115
	SBIC 0x16,0
	RJMP _0x115
	SBIC 0x16,6
	RJMP _0x115
	SBIS 0x16,2
	RJMP _0x115
	SBIS 0x16,4
	RJMP _0x116
_0x115:
	RJMP _0x114
_0x116:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CALL SUBOPT_0x2A
_0x114:
	SBIC 0x19,4
	RJMP _0x118
	SBIC 0x19,6
	RJMP _0x118
	SBIC 0x16,0
	RJMP _0x118
	SBIS 0x16,6
	RJMP _0x118
	SBIC 0x16,2
	RJMP _0x118
	SBIS 0x16,4
	RJMP _0x119
_0x118:
	RJMP _0x117
_0x119:
	LDI  R30,LOW(33)
	LDI  R31,HIGH(33)
	CALL SUBOPT_0x2A
_0x117:
	SBIC 0x19,4
	RJMP _0x11B
	SBIC 0x19,6
	RJMP _0x11B
	SBIS 0x16,0
	RJMP _0x11B
	SBIC 0x16,6
	RJMP _0x11B
	SBIC 0x16,2
	RJMP _0x11B
	SBIS 0x16,4
	RJMP _0x11C
_0x11B:
	RJMP _0x11A
_0x11C:
	LDI  R30,LOW(34)
	LDI  R31,HIGH(34)
	CALL SUBOPT_0x2A
_0x11A:
	SBIC 0x19,4
	RJMP _0x11E
	SBIS 0x19,6
	RJMP _0x11E
	SBIC 0x16,0
	RJMP _0x11E
	SBIC 0x16,6
	RJMP _0x11E
	SBIC 0x16,2
	RJMP _0x11E
	SBIS 0x16,4
	RJMP _0x11F
_0x11E:
	RJMP _0x11D
_0x11F:
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	CALL SUBOPT_0x2A
_0x11D:
	SBIC 0x19,4
	RJMP _0x121
	SBIC 0x19,6
	RJMP _0x121
	SBIC 0x16,0
	RJMP _0x121
	SBIS 0x16,6
	RJMP _0x121
	SBIS 0x16,2
	RJMP _0x121
	SBIS 0x16,4
	RJMP _0x122
_0x121:
	RJMP _0x120
_0x122:
	LDI  R30,LOW(36)
	LDI  R31,HIGH(36)
	CALL SUBOPT_0x2A
_0x120:
	SBIC 0x19,4
	RJMP _0x124
	SBIC 0x19,6
	RJMP _0x124
	SBIS 0x16,0
	RJMP _0x124
	SBIS 0x16,6
	RJMP _0x124
	SBIC 0x16,2
	RJMP _0x124
	SBIS 0x16,4
	RJMP _0x125
_0x124:
	RJMP _0x123
_0x125:
	LDI  R30,LOW(37)
	LDI  R31,HIGH(37)
	CALL SUBOPT_0x2A
_0x123:
	SBIC 0x19,4
	RJMP _0x127
	SBIS 0x19,6
	RJMP _0x127
	SBIS 0x16,0
	RJMP _0x127
	SBIC 0x16,6
	RJMP _0x127
	SBIC 0x16,2
	RJMP _0x127
	SBIS 0x16,4
	RJMP _0x128
_0x127:
	RJMP _0x126
_0x128:
	LDI  R30,LOW(38)
	LDI  R31,HIGH(38)
	CALL SUBOPT_0x2A
_0x126:
	SBIC 0x19,4
	RJMP _0x12A
	SBIS 0x19,6
	RJMP _0x12A
	SBIC 0x16,0
	RJMP _0x12A
	SBIS 0x16,6
	RJMP _0x12A
	SBIC 0x16,2
	RJMP _0x12A
	SBIC 0x16,4
	RJMP _0x12B
_0x12A:
	RJMP _0x129
_0x12B:
	LDI  R30,LOW(39)
	LDI  R31,HIGH(39)
	CALL SUBOPT_0x2A
_0x129:
	SBIS 0x19,4
	RJMP _0x12D
	SBIC 0x19,6
	RJMP _0x12D
	SBIS 0x16,0
	RJMP _0x12D
	SBIC 0x16,6
	RJMP _0x12D
	SBIS 0x16,2
	RJMP _0x12D
	SBIS 0x16,4
	RJMP _0x12E
_0x12D:
	RJMP _0x12C
_0x12E:
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x2A
_0x12C:
	SBIC 0x19,4
	RJMP _0x130
	SBIS 0x19,6
	RJMP _0x130
	SBIS 0x16,0
	RJMP _0x130
	SBIC 0x16,6
	RJMP _0x130
	SBIC 0x16,2
	RJMP _0x130
	SBIC 0x16,4
	RJMP _0x131
_0x130:
	RJMP _0x12F
_0x131:
	LDI  R30,LOW(41)
	LDI  R31,HIGH(41)
	CALL SUBOPT_0x2A
_0x12F:
	SBIS 0x19,4
	RJMP _0x133
	SBIC 0x19,6
	RJMP _0x133
	SBIC 0x16,0
	RJMP _0x133
	SBIS 0x16,6
	RJMP _0x133
	SBIS 0x16,2
	RJMP _0x133
	SBIS 0x16,4
	RJMP _0x134
_0x133:
	RJMP _0x132
_0x134:
	LDI  R30,LOW(42)
	LDI  R31,HIGH(42)
	CALL SUBOPT_0x2A
_0x132:
	SBIC 0x19,4
	RJMP _0x136
	SBIC 0x19,6
	RJMP _0x136
	SBIS 0x16,0
	RJMP _0x136
	SBIC 0x16,6
	RJMP _0x136
	SBIS 0x16,2
	RJMP _0x136
	SBIS 0x16,4
	RJMP _0x137
_0x136:
	RJMP _0x135
_0x137:
	LDI  R30,LOW(43)
	LDI  R31,HIGH(43)
	CALL SUBOPT_0x2A
_0x135:
	SBIC 0x19,4
	RJMP _0x139
	SBIC 0x19,6
	RJMP _0x139
	SBIS 0x16,0
	RJMP _0x139
	SBIC 0x16,6
	RJMP _0x139
	SBIC 0x16,2
	RJMP _0x139
	SBIC 0x16,4
	RJMP _0x13A
_0x139:
	RJMP _0x138
_0x13A:
	LDI  R30,LOW(44)
	LDI  R31,HIGH(44)
	CALL SUBOPT_0x2A
_0x138:
	SBIC 0x19,4
	RJMP _0x13C
	SBIS 0x19,6
	RJMP _0x13C
	SBIC 0x16,0
	RJMP _0x13C
	SBIC 0x16,6
	RJMP _0x13C
	SBIS 0x16,2
	RJMP _0x13C
	SBIS 0x16,4
	RJMP _0x13D
_0x13C:
	RJMP _0x13B
_0x13D:
	LDI  R30,LOW(45)
	LDI  R31,HIGH(45)
	CALL SUBOPT_0x2A
_0x13B:
	SBIC 0x19,4
	RJMP _0x13F
	SBIS 0x19,6
	RJMP _0x13F
	SBIC 0x16,0
	RJMP _0x13F
	SBIC 0x16,6
	RJMP _0x13F
	SBIC 0x16,2
	RJMP _0x13F
	SBIC 0x16,4
	RJMP _0x140
_0x13F:
	RJMP _0x13E
_0x140:
	LDI  R30,LOW(46)
	LDI  R31,HIGH(46)
	CALL SUBOPT_0x2A
_0x13E:
	SBIS 0x19,4
	RJMP _0x142
	SBIC 0x19,6
	RJMP _0x142
	SBIC 0x16,0
	RJMP _0x142
	SBIC 0x16,6
	RJMP _0x142
	SBIS 0x16,2
	RJMP _0x142
	SBIS 0x16,4
	RJMP _0x143
_0x142:
	RJMP _0x141
_0x143:
	LDI  R30,LOW(47)
	LDI  R31,HIGH(47)
	CALL SUBOPT_0x2A
_0x141:
	SBIS 0x19,4
	RJMP _0x145
	SBIC 0x19,6
	RJMP _0x145
	SBIC 0x16,0
	RJMP _0x145
	SBIS 0x16,6
	RJMP _0x145
	SBIC 0x16,2
	RJMP _0x145
	SBIS 0x16,4
	RJMP _0x146
_0x145:
	RJMP _0x144
_0x146:
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL SUBOPT_0x2A
_0x144:
	SBIC 0x19,4
	RJMP _0x148
	SBIC 0x19,6
	RJMP _0x148
	SBIS 0x16,0
	RJMP _0x148
	SBIS 0x16,6
	RJMP _0x148
	SBIC 0x16,2
	RJMP _0x148
	SBIC 0x16,4
	RJMP _0x149
_0x148:
	RJMP _0x147
_0x149:
	LDI  R30,LOW(49)
	LDI  R31,HIGH(49)
	CALL SUBOPT_0x2A
_0x147:
	SBIS 0x19,4
	RJMP _0x14B
	SBIC 0x19,6
	RJMP _0x14B
	SBIC 0x16,0
	RJMP _0x14B
	SBIS 0x16,6
	RJMP _0x14B
	SBIS 0x16,2
	RJMP _0x14B
	SBIS 0x16,4
	RJMP _0x14C
_0x14B:
	RJMP _0x14A
_0x14C:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x2A
_0x14A:
	SBIC 0x19,4
	RJMP _0x14E
	SBIC 0x19,6
	RJMP _0x14E
	SBIS 0x16,0
	RJMP _0x14E
	SBIS 0x16,6
	RJMP _0x14E
	SBIC 0x16,2
	RJMP _0x14E
	SBIC 0x16,4
	RJMP _0x14F
_0x14E:
	RJMP _0x14D
_0x14F:
	LDI  R30,LOW(51)
	LDI  R31,HIGH(51)
	CALL SUBOPT_0x2A
_0x14D:
	SBIC 0x19,4
	RJMP _0x151
	SBIC 0x19,6
	RJMP _0x151
	SBIS 0x16,0
	RJMP _0x151
	SBIC 0x16,6
	RJMP _0x151
	SBIS 0x16,2
	RJMP _0x151
	SBIC 0x16,4
	RJMP _0x152
_0x151:
	RJMP _0x150
_0x152:
	LDI  R30,LOW(52)
	LDI  R31,HIGH(52)
	CALL SUBOPT_0x2A
_0x150:
	SBIC 0x19,4
	RJMP _0x154
	SBIC 0x19,6
	RJMP _0x154
	SBIC 0x16,0
	RJMP _0x154
	SBIS 0x16,6
	RJMP _0x154
	SBIC 0x16,2
	RJMP _0x154
	SBIC 0x16,4
	RJMP _0x155
_0x154:
	RJMP _0x153
_0x155:
	LDI  R30,LOW(53)
	LDI  R31,HIGH(53)
	CALL SUBOPT_0x2A
_0x153:
	SBIS 0x19,4
	RJMP _0x157
	SBIS 0x19,6
	RJMP _0x157
	SBIC 0x16,0
	RJMP _0x157
	SBIC 0x16,6
	RJMP _0x157
	SBIS 0x16,2
	RJMP _0x157
	SBIS 0x16,4
	RJMP _0x158
_0x157:
	RJMP _0x156
_0x158:
	LDI  R30,LOW(54)
	LDI  R31,HIGH(54)
	CALL SUBOPT_0x2A
_0x156:
	SBIC 0x19,4
	RJMP _0x15A
	SBIS 0x19,6
	RJMP _0x15A
	SBIS 0x16,0
	RJMP _0x15A
	SBIS 0x16,6
	RJMP _0x15A
	SBIC 0x16,2
	RJMP _0x15A
	SBIS 0x16,4
	RJMP _0x15B
_0x15A:
	RJMP _0x159
_0x15B:
	LDI  R30,LOW(55)
	LDI  R31,HIGH(55)
	CALL SUBOPT_0x2A
_0x159:
	SBIC 0x19,4
	RJMP _0x15D
	SBIS 0x19,6
	RJMP _0x15D
	SBIC 0x16,0
	RJMP _0x15D
	SBIS 0x16,6
	RJMP _0x15D
	SBIC 0x16,2
	RJMP _0x15D
	SBIS 0x16,4
	RJMP _0x15E
_0x15D:
	RJMP _0x15C
_0x15E:
	LDI  R30,LOW(56)
	LDI  R31,HIGH(56)
	CALL SUBOPT_0x2A
_0x15C:
	SBIS 0x19,4
	RJMP _0x160
	SBIS 0x19,6
	RJMP _0x160
	SBIC 0x16,0
	RJMP _0x160
	SBIS 0x16,6
	RJMP _0x160
	SBIC 0x16,2
	RJMP _0x160
	SBIS 0x16,4
	RJMP _0x161
_0x160:
	RJMP _0x15F
_0x161:
	LDI  R30,LOW(57)
	LDI  R31,HIGH(57)
	CALL SUBOPT_0x2A
_0x15F:
	SBIS 0x19,4
	RJMP _0x163
	SBIC 0x19,6
	RJMP _0x163
	SBIS 0x16,0
	RJMP _0x163
	SBIC 0x16,6
	RJMP _0x163
	SBIC 0x16,2
	RJMP _0x163
	SBIS 0x16,4
	RJMP _0x164
_0x163:
	RJMP _0x162
_0x164:
	LDI  R30,LOW(58)
	LDI  R31,HIGH(58)
	CALL SUBOPT_0x2A
_0x162:
	SBIS 0x19,4
	RJMP _0x166
	SBIC 0x19,6
	RJMP _0x166
	SBIS 0x16,0
	RJMP _0x166
	SBIS 0x16,6
	RJMP _0x166
	SBIC 0x16,2
	RJMP _0x166
	SBIS 0x16,4
	RJMP _0x167
_0x166:
	RJMP _0x165
_0x167:
	LDI  R30,LOW(59)
	LDI  R31,HIGH(59)
	CALL SUBOPT_0x2A
_0x165:
	SBIC 0x19,4
	RJMP _0x169
	SBIS 0x19,6
	RJMP _0x169
	SBIC 0x16,0
	RJMP _0x169
	SBIC 0x16,6
	RJMP _0x169
	SBIS 0x16,2
	RJMP _0x169
	SBIC 0x16,4
	RJMP _0x16A
_0x169:
	RJMP _0x168
_0x16A:
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	CALL SUBOPT_0x2A
_0x168:
	CALL SUBOPT_0x22
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41200000
	CALL __CMPF12
	BRSH _0x16B
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CALL SUBOPT_0x2A
_0x16B:
	RET
; .FEND
_detectorcase:
; .FSTART _detectorcase
	LDS  R30,_detector_value
	LDS  R31,_detector_value+1
	SBIW R30,0
	BRNE _0x19C
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	RJMP _0x267
_0x19C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x19D
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x19D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x19E
	RJMP _0x269
_0x19E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x19F
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	RJMP _0x267
_0x19F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x1A0
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2C
	RJMP _0x267
_0x1A0:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x1A1
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1A1:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x1A2
	RJMP _0x269
_0x1A2:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x1A3
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP _0x26A
_0x1A3:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x1A4
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1A4:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x1A5
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2E
	CALL SUBOPT_0x2C
	RJMP _0x267
_0x1A5:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x1A6
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1A6:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x1A7
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1A7:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x1A8
	CALL SUBOPT_0x2B
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP _0x268
_0x1A8:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x1A9
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP _0x26A
_0x1A9:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x1AA
	CALL SUBOPT_0x2B
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x268
_0x1AA:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x1AB
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x26A
_0x1AB:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x1AC
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RJMP _0x26A
_0x1AC:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x1AD
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RJMP _0x26A
_0x1AD:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x1AE
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RJMP _0x26A
_0x1AE:
	CPI  R30,LOW(0x13)
	LDI  R26,HIGH(0x13)
	CPC  R31,R26
	BRNE _0x1AF
	CALL SUBOPT_0x2D
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x268
_0x1AF:
	CPI  R30,LOW(0x14)
	LDI  R26,HIGH(0x14)
	CPC  R31,R26
	BRNE _0x1B0
	CALL SUBOPT_0x2D
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x268
_0x1B0:
	CPI  R30,LOW(0x15)
	LDI  R26,HIGH(0x15)
	CPC  R31,R26
	BRNE _0x1B1
	CALL SUBOPT_0x2F
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	RJMP _0x268
_0x1B1:
	CPI  R30,LOW(0x16)
	LDI  R26,HIGH(0x16)
	CPC  R31,R26
	BRNE _0x1B2
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1B2:
	CPI  R30,LOW(0x17)
	LDI  R26,HIGH(0x17)
	CPC  R31,R26
	BRNE _0x1B3
	RJMP _0x269
_0x1B3:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x1B4
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1B4:
	CPI  R30,LOW(0x19)
	LDI  R26,HIGH(0x19)
	CPC  R31,R26
	BRNE _0x1B5
	RJMP _0x269
_0x1B5:
	CPI  R30,LOW(0x1A)
	LDI  R26,HIGH(0x1A)
	CPC  R31,R26
	BRNE _0x1B6
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1B6:
	CPI  R30,LOW(0x1B)
	LDI  R26,HIGH(0x1B)
	CPC  R31,R26
	BRNE _0x1B7
	RJMP _0x269
_0x1B7:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BRNE _0x1B8
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1B8:
	CPI  R30,LOW(0x1D)
	LDI  R26,HIGH(0x1D)
	CPC  R31,R26
	BRNE _0x1B9
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1B9:
	CPI  R30,LOW(0x1E)
	LDI  R26,HIGH(0x1E)
	CPC  R31,R26
	BRNE _0x1BA
	RJMP _0x269
_0x1BA:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BRNE _0x1BB
	RJMP _0x269
_0x1BB:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x1BC
	CALL SUBOPT_0x2B
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	RJMP _0x268
_0x1BC:
	CPI  R30,LOW(0x21)
	LDI  R26,HIGH(0x21)
	CPC  R31,R26
	BRNE _0x1BD
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	RJMP _0x26A
_0x1BD:
	CPI  R30,LOW(0x22)
	LDI  R26,HIGH(0x22)
	CPC  R31,R26
	BRNE _0x1BE
	RJMP _0x269
_0x1BE:
	CPI  R30,LOW(0x23)
	LDI  R26,HIGH(0x23)
	CPC  R31,R26
	BRNE _0x1BF
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	RJMP _0x26A
_0x1BF:
	CPI  R30,LOW(0x24)
	LDI  R26,HIGH(0x24)
	CPC  R31,R26
	BRNE _0x1C0
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1C0:
	CPI  R30,LOW(0x25)
	LDI  R26,HIGH(0x25)
	CPC  R31,R26
	BRNE _0x1C1
	RJMP _0x269
_0x1C1:
	CPI  R30,LOW(0x26)
	LDI  R26,HIGH(0x26)
	CPC  R31,R26
	BRNE _0x1C2
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1C2:
	CPI  R30,LOW(0x27)
	LDI  R26,HIGH(0x27)
	CPC  R31,R26
	BRNE _0x1C3
	RJMP _0x269
_0x1C3:
	CPI  R30,LOW(0x28)
	LDI  R26,HIGH(0x28)
	CPC  R31,R26
	BRNE _0x1C4
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1C4:
	CPI  R30,LOW(0x29)
	LDI  R26,HIGH(0x29)
	CPC  R31,R26
	BRNE _0x1C5
	RJMP _0x269
_0x1C5:
	CPI  R30,LOW(0x2A)
	LDI  R26,HIGH(0x2A)
	CPC  R31,R26
	BRNE _0x1C6
	RJMP _0x269
_0x1C6:
	CPI  R30,LOW(0x2B)
	LDI  R26,HIGH(0x2B)
	CPC  R31,R26
	BRNE _0x1C7
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1C7:
	CPI  R30,LOW(0x2C)
	LDI  R26,HIGH(0x2C)
	CPC  R31,R26
	BRNE _0x1C8
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	RJMP _0x26A
_0x1C8:
	CPI  R30,LOW(0x2D)
	LDI  R26,HIGH(0x2D)
	CPC  R31,R26
	BRNE _0x1C9
	CALL SUBOPT_0x2E
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RJMP _0x268
_0x1C9:
	CPI  R30,LOW(0x2E)
	LDI  R26,HIGH(0x2E)
	CPC  R31,R26
	BRNE _0x1CA
	CALL SUBOPT_0x2E
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RJMP _0x268
_0x1CA:
	CPI  R30,LOW(0x2F)
	LDI  R26,HIGH(0x2F)
	CPC  R31,R26
	BRNE _0x1CB
	CALL SUBOPT_0x2F
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x268
_0x1CB:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x1CC
	CALL SUBOPT_0x2F
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x268
_0x1CC:
	CPI  R30,LOW(0x31)
	LDI  R26,HIGH(0x31)
	CPC  R31,R26
	BRNE _0x1CD
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	RJMP _0x26A
_0x1CD:
	CPI  R30,LOW(0x32)
	LDI  R26,HIGH(0x32)
	CPC  R31,R26
	BRNE _0x1CE
	CALL SUBOPT_0x2E
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1CE:
	CPI  R30,LOW(0x33)
	LDI  R26,HIGH(0x33)
	CPC  R31,R26
	BRNE _0x1CF
	CALL SUBOPT_0x2B
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RJMP _0x268
_0x1CF:
	CPI  R30,LOW(0x34)
	LDI  R26,HIGH(0x34)
	CPC  R31,R26
	BRNE _0x1D0
	CALL SUBOPT_0x2B
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1D0:
	CPI  R30,LOW(0x35)
	LDI  R26,HIGH(0x35)
	CPC  R31,R26
	BRNE _0x1D1
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	RJMP _0x26A
_0x1D1:
	CPI  R30,LOW(0x36)
	LDI  R26,HIGH(0x36)
	CPC  R31,R26
	BRNE _0x1D2
	CALL SUBOPT_0x2E
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	RJMP _0x268
_0x1D2:
	CPI  R30,LOW(0x37)
	LDI  R26,HIGH(0x37)
	CPC  R31,R26
	BRNE _0x1D3
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x26A
_0x1D3:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0x1D4
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x26A
_0x1D4:
	CPI  R30,LOW(0x39)
	LDI  R26,HIGH(0x39)
	CPC  R31,R26
	BRNE _0x1D5
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x26A
_0x1D5:
	CPI  R30,LOW(0x3A)
	LDI  R26,HIGH(0x3A)
	CPC  R31,R26
	BRNE _0x1D6
	CALL SUBOPT_0x2B
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x268
_0x1D6:
	CPI  R30,LOW(0x3B)
	LDI  R26,HIGH(0x3B)
	CPC  R31,R26
	BRNE _0x1D7
	CALL SUBOPT_0x2B
	LDI  R30,LOW(85)
	LDI  R31,HIGH(85)
	RJMP _0x268
_0x1D7:
	CPI  R30,LOW(0x3C)
	LDI  R26,HIGH(0x3C)
	CPC  R31,R26
	BRNE _0x1D8
	CALL SUBOPT_0x2E
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP _0x268
_0x1D8:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x19B
_0x269:
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
_0x26A:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
_0x268:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(1)
_0x267:
	LDI  R27,0
	RCALL _movement
_0x19B:
	RET
; .FEND
_STATE_DREHUNG:
; .FSTART _STATE_DREHUNG
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3
_0x1DB:
	CALL SUBOPT_0x23
	CALL SUBOPT_0x29
	__POINTW2MN _0x1E1,0
	CALL SUBOPT_0x27
	__POINTW2MN _0x1E1,3
	CALL SUBOPT_0x28
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRGE _0x1E2
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0x1E3
_0x1E2:
	RJMP _0x1DC
_0x1E3:
	RJMP _0x1DB
_0x1DC:
	RET
; .FEND

	.DSEG
_0x1E1:
	.BYTE 0x7

	.CSEG
_STATE_METERLINKSMETERRECHTS:
; .FSTART _STATE_METERLINKSMETERRECHTS
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3
_0x1E5:
	CALL SUBOPT_0x24
	CALL SUBOPT_0x29
	__POINTW2MN _0x1EB,0
	CALL SUBOPT_0x27
	__POINTW2MN _0x1EB,3
	CALL SUBOPT_0x28
	CALL SUBOPT_0x4
	SBIW R26,17
	BRLT _0x1E5
	CALL SUBOPT_0x30
	CALL SUBOPT_0x3
_0x1F1:
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	__POINTW2MN _0x1EB,7
	CALL SUBOPT_0x27
	__POINTW2MN _0x1EB,10
	CALL SUBOPT_0x28
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRGE _0x1F7
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x1F8
_0x1F7:
	RJMP _0x1F2
_0x1F8:
	RJMP _0x1F1
_0x1F2:
	CALL SUBOPT_0x30
	CALL SUBOPT_0x3
_0x1FE:
	CALL SUBOPT_0x25
	CALL SUBOPT_0x26
	__POINTW2MN _0x1EB,14
	CALL SUBOPT_0x27
	__POINTW2MN _0x1EB,17
	CALL SUBOPT_0x28
	CALL SUBOPT_0x1
	SBIW R26,17
	BRLT _0x1FE
	CALL SUBOPT_0x30
	CALL SUBOPT_0x3
_0x209:
	CALL SUBOPT_0x23
	CALL SUBOPT_0x31
	__POINTW2MN _0x1EB,21
	CALL SUBOPT_0x27
	__POINTW2MN _0x1EB,24
	CALL SUBOPT_0x28
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRGE _0x20F
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x210
_0x20F:
	RJMP _0x20A
_0x210:
	RJMP _0x209
_0x20A:
	RET
; .FEND

	.DSEG
_0x1EB:
	.BYTE 0x1C

	.CSEG
_STATE_3:
; .FSTART _STATE_3
	RCALL _detector
	RCALL _detectorcase
	RET
; .FEND
_STATE_MACHINE:
; .FSTART _STATE_MACHINE
	LDI  R30,LOW(0)
	STS  _ipwmcompareleft,R30
	STS  _ipwmcompareleft+1,R30
	STS  _ipwmcompareright,R30
	STS  _ipwmcompareright+1,R30
	LDS  R30,_state
	LDS  R31,_state+1
	SBIW R30,0
	BRNE _0x214
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x215
	CALL _lcd_clear
	__POINTW2MN _0x216,0
	CALL SUBOPT_0x32
_0x215:
	CALL _STATE_LINE_SENSOR
	RJMP _0x213
_0x214:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x217
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x218
	CALL _lcd_clear
	__POINTW2MN _0x216,17
	CALL SUBOPT_0x32
_0x218:
	CALL _STATE_ENGINE
	RJMP _0x213
_0x217:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x219
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x21A
	CALL _lcd_clear
	__POINTW2MN _0x216,33
	CALL SUBOPT_0x32
_0x21A:
	CALL _STATE_ENGINE_DIR
	RJMP _0x213
_0x219:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x21B
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x21C
	CALL _lcd_clear
	__POINTW2MN _0x216,51
	CALL SUBOPT_0x32
_0x21C:
	CALL _STATE_DISTANCE_SENSOR
	RJMP _0x213
_0x21B:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x21D
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x21E
	CALL _lcd_clear
	__POINTW2MN _0x216,68
	CALL SUBOPT_0x32
_0x21E:
	CALL _STATE_LIGHTSENSOR
	RJMP _0x213
_0x21D:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x21F
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x220
	CALL _lcd_clear
	__POINTW2MN _0x216,85
	CALL SUBOPT_0x32
_0x220:
	CALL _STATE_WIICAM
	RJMP _0x213
_0x21F:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x221
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x222
	CALL _lcd_clear
	__POINTW2MN _0x216,101
	CALL SUBOPT_0x32
_0x222:
	RCALL _STATE_IRTOWER
	RJMP _0x213
_0x221:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x223
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x224
	CALL _lcd_clear
	__POINTW2MN _0x216,118
	CALL SUBOPT_0x32
_0x224:
	RCALL _STATE_SERVO
	RJMP _0x213
_0x223:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x225
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x226
	CALL _lcd_clear
	__POINTW2MN _0x216,133
	CALL SUBOPT_0x32
_0x226:
	RCALL _STATE_ULTRASONIC
	RJMP _0x213
_0x225:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x227
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x228
	CALL _lcd_clear
	__POINTW2MN _0x216,149
	CALL SUBOPT_0x32
_0x228:
	RCALL _STATE_VOR
	RJMP _0x213
_0x227:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x229
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x22A
	CALL _lcd_clear
	__POINTW2MN _0x216,165
	CALL SUBOPT_0x32
_0x22A:
	RCALL _STATE_ZUR
	RJMP _0x213
_0x229:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x22B
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x22C
	CALL _lcd_clear
	__POINTW2MN _0x216,183
	CALL SUBOPT_0x32
_0x22C:
	RCALL _STATE_LINKS
	RJMP _0x213
_0x22B:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x22D
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x22E
	CALL _lcd_clear
	__POINTW2MN _0x216,200
	CALL SUBOPT_0x32
_0x22E:
	RCALL _STATE_RECHTS
	RJMP _0x213
_0x22D:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x22F
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x230
	CALL _lcd_clear
	__POINTW2MN _0x216,216
	CALL SUBOPT_0x32
_0x230:
	RCALL _STATE_90LINKS
	RJMP _0x213
_0x22F:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x231
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x232
	CALL _lcd_clear
	__POINTW2MN _0x216,234
	CALL SUBOPT_0x32
_0x232:
	RCALL _STATE_90RECHTS
	RJMP _0x213
_0x231:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x233
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x234
	CALL _lcd_clear
	__POINTW2MN _0x216,251
	CALL SUBOPT_0x32
_0x234:
	RCALL _STATE_DREHUNG
	RJMP _0x213
_0x233:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x235
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x236
	CALL _lcd_clear
	__POINTW2MN _0x216,264
	CALL SUBOPT_0x32
_0x236:
	RCALL _STATE_METERLINKSMETERRECHTS
	RJMP _0x213
_0x235:
	CPI  R30,LOW(0x11)
	LDI  R26,HIGH(0x11)
	CPC  R31,R26
	BRNE _0x237
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x238
	CALL _lcd_clear
	__POINTW2MN _0x216,282
	CALL SUBOPT_0x32
_0x238:
	RCALL _STATE_3
	RJMP _0x213
_0x237:
	CPI  R30,LOW(0x12)
	LDI  R26,HIGH(0x12)
	CPC  R31,R26
	BRNE _0x23B
	MOV  R0,R12
	OR   R0,R13
	BRNE _0x23A
	CALL _lcd_clear
	__POINTW2MN _0x216,300
	CALL SUBOPT_0x32
_0x23A:
	RCALL _STATE_3
	RJMP _0x213
_0x23B:
	CALL _lcd_clear
	__POINTW2MN _0x216,318
	CALL SUBOPT_0x7
	__POINTW2MN _0x216,332
	CALL _lcd_puts
_0x213:
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
	RET
; .FEND

	.DSEG
_0x216:
	.BYTE 0x157
;#include "modules/esp.h"

	.CSEG
_slave_rx_handler:
; .FSTART _slave_rx_handler
	ST   -Y,R26
;	rx_complete -> Y+0
	LDS  R30,_twi_result
	CPI  R30,0
	BRNE _0x23C
	SET
	BLD  R2,1
	RJMP _0x23D
_0x23C:
	CLT
	BLD  R2,1
	LDI  R30,LOW(0)
	JMP  _0x20E0001
_0x23D:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x23E
	LDI  R30,LOW(0)
	JMP  _0x20E0001
_0x23E:
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
	RJMP _0x23F
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
	CALL SUBOPT_0x22
	__POINTW2MN _tx_buffer,13
	CALL __CFD1U
	ST   X,R30
	LDS  R30,_iTemp
	__PUTB1MN _tx_buffer,14
	LDI  R30,LOW(15)
	JMP  _0x20E0001
_0x23F:
	SBRS R2,1
	RJMP _0x240
	__GETB1MN _rx_buffer,14
	LDI  R31,0
	STS  _currstate,R30
	STS  _currstate+1,R31
_0x240:
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
;#include "modules/pwm.h"
_timer1_ovf_isr:
; .FSTART _timer1_ovf_isr
	CALL SUBOPT_0x0
	LDI  R30,LOW(156)
	OUT  0x2C,R30
	LDI  R26,LOW(_ipwmcounter)
	LDI  R27,HIGH(_ipwmcounter)
	CALL SUBOPT_0x2
	CALL SUBOPT_0x33
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x241
	LDI  R30,LOW(0)
	STS  _ipwmcounter,R30
	STS  _ipwmcounter+1,R30
_0x241:
	LDS  R30,_ipwmcompareleft
	LDS  R31,_ipwmcompareleft+1
	CALL SUBOPT_0x33
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x242
	CBI  0x1B,3
	RJMP _0x245
_0x242:
	SBI  0x1B,3
_0x245:
	LDS  R30,_ipwmcompareright
	LDS  R31,_ipwmcompareright+1
	CALL SUBOPT_0x33
	CP   R26,R30
	CPC  R27,R31
	BRLT _0x248
	CBI  0x1B,1
	RJMP _0x24B
_0x248:
	SBI  0x1B,1
_0x24B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
; .FEND
;
;/*
; void radkorrektur(){
;char strrad [17];
; float newval = 100/(wheelEncoderCounter_right+wheelEncoderCounter_left);
; float newvalprozent= newval*wheelEncoderCounter_left;
; itoa(newvalprozent,strrad);
;  lcd_clear();
; lcd_puts(strrad);
;
;}
;*/
;
;
;
;
;
;
;
;
;void main(void)
; 0000 005A {
_main:
; .FSTART _main
; 0000 005B // Ports initialisieren
; 0000 005C port_init();
	CALL _port_init
; 0000 005D //Other inits
; 0000 005E i2c_init();
	CALL _i2c_init
; 0000 005F wii_cam_init();
	CALL _wii_cam_init
; 0000 0060 twiinit();
	RCALL _twiinit
; 0000 0061 
; 0000 0062 while (1)
_0x24E:
; 0000 0063       {
; 0000 0064       detector();           //SENSOR_DETECTOR
	CALL _detector
; 0000 0065       STATE_MACHINE();      //DEFAULT_STATE_MACHINE
	RCALL _STATE_MACHINE
; 0000 0066       esp_states();         //ESP_STATE_MACHINE
	CALL _esp_states
; 0000 0067       ondata();             //IR_DATA_FUNCTION
	CALL _ondata
; 0000 0068       esp_mainfunctions();  //ESP_MAIN_FUNCTIONS
	CALL _esp_mainfunctions
; 0000 0069 
; 0000 006A       }
	RJMP _0x24E
; 0000 006B }
_0x251:
	RJMP _0x251
; .FEND

	.CSEG
_itoa:
; .FSTART _itoa
	ST   -Y,R27
	ST   -Y,R26
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
; .FEND

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
_lcd_gotoxy:
; .FSTART _lcd_gotoxy
	ST   -Y,R26
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G104)
	SBCI R31,HIGH(-__base_y_G104)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R26,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
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
_lcd_putchar:
; .FSTART _lcd_putchar
	ST   -Y,R26
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
	BRLO _0x2080004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R26,__lcd_y
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2080004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
	LD   R26,Y
	CALL __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20E0001
; .FEND
_lcd_puts:
; .FSTART _lcd_puts
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2080005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2080007
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2080005
_0x2080007:
	RJMP _0x20E0002
; .FEND
_lcd_putsf:
; .FSTART _lcd_putsf
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
_0x2080008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x208000A
	MOV  R26,R17
	RCALL _lcd_putchar
	RJMP _0x2080008
_0x208000A:
_0x20E0002:
	LDD  R17,Y+0
	ADIW R28,3
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
	CALL SUBOPT_0x34
	CALL SUBOPT_0x34
	CALL SUBOPT_0x34
	RCALL __long_delay_G104
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G104
	RCALL __long_delay_G104
	LDI  R26,LOW(40)
	CALL SUBOPT_0x35
	LDI  R26,LOW(4)
	CALL SUBOPT_0x35
	LDI  R26,LOW(133)
	CALL SUBOPT_0x35
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
_detector_value:
	.BYTE 0x2
_detector_value_line:
	.BYTE 0x2
_tmr_line:
	.BYTE 0x2
_val_R_linesearch:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	LDS  R26,_wheelEncoderCounter_right
	LDS  R27,_wheelEncoderCounter_right+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	STS  _wheelEncoderCounter_right,R30
	STS  _wheelEncoderCounter_right+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4:
	LDS  R26,_wheelEncoderCounter_left
	LDS  R27,_wheelEncoderCounter_left+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	STS  _wheelEncoderCounter_left,R30
	STS  _wheelEncoderCounter_left+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	LDS  R30,_tmp
	LDS  R31,_tmp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x7:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x8:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_s)
	LDI  R27,HIGH(_s)
	CALL _itoa
	LDI  R26,LOW(_s)
	LDI  R27,HIGH(_s)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	LDS  R26,_currstate
	LDS  R27,_currstate+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	CALL __MULW12
	__ADDWRR 22,23,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xD:
	MOVW R30,R16
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	MOVW R26,R30
	LSL  R26
	ROL  R27
	__ADDW2MN _data,6
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	CALL __GETW1P
	LDS  R26,_temp
	LDS  R27,_temp+1
	ADD  R30,R26
	ADC  R31,R27
	MOVW R26,R22
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _ipwmcompareleft,R30
	STS  _ipwmcompareleft+1,R31
	STS  _ipwmcompareright,R30
	STS  _ipwmcompareright+1,R31
	CALL _lcd_clear
	LDS  R30,_engine_dir
	LDS  R31,_engine_dir+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x12:
	CALL _lcd_puts
	LDS  R30,_wheelEncoderCounter_left
	LDS  R31,_wheelEncoderCounter_left+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	CALL _itoa
	MOVW R26,R28
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x13:
	CALL _lcd_puts
	LDS  R30,_wheelEncoderCounter_right
	LDS  R31,_wheelEncoderCounter_right+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,2
	CALL _itoa
	MOVW R26,R28
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(250)
	LDI  R27,0
	CALL _delay_ms
	LDS  R30,_engine_dir
	LDS  R31,_engine_dir+1
	CALL __LNEGW1
	LDI  R31,0
	STS  _engine_dir,R30
	STS  _engine_dir+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	MOVW R26,R28
	ADIW R26,6
	CALL _itoa
	MOVW R26,R28
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x16:
	MOV  R30,R17
	LDI  R26,LOW(_x)
	LDI  R27,HIGH(_x)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x17:
	MOV  R30,R17
	LDI  R26,LOW(_y)
	LDI  R27,HIGH(_y)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(20)
	MULS R17,R26
	ST   -Y,R0
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	__POINTW2FN _0x0,213
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	STS  _wiicamobject,R30
	STS  _wiicamobject+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	SUBI R30,LOW(512)
	SBCI R31,HIGH(512)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Wert)
	LDI  R27,HIGH(_Wert)
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(_Wert)
	LDI  R27,HIGH(_Wert)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	SUBI R30,LOW(374)
	SBCI R31,HIGH(374)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Wert)
	LDI  R27,HIGH(_Wert)
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sWIICAM)
	SBCI R31,HIGH(-_sWIICAM)
	LD   R30,Z
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Wert)
	LDI  R27,HIGH(_Wert)
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wiicamobject,R30
	STS  _wiicamobject+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	MOV  R30,R17
	SUBI R30,LOW(2)
	LDI  R26,LOW(20)
	MULS R30,R26
	ST   -Y,R0
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x22:
	LDS  R30,_iTime
	LDS  R31,_iTime+1
	CLR  R22
	CLR  R23
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4250CCCD
	CALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _ipwmcompareleft,R30
	STS  _ipwmcompareleft+1,R31
	STS  _ipwmcompareright,R30
	STS  _ipwmcompareright+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x24:
	LDI  R30,LOW(0)
	STS  _ipwmcompareleft,R30
	STS  _ipwmcompareleft+1,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _ipwmcompareright,R30
	STS  _ipwmcompareright+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _ipwmcompareleft,R30
	STS  _ipwmcompareleft+1,R31
	LDI  R30,LOW(0)
	STS  _ipwmcompareright,R30
	STS  _ipwmcompareright+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	CBI  0x1B,7
	SBI  0x1B,5
	CALL _lcd_clear
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x27:
	CALL _lcd_puts
	LDS  R30,_wheelEncoderCounter_left
	LDS  R31,_wheelEncoderCounter_left+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	CALL _itoa
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x28:
	CALL _lcd_puts
	LDS  R30,_wheelEncoderCounter_right
	LDS  R31,_wheelEncoderCounter_right+1
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	CALL _itoa
	LDI  R26,LOW(_str)
	LDI  R27,HIGH(_str)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	SBI  0x1B,7
	CBI  0x1B,5
	CALL _lcd_clear
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 61 TIMES, CODE SIZE REDUCTION:117 WORDS
SUBOPT_0x2A:
	STS  _detector_value,R30
	STS  _detector_value+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x30:
	CBI  0x1B,1
	CBI  0x1B,3
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	CBI  0x1B,7
	CBI  0x1B,5
	CALL _lcd_clear
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:159 WORDS
SUBOPT_0x32:
	CALL _lcd_puts
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
	CALL _lcd_clear
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	LDS  R26,_ipwmcounter
	LDS  R27,_ipwmcounter+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x34:
	CALL __long_delay_G104
	LDI  R26,LOW(48)
	JMP  __lcd_init_write_G104

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
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

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

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
