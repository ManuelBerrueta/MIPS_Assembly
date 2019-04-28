# MIPS Hello World!

.data
	str_helloWorld: .asciiz "Hello World! \n" #Sets up a string
		
.text
.globl	main
main:
	#
	li		$v0, 4					# 4 to print out strings & char
	la		$a0, str_helloWorld
	syscall
	
	exit:
		li		$v0, 10				# 10 is used to terminate the program
		syscall