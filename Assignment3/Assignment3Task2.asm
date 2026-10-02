li $t0, 0
li $t1, 101

increment:
	beq $t0, $t1, terminate
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 11
	li $a0, '\n'
	syscall
	
	addi $t0, $t0, 1
	
	j increment
	
terminate:
	li $v0, 10
	syscall