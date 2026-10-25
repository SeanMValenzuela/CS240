.data
string_0: .asciiz "fizz"
string_1: .asciiz "buzz"
string_2: .asciiz "fizzbuzz"

.text
	li $t0, 1
	li $t1, 101
	li $t4, 3
	li $t5, 5
label_400010:
	beq $t0, $t1, label_4000c0
	rem $t2, $t0, $t4
	rem $t3, $t0, $t5
	beq $t2, $zero, label_40004c
	beq $t3, $zero, label_400074
	li $v0, 1
	move $a0, $t0
	syscall
	li $v0, 11
	li $a0, 10
	syscall
	addi $t0, $t0, 1
	j label_400010
label_40004c:
	beq $t3, $zero, label_40009c
	li $v0, 4
	la $a0, string_0
	syscall
	li $v0, 11
	li $a0, 10
	syscall
	addi $t0, $t0, 1
	j label_400010
label_400074:
	beq $t2, $zero, label_40009c
	li $v0, 4
	la $a0, string_1
	syscall
	li $v0, 11
	li $a0, 10
	syscall
	addi $t0, $t0, 1
	j label_400010
label_40009c:
	li $v0, 4
	la $a0, string_2
	syscall
	li $v0, 11
	li $a0, 10
	syscall
	addi $t0, $t0, 1
	j label_400010
label_4000c0:
	li $v0, 10
	syscall
