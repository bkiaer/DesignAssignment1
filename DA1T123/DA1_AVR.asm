;
; Asst01.asm
;
; Created: 2/12/2018 10:28:01 AM
; Author : Brian Kiaer
;


; Replace with your application code
	
	LDI R24, 0x2C ;low value of 300
	LDI R25, 0x01 ; stores value  300
	LDI R20, 0x02 ;store the high value of 0x0222
	LDI XL, LOW(0x0222) ;low value of STARTADDR
	LDI XH, HIGH(0x0222) ;high value of STARTADDR
	LDI R22, 0x22 ;load lower value of STARTADDR
	LDI R23, 0x02 ; load high value of STARTADDR
	ADD R22, R23 ;add 0x02 and 0x22 = 0x24


L1: ST X+, R22		;Store value of R22, and increment addr of X ;store value into memory location and increment
	ADC R20, R0		;Add carry to high value
	ADD R22, R20;	;add the high value of x
	BRNE NEXT		;if 0 jump to next to change 2C to FF
	INC R24			;inc counter because it dec twice
	
NEXT: 	
	DEC R24			;decrement lower value ox 0x012C
	BRNE L1			 ;if 0x2C is not 0 branch to loop 1
	JMP COUNT		;if 0 branch to check
	 
COUNT:
	ADD R25, R0		;adds 0 to the counter
	BREQ DIVISIBLE	;if counter is 0 then jump to task 2
	DEC R25			;if not dec the high value of 0x012C
	LDI R24, 0xFF	;reset counter
	JMP L1			;go back to loop

DIVISIBLE:
	LDI R24, 0x2D	;counter for 300
	LDI R25, 0x01	;high value for counter at 300
	LDI XL, LOW(0x0222)		;low value of STARTADDR
	LDI XH, HIGH(0x0222)	;High value of STARTADR
	LDI YL, LOW(0x0400)		;store lower value of address in Y register
	LDI YH, HIGH(0x0400)	;store higher value of address in Y register
	LDI ZL, LOW(0x0600)		;low value of address 0x0600 of Z reg
	LDI ZH, HIGH(0x0600)	;high value of address 0x600 of Z reg

RELOAD:	LD R20, X+	;load value from STARTADDR
	MOV R19, R20	;temporarily store value in r19 to save in SRAM later
	LDI R21, 5		;divisor
	CLR R22			;quotient

L2: INC R22			;quotient
	SUB R20, R21	;Subtract value by divisor
	BRCC L2			;branch if carry cleared back to L2

	DEC R22			;quotient
	ADD R20, R21	;remainder
	BREQ YLOC		;if remainder is 0 then store into Y mem location.
	JMP ZLOC		;else store into z location

YLOC:
	ST Y+, R19		;store quotient in Y memory location
	INC R10			;counter for Y
	JMP COUNTER		;jump to dec counter
ZLOC:
	ST Z+, R19		;store quotient in Z memory location
	INC R11			;counter for Z

COUNTER:
	DEC R24			;dec counter
	BREQ CHECK2		;if counter is 0 double check
	JMP RELOAD		;else reload value to get divided

CHECK2: 
	ADD R25, R0		;double checks if high value is 0 in counter
	BREQ TASK3		;if it is 0 jump to task 3
	DEC R25			;else dec counter 
	JMP RELOAD

TASK3:
	LDI YL, LOW(0x0400)  ;restart pointer for Y at 400
	LDI YH, HIGH(0x0400)
	LDI ZL, LOW(0x0600)  ;restart pointer for Z at 600
	LDI ZH, HIGH(0x0600)
	LDI R21, 0x0		;reset values and set to 0
	LDI R20, 0x0
	LDI R19, 0x0
	
LOOP:
	LD R8,  Y+		;use r8 as temp register to hold current Y value
	LD R9,  Z+		;use r9 as temp register to hold current Z value

YADD:
	ADD R10, R0		;r10 is the counter for Y numbers, if 0 check if Z counter is 0
	BREQ ZADD		;if 0 check z counter is 0 then finish
 	ADD R17, R8		;add value to r17 to hold permanent value
	CLR R21			;clear 
	ADC R16, R21	;add with carry for overflow	
	DEC R10			;decrement Y counter 		
	

ZADD:
	ADD R11, R0		;check if r11 (Z counter) to be 0
	BREQ CHECK3		;if 0 check if Y counter is 0 then finish
	ADD R19, R9		;add current value to main register r19
	ADC R18, R0		;add carry to high address
	DEC R11			;decrement z counter 
	JMP LOOP
			;return to loop 
CHECK3: 
	ADD R10, R0		;checks if both counters are 0
	BREQ DONE		;if 0 then finish
	JMP YADD		;else return to loop

DONE:
ADD R0, R0

	

	

