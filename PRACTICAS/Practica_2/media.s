.section .data
#ifndef TEST
#define TEST 9
#endif

	.macro linea
	#if   TEST==1
	 	.int 1,1,1,1
	#elif TEST==2
		.int 0x0fffffff, 0x0fffffff, 0x0fffffff, 0x0fffffff
	#elif TEST==3
		.int 0x10000000, 0x10000000, 0x10000000, 0x10000000
	#elif TEST==4
		.int 0xffffffff, 0xffffffff, 0xffffffff, 0xffffffff
	#elif TEST==5
		.int -1, -1, -1, -1
	#elif TEST==6
		.int 200 000 000, 200 000 000, 200 000 000, 200 000 000
	#elif TEST==7
		.int 300 000 000, 300 000 000, 300 000 000, 300 000 000
	#elif TEST==8
		.int 5 000 000 000, 5 000 000 000, 5 000 000 000, 5 000 000 000
	
	#else 
		.error "Definir TEST entre 1 ... 8"
	#endif
		.endm

lista:		.irpc i, 1234
						linea
				.endr

longlista:	.int   (.-lista)/4
resultado:	.quad   0
  formato: 	.ascii	"resultado \t =   %18lu (uns) \n"
				.ascii			  "\t\t = 0x%18lx (hex) \n"
				.asciz			  "\t\t = 0x  %08x %08x \n"

# 4) gcc media.s -o media -no-pie

.section .text
main: .global  main

	mov     $lista, %rbx
	mov  longlista, %ecx
	call suma		# == suma(&lista, longlista);
	mov  %eax, resultado

   #imprimir usando libC

	mov   $formato, %rdi
	mov   resultado,%rsi
	mov   resultado,%rdx
	mov          $0,%eax	# varargin sin xmm
	call  printf		# == printf(formato, res, res);

   #acabar_C:			# requiere libC

	mov  $0, %edi
	call _exit		# ==  exit(0)
	ret


suma:
	push     %rdx
	mov  $0, %eax
	mov  $0, %rdx
bucle:
	add  (%rbx,%rdx,4), %eax
	inc   %rdx
	cmp   %rdx,%rcx
	jne    bucle

	pop   %rdx
	ret

