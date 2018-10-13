
#Para probar la bateria de test

#for i in $(seq 1 19); do
#rm media
#gcc -x assembler-with-cpp -D TEST=$i -no-pie media.s -o media
#printf "__TEST%02d__%35s\n" $i "" | tr " " "-" ; ./media
#done


#Antonio David Villegas Yeguas  --- 2B - Grupo practicas 2


.section .data
#ifndef TEST
#define TEST 20
#endif

	.macro linea
	  #if   TEST==1
	 	.int 1, 2, 1, 2
	#elif TEST==2
		.int -1, -2, -1, -2
	#elif TEST==3
		.int 0x7fffffff, 0x7fffffff, 0x7fffffff, 0x7fffffff  
	#elif TEST==4
		.int 0x80000000, 0x80000000, 0x80000000, 0x80000000
	#elif TEST==5
		.int 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
	#elif TEST==6
		.int 2000000000, 2000000000, 2000000000, 2000000000
	#elif TEST==7
		.int 3000000000, 3000000000, 3000000000, 3000000000
	#elif TEST==8
		.int -2000000000, -2000000000, -2000000000, -2000000000
	#elif TEST==9
		.int -3000000000, -3000000000, -3000000000, -3000000000       #ocurrira un error por el truncamiento
	#endif
		.endm

		.macro linea0
	
	  #if TEST>=1 && TEST<=9
		linea

	#elif TEST==10
		.int 0, 2, 1, 1
	#elif TEST==11
		.int 1, 2, 1, 1
	#elif TEST==12
		.int 8, 2, 1, 1
	#elif TEST==13
		.int 15, 2, 1, 1
	#elif TEST==14
		.int 16, 2, 1, 1
	#elif TEST==15
		.int 0, -2, -1, -1
	#elif TEST==16
		.int -1, -2, -1, -1
	#elif TEST==17
		.int -8, -2, -1, -1
	#elif TEST==18
		.int -15, -2, -1, -1
	#elif TEST==19
		.int -16, -2, -1, -1



	#else 
		.error "Definir TEST entre 1 ... 19"
	#endif
		.endm

lista:      linea0
				.irpc i, 1234
						linea
				.endr

longlista:	.int   (.-lista)/4
media:		.int	  0
resto: 		.int    0
formato: 	.ascii	"media \t = %11d \t resto \t = %11d  \n"   
				.asciz			"\t = 0x %08x \t    \t = %08x \n"

formatoq:	.ascii   "\n\ncalculos realizados con registros de 64 bits \n"
				.ascii	"media \t = %11d \t resto \t = %11d  \n"   
				.asciz			"\t = 0x %08x \t    \t = %08x \n\n"

# gcc media.s -o media -no-pie

.section .text
main: .global  main

	mov     $lista, %rbx
	mov  longlista, %ecx
	call suma		# == suma(&lista, longlista);

	call calc_media
	mov %edx, resto
	mov %eax, media

   #imprimir usando libC

	mov   $formato, %rdi #primer parametro, el formato
	mov   media,%rsi #segundo parametro, resultado en decimal
	mov   resto,%rdx #tercer parametro, resultado en hexadecimal
	mov   media,%rcx #cuarto parametro
	mov   resto,%r8 #quinto paremetro

	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res);


	mov  longlista, %ecx  #recuperamos la longitud de la lista
								 #la perdimos al usar printf

	#hacemos todo de nuevo, solo que con 64 bits

	call sumaq
	call calc_mediaq
	mov %edx, resto
	mov %eax, media

	mov   $formatoq, %rdi #primer parametro, el formato
	mov   media,%rsi #segundo parametro, resultado en decimal
	mov   resto,%rdx #tercer parametro, resultado en hexadecimal
	mov   media,%rcx #cuarto parametro
	mov   resto,%r8 #quinto paremetro
	
	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res);

   #acabar_C:			# requiere libC

	mov  $0, %edi
	call _exit		# ==  exit(0)
	ret


suma:
	push %rbp
	push %rdi

	mov  $0, %eax
	mov  $0, %edx
	mov  $0, %ebp

	mov  $0, %edi
	
	mov  $0, %esi

bucle:
	mov  (%rbx,%rsi,4), %eax  #leemos valor
	cltd                      #extension de signo EDX:EAX <- EAX

	add  %eax, %ebp           #sumamos en ebp

	adc 	%edx, %edi          #sumamos a la extension de signo acarreo, lo guardamos en edi

	inc 	%rsi
	cmp   %rsi,%rcx
	jne    bucle

	mov  %edi, %edx			 #dejamos los valores en edx y eax
	mov  %ebp, %eax

	pop %rdi
	pop %rbp

	ret


calc_media:
	idiv	 %ecx  # %edx <- RDX:RAX mod ECX
				    # %eax <- RDX:RAX / ECX

	ret



sumaq:

	push %rdx
	push %rdi
	
	mov $0, %eax
	mov $0, %edi
	mov $0, %edx

bucleq:
	mov  (%rbx,%rdx,4), %eax #leemos el valor
	cltq                     # extendemos con signo RAX <- ExtSng(EAX)

	add %rax, %rdi           #lo sumamos con 64 bits

	inc %rdx						 #sumamos 1 a los valores sumados
	cmp %rdx, %rcx
	jne bucleq

	mov %rdi, %rax

	pop %rdi
	pop %rdx
	ret



calc_mediaq:
	cqto          #extendemos con signo RDX:RAX <- RAX
	idiv  %rcx	  # %rdx <- RDX:RAX mod RCX
				     # %rax <- RDX:RAX / RCX

	ret



#A continuacion, pondre en comentarios, las soluciones por apartado, el apartado 5.4 esta en la solucion (funcion suma)
#																								apartado 5.5 esta en la solucion (funcion sumaq)

#Apartado 5.1

#suma:
#	mov  $0, %eax
#	mov  $0, %rdx
#	
#	mov $0, %rsi
#
#bucle:
#	add  (%rbx,%rsi,4), %eax
#
#	jnc	sin_acarreo
#	inc   %rdx        #cuando hay acarreo, sumamos a la segunda seccion
#sin_acarreo:
#	inc 	%rsi
#	cmp   %rsi,%rcx
#	jne    bucle
#
#	ret


#Apartado 5.2

#suma:
#	mov  $0, %eax
#	mov  $0, %rdx
#	
#	mov $0, %rsi
#
#bucle:
#	add  (%rbx,%rsi,4), %eax	#sumamos en EAX
#
#	adc 	$0, %edx					#sumamos el acarreo en EDX
#
#	inc 	%rsi
#	cmp   %rsi,%rcx
#	jne    bucle

#	ret


#Apartado 5.3

#suma:
#	push %rbp
#	push %rdi

#	mov  $0, %eax
#	mov  $0, %edx
#	mov  $0, %ebp

#	mov  $0, %edi
	
#	mov  $0, %esi

#bucle:
#	mov  (%rbx,%rsi,4), %eax
#	cltd	                        #extendemos con signo EDX:EAX <- EAX
#	add  %eax, %ebp
#
#	adc 	%edx, %edi					#sumamos con acarreo a la extension de signo
#
#	inc 	%rsi
#	cmp   %rsi,%rcx
#	jne    bucle
#
#	mov  %edi, %edx
#	mov  %ebp, %eax
#
#	pop %rdi
#	pop %rbp
#
#	ret
