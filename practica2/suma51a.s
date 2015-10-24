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
	.ascii "suma = %llu =  %llx hex \n \0"
	
.section .text
#_start:	.global _start
main:	.global main
	mov    $lista, %ebx
	mov longlista, %ecx
	call suma
	mov %eax, resultado
	mov %edx ,resultado+4

	pushl resultado+4
	pushl resultado 
	pushl resultado+4
	pushl resultado 
	push $formato
	call printf
	add $20 ,%esp

	ret

suma:
	push %esi
	mov $0, %eax
	mov $0, %esi
	mov $0, %edx
bucle:
	add (%ebx,%esi,4), %eax
	jnc extra
	inc %edx
extra:	
	inc       %esi
	cmp  %esi,%ecx
	jne bucle

	pop %esi
	ret
