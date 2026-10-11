.data

board: .word 0, 0, 0, 0, 0, 0, 0, 0, 0
x_prompt: .asciiz "Player X, choose a position (1-9): "
o_prompt: .asciiz "Player O, choose a position (1-9): "
x_winner_prompt: .asciiz "Player X wins!"
o_winner_prompt: .asciiz "Player O wins!"
invalid_position_prompt: .asciiz "Invalid position, try again. "
occupied_position_prompt: .asciiz "Position already occupied, try again. "
tie_prompt: .asciiz "Tie game!"
x_marker: .asciiz "X"
o_marker: .asciiz "O"
row_centers: .word 5, 15, 26
col_centers: .word 5, 15, 26

.text
.globl main

main:
jal board_setup

# Player X's turn
x_turn:
li $v0, 4
la $a0, x_prompt
syscall

li $v0, 5
syscall

move $t1, $v0
move $s0, $t1

# Checks if position is valid
li $t2, 1
li $t3, 9
blt $t1, $t2, invalid_position_x_turn
bgt $t1, $t3, invalid_position_x_turn


addi $t1, $t1, -1
sll $t1, $t1, 2
la $t0, board
add $t0, $t0, $t1

# Checks if position is already occupied
li $t2, 1
li $t3, 2
lw $t4, 0($t0)
beq $t4, $t2, occupied_position_x_turn
beq $t4, $t3, occupied_position_x_turn

li $t2, 1
sw $t2, 0($t0)

# Draw X
move $a0, $s0
li $a1, 1
jal draw_marker

jal check_winner

j o_turn

invalid_position_x_turn:
li $v0, 4
la $a0, invalid_position_prompt
syscall
j x_turn

occupied_position_x_turn:
li $v0, 4
la $a0, occupied_position_prompt
syscall
j x_turn

# Player O's turn
o_turn:
li $v0, 4
la $a0, o_prompt
syscall

li $v0, 5
syscall

move $t1, $v0
move $s0, $t1

# Checks if position is valid
li $t2, 1
li $t3, 9
blt $t1, $t2, invalid_position_o_turn
bgt $t1, $t3, invalid_position_o_turn

addi $t1, $t1, -1
sll $t1, $t1, 2
la $t0, board
add $t0, $t0, $t1

# Checks if position is already occupied
li $t2, 1
li $t3, 2
lw $t4, 0($t0)
beq $t4, $t2, occupied_position_o_turn
beq $t4, $t3, occupied_position_o_turn

li $t2, 2
sw $t2, 0($t0)

# Draw O
move $a0, $s0
li $a1, 2
jal draw_marker

jal check_winner

j x_turn

invalid_position_o_turn:
li $v0, 4
la $a0, invalid_position_prompt
syscall
j o_turn

occupied_position_o_turn:
li $v0, 4
la $a0, occupied_position_prompt
syscall
j o_turn

# Procedure for checking if there's a winner
check_winner:
la $t0, board

# check first row
check_top_row:
lw $t1, 0($t0)
lw $t2, 4($t0)
lw $t3, 8($t0)

beq $t1, $zero, check_second_row
beq $t2, $zero, check_second_row
beq $t3, $zero, check_second_row

bne $t1, $t2, check_second_row
bne $t1, $t3, check_second_row

j who_is_winner

# check second row
check_second_row:
lw $t1, 12($t0)
lw $t2, 16($t0)
lw $t3, 20($t0)

beq $t1, $zero, check_third_row
beq $t2, $zero, check_third_row
beq $t3, $zero, check_third_row

bne $t1, $t2, check_third_row
bne $t1, $t3, check_third_row

j who_is_winner

# check third row
check_third_row:
lw $t1, 24($t0)
lw $t2, 28($t0)
lw $t3, 32($t0)

beq $t1, $zero, check_first_column
beq $t2, $zero, check_first_column
beq $t3, $zero, check_first_column

bne $t1, $t2, check_first_column
bne $t1, $t3, check_first_column

j who_is_winner

# check first column
check_first_column:
lw $t1, 0($t0)
lw $t2, 12($t0)
lw $t3, 24($t0)

