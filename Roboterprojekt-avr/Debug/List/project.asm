
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
	.DEF _currstate=R4
	.DEF _currstate_msb=R5
	.DEF _state=R6
	.DEF _state_msb=R7
	.DEF _line_left=R8
	.DEF _line_left_msb=R9
	.DEF _line_mleft=R10
	.DEF _line_mleft_msb=R11
	.DEF _line_mright=R12
	.DEF _line_mright_msb=R13

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
	JMP  _twi_int_handler
	JMP  0x00

_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x000B

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x11,0x0

_0x3:
	.DB  0x5E,0x1
_0x4:
	.DB  0xA0,0xF
_0x5:
	.DB  0x1
_0x6:
	.DB  0xAA
_0x7:
	.DB  0xA
_0x0:
	.DB  0x50,0x4F,0x53,0x49,0x54,0x49,0x4F,0x4E
	.DB  0x2D,0x53,0x45,0x52,0x56,0x4F,0x0,0x44
	.DB  0x41,0x54,0x41,0x0,0x4C,0x45,0x46,0x54
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
	.DB  0x20,0x20,0x4D,0x4F,0x54,0x4F,0x52,0x45
	.DB  0x4E,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x4C,0x45,0x4E,0x4B,0x55
	.DB  0x4E,0x47,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x44,0x49,0x53,0x54,0x41,0x4E,0x5A,0x20
	.DB  0x53,0x45,0x4E,0x53,0x4F,0x52,0x20,0x0
	.DB  0x20,0x20,0x4C,0x49,0x43,0x48,0x54,0x20
	.DB  0x53,0x45,0x4E,0x53,0x4F,0x52,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x57,0x49
	.DB  0x49,0x20,0x43,0x41,0x4D,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x49,0x52,0x20
	.DB  0x54,0x4F,0x57,0x45,0x52,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x53
	.DB  0x45,0x52,0x56,0x4F,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x55,0x4C,0x54,0x52
	.DB  0x41,0x53,0x43,0x48,0x41,0x4C,0x4C,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x56,0x4F,0x52,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x5A,0x55,0x52,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x4C,0x49,0x4E,0x4B,0x53,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x52,0x45,0x43,0x48,0x54
	.DB  0x53,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x39,0x30,0x4C,0x49
	.DB  0x4E,0x4B,0x53,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x39,0x30,0x52
	.DB  0x45,0x43,0x48,0x54,0x53,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x44,0x52
	.DB  0x45,0x48,0x55,0x4E,0x47,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x20,0x20,0x31,0x6D
	.DB  0x31,0x6D,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x42,0x6C,0x75,0x65,0x4D,0x61
	.DB  0x74,0x69,0x63,0x73,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x52,0x6F,0x62,0x62,0x79,0x0
	.DB  0x4F,0x4B,0x0,0x42,0x75,0x66,0x66,0x65
	.DB  0x72,0x20,0x6F,0x76,0x65,0x72,0x66,0x6C
	.DB  0x6F,0x77,0x0,0x41,0x72,0x62,0x69,0x74
	.DB  0x72,0x61,0x74,0x69,0x6F,0x6E,0x20,0x6C
	.DB  0x6F,0x73,0x74,0x0,0x42,0x75,0x73,0x20
	.DB  0x65,0x72,0x72,0x6F,0x72,0x0,0x4E,0x41
	.DB  0x43,0x4B,0x20,0x72,0x65,0x63,0x65,0x69
	.DB  0x76,0x65,0x64,0x0,0x42,0x75,0x73,0x20
	.DB  0x74,0x69,0x6D,0x65,0x6F,0x75,0x74,0x0
	.DB  0x46,0x61,0x69,0x6C,0x0,0x55,0x6E,0x6B
	.DB  0x6E,0x6F,0x77,0x6E,0x20,0x65,0x72,0x72
	.DB  0x6F,0x72,0x0
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
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x01
	.DW  _servo_breaks
	.DW  _0x5*2

	.DW  0x01
	.DW  _servo_value_cur
	.DW  _0x6*2

	.DW  0x0F
	.DW  _0x15
	.DW  _0x0*2

	.DW  0x05
	.DW  _0x23
	.DW  _0x0*2+15

	.DW  0x08
	.DW  _0x47
	.DW  _0x0*2+20

	.DW  0x08
	.DW  _0x47+8
	.DW  _0x0*2+28

	.DW  0x0A
	.DW  _0x47+16
	.DW  _0x0*2+36

	.DW  0x0A
	.DW  _0x47+26
	.DW  _0x0*2+46

	.DW  0x09
	.DW  _0x47+36
	.DW  _0x0*2+56

	.DW  0x09
	.DW  _0x47+45
	.DW  _0x0*2+65

	.DW  0x09
	.DW  _0x47+54
	.DW  _0x0*2+74

	.DW  0x09
	.DW  _0x47+63
	.DW  _0x0*2+83

	.DW  0x11
	.DW  _0x54
	.DW  _0x0*2+92

	.DW  0x11
	.DW  _0x54+17
	.DW  _0x0*2+109

	.DW  0x03
	.DW  _0x54+34
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0x54+37
	.DW  _0x0*2+129

	.DW  0x10
	.DW  _0x64
	.DW  _0x0*2+133

	.DW  0x0F
	.DW  _0x64+16
	.DW  _0x0*2+149

	.DW  0x03
	.DW  _0x64+31
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0x64+34
	.DW  _0x0*2+129

	.DW  0x08
	.DW  _0x70
	.DW  _0x0*2+20

	.DW  0x08
	.DW  _0x70+8
	.DW  _0x0*2+28

	.DW  0x0A
	.DW  _0x70+16
	.DW  _0x0*2+36

	.DW  0x0A
	.DW  _0x70+26
	.DW  _0x0*2+46

	.DW  0x09
	.DW  _0x70+36
	.DW  _0x0*2+164

	.DW  0x09
	.DW  _0x70+45
	.DW  _0x0*2+173

	.DW  0x09
	.DW  _0x70+54
	.DW  _0x0*2+182

	.DW  0x09
	.DW  _0x70+63
	.DW  _0x0*2+191

	.DW  0x06
	.DW  _0x78
	.DW  _0x0*2+200

	.DW  0x07
	.DW  _0x78+6
	.DW  _0x0*2+206

	.DW  0x03
	.DW  _0xBB
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xBB+3
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xC7
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xC7+3
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xD3
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xD3+3
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xE1
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xE1+3
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xE1+7
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xE1+10
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xE1+14
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xE1+17
	.DW  _0x0*2+129

	.DW  0x03
	.DW  _0xE1+21
	.DW  _0x0*2+126

	.DW  0x04
	.DW  _0xE1+24
	.DW  _0x0*2+129

	.DW  0x11
	.DW  _0x11C
	.DW  _0x0*2+252

	.DW  0x11
	.DW  _0x11C+17
	.DW  _0x0*2+269

	.DW  0x11
	.DW  _0x11C+34
	.DW  _0x0*2+286

	.DW  0x11
	.DW  _0x11C+51
	.DW  _0x0*2+303

	.DW  0x11
	.DW  _0x11C+68
	.DW  _0x0*2+320

	.DW  0x10
	.DW  _0x11C+85
	.DW  _0x0*2+337

	.DW  0x11
	.DW  _0x11C+101
	.DW  _0x0*2+353

	.DW  0x0F
	.DW  _0x11C+118
	.DW  _0x0*2+370

	.DW  0x11
	.DW  _0x11C+133
	.DW  _0x0*2+385

	.DW  0x11
	.DW  _0x11C+150
	.DW  _0x0*2+402

	.DW  0x11
	.DW  _0x11C+167
	.DW  _0x0*2+419

	.DW  0x12
	.DW  _0x11C+184
	.DW  _0x0*2+436

	.DW  0x11
	.DW  _0x11C+202
	.DW  _0x0*2+454

	.DW  0x12
	.DW  _0x11C+219
	.DW  _0x0*2+471

	.DW  0x11
	.DW  _0x11C+237
	.DW  _0x0*2+489

	.DW  0x10
	.DW  _0x11C+254
	.DW  _0x0*2+506

	.DW  0x0D
	.DW  _0x11C+270
	.DW  _0x0*2+522

	.DW  0x0E
	.DW  _0x11C+283
	.DW  _0x0*2+535

	.DW  0x0B
	.DW  _0x11C+297
	.DW  _0x0*2+549

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
;
;
;
;//Verkürzung von lcd_puts
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
	BRLO _0x8
	LDI  R30,LOW(0)
	STS  _input_index_S0000000000,R30
