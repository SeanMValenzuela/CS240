.data
slot_reels: .word 0, 0, 0
enter_balance_msg: .asciiz "How much would you like to put in? "
current_balance_msg: .asciiz "Your current balance: "
ask_wager_msg: .asciiz "Enter your wager: "
win_msg: .asciiz "You win!\n"
invalid_wager_msg: .asciiz "Invalid wager, try again.\n"
invalid_balance_msg: .asciiz "Invalid balance, try again.\n"
spin_machine_prompt: .asciiz "Enter 1 to spin machine, 0 to walk away: "
invalid_spin_machine_enter: .asciiz "Invalid action, try again.\n"
final_balance_total_msg: .asciiz "Your final balance: "
no_win_msg: .asciiz "No win, better luck next time!\n"
bankrupt_msg: .asciiz "You have no balance left, come again soon!\n"
reel_separator: .asciiz " | "
new_line: .asciiz "\n"

.align 2
# Palette of colors to design GUI
palette:
.word 0xFFFFFF   # white
.word 0xFFD700   # gold
.word 0xB8860B   # dark gold
.word 0xE02020   # cherry red
.word 0x2E8B2E   # stem green
.word 0xFFE14D   # bell yellow
.word 0xFFF3B0   # highlight
.word 0x5A3A1A   # brown
.word 0x103010   # background (dark green)
.word 0x000000   # black
.word 0x00C000   # win banner
.word 0xC00000   # lose banner
.word 0x606060   # neutral gray
.word 0x202020   # reel border

reel_x:      .word 4, 24, 44
sprite_table: .word seven, cherry, bell

# 12x12 sprites
seven:
.byte 0,2,2,2,2,2,2,2,2,2,2,0
.byte 0,2,1,1,1,1,1,1,1,1,2,0
.byte 0,2,1,1,1,1,1,1,1,1,2,0
.byte 0,2,2,2,2,2,2,1,1,1,2,0
.byte 0,0,0,0,0,0,2,1,1,2,0,0
.byte 0,0,0,0,0,2,1,1,2,0,0,0
.byte 0,0,0,0,0,2,1,1,2,0,0,0
.byte 0,0,0,0,2,1,1,2,0,0,0,0
.byte 0,0,0,0,2,1,1,2,0,0,0,0
.byte 0,0,0,2,1,1,2,0,0,0,0,0
.byte 0,0,0,2,1,1,2,0,0,0,0,0
.byte 0,0,0,0,2,2,0,0,0,0,0,0

cherry:
.byte 0,0,0,0,0,0,0,4,4,4,0,0
.byte 0,0,0,0,0,0,4,4,0,0,0,0
.byte 0,0,0,0,0,4,0,4,0,0,0,0
.byte 0,0,0,0,4,0,0,0,4,0,0,0
.byte 0,0,0,4,0,0,0,0,0,4,0,0
.byte 0,0,0,4,0,0,0,0,0,4,0,0
.byte 0,3,3,3,0,0,0,0,3,3,3,0
.byte 3,3,6,3,3,0,0,3,3,6,3,3
.byte 3,3,3,3,3,0,0,3,3,3,3,3
.byte 3,3,3,3,3,0,0,3,3,3,3,3
.byte 0,3,3,3,0,0,0,0,3,3,3,0
.byte 0,0,0,0,0,0,0,0,0,0,0,0

bell:
.byte 0,0,0,0,0,2,2,0,0,0,0,0
.byte 0,0,0,0,2,5,5,2,0,0,0,0
.byte 0,0,0,2,5,6,5,5,2,0,0,0
.byte 0,0,0,2,5,6,5,5,2,0,0,0
.byte 0,0,2,5,5,5,5,5,5,2,0,0
.byte 0,0,2,5,5,5,5,5,5,2,0,0
.byte 0,0,2,5,5,5,5,5,5,2,0,0
.byte 0,2,5,5,5,5,5,5,5,5,2,0
.byte 0,2,5,5,5,5,5,5,5,5,2,0
.byte 2,2,2,2,2,2,2,2,2,2,2,2
.byte 0,0,0,0,2,7,7,2,0,0,0,0
.byte 0,0,0,0,0,7,7,0,0,0,0,0

.text
.globl main

