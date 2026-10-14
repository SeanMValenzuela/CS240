.data
deck: .word 0:52
welcome_msg: .asciiz "Welcome to Blackjack\n"
hit_or_stand_msg: .asciiz "Hit or stand? (1 to hit, 0 to stand): "
player_hand_msg: .asciiz "Your hand: "
player_hit_msg: .asciiz "You hit!\n"
player_stand_msg: .asciiz "You stand!\n"
player_wins: .asciiz "You win!\n"
player_bust_msg: .asciiz "Player bust!\n"
player_blackjack_msg: .asciiz "Player blackjack!\n"
dealer_hand_msg: .asciiz "Dealer's hand: "
dealer_hit_msg: .asciiz "Dealer hit!\n"
dealer_stand_msg: .asciiz "Dealer stand!\n"
dealer_wins: .asciiz "Dealer wins!\n"
dealer_bust_msg: .asciiz "Dealer bust!\n"
dealer_blackjack_msg: .asciiz "Dealer blackjack!\n"
tie_game_msg: .asciiz "Tie game!\n"
ace_msg: .asciiz "Ace\n"
two_msg: .asciiz "Two\n"
three_msg: .asciiz "Three\n"
four_msg: .asciiz "Four\n"
five_msg: .asciiz "Five\n"
six_msg: .asciiz "Six\n"
seven_msg: .asciiz "Seven\n"
eight_msg: .asciiz "Eight\n"
nine_msg: .asciiz "Nine\n"
ten_msg: .asciiz "Ten\n"
jack_msg: .asciiz "Jack\n"
queen_msg: .asciiz "Queen\n"
king_msg: .asciiz "King\n"
new_line: .asciiz "\n"

player_cards_x: .word 36, 82, 128, 174, 36, 82, 128, 174
dealer_cards_x: .word 54, 100, 146, 192, 54, 100, 146, 192
player_cards_y: .word 126
dealer_cards_y: .word 32

last_rank: .word 0
last_red: .word 0

# 3x5 pixel font, 5 rows per glyph (each row is 3 bits)
# glyph index: 0-9 = digits, 10 = A, 11 = J, 12 = Q, 13 = K
font:
.word 7,5,5,5,7    # 0
.word 2,6,2,2,7    # 1
.word 7,1,7,4,7    # 2
.word 7,1,7,1,7    # 3
.word 5,5,7,1,1    # 4
.word 7,4,7,1,7    # 5
.word 7,4,7,5,7    # 6
.word 7,1,1,1,1    # 7
.word 7,5,7,5,7    # 8
.word 7,5,7,1,7    # 9
.word 2,5,7,5,5    # A
.word 1,1,1,5,7    # J
.word 7,5,5,7,1    # Q
.word 5,5,6,5,5    # K

.text
.globl main
 
main:
jal draw_table

start:
# Initializes registers for player hand, dealer hand, hand indicator, card value, hit/stand, player aces, dealer aces, player card count, dealer card count
li $s0, 0
li $s1, 0
li $s2, 0
li $s3, 0
li $s4, 0
li $s5, 0
li $s6, 0
li $s7, 0
li $t8, 0
li $t9, 0

li $v0, 4
la $a0, welcome_msg
syscall

# Deals first card to player
player_first_deal:
li $s3, 0
li $v0, 42
li $a0, 0
li $a1, 52
syscall

move $t2, $a0

# Checks if a card has already been drawn
la $t3, deck
sll $t4, $t2, 2
add $t3, $t3, $t4
lw $t5, 0($t3)
bne $t5, $zero, player_first_deal

li $t5, 1
sw $t5, 0($t3)

li $t1, 13
div $t2, $t1
mfhi $t0
addi $t0, $t0, 1

jal card_check

# Deals first card to dealer
dealer_first_deal:
li $s3, 1
li $v0, 42
li $a0, 0
li $a1, 52
syscall

move $t2, $a0

# Checks if a card has already been drawn
la $t3, deck
sll $t4, $t2, 2
add $t3, $t3, $t4 
lw $t5, 0($t3)     
bne $t5, $zero, dealer_first_deal

li $t5, 1
sw $t5, 0($t3)

li $t1, 13
div $t2, $t1
mfhi $t0
addi $t0, $t0, 1

jal card_check

