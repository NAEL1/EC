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
media: .int -1

formato:
	.ascii "suma = %lld =  %llx hex \n media= %ld \n\0"    # añadimos al formato  la media 
	
.section .text
#_start:	.global _start
main:	.global main
	mov    $lista, %ebx
	mov longlista, %ecx
	call suma
	mov %esi, resultado
	mov %edi ,resultado+4
	mov %eax , media		# ponemos en media el cociente de la division
	
	push media				# ponemos la media en la pila 
	pushl resultado+4
	pushl resultado 
	pushl resultado+4
	pushl resultado 
	push $formato
	call printf
	add $24 ,%esp			#restauramos el valor del puntero de pila

	ret

suma:
	push %ebp    	  # preservar  %ebp
	mov $0, %eax	  # ponemos a cero el registro auxiliar (parte baja)
	mov $0, %edx	  # ponemos a cero el registro auxiliar (parte alta)
	mov $0, %esi      # poner a cero los primeros 32 bits del acumulador
	mov $0, %edi	  # poner a cero los ultimos 32 bits del acumulador
	mov $0, %ebp      # poner a cero el indice
bucle:
	mov (%ebx,%ebp,4), %eax # ponemos el elemento i-esimo en el registro auxiliar
	cltd					# extendemos el bit de signa a la parte alta del registro auxiliar( poner los 32 bits de %edx cn el valor del bit de signo de %eax)
	add  %eax , %esi 		# añadimos el valor el registro auxiliar(parte baja) al acumulador(parte baja)
	adc  %edx , %edi  		# añadimos el valor el registro auxiliar(parte alta) al acumulador(parte alta)
	inc       %ebp  		# actualizamos el indice
	cmp  %ebp,%ecx  		# comprobamos si hemos llegado al final del array
	jne bucle 				# si aun quedan elementos en el array saltamos a la etiqueta bucle
	mov %esi ,%eax			# para preparar la division guardamos en %eax y %edx el valor final de acumultador
	mov %edi ,%edx
	idiv %ecx				# division con signo  EDX:EAX/ N   ECX contiene Numero de elementos, %eax contiene el cociente y %edx el resto

	pop %ebp				# sino  restauramos el valor %ebp
	ret 					# devolver el control al programa