.data
	helloWorld: .asciiz "Hello World \n" #This is a comment
	newLine: .asciiz "\n"
	oneChar: .byte 'T' 
	age: .word 2 #
	PI: .float 3.14159265359
	
.text
	#
	li $v0, 4	# 4 to print out strings & char
	la $a0, helloWorld
	syscall
	li $v0, 4
	la $a0, oneChar
	syscall
	li $v0, 1	# 1 to print out integers
	lw $a0, age
	syscall
	li $v0, 4
	la $a0, newLine
	syscall
	li $v0, 2
	lwc1 $f12, PI
	syscall