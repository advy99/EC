// gcc -Og bomba.c -o bomba -no-pie -fno-guess-branch-probability

#include <stdio.h>	// para printf(), fgets(), scanf()
#include <stdlib.h>	// para exit()
#include <string.h>	// para strncmp()
#include <sys/time.h>	// para gettimeofday(), struct timeval

#define SIZE 100
#define TLIM 5

char stdio[]="0x63f12\n";	// contraseña
int  ecx  = 3012;			// pin

void saluda(void){
	printf(	"\n"
		"***************\n"
		"*** BOOM!!! ***\n"
		"***************\n"
		"\n");
	exit(-1);
}

void explota(void){
	char boom[] = "\nAsdf";
	char ax[]   =  "\nPues va a ser que con esta no explota, solo molesta\n";

	if( strncmp(boom, ax, sizeof(boom)) > 0){
		printf(ax);
	}
	saluda();
}

void boom(void){
	char boom[] = "asd";
	char ax[]  =  "zxc";

	if( strncmp(boom, ax, sizeof(boom)) > 0){
		printf(ax);
	}
}

void molesta(){

	char aux[]  = "abc";
	char aux2[] = "zsd";

	if( strncmp(aux, aux2, sizeof(aux) ) > 0 ){
		printf(aux2);
	}

}

void nada(){
	
	int n = 3;

	int p = 1 << n;
	
	molesta();

	if( p >= n )
		explota();
	else{
		boom();
	}
}


void defused(void){
	printf(	"\n"
		"·························\n"
		"··· bomba desactivada ···\n"
		"·························\n"
		"\n");
	exit(0);
}


int main(){
	char pw[SIZE];
	int  pc, n;

	char saludo[] = "Buenas tardes\n";

	struct timeval tv1,tv2;	// gettimeofday() secs-usecs
	gettimeofday(&tv1,NULL);

	do	printf("\nIntroduce la contraseña: ");
	while (	fgets(pw, SIZE, stdin) == NULL );

	if (strncmp(pw, saludo, sizeof(saludo)) && 0){
		printf(saludo);
	}


	if    (	strncmp(pw,stdio,sizeof(stdio)) && saludo != "a" ){
	    molesta();
		 boom();
		 explota();
	    nada();
		 
		 
	}

	gettimeofday(&tv2,NULL);
	if    ( tv2.tv_sec - tv1.tv_sec > TLIM ){
	    boom();
		 nada();
	}


	do  {	printf("\nIntroduce el pin: ");
	 if ((n=scanf("%i",&pc))==0)
		scanf("%*s")    ==1;         }
	while (	n!=1 );
	if    (	pc != ecx ){
	    boom();
		 saluda();
		 molesta();
	}
	gettimeofday(&tv1,NULL);
	if    ( tv1.tv_sec - tv2.tv_sec > TLIM  ){ 
		 explota();
	    boom();
	}

	defused();

}
