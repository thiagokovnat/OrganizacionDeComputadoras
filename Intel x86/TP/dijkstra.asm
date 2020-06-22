;**************************************************************
; ALGORITMO DE DIJKSTRA CAMINO MINIMO ENTRE DOS VERTICES      *
; Thiago Kovnat, Primer Cuatrimestre 2020 Orga 9557           *
;**************************************************************

global main
extern printf


section .data


    ; RELACIONADAS A LA MATRIZ 

	SPT             dq 1,0,0,0,0,0,0,0,0,0

	matrizAdy       dq 0,5,3,4,0,0,0,0,0,0
					dq 5,0,2,0,0,0,1,0,0,0
					dq 3,2,0,3,0,1,1,0,0,0
					dq 4,0,3,0,0,0,0,0,0,0
					dq 0,0,0,0,0,6,0,7,1,0
					dq 0,0,1,0,6,0,3,2,0,0
					dq 0,1,1,0,0,3,0,7,0,0
					dq 0,0,0,0,7,2,7,0,2,4
					dq 0,0,0,0,1,0,0,2,0,0
					dq 0,0,0,0,0,0,0,4,0,0

	matrizCaminoMinimo dq 0,1
					   dq 60001,2
					   dq 60000,3
					   dq 60000,3
					   dq 60000,4
					   dq 60000,4
					   dq 60000,7
					   dq 60000,8
					   dq 60000,9
					   dq 60000,10

	; RELACIONADAS A LOS VERTICES

	cantVerticesSPT dq 1
	cantVertices    dq 10

	nodoMinimo      dq 0
	nodoInicial     dq 1
	nodoFin         dq 10



	; FILAS / COLUMNAS

	fila dq 0
	columna dq 0
	longFila dq 80
	elemento dq 0

	elementoCaminoMinimo dq 0


	; AUXILIARES


	auxiliar dq 0
	msjPrintf dw "Distancia: %i",13,0
	msjDebug dw " FFFFFFFFFFFFF", 0
	minimoActual dq 0

	printfCamino dw "%i <- ", 0

	printIn dw "IN",10,0

	printMsjCamino dw "Camino minimo desde %hi a %hi:",10,0

section .bss

	estaPresente resb 1


section .text


main:


	call DIJKSTRA



	ret

DIJKSTRA:
	
	
	call inicializarMatriz							; Inicializo la matriz que uso para el algoritmo


loopDIJKSTRA:


	call getNodoMinimo								; Busco el nodo con menor peso que no haya visistado

	mov rax, qword[nodoFin]
	cmp rax, qword[nodoMinimo]
	je finDIJKSTRA									; Si el nodo minimo es mi nodo fin, llegue al fin del algoritmo

	call actualizarMatriz							; Si no es mi nodo fin, actualizo la matriz tomando el minimo entre dist(u) y dist(v) + dist(u-v)
	
	jmp loopDIJKSTRA

finDIJKSTRA:


	call imprimirCamino								; Imprimo el camino fin 
	;call imprimirMatriz
	ret



imprimirMatriz:

	mov qword[columna], 1
	mov qword[fila], 1



loopImprimir: 

	
	cmp qword[fila], 10
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

	cmp qword[fila], 10
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

	mov byte[estaPresente], "N"

	mov qword[fila], 1

loopComprobarPresente:

	mov rax, qword[fila]
	dec rax
	imul rax, 8

	cmp rbx, qword[SPT + rax]
	je nodoPresente

	mov rax, qword[cantVertices]
	inc qword[fila]
	cmp qword[fila], rax
	jle loopComprobarPresente


finComprobar:

	ret


nodoPresente:


	mov byte[estaPresente], "S"
	jmp finComprobar


inicializarMatriz:							; Inicializa la matriz de camino minimo utilizada.


	mov rax, qword[nodoInicial]
	mov qword[fila], rax
	mov qword[columna], 1

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
	mov rbx, qword[nodoInicial]
	mov qword[matrizCaminoMinimo + rax], rbx


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
		
	mov rax, qword[fila]
	dec rax
	imul rax, qword[longFila]

	mov rbx, rax

	mov rax, qword[columna]
	dec rax
	imul rax, 8

	add rbx, rax

	mov rax, [matrizAdy + rbx]
	

	mov qword[elemento], rax
	ret