# Deals second card to player
player_second_deal:
li $s3, 0
li $v0, 42
li $a0, 0
li $a1, 52
syscall

move $t2, $a0

# Checks if a card has already been drawn
la $t3, deck
sll $t4, $t2, 2
add $t3, $t3, $t4   
lw $t5, 0($t3)     
bne $t5, $zero, player_second_deal  

li $t5, 1
sw $t5, 0($t3)

li $t1, 13
div $t2, $t1
mfhi $t0
addi $t0, $t0, 1

jal card_check

# Deals second card to dealer
dealer_second_deal:
li $s3, 1
li $v0, 42
li $a0, 0
li $a1, 52
syscall

move $t2, $a0

# Checks if a card has already been drawn
la $t3, deck
sll $t4, $t2, 2
add $t3, $t3, $t4
lw $t5, 0($t3)
bne $t5, $zero, dealer_second_deal

li $t5, 1
sw $t5, 0($t3)

li $t1, 13
div $t2, $t1
mfhi $t0
addi $t0, $t0, 1

jal card_check

li $t0, 21

beq $s0, $t0, check_both_natural_blackjack
beq $s1, $t0, dealer_natural_blackjack

j player_turn

# Checks if both initial hands are natural blackjacks
check_both_natural_blackjack:
beq $s1, $t0, tie_game
j player_natural_blackjack

# Asks player if they want to hit or stand
player_turn:
li $t1, 21
bgt $s0, $t1, player_bust
beq $s0, $t1, player_stand

li $v0, 4
la $a0, hit_or_stand_msg
syscall

li $v0, 5
syscall

move $t1, $v0
move $s5, $t1

li $t1, 0
beq $s5, $t1, player_stand

li $t1, 1
beq $s5, $t1, player_hit

j player_turn

# Checks dealer's hand to determine if they hit or stand
# Dealer stands if cards add up to 17 or greater, hits if 16 or under
dealer_turn:
li $t1, 21
bgt $s1, $t1, dealer_bust
beq $s1, $t1, compare_hands

li $t1, 17
bge $s1, $t1, dealer_stand_seventeen_noti
blt $s1, $t1, dealer_hit

j dealer_turn


# Checks what rank a card is
card_check:
addiu $sp, $sp, -4
sw $ra, 0($sp)
sw $t0, last_rank 
slti $t1, $t2, 26
sw $t1, last_red

li $t1, 1
beq $t0, $t1, ace_print

li $t1, 2
beq $t0, $t1, two_print

li $t1, 3
beq $t0, $t1, three_print

li $t1, 4
beq $t0, $t1, four_print

li $t1, 5
beq $t0, $t1, five_print

li $t1, 6
beq $t0, $t1, six_print

li $t1, 7
beq $t0, $t1, seven_print

li $t1, 8
beq $t0, $t1, eight_print

li $t1, 9
beq $t0, $t1, nine_print

li $t1, 10
beq $t0, $t1, ten_print

li $t1, 11
beq $t0, $t1, jack_print

li $t1, 12
beq $t0, $t1, queen_print

li $t1, 13
beq $t0, $t1, king_print


# Prints ace
ace_print:
li $v0, 4
la $a0, ace_msg
syscall

li $s4, 11

li $t1, 0
beq $t1, $s3, add_player_hand_ace
li $t1, 1
beq $t1, $s3, add_dealer_hand_ace

j card_done

# Prints two
two_print:
li $v0, 4
la $a0, two_msg
syscall

li $s4, 2

li $t1, 0
beq $t1, $s3, add_player_hand
li $t1, 1
beq $t1, $s3, add_dealer_hand

j card_done

# Prints three
three_print:
li $v0, 4
la $a0, three_msg
syscall

li $s4, 3

li $t1, 0
beq $t1, $s3, add_player_hand
li $t1, 1
beq $t1, $s3, add_dealer_hand

j card_done

# Prints four
four_print:
li $v0, 4
la $a0, four_msg
syscall

li $s4, 4

li $t1, 0
beq $t1, $s3, add_player_hand
li $t1, 1
beq $t1, $s3, add_dealer_hand

j card_done

# Prints five
five_print:
li $v0, 4
la $a0, five_msg
syscall

li $s4, 5

li $t1, 0
beq $t1, $s3, add_player_hand
li $t1, 1
beq $t1, $s3, add_dealer_hand

j card_done

