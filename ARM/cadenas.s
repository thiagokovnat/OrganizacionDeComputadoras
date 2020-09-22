

	.equ SWI_Print_String, 0x02
    .equ SWI_Exit, 0x11


    .data


mensaje1:

	.asciz "Hola"

mensaje2:

	.asciz "Chau"

newLine:

	.asciz "/n"


	.text

	.global _start

_start:

	ldr r3, =mensaje1
	bl mostrarCadena

	ldr r3, =mensaje2

	bl mostrarCadena

	swi SWI_Exit





mostrarCadena:

	stmfd sp!, {r0,lr}

	mov r0, r3

	swi SWI_Print_String

	ldr r0, =newLine

	swi SWI_Print_String

	ldmfd sp!, {r0, pc}



	.end