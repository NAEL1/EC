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


## 5.3 Media de N enteros ﬁ signo de 32bits, en plataforma de 32bits:

### version a:

``` c
.section .data
#lista:		.int 1,2,10,  1,2,0b10,  1,2,0x10

.macro linea
	#.int 1,1,1,1
	#.int 2,2,2,2
	.int 1,2,3,4
	#.int -1,-1,-1,-1
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
	.ascii "suma = %lld =  %llx hex \n media= %ld\n \0"  # añadimos al formato  la media 
	
.section .text
#_start:	.global _start
main:	.global main
	mov    $lista, %ebx
	mov longlista, %ecx
	call suma
	mov %esi, resultado
	mov %edi ,resultado+4
	mov %eax , media  	# ponemos en media el cociente de la division
	
	push media			# ponemos la media en la pila 
	pushl resultado+4
	pushl resultado 
	pushl resultado+4
	pushl resultado 
	push $formato
	call printf
	add $24 ,%esp		#restauramos el valor del puntero de pila

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
	cmp  $0 , %eax 			# comprobamos  el signo del registro auxiliar
	js l1					# si es negativo saltar a la etiquete l1
	add  %eax ,%esi 		# sino añadimos el valor el registro auxiliar al acumulador
	adc $0 , %edi			# como el registro auxiliar es positivos añadimos 32 ceros a la parte alta del acumulador
l2:
	inc %ebp				# actualizamos el indice
	cmp  %ebp,%ecx			# comprobamos si hemos llegado al final del array
	jne bucle				# si aun quedan elementos en el array saltamos a la etiqueta bucle
	mov %esi ,%eax			# para preparar la division guardamos en %eax y %edx el valor final de acumultador
	mov %edi ,%edx
	idiv %ecx				# division con signo  EDX:EAX/ N   ECX contiene Numero de elementos, %eax contiene el cociente y %edx el resto
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

```


## preguntas del guión de la práctica de la sección 5.0 (apéndice 3):

###Sesión de depuración saludo.s

####1 ¿Qué contiene EDX tras ejecutar mov longsaludo, %edx? ¿Para qué necesitamos esa instrucción, o ese valor? Responder no sólo el valor concreto (en decimal y hex) sino también el significado del mismo (¿de dónde sale?) Comprobar que se corresponden los valores hexadecimal y decimal mostrados en la ventana Status»>Registers

####2 ¿Qué contiene ECX tras ejecutar mov Ssaludo, %ecx? Indicar el valor en hexadecimal, y el significado del mismo. Realizar un dibujo a escala de la memoria del programa, indicando dónde empieza el programa (_start, .text), dónde empieza saludo (.data), y dónde está el tope de pila (%esp)

####3 ¿Qué sucede si se elimina el símbolo de dato ¡Inmediato (S) de la instrucciór anterior? (moiv saludo, %ecx) Realizar la modificación, indicar el contenido de ECX en hexadecimal, explicar por qué no es lo mismo en ambos casos. Concretar de dónde viene el nuevo valor (obtenido sin usar S)

####4 ¿Cuántas posiciones de memoria ocupa la variable longsaludo? ¿Y la variable saludo? ¿Cuántos bytes ocupa por tanto la sección de datos? Comprobar con un volcado Data»>Memory TÏIGYOIT que la zona de datos antes de hacer Run.

####5 Añadir dos volcados Data»>Memory dela variable longsaludo, uno como entero hexadecilmal, y otro como 4 bytes hex. Teniendo en cuenta lo mostrado en esos volcados... ¿Qué direcciones de memoria ocupa longsaludo? ¿Cuál byte está en la primera posición, el más o el menos significativo? ¿Los procesadores de la línea x86 usan el criterio del extremo mayor (bigendian) o menor (little»endian)? Razonar la respuesta

####6 ¿Cuántas posiciones de memoria ocupa la instrucción mov S1, %ebx? ¿Cómo se ha obtenido esa información? Indicar las posiciones concretas en hexadecimal.

####7 ¿Qué sucede si se elimina del programa la primera instrucción int 0x80? ¿Y si se elimina la segunda? Razonar las respuestas

####8 ¿Cuál es el número de la llamada al sistema READ (en kernel Linux 32bits)? ¿De dónde se ha obtenido esa información?


###Sesión de depuración suma.s

####1 ¿Cuál es el contenido de EAXjusto antes de ejecutar la instrucción RET, para esos componentes de lista concretos? Razonar la respuesta, incluyendo cuánto valen 0b10, 0x10, y (.-Lista)/4

####2 ¿Qué valor en hexadecimal se obtiene en resultado si se usa la lista de 3 elementos: .int Oxffffffff, Oxffffffff, Oxffffffff? ¿Por qué es diferente del que se obtiene haciendo la suma a mano? NOTA: Indicar qué valores va tomando EAX en cada iteración del bucle, como los muestra la ventana Status»>Registers, en hexadecimal y decimal (con signo). Fijarse también en si se van activando los flags CF y OF o no tras cada suma. Indicar también qué valor muestra resultado si se vuelca con Data»>Memory como decimal (con signo) o unsigned (sin signo).

####3 ¿Qué dirección se le ha asignado ala etiqueta suma? ¿Y a bucle? ¿Cómo se ha obtenido esa información?

####4 ¿Para qué usa el procesador los registros EIP y ESP?

####5 ¿Cuál es el valor de ESP antes de ejecutar CALL, y cuál antes de ejecutar RET? ¿En cuánto se diferencian ambos valores? ¿Por qué? ¿Cuál de los dos valores de ESP apunta a algún dato de interés para nosotros? ¿Cuál es ese dato?

####6 ¿Qué registros modifica la instrucción CALL? Explicar por qué necesita CALL modificar esos registros

####7 ¿Qué registros modifica la instrucción RET? Explicar por qué necesita RET modificar esos registros

####8 Indicar qué valores se introducen en la pila durante la ejecución del programa, y en qué direcciones de memoria queda cada uno. Realizar un dibujo de la pila con dicha información. NOTA: en los volcados Data-> Memory se puede usar Sesp para referirse a donde apunta el registro ESP

####9 ¿Cuántas posiciones de memoria ocupa la instrucción mov $0, %edx? ¿Y la instrucción ilnc %edx? ¿Cuáles son sus respectivos códigos máquina? Indicar cómo se han obtenido. NOTA: en los volcados Data»> Memory se puede usar una dirección hexadecimal Ox... para indicar la dirección del volcado. Recordar la ventana View»>Machine Code Window. Recordar también la herramienta objdump.

####10 ¿Qué ocurriría si se eliminara la instrucción RET? Razonar la respuesta. Comprobarlo usando ddd