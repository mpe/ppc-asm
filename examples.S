#include "helpers.S"

#define MSR_HV_BIT	60
#define MSR_PR_BIT	14

#define MSR_HV		(1 << MSR_HV_BIT)
#define MSR_PR		(1 << MSR_PR_BIT)

.data
u64_val:
	.llong 0xdeadbeefdeadbeef
u32_val:
	.long 0xdeadbeef

	// ========================================
	// Test a low numbered bit in r3, sets cr0
	li	%r3, MSR_PR
	andi.	%r4, %r3, MSR_PR
	// Branch if it's non-zero
	bne	1f
	nop
1:	nop

	// ========================================
	// Test a high numbered bit in r3, sets cr0
	LOAD_REG_IMMEDIATE(%r3, MSR_HV)
	extrdi.	%r4, %r3, 1, 63 - MSR_HV_BIT
	// Branch if it's non-zero
	bne	1f
	nop
1:	nop
