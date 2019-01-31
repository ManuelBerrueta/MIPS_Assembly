#$s0---->x
#$s1---->y

# while (x>y+5) {x--; x--; y++}

.text
.globl	main
main:
	Loop:
		addi	$t1, $s1, 5 		# $s1+5 and storing it in $t1 [$s1 represents y,]
						#! y + 5

		sgt	$t2, $s0, $t1		# If $s0 > $t1 sets $t2 = 1,
						# If not $t2 = 0
						#! x > y+5
		
		
		beq	$t2, $zero, Exit	# Check if $t2 is == 0, if so then jumps to Exit
						# If $t2 ==1 then it falls through, meaning $s0 > $t1 above is true
						# If  $t1 is equal to zero, it means that It is not true that $s0 > 5
						# If  $t1 is equal to 1, it means that is is true that $s0 > 5
						#! while
		subi	$s0, $s0, 1		#! x--
		subi	$s0, $s0, 1		#! x--
		addi	$s1, $s1, 1		# y++
		j	Loop
	
	Exit:
		li	$v0, 10			#exit code
		syscall