# Prints six
six_print:
li $v0, 4
la $a0, six_msg
syscall

li $s4, 6

li $t1, 0
beq $t1, $s3, add_player_hand
li $t1, 1
beq $t1, $s3, add_dealer_hand

j card_done

# Prints seven
seven_print:
li $v0, 4
la $a0, seven_msg
syscall

li $s4, 7

li $t1, 0
beq $t1, $s3, add_player_hand
li $t1, 1
beq $t1, $s3, add_dealer_hand

j card_done

# Prints eight
eight_print:
li $v0, 4
la $a0, eight_msg
syscall

li $s4, 8

li $t1, 0
beq $t1, $s3, add_player_hand
li $t1, 1
beq $t1, $s3, add_dealer_hand

j card_done

# Prints nine
nine_print:
li $v0, 4
la $a0, nine_msg
syscall

li $s4, 9

li $t1, 0
beq $t1, $s3, add_player_hand
li $t1, 1
beq $t1, $s3, add_dealer_hand

j card_done

# Prints ten
ten_print:
li $v0, 4
la $a0, ten_msg
syscall

li $s4, 10

li $t1, 0
beq $t1, $s3, add_player_hand
li $t1, 1
beq $t1, $s3, add_dealer_hand

j card_done

# Prints jack
jack_print:
li $v0, 4
la $a0, jack_msg
syscall

li $s4, 10

li $t1, 0
beq $t1, $s3, add_player_hand
li $t1, 1
beq $t1, $s3, add_dealer_hand

j card_done

# Prints queen
queen_print:
li $v0, 4
la $a0, queen_msg
syscall

li $s4, 10

li $t1, 0
beq $t1, $s3, add_player_hand
li $t1, 1
beq $t1, $s3, add_dealer_hand

j card_done

# Prints king
king_print:
li $v0, 4
la $a0, king_msg
syscall

li $s4, 10

li $t1, 0
beq $t1, $s3, add_player_hand
li $t1, 1
beq $t1, $s3, add_dealer_hand

j card_done

# Prints when dealer stands on 17
dealer_stand_seventeen_noti:
li $v0, 4
la $a0, dealer_stand_msg
syscall

j compare_hands

# Player hits
player_hit:
li $v0, 4
la $a0, player_hit_msg
syscall
player_hit_used_card:
li $s3, 0
li $v0, 42
li $a0, 0
li $a1, 52
syscall

move $t2, $a0

# Checks if a card has already been drawn
la $t3, deck
sll $t4, $t2, 2
add $t3, $t3, $t4
lw $t5, 0($t3)
bne $t5, $zero, player_hit_used_card

li $t5, 1
sw $t5, 0($t3)

li $t1, 13
div $t2, $t1
mfhi $t0
addi $t0, $t0, 1

jal card_check
j player_turn

# Dealer hits
dealer_hit:
li $v0, 4
la $a0, dealer_hit_msg
syscall
dealer_hit_used_card:
li $s3, 1
li $v0, 42
li $a0, 0
li $a1, 52
syscall

move $t2, $a0

# Checks if a card has already been drawn
la $t3, deck
sll $t4, $t2, 2
add $t3, $t3, $t4
lw $t5, 0($t3)
bne $t5, $zero, dealer_hit_used_card

li $t5, 1
sw $t5, 0($t3)

li $t1, 13
div $t2, $t1
mfhi $t0
addi $t0, $t0, 1

jal card_check
j dealer_turn

# Player stands 
player_stand:
li $v0, 4
la $a0, player_stand_msg
syscall

j dealer_turn

# Adds value to player's hand ($s0)
add_player_hand:
li $v0, 4
la $a0, player_hand_msg
syscall
add $s0, $s0, $s4
move $a0, $s0
li $v0, 1
syscall
li $v0, 4
la $a0, new_line
syscall
addi $t8, $t8, 1
addiu $sp, $sp, -4
sw $ra, 0($sp)
jal draw_dealt_card
lw $ra, 0($sp)
addiu $sp, $sp, 4
j card_done

# Adds value to dealer's hand ($s1)
add_dealer_hand:
li $v0, 4
la $a0, dealer_hand_msg
syscall
add $s1, $s1, $s4
move $a0, $s1
li $v0, 1
syscall
li $v0, 4
la $a0, new_line
syscall
addi $t9, $t9, 1
addiu $sp, $sp, -4
sw $ra, 0($sp)
jal draw_dealt_card
lw $ra, 0($sp)
addiu $sp, $sp, 4
j card_done

