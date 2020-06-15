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


