# $s0 ------> A[] - Address of Array
# $t0 ------> Addres of A[i]
# $t1 ------> i
# $t2 ------> j
# $t3 ------> tempVar for integer input
# $t8 ------> size Of Array

.data
	# myArray is an array of 6 integers
	# The size of the space is given by n * 4
	# Where n is size of array and 4 is the number of bytes per index
	myArray: .space 24 		# 6 intgers * 4 bytes
	Testing: .asciiz "Jumped to Function! \n" #Sets up a string
	
.text
.globl	main
main:
	li	$t8, 6				# myArray size = 6
	li	$t1, 0				# i = 0
	
	Loop:
		la		$s0, myArray	# Loads address of myArray into $s0
		
		# Shift logical left by 2
		sll		$t0, $t1, 2	#  i * 4 bytes
		
		add		$t0, $s0, $t0	# add n*4 bytes to address of array
							# $t0 stores address of myArrray[i]
		
		li		$v0, 5		# 5 = opcode to read int from keyboard
							# stores int in $v0
		syscall				# Systemcall of prior instruction
							# Read int in from keyboard
						
		move	$t3, $v0	# move int from input to #$t1
			
		sw		$t3, 0($t0)	# Store int from input into myArray[i]
		
		#Code to test the contents of $t0		
		#move 	$a0, $t3
		#li	$v0, 1
		#syscall
	
		addi	$t1, $t1, 1		# i++ counter for loop to read integers
		beq		$t1, 6, FindSecLrg	# Check if $t8 == 6, if so then jumps to SecondLargest
		j		Loop
		
	FindSecLrg:
		# $s0 -----> A[0] Address of Array
		# $t1 -----> i
		# $t2 -----> j
		# $t3 -----> address of myArray[i]
		# $t4 -----> address of myArray[j]
		# $t5 -----> tempVar1 Value of myArray[i]
		# $t6 -----> tempVar2 Value of myArray[j]
		# $t7 -----> First Largest
		# $t8 -----> Second Largest
		# $t9 -----> Check Equality Flag
		
		la		$s0, myArray		# Loads address of myArray[0] into $t3
		li		$t1, 0			# set i = 0
		li		$t2, 1			# set j = 1
		
		sll		$t3, $t1, 2		# calculate address shift
		add		$t3, $t3, $s0	# address of myArray[0]
		
		sll		$t4, $t2, 2		# i * 4 bytes
		add		$t4, $t4, $s0	# myArrray[1] address
						
		lw		$t5, 0($t3)		# Load contents of A[0] in to $t5
		lw		$t6, 0($t4)		# Load contents of A[1] in to $t6
		
			# if A[0] > A[1]
			# largest $t2 = A[0]
			# seclargest $t3 = A[1]
			# else
			# largest $t2 = A[1]
			# seclargest $t3 = A[0]
												
		# if A[0] is greater then A[1]
		sgt		$t9, $t5, $t6	
		beq		$t9, $zero, Else
		move	$t7, $t5		# First Largest  = A[0]
		move	$t8, $t6		# Second Largest =A[i]
		addi	$t2, $t2, 1		# j++
		j	SecLargestLoop
	
		Else:
			move	$t7, $t6	# First Largest = myArrray[1]
			move	$t8, $t5	# Second Largest = myArray[0]
			addi	$t2, $t2, 1	# j++

		
		SecLargestLoop:
			sll		$t4, $t2, 2		# j * 4 bytes
			add		$t4, $t4, $s0	# myArrray[j] address
			lw		$t6, 0($t4)		# Load contents of A[j] in to $t6
			
			# if $t7 is less than $t6, then move $t7 to $t8 and
			# $t7 = $t6
			sgt		$t9, $t7, $t6
			beq		$t9, $zero, Swap
			
			j	Continue
			
			# A[0] is less than A[1]
			Swap:
				move	$t8, $t7	# First Largest = myArrray[1]
				move	$t7, $t6	# Second Largest = myArray[0]
				addi	$t2, $t2, 1	# j++
				beq	$t2, 6, PrintSecondLargest
				j 	SecLargestLoop
			
			Continue:
				addi	$t2, $t2, 1	# j++
				beq		$t2, 6, PrintSecondLargest	#if $t2 == 6 get out loop
				j		SecLargestLoop
			
		PrintSecondLargest:
			# Code to print out second largest
			move 	$a0, $t8
			li		$v0, 1
			syscall

	Exit:
        li		$v0, 10	  #exit code
        syscall