beq $t1, $zero, check_second_column
beq $t2, $zero, check_second_column
beq $t3, $zero, check_second_column

bne $t1, $t2, check_second_column
bne $t1, $t3, check_second_column

j who_is_winner

# check second column
check_second_column:
lw $t1, 4($t0)
lw $t2, 16($t0)
lw $t3, 28($t0)

beq $t1, $zero, check_third_column
beq $t2, $zero, check_third_column
beq $t3, $zero, check_third_column

bne $t1, $t2, check_third_column
bne $t1, $t3, check_third_column

j who_is_winner

# check third column
check_third_column:
lw $t1, 8($t0)
lw $t2, 20($t0)
lw $t3, 32($t0)

beq $t1, $zero, check_first_diagonal
beq $t2, $zero, check_first_diagonal
beq $t3, $zero, check_first_diagonal

bne $t1, $t2, check_first_diagonal
bne $t1, $t3, check_first_diagonal

j who_is_winner

# check top-left to bottom-right diagonal
check_first_diagonal:
lw $t1, 0($t0)
lw $t2, 16($t0)
lw $t3, 32($t0)

beq $t1, $zero, check_second_diagonal
beq $t2, $zero, check_second_diagonal
beq $t3, $zero, check_second_diagonal

bne $t1, $t2, check_second_diagonal
bne $t1, $t3, check_second_diagonal

j who_is_winner

# check bottom-left to top-right diagonal
check_second_diagonal:
lw $t1, 8($t0)
lw $t2, 16($t0)
lw $t3, 24($t0)

beq $t1, $zero, no_win
beq $t2, $zero, no_win
beq $t3, $zero, no_win

bne $t1, $t2, no_win
bne $t1, $t3, no_win

j who_is_winner

# If no winner detected (also checks for a tie (full board))
no_win:
check_first:
lw $t1, 0($t0)
bne $t1, $zero, check_second
j no_tie

check_second:
lw $t1, 4($t0)
bne $t1, $zero, check_third
j no_tie

check_third:
lw $t1, 8($t0)
bne $t1, $zero, check_fourth
j no_tie

check_fourth:
lw $t1, 12($t0)
bne $t1, $zero, check_fifth
j no_tie

check_fifth:
lw $t1, 16($t0)
bne $t1, $zero, check_sixth
j no_tie

check_sixth:
lw $t1, 20($t0)
bne $t1, $zero, check_seventh
j no_tie

check_seventh:
lw $t1, 24($t0)
bne $t1, $zero, check_eighth
j no_tie

check_eighth:
lw $t1, 28($t0)
bne $t1, $zero, check_ninth
j no_tie

check_ninth:
lw $t1, 32($t0)
bne $t1, $zero, tie
jr $ra

no_tie:
jr $ra

tie:
li $v0, 4
la $a0, tie_prompt
syscall
j terminate

# Figures out who the winner is
who_is_winner:
li $t4, 1
li $t5, 2
beq $t1, $t4, x_winner
beq $t1, $t5, o_winner

# If Player X wins
x_winner:
li $v0, 4
la $a0, x_winner_prompt
syscall
j terminate

# If Player O wins
o_winner: 
li $v0, 4
la $a0, o_winner_prompt
syscall
j terminate

# End game
terminate:
li $v0, 10
syscall

# Sets up grid for gameplay
board_setup:
# Initializes display address and color (white)
li $t0, 0x10008000
li $t3, 0x00FFFFFF

# 0 represents the starting row, 10 represents the column number (fixed)
li $t1, 0
li $t2, 10

# Draws first vertical line
vertical_one:
sll $t4, $t1, 5
add $t4, $t4, $t2
sll $t4, $t4, 2
add $t5, $t0, $t4
sw $t3, 0($t5)
addi $t1, $t1, 1
blt $t1, 32, vertical_one

# 0 represents the starting row, 21 represents the column number (fixed)
li $t1, 0
li $t2, 21

# Draws second vertical line
vertical_two:
sll $t4, $t1, 5
add $t4, $t4, $t2
sll $t4, $t4, 2
add $t5, $t0, $t4
sw $t3, 0($t5)
addi $t1, $t1, 1
blt $t1, 32, vertical_two