# Adds ace to player's hand ($s0)
add_player_hand_ace:
addi $t8, $t8, 1
addiu $sp, $sp, -4
sw $ra, 0($sp)
jal draw_dealt_card
lw $ra, 0($sp)
addiu $sp, $sp, 4
li $v0, 4
la $a0, player_hand_msg
syscall
addi $s6, $s6, 1
add $s0, $s0, $s4
li $t0, 21
bgt $s0, $t0, check_if_player_aces
move $a0, $s0
li $v0, 1
syscall
li $v0, 4
la $a0, new_line
syscall
j card_done

# Adds ace to dealer's hand ($s1)
add_dealer_hand_ace:
addi $t9, $t9, 1
addiu $sp, $sp, -4
sw $ra, 0($sp)
jal draw_dealt_card
lw $ra, 0($sp)
addiu $sp, $sp, 4
li $v0, 4
la $a0, dealer_hand_msg
syscall
addi $s7, $s7, 1
add $s1, $s1, $s4
li $t0, 21
bgt $s1, $t0, check_if_dealer_aces
move $a0, $s1
li $v0, 1
syscall
li $v0, 4
la $a0, new_line
syscall
j card_done

# Checks if there are any aces for the player
check_if_player_aces:
li $t0, 0
bgt $s6, $t0, change_player_ace
j card_done

# Checks if there are any aces for the dealer
check_if_dealer_aces:
li $t0, 0
bgt $s7, $t0, change_dealer_ace
j card_done

# Changes player ace to 1
change_player_ace:
subi $s6, $s6, 1
subi $s0, $s0, 10
move $a0, $s0
li $v0, 1
syscall
li $v0, 4
la $a0, new_line
syscall
li $t0, 21
bgt $s0, $t0, check_if_player_aces
j card_done

# Change dealer ace to 1
change_dealer_ace:
subi $s7, $s7, 1
subi $s1, $s1, 10
move $a0, $s1
li $v0, 1
syscall
li $v0, 4
la $a0, new_line
syscall
li $t0, 21
bgt $s1, $t0, check_if_dealer_aces
j card_done

# Player busts
player_bust:
li $v0, 4
la $a0, player_bust_msg
syscall
j dealer_win

# Player blackjack
player_blackjack:
li $v0, 4
la $a0, player_blackjack_msg
syscall
j dealer_turn

# Player natural blackjack
player_natural_blackjack:
li $v0, 4
la $a0, player_blackjack_msg
syscall
j player_win

# Dealer busts
dealer_bust:
li $v0, 4
la $a0, dealer_bust_msg
syscall
j player_win

# Dealer blackjack
dealer_blackjack:
li $v0, 4
la $a0, dealer_blackjack_msg
syscall
j player_turn

# Dealer natural blackjack
dealer_natural_blackjack:
li $v0, 4
la $a0, dealer_blackjack_msg
syscall
j dealer_win

# Compares player's and dealer's hands
compare_hands:
bgt $s0, $s1, player_win
bgt $s1, $s0, dealer_win
beq $s0, $s1, tie_game

# If player wins
player_win:
li $v0, 4
la $a0, player_wins
syscall
li $v0, 10
syscall

# If dealer wins
dealer_win:
li $v0, 4
la $a0, dealer_wins
syscall
li $v0, 10
syscall

# Tie game
tie_game:
li $v0, 4
la $a0, tie_game_msg
syscall
li $v0, 10
syscall

# When dealing each card is done
card_done:
lw $ra, 0($sp)
addiu $sp, $sp, 4
jr $ra

# Draws green blackjack table
draw_table:
addiu $sp, $sp, -4
sw $ra, 0($sp)
li $t0, 0x10040000
li $t1, 65536
li $t2, 0x176B45

table_loop:
sw $t2, 0($t0)
addi $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, table_loop

# Draws dark green border for table
li $a0, 0
li $a1, 0
li $a2, 256
li $a3, 5
li $t2, 0x06452D
jal rectangle

li $a0, 0
li $a1, 251
li $a2, 256
li $a3, 5
li $t2, 0x06452D
jal rectangle

