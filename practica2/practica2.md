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

Tras ejecutar mov longsaludo, %edx  EDX contiene  0x1c ò 28 que es la longitud del String saludo , la necesitamos como argumento de la funcion write.
![pr2-1](https://github.com/NAEL1/EC/blob/master/practica2/pr2-1.png)

####2 ¿Qué contiene ECX tras ejecutar mov saludo, %ecx? Indicar el valor en hexadecimal, y el significado del mismo. Realizar un dibujo a escala de la memoria del programa, indicando dónde empieza el programa (_start, .text), dónde empieza saludo (.data), y dónde está el tope de pila (%esp)

Tras ejecutar mov saludo, %ecx ECX contiene la direccion de memoria donde empieza el String saludo, el valor hexadecimal de %ecx es 0x804a01c

```
	.
	.
	.
	.
|int $0x80		   |0x80483f5
|------------------|
|				   |0x80483f4
|movlongsaludo,%edx|0x80483f3
|				   |0x80483f2
|mov $saludo,%ecx  |0x80483f1
|------------------|
|				   |0x80483f0
|mov $1, %ebx	   |0x80483ef
|				   |0x80483ee
|mov $4, %eax      |0x80483ed  _start ó .text ó main   (suponemos que cada operacion ocupa 2byte aunque sabemos que varia
|----------------- |									dependiendo de la operacion )

	.
	.
	.
	.
|----------------- |
| 	0x00	       |0x80a03b
|   0x00	       |0x80a03a
|   0x00		   |0x80a039
|   0x1c 		   |0x80a038
|----------------- |
|   \n 			   |0x80a037
|   !  			   |0x80a036
|   d 			   |0x80a035
|   l  			   |0x80a034
|----------------- |
|   r  			   |0x80a033
|   o 		       |0x80a032
|   w  			   |0x80a031
|   \b 			   |0x80a030
|----------------- |
|   ,  			   |0x80a02f
|   o 			   |0x80a02e
|   l  			   |0x80a02d
|   l 			   |0x80a02c
|----------------- |
|   e  			   |0x80a02b
|   h  			   |0x80a02a
|   \n 			   |0x80a029
|   !  			   |0x80a028
|----------------- |
|   s 			   |0x80a027
|   o    		   |0x80a026
|   d  			   |0x80a025
|   o   		   |0x80a024
|----------------- |
|   t  			   |0x80a023
|   \b 			   |0x80a022
|   a  		 	   |0x80a021
|   \b 			   |0x80a020
|----------------- |
|   a  			   |0x80a01f
|   l 			   |0x80a01e
|   o  		 	   |0x80a01d
|   h  			   |0x80a01c
|----------------- |

```
####3 ¿Qué sucede si se elimina el símbolo de dato inmediato ($) de la instrucciór anterior? (moiv saludo, %ecx) Realizar la modificación, indicar el contenido de ECX en hexadecimal, explicar por qué no es lo mismo en ambos casos. Concretar de dónde viene el nuevo valor (obtenido sin usar S)

Si se elimina el símbolo de dato inmediato ($) de la instrucciór anterior, en vez de poner la dirrecion de memoria del String saludo en ECX te ententara llenar el regsitro con los 4 primeros caracteres des String asi que se metera el equivalente hexadicimal( a(0x61) , l(0x6c) , o(0x6f) ,l(0x46) ) de los 4 caracteres en ECX  por lo que al llamar a Write  ententara escribir en la salida estandar 28 caracteres empezando por la posicion de memoria de ECX que es la combinacion de los 4 caracteres

Al modificar el programa, el registro %ecx tiene el valor: 0x616cf48 que efictivamente corresponde a nuetras supociciones,

![p2-2](https://github.com/NAEL1/EC/blob/master/practica2/pr2-2.png)


####4 ¿Cuántas posiciones de memoria ocupa la variable longsaludo? ¿Y la variable saludo? ¿Cuántos bytes ocupa por tanto la sección de datos? Comprobar con un volcado Data->Memory mayor que la zona de datos antes de hacer Run.
`
 	longsaludo ocupa 4 bytes.
 	saludo ocupa 28 bytes.
 	por lo tanto la seccion datos ocupa 32 bytes
`
![p2-3](https://github.com/NAEL1/EC/blob/master/practica2/pr2-3.png)

`
tal como se ha comentado vemos que saludo ocupa 28 bytes empezando en 0x804a01c por 0x48 "H" y terminando en 0x804a037 por 0x0a "LF o salto de linea"
y longsaludo ocupa 4 bytes empezando en 0x804a038 y terminando en 0x804a03b
`


####5 Añadir dos volcados Data»>Memory dela variable longsaludo, uno como entero hexadecilmal, y otro como 4 bytes hex. Teniendo en cuenta lo mostrado en esos volcados... ¿Qué direcciones de memoria ocupa longsaludo? ¿Cuál byte está en la primera posición, el más o el menos significativo? ¿Los procesadores de la línea x86 usan el criterio del extremo mayor (bigendian) o menor (little»endian)? Razonar la respuesta

![p2-4](https://github.com/NAEL1/EC/blob/master/practica2/pr2-4.png)

longlista ocupa direcciones de memoria que va desde 0x804a038 hasta  0x804a03b, el menos significativo es 0x804a038  y el mas significativo es 0x804a03b, los procesadores de linea x86 usan little endian , porque como se ve en longlista, la parte menos significativa se guarda en la posicion mas pequeña.

####6 ¿Cuántas posiciones de memoria ocupa la instrucción mov S1, %ebx? ¿Cómo se ha obtenido esa información? Indicar las posiciones concretas en hexadecimal.

la operacion mov $1 , %ebx ocupa 5 bytes he obtenido esta informacion usando *objdump* :

 80483f2:	bb 01 00 00 00       	mov    $0x1,%ebx
loas direcciones empiezan en 0x80483f2 y terminan en 0x80483f6

####7 ¿Qué sucede si se elimina del programa la primera instrucción int 0x80? ¿Y si se elimina la segunda? Razonar las respuestas 

si se elimina del programa la primera instrucción int 0x80 no se llamara a la funcion Write y si se elimina la segunda no se llamara a exit. porque 0x80 es el codigo de interrupcion para llamar al manejador(en linux es el mismo Kernel) para que ejecute una rutina.asi que el jernel examinara el registro %eax para saber que servicio es el solicitado.

####8 ¿Cuál es el número de la llamada al sistema READ (en kernel Linux 32bits)? ¿De dónde se ha obtenido esa información?

mov $3 , %eax 	número de la llamada al sistema READ
mov $? , %ebx 	donde $? es el descriptor del fichero(por ejemplo $2 para el teclado)
mov num, %ecx 	donde num es el puntero al buffer deentrada
mov $? , %edx 	donde $? es el tamaño  del buffer(por ejemplo para int seria $5 : 1 byte para el signo y 4 para el entero)
int $0x80 	trampa de S.O.

el sistema escribira en %eax en numero de byte leido o el codigo de error en el caso de haya fallado la lectura

Reading from a File

For reading from a file, perform the following tasks −

    Put the system call sys_read() number 3, in the EAX register.

    Put the file descriptor in the EBX register.

    Put the pointer to the input buffer in the ECX register.

    Put the buffer size, i.e., the number of bytes to read, in the EDX register.

Solucion obtenida de la pagina http://www.tutorialspoint.com/assembly_programming/assembly_file_management.htm



###Sesión de depuración suma.s

####1 ¿Cuál es el contenido de EAX justo antes de ejecutar la instrucción RET, para esos componentes de lista concretos? Razonar la respuesta, incluyendo cuánto valen 0b10, 0x10, y (.-Lista)/4

El registro EAX contenia 37 justo antes de ejecutar la instruccion  RET, ya que contenia la suma de los elementos de lista:
.int 1,2,10, 1,2,0b10, 1,2,0x10 
siengo 0b10 2 ya que 10 es la representacion en binario de 2 y 0x10 vale 16 ya que esta en hexadecimal.
(.Lista)/4  vale 9 que es : "." es la direccion actual, entonces cuenta la memoria ocupada entre la direcion actual y la etiqueta Lista que nos daria 36 Bytes  y se divide por 4 ya que cada elemento de la lista ocupa 4 Byte (.int)

####2 ¿Qué valor en hexadecimal se obtiene en resultado si se usa la lista de 3 elementos: .int Oxffffffff, Oxffffffff, Oxffffffff? ¿Por qué es diferente del que se obtiene haciendo la suma a mano? NOTA: Indicar qué valores va tomando EAX en cada iteración del bucle, como los muestra la ventana Status»>Registers, en hexadecimal y decimal (con signo). Fijarse también en si se van activando los flags CF y OF o no tras cada suma. Indicar también qué valor muestra resultado si se vuelca con Data»>Memory como decimal (con signo) o unsigned (sin signo).

| Iteracion  |  valor EAX | hexadecimal | Flags |
|:---:|:---:|:---:| :----:|
| 0  |  0 | 0xffffffff | PF SF IF |
|  1 |  -1 | 0xffffffff | CF AF SF IF |
|  2 |  -2 | 0xfffffffe | CF AF SF IF | 
|  3 |  -3 | 0xfffffffd | CF AF SF IF |

####3 ¿Qué dirección se le ha asignado ala etiqueta suma? ¿Y a bucle? ¿Cómo se ha obtenido esa información?
suma:0x70480d9
resultado: 0x8049106

![p2-5](https://github.com/NAEL1/EC/blob/master/practica2/pr2-5.png)

####4 ¿Para qué usa el procesador los registros EIP y ESP?

*EIP*  es el contador del programa apunta a la siguiente operacion a ejecutar.
*ESP* indice de pila  apunta al ultimo elemento introducido en la pila.

####5 ¿Cuál es el valor de ESP antes de ejecutar CALL, y cuál antes de ejecutar RET? ¿En cuánto se diferencian ambos valores? ¿Por qué? ¿Cuál de los dos valores de ESP apunta a algún dato de interés para nosotros? ¿Cuál es ese dato?

####6 ¿Qué registros modifica la instrucción CALL? Explicar por qué necesita CALL modificar esos registros

####7 ¿Qué registros modifica la instrucción RET? Explicar por qué necesita RET modificar esos registros

####8 Indicar qué valores se introducen en la pila durante la ejecución del programa, y en qué direcciones de memoria queda cada uno. Realizar un dibujo de la pila con dicha información. NOTA: en los volcados Data-> Memory se puede usar Sesp para referirse a donde apunta el registro ESP

####9 ¿Cuántas posiciones de memoria ocupa la instrucción mov $0, %edx? ¿Y la instrucción ilnc %edx? ¿Cuáles son sus respectivos códigos máquina? Indicar cómo se han obtenido. NOTA: en los volcados Data»> Memory se puede usar una dirección hexadecimal Ox... para indicar la dirección del volcado. Recordar la ventana View»>Machine Code Window. Recordar también la herramienta objdump.

####10 ¿Qué ocurriría si se eliminara la instrucción RET? Razonar la respuesta. Comprobarlo usando ddd