actualizarMatriz:

	mov rax, qword[nodoMinimo]

	mov qword[fila], rax
	mov qword[columna], 1

loopActualizar:
	
	call getElemento

	cmp qword[elemento], 0
	je incrementColumnaActualizar

	mov rax, qword[columna]
	cmp rax, qword[nodoMinimo]
	je incrementColumnaActualizar

	call getElementoCaminoMinimo

	mov rax, qword[elementoCaminoMinimo]
	mov qword[auxiliar], rax

	push qword[columna]
	mov rax, qword[fila]

	mov qword[columna], rax

	call getElementoCaminoMinimo

	pop qword[columna]

	mov rax, qword[elementoCaminoMinimo]
	add rax, qword[elemento]                            ; dist[v] + edge(u-v) 
	mov qword[elemento], rax
	push rax

	mov rax, 0

	pop rax
	cmp rax, qword[auxiliar]                            ; if dist(u) > dist[v] + edge(u-v) then dist(u) = dist(v) + edge(u-v)
	jl placeElemento

incrementColumnaActualizar:

	inc qword[columna]

	mov rbx, qword[cantVertices]
	cmp qword[columna], rbx
	jg finActualizar

	jmp loopActualizar

finActualizar:

	inc qword[cantVerticesSPT]

	mov rax, qword[cantVerticesSPT]
	dec rax
	imul rax, 8

	mov rbx, rax

	mov rax, qword[nodoMinimo]

	mov qword[SPT + rbx], rax

	ret

placeElemento:

	mov rbx, qword[columna]
	dec rbx
	imul rbx, 16

	mov qword[matrizCaminoMinimo + rbx], rax

	add rbx, 8                                ; me desplazo a la columna "FROM"

	mov rax, qword[nodoMinimo]

	mov qword[matrizCaminoMinimo + rbx], rax

	jmp incrementColumnaActualizar

getElementoCaminoMinimo:

	
	mov rax, qword[columna]                     ; Por como esta hecha esta matriz, la columna de la matriz de adyacencia es la fila de la matriz de camino minimo
	dec rax
	imul rax, 16

	mov rbx, rax

	mov rax, 1                                  ; Siempre quiero el elemento de mi primera columna
	dec rax
	imul rax, 8

	add rbx, rax

	mov rax, qword[matrizCaminoMinimo + rbx]

	mov qword[elementoCaminoMinimo], rax

	ret

printDebug:

 	mov qword[columna], 1

loopDebug:

 	mov rax, qword[columna]
 	dec	rax
 	imul rax, 8

 	mov rdi, msjPrintf
 	mov rsi, [SPT + rax]
 	sub rsp, 8
 	call printf
 	add rsp, 8

 	inc qword[columna]

 	cmp qword[columna], 3
 	jg finDebug

 	jmp loopDebug


 finDebug:

 	ret


imprimirCamino:
	
	mov rax, 0
	mov rdi, printMsjCamino
	mov rsi, qword[nodoInicial]
	mov rdx, qword[nodoFin]
	sub rsp, 8
	call printf
	add rsp, 8

loopCamino:

	mov rdi, printfCamino
	mov rsi, qword[nodoFin]
	sub rsp, 8
	call printf
	add rsp, 8

	mov rax, qword[nodoFin]
	dec rax
	imul rax, 16

	mov rbx, rax

	mov rax, 1
	imul rax, 8

	add rbx, rax

	mov rax, qword[matrizCaminoMinimo + rbx]

	cmp rax, qword[nodoInicial]
	je finMostrarCamino

	mov qword[nodoFin], rax
	jmp loopCamino

finMostrarCamino:

	mov rdi, printfCamino
	mov rsi, qword[nodoInicial]
	sub rsp, 8
	call printf
	add rsp, 8

	mov rdi, printIn
	sub rsp, 8
	call printf
	add rsp, 8

	ret
