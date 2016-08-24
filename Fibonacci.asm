## CSE 220 
##
## Fibonacci

###########################################
#					  #
# The text segment -- the instructions    #
#					  #
###########################################
##
## Registers used:
##
## $s0 holds the running sum total of Fibonacci elements
## $s1 is used to hold addresses of various terms in the Fibonacci "array"
## $s3 hold the index of the F element we are working on, which at the end will be
##     the highest index for which F was calculated when overflow occurred in $s0
##

	.text
	.globl main
main:
	li $s0, 3              # $s0 will hold the running sum of Fibannaci terms
	la $s1, F              # pointer into F "array" -- points to F(1)
	li $s3, 3              # already have up to element F(3)

loop1:	addi $s3, $s3, 1       # update element index n of F(n)

	lw   $t0,  ($s1)       # load value of F(n-3)
	lw   $t1, 4($s1)       # load value of F(n-2)
	add  $t0, $t0, $t1     # F(n) = calculate F(n-1) + F(n-2)
	
	sw   $t0, 12($s1)       # store F(n) into the F "array"
	
	addi $s1, $s1, 4       # update pointer in F "array" for next time round loop1
	addu $s0, $s0, $t0     # add F(n) to running total in $s0
	bgtz $s0, loop1        # check for overflow in running total $s0
	
	la   $a0, enter2       # print "overflow occurred when ..." message
	li   $v0, 4
	syscall
	move $a0, $s3          # print highest index n reached
	li   $v0, 1
	syscall
	la   $a0, newln        # print newlines
	li   $v0, 4
	syscall

loop2:  la   $a0, enter1       # prompt user with "Which element of the series do you want?"
	li   $v0, 4
	syscall
	li   $v0, 5            # read user input, j
	syscall
	blez $v0, exit         # exit if j <= 0
	bgt  $v0, $s3, nogood  # no good if j > largest n reached
	addi $v0, $v0, -1      # calculate displacement (j -1)*4
	sll  $v0, $v0, 2
	la   $s1, F
	add  $s1, $s1, $v0     # address of F(j)
	lw   $a0, ($s1)        # load value of F(j)
	li   $v0, 1            # print it
	syscall
	la   $a0, newln        # print newlines
	li   $v0, 4
	syscall
	b loop2                # go prompt user again

nogood: la   $a0, enter3       # print "too far" message
	li   $v0, 4
	syscall
	b loop2                # go prompt user again

exit:	li, $v0, 10	       # end program 	
	syscall 

#####################
# The data segment  #
#####################
.data

enter1: .asciiz "Which element of the series do you want? \n"
enter2: .asciiz "Overflow occurred when adding element "
enter3: .asciiz "\n Sorry! I did not get that far.\n\n"
newln:  .asciiz "\n\n"
F: .word 1,1, 1
   .space 300