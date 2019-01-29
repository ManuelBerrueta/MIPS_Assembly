#x---->$s0
#y---->$s1

.data
		
.text
.globl	main
main:
	sgt $t1, $s0, 5		# If $s0 > 5
				# If true sets $t1 to one?
	beq $t1, $zero, Else	# Check if $t1 is = 0, if so then jumps to Else
	add $s0, $s0, $s1
	j   Exit

	Else:
		
	Exit:
	
