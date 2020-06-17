;**************************************************************
; ALGORITMO DE DIJKSTRA DISTANCIA MINIMA A TODOS LOS VERTICES *
; Thiago Kovnat, Primer Cuatrimestre 2020 Orga 9557           *
;**************************************************************




global main
extern printf


section .data

	cantVerticesSPT dq 0
	SPT             dw 1,0,0

	matrizAdy       dw 0,1,0   ;uso una Matriz Adyacencia ejemplo
					dw 1,0,1
					dw 0,1,0

	distancia       dw 0,60000,60000



section .bss


section .text


main:






getElemento:										; Dada una fila y una columna, devuelve el elemento almacenado en la matriz en dicha fila y columna.
		

	mov rax, [fila]
	dec rax
	imul rax, qword[longFila]

	mov rbx, rax

	mov rax, [columna]
	dec rax
	imul rax, 2

	add rbx, rax

	mov ax, [matriz + rbx]
	cwde
	cdqe

	mov qword[elemento], rax
	ret


