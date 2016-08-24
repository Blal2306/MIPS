.data
# LABLES
Row: .asciiz "Please enter the number of rows in the matrix : "
Row_enter: .asciiz "Enter row (zero is min index) : "
Column_enter: .asciiz "Enter column (zero is min index) : "
Column: .asciiz "Please enter the number of columns : "
Element: .asciiz "Please enter the elements of the matrix\n"
Options: .asciiz "'A' FOR ADDITION, 'S' FOR SCALAR MULT, 'T' FOR TRANSPOSITION, 'L' FOR TABLE LOOKUP : "
NotValid: .asciiz "Not a valid input, try again ... \n"
Scalar: .asciiz "Enter a Scalar : "
ln: .asciiz "\n"
c: .asciiz "\t"
A_L: .asciiz "A"
S_L: .asciiz "S"
T_L: .asciiz "T"
L_L: .asciiz "L"
CHAR: .space 4 # THIS WILL BE TO READ THE INPUT

# ARRAYS
.align 2 # SIZE 4 BYTES 32 BITS
M1_A: .space 256
M2_A: .space 256

.globl main

.text
main:
	b M1 # GET THE DATA FOR THE FIRST MATRIX
M1: 
	# NENTER THE NUMBER OF COLUMNS
	li $v0, 4
	la $a0, Column
	syscall
	
	li $v0, 5
	syscall
	move $s0, $v0
	
	#ENTER THE NUMBER OF ROWS
	li $v0, 4
	la $a0, Row
	syscall
	
	li $v0, 5
	syscall
	move $s1, $v0
	
	# ENTER THE ELEMENTS
	
	# LABEL
	li $v0, 4
	la $a0, Element
	syscall
	
	
	mult $s0, $s1
	mflo $t0 # x = N of slots
	
	
	# GET THE DATA FOR THE MATRIX
	la $t2, M1_A
	LOOP:
		#GET THE NUMBER
		li $v0, 5
		syscall
		
		# PUT IT IN THE ARRAY
		sw $v0, ($t2)
		add $t2, $t2, 4 # a++
		subi $t0, $t0, 1
		bgtz  $t0, LOOP
		
	# PRINT A NEW LINE
	la $a0, ln
	li $v0, 4
	syscall
		
	# PRINT THE ANSWER
	la $t1, M1_A
	mult $s0, $s1
	mflo $t0
	
	
	LOOP2_S:
		# GET THE NUMBER
		lw $a0, ($t1)
		# PRINT IT
		li $v0, 1
		syscall
		#PRINT THE COMMA
		la $a0, c
		li $v0, 4
		syscall
		addi $t1, $t1, 4
		subi $t0, $t0, 1
		
		
		### DO WE NEED TO PRINT A NEW LINE ###
		
		# GET THE REMAINDER
		div $t0, $s0
		mfhi $t2
		bgtz $t2 ELSE_2 # IF IT IS GREATER THAN ZERO DON'T NEED A NEW LINE
			# PRINT THE LINE
			la $a0, ln
			li $v0, 4
			syscall
			
			bgtz $t0, LOOP2_S
		
		######################################
		
		
		ELSE_2:
			bgtz $t0, LOOP2_S
	# END OF THE PRINT STATEMENT
	
	b OPTIONS
		
