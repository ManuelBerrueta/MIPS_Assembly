# Requirements:
    # Translating the following C code:
    # void main(){
    # int x=12;
    # int y=simpleEx(x,x-5);
    # y=y+simpleEx(14,x);
    
    #}
    #int simpleEx(int x, int y){
    #int z=7;
    #return x+2y-z;
    #}

.text
.globl main

main:
        # x -----> $s0 
        # z -----> $s1 
        # y -----> $s2
        # x-5 ---> $t0
        # $a0 = 12
        # $a1 = 7
        

        # x = 12
        li		$s0, 12	        # $s0 = 12 // x=12
        addi    $t0, $s0, -5    # subtract 5 from $s0, store in $t0 // x-5
        move 	$a0, $s0		# $a0 = $s0
        move    $a1, $t0        # $a1 = x-5
        jal     simpleEx
        move 	$s2, $v0		# $s2 = $t1
        li		$t0, 14
        move 	$a0, $t0
        move 	$a1, $s0		# $a1 = s0
        jal     simpleEx
        add     $s2, $s2, $v0

        # Test code to test contents of y 
        #move 	$a0, $s2
        #li	$v0, 1
        #syscall

        j       Exit




simpleEx:
        # #a0 ---> x
        # $a1 ---> y

        # For practice: Making space in the stack and saving $s0 on the stack
        addi	$sp, $sp, -4        # making space for 4 bytes in the stack
        sw	$s0, 0($sp)		    # saved s0 on the stack

        li	$s1, 7		        # $s1 =7 // z = 7 //? Global Var...
        
        # using $s0 for arithmetic
        sll     $s0, $a1, 1         # 2 * y
        add		$s0, $a0, $s0		# $s0 = $a0 + $s0 // x + 2y
        sub     $s0, $s0, $s1       #  x + 2y - z
        
        # return z + 2y + z
        move    $v0, $s0

        # For practice: Recover $s0 from the stack and clean up the stack
        lw      $s0, 0($sp)         # Recover $s0 from the stack
        addi	$sp, $sp, 4			# Adding the 4 that we subtracted
                                    
        jr		$ra					# jump to $ra // returns $v0 and back to main
        
Exit:
    li		$v0, 10	  #exit code
    syscall









