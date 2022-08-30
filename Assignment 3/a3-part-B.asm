	.data
KEYBOARD_EVENT_PENDING:
	.word	0x0
KEYBOARD_EVENT:
	.word   0x0
KEYBOARD_COUNTS:
	.space  128
NEWLINE:
	.asciiz "\n"
SPACE:
	.asciiz " "
	
	
	.eqv 	LETTER_a 97
	.eqv	LETTER_b 98
	.eqv	LETTER_c 99
	.eqv 	LETTER_D 100
	.eqv 	LETTER_space 32
	
	
	.text  
main:
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	la $t4, KEYBOARD_EVENT
	la $t0, 0xffff0000
	lb $t1, 0($t0)
	ori $t1, $t1, 0x02	
	sb $t1, 0($t0)
	la $t5, KEYBOARD_EVENT_PENDING

check_for_event:		# waits for key press
	lw $s0, 0($t5)
	beq $s0, $zero, check_for_event
		
check_letter:			# checks what letter is keyboard event 
	lbu $t2, 0($t4)
	beq $t2, LETTER_a, add_a
	beq $t2, LETTER_b, add_b
	beq $t2, LETTER_c, add_c
	beq $t2, LETTER_D, add_d
	beq $t2, LETTER_space, end
	b check_for_event
	
add_a:			# a counter
	addi $s3, $s3, 1
	jal reset
	b check_for_event

add_b:			# b counter
	addi $s4, $s4, 1
	jal reset
	b check_for_event

add_c:			# c counter
	addi $s5, $s5, 1
	jal reset
	b check_for_event

add_d:			# d counter
	addi $s6, $s6, 1
	jal reset
	b check_for_event
	
reset:			# resets pending to wait for key press
	li $t7, 0
	sw $t7, KEYBOARD_EVENT_PENDING
	jr $ra
	
end:			# prints everything
	li $v0, 0
	move $a0, $s3
	li $v0, 1
	syscall

	li $v0, 0
	la $a0, SPACE		
	li $v0, 4
	syscall

	li $v0, 0
	move $a0, $s4
	li $v0, 1
	syscall
	
	li $v0, 0
	la $a0, SPACE		
	li $v0, 4
	syscall
	
	li $v0, 0
	move $a0, $s5
	li $v0, 1
	syscall
	
	li $v0, 0
	la $a0, SPACE		
	li $v0, 4
	syscall
	
	li $v0, 0
	move $a0, $s6
	li $v0, 1
	syscall
	
	li $v0, 0
	la $a0, NEWLINE		
	li $v0, 4
	syscall
	

	


	
	.kdata

	.ktext 0x80000180
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
	
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

	
