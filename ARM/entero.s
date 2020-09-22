    .equ SWI_Open_File, 0x66
	.equ SWI_Read_Int, 0x6C
	.equ SWI_Print_Int, 0x6B
	.equ SWI_Close_File, 0x68
    .equ SWI_Exit, 0x11


    .data


nombreArchivo:

	.asciz "entero.txt"

	.text

	.global _start


_start:


	ldr r0, =nombreArchivo

	mov r1, #0

	swi SWI_Open_File

	mov r5, r0


	mov r0, r5

	swi SWI_Read_Int

	mov r1, r0

	bl printEntero

	swi SWI_Exit



printEntero:

	stmfd sp!, {r0, lr}

	mov r0, #1

	swi SWI_Print_Int

	ldmfd sp!, {r0, pc}