li $a0, 0
li $a1, 0
li $a2, 5
li $a3, 256
li $t2, 0x06452D
jal rectangle

li $a0, 251
li $a1, 0
li $a2, 5
li $a3, 256
li $t2, 0x06452D
jal rectangle

lw $ra, 0($sp)
addiu $sp, $sp, 4
jr $ra

# Draws dealer cards
draw_dealer_cards:
# Card 1
li $a0, 54
li $a1, 32
jal draw_card

# Card 2
li $a0, 112
li $a1, 32
jal draw_card

jr $ra

# Draw player cards
draw_player_cards:
li $a0, 36
li $a1, 126
jal draw_card

li $a0, 91
li $a1, 126
jal draw_card

li $a0, 146
li $a1, 126
jal draw_card

jr $ra

# -----------------------------------
# White playing card with dark outline
# a0 = x, a1 = y
# Card size = 42 x 60
# -----------------------------------
draw_card:
addi $sp, $sp, -16
sw $ra, 12($sp)
sw $a0, 8($sp)
sw $a1, 4($sp)

# Outline
move $t3, $a0
move $t4, $a1
li $a2, 42
li $a3, 60
li $t2, 0x102820
jal rectangle

# Inner white face
lw $a0, 8($sp)
lw $a1, 4($sp)
addi $a0, $a0, 2
addi $a1, $a1, 2
li $a2, 38
li $a3, 56
li $t2, 0xFFFFFF
jal rectangle

# Red rank/suit-like accent
lw $a0, 8($sp)
lw $a1, 4($sp)
addi $a0, $a0, 7
addi $a1, $a1, 8
li $a2, 10
li $a3, 5
li $t2, 0xC62828
jal rectangle

lw $a0, 8($sp)
lw $a1, 4($sp)
addi $a0, $a0, 12
addi $a1, $a1, 24
li $a2, 18
li $a3, 18
li $t2, 0xC62828
jal rectangle

lw $ra, 12($sp)
addi $sp, $sp, 16
jr $ra

# Rectangle drawing procedure
# a0 = x, a1 = y
# a2 = width, a3 = height
# t2 = color
rectangle:
addiu $sp, $sp, -32
sw $t8, 28($sp)
sw $t9, 24($sp)
sw $ra, 20($sp)
sw $s0, 16($sp)
sw $s1, 12($sp)
sw $s2, 8($sp)
sw $s3, 4($sp)
sw $s4, 0($sp)

move $s0, $a0
move $s1, $a1
move $s2, $a2
move $s3, $a3
move $s4, $t2

li $t5, 256
mul $t6, $s1, $t5
addu $t6, $t6, $s0
sll $t6, $t6, 2
li $t7, 0x10040000
addu $t6, $t6, $t7

move $t8, $zero

rect_row:
move $t9, $zero
move $t4, $t6

rect_col:
sw $s4, 0($t4)
addiu $t4, $t4, 4
addiu $t9, $t9, 1
blt $t9, $s2, rect_col

addiu $t6, $t6, 1024
addiu $t8, $t8, 1
blt $t8, $s3, rect_row

lw $s4, 0($sp)
lw $s3, 4($sp)
lw $s2, 8($sp)
lw $s1, 12($sp)
lw $s0, 16($sp)
lw $ra, 20($sp)
lw $t9, 24($sp)
lw $t8, 28($sp)
addiu $sp, $sp, 32
jr $ra
    
# draw_dealt_card
# $s3 = 0 player, 1 dealer
# $s4 = card point value (Ace=1, 2-10, face cards=10)
# $t8 = player card count
# $t9 = dealer card count
# Draws a card at the next available position
# Call AFTER incrementing the relevant card counter

draw_dealt_card:
addiu $sp, $sp, -32
sw $ra, 28($sp)
sw $t0, 24($sp)
sw $t1, 20($sp)
sw $t2, 16($sp)
sw $t3, 12($sp)
sw $t4, 8($sp)
sw $t5, 4($sp)
sw $t6, 0($sp)

beq $s3, $zero, draw_player_card

draw_dealer_card:
# Convert dealer card count to zero-based index
addiu $t0, $t9, -1
sll $t0, $t0, 2
la $t1, dealer_cards_x
addu $t1, $t1, $t0
lw $a0, 0($t1)

li $a1, 32
jal draw_card_rank
j draw_card_return