M2:
	# NENTER THE NUMBER OF COLMNS
	li $v0, 4
	la $a0, Column
	syscall
	
	li $v0, 5
	syscall
	move $s2, $v0
	
	# ENTER THE NUMBER OF COLUMNS
	li $v0, 4
	la $a0, Row
	syscall
	
	li $v0, 5
	syscall
	move $s3, $v0
	
	# LABEL
	li $v0, 4
	la $a0, Element
	syscall
	
	mult $s0, $s1
	mflo $t0 # x = N of slots
	
	
	# GET THE DATA FOR THE MATRIX
	la $t2, M2_A
	LOOP3:
		#GET THE NUMBER
		li $v0, 5
		syscall
		
		# PUT IT IN THE ARRAY
		sw $v0, ($t2)
		add $t2, $t2, 4 # a++
		subi $t0, $t0, 1
		bgtz  $t0, LOOP3
		
	# PRINT A NEW LINE
	la $a0, ln
	li $v0, 4
	syscall
	
	# PRINT THE ANSWER
	la $t1, M2_A
	mult $s2, $s3
	mflo $t0
	
	
	LOOP3_S:
		# GET THE NUMBER
		lw $a0, ($t1)
		# PRINT IT
		li $v0, 1
		syscall
		#PRINT THE COMMA
		la $a0, c
		li $v0, 4
		syscall
		addi $t1, $t1, 4
		subi $t0, $t0, 1
		
		
		### DO WE NEED TO PRINT A NEW LINE ###
		
		# GET THE REMAINDER
		div $t0, $s2
		mfhi $t2
		bgtz $t2 ELSE_3 # IF IT IS GREATER THAN ZERO DON'T NEED A NEW LINE
			# PRINT THE LINE
			la $a0, ln
			li $v0, 4
			syscall
			
			bgtz $t0, LOOP3_S
		
		######################################
		
		
		ELSE_3:
			bgtz $t0, LOOP3_S
	# END OF THE PRINT STATEMENT
		
	b A2

OPTIONS:
	la $a0, Options
	li $v0, 4
	syscall
	
	#READ A CHARACTER
	li $v0, 8
	la $a0, CHAR
	li $a1, 4
	syscall
	
	la $t0, CHAR
	lb $t1, ($t0)
	
	# IS IT EQUAL TO A
	la $t2, A_L
	lb $t3, ($t2)
	beq $t1, $t3, A
	
	# IS IT EQUAL TO S
	la $t2, S_L
	lb $t3, ($t2)
	beq $t1, $t3, S
	
	# IS IT EQUAL TO T
	la $t2, T_L
	lb $t3, ($t2)
	beq $t1, $t3, T
	
	# IS IT EQUAL TO L
	la $t2, L_L
	lb $t3, ($t2)
	beq $t1, $t3, L
	
	# LOOP TO OPTIONS
	b OPTIONS
	
A:
	b M2
	A2:
		# ADD THE MATRICES AND PRINT THE RESULTING MATRIX #
		mult $s2, $s3
		mflo  $s4
		
		la $t0, M1_A
		la $t1, M2_A
		A2_LOOP:
		
			lw $t2, ($t0)
			lw $t3, ($t1)
		
			add $t2, $t2, $t3
			
			sw $t2, ($t0)
			addi $t0, $t0, 4
			addi $t1, $t1, 4
			
			subi $s4, $s4, 1
			
			bgtz $s4, A2_LOOP
			
	# PRINT THE ANSWER
	la $t1, M1_A
	mult $s0, $s1
	mflo $t0
	
	
	LOOP2_A:
		# GET THE NUMBER
		lw $a0, ($t1)
		# PRINT IT
		li $v0, 1
		syscall
		#PRINT THE COMMA
		la $a0, c
		li $v0, 4
		syscall
		addi $t1, $t1, 4
		subi $t0, $t0, 1
		
		
		### DO WE NEED TO PRINT A NEW LINE ###
		
		# GET THE REMAINDER
		div $t0, $s0
		mfhi $t2
		bgtz $t2 ELSE # IF IT IS GREATER THAN ZERO DON'T NEED A NEW LINE
			# PRINT THE LINE
			la $a0, ln
			li $v0, 4
			syscall
			
			bgtz $t0, LOOP2_A
		
		######################################
		
		
		ELSE:
			bgtz $t0, LOOP2_A
	# END OF THE PRINT STATEMENT
	b OPTIONS

