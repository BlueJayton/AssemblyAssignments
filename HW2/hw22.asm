.data
prompt: .asciiz "Enter a number: "

.text
	.globl main

main:
	la $a0, prompt
	li $v0, 4
	syscall
	li $v0, 5
	syscall

	move $a0, $v0

	jal fibcheck
	
	j exit

fibcheck:
	addi $t1, $zero, 1
	beq $a0, $zero, fibzero
	beq $a0, $t1, fibone
	j fib

fibzero:
	li $v0, 0
	jr $ra

fibone:
	li $v0, 1
	jr $ra

fib:
	addi $sp, $sp, -16	#making room
	sw $ra, 0($sp)		#saving return address
	sw $a0, 4($sp)		#saving entered number

	addi $a0, $a0, -1
	jal fibcheck
	sw $v0, 8($sp)

	lw $a0, 4($sp)
	addi $a0, $a0, -2
	jal fibcheck
	sw $v0, 12($sp)

	lw $ra, 0($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	addi $sp, $sp, 16
	add $v0, $t2, $t3

	jr $ra

exit:
	add $a0, $v0, $zero
	li $v0, 1
	syscall
	
	li $v0, 10
	syscall