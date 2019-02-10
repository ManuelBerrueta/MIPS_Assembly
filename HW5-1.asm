.text
.globl main

main:

    # our $a0 will be equal to 4
   

    li      $a0, 4
    jal     customFib

    print:
        # Load $v0 into $a0 to print out the contents 
        move 	    $a0, $v0		# $a0 = 2 * customFib(n-1) + 3 * customFib(n-2)
        li	        $v0, 1
        syscall


    exit:
        li		    $v0, 10	  #exit code
        syscall

 # $t1 -----> 1
customFib:
    # If n > 1
    bgt         $a0, 1, recursive   #if argument $a0 is greater than 1 jump to recursive step

    #elseif n == 1
    li		    $t1, 1		        # $ t1= 1
    beq         $a0, $t1, itsOne    #jump to label itsOne
    

    #if n == 0, exit 
    beqz        $a0, itsZero	# if        $a0 != zero exit
    
    #else it is zero, falls through and returns 1
    itsZero:
        li          $v0, 1          # if its zero load 1 to $v0 
        jr		    $ra			    # jump to $ra return 1

    #else if it is 1, returns 2    
    itsOne:
        li          $v0, 2          # if its zero load 1 to $v0 
        jr		    $ra			    # jump to $ra return 1


recursive:
    # Save variables on stack
    addi	    $sp, $sp, -8		# $sp1 $sp, -8 
    sw		    $ra, 0($sp)		    # saved $ra on the stack
    sw		    $a0, 4($sp)		    # saved $a0 pm the stack

    # customFib(n-1)
    addi        $a0, $a0, -1    	# $a0 =  n-1 
    jal         customFib           # calls customFib(n-1)
    addi	    $sp, $sp, -4		# $sp = sp1 - 4  // Making space to save $v0 returned from customFib(n-1)
    
    # t2 -----> 2
    # For 2 * customFib(n-1)
    li		    $t2, 2          	# $t2 = 2
    mul         $v0, $v0, $t2       # 2 * customFib(n-1)
    sw          $v0, 0($sp)         # saved $v0 (2 * customFib(n-1))
    

    # customFib(n-2)
    addi        $a0, $a0, -1	    # $a0 = n-2
    jal         customFib           # calls customFib(n-2)

    # t3 -----> 3
    # For 3 * customFib(n-2)
    li          $t3, 3              # $t3 = 3
    mul         $v0, $v0, $t3       # 3 * customFib(n-2)


    # load: 2 * customFib(n-1) from the stack
    lw		    $t0, 0($sp)         # $t0 = 2 * customFib(n-1)
    addi        $sp, $sp, 4         # Clean up 2 * customFib(n-1) from stack


    # add: 2 * customFib(n-1) + 3 * customFib(n-2)
    add		    $v0, $v0, $t0	    # $v0 = 2 * customFib(n-1) + 3 * customFib(n-2)
    


    # Recover variables from the stack
    lw		    $a0, 4($sp)		    # recover $a0 from stack
    lw		    $ra, 0($sp) 		# recover $ra from stack
    addi        $sp, $sp, 8         # clean up stack
    jr		    $ra					# jump to   $ra