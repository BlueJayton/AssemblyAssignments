.data
	.align 2

	arr:		.word -1, -2, -3, -4, -5, -6, -7, -8, -9, 0
	size:		.word 10
	min:		.word 0
	max:		.word 0
	newline:	.asciiz "\n"
	outmin:		.asciiz "Min: "
	outmax:		.asciiz "Max: "
	outabs:		.asciiz "Abs: "
.text
	.globl main

main:

	lw $s0, arr
	lw $s1, size
	lw $t8, min
	lw $t9, max

	addi $sp, $sp, -16 #give space for size, array, min, max
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $t8, 8($sp)
	sw $t9, 12($sp)

	jal MinMax

	#output
	#Get values back off stack
	lw $s0, 0($sp)	#load address of array, size, min, max
	lw $s1, 4($sp)
	lw $t8, 8($sp)
	lw $t9, 12($sp)
	lw $t7, 16($sp)

	#release space on stack
	addi $sp, $sp, 20

	#min tag
	li $v0, 4
	la $a0, outmin
	syscall
	
	#Print min
	li $v0, 1
	move $a0, $t8
	syscall

	#newline
	li $v0, 4
	la $a0, newline
	syscall

	#max tag
	li $v0, 4
	la $a0, outmax
	syscall
	
	#Print max
	li $v0, 1
	move $a0, $t9
	syscall

	#newline
	li $v0, 4
	la $a0, newline
	syscall

	#abs tag
	li $v0, 4
	la $a0, outabs
	syscall
	
	#Print max
	li $v0, 1
	move $a0, $t6
	syscall


MinMax:
	#Get values back off stack
	lw $s0, 0($sp)	#load address of array, size, min, max
	lw $s1, 4($sp)
	lw $t8, 8($sp)
	lw $t9, 12($sp)

	#release space on stack
	addi $sp, $sp, 16

	add $t1, $t1, $s0 #make temp array pointer
	addi $t2, $zero, 0 #clear iterator
	
	#set min and max to first number
	lw $t4, 0($t1)
	add $t8, $t8, $t4	
	add $t9, $t9, $t4

	loop:
		addi $t3, $zero, 0 #clear current element
		lw, $t3, 0($t1)
	#checkmin
		ble $t3, $t8, changemin
	#checkmax
		bgt $t3, $t9, changemax
	#countup
	j next


	changemin:
		addi $t8, $zero, 0
		addi $t8, $t3, 0
		j next

	changemax:
		addi $t9, $zero, 0
		addi $t9, $t3, 0
		j next
	next: 
		addi $t1, $t1, 4
		blt $t1, 40, loop

	store:
		addi $sp, $sp, -16 #give space for size, array, min, max
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $t8, 8($sp)
		sw $t9, 12($sp)

		jal absfunc

		jr $ra

absfunc:
	#Get values back off stack
	lw $s0, 0($sp)	#load address of array, size, min, max
	lw $s1, 4($sp)
	lw $t8, 8($sp)
	lw $t9, 12($sp)

	#release space on stack
	addi $sp, $sp, 16

	#make temp array pointer
	add $t1, $t1, $s0

	#min - max into a0
	sub $a0, $t8, $t9

	#get absolute value, since it will always be lower - larger, we must take away the negative by 0 - number
	sub $a0, $zero, $a0
	
	addi $sp, $sp, -20 #give space for size, array, min, max
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $t8, 8($sp)
	sw $t9, 12($sp)
	sw $a0, 16($sp)

	jr $ra