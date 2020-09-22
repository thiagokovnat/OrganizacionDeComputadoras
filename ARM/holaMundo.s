        .equ SWI_Print_Int, 0x6B
        .equ SWI_Print_String, 0x02
        .equ SWI_Exit, 0x11


        .data


numero:

        .word 100

mensaje:

        .asciz "Hola Mundo"
        

        .text


        .global _start
_start:

        ldr r0, =mensaje
        swi SWI_Print_String

        ldr r1, =numero
        ldr r1, [r1]
        mov r0, #1
        swi SWI_Print_Int
        swi SWI_Exit
        .end
