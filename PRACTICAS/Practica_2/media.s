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
		.int -3000000000, -3000000000, -3000000000, -3000000000
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
		.error "Definir TEST entre 1 ... 8"
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

# 4) gcc media.s -o media -no-pie

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
	mov   media,%rcx #cuarto parametro, LSB en hexadecimal (recordar little-endian)
	mov   resto,%r8 #quito paremetro, MSB en hexadecimal 

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
	mov  (%rbx,%rsi,4), %eax
	cltd #extension de signo EDX:EAX <- EAX

	add  %eax, %ebp

	adc 	%edx, %edi

	inc 	%rsi
	cmp   %rsi,%rcx
	jne    bucle

	mov  %edi, %edx
	mov  %ebp, %eax

	pop %rdi
	pop %rbp

	ret


calc_media:
	idiv	 %ecx  # %edx <- RDX:RAX mod ECX
				  # %eda <- RDX:RAX / ECX

	ret