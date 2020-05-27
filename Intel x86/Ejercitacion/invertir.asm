global main
extern gets
extern puts
extern printf

section .data
	mensajeIngreso db "Ingrese un string",0

section .bss

	texto resb 100
	longTexto resq 1

section .text

main:
	
	sub rsp, 8
	mov rdi, mensajeIngreso
	call puts

	mov rdi, texto
	call gets




	add rsp, 8
	ret