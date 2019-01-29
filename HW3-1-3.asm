#x---->$s0
#y---->$s1

.text
.globl	main
main:
		# li - load immediate
		li	$s0, 1	# x = 1
	
	Loop:	
		# slt - Set on Less Than
		slt	$t0, $s0, $s1		# Check if $s0 < $s1
						# If $s0< $s1, set $t0 = 1
						#! x < y
		
		beq	$t0, $zero, Exit	# Check if $t0 is == 0, if so then jumps to Exit
						# If not falls through to next instruction
						#! for 
						
		addi	$s0, $s0, 5		# x = x +5		
		addi	$s1, $s1, 1		# y = y + 1 == y++ 
		
		#Code to test the contents of $t1
		move 	$a0, $t0
		li	$v0, 1
		syscall

		#Code to test the contents of $s0		
		move 	$a0, $s0
		li	$v0, 1
		
		addi	$s0, $s0, 1		# x++ in for loop
		
		j	Loop
		
	Exit:
		li	$v0, 10			#exit code
		syscall