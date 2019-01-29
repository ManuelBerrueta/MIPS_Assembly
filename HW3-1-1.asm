#x---->$s0
#y---->$s1

.data
		
.text
.globl	main
main:
	addi	$t1, $s1, 5		# $s1+5 and storing it in $t1 [$s1 represents y,]

	sgt 	$t2, $s0, $t1 		# If $s0 > $t1 sets $t2 = 1,
					# If not $t2 = 0
	
	beq 	$t2, $zero, Else	# Check if $t2 is == 0, if so then jumps to Else
					# If $t2 ==1 then it falls through, meaning $s0 > $t1 above is true
					# If  $t1 is equal to zero, it means that It is not true that $s0 > 5
					# If  $t1 is equal to 1, it means that is is true that $s0 > 5
					
	add 	$s0, $s0, $s1		# x = x +y	
	j   	Exit

	Else:
		sub 	$s1, $s0, $s1
		
	Exit:
		li	$v0, 10			#exit code
		syscall
	
