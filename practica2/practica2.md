#Practica 2:

## link de los ficheros: https://github.com/NAEL1/EC/tree/master/practica2

## 5.1 Sumar N enteros sin signo de 32bits en una plataforma de 32bits sin perder precisión (N≈32):

### version a:

``` c
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
	.ascii "suma = %llu =  %llx hex \n \0"  # formato del texto que se va  a imprimir por printf " %llu"= unigned long long 
	
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

	ret

suma:
	push %esi      # preservar  %esi
	mov $0, %eax   # poner a cero los primeros 32 bits del acumulador
	mov $0, %esi   # poner a cero el indice
	mov $0, %edx   # poner a cero los ultimos 32 bits del acumulador
bucle:
	add (%ebx,%esi,4), %eax # acumular el i-esimo elemento
	jnc extra				# si no hay acarreo saltar a la etiqueta extra
	inc %edx				# si hay acareo incrementar en uno edx
extra:	
	inc       %esi   		#  incrementar el indice
	cmp  %esi,%ecx		    # comparar el indice con el tamaño del vector
	jne bucle				# ni aun no hemos llegado al final del vector lastar a la etiqueta bucle

	pop %esi  				# restaurar el valor del registro
	ret 					#devolver el control al programa


```


### version b:

```c
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
	mov $0, %eax   # poner a cero los primeros 32 bits del acumulador
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

```


## 5.2 Sumar N enteros con signo de 32bits en una plataforma de 32bits:

### version a:

``` c
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
	mov $0, %eax	  # ponemos a cero el registro auxiliar
	#mov $0, %edx
	mov $0, %esi      # poner a cero los primeros 32 bits del acumulador
	mov $0, %edi	  # poner a cero los ultimos 32 bits del acumulador
	mov $0 , %ebp     # poner a cero el indice
bucle:
	mov (%ebx,%ebp,4), %eax # ponemos el elemento i-esimo en el registro auxiliar
	cmp  $0 , %eax 			# comprobamos  el signo del registro auxiliar
	js l1					# si es negativo saltar a la etiquete l1
	add  %eax ,%esi 		# sino añadimos el valor el registro auxiliar al acumulador
	adc $0 , %edi			# como el registro auxiliar es positivos añadimos 32 ceros a la parte alta del acumulador
l2:
	inc %ebp				# actualizamos el indice
	cmp  %ebp,%ecx			# comprobamos si hemos llegado al final del array
	jne bucle				# si aun quedan elementos en el array saltamos a la etiqueta bucle
	pop %ebp				# sino  restauramos el valor %ebp
	ret 					# devolver el control al programa
l1:	
	add  %eax,%esi 			# añadimos el valor el registro auxiliar al acumulador	
	adc $-1 ,%edi			# como el registro auxiliar es negativo añadimos 32 unos a la parte alta del acumulador
	jmp l2					# salto incondicional a la etiqueta l2


```

### version b:

```c
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
	mov $0 , %ebp     # poner a cero el indice
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


```