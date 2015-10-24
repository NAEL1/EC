.section .data
#lista:		.int 1,2,10,  1,2,0b10,  1,2,0x10
longlista:	.int (.-lista)/4
resultado:	.quad -1
.macro linea
	.int 1,1,1,1
	#.int 2,2,2,2
	#.int 1,2,3,4
	#.int -1,-1,-1,-1
	#.int  0xffffffff ,0xffffffff,0xffffffff,0xffffffff
	#.int 0x08000000 ,0x08000000 ,0x08000000,0x08000000
	#.int 0x10000000 ,0x10000000 ,0x10000000,0x10000000
.endm
lista: .irpc i, 12345678
		linea
		.endr
formato:
	.ascii "suma = %llu =  %llx hex \n \0" # formato del texto que se va  a imprimir por printf " %llu"=  long long unigned
	
.section .text
#_start:	.global _start
main:	.global main
	mov    $lista, %ebx
	mov longlista, %ecx
	call suma
	mov %eax, resultado
	mov %edx ,resultado+4

	pushl resultado+4 # parte alta del resultado 
	pushl resultado   # parte baja del resultado
	pushl resultado+4 # repetimos una segunda vez ya que vamos a imprimir el resultado 2 veces
	pushl resultado 
	push $formato	  # ponemos el formato en la pila
	call printf		  # llmamos a printf
	add $20 ,%esp	  # volvemos a colocar el puntero de pila a su lugar original

	mov $1, %eax
	mov $0, %ebx
	int $0x80

suma:
	push %esi      # preservar  %esi
	mov $0, %eax   # poner a cero los primeros 32 bits del acumilador
	mov $0, %esi   # poner a cero el indice
	mov $0, %edx   # poner a cero los ultimos 32 bits del acumulador

bucle:
	add (%ebx,%esi,4), %eax # acumular el i-esimo elemento
	adc $0,%edx				# añadimos el valor del flag del acarreo a %edx : si no hay 0 si hay accareo 1
	inc       %esi 			#  incrementar el indice
	cmp  %esi,%ecx			# comparar el indice con el tamaño del vector
	jne bucle				# ni aun no hemos llegado al final del vector lastar a la etiqueta bucle


	pop %esi  				# restaurar el valor del registro
	ret 					#devolver el control al programa