_0x8:
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
	BRGE _0x9
	LDI  R26,LOW(_wheelEncoderCounter_right)
	LDI  R27,HIGH(_wheelEncoderCounter_right)
	CALL SUBOPT_0x2
	RJMP _0xA
_0x9:
	CALL SUBOPT_0x3
_0xA:
	RJMP _0x159
; .FEND
_ext_int6_isr:
; .FSTART _ext_int6_isr
	CALL SUBOPT_0x0
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x4E20)
	LDI  R30,HIGH(0x4E20)
	CPC  R27,R30
	BRGE _0xB
	LDI  R26,LOW(_wheelEncoderCounter_left)
	LDI  R27,HIGH(_wheelEncoderCounter_left)
	CALL SUBOPT_0x2
	RJMP _0xC
_0xB:
	CALL SUBOPT_0x5
_0xC:
	RJMP _0x159
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
	LDI  R30,LOW(4)
	OUT  0x25,R30
	LDI  R30,LOW(0)
	OUT  0x24,R30
	OUT  0x23,R30
	LDI  R30,LOW(81)
	OUT  0x37,R30
	LDI  R30,LOW(48)
	STS  125,R30
	sei
	RET
; .FEND
;#include "modules/servo_ir.h"
_timer2_ovf_isr:
; .FSTART _timer2_ovf_isr
	CALL SUBOPT_0x0
	CBI  0x12,7
	LDS  R30,_servo_value_copy
	LDS  R31,_servo_value_copy+1
	CALL SUBOPT_0x6
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x10
	LDS  R26,_servo_breaks
	LDS  R27,_servo_breaks+1
	SBIW R26,5
	BRNE _0xF
_0x10:
	LDS  R30,_servo_value_cur
	LDS  R31,_servo_value_cur+1
	STS  _servo_value_copy,R30
	STS  _servo_value_copy+1,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _servo_breaks,R30
	STS  _servo_breaks+1,R31
	LDS  R30,_servo_value_cur
	OUT  0x24,R30
	SBI  0x12,7
	RJMP _0x14
_0xF:
	LDI  R26,LOW(_servo_breaks)
	LDI  R27,HIGH(_servo_breaks)
	CALL SUBOPT_0x2
	LDI  R30,LOW(0)
	OUT  0x24,R30
_0x14:
	RJMP _0x159
; .FEND
_fnDisplay:
; .FSTART _fnDisplay
	SBIW R28,10
;	str -> Y+0
	CALL _lcd_clear
	__POINTW2MN _0x15,0
	CALL SUBOPT_0x7
	LDS  R30,_servo_value_cur
	LDS  R31,_servo_value_cur+1
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
_0x15:
	.BYTE 0xF

	.CSEG
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	CALL SUBOPT_0x0
	LDI  R30,LOW(254)
	OUT  0x32,R30
	LDS  R26,_rc5_time
	SUBI R26,-LOW(1)
	STS  _rc5_time,R26
	CPI  R26,LOW(0x44)
	BRLO _0x16
	__GETB1MN _tmp,1
	ANDI R30,LOW(0x40)
	BRNE _0x18
	__GETB1MN _tmp,1
	ANDI R30,LOW(0x20)
	BRNE _0x19
