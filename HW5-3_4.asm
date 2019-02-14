# Quicksort

.data
	# myArray is an array of 6 integers
	# The size of the space is given by n * 4
	# Where n is size of array and 4 is the number of bytes per index
	#myArray: .space 28 		# 7 intgers * 4 bytes
	myArray: .word 10, 2, 17, 9, 6, 4, 8
	
.text
.globl	main
main:	
	readyForSort:
		# Setting up arguments for quicksort (int array[], int low, int high)
		la		$a0, myArray	# Loads address of myArray into $a0
		li		$a1, 0			# $a1 = 0 // Initial Low
		li		$a2, 6			# $a2 = 6 // Initial High = size - 1
		jal		Quicksort		# jump to Quicksort and save position to $ra
		j		print			# jump to print

Quicksort:
	
	# if ( low < high ) / if (low >= high) we jump
	slt		$t0, $a1, $a2
	beq     $t0, $zero, returnqs

	
	# Save incoming arguments on the stack
	addi	$sp, $sp, -16			# $sp = $sp + -12 // Make space on stack
	sw		$ra, 0($sp)			# Save return address
	sw      $a0, 4($sp)			# Save array address
	sw		$a1, 8($sp)				# Save  low value
	sw		$a2, 12($sp)				# Save  high value

	sll     $t1, $a1, 2				# i * 4 bytes to calculate offset for myArray[i]
	add		$t1, $a0, $t1			# myArray[i] adddress
	lw		$t1, 0($t1)				# value of myArray[i]
	
	addi	$t3, $a1, 1				# low + 1
	move 	$t4, $a2				# High

	partitionLowerLoop:
		sll     $t5, $t3, 2			# i * 4
		add		$t5, $a0, $t5		# myArray[i]
		lw      $t5, 0($t5)			# value at myArray[i]

		#check if pivot is less than value at myArray[i]
		slt     $t0, $t1, $t5		# myArray[i] <= 
		bne     $t0, $zero, partitionHighLoop

		addi    $t3, $t3, 1			# i++
		slt     $t0, $a2, $t3		# j < i
		bne		$t0, $zero, partitionHighLoop	# if i > j jump

	partitionHighLoop:
		sll     $t7, $t4, 2			# j * 4 // High
		add		$t7, $a0, $t7		# myArray[j]
		lw      $t7, 0($t7)			# value at myArray[j]

		#check if pivot is less than value at myArray[j]
		slt     $t0, $t7, $t1
		bne     $t0, $zero, endPartitionLoop

		addi    $t4, $t4, -1			# j--
		slt     $t0, $a1, $t4			# i < j
		beq		$t0, $zero, endPartitionLoop	# if i >= j exit loop


	endPartitionLoop:
		slt     $t0, $t4, $t3
		bne		$t0, $zero, endPartition	# if $t7 != zerot jump to EndPartition

		# new temps to keep track
		swap:
			sll     $t5, $t3, 2			# i * 4 bytes
			add		$t5, $a0, $t5		# myArray[i] address
			lw		$t7, 0($t5)			# value at myArray[i]
			sll     $t6, $t4, 2			#	j * 4 bytes
			add		$t6, $a0, $t6		# address of myArray[j]
			lw		$t8, 0($t6)			#  load value at myArray[j]
			sw      $t8, 0($t5)
			sw      $t7, 0($t6)

			j	partitionLowerLoop
		
	endPartition:

	sll     $t6, $t4, 2				# j * 4 bytes
	add		$t6, $a0, $t6			# address of myArray[j]
	sll     $t5, $a1, 2				# i * 4 bytes
	add		$t5, $a0, $t5			# address of myArray[i]

	lw      $t8, 0($t6)
	sw      $t8, 0($t5)
	sw      $t1, 0($t6)

    addi    $sp, $sp, -4

	sw      $t4, 0($sp)

	move	$a2, $t4				# 
	
	jal		Quicksort				# jump to Quicksort to sort lower half
	
	lw		$t4, 0($sp)	
    
    addi    $sp, $sp, 4
	
	addi    $t4, $t4, 1

	move 	$a1, $t4	

	lw		$a2, 12($sp)		# CHECK HERREE!
	
	jal		Quicksort				# jump to Quicksort to sort upper half

	lw		$ra, 0($sp)			# Recover saved return address

	addi    $sp, $sp, 16
#	lw		$a2, 8($sp)				# Recover saved high value
#	lw		$a1, 12($sp)				# Recover low value
#	lw		$a0, 16($sp)				# Recover array address
#	addi	$sp, $sp, 20			# $sp = sp1 + 12 // Clean up stack
	
	returnqs:
		jr      $ra


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