# Computer n! recursively in MIPS
# Based on the example in Appendix A
# In fact it is almost identical
     .text

main:
	# SPACE FOR 32 BYTES
	addi	$sp,$sp,-32
	# 20 - 24 = RETURN ADDRESS
	sw	$ra,20($sp)	
	# 16 - 20 = OLD FRAME REFERENCE	
	sw	$fp,16($sp)
	# -32 + 28 = -4 = FRAME POINTER
	addi	$fp,$sp,28		# Set up frame pointer

	# FACT (a0) --- N
	li	$a0,3			# Put argument (10) in $a0
	jal	fact			# Call factorial function

	# PRINT THE RESULTS
	add	$a0, $v0, $zero		# Load sum of inupt numbers into $a0
	li	$v0, 1			# Load 1=print_int into $v0
	syscall				# Output the prompt via syscall

	# Remove Stack Frame
	lw	$ra,20($sp)		# Restore return address
	lw	$fp,16($sp)		# Restore frame pointer
	addi	$sp,$sp,32		# Pop stack frame

# Exit
	li	$v0, 10			# exit
	syscall



fact:
	
	addi	$sp, $sp, -32		
	sw	$ra,20($sp)		# Save return address
	sw	$fp,16($sp)		# Save frame pointer
	addi	$fp,$sp,28		# Set up frame pointer
		
	# fp = N
	sw	$a0,0($fp)		# Save argument (n)

	# N > 0
	lw	$v0,0($fp)		# Load n
	bgtz	$v0,L2			# Branch if n > 0
	
	# BASE CASE
	li	$v0,1			# Return 1 if n = 0
	j	L1			# Jump to code to return

# Compute (n-1)!
L2:
	lw	$v1,0($fp)		# Load n
	addi	$v0,$v1,-1		# Compute n - 1
	move	$a0,$v0			# a0 = v0 = N -1
	jal	fact			# Call factorial function
	
	
	# AFTER THE BASE CASE IS EXECUTED, RUNNING WILL CONTINUE HERE 
	lw	$v1,0($fp)		# Load n
	mul	$v0,$v0,$v1		# Compute (n-1)*n = n!


L1:					# Result is in $v0
	lw	$ra, 20($sp)		# Restore $ra
	lw	$fp, 16($sp)		# Restore $fp
	addiu	$sp, $sp, 32		# Pop stack
	jr	$ra			# Return to caller
