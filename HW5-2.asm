#function while ( (k >= 2 && m <=k) && (m % 2 ==0) ) {   , m * m }
#int  theta(int k);
#
#int main(void)
#{
#    int k = 15;
#    int maxValue = 0;
#
#    maxValue = theta(k);
#
#    printf("Return value should be 560 and is: %d \n",  maxValue);
#}
#
#int theta(int k)
#{
#    int m =2;
#    int sigma = 0;
#
#    while((k >= 2) && (m <=k))
#    {
#        if((m % 2) == 0)
#        {
#            sigma += m * m;
#        }
#        m++;
#    }
#    return sigma;
#}

.text
.globl main

main:

    # $a0 ----> k
    
    li      $a0, 15
    jal     theta
    
    
    print:
        # Load $v0 into $a0 to print out the contents 
        move 	    $a0, $v0		# $a0 = 2 * customFib(n-1) + 3 * customFib(n-2)
        li	        $v0, 1
        syscall


    exit:
        li		    $v0, 10	  #exit code
        syscall

theta:
    
    # Saving variables on stack for practice!
    addi        $sp, $sp, -4    # make space on the stack
    sw          $ra, 0($sp)     # save $ra on the stack 

    # t0 ----> sigma, sum of the m^2
    # t1 ----> m
    # t2 ----> temp m^2 value
    # t3 ----> temp m for mod operations
    li          $t9, 2  #temp for mod
    li          $t1, 2  # starting m at 2, m=2

    Loop:

        beq     $t1, $a0, kIsBLEm   # check if m == k,if so jump to kIsBLEm
        move    $t3, $t1
        div		$t3, $t9			# $t3 / 2
        mflo	$t4				# $t4 = floor($t3 / 2) 
        mfhi	$t5				# $t5 = $t3 mod 2 
        
        beqz    $t5,  mModTwoisZero #chec if m mod 2 == 0, if so jump and perform sigma += m^2

        addi    $t1, $t1, 1 # m++
        j       Loop

        mModTwoisZero:
            mul     $t2, $t1, $t1   # m^2 or m*m
            add		$t0, $t0, $t2	# $t0 = $t0 + $t2   // sigma += m^2
            addi    $t1, $t1, 1 # m++
            j       Loop

        
    kIsBLEm:
        lw      $ra, 0($sp)
        addi	$sp, $sp, 4			# $sp = $sp + 4 // Clean up stack
        

        #return signma
        move    $v0, $t0
        jr		$ra					# jump to $ra
    