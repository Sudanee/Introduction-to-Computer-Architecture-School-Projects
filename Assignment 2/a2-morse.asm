.text


main:	

# UVic CSC 230, Fall 2020
# Assignment #2

# Student name: Migdad Izzeldin
# Student number: V00955271


# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv

	## Test code that calls procedure for part A
	#jal save_our_souls

	## morse_flash test for part B
	#addi $a0, $zero, 0x37   ## dot dot dash dot
	#jal morse_flash
	
	## morse_flash test for part B
	#addi $a0, $zero, 0x37   ## dash dash dash
	#jal morse_flash
		
	## morse_flash test for part B
	# addi $a0, $zero, 0x32  	## dot dash dot
	# jal morse_flash
			
	## morse_flash test for part B
	# addi $a0, $zero, 0x11   ## dash
	# jal morse_flash	
	
	## flash_message test for part C
	#la $a0, test_buffer
	#jal flash_message
	
	## letter_to_code test for part D
	## the letter 'P' is properly encoded as 0x46. 
	#addi $a0, $zero, 'P'		
	#jal letter_to_code
	
	## letter_to_code test for part D
	## the letter 'A' is properly encoded as 0x21
	#addi $a0, $zero, 'A'
	#jal letter_to_code
	
	## letter_to_code test for part D
	## the space' is properly encoded as 0xff
	#addi $a0, $zero, ' '
	#jal letter_to_code
	
	## encode_message test for part E
	## The outcome of the procedure is here
	## immediately used by flash_message
	#la $a0, message01
	#la $a1, buffer01
	#jal encode_message
	#la $a0, buffer01
	#jal flash_message
	
	
	## Proper exit from the program.
	addi $v0, $zero, 10
	syscall
 
	
	
###########
# PROCEDURE
save_our_souls:

	la $a0, codes

	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp) # address of s	
	sw $s2, 12($sp) # address of o
	sw $s3, 16($sp) # extra space to store address of o or a 
	sw $s4, 20($sp) # extra space to store count
	
	move $s0, $a0
	
	jal find_s		
	move $s1, $a0
	move $a0, $s0
	
	jal find_o		
	move $s2, $a0
	move $a0, $s0

again:				# goes here to display s the second time
	move $s3, $s1
	move $t4, $s4
	jal find_pattern

next:	
	move $s4, $t4		# depending on current count ($t4) displays o or goes to s again or to exit 
	beq $t4, 2, again
	beq $t4, 3, exit
	move $s3, $s2
	move $t4, $s4
	jal find_pattern
	move $s4, $t4	

flash_dot:			# flashes dot (whatever $t2 is)
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	addi $s3, $s3, 1
	b find_pattern

flash_dash:			#flashes dash (whatever $t2 is)
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	addi $s3, $s3, 1
	b find_pattern
	
exit:	
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 24
	jr $31

find_pattern:			# finds dot or dash from the address from $s3 and goes to display it. If reaches 0 then counts 1
	lbu $t2, 0($s3)
	beq $t2, 0, count
	beq $t2, 46, flash_dot
	beq $t2, 45, flash_dash
	addi $s3, $s3, 1
	b find_pattern
	
count:
	addi $t4, $t4, 1
	b next

find_s:				# finds the letter s
	lbu $t3, 0($a0)  
	beq $t3, 83, return
	addi $a0, $a0, 1
	b find_s

find_o:				# finds the letter o
	lbu $t3, 0($a0)  
	beq $t3, 79, return
	addi $a0, $a0, 1
	b find_o

return:				# just return helper
	jr $ra
	
	
# PROCEDURE
morse_flash:
	
	la $t0, 0($a0)
	
	addi $sp, $sp, -16
	sw $ra, 0($sp)
	sw $s0, 4($sp) # contains original address of byte
	sw $s2, 8($sp)  # length of byte (High nybble)
	sw $s3, 12($sp) # sequence (low nybble)
	
	
	move $s0, $t0
	
	beq $s0, 0xFF, spaceflash
	
	jal find_length
	
	move $s2, $t0  
	move $t0, $s0
	jal find_sequence
	move $s3, $t0	
	
	move $t0, $s3
	move $t4, $s2

	b skip_help
	 
	
flash_dot1:			# flashes dot 
	jal seven_segment_on
	jal delay_short
	jal seven_segment_off
	jal delay_long
	sll $t0, $t0, 1
	b count_down
	b count_bits

flash_dash1:			# flashes dash
	jal seven_segment_on
	jal delay_long
	jal seven_segment_off
	jal delay_long
	sll $t0, $t0, 1
	b count_down
	b count_bits	
	
