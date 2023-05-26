	.text
	.file	"code3.c"
	.globl	calculator              # -- Begin function calculator
	.p2align	4, 0x90
	.type	calculator,@function
calculator:                             # @calculator
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset %rbp, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register %rbp
	movl	%edi, -16(%rbp)
	movl	%esi, -12(%rbp)
	movb	%dl, -1(%rbp)
	movsbl	-1(%rbp), %eax
	movl	%eax, %ecx
	subl	$43, %ecx
	je	.LBB0_2
	jmp	.LBB0_1
.LBB0_1:
	subl	$45, %eax
	je	.LBB0_3
	jmp	.LBB0_4
.LBB0_2:
	movl	-16(%rbp), %eax
	addl	-12(%rbp), %eax
	movl	%eax, -8(%rbp)
	jmp	.LBB0_4
.LBB0_3:
	movl	-16(%rbp), %eax
	subl	-12(%rbp), %eax
	movl	%eax, -8(%rbp)
.LBB0_4:
	movl	-8(%rbp), %eax
	popq	%rbp
	.cfi_def_cfa %rsp, 8
	retq
.Lfunc_end0:
	.size	calculator, .Lfunc_end0-calculator
	.cfi_endproc
                                        # -- End function
	.ident	"clang version 10.0.0-4ubuntu1 "
	.section	".note.GNU-stack","",@progbits
