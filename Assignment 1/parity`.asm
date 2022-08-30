# UVic CSC 230, Fall 2020
# Assignment #1, part A

# Student name: Migdad Izzeldin
# Student number: V00955271


# Compute odd parity of word that must be in register $8
# Value of odd parity (0 or 1) must be in register $15


.text

start:
	lw $8, testcase1  # STUDENTS MAY MODIFY THE TESTCASE GIVEN IN THIS LINE
	
# STUDENTS MAY MODIFY CODE BELOW
# vvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
	addi $9, $8, 0

count_bits:	
	andi $16, $9, 1
	add $17, $17, $16
	srl $9, $9, 1
	beqz $9, add0
	b count_bits

add0:
	and $18, $17, 1
	beq $18, 1, add1
	addi $14 ,$8, 0
	add $15, $18, 0
	li $8, 0
	add $8, $8, $14
	b exit
	
add1:
	add $15, $18, 0
	add $8, $8, $14
	addi $14, $8, 1
	b exit

# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
# STUDENTS MAY MODIFY CODE ABOVE


exit:
	add $2, $0, 10
	syscall
		

.data

testcase1:
	.word	0x00200020    # odd parity is 1

testcase2:
	.word 	0x00300020    # odd parity is 0
	
testcase3:
	.word  0x1234fedc     # odd parity is 0

