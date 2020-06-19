;**************************************************************
; ALGORITMO DE DIJKSTRA DISTANCIA MINIMA A TODOS LOS VERTICES *
; Thiago Kovnat, Primer Cuatrimestre 2020 Orga 9557           *
;**************************************************************

global main
extern printf


section .data


    ; RELACIONADAS A LA MATRIZ 

	SPT             dq 1,0,2

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

	nodoInicial     dq 1

	nodoFin         dq 3



	; FILAS / COLUMNAS

	fila dq 0
	columna dq 0
	longFila dq 24

	elemento dq 0


	; AUXILIARES


	auxiliar dq 0
	msjPrintf dw "Distancia: %i",10,0

	msjDebug dw "FFFFFFFFFFFFF", 0

	minimoActual dq 0

section .bss

	estaPresente resb 1


section .text


main:


	call DIJKSTRA



	ret

DIJKSTRA:

	
	call inicializarMatriz

	call getNodoMinimo

	mov rax, 0
	mov rdi, msjPrintf
	mov rsi, qword[nodoMinimo]
	sub rsp, 8
	call printf
	add rsp, 8


	;call imprimirMatriz

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


getNodoMinimo:														; Deja en la variable nodoMinimo la fila donde se encuentra el nodo de menor valor actualmente.

	mov qword[fila], 1
	mov qword[columna], 1
	mov qword[minimoActual], 60000

loopNodoMinimo:

	cmp qword[fila], 3
	jg finNodoMinimo

	mov rax, qword[nodoInicial]										; No comparo el nodo del cual parti, ya que su distancia siempre es 0 y quedaria como el nodo minimo.
	cmp qword[fila], rax
	je incrementFilaNodoMin

	mov rax, qword[fila]
	dec rax
	imul rax, 16

	mov rbx, rax

	mov rax, qword[columna]
	dec rax
	imul rax, 8

	add rbx, rax

	mov rax, qword[matrizCaminoMinimo + rbx]

	cmp rax, qword[minimoActual]
	jl nuevoMinimo

incrementFilaNodoMin:

	inc qword[fila]
	jmp loopNodoMinimo


finNodoMinimo:

	ret


nuevoMinimo:

	push qword[fila]
	push rax

	call comprobarSiNodoYaEstaPresente

	pop rax
	pop qword[fila]

	cmp byte[estaPresente], "S"
	je incrementFilaNodoMin

	mov qword[minimoActual], rax

	mov rax, qword[fila]
	mov qword[nodoMinimo], rax
	jmp incrementFilaNodoMin



comprobarSiNodoYaEstaPresente:								; Deja en una variable estaPresente si el nodo ya se encuentra en el SPT

	mov rbx, qword[fila]
	mov qword[fila], 1

loopComprobarPresente:

	mov rax, qword[fila]
	dec rax
	imul rax, 8

	cmp rbx, qword[SPT + rax]
	je nodoPresente

	inc qword[fila]
	cmp qword[fila], 3
	jle loopComprobarPresente

	mov byte[estaPresente], "N"

finComprobar:

	ret


nodoPresente:
	
	mov byte[estaPresente], "S"
	jmp finComprobar





inicializarMatriz:							; Inicializa la matriz de camino minimo utilizada.

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


