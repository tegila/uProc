/* avr-gcc -S file.c */
/* Write your program in a file filename. */
/* avr-as filename program.out */
/* avr-objcopy -j .text -j .data -O ihex program.out program.hex */

/* 
int main(void) {
  int i=0;
  i = i+10;
  return i;
}
*/

__SP_H__ = 0x3e
__SP_L__ = 0x3d
__SREG__ = 0x3f
__tmp_reg__ = 0
__zero_reg__ = 1
	.text
.global	main
	.type	main, @function
main:
	push r28
	push r29
	rcall .
	in r28,__SP_L__
	in r29,__SP_H__
/* prologue: function */
/* frame size = 2 */
/* stack size = 4 */
.L__stack_usage = 4
	std Y+2,__zero_reg__
	std Y+1,__zero_reg__
	ldd r24,Y+1
	ldd r25,Y+2
	adiw r24,10
	std Y+2,r25
	std Y+1,r24
	ldd r24,Y+1
	ldd r25,Y+2
/* epilogue start */
	pop __tmp_reg__
	pop __tmp_reg__
	pop r29
	pop r28
	ret
	.size	main, .-main
	.ident	"GCC: (GNU) 4.9.2"