# 10 represents the row number (fixed), 0 represents the starting column
li $t1, 10
li $t2, 0

#Draws first horizontal line
horizontal_one:
sll $t4, $t1, 5
add $t4, $t4, $t2
sll $t4, $t4, 2
add $t5, $t0, $t4
sw $t3, 0($t5)
addi $t2, $t2, 1
blt $t2, 32, horizontal_one

# 21 represents the row number (fixed), 0 represents the starting column
li $t1, 21
li $t2, 0

# Draws second horizontal line
horizontal_two:
sll $t4, $t1, 5
add $t4, $t4, $t2
sll $t4, $t4, 2
add $t5, $t0, $t4
sw $t3, 0($t5)
addi $t2, $t2, 1
blt $t2, 32, horizontal_two

jr $ra

# Draws the X's and O's on grid
draw_marker:
# Saves temporary registers
addi $sp, $sp, -36
sw $t0,  0($sp)
sw $t1,  4($sp)
sw $t2,  8($sp)
sw $t3, 12($sp)
sw $t4, 16($sp)
sw $t5, 20($sp)
sw $t6, 24($sp)
sw $t7, 28($sp)
sw $t8, 32($sp)

# Convert's players position into a row and column
addi $t0, $a0, -1
li $t3, 3
div $t0, $t3
mflo $t4                 
mfhi $t5                 

# Looks up pixel coordinates for that specific cell
la $t6, row_centers
sll $t4, $t4, 2
add $t6, $t6, $t4
lw $t1, 0($t6)           

la $t6, col_centers
sll $t5, $t5, 2
add $t6, $t6, $t5
lw $t2, 0($t6)           

# Initializes bitmap display with base address and color (white)
li $t0, 0x10008000
li $t3, 0x00FFFFFF

# If marker type is 1, draw an X, otherwise, draw an O    
li $t4, 1
beq $a1, $t4, draw_x

j draw_o


# Draws X using two diagonal lines
draw_x:
li $t4, 0

x_loop:
    
addi $t5, $t1, -2
add $t5, $t5, $t4
addi $t6, $t2, -2
add $t6, $t6, $t4

sll $t7, $t5, 5
add $t7, $t7, $t6
sll $t7, $t7, 2
add $t8, $t0, $t7
sw $t3, 0($t8)

addi $t6, $t2, 2
sub $t6, $t6, $t4

sll $t7, $t5, 5
add $t7, $t7, $t6
sll $t7, $t7, 2
add $t8, $t0, $t7
sw $t3, 0($t8)

addi $t4, $t4, 1
blt $t4, 5, x_loop

j marker_done


# Draws O using a square outline
draw_o:
li $t4, 0

o_loop:
    
addi $t5, $t1, -2
addi $t6, $t2, -2
add $t6, $t6, $t4

sll $t7, $t5, 5
add $t7, $t7, $t6
sll $t7, $t7, 2
add $t8, $t0, $t7
sw $t3, 0($t8)

addi $t5, $t1, 2

sll $t7, $t5, 5
add $t7, $t7, $t6
sll $t7, $t7, 2
add $t8, $t0, $t7
sw $t3, 0($t8)

addi $t5, $t1, -2
add $t5, $t5, $t4
addi $t6, $t2, -2

sll $t7, $t5, 5
add $t7, $t7, $t6
sll $t7, $t7, 2
add $t8, $t0, $t7
sw $t3, 0($t8)

addi $t6, $t2, 2

sll $t7, $t5, 5
add $t7, $t7, $t6
sll $t7, $t7, 2
add $t8, $t0, $t7
sw $t3, 0($t8)

addi $t4, $t4, 1
blt $t4, 5, o_loop

# Restores register and goes back to where program left off
marker_done:
lw $t0,  0($sp)
lw $t1,  4($sp)
lw $t2,  8($sp)
lw $t3, 12($sp)
lw $t4, 16($sp)
lw $t5, 20($sp)
lw $t6, 24($sp)
lw $t7, 28($sp)
lw $t8, 32($sp)
addi $sp, $sp, 36

jr $ra
