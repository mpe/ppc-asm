#include "helpers.S"

// You can #define things here
#define SOME_VAL	2

// You can define data here
.data
string_val:
	.ascii "hello world\n"
string_val_end:

.text
	.align 2
	.global user_code
	.type user_code,@function
user_code:
	// ========================================
	// User code starts here
	// %r1 is stack pointer
	// %r2 is toc

	// See examples.S for more examples

	// ========================================
	// Write a message to stdout

	li	%r0, sys_write
	li	%r3, 1
	ld	%r4, string_val@got(%r2)
	li	%r5, string_val_end-string_val
	sc

	// ========================================
	blr
