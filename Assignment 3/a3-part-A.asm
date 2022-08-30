
	.data
ARRAY_A:
	.word	21, 210, 49, 4
ARRAY_B:
	.word	21, -314159, 0x1000, 0x7fffffff, 3, 1, 4, 1, 5, 9, 2
ARRAY_Z:
	.space	28
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
		
	
	.text  
main:	
	la $a0, ARRAY_A
	addi $a1, $zero, 4
	jal dump_array
	
	la $a0, ARRAY_B
	addi $a1, $zero, 11
	jal dump_array
	
	la $a0, ARRAY_Z
	lw $t0, 0($a0)
	addi $t0, $t0, 1
	sw $t0, 0($a0)
	addi $a1, $zero, 9
	jal dump_array
		
	addi $v0, $zero, 10
	syscall

# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	
	
dump_array:
	
	addi $sp, $sp, -28
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)	
	sw $s2, 12($sp)
	sw $s3, 16($sp) 
	sw $s4, 20($sp)
	sw $s5, 24($sp)
	
	move $s0, $a0	#copy of array address
	move $s1, $a1	#copy of legnth of array
	li $t3, 0

find_num:		#loops through array 
	beq $s5, $s1, finish
	lw $s4, 0($s0)
	jal print_num
	jal print_space
	addi $s0, $s0, 4
	addi $s5, $s5, 1
	b find_num

finish:
	jal print_newline
	
	lw $s5, 24($sp)		
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 28
	jr $ra
	
print_space:		#prints a space
	li $v0, 0
	la $a0, SPACE		
	li $v0, 4
	syscall
	jr $ra

print_newline:		#prints \n
	li $v0, 0
	la $a0, NEWLINE		
	li $v0, 4
	syscall
	jr $ra

print_num:		#print specified number
	li $v0, 0
	move $a0, $s4
	li $v0, 1
	syscall
	jr $ra
	
		
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE
