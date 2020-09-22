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
    .align

fileHandle:

	.word 0

	.text

	.global _start


_start:


	ldr r0, =nombreArchivo
	mov r1, #0

	swi SWI_Open_File
	bcs inFileError

	ldr r1, =fileHandle
	str r0, [r1]

	ldr r0, =fileHandle
	ldr r0, [r0]

	swi SWI_Read_Int
	mov r3, r0

	ldr r0, =fileHandle
	ldr r0, [r0]

	swi SWI_Read_Int
	mov r4, r0

	cmp r4, r3

	movlt r5, r3
	movlt r3, r4
	movlt r4, r5

	mov r0, #1
	mov r1, r3

	swi SWI_Print_Int

	ldr r1, =eol
	swi SWI_Print_Str

	mov r0, #1
	mov r1, r4
	swi SWI_Print_Int

	ldr r0, =fileHandle
	ldr r0, [r0]
	swi SWI_Close_File

inFileError:

	swi SWI_Exit
	.end

