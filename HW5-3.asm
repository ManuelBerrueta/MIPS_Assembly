# Quicksort

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
	myArray: .space 28 		# 7 intgers * 4 bytes
	
.text
.globl	main
main:
	li	$t8, 7				# myArray size = 6
	li	$t1, 0				# i = 0
	
	readNumLoop:
		la		$s0, myArray	# Loads address of myArray into $s0
		
		# Shift logical left by 2
		sll		$t0, $t1, 2	    #  i * 4 bytes where t1 represnts i
		
		add		$t0, $s0, $t0	# add n*4 bytes to address of array
							    # $t0 stores address of myArrray[i]
		
		li		$v0, 5		# 5 = opcode to read int from keyboard
							# stores int in $v0
		syscall				# Systemcall of prior instruction
							# Read int in from keyboard
						
		move	$t3, $v0	# move int from input to #$t1
			
		sw		$t3, 0($t0)	# Store int from input into myArray[i]
		
		#Code to test the contents of array at myArray[i]		
		lw 	    $a0, 0($t0)
		li	    $v0, 1
		syscall
	
		addi	$t1, $t1, 1		# i++ counter for loop to read integers
		beq		$t1, 7, readyForSort	# Check if $t1 == 7, if so then jumps to SecondLargest
		j		readNumLoop
		
	readyForSort:
		# Setting up arguments for quicksort (int array[], int low, int high)
		la		$a0, myArray	# Loads address of myArray into $a0
		li		$a1, 0			# $a1 = 0 
		li		$a2, 6			# $a2 = 6 // size - 1
		

		


    
Quicksort:
	
	# if ( low < high ) / if (low >= high) we jump
	beq		$a1, $a2, returnqs	# if $a1 == $a2 then target
	
	# Save incoming arguments on the stack
	addi	$sp, $sp, -16			# $sp = $sp + -12 // Make space on stack
	sw		$a0, 0($sp)				# Save array address
	sw      $a1, 4($sp)				# Save low value
	sw		$a2, 8($sp)				# Save high value
	sw		$ra, 12($sp)			# Save return address

	jal		Partition				# jump to Partition and save position to $ra

	addi	$sp, $sp, -4			# $sp = $sp -4 // space for returned value from partition
	sw      $v0, 4($sp)			

	lw      $a0, 0($sp)	
	
	
	




	lw		$ra, 12($sp)			# Recover saved return address
	lw		$a2, 8($sp)				# Recover saved high value
	lw		$a1, 4($sp)				# Recover low value
	lw		$a0, 0($sp)				# Recover array address
	addi	$sp, $sp, 16			# $sp = sp1 + 12 // Clean up stack
	
	returnqs:
		jr      $ra
	
	
	
	
	
	
	
    
	
	lowToMid:
        # Pass in address of array, zero index, and mid index
        # Sort this half
        # ACTUALLY SOUNDS LIKE I HAVE TO SPLIT IN HALF LESS THAN X
        # So....pick a mid point, get a value, go throug array and save values lower than midvalue into a new array, sort those

    midToHigh:
        # Pass in mid+1 to sizeOfArray -1
        # Sort this half

Partition:
	# $t0 ----> pivot, list[high]
	sll     $t0, $a2, 2		
	add     $t0, $a0, $t0	# add high*4 bytes to address of array

Swap:





	print:

		li	$t1, 0				# i = 0
		printLoop:
			la		$s0, myArray	# Loads address of myArray into $s0
		
			# Shift logical left by 2
			sll		$t0, $t1, 2	    #  i * 4 bytes where t1 represnts i
			
			add		$t0, $s0, $t0	# add n*4 bytes to address of array
									# $t0 stores address of myArrray[i]
			
			#Code to print the contents of array at myArray[i]		
			lw 	    $a0, 0($t0)
			li	    $v0, 1
			syscall
		
			addi	$t1, $t1, 1		# i++ counter for loop to read integers
			beq		$t1, 7, exit	# Check if $t1 == 7, if so then jumps to SecondLargest
			j		printLoop				# jump to printLoop

	exit:
	li      $v0, 10	  #exit code
	syscall