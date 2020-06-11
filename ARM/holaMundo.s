
        .equ SWI_Print_String, 0x02
        .equ SWI_Exit, 0x11


        .data
mensaje:

        .asciz "Hola Mundo"


        .text


        .global _start
_start:

        ldr r0, =mensaje
        swi SWI_Print_String
        swi SWI_Exit
        .end
