;**************************************************************
; ALGORITMO DE DIJKSTRA DISTANCIA MINIMA A TODOS LOS VERTICES *
; Thiago Kovnat, Primer Cuatrimestre 2020 Orga 9557           *
;**************************************************************

global main
extern printf


section .data


    ; RELACIONADAS A LA MATRIZ 

	SPT             dw 1,0,0

	matrizAdy       dq 0,1,5   ;uso una Matriz Adyacencia ejemplo
					dq 1,0,1
					dq 5,1,0

	matrizCaminoMinimo dq 0,1
					   dq 60001,2
					   dq 60000,3

	; RELACIONADAS A LOS VERTICES

	cantVerticesSPT dq 0
	verticeInicial dq 1
	verticeFinal    dq 3
	cantVertices    dq 3

	nodoMinimo      dq 0



	; FILAS / COLUMNAS

	fila dq 0
	columna dq 0
	longFila dq 24

	elemento dq 0


	; AUXILIARES


	auxiliar dq 0
	msjPrintf dw "Distancia: %i",10,0

	msjDebug dw "FFFFFFFFFFFFF", 0

section .bss


section .text


main:


	call DIJKSTRA



	ret

DIJKSTRA:

	
	call inicializarMatriz

	;call getNodoMinimo

	call imprimirMatriz

	ret

imprimirMatriz:

	mov qword[columna], 1
	mov qword[fila], 1



loopImprimir: 

	
	cmp qword[fila], 3
	jg finImprimir

	mov rax, qword[fila]
	dec rax
	imul rax, 16

	mov rbx, rax

	mov rax, qword[columna]
	dec rax
	imul rax, 8

	add rbx, rax

	mov rdi, msjPrintf
	mov rsi, qword[matrizCaminoMinimo + rbx]
	mov rax, 0
	sub rsp, 8
	call printf
	add rsp, 8

	inc qword[fila]
	jmp loopImprimir


	

finImprimir:

	ret


getNodoMinimo:



inicializarMatriz:

	mov qword[fila], 1
	mov qword[columna], 2

loopInicializar:

	mov rax, qword[cantVertices]
	cmp qword[columna], rax
	jg finInicializar

	call getElemento
	
	mov rax, qword[columna]
	dec rax
	imul rax, 16


	cmp qword[elemento], 0
	je putInfinito

	mov rbx, qword[elemento]


	mov qword[matrizCaminoMinimo + rax], rbx
	add rax, 8
	mov qword[matrizCaminoMinimo + rax], 1


incrementColumna:

	inc qword[columna]
	jmp loopInicializar
	

putInfinito:


	mov qword[matrizCaminoMinimo + rax], 60000
	add rax, 8
	mov qword[matrizCaminoMinimo + rax], 1

	jmp incrementColumna

finInicializar:

	ret

getElemento:										; Dada una fila y una columna, devuelve el elemento almacenado en la matriz en dicha fila y columna.
		

	mov rax, [fila]
	dec rax
	imul rax, qword[longFila]

	mov rbx, rax

	mov rax, [columna]
	dec rax
	imul rax, 8

	add rbx, rax

	mov rax, [matrizAdy + rbx]
	

	mov qword[elemento], rax
	ret


