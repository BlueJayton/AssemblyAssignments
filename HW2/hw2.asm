.data
list: .word 0:1000
prompt1: .asciiz "Enter an integer: "
prompt2: .asciiz "\nEnter another: "

.text
	.globl main

main:
	la $s2, list
	la $s3, list
	
	#get first int
	li $v0, 4
	la $a0, prompt1
	syscall
	li $v0, 5
	syscall
	move $s0, $v0

	#get second int
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 5
	syscall
	move $s1, $v0

	#get max size of array
	mul $t7, $s1, 4

for1:
	beq $t0, $s0, printarray	#outer loop condition check
	addi $t1, $zero, 0		#set inner loop controller to zero
	addi $t0, $t0, 1		#increment outerloop counter

for2:
	beq $t1, $s1, for1		#inner loop condition check
	mul $t4, $t1, 4			#4*j
	add $t5, $t0, $t1		#i+j
	add $s2, $s2, $t4
	sb $t5, ($s2)

	addi $t1, $t1, 1
	j for1

printarray:
	beq $t7, $t6 exit
	add $s3, $s3, $t6
	lb $t2, ($s3)

	li $v0, 1
	move $a0, $t2
	syscall

	li $a0, 32
	li $v0, 11
	syscall

	addi $t6, $t6, 1
	j printarray
exit:
	li $v0, 10
	syscall