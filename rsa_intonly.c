#include <stdio.h>

//#include <io.h>

#include <string.h>

#include <stdlib.h>

#include <fcntl.h>
#include <time.h>

int main(void){

	int i, j;

	printf("RSA encryption ready...\n");

	int p, q;
	int primeconfirm1 = 0;
	int primeconfirm2 = 0;
	while(primeconfirm1 == 0){

		printf("Enter first prime number: ");
		scanf("%d", &p); //need to be passing pointers in yo
		primeconfirm1 = prime_checker(p);
		if(primeconfirm1 == 0)
			printf("Your first number is not prime.\n");
	}
	while(primeconfirm2 == 0){

		printf("Enter second prime number: ");
		scanf("%d", &q);
		primeconfirm2 = prime_checker(q);
		if(primeconfirm2 == 0)
			printf("Your second number is not prime.\n");
	}
	printf("First number: %d, Second number: %d\n", p, q);

	int e_bool;
	e_bool = 0;
	int n, phi, e, s, d;
	n = p*q; 
	phi = (p-1)*(q-1); //totient
	printf("Phi value = %d\n", phi);
	while(e_bool == 0){
		printf("Enter a prime number that is less than phi for (e): ");
		scanf("%d", &e);
		e_bool = e_checker(e, phi);
		if(e_bool == 0)
			printf("Your e number is not valid.\n");
	}
	d = 1;
	s = (d * e) % phi;
	while(s != 1){
		s = (d * e) % phi;
		d++;
	}
	d--;

	printf("Public Key: %d %d\n", e, n);
	printf("Private key: %d %d\n", d, n);
	
	//unsigned char msg[100];
	int M, C, plaintext, ciphertext;
	printf("Enter plaintext: ");
	scanf("%d", &M); 
	ciphertext = encrypt(M, e, n);
	printf("Encrypted: %d\n", ciphertext);
	printf("Enter ciphertext: ");
	scanf("%d", &C);
	plaintext = decrypt(C, d, n);
	printf("Decrypted: %d\n", plaintext);
	

}
int encrypt(int M, int e, int n){
	int i;
	int C;
	C = 1;
	for(i = 0; i < e; i++){
		C = (C*M)%n;
	}
	C = C % n;
	return C;
}
int decrypt(int C, int d, int n){
	int i;
	int M;
	M = 1;
	for(i = 0; i < d; i++){
		M = (M*C)%n;
	}
	M = M % n;
	return M;

}
/*return 0 if not prime, 1 if prime*/
int prime_checker(int number) { 
	int i;
	for(i = 2; i < number; i++) { 
	    if(number % i == 0 && i != number) 
	    return 0; 
	} 
	return 1; 
} 
int e_checker(int e, int phi){
	int prime, lessthan;
	prime = prime_checker(e);
	if(e < phi)
		lessthan = 1;
	else
		lessthan = 0;

	if(lessthan == 1 && prime == 1)
		return 1;
	else
		return 0;
}