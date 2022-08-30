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
	
	.globl main
	.text	
main:
	addi $a0, $zero, 0
	addi $a1, $zero, 0
	addi $a2, $zero, 0x00ff0000
	jal draw_bitmap_box
	
	addi $a0, $zero, 11
	addi $a1, $zero, 6
	addi $a2, $zero, 0x00ffff00
	jal draw_bitmap_box
	
	addi $a0, $zero, 8
	addi $a1, $zero, 8
	addi $a2, $zero, 0x0099ff33
	jal draw_bitmap_box
	
	addi $a0, $zero, 2
	addi $a1, $zero, 3
	addi $a2, $zero, 0x00000000
	jal draw_bitmap_box

	addi $v0, $zero, 10
	syscall
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv


# Draws a 4x4 pixel box in the "Bitmap Display" tool
# $a0: row of box's upper-left corner
# $a1: column of box's upper-left corner
# $a2: colour of box

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
	
again:
	jal set_pixel

	li $t2, 0
loop_r:			# loops through and displays every column
	move $s4, $a0
	move $s5, $a1
	move $s6, $a2
	
	jal column_count
	
	move $a0, $s4
	move $a1, $s5
	move $a2, $s6
	
	jal set_pixel
	
	addi $t2, $t2, 1
	bne $t2, 3, loop_r
	jal reset

	

reset:			# adds a row to loop through loop_r again
	li $t2, 0
	
	move $s4, $a0
	move $s5, $a1
	move $s6, $a2
	
	jal row_count
	
	move $a0, $s4
	move $a1, $s5
	move $a2, $s6
	
	move $a1, $s1
	addi $s3, $s3, 1
	beq $s3, 4, exit
	b again

exit:			#stops program
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


row_count:		# add 1 to row
	addi $s4, $s4, 1
	jr $ra

column_count:		# add 1 to column
	addi $s5, $s5, 1
	jr $ra

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
