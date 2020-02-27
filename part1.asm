;
; ECE 3613 Lab 5 Activity 3 Part 1.asm
;
; Created: 2/26/2020 10:07:07 PM
; Author : Leomar Duran <https://github.com/lduran2>
; Board  : ATmega324PB Xplained Pro - 2505
; For    : ECE 3612, Spring 2020
;


	;set up PORTA for output
	ldi	r16,0xFF	;for data direction register
	out	DDRA,r16	;all output
	;set up PORTB for output
	ldi	r16,0xFF	;for pull up switches
	out PORTB,r16	;all closed
	ldi	r16,0x00	;for data direction register
	out	DDRB,r16	;all input

;listens to PORTB switches and performs accordingly
LISTENER:
	ldi	r16,0	;default the bit pattern to all zeros
	out	PORTA,r16	;to PORTA
	;loop through the bits in PINB, from right to left
	in	r1,PINB	;copy of PINB (using in for input)
	com	r1	;switches are set open on this board
	ldi	r16,8	;counter
	mov	r0,r16	;copy the maximum
SW_BIT_LOOP:
	ror	r1	;rotate rightmost bit to carry flag
	brcs	SET_BIT_PATTERN	;if the bit read is 1, go SET_BIT_PATTERN
	dec	r16	;decrement counter
	brne	SW_BIT_LOOP	;repeat if there are more bits to check
SW_BIT_LOOP_DONE:
	rjmp	LISTENER	;continue to listen

END:	rjmp	END	;loop infinitely

SET_BIT_PATTERN:
	sub	r0,r16	;this value is the same as the switch that was pressed
	out	PORTA,r0	;send to PORTA
	rjmp	SW_BIT_LOOP_DONE	;exit the loop