exit1:	
	lw $s3, 12($sp)
	lw $s2, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 16
	jr $ra
	
spaceflash:			# if char is space
	jal seven_segment_off
	jal delay_long
	jal delay_long
	jal delay_long
	jal exit1
	
find_sequence:		# finds the dot-dash sequence
	andi $t1, $t0, 1
	sll $t0, $t0, 28
	b return

count_down:		# count down
	subi $t4, $t4, 1
	b count_bits

find_length:		# finds length of the sequence
	andi $t1, $t0, 1
	srl $t0, $t0, 4
	b return
	
count_bits:		# from sequence counts 1 and 0 bits and flashes dot or dash
	beq $t4, 0, exit1	
	andi $t1, $t0, 0x80000000
	beq $t1, 0, flash_dot1
	beq $t1, 0x80000000, flash_dash1
	sll $t0, $t0, 1
	beqz $t0, exit1
	b count_bits

	
skip:			# from skip help execute the skip
	beq $t5, 0, count_bits
	andi $t1, $t0, 1
	sll $t0, $t0, 1
	subi $t5, $t5, 1
	b skip

skip_help:		# depending on length finds out how much we should skip
	li $t5, 4
	subu $t5, $t5, $t4
	b skip

###########
# PROCEDURE
flash_message:
	addi $sp, $sp, -8
	sw $ra, 0($sp)
	sw $s0, 4($sp) # original address of message
	
	move $s0, $a0

display:		#takes one byte from message and goes to morse flash to display it
	lbu $a0, 0($s0)
	beq $a0, 0, exit2
	jal morse_flash
	addi $s0, $s0, 1
	b display
	
	
	
exit2:	
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 8
	jr $ra	
###########
# PROCEDURE
	

letter_to_code:
	addi $sp, $sp, -24			
	sw $ra, 0($sp)				
	sw $s0, 4($sp)	# address of codes				
	sw $s1, 8($sp)	# extra space for address of codes to be used				
	sw $s3, 12($sp) # address of letter
	sw $s4, 16($sp)	# length of sequence
	sw $s5, 20($sp)	# byte thats found				
	
	la $t0, codes
	move $s0, $a0
	move $s1, $t0	
	
	jal find_letter
	
	move $s3, $t0	
	move $t0, $s3
	li $t3, 0
	
	jal find_pattern1
	
	move $s4, $t3	
	li $t5, 0
	
	jal get_length
	
	move $s5, $t5
	
	jal shift4
	
	move $t0, $s3
	addi $t0, $t0, 1
	li $s3, 0
	
	jal add_pattern
	jal get_result

		
exit3:	
	move $v0, $s5	# moves final answer to $v0
	lw $s5, 20($sp)
	lw $s4, 16($sp)
	lw $s3, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 24
	jr $ra	

get_result:		# adds the high nybble and low nybble that was found together 
	add $s5, $s5, $s3
	b return


find_letter:		# finds letter address in codes
	lbu $t3, 0($t0)
	beq $t3, 32, space
	beq $t3, $s0, return
	addi $t0, $t0, 1
	b find_letter
	
space:			# special case if letter is space
	li $s5, 0xFF
	b exit3
	

find_pattern1:		# counts every dot and dash to get the length (high nybble)
	lbu $t2, 0($t0)
	beq $t2, 46, count1
	beq $t2, 45, count1
	beq $t2, 0, return
	addi $t0, $t0, 1
	b find_pattern1

add_pattern:		# gets the low nybble
	lbu $t2, 0($t0)
	beq $s4, 1, last
	beq $t2, 46, shift
	beq $t2, 45, flip
	addi $t0, $t0, 1
	subi $s4, $s4, 1
	b add_pattern
	

last:			# if length is 1 indicates that $t2 is the last dash or dot
	beq $t2, 45, fliplast
	b return

fliplast:		# if last pattern is a dash we flip the last bit 0 to 1 without shifting
	or $s3, $s3, 1
	b return
	
get_length:		# turns legnth into first part of byte
	beq $t3, 0, return
	addi $t5, $t5, 0x00000001
	subi $t3, $t3, 1
	b get_length


count1:			# count to get the length
	addi $t3, $t3, 1
	addi $t0, $t0, 1
	b find_pattern1
	
flip:			# if $t2 is a dash flips 0 to 1 the shifts to left 
	or $s3, $s3, 1
	sll $s3, $s3, 1
	addi $t0, $t0, 1
	subi $s4, $s4, 1
	b add_pattern