_0x18:
	RJMP _0x17
_0x19:
	CALL SUBOPT_0x8
	STS  _rc5_data,R30
	STS  _rc5_data+1,R31
_0x17:
	LDI  R30,LOW(0)
	STS  _tmp,R30
	STS  _tmp+1,R30
_0x16:
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
	BREQ _0x1A
	LDI  R30,LOW(1)
	EOR  R2,R30
	LDS  R26,_rc5_time
	CPI  R26,LOW(0xB)
	BRSH _0x1B
	LDI  R30,LOW(0)
	STS  _tmp,R30
	STS  _tmp+1,R30
_0x1B:
	CALL SUBOPT_0x8
	SBIW R30,0
	BREQ _0x1D
	LDS  R26,_rc5_time
	CPI  R26,LOW(0x2D)
	BRLO _0x1C
_0x1D:
	__GETB1MN _tmp,1
	ANDI R30,LOW(0x40)
	BRNE _0x1F
	CALL SUBOPT_0x8
	LSL  R30
	ROL  R31
	STS  _tmp,R30
	STS  _tmp+1,R31
_0x1F:
	SBRC R2,0
	RJMP _0x20
	CALL SUBOPT_0x8
	ORI  R30,1
	STS  _tmp,R30
	STS  _tmp+1,R31
_0x20:
	LDI  R30,LOW(0)
	STS  _rc5_time,R30
_0x1C:
_0x1A:
	RJMP _0x159
; .FEND
_timer1_compa_isr:
; .FSTART _timer1_compa_isr
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
	BREQ _0x21
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
	RJMP _0x20E0008
_0x21:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
_0x20E0008:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,8
	RET
; .FEND
_rc5_display:
; .FSTART _rc5_display
	CALL _lcd_clear
	__POINTW2MN _0x23,0
	CALL SUBOPT_0x7
	LDS  R26,_ucToggle
	SUBI R26,-LOW(48)
	CALL _lcd_putchar
	LDI  R26,LOW(32)
	CALL _lcd_putchar
	LDS  R30,_ucAdress
	CALL SUBOPT_0x9
	LDI  R26,LOW(32)
	CALL _lcd_putchar
	LDS  R30,_ucData
	CALL SUBOPT_0x9
	RET
; .FEND

	.DSEG
_0x23:
	.BYTE 0x5
;#include "modules/esp_main_func.h"

	.CSEG
_esp_states:
; .FSTART _esp_states
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x24
	CALL SUBOPT_0x6
	CPI  R26,LOW(0xDC)
	LDI  R30,HIGH(0xDC)
	CPC  R27,R30
	BRGE _0x25
	LDI  R26,LOW(_servo_value_cur)
	LDI  R27,HIGH(_servo_value_cur)
	CALL SUBOPT_0x2
_0x25:
_0x24:
	LDI  R30,LOW(21)
	LDI  R31,HIGH(21)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x26
	CALL SUBOPT_0x6
	CPI  R26,LOW(0x79)
	LDI  R30,HIGH(0x79)
	CPC  R27,R30
	BRLT _0x27
	LDI  R26,LOW(_servo_value_cur)
	LDI  R27,HIGH(_servo_value_cur)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x27:
_0x26:
	MOV  R0,R4
	OR   R0,R5
	BRNE _0x28
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	RJMP _0x14F
_0x28:
	MOVW R30,R4
	SBIW R30,1
_0x14F:
	MOVW R6,R30
	RET
; .FEND
_esp_mainfunctions:
; .FSTART _esp_mainfunctions
	SBIC 0x0,0
	RJMP _0x2A
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
	RJMP _0x2B
_0x2A:
	CLR  R8
	CLR  R9
_0x2B:
	SBIC 0x0,2
	RJMP _0x2C
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R10,R30
	RJMP _0x2D
_0x2C:
	CLR  R10
	CLR  R11
_0x2D:
	SBIC 0x0,4
	RJMP _0x2E
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R12,R30
	RJMP _0x2F
_0x2E:
	CLR  R12
	CLR  R13
_0x2F:
	SBIC 0x0,6
	RJMP _0x30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _line_right,R30
	STS  _line_right+1,R31
	RJMP _0x31
_0x30:
	LDI  R30,LOW(0)
	STS  _line_right,R30
	STS  _line_right+1,R30
_0x31:
	MOVW R30,R8
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL __MULW12
	MOVW R22,R30
	MOVW R30,R10
	CALL SUBOPT_0xA
	MOVW R30,R12
	CALL SUBOPT_0xB
	LDS  R26,_line_right
	LDS  R27,_line_right+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _linesensorvaluetemp,R30
	STS  _linesensorvaluetemp+1,R31
	SBIC 0x16,0
	RJMP _0x32
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _dist_left,R30
	STS  _dist_left+1,R31
	RJMP _0x33
_0x32:
	LDI  R30,LOW(0)
	STS  _dist_left,R30
	STS  _dist_left+1,R30
_0x33:
	SBIC 0x16,2
	RJMP _0x34
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _dist_fleft,R30
	STS  _dist_fleft+1,R31
	RJMP _0x35
_0x34:
	LDI  R30,LOW(0)
	STS  _dist_fleft,R30
	STS  _dist_fleft+1,R30
_0x35:
	SBIC 0x16,4
	RJMP _0x36
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _dist_fright,R30
	STS  _dist_fright+1,R31
	RJMP _0x37
_0x36:
	LDI  R30,LOW(0)
	STS  _dist_fright,R30
	STS  _dist_fright+1,R30
_0x37:
	SBIC 0x16,6
	RJMP _0x38
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _dist_right,R30
	STS  _dist_right+1,R31
	RJMP _0x39
