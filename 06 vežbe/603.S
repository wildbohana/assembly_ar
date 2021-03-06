# potrogram za postavljanje pariteta 16-bit broja
# in setParity(unsigned short int* v)

.section .data
	v: .word 0x12ac
.section .text
.globl main

main:
	movl $v, %ecx				# adresa od v
	andw $0x7fff, (%ecx)			# najviši bit na 0 (ne gleda se kod parity)
	movw $1, %dx				# inicijalna maska
	xorl %eax, %eax				# brojač bita
petlja:
	testw %dx, (%ecx)			# da li je na poziciji maske bit 1?
	jz dalje				# ako je 0, onda ništa, ideš dalje
	incl %eax
dalje:
	shlw $1, %dx				# sledeća bit pozicija
	jnc petlja				# ako nema carry, idi dalje
postavi:	
	andl $1, %eax				# da li je najniži bit u %eax 0 ili 1
	pushl %eax				# stavi na stek (sačuvaj)
	shlw $1, (%ecx)				# broj shift u levo (oslobodi najniži bit)
	shrl $1, %eax				# brojač bita shift desno, vrednost iz najniže
						# bit pozicije će otići u carry
	rcrw $1, (%ecx)				# desna carry rotacija -> na prvo mesto broja će
						# se smestiti vr. iz carry - paritet broja
	popl %eax				# vrati sa steka (restauriraj)
kraj:
	movl $1, %eax
	movl $0, %ebx
	int $0x80
