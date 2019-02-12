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
	li	$t8, 7				# myArray size = 7
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
		jal		Quicksort		# jump to Quicksort and save position to $ra
		j		print			# jump to print
		
    
Quicksort:
	
	# $t0 ----> midpivot -1
	# $t1 ----> midpivot +1
	# $t2 ----> high 

	# if ( low < high ) / if (low >= high) we jump
	bgt		$a1, $a2, returnqs	# if $a1 == $a2 then target
	
	# Save incoming arguments on the stack
	addi	$sp, $sp, -16			# $sp = $sp + -12 // Make space on stack
	sw		$a0, 0($sp)				# Save array address
	sw      $a1, 4($sp)				# Save low value
	sw		$a2, 8($sp)				# Save high value
	sw		$ra, 12($sp)			# Save return address

	jal		Partition				# jump to Partition and save position to $ra

	addi	$sp, $sp, -4			# $sp = $sp -4 // space for returned value from partition
									# Need to clean up this from the stack

	sw      $v0, 0($sp)				# save return v0 from Partition to the stack
	
	
	addi	$t0, $v0, -1			# $t0 = midpivot - 1
	
	move    $a2, $t0				# move midpivot-1 to 3rd argument for lower half sort

	jal		Quicksort				# jump to Quicksort to sort lower half
	
	lw      $t1, 4($sp)				# Recover midpivot (v0) from Partition (midpivot) from the stack
	addi	$sp, $sp, 4				# Clean up v0 from stack

	addi	$t1, $t1, 1				# $t1 = midpivot +1

	move 	$a1, $t1				# $a1 = midpivot + 1

	lw      $t2, 8($sp)				# Retrieved High from stack

	move 	$a2, $t2				# $a2 = High

	jal		Quicksort				# jump to Quicksort to sort upper half


	lw		$ra, 12($sp)			# Recover saved return address
	lw		$a2, 8($sp)				# Recover saved high value
	lw		$a1, 4($sp)				# Recover low value
	lw		$a0, 0($sp)				# Recover array address
	addi	$sp, $sp, 16			# $sp = sp1 + 12 // Clean up stack
	
	returnqs:
		jr      $ra

Partition:
	# $t0 ----> pivot address, list[high] address
	# $t1 ----> PIVOT, value at list[high]
	# $t2 ----> i -1
	# $t3 ----> j
	# $t4 ----> high -1
	# $s0 ----> arrayAdress
	# $t5 ----> address of list[j]
	# $t6 ----> value at list[j]
	# $t7 ----> address of list [i]
	# $t8 ----> value at list[i]
	# $t9 ----> tempSwap

	move    $s0, $a0		# Adress of array/list
	sll     $t0, $a2, 2		#  i * 4 bytes where a2 represnts highest index on array
	add     $t0, $s0, $t0	# add high*4 bytes to address of array
							# Gets us the address of the last element
	lw		$t1, 0($t0)		# Load value at last element into t1

	addi    $t2, $a1, -1	# Initialize i = low -1
	move    $t3, $a1		# Initialize j = low
	addi    $t4, $a2, -1	# $t4 = high - 1

	partitionLoop:
		
		bgt     $t3, $t4, endPartitionLoop		# For/while( j <= high-1)		#SHOULD BE GOOD...

		# Load value of list[j]
		sll     $t5, $t3, 2		# j * 4 bytes
		add		$t5, $s0, $t5		# address of list[j]
		lw		$t6, 0($t5)		# Load value of list[j] into $t6
		# if list[j] <= pivot
		ble		$t6, $t1, lessThanEqual	# if list[j] <= pivot then lessThanEqual
		
		addi	$t3, $t3, 1			# j++
		
		j partitionLoop

			lessThanEqual:
			addi    $t2, $t2, 1		# i++
			
			#SWAp goes here
			Swap:
				lw		$t9, 0($t5)		# tempSwap = value at list[j]
				
				# calculate adress of list[i]
				sll     $t7, $t2, 2		# i * 4 bytes
				add		$t7, $s0, $t7	# address of list[i]
				
				lw		$t8, 0($t7)		# Load value of list[i] into $t8

				# swap value of list[i] into list[j]
				sw		$t8, 0($t5)		

				# value of list[j] into list[i]
				sw		$t9, 0($t7)		# 
				#end of swap

				addi	$t3, $t3, 1			# j++
				j partitionLoop

	endPartitionLoop:
		#SWAp goes here
		SwapEnd:
			addi    $t2, $t2, 1		# i++
			
			sll     $t5, $a2, 2		# high * 4 bytes
			add		$t5, $s0, $t5		# address of list[high]
			lw		$t6, 0($t5)		# Load value of list[high] into $t6


			# calculate adress of list[i]
			sll     $t7, $t2, 2		# i * 4 bytes
			add		$t7, $s0, $t7	# address of list[i+1]
			
			lw		$t8, 0($t7)		# Load value of list[i+1] into $t8

			# swap value of list[i+1] into list[high]
			sw		$t8, 0($t5)		

			# value of list[high] into list[i+1]
			sw		$t6, 0($t7)		# 
			#end of swap

			addi	$t2, $t2, 1			# i+1 for end of partition
			#end of swap

			#return i+1
			addi	$v0, $t2, 1			# $v0 = i+1

			jr		$ra					# jump to $ra
		
		
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