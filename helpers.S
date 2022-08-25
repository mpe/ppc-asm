#define	sys_write	4
#define	sys_exit	1

// Below macros borrowed from Linux

.macro __LOAD_REG_IMMEDIATE_32 r, x
	.if (\x) >= 0x8000 || (\x) < -0x8000
		lis \r, (\x)@high
		.if (\x) & 0xffff != 0
			ori \r, \r, (\x)@l
		.endif
	.else
		li \r, (\x)@l
	.endif
.endm

.macro __LOAD_REG_IMMEDIATE r, x
	.if (\x) >= 0x80000000 || (\x) < -0x80000000
		__LOAD_REG_IMMEDIATE_32 \r, (\x) >> 32
		sldi	\r, \r, 32
		.if (\x) & 0xffff0000 != 0
			oris \r, \r, (\x)@high
		.endif
		.if (\x) & 0xffff != 0
			ori \r, \r, (\x)@l
		.endif
	.else
		__LOAD_REG_IMMEDIATE_32 \r, \x
	.endif
.endm

#define LOAD_REG_IMMEDIATE(reg, expr) __LOAD_REG_IMMEDIATE reg, expr

#define LOAD_REG_ADDR(reg,name) \
	ld	reg,name@got(r2)
