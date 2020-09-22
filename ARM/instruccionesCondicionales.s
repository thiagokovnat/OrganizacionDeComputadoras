
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

FileHandle:

	.word 0

	.text

	.global _start


_start:

	ldr r0, =nombreArchivo
	mov r1, #0

	swi SWI_Open_File

	bcs inFileError

	ldr r1, =FileHandle
	str r0, [r1]


readLoop:

	ldr r0, =FileHandle
	ldr r0, [r0]

	swi SWI_Read_Int
	bcs EofReached

	mov r2, r0

	bl PrintInt

	b readLoop

PrintInt:

	stmfd sp!, {r0, lr}

	cmp r2, #0

	mvnmi r2, r2
	addmi r2, #1


	mov r0, #1
	mov r1, r2

	swi SWI_Print_Int

	ldr r1, =eol
	swi SWI_Print_Str

	ldmfd sp!, {r0, pc}


EofReached:
inFileError:

	ldr r1, =FileHandle
	ldr r0, [r1]

	swi SWI_Close_File
	swi SWI_Exit
	.end