main:
jal init_screen

# Asks user how much they want to put into the machine
enter_balance:
li $v0, 4
la $a0, enter_balance_msg
syscall

li $v0, 5
syscall

move $s0, $v0              # $s0 -> balance

blt $s0, $zero, invalid_balance
beq $s0, $zero, bankrupt

li $v0, 4
la $a0, new_line
syscall

j ask_wager

invalid_balance:
li $v0, 4
la $a0, invalid_balance_msg
syscall

li $v0, 4
la $a0, new_line
syscall

j enter_balance

# Asks user how much they want to wager
ask_wager:
beq $s0, $zero, bankrupt

li $v0, 4
la $a0, current_balance_msg
syscall

move $a0, $s0
li $v0, 1
syscall

li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, ask_wager_msg
syscall

li $v0, 5
syscall

move $s1, $v0              # $s1 -> wager

ble $s1, $zero, invalid_wager
bgt $s1, $s0, invalid_wager

li $v0, 4
la $a0, new_line
syscall

j spin_machine_ask

invalid_wager:
li $v0, 4
la $a0, invalid_wager_msg
syscall

li $v0, 4
la $a0, new_line
syscall

j ask_wager

# Prompts user to spin machine
spin_machine_ask:
li $v0, 4
la $a0, spin_machine_prompt
syscall

li $v0, 5
syscall

move $t0, $v0

li $t1, 1
beq $t1, $t0, spin_machine

li $t1, 0
beq $t1, $t0, walk_away

j invalid_spin_machine_ask

invalid_spin_machine_ask:
li $v0, 4
la $a0, invalid_spin_machine_enter
syscall

j spin_machine_ask

# When user decides to spin the machine
spin_machine:
sub $s0, $s0, $s1

# Reset banner to neutral gray
li $a0, 12
jal draw_banner

# Spin animation: 10 frames
li $s2, 0
anim_loop:
bge $s2, 10, anim_done
li $s3, 0
anim_reel:
bge $s3, 3, anim_wait
li $v0, 42
li $a0, 0
li $a1, 3
syscall
move $a1, $a0 # symbol
move $a0, $s3 # reel index
jal draw_reel
addi $s3, $s3, 1
j anim_reel
anim_wait:
li $v0, 32  # sleep
li $a0, 80
syscall
addi $s2, $s2, 1
j anim_loop
anim_done:

# Roll final result into slot_reels
li $s5, 0
roll_loop:
bge $s5, 3, roll_done
li $v0, 42
li $a0, 0
li $a1, 3
syscall
la $t0, slot_reels
sll $t1, $s5, 2
add $t0, $t0, $t1
sw $a0, 0($t0)
addi $s5, $s5, 1
j roll_loop
roll_done:

# Draw final reels
li $s5, 0
show_loop:
bge $s5, 3, show_done
la $t0, slot_reels
sll $t1, $s5, 2
add $t0, $t0, $t1
lw $a1, 0($t0)
move $a0, $s5
jal draw_reel
addi $s5, $s5, 1
j show_loop
show_done:

# Load results
la $t0, slot_reels
lw $s2, 0($t0)
lw $s3, 4($t0)
lw $s4, 8($t0)

# Print reels to console
move $a0, $s2
li $v0, 1
syscall

li $v0, 4
la $a0, reel_separator
syscall

move $a0, $s3
li $v0, 1
syscall

li $v0, 4
la $a0, reel_separator
syscall

move $a0, $s4
li $v0, 1
syscall

li $v0, 4
la $a0, new_line
syscall

bne $s2, $s3, no_win
bne $s3, $s4, no_win

# Win
li $a0, 10
jal draw_banner

li $v0, 4
la $a0, win_msg
syscall

sll $t1, $s1, 3  # return 8x the wager
add $s0, $s0, $t1

j ask_wager

# When user decides to walk away
walk_away:
li $v0, 4
la $a0, new_line
syscall

li $v0, 4
la $a0, final_balance_total_msg
syscall

move $a0, $s0
li $v0, 1
syscall

li $v0, 4
la $a0, new_line
syscall

li $v0, 10
syscall

# When user has no money in balance
bankrupt:
li $v0, 4
la $a0, bankrupt_msg
syscall

li $v0, 10
syscall

