/* COMENTÁRIOS */
/* xtensa-lx106-elf-gcc -S file.c */
/* Write your program in a file filename. */

/* 
int main(void) {
  int i=0;
  i = i+10;
  return i;
}
*/

	.file	"main.c"
	.text
	.literal_position
	.align	4
	.global	main
	.type	main, @function
main:
	addi	sp, sp, -32
	s32i.n	a15, sp, 28
	mov.n	a15, sp
	movi.n	a2, 0
	s32i.n	a2, a15, 0
	l32i.n	a2, a15, 0
	addi.n	a2, a2, 10
	s32i.n	a2, a15, 0
	l32i.n	a2, a15, 0
	mov.n	sp, a15
	l32i.n	a15, sp, 28
	addi	sp, sp, 32
	ret.n
	.size	main, .-main
	.ident	"GCC: (crosstool-NG 1.20.0) 4.8.2"