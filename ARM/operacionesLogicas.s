    .equ SWI_Open_File, 0x66
	.equ SWI_Read_Int, 0x6C
	.equ SWI_Print_Int, 0x6B
	.equ SWI_Close_File, 0x68
	.equ SWI_Print_Str, 0x69
    .equ SWI_Exit, 0x11


    .data


nombreArchivo:

	.asciz "entero.txt"

eol:
    .asciz "\n"


	.text

	.global _start


_start:

	ldr r0, =nombreArchivo
	mov r1, #0

	swi SWI_Open_File


	@ R1 = FileHandle
	mov r1, r0

	swi SWI_Read_Int

	@ R2 = Primer entero

	mov r2, r0
	mov r0, r1

	swi SWI_Read_Int

	@ R3 = Segundo entero

	mov r3, r0
	mov r4, r2

	bl imprimirEntero

	mov r4, r3

	bl imprimirEntero

	swi SWI_Close_File
	swi SWI_Exit


imprimirEntero:

	stmfd sp!, {r0, lr}


	mov r0, #1
	mov r1, r4

	swi SWI_Print_Int

	ldr r1, =eol
	swi SWI_Print_Str

	mov r5, #-1

	eor r1, r4, r5

	mov r0, #1
	swi SWI_Print_Int

	ldr r1, =eol
	swi SWI_Print_Str

	

	ldmfd sp!, {r0, pc}