# No win
no_win:
li $a0, 11
jal draw_banner

li $v0, 4
la $a0, no_win_msg
syscall

j ask_wager

# Graphics routines (64x64 unit grid at $gp)
# fill_rect: $a0=x, $a1=y, $a2=width, $a3=height, $v1=palette index
fill_rect:
la $t0, palette
sll $t1, $v1, 2
add $t0, $t0, $t1
lw $t0, 0($t0) # color value
move $t1, $a1 # current y
add $t2, $a1, $a3 # end y
fr_row:
bge $t1, $t2, fr_done
move $t3, $a0 # current x
add $t4, $a0, $a2 # end x
fr_col:
bge $t3, $t4, fr_next
sll $t5, $t1, 6 # y * 64
add $t5, $t5, $t3
sll $t5, $t5, 2
add $t5, $t5, $gp
sw $t0, 0($t5)
addi $t3, $t3, 1
j fr_col
fr_next:
addi $t1, $t1, 1
j fr_row
fr_done:
jr $ra

# draw_sprite: $a0=sprite address, $a1=x, $a2=y (12x12 bytes)
draw_sprite:
la $t0, palette
li $t1, 0 # row
ds_row:
bge $t1, 12, ds_done
li $t2, 0 # col
ds_col:
bge $t2, 12, ds_next
lbu $t3, 0($a0)
addi $a0, $a0, 1
sll $t3, $t3, 2
add $t3, $t3, $t0
lw $t3, 0($t3) # color
add $t4, $a2, $t1
sll $t4, $t4, 6
add $t4, $t4, $a1
add $t4, $t4, $t2
sll $t4, $t4, 2
add $t4, $t4, $gp
sw $t3, 0($t4)
addi $t2, $t2, 1
j ds_col
ds_next:
addi $t1, $t1, 1
j ds_row
ds_done:
jr $ra

# draw_reel: $a0=reel index (0-2), $a1=symbol (0-2)
draw_reel:
addi $sp, $sp, -12
sw $ra, 0($sp)
sw $s6, 4($sp)
sw $s7, 8($sp)

la $t0, reel_x
sll $t1, $a0, 2
add $t0, $t0, $t1
lw $s6, 0($t0) # reel x

la $t0, sprite_table
sll $t1, $a1, 2
add $t0, $t0, $t1
lw $s7, 0($t0) # sprite address

# Border
move $a0, $s6
li $a1, 20
li $a2, 16
li $a3, 16
li $v1, 13
jal fill_rect

# White inside
addi $a0, $s6, 1
li $a1, 21
li $a2, 14
li $a3, 14
li $v1, 0
jal fill_rect

# Sprite
move $a0, $s7
addi $a1, $s6, 2
li $a2, 22
jal draw_sprite

lw $ra, 0($sp)
lw $s6, 4($sp)
lw $s7, 8($sp)
addi $sp, $sp, 12
jr $ra

# draw_banner: $a0 = palette index for banner color
draw_banner:
addi $sp, $sp, -4
sw $ra, 0($sp)

move $v1, $a0
li $a0, 4
li $a1, 42
li $a2, 56
li $a3, 6
jal fill_rect

lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra

# init_screen: background, title bar, machine body, starting reels (7 7 7)
init_screen:
addi $sp, $sp, -4
sw $ra, 0($sp)

# Background
li $a0, 0
li $a1, 0
li $a2, 64
li $a3, 64
li $v1, 8
jal fill_rect

# Title bar (gold with dark border)
li $a0, 3
li $a1, 5
li $a2, 58
li $a3, 8
li $v1, 2
jal fill_rect

li $a0, 4
li $a1, 6
li $a2, 56
li $a3, 6
li $v1, 1
jal fill_rect

# Machine body behind reels
li $a0, 2
li $a1, 18
li $a2, 60
li $a3, 20
li $v1, 12
jal fill_rect

# Banner (neutral)
li $a0, 12
jal draw_banner

# Initial reels
li $s5, 0
init_reels:
bge $s5, 3, init_done
move $a0, $s5
li $a1, 0
jal draw_reel
addi $s5, $s5, 1
j init_reels
init_done:
lw $ra, 0($sp)
addi $sp, $sp, 4
jr $ra