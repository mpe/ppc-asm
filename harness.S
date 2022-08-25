#include "helpers.S"

.data
msg:
	.ascii "harness completed\n"
msg_end:

.text
	.align 2
	.global _start
	.type _start,@function
_start:
	addis	%r2, %r12, .TOC. - _start@ha
	addi	%r2, %r2, .TOC. - _start@l
.localentry _start,.-_start
	stdu	%r1, -32(%r1)
	bl	user_code
	addi	%r1, %r1, 32

	// Write "harness completed" to stdout
	li	%r0, sys_write
	li	%r3, 1
	ld	%r4, msg@got(%r2)
	li	%r5, msg_end-msg
	sc

	// By default exit with success
	li	%r0, sys_exit
	li	%r3, 0
	sc
	b	.