S:
	# PRINT THE LABEL
	la $a0, Scalar
	li $v0, 4
	syscall
	
	# ENTER A SCALAR
	li $v0, 5
	syscall
	
	move $t0, $v0
	
	# MULTIPLY EVERYTHING IN M1_A WITH t0
	la $t1, M1_A
	mult $s0, $s1
	mflo $t2
	
	S_LOOP:
		lw $t3, ($t1)
		mult $t3, $t0
		mflo $t3
		
		# PUT IT BACK IT THE ARRAY
		sw $t3, ($t1)
		addi $t1, $t1, 4
		sub $t2, $t2, 1
		
		bgtz $t2 S_LOOP
	# PRINT THE ANSWER
	la $t1, M1_A
	mult $s0, $s1
	mflo $t0
	
	
	LOOP4_S:
		# GET THE NUMBER
		lw $a0, ($t1)
		# PRINT IT
		li $v0, 1
		syscall
		#PRINT THE COMMA
		la $a0, c
		li $v0, 4
		syscall
		addi $t1, $t1, 4
		subi $t0, $t0, 1
		
		
		### DO WE NEED TO PRINT A NEW LINE ###
		
		# GET THE REMAINDER
		div $t0, $s0
		mfhi $t2
		bgtz $t2 ELSE_4 # IF IT IS GREATER THAN ZERO DON'T NEED A NEW LINE
			# PRINT THE LINE
			la $a0, ln
			li $v0, 4
			syscall
			
			bgtz $t0, LOOP4_S
		
		######################################
		
		
		ELSE_4:
			bgtz $t0, LOOP4_S
	# END OF THE PRINT STATEMENT
	b OPTIONS
	
T:
	move $t0, $s0 # t0 = MAX COLUMNS
	move $t1, $s1 # t1 = MAX ROWS
	li $t2, 0 # COLUMNS = 0
	li $t3, 0 # ROWS  = 0
	
	W_C:
		W_R:
			mult $t3, $s0
			mflo $t4 # t4 = i(MAX COLUMN) 
			add $t4, $t4, $t2 # i(MAX COLUMNS) + j
			
			# GET THE VALUE
			li $t8, 4
			mult $t8, $t4
			mflo $t4
			
			la $t9, M1_A
			add $t9, $t9, $t4
			
			lw $a0, ($t9)
			# PRINT IT
			li $v0, 1
			syscall
			
			# PRINT TAB
			la $a0, c
			li $v0, 4
			syscall
			
			addi $t3, $t3, 1
			
			blt $t3, $s1, W_R
		
		#print a new line
		la $a0, ln
		li $v0, 4
		syscall
		
		li $t3, 0
		addi $t2, $t2, 1
		blt $t2, $s0, W_C
		
	#print a new line
	la $a0, ln
	li $v0, 4
	syscall	
			
	b OPTIONS

L:

L_RE:
	# GRT THE COLUMN
	la $a0, Column_enter
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	bltz $v0, NotValid_ROUTINE
	
	move $t8, $s0 # t8 = MAX NUMBER OF COLUMNS ALLOWED
	subi $t8, $t8, 1 # SUBTRACT ONE FROM IT
	bgt $v0, $t8, NotValid_ROUTINE
	
	move $t0, $v0 # t0 = COLUMN
	
	# GET THE ROW
	la $a0, Row_enter
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	bltz $v0, NotValid_ROUTINE
	
	move $t7, $s1
	subi $t7, $t7, 1
	bgt $v0, $t7, NotValid_ROUTINE
	move $t1, $v0 # t1 = ROW
	
	mult $t1, $s0
	mflo $t3
	add $t3, $t3, $t0
	
	# GET THE OBJECT AT THE LOCATION
	la $t4, M1_A
	li $t6, 4
	mult $t6, $t3
	mflo $t3
	add $t4, $t4, $t3
	
	lw $t5, 0($t4)
	move $a0, $t5
	li $v0, 1
	syscall
	
	la $a0, ln
	li $v0, 4
	syscall
	
	b OPTIONS

NotValid_ROUTINE:
	la $a0, NotValid
	li $v0, 4
	
	syscall
	
	b L_RE

