.section .data
#lista:		.int 1,2,10,  1,2,0b10,  1,2,0x10

.macro linea
	#.int 1,1,1,1
	#.int 2,2,2,2
	#.int 1,2,3,4
	.int -1,-1,-1,-1
	#.int  0xffffffff ,0xffffffff,0xffffffff,0xffffffff
	#.int 0x08000000 ,0x08000000 ,0x08000000,0x08000000
	#.int 0x10000000 ,0x10000000 ,0x10000000,0x10000000
.endm
lista: .irpc i, 12345678
		linea
		.endr 

longlista:	.int (.-lista)/4
resultado:	.quad -1

formato:
	.ascii "suma = %lld =  %llx hex \n \0"
	
.section .text
#_start:	.global _start
main:	.global main
	mov    $lista, %ebx
	mov longlista, %ecx
	call suma
	mov %esi, resultado
	mov %edi ,resultado+4

	pushl resultado+4 # parte alta del resultado 
	pushl resultado   # parte baja del resultado
	pushl resultado+4 # repetimos una segunda vez ya que vamos a imprimir el resultado 2 veces
	pushl resultado 
	push $formato	  # ponemos el formato en la pila
	call printf		  # llmamos a printf
	add $20 ,%esp	  # volvemos a colocar el puntero de pila a su lugar original
	ret

suma:
	push %ebp    	  # preservar  %ebp
	mov $0, %eax	  # ponemos a cero el registro auxiliar (parte baja)
	mov $0, %edx	  # ponemos a cero el registro auxiliar (parte alta)
	mov $0, %esi      # poner a cero los primeros 32 bits del acumulador
	mov $0, %edi	  # poner a cero los ultimos 32 bits del acumulador
	mov $0, %ebp     # poner a cero el indice
bucle:
	mov (%ebx,%ebp,4), %eax # ponemos el elemento i-esimo en el registro auxiliar
	cltd					# extendemos el bit de signa a la parte alta del registro auxiliar( poner los 32 bits de %edx cn el valor del bit de signo de %eax)
	add  %eax , %esi 		# añadimos el valor el registro auxiliar(parte baja) al acumulador(parte baja)
	adc  %edx , %edi  		# añadimos el valor el registro auxiliar(parte alta) al acumulador(parte alta)
	inc       %ebp  		# actualizamos el indice
	cmp  %ebp,%ecx  		# comprobamos si hemos llegado al final del array
	jne bucle 				# si aun quedan elementos en el array saltamos a la etiqueta bucle

	pop %ebp				# sino  restauramos el valor %ebp
	ret 					# devolver el control al programa
