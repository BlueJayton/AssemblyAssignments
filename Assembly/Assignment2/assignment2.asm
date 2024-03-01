.data
	x: .word 3, 16, 4, 8, 23, 16, 12, 28, 2, 10
	iter:  .word 0
	size:  .word 10
	newline: .asciiz "\n"
.text

main: 
	lw $t1, iter
	lw $t2, size

	add $t3, $zero, 0 #clear max
	add $t3, $t3, 1	#lower bound

	add $t4, $zero, 0 #clear min
	addi $t4, $t4, 100 #upper bound
loop:
	beq $t1, $t2, end #if iter == size, go to end
	
	add $t5, $zero, 0 #clear current int
	lw $t5, x($t0)

#checkmax
	bgt $t5, $t3, changemax
	
#checkmin
	ble $t5, $t4, changemin

neither:
	j next

changemax:
	add $t3, $zero, 0 #clear max
	add $t3, $t5, 0
	j next
changemin:
	add $t4, $zero, 0 #clear min
	add $t4, $t5, 0
	j next
next:
	add $t0, $t0, 4 #next number
	add $t1, $t1, 1 #next iter	
	j loop
end:
	#Print max
	li $v0, 1
	move $a0, $t3
	syscall
	
	#newline
	li $v0, 4
	la $a0, newline
	syscall

	#Print min
	li $v0, 1
	move $a0, $t4
	syscall
		
	#newline
	li $v0, 4
	la $a0, newline
	syscall

	#MinMax
	add $t6, $t4, $t3
	srl $t6, $t6, 1
	li $v0, 1
	move $a0, $t6
	syscall
		
	#newline
	li $v0, 4
	la $a0, newline
	syscall

	#MaxMin
	sub $t7, $t3, $t4
	srl $t7, $t7, 1
	subu $t7, $zero, $t7
	li $v0, 1
	move $a0, $t7
	syscall

	jr $ra