_0x38:
	LDI  R30,LOW(0)
	STS  _dist_right,R30
	STS  _dist_right+1,R30
_0x39:
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
	CALL SUBOPT_0xC
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
_0x3B:
	CPI  R17,15
	BRSH _0x3C
	MOV  R30,R17
	LDI  R26,LOW(_data)
	LDI  R27,HIGH(_data)
	LDI  R31,0
	CALL SUBOPT_0xD
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
	RJMP _0x3B
_0x3C:
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
_0x3E:
	__CPWRN 16,17,4
	BRLT PC+2
	RJMP _0x3F
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	ANDI R30,LOW(0x30)
	ANDI R31,HIGH(0x30)
	CALL __LSLW4
	STS  _temp,R30
	STS  _temp+1,R31
	MOVW R30,R16
	LDI  R26,LOW(_x)
	LDI  R27,HIGH(_x)
	CALL SUBOPT_0xD
	MOVW R22,R30
	CALL SUBOPT_0xE
	MOVW R26,R30
	LSL  R26
	ROL  R27
	__ADDW2MN _data,2
	CALL SUBOPT_0x10
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	ANDI R30,LOW(0xC0)
	ANDI R31,HIGH(0xC0)
	CALL __LSLW2
	STS  _temp,R30
	STS  _temp+1,R31
	MOVW R30,R16
	LDI  R26,LOW(_y)
	LDI  R27,HIGH(_y)
	CALL SUBOPT_0xD
	MOVW R22,R30
	CALL SUBOPT_0xE
	MOVW R26,R30
	LSL  R26
	ROL  R27
	__ADDW2MN _data,4
	CALL SUBOPT_0x10
	MOVW R30,R16
	SUBI R30,LOW(-_sWIICAM)
	SBCI R31,HIGH(-_sWIICAM)
	MOVW R22,R30
	CALL SUBOPT_0xE
	MOVW R26,R30
	LSL  R26
	ROL  R27
	__ADDW2MN _data,6
	LD   R30,X
	ANDI R30,LOW(0xF)
	MOVW R26,R22
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0x3E
_0x3F:
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
	RJMP _0x40
	LDS  R30,_icr3
	LDS  R31,_icr3+1
	STS  _iRisingEdge,R30
	STS  _iRisingEdge+1,R31
	LDS  R30,138
	ANDI R30,0xBF
	STS  138,R30
	RJMP _0x41
_0x40:
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
	BLD  R2,6
_0x41:
_0x159:
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
	RJMP _0x46
	__POINTW2MN _0x47,0
	RJMP _0x150
_0x46:
	__POINTW2MN _0x47,8
_0x150:
	CALL _lcd_puts
	SBIC 0x0,6
	RJMP _0x49
	__POINTW2MN _0x47,16
	RJMP _0x151
_0x49:
	__POINTW2MN _0x47,26
_0x151:
	CALL _lcd_puts
	CALL SUBOPT_0x11
	SBIC 0x0,2
	RJMP _0x4B
	__POINTW2MN _0x47,36
	RJMP _0x152
_0x4B:
	__POINTW2MN _0x47,45
_0x152:
	CALL _lcd_puts
	SBIC 0x0,4
	RJMP _0x4D
	__POINTW2MN _0x47,54
	RJMP _0x153
_0x4D:
	__POINTW2MN _0x47,63
_0x153:
	CALL _lcd_puts
	RET
; .FEND

	.DSEG
_0x47:
	.BYTE 0x48

	.CSEG
_STATE_ENGINE:
; .FSTART _STATE_ENGINE
	SBIW R28,17
;	str -> Y+0
	CALL SUBOPT_0x12
	BRNE _0x53
	__POINTW2MN _0x54,0
	CALL _lcd_puts
	CBI  0x1B,7
	CBI  0x1B,5
	RJMP _0x59
_0x53:
	__POINTW2MN _0x54,17
	CALL _lcd_puts
	SBI  0x1B,7
	SBI  0x1B,5
_0x59:
	CALL SUBOPT_0x11
	__POINTW2MN _0x54,34
	CALL SUBOPT_0x13
	__POINTW2MN _0x54,37
	CALL SUBOPT_0x14
	SBIC 0x19,6
	RJMP _0x5E
	CALL SUBOPT_0x15
_0x5E:
	ADIW R28,17
	RET
; .FEND

	.DSEG
_0x54:
	.BYTE 0x29

	.CSEG
_STATE_ENGINE_DIR:
; .FSTART _STATE_ENGINE_DIR
	SBIW R28,10
;	str -> Y+0
	CALL SUBOPT_0x12
	BRNE _0x63
	__POINTW2MN _0x64,0
	CALL _lcd_puts
	CBI  0x1B,7
	SBI  0x1B,5
	RJMP _0x69
_0x63:
	__POINTW2MN _0x64,16
	CALL _lcd_puts
	SBI  0x1B,7
	CBI  0x1B,5
_0x69:
	CALL SUBOPT_0x11
	__POINTW2MN _0x64,31
	CALL SUBOPT_0x13
	__POINTW2MN _0x64,34
	CALL SUBOPT_0x14
	SBIC 0x19,6
	RJMP _0x6E
	CALL SUBOPT_0x15
_0x6E:
_0x20E0007:
	ADIW R28,10
	RET
; .FEND

	.DSEG
_0x64:
	.BYTE 0x26

	.CSEG
_STATE_DISTANCE_SENSOR:
; .FSTART _STATE_DISTANCE_SENSOR
	CALL _lcd_clear
	SBIC 0x16,0
	RJMP _0x6F
	__POINTW2MN _0x70,0
	RJMP _0x154
_0x6F:
	__POINTW2MN _0x70,8
_0x154:
	CALL _lcd_puts
	SBIC 0x16,6
	RJMP _0x72
	__POINTW2MN _0x70,16
	RJMP _0x155
_0x72:
	__POINTW2MN _0x70,26