shift:			# if $t2 is a dot shifts 0 to left
	sll $s3, $s3, 1
	addi $t0, $t0, 1
	subi $s4, $s4, 1
	b add_pattern

shift4:			# shifts the high nybble to left
	sll $s5, $s5, 4
	b return
	



###########
# PROCEDURE
encode_message:

	addi $sp, $sp, -12			
	sw $ra, 0($sp)				
	sw $s0, 4($sp)	# original address of message				
	sw $s1, 8($sp)	# address of buffer			
	
	move $s0, $a0
	move $s1, $a1
	
	
loop:			# finds every letter and calls letter_to_code to convert it to one byte then stores it into buffer to later be flashed
	lbu $a0, 0($s0)
	beq $a0, 0, exit4
	jal letter_to_code
	sb $v0, 0($s1)
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	b loop
	
	
	
	
exit4:	
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra
	
	
	

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

#############################################
# DO NOT MODIFY ANY OF THE CODE / LINES BELOW

###########
# PROCEDURE
seven_segment_on:
	la $t1, 0xffff0010     # location of bits for right digit
	addi $t2, $zero, 0xff  # All bits in byte are set, turning on all segments
	sb $t2, 0($t1)         # "Make it so!"
	jr $31


###########
# PROCEDURE
seven_segment_off:
	la $t1, 0xffff0010	# location of bits for right digit
	sb $zero, 0($t1)	# All bits in byte are unset, turning off all segments
	jr $31			# "Make it so!"
	

###########
# PROCEDURE
delay_long:
	add $sp, $sp, -4	# Reserve 
	sw $a0, 0($sp)
	addi $a0, $zero, 600
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31

	
###########
# PROCEDURE			
delay_short:
	add $sp, $sp, -4
	sw $a0, 0($sp)
	addi $a0, $zero, 200
	addi $v0, $zero, 32
	syscall
	lw $a0, 0($sp)
	add $sp, $sp, 4
	jr $31




#############
# DATA MEMORY
.data
codes:
	.byte 'A', '.', '-', 0, 0, 0, 0, 0
	.byte 'B', '-', '.', '.', '.', 0, 0, 0
	.byte 'C', '-', '.', '-', '.', 0, 0, 0
	.byte 'D', '-', '.', '.', 0, 0, 0, 0
	.byte 'E', '.', 0, 0, 0, 0, 0, 0
	.byte 'F', '.', '.', '-', '.', 0, 0, 0
	.byte 'G', '-', '-', '.', 0, 0, 0, 0
	.byte 'H', '.', '.', '.', '.', 0, 0, 0
	.byte 'I', '.', '.', 0, 0, 0, 0, 0
	.byte 'J', '.', '-', '-', '-', 0, 0, 0
	.byte 'K', '-', '.', '-', 0, 0, 0, 0
	.byte 'L', '.', '-', '.', '.', 0, 0, 0
	.byte 'M', '-', '-', 0, 0, 0, 0, 0
	.byte 'N', '-', '.', 0, 0, 0, 0, 0
	.byte 'O', '-', '-', '-', 0, 0, 0, 0
	.byte 'P', '.', '-', '-', '.', 0, 0, 0
	.byte 'Q', '-', '-', '.', '-', 0, 0, 0
	.byte 'R', '.', '-', '.', 0, 0, 0, 0
	.byte 'S', '.', '.', '.', 0, 0, 0, 0
	.byte 'T', '-', 0, 0, 0, 0, 0, 0
	.byte 'U', '.', '.', '-', 0, 0, 0, 0
	.byte 'V', '.', '.', '.', '-', 0, 0, 0
	.byte 'W', '.', '-', '-', 0, 0, 0, 0
	.byte 'X', '-', '.', '.', '-', 0, 0, 0
	.byte 'Y', '-', '.', '-', '-', 0, 0, 0
	.byte 'Z', '-', '-', '.', '.', 0, 0, 0
	
message01:	.asciiz "A A A"
message02:	.asciiz "SOS"
message03:	.asciiz "WATERLOO"
message04:	.asciiz "DANCING QUEEN"
message05:	.asciiz "CHIQUITITA"
message06:	.asciiz "THE WINNER TAKES IT ALL"
message07:	.asciiz "MAMMA MIA"
message08:	.asciiz "TAKE A CHANCE ON ME"
message09:	.asciiz "KNOWING ME KNOWING YOU"
message10:	.asciiz "FERNANDO"

buffer01:	.space 128
buffer02:	.space 128
test_buffer:	.byte 0x30 0x37 0x30 0x00    # This is SOS
