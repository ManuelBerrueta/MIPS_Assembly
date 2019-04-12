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
	#myArray: .space 28 		# 7 intgers * 4 bytes
	myArray: .word 10, 2, 17, 9, 6, 4, 8
	
.text
.globl	main
main:
	li	$t8, 7				# myArray size = 7
	li	$t1, 0				# i = 0
	
#	readNumLoop:
#		la		$s0, myArray	# Loads address of myArray into $s0
#		
#		# Shift logical left by 2
#		sll		$t0, $t1, 2	    #  i * 4 bytes where t1 represnts i
#		
#		add		$t0, $s0, $t0	# add n*4 bytes to address of array
#							    # $t0 stores address of myArrray[i]
#		
#		li		$v0, 5		# 5 = opcode to read int from keyboard
#							# stores int in $v0
#		syscall				# Systemcall of prior instruction
#							# Read int in from keyboard
#						
#		move	$t3, $v0	# move int from input to #$t1
#			
#		sw		$t3, 0($t0)	# Store int from input into myArray[i]
#		
#		#Code to test the contents of array at myArray[i]		
#		lw 	    $a0, 0($t0)
#		li	    $v0, 1
#		syscall
#	
#		addi	$t1, $t1, 1		# i++ counter for loop to read integers
#		beq		$t1, 7, readyForSort	# Check if $t1 == 7, if so then jumps to SecondLargest
#		j		readNumLoop
		
	readyForSort:
		# Setting up arguments for quicksort (int array[], int low, int high)
		la		$a0, myArray	# Loads address of myArray into $a0
		li		$a1, 0			# $a1 = 0 
		li		$a2, 6			# $a2 = 6 // size - 1
		jal		Quicksort		# jump to Quicksort and save position to $ra
		j		print			# jump to print
		

Partition:
	# $t0 ----> pivot address calculation 
	# $t1 ----> pivot value
	# $t2 ----> i +1
	# $t3 ----> j
	# $t4 ----> high
	# $s0 ----> arrayAdress
	# $t5 ----> address of list[j]
	# $t6 ----> value at list[j]
	# $t7 ----> address of list [i]
	# $t8 ----> value at list[i]
	# $t9 ----> tempSwap

	add 	$t0, $a1, $a1
	sll     $t0, $t0, 2		# $t0 = $t1 + $t2
	
	add		$t0, $a0, $t0	#Pivot address

	lw      $t1, 0($t0)

	addi	$t2, $a1, 1

	move	$t3, $a2





	, $a0		# Adress of array/list
	sll     $t0, $a1, 2		#  i * 4 bytes where a1 represnts index low array
	add     $t0, $s0, $t0	# add i*4 bytes to address of array

	lw		$t0, 0($t0)		# Load value at calculated i

	addi    $t1, $a1, -1	# Initialize i = low -1
	addi    $t2, $a2, 1		# Initialize j = high + 1
	
	add		$t3, $t1, $t1	# $t3 = $t1 + $t1
	sll		$t3, $t3, 2		
	add		$t3, $a0 $t3	# Calculated address of i

	add		$t4, $t2, $t2	# $t3 = $t1 + $t1
	sll		$t4, $t4, 2		
	add		$t4, $a0 $t4	# Calculated address of i	


	partitionLoop:

		addi	$t1, $t1, 1			# i++
		sll     $t3, $t3, 2			# list[i]
		lw		$t5, 0($t3)		# Load value of list[j] into $t6
		slt     $t6, $t5, $t0
		bne		$t6, $zero, partitionLoop	
		ori     $t0, $t0, 0
		


		innerLoop:
		addi    $t2, $t2, -1		# j--
		
		addi	$t4, $t4, -4		# address of list[j--]
		lw      $t5, 0($t4)			# Value at current list[j--]
		slt     $t6, $t0, $t5
		bne     $t6, $zero, innerLoop
		slt     $t5, $t1, $t2
		beq     $t5, $zero, endPartitionLoop

		Swap:
			lw		$t5, 0($t3)		# tempSwap = value at list[j]
			lw		$t6, 0($t4)		# Load value of list[i] into $t8

			# swap value of list[i] into list[j]
			sw		$t6, 0($t3)		

			# value of list[j] into list[i]
			sw		$t5, 0($t4)		# 
			#end of swap

			j		partitionLoop				# jump to partitionLoop
							

	endPartitionLoop:
		addu	$v0, $zero, $t2	 
		jr		$ra					# jump to $ra
		

Quicksort:
	
	# $t0 ----> midpivot -1
	# $t1 ----> midpivot +1
	# $t2 ----> high 

	# if ( low < high ) / if (low >= high) we jump
	bge		$a1, $a2, returnqs	# if $a1 >= $a2 then target
	
	# Save incoming arguments on the stack
	addi	$sp, $sp, -16			# $sp = $sp + -12 // Make space on stack
	sw		$ra, 16($sp)			# Save return address
	sw      $a0, 12($sp)			# Save array address
	sw		$a1, 8($sp)				# Save  low value
	sw		$a2, 4($sp)				# Save  high value

	jal		Partition				# jump to Partition and save position to $ra

	addi	$sp, $sp, -4			# $sp = $sp -4 // space for returned value from partition
									# Need to clean up this from the stack

	sw      $v0, 4($sp)				# save return v0 from Partition to the stack

	
	#	$t0, $v0, -1			# $t0 = midpivot - 1
	add		$t0, $v0, -1		
	
	lw		$a0, 16($sp)		# 
	lw		$a1, 12($sp)		# 
	
	move    $a2, $t0				# move midpivot-1 to 3rd argument for lower half sort

	jal		Quicksort				# jump to Quicksort to sort lower half
	
	lw      $a0, 16($sp)				# Recover midpivot (v0) from Partition (midpivot) from the stack
	lw		$t1, 4($sp)		# 
	
	addi	$t1, $t1, 1				# $t1 = midpivot +1

	move 	$a1, $t1				# $a1 = midpivot + 1

	lw      $t2, 8($sp)				# Retrieved High from stack

	move 	$a2, $t2				# $a2 = High

	jal		Quicksort				# jump to Quicksort to sort upper half

	addi    $sp, $sp, 20
	lw		$ra, 0($sp)			# Recover saved return address
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