_0x155:
	CALL _lcd_puts
	CALL SUBOPT_0x11
	SBIC 0x16,2
	RJMP _0x74
	__POINTW2MN _0x70,36
	RJMP _0x156
_0x74:
	__POINTW2MN _0x70,45
_0x156:
	CALL _lcd_puts
	SBIC 0x16,4
	RJMP _0x76
	__POINTW2MN _0x70,54
	RJMP _0x157
_0x76:
	__POINTW2MN _0x70,63
_0x157:
	CALL _lcd_puts
	RET
; .FEND

	.DSEG
_0x70:
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
	__POINTW2MN _0x78,0
	CALL _lcd_puts
	ST   -Y,R19
	ST   -Y,R18
	CALL SUBOPT_0x16
	CALL SUBOPT_0x7
	__POINTW2MN _0x78,6
	CALL _lcd_puts
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x16
	CALL _lcd_puts
	CALL __LOADLOCR4
	ADIW R28,14
	RET
; .FEND

	.DSEG
_0x78:
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
_0x7A:
	CPI  R17,4
	BRLO PC+2
	RJMP _0x7B
	CPI  R17,2
	BRSH _0x7C
	CALL SUBOPT_0x17
	CPI  R30,LOW(0x3FF)
	LDI  R26,HIGH(0x3FF)
	CPC  R31,R26
	BREQ _0x7E
	CALL SUBOPT_0x18
	CPI  R30,LOW(0x3FF)
	LDI  R26,HIGH(0x3FF)
	CPC  R31,R26
	BRNE _0x7D
_0x7E:
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1A
	RJMP _0x80
_0x7D:
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x19
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1D
	LDI  R26,LOW(20)
	MULS R17,R26
	MOVW R30,R0
	SUBI R30,-LOW(8)
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1F
	LDI  R26,LOW(20)
	MULS R17,R26
	MOVW R30,R0
	SUBI R30,-LOW(16)
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x20
_0x80:
	RJMP _0x81
_0x7C:
	CALL SUBOPT_0x17
	CPI  R30,LOW(0x3FF)
	LDI  R26,HIGH(0x3FF)
	CPC  R31,R26
	BREQ _0x83
	CALL SUBOPT_0x18
	CPI  R30,LOW(0x3FF)
	LDI  R26,HIGH(0x3FF)
	CPC  R31,R26
	BRNE _0x82
_0x83:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1A
	RJMP _0x85
_0x82:
	CALL SUBOPT_0x17
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1D
	MOV  R30,R17
	SUBI R30,LOW(2)
	LDI  R26,LOW(20)
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(8)
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1F
	MOV  R30,R17
	SUBI R30,LOW(2)
	LDI  R26,LOW(20)
	MULS R30,R26
	MOVW R30,R0
	SUBI R30,-LOW(16)
	CALL SUBOPT_0x22
	CALL SUBOPT_0x20
_0x85:
_0x81:
	SUBI R17,-1
	RJMP _0x7A
_0x7B:
	LDI  R26,LOW(30)
	LDI  R27,0
	CALL _delay_ms
	SBIS 0x18,3
	RJMP _0x86
	CBI  0x18,3
	RJMP _0x87
_0x86:
	SBI  0x18,3
_0x87:
_0x20E0006:
	LD   R17,Y+
	RET
; .FEND
_STATE_IRTOWER:
; .FSTART _STATE_IRTOWER
	RCALL _rc5_display
	CALL SUBOPT_0x23
	BREQ _0x88
	LDS  R30,_ucData
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x8B
	CALL SUBOPT_0xC
_0x8B:
_0x88:
	RET
; .FEND
_STATE_SERVO:
; .FSTART _STATE_SERVO
	CALL _lcd_clear
	RCALL _fnDisplay
	LDI  R26,LOW(200)
	RJMP _0x20E0003
; .FEND
_STATE_ULTRASONIC:
; .FSTART _STATE_ULTRASONIC
	SBRS R2,6
	RJMP _0x8D
	CALL SUBOPT_0x11
	LDS  R26,_iTime
	LDS  R27,_iTime+1
	CPI  R26,LOW(0x1771)
	LDI  R30,HIGH(0x1771)
	CPC  R27,R30
	BRSH _0x8E
	CALL _lcd_clear
	__POINTW2FN _0x0,224
	CALL _lcd_putsf
	CALL SUBOPT_0x11
	CALL SUBOPT_0x24
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
	BLD  R2,6
_0x8D:
	RET
; .FEND
_STATE_VOR:
; .FSTART _STATE_VOR
	SBI  0x1B,1
	RJMP _0x20E0005
; .FEND
_STATE_ZUR:
; .FSTART _STATE_ZUR
	SBI  0x1B,1
	SBI  0x1B,3
	SBI  0x1B,7
	SBI  0x1B,5
	RET
; .FEND
_STATE_LINKS:
; .FSTART _STATE_LINKS
	SBI  0x1B,1
	CBI  0x1B,3
	RJMP _0x20E0004
; .FEND
_STATE_RECHTS:
; .FSTART _STATE_RECHTS
	CBI  0x1B,1
_0x20E0005:
	SBI  0x1B,3
_0x20E0004:
	CBI  0x1B,7
	CBI  0x1B,5
	RET
; .FEND
_STATE_90RECHTS:
; .FSTART _STATE_90RECHTS
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3
_0xB1:
	CALL SUBOPT_0x25
	__POINTW2MN _0xBB,0
	CALL SUBOPT_0x26
	__POINTW2MN _0xBB,3
	CALL SUBOPT_0x27
	CALL SUBOPT_0x1
	SBIW R26,17
	BRLT _0xB1
	RET
; .FEND

	.DSEG
_0xBB:
	.BYTE 0x7

	.CSEG
