# UVic CSC 230, Fall 2020
# Assignment #1, part B

# Student name: Migdad Izzeldin
# Student number: V00955271


# Compute the reverse of the input bit sequence that must be stored
# in register $8, and the reverse must be in register $15.


.text
start:
	lw $8, testcase3   # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	addi $9, $8, 0
	

loop:	
	add $17, $17, 1
	beq $9, 0, shiftL
	and $10, $9, 1
	beq $10, 1, store1
	beq $10, 0, store0
	
	
store1:
	sll $15, $15, 1
	or $15, $15, 1
	srl $9, $9, 1
	b loop	

store0:
	sll $15, $15, 1
	or $15, $15, 0
	srl $9, $9, 1
	b loop	

count:
	li $7, 31
	sub $18, $7, $17
	li $6, 1
	b shiftL
	
shiftL:
	beq $6, 0, count
	beq $17, 31, exit
	beq $16, $18, finish
	addi $16, $16, 1
	sll $15, $15, 1
	or $15, $15, 0
	b shiftL

finish:
	sll $15, $15, 2
	b exit	
	

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE

exit:
	add $2, $0, 10
	syscall
	
	

.data

testcase1:
	.word	0x00200020    # reverse is 0x04000400

testcase2:
	.word 	0x00300020    # reverse is 0x04000c00
	
testcase3:
	.word	0x1234fedc     # reverse is 0x3b7f2c48