draw_player_card:
addiu $t0, $t8, -1
sll $t0, $t0, 2
la $t1, player_cards_x
addu $t1, $t1, $t0
lw $a0, 0($t1)

li $a1, 126
jal draw_card_rank

draw_card_return:
lw $t6, 0($sp)
lw $t5, 4($sp)
lw $t4, 8($sp)
lw $t3, 12($sp)
lw $t2, 16($sp)
lw $t1, 20($sp)
lw $t0, 24($sp)
lw $ra, 28($sp)
addiu $sp, $sp, 32
jr $ra


# draw_card_rank
# a0 = x, a1 = y
# uses last_rank (1=Ace, 2-10, 11=J, 12=Q, 13=K)
draw_card_rank:
addiu $sp, $sp, -28
sw $ra, 24($sp)
sw $a0, 20($sp)
sw $a1, 16($sp)

# Dark card outline
li $a2, 42
li $a3, 60
li $t2, 0x101010
jal rectangle

# White card interior
lw $a0, 20($sp)
lw $a1, 16($sp)
addiu $a0, $a0, 2
addiu $a1, $a1, 2
li $a2, 38
li $a3, 56
li $t2, 0xFFFFFF
jal rectangle

# Pick color from suit: red suits are red, black suits are black
lw $t0, last_red
li $t1, 0x101010
beq $t0, $zero, rk_color_done
li $t1, 0xD02030
rk_color_done:
sw $t1, 12($sp)

# Draw rank letter/number in top-left corner
lw $a0, 20($sp)
lw $a1, 16($sp)
addiu $a0, $a0, 5
addiu $a1, $a1, 5
lw $a3, 12($sp)

lw $t0, last_rank
li $t1, 10
beq $t0, $t1, rk_ten
li $a2, 10 # Ace uses glyph 10
beq $t0, 1, rk_draw_one
move $a2, $t0 # 2-9, J, Q, K: glyph index = rank
rk_draw_one:
jal draw_glyph
j rk_pip

rk_ten:
li $a2, 1 # "1"
jal draw_glyph
lw $a0, 20($sp)
lw $a1, 16($sp)
addiu $a0, $a0, 17
addiu $a1, $a1, 5
li $a2, 0 # "0"
lw $a3, 12($sp)
jal draw_glyph

rk_pip:
# Center pip
lw $a0, 20($sp)
lw $a1, 16($sp)
addiu $a0, $a0, 15
addiu $a1, $a1, 25
li $a2, 12
li $a3, 12
lw $t2, 12($sp)
jal rectangle

lw $a1, 16($sp)
lw $a0, 20($sp)
lw $ra, 24($sp)
addiu $sp, $sp, 28
jr $ra
    
# draw_glyph
# a0 = x, a1 = y, a2 = glyph index, a3 = color
# Draws a 3x5 glyph with each pixel scaled to 3x3 (9 wide, 15 tall)
draw_glyph:
addiu $sp, $sp, -24
sw $ra, 20($sp)
sw $a0, 16($sp)
sw $a1, 12($sp)
sw $a3, 8($sp)

la $t3, font
li $t4, 20 # 5 words * 4 bytes per glyph
mul $t4, $a2, $t4
addu $t3, $t3, $t4
sw $t3, 4($sp) # glyph base address

li $t0, 0 # row
gl_row:
lw $t3, 4($sp)
sll $t4, $t0, 2
addu $t3, $t3, $t4
lw $t3, 0($t3) # bits for this row
li $t1, 0 # col
gl_col:
li $t4, 2
subu $t4, $t4, $t1
srlv $t5, $t3, $t4
andi $t5, $t5, 1
beq $t5, $zero, gl_skip

lw $a0, 16($sp)
li $t4, 3
mul $t4, $t1, $t4
addu $a0, $a0, $t4

lw $a1, 12($sp)
li $t4, 3
mul $t4, $t0, $t4
addu $a1, $a1, $t4

li $a2, 3
li $a3, 3
lw $t2, 8($sp)
jal rectangle
gl_skip:
addiu $t1, $t1, 1
li $t4, 3
blt $t1, $t4, gl_col

addiu $t0, $t0, 1
li $t4, 5
blt $t0, $t4, gl_row

lw $ra, 20($sp)
addiu $sp, $sp, 24
jr $ra