_STATE_90LINKS:
; .FSTART _STATE_90LINKS
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3
_0xBD:
	CALL SUBOPT_0x28
	__POINTW2MN _0xC7,0
	CALL SUBOPT_0x26
	__POINTW2MN _0xC7,3
	CALL SUBOPT_0x27
	CALL SUBOPT_0x4
	SBIW R26,17
	BRLT _0xBD
	RET
; .FEND

	.DSEG
_0xC7:
	.BYTE 0x7

	.CSEG
_STATE_DREHUNG:
; .FSTART _STATE_DREHUNG
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3
_0xC9:
	SBI  0x1B,1
	SBI  0x1B,3
	SBI  0x1B,7
	CALL SUBOPT_0x29
	__POINTW2MN _0xD3,0
	CALL SUBOPT_0x26
	__POINTW2MN _0xD3,3
	CALL SUBOPT_0x27
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRGE _0xD4
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLT _0xD5
_0xD4:
	RJMP _0xCA
_0xD5:
	RJMP _0xC9
_0xCA:
	RET
; .FEND

	.DSEG
_0xD3:
	.BYTE 0x7

	.CSEG
_STATE_METERLINKSMETERRECHTS:
; .FSTART _STATE_METERLINKSMETERRECHTS
	CALL SUBOPT_0x5
	CALL SUBOPT_0x3
_0xD7:
	CALL SUBOPT_0x28
	__POINTW2MN _0xE1,0
	CALL SUBOPT_0x26
	__POINTW2MN _0xE1,3
	CALL SUBOPT_0x27
	CALL SUBOPT_0x4
	SBIW R26,17
	BRLT _0xD7
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x3
_0xE7:
	SBI  0x1B,1
	SBI  0x1B,3
	CBI  0x1B,7
	CALL SUBOPT_0x29
	__POINTW2MN _0xE1,7
	CALL SUBOPT_0x26
	__POINTW2MN _0xE1,10
	CALL SUBOPT_0x27
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRGE _0xF1
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0xF2
_0xF1:
	RJMP _0xE8
_0xF2:
	RJMP _0xE7
_0xE8:
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x3
_0xF8:
	CALL SUBOPT_0x25
	__POINTW2MN _0xE1,14
	CALL SUBOPT_0x26
	__POINTW2MN _0xE1,17
	CALL SUBOPT_0x27
	CALL SUBOPT_0x1
	SBIW R26,17
	BRLT _0xF8
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x3
_0x107:
	SBI  0x1B,1
	SBI  0x1B,3
	CBI  0x1B,7
	CALL SUBOPT_0x29
	__POINTW2MN _0xE1,21
	CALL SUBOPT_0x26
	__POINTW2MN _0xE1,24
	CALL SUBOPT_0x27
	CALL SUBOPT_0x4
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRGE _0x111
	CALL SUBOPT_0x1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	BRLT _0x112
_0x111:
	RJMP _0x108
_0x112:
	RJMP _0x107
_0x108:
	RET
; .FEND

	.DSEG
_0xE1:
	.BYTE 0x1C

	.CSEG
_STATE_MACHINE:
; .FSTART _STATE_MACHINE
	CBI  0x1B,1
	CBI  0x1B,3
	MOVW R30,R6
	SBIW R30,0
	BRNE _0x11A
	CALL SUBOPT_0x2B
	BRNE _0x11B
	CALL _lcd_clear
	__POINTW2MN _0x11C,0
	CALL SUBOPT_0x2C
_0x11B:
	RCALL _STATE_LINE_SENSOR
	RJMP _0x119
_0x11A:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x11D
	CALL SUBOPT_0x2B
	BRNE _0x11E
	CALL _lcd_clear
	__POINTW2MN _0x11C,17
	CALL SUBOPT_0x2C
_0x11E:
	RCALL _STATE_ENGINE
	RJMP _0x119
_0x11D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x11F
	CALL SUBOPT_0x2B
	BRNE _0x120
	CALL _lcd_clear
	__POINTW2MN _0x11C,34
	CALL SUBOPT_0x2C
_0x120:
	RCALL _STATE_ENGINE_DIR
	RJMP _0x119
_0x11F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x121
	CALL SUBOPT_0x2B
	BRNE _0x122
	CALL _lcd_clear
	__POINTW2MN _0x11C,51
	CALL SUBOPT_0x2C
_0x122:
	RCALL _STATE_DISTANCE_SENSOR
	RJMP _0x119
_0x121:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x123
	CALL SUBOPT_0x2B
	BRNE _0x124
	CALL _lcd_clear
	__POINTW2MN _0x11C,68
	CALL SUBOPT_0x2C
_0x124:
	RCALL _STATE_LIGHTSENSOR
	RJMP _0x119
_0x123:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0x125
	CALL SUBOPT_0x2B
	BRNE _0x126
	CALL _lcd_clear
	__POINTW2MN _0x11C,85
	CALL SUBOPT_0x2C
_0x126:
	RCALL _STATE_WIICAM
	RJMP _0x119
_0x125:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x127
	CALL SUBOPT_0x2B
	BRNE _0x128
	CALL _lcd_clear
	__POINTW2MN _0x11C,101
	CALL SUBOPT_0x2C
_0x128:
	RCALL _STATE_IRTOWER
	RJMP _0x119
_0x127:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x129
	CALL SUBOPT_0x2B
	BRNE _0x12A
	CALL _lcd_clear
	__POINTW2MN _0x11C,118
	CALL SUBOPT_0x2C
_0x12A:
	RCALL _STATE_SERVO
	RJMP _0x119
_0x129:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x12B
	CALL SUBOPT_0x2B
	BRNE _0x12C
	CALL _lcd_clear
	__POINTW2MN _0x11C,133
	CALL SUBOPT_0x2C
_0x12C:
	RCALL _STATE_ULTRASONIC
	RJMP _0x119
