li $t0, 0
li $t1, 101
li $t2, 0

divisible:
	beq $t0, $t1, terminate
	
	rem $t3, $t0, 2
	
	beq $t3, $zero, sum
	
	j increment
	
sum:
	add $t2, $t0, $t2	
	
increment:
	addi $t0, $t0, 1	
	j divisible
	
terminate:
	li $v0, 1
	move $a0, $t2
	syscall