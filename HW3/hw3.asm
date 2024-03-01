.data
prompt: .asciiz "Enter a number: "
twofactorial: .word 2
threefactorial: .word 6

.text
	.globl main

main:
	la $t0, twofactorial
	la $t1, threefactorial

	la $a0, prompt
	li $v0, 4
	syscall
	li $v0, 5
	syscall

	move $t9, $v0

	jal compute

	j exit

compute:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $t9, 4($sp)

	addi $t3, $t9, 1	#1 + x

	mult $t9, $t9		#x^2
	mflo $t4
	div $t4, $t0		#x^2 / 2!
	mflo $t5

	add $t3, $t3, $t5	#1 + x + x^2/2!

	mult $t4, $t9		#x^2 * x = x^3
	mflo $t4
	div $t4, $t1		#x^3 / 3!
	mflo $t5

	add $t3, $t3, $t5	#1+x + x^2/2! + x^3/3!

	lw $ra, 0($sp)
	lw $t9, 4($sp)
	addi $sp, $sp, 8

	jr $ra	

exit:
	move $a0, $t3
	li $v0, 4
	syscall

	li $v0, 10
	syscall