_0x12B:
	CPI  R30,LOW(0x9)
	LDI  R26,HIGH(0x9)
	CPC  R31,R26
	BRNE _0x12D
	CALL SUBOPT_0x2B
	BRNE _0x12E
	CALL _lcd_clear
	__POINTW2MN _0x11C,150
	CALL SUBOPT_0x2C
_0x12E:
	RCALL _STATE_VOR
	RJMP _0x119
_0x12D:
	CPI  R30,LOW(0xA)
	LDI  R26,HIGH(0xA)
	CPC  R31,R26
	BRNE _0x12F
	CALL SUBOPT_0x2B
	BRNE _0x130
	CALL _lcd_clear
	__POINTW2MN _0x11C,167
	CALL SUBOPT_0x2C
_0x130:
	RCALL _STATE_ZUR
	RJMP _0x119
_0x12F:
	CPI  R30,LOW(0xB)
	LDI  R26,HIGH(0xB)
	CPC  R31,R26
	BRNE _0x131
	CALL SUBOPT_0x2B
	BRNE _0x132
	CALL _lcd_clear
	__POINTW2MN _0x11C,184
	CALL SUBOPT_0x2C
_0x132:
	RCALL _STATE_LINKS
	RJMP _0x119
_0x131:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x133
	CALL SUBOPT_0x2B
	BRNE _0x134
	CALL _lcd_clear
	__POINTW2MN _0x11C,202
	CALL SUBOPT_0x2C
_0x134:
	RCALL _STATE_RECHTS
	RJMP _0x119
_0x133:
	CPI  R30,LOW(0xD)
	LDI  R26,HIGH(0xD)
	CPC  R31,R26
	BRNE _0x135
	CALL SUBOPT_0x2B
	BRNE _0x136
	CALL _lcd_clear
	__POINTW2MN _0x11C,219
	CALL SUBOPT_0x2C
_0x136:
	RCALL _STATE_90LINKS
	RJMP _0x119
_0x135:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x137
	CALL SUBOPT_0x2B
	BRNE _0x138
	CALL _lcd_clear
	__POINTW2MN _0x11C,237
	CALL SUBOPT_0x2C
_0x138:
	RCALL _STATE_90RECHTS
	RJMP _0x119
_0x137:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x139
	CALL SUBOPT_0x2B
	BRNE _0x13A
	CALL _lcd_clear
	__POINTW2MN _0x11C,254
	CALL SUBOPT_0x2C
_0x13A:
	RCALL _STATE_DREHUNG
	RJMP _0x119
_0x139:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x13D
	CALL SUBOPT_0x2B
	BRNE _0x13C
	CALL _lcd_clear
	__POINTW2MN _0x11C,270
	CALL SUBOPT_0x2C
_0x13C:
	RCALL _STATE_METERLINKSMETERRECHTS
	RJMP _0x119
_0x13D:
	CALL _lcd_clear
	__POINTW2MN _0x11C,283
	CALL SUBOPT_0x7
	__POINTW2MN _0x11C,297
	CALL _lcd_puts
_0x119:
	LDI  R26,LOW(50)
_0x20E0003:
	LDI  R27,0
	CALL _delay_ms
	RET
; .FEND

	.DSEG
_0x11C:
	.BYTE 0x134
;#include "modules/esp.h"

	.CSEG
_slave_rx_handler:
; .FSTART _slave_rx_handler
	ST   -Y,R26
;	rx_complete -> Y+0
	LDS  R30,_twi_result
	CPI  R30,0
	BRNE _0x13E
	SET
	BLD  R2,5
	RJMP _0x13F
_0x13E:
	CLT
	BLD  R2,5
	LDI  R30,LOW(0)
	JMP  _0x20E0001
_0x13F:
	LD   R30,Y
	CPI  R30,0
	BREQ _0x140
	LDI  R30,LOW(0)
	JMP  _0x20E0001
_0x140:
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
	RJMP _0x141
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
	LDS  R30,_servo_value_cur
	__PUTB1MN _tx_buffer,12
	CALL SUBOPT_0x24
	__POINTW2MN _tx_buffer,13
	CALL __CFD1U
	ST   X,R30
	LDS  R30,_iTemp
	__PUTB1MN _tx_buffer,14
	LDI  R30,LOW(15)
	JMP  _0x20E0001
_0x141:
	SBRS R2,5
	RJMP _0x142
	__GETBRMN 4,_rx_buffer,14
	CLR  R5
_0x142:
	LDI  R30,LOW(0)
	JMP  _0x20E0001
