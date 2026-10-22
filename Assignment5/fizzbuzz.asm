.data
fizz_word: .asciiz "fizz"
buzz_word: .asciiz "buzz"
fizzbuzz_word: .asciiz "fizzbuzz"

.text
li $t0, 1
li $t1, 101

increment:
	beq $t0, $t1, terminate
	rem $t2, $t0, 3
	rem $t3, $t0, 5
	beq $t2, 0, fizz
	beq $t3, 0, buzz
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	addi $t0, $t0, 1
	j increment
fizz:
	beq $t3, 0, fizzbuzz
	li $v0, 4
	la $a0, fizz_word
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	addi $t0, $t0, 1
	j increment
buzz:
	beq $t2, 0, fizzbuzz
	li $v0, 4
	la $a0, buzz_word
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	addi $t0, $t0, 1
	j increment
fizzbuzz:
	li $v0, 4
	la $a0, fizzbuzz_word
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	addi $t0, $t0, 1
	j increment
	
terminate:
	li $v0, 10
	syscall
