.data
	.align 2	

	iter:		.word 0
	size:		.word 10
	Min:		.word 100
	Max:		.word 1
	prompt:		.asciiz "Enter number: "
	newline:	.asciiz "\n"

	
.text
	.globl main

main:
	lw $t1, iter
	lw $s1, size
	lw $t8, Min
	lw $t9, Max
	
	#allocate on heap and make array
	li $v0, 9
	li $a0, 40
	syscall
	move $s0, $v0

	#make temp for array address
	add $s2, $zero, $s0
	
	addi $sp, $sp, -16 #give space for size, array, min, max
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $t8, 8($sp)
	sw $t9, 12($sp)

	jal inputloop

	jal MinMax

	#GET MIN MAX FROM STACK
	addi $t8, $zero, 0
	addi $t9, $zero, 0

	lw $t8, 0($sp)
	lw $t9, 04($sp)	

	#Print min
	li $v0, 1
	move $a0, $t8
	syscall
	
	#newline
	li $v0, 4
	la $a0, newline
	syscall

	#Print max
	li $v0, 1
	move $a0, $t9
	syscall
		
	#newline
	li $v0, 4
	la $a0, newline
	syscall

	#MinMax
	add $t4, $t8, $t9
	srl $t4, $t4, 1
	li $v0, 1
	move $a0, $t4
	syscall
		
	#newline
	li $v0, 4
	la $a0, newline
	syscall

	#MaxMin
	sub $t5, $t9, $t8
	srl $t5, $t5, 1
	li $v0, 1
	move $a0, $t5
	syscall
	
	#end program
	li $v0, 10
	syscall
		inputloop:
	
			#prompt user
			la $a0, prompt
			li $v0, 4
			syscall
	
			#get value
			li $v0, 5
			syscall
			move $t2, $v0
	
			#Add to heap
			sw $t2, 0($s2)

			addi $t2, $zero, 0 #clear element
			addi $t1, $t1, 4
			addi $s2, $s2, 4
	
			blt $t1, 40, inputloop	
			jr $ra

MinMax:
	add $s0, $zero, $0  #clear registers
	add $s1, $zero, $0
	
	
	lw $s0, 0($sp)	#load address of array, size, min, max
	lw $s1, 4($sp)
	lw $t8, 8($sp)
	lw $t9, 12($sp)

	#clear iterator
	addi $t1, $zero, 0
	
	#remake temp for array address
	add $s2, $zero, $s0

	addi $sp, $sp, 16 #remove space for array and size
	
	addi $sp, $sp, -40 #allocate space in stack for 10 ints
	
	jal stackloop

	addi $t1, $zero, 0
	addi $sp, $sp, -40

	lw $t8, 0($sp)	#set min and max to first element
	lw $t9, 0($sp)  
	
	jal FindMinMax

	#PUT MIN AND MAX ON STACK
	addi $sp, $sp, -8

	sw $t8, 0($sp)
	sw $t9, 4($sp)

	jr $ra
		stackloop:

			#get value from heap
			lw $t2, 0($s2)

			#add to stack
			sw $t2, 0($sp)

			addi $t2, $zero, 0 #clear element
			addi $t1, $t1, 4
			addi $sp, $sp, 4
			addi $s2, $s2, 4
			blt $t1, 40, stackloop
			jr $ra


		FindMinMax:
			add $t3, $zero, 0	#clear current element
			lw $t3, 0($sp)		#get next value

		#checkmin
			ble $t3, $t8, changemin
		#checkmax
			bgt $t3, $t9, changemax
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
			addi $sp, $sp, 4
			blt $t1, 40, FindMinMax
			jr $ra