.data
	helloWorld: .asciiz "Hello World \n" #Sets up a string
		
.text
.globl	main
main:
	#
	li $v0, 4	                     # 4 to print out strings & char
	la $a0, helloWorld
	syscall
	#addi $t0, $t0, 1