; .FEND
;
;
;
;
;
;
;
;
;
;void main(void)
; 0000 004E {
_main:
; .FSTART _main
; 0000 004F // Ports initialisieren
; 0000 0050 port_init();
	RCALL _port_init
; 0000 0051 // I2C Bus initialisieren
; 0000 0052 i2c_init();
	CALL _i2c_init
; 0000 0053 //Kamera initialisieren
; 0000 0054 wii_cam_init();
	RCALL _wii_cam_init
; 0000 0055 // TWI slave initialization
; 0000 0056   twi_slave_init(false,TWI_SLAVE_ADDR,rx_buffer.bytes,BUFFER_SIZE,tx_buffer.bytes,slave_rx_handler,slave_tx_handler);
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
; 0000 0057 
; 0000 0058 while (1)
_0x143:
; 0000 0059       {
; 0000 005A       STATE_MACHINE();
	RCALL _STATE_MACHINE
; 0000 005B       esp_states();
	RCALL _esp_states
; 0000 005C 
; 0000 005D       if (!BUMPER_RIGHT){
	SBIC 0x19,6
	RJMP _0x146
; 0000 005E         state=16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	MOVW R6,R30
; 0000 005F       }
; 0000 0060 
; 0000 0061 
; 0000 0062 
; 0000 0063 
; 0000 0064 
; 0000 0065 ///////IR DATEN AUSWERTEN//////////
; 0000 0066     if(rc5_receive(&ucToggle, &ucAdress, &ucData))
_0x146:
	CALL SUBOPT_0x23
	BREQ _0x147
; 0000 0067     {
; 0000 0068       switch (ucData)
	LDS  R30,_ucData
	LDI  R31,0
; 0000 0069       {
; 0000 006A         case 0:
	SBIW R30,0
	BRNE _0x14B
; 0000 006B         state=state_stop;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	RJMP _0x158
; 0000 006C           delay_ms(100);
; 0000 006D           break;
; 0000 006E         case 1:
_0x14B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x14C
; 0000 006F         state=15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	RJMP _0x158
; 0000 0070           delay_ms(100);
; 0000 0071           break;
; 0000 0072         case 2:
_0x14C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x14A
; 0000 0073         state=16;
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
_0x158:
	MOVW R6,R30
; 0000 0074           delay_ms(100);
	CALL SUBOPT_0xC
; 0000 0075           break;
; 0000 0076       }
_0x14A:
; 0000 0077     }
; 0000 0078 esp_mainfunctions();
_0x147:
	RCALL _esp_mainfunctions
; 0000 0079 }
	RJMP _0x143
; 0000 007A }
_0x14E:
	RJMP _0x14E
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
	BLD  R3,0
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
	BLD  R2,7
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
	SBRS R2,7
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
	BLD  R2,7
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
	SBRS R2,7
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
	BLD  R2,7
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
	BLD  R3,0
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
	BLD  R2,7
	RJMP _0x206005A
_0x2060055:
	CPI  R30,LOW(0xB8)
	BRNE _0x206005B
_0x206005A:
	SBRS R2,7
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
	BLD  R2,7
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
	BLD  R3,0
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
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2D
	CALL SUBOPT_0x2D
	RCALL __long_delay_G104
	LDI  R26,LOW(32)
	RCALL __lcd_init_write_G104
	RCALL __long_delay_G104
	LDI  R26,LOW(40)
	CALL SUBOPT_0x2E
	LDI  R26,LOW(4)
	CALL SUBOPT_0x2E
	LDI  R26,LOW(133)
	CALL SUBOPT_0x2E
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
_strTemp:
	.BYTE 0x11
_servo_breaks:
	.BYTE 0x2
_servo_value_cur:
	.BYTE 0x2
_servo_value_copy:
	.BYTE 0x2
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
_state_info:
	.BYTE 0x2
_engine_dir:
	.BYTE 0x2
_wiicamobject:
	.BYTE 0x2
_str:
	.BYTE 0x11
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1:
	LDS  R26,_wheelEncoderCounter_right
	LDS  R27,_wheelEncoderCounter_right+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R26,_servo_value_cur
	LDS  R27,_servo_value_cur+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x7:
	CALL _lcd_puts
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDS  R30,_tmp
	LDS  R31,_tmp+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LDI  R31,0
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_s)
	LDI  R27,HIGH(_s)
	CALL _itoa
	LDI  R26,LOW(_s)
	LDI  R27,HIGH(_s)
	JMP  _lcd_puts

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
	LDI  R26,LOW(100)
	LDI  R27,0
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xE:
	MOVW R30,R16
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	MOVW R26,R30
	LSL  R26
	ROL  R27
	__ADDW2MN _data,6
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x10:
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
SUBOPT_0x11:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x12:
	SBI  0x1B,1
	SBI  0x1B,3
	CALL _lcd_clear
	LDS  R30,_engine_dir
	LDS  R31,_engine_dir+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x13:
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
SUBOPT_0x14:
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
SUBOPT_0x15:
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
SUBOPT_0x16:
	MOVW R26,R28
	ADIW R26,6
	CALL _itoa
	MOVW R26,R28
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x17:
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
SUBOPT_0x18:
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
SUBOPT_0x19:
	LDI  R26,LOW(20)
	MULS R17,R26
	ST   -Y,R0
	LDI  R26,LOW(0)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1A:
	__POINTW2FN _0x0,213
	CALL _lcd_putsf
	LDI  R30,LOW(0)
	STS  _wiicamobject,R30
	STS  _wiicamobject+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	SUBI R30,LOW(512)
	SBCI R31,HIGH(512)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Wert)
	LDI  R27,HIGH(_Wert)
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(_Wert)
	LDI  R27,HIGH(_Wert)
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	SUBI R30,LOW(374)
	SBCI R31,HIGH(374)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(_Wert)
	LDI  R27,HIGH(_Wert)
	JMP  _itoa

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	ST   -Y,R30
	LDI  R26,LOW(0)
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
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
SUBOPT_0x20:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _wiicamobject,R30
	STS  _wiicamobject+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	MOV  R30,R17
	SUBI R30,LOW(2)
	LDI  R26,LOW(20)
	MULS R30,R26
	ST   -Y,R0
	LDI  R26,LOW(1)
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	ST   -Y,R30
	LDI  R26,LOW(1)
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x23:
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
	CALL _rc5_receive
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x24:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	SBI  0x1B,1
	CBI  0x1B,3
	CBI  0x1B,7
	SBI  0x1B,5
	CALL _lcd_clear
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x26:
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
SUBOPT_0x27:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x28:
	CBI  0x1B,1
	SBI  0x1B,3
	SBI  0x1B,7
	CBI  0x1B,5
	CALL _lcd_clear
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	CBI  0x1B,5
	CALL _lcd_clear
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	CBI  0x1B,1
	CBI  0x1B,3
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x2B:
	LDS  R30,_state_info
	LDS  R31,_state_info+1
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:189 WORDS
SUBOPT_0x2C:
	CALL _lcd_puts
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
	CALL _lcd_clear
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _state_info,R30
	STS  _state_info+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	CALL __long_delay_G104
	LDI  R26,LOW(48)
	JMP  __lcd_init_write_G104

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2E:
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
