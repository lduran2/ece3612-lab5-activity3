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
	out	PORTB,r16	;all closed
	ldi	r16,0x00	;for data direction register
	out	DDRB,r16	;all input

;listens to PORTB switches and performs accordingly
LISTENER:
	;loop through the bits in PINB, from right to left
	in	r0,PINB	;copy of PINB (using in for input)
	com	r0	;switches are set open on this board
		;we use COM because when all switches besides carry are
		;closed, r0 will be zero
	ldi	r16,8	;counter
	mov	r17,r16	;copy the maximum
SW_BIT_LOOP:
	lsr	r0	;logical shift the rightmost bit to carry flag
		;logical shift saves the need to clear the carry flag
		;since the loop stops if more than one bit is set
	brcs	SET_BIT_PATTERN	;if the bit read is 1, go SET_BIT_PATTERN
	dec	r16	;decrement counter
	brne	SW_BIT_LOOP	;repeat if there are more bits to check
SET_BIT_PATTERN_ELSE:
	ldi	r17,0	;default the bit pattern to all zeros
SW_BIT_LOOP_DONE:
	out	PORTA,r17	;output r17 to PORTA
	rjmp	LISTENER	;continue to listen

END:	rjmp	END	;loop infinitely

SET_BIT_PATTERN:
	brne	SET_BIT_PATTERN_ELSE	;stop if any of the other
			;switches are open
	sub	r17,r16	;this value is the same as the switch that was pressed
	out	PORTA,r0	;send to PORTA
	rjmp	SW_BIT_LOOP_DONE	;exit the loop
