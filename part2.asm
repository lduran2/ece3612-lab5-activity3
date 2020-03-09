;
; ECE 3613 Lab 5 Activity 3 Part 2.asm
;
; Created: 2/29/2020 12:19:06 PM
; Author : Leomar Duran <https://github.com/lduran2>
; Board  : ATmega324PB Xplained Pro - 2505
; For    : ECE 3612, Spring 2020
; 


	;set up PORTA for output
	ldi	r16,0xFF	;for data direction register (PORTA)
	out	DDRA,r16	;set to all output
	;set up PORTB for input
	ldi	r16,0xFF	;for pull up switches
	out	PORTB,r16	;set to all closed
	ldi	r16,0x00	;for data direction register (PORTB)
	out	DDRB,r16	;set to all input

	;set up switch constants
	;note that switches are set on open on this board
	ldi	r16,0b11111110	;switch SW0 for pattern 1
	ldi	r17,0b11111101	;switch SW1 for pattern 2
	;set up LED constants
	ldi	r19,0b11111111	;all LEDs lit

	in	r1,PINB	;initialize the next switch bits

;listen to the PORTB switches and choose the pattern accordingly
;SW0 = pattern from PA0 to PA7 (down)
;SW1 = pattern from PA7 to PA0 (up)
LISTENER:
	ldi	r18,0	;set up the bit pattern
	mov	r0,r1	;update the current switch bits
;display the bit pattern
BIT_PATTERN_LOOP:
	cp	r18,r19	;check if all LEDs are lit
	breq	SKIP_SW1	;if so, clear the bit pattern and restart
	cp	r0,r16	;check for switch SW0
	brne	SKIP_SW0	;if not, skip the bit pattern for SW0
	sec	;set the carry flag to push onto the bit pattern
	rol	r18	;push the carry flag up the bits
	rjmp	SKIP_DEFAULT
SKIP_SW0:
	cp	r0,r17	;check for switch SW1
	brne	SKIP_SW1	;if not, skip the bit pattern for SW1
	sec	;set the carry flag to push onto the bit pattern
	ror	r18	;psuh the carry flag down the bits
	rjmp	SKIP_DEFAULT
SKIP_SW1:
	ldi	r18,0	;clear the bit pattern
SKIP_DEFAULT:
	out	PORTA,r18	;output the bit pattern to the LEDs
	call	delay	;delay after displaying
	in	r1,PINB	;the next switch bits
	cp	r0,r1	;check switch bits now
	breq	BIT_PATTERN_LOOP	;if same, update bit pattern
	rjmp	LISTENER	;reset the bit pattern and listen to
		;new switch

END:	rjmp END	;loop indefinitely

DELAY: LDI r20,106	;212 for 1 second, 106 for 0.5 second
	L1: LDI R21, 100
	L2: LDI R22, 150
	L3: NOP
		NOP
		DEC R22
		BRNE L3
		DEC R21
		BRNE L2
		DEC R20
		BRNE L1

	RET
