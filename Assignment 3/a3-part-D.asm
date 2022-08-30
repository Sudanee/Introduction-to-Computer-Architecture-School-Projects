# This code assumes the use of the "Bitmap Display" tool.
#
# Tool settings must be:
#   Unit Width in Pixels: 32
#   Unit Height in Pixels: 32
#   Display Width in Pixels: 512
#   Display Height in Pixels: 512
#   Based Address for display: 0x10010000 (static data)
#
# In effect, this produces a bitmap display of 16x16 pixels.


	.include "bitmap-routines.asm"

	.data
TELL_TALE:
	.word 0x12345678 0x9abcdef0	# Helps us visually detect where our part starts in .data section
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
BOX_ROW:
	.word	0x0
BOX_COLUMN:
	.word	0x0

	.eqv LETTER_a 97
	.eqv LETTER_d 100
	.eqv LETTER_w 119
	.eqv LETTER_x 120
	.eqv BOX_COLOUR 0x0099ff33
	
	.globl main
	
	.text	
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	# initialize variables
	la $t4, KEYBOARD_EVENT
	la $t0, 0xffff0000
	lb $t1, 0($t0)
	ori $t1, $t1, 0x02	
	sb $t1, 0($t0)
	la $t5, KEYBOARD_EVENT_PENDING

box:	
	addu $a0, $zero, $a0
	addu $a1, $zero, $a1
	addi $a2, $zero, 0x00ff0000
	jal draw_bitmap_box

check_for_event:
	lw $s0, 0($t5)
	beq $s0, $zero, check_for_event
	
check_letter:
	lbu $t7, 0($t4)
	beq $t7, LETTER_a, add_a
	beq $t7, LETTER_d, add_d
	beq $t7, LETTER_w, add_w
	beq $t7, LETTER_x, add_x
	b check_for_event
	



add_a:	
	subi $a1, $a1, 1
	jal reset


add_d:	
	addi $a1, $a1, 1
	jal reset
	

add_w:	
	subi $a0, $a0, 1
	jal reset
	

add_x:	
	addi $a0, $a0, 1
	jal reset
	
	
reset:
	li $t3, 0
	sw $t3, KEYBOARD_EVENT_PENDING
	jal box
	
	
	

	
	
	
	
	# Should never, *ever* arrive at this point
	# in the code.	

	addi $v0, $zero, 10

.data
    .eqv BOX_COLOUR_BLACK 0x00000000
.text

	addi $v0, $zero, BOX_COLOUR_BLACK
	syscall



# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box


#
# You can copy-and-paste some of your code from part (c)
# to provide the procedure body.
#







draw_bitmap_box:
	addi $sp, $sp, -32
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)	
	sw $s2, 12($sp)
	sw $s3, 16($sp) 
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	sw $s6, 28($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2

check_event:
	beqz $t7, again 
	

	
		
del:
	move $s4, $s0
	move $s5, $s1
	li $a2, 0x00000000
	b again
	

shift_left:
	addi $t3, $t3, 1
	move $s4, $a0
	move $s5, $a1
	move $s6, $a2

	jal column_left
	
	move $a0, $s4
	move $a1, $s5
	move $a2, $s6
	
	li $t7, 0
	b loop_r
	
shift_right:
	addi $t3, $t3, 1
	move $s4, $a0
	move $s5, $a1
	move $s6, $a2

	jal column_right
	
	move $a0, $s4
	move $a1, $s5
	move $a2, $s6
	
	li $t7, 0
	b loop_r
	
shift_up:
	addi $t3, $t3, 1
	move $s4, $a0
	move $s5, $a1
	move $s6, $a2

	jal row_up
	
	move $a0, $s4
	move $a1, $s5
	move $a2, $s6
	
	li $t7, 0
	b loop_r
	
shift_down:
	addi $t3, $t3, 1
	move $s4, $a0
	move $s5, $a1
	move $s6, $a2

	jal row_down
	
	move $a0, $s4
	move $a1, $s5
	move $a2, $s6
	
	li $t7, 0
	b loop_r
add1:
	addi $a1, $a1, 1
	b again

again:
	#jal set_pixel
	li $t6, 0

loop_r:	
	move $s4, $a0
	move $s5, $a1
	move $s6, $a2
	jal set_pixel
	jal column_right
	
	move $a0, $s4
	move $a1, $s5
	move $a2, $s6
	
	
	
	addi $t6, $t6, 1
	bne $t6, 4, loop_r
	jal reset1


reset1:	
	li $t6, 0
	
	move $s4, $a0
	move $s5, $a1
	move $s6, $a2
	
	jal row_up
	
	move $a0, $s4
	move $a1, $s5
	move $a2, $s6
	
	move $a1, $s1
	addi $s3, $s3, 1
	beq $s3, 4, return
	bnez  $t3, add1
	b again

return:
	li $s3, 0
	move $a0, $s0
	move $a1, $s1
	move $a2, $s2
	
	beq $t7, 0, exit
	lbu $t2, 0($t4)
	beq $t2, LETTER_a, shift_left
	beq $t2, LETTER_d, shift_right
	beq $t2, LETTER_w, shift_up
	beq $t2, LETTER_x, shift_down
	b exit

exit:	
	
	sw $t7, KEYBOARD_EVENT_PENDING 
	lw $s6, 28($sp)
	lw $s5, 24($sp)		
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 32
	
	
	
	
	jr $ra


row_up:
	addi $s4, $s4, 1
	jr $ra

row_down:
	subi $s4, $s4, 1
	jr $ra

column_left:
	subi $s5, $s5, 1
	jr $ra
	
column_right:
	addi $s5, $s5, 1
	jr $ra

	.kdata

	.ktext 0x80000180
#
# You can copy-and-paste some of your code from part (a)
# to provide elements of the interrupt handler.
#
__kernel_entry:
	mfc0 $k0, $13		
	andi $k1, $k0, 0x7c	
	srl  $k1, $k1, 2	
	beq $zero, $k1, __is_interrupt

__is_interrupt:
	andi $k1, $k0, 0x0100	
	bne $k1, $zero, __is_keyboard_interrupt	
	b __exit_exception

__is_keyboard_interrupt:
	la $k0, 0xffff0004
	lw $k1, 0($k0)	
	sw $k1, KEYBOARD_EVENT
	sw $k1, KEYBOARD_EVENT_PENDING
	b __exit_exception
	
	
__exit_exception:
	eret


.data

# Any additional .text area "variables" that you need can
# be added in this spot. The assembler will ensure that whatever
# directives appear here will be placed in memory following the
# data items at the top of this file.

	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


.eqv BOX_COLOUR_WHITE 0x00FFFFFF
	
