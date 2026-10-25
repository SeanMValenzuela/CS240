.data
fizz_word: .asciiz "fizz"
buzz_word: .asciiz "buzz"
fizzbuzz_word: .asciiz "fizzbuzz"

.text
li $t0, 1
li $t1, 101
li $t4, 3
li $t5, 5

increment:
	beq $t0, $t1, terminate
	rem $t2, $t0, $t4
	rem $t3, $t0, $t5
	beq $t2, $zero, fizz
	beq $t3, $zero, buzz
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	addi $t0, $t0, 1
	j increment
fizz:
	beq $t3, $zero, fizzbuzz
	li $v0, 4
	la $a0, fizz_word
	syscall
	li $v0, 11
	li $a0, '\n'
	syscall
	addi $t0, $t0, 1
	j increment
buzz:
	beq $t2, $zero, fizzbuzz
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
