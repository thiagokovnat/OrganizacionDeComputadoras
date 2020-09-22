

	.equ SWI_Exit, 0x11


	.data

numero1:

	.word 3

numero2:

	.word 4


	.text

	.global _start


_start:

	ldr r0, =numero1

	ldr r0, [r0]

	ldr r1, =numero2

	ldr r1, [r1]

	add r2, r0, r1

	sub r3, r0, r1

	mul r4, r0, r1

	and r5, r0, r1

	orr r6, r0, r1

	eor r7, r0, r1

	mov r8, r0, LSL r1

	mov r9, r0, LSR r1

	swi SWI_Exit

	.end

