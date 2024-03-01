.data
str: .asciiz "brexxit"
toreplace: .asciiz "x"
replacer: .asciiz "y"

.text
	.globl main

main:
	la $s0, str
	lb $s2, toreplace
	lb $s3, replacer
	add $s1, $s1, $zero

loop:
	add $t0, $s0, $s1
	lb $t1, 0($t0)

	bne $t1, $s2, next
	sb $s3, 0($t0)

next:
	addi $s1, $s1, 1
	beq $t1, $zero, exit
	j loop

exit:
	move $a0, $s0
	li $v0, 4
	syscall

	li $v0, 10
	syscall