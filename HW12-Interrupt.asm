# MIPS Memmory mapped I/O Interrupt Handler
# Single digit adder program
# Takes keyboard input A+B= and displays A+B=C
# where A & B are single digits & C is the single or two digit result of the sum

# SPECIAL REGISTERS:
# $12 Status Register
# $13 Cause Register

# Special Addresses
# Receiver Control:     0xFFFF0000 = 0xFFFF
# Receiver Data:        0xFFFF0004 = 0xFFFF + 4
# Transmitter Control:  0xFFFF0008 = 0xFFFF + 8
# Transmitter Data:     0xFFFF000C = 0xFFFF + 12


.text
.globl	main
main:
    #####################! Start of Initial Setup !#####################
    # Turn on the interrupt bit
    lui     $t0, 0xFFFF         # Address of Transmitter/Receiver
    lw		$t1, 0($t0)		    # Load contents of 0xFFFF into $t1
    ori     $t1, $t1, 0x0002    # Change the 2nd to last bit to on (Interrup Enable =1)
    sw		$t1, 0($t0) 		# Store the modified contents back to the register
    # s7 = myArray address 
    la	    $s7, myArray

    # $s2 = 9 will be my number to check if result is more than one digit
    li		$s2, 9		# 
    
`
    #Turn on transmitter control ready bit
    ori     $k0, 0x0001
    
    #Setup $12 Cause Register - DONE by emulator - don't need to do anything
    #####################! End of Initial Setup !#####################
    
    #####################! Running Loop !#####################
    Loop:
        addi        $s0, $s0, 0
        j Loop
        #li          $v0, 10 		# $v0 = 10 
        #syscall
    ##################! End Of Running Loop !##################
    
.kdata
    # Allocate memory for saving any temporary register
    k_save_t0:  .word 0
    k_save_t1:  .word 0
    k_save_t2:  .word 0
    k_save_t3:  .word 0
    k_save_t4:  .word 0
    k_save_t5:  .word 0
    k_save_t6:  .word 0
    k_save_t7:  .word 0
    k_save_t8:  .word 0
    k_save_t9:  .word 0
    k_save_at:  .word 0
    
    asciiZero:	.byte '0'
	myArray: 	.space 30
    
.ktext 0x80000180
    ############################! Interrupt Setup !############################
    # Save incoming register content to memory
    sw      $t0, k_save_t0
    sw      $t1, k_save_t1
    sw      $t2, k_save_t2
    sw      $t3, k_save_t3
    sw      $t4, k_save_t4
    sw      $t5, k_save_t5
    sw      $t6, k_save_t6
    sw      $t7, k_save_t7
    sw      $t8, k_save_t8
    sw      $t9, k_save_t9
    sw      $at, k_save_at
    
    ###########################! INTERRUPT HANDLER !###########################
    # move from coprocesor 0 $12 Status Register
    mfc0    $t4, $12            
    # Set interrupt enable bit = 0 for the $12 Status Register
    # The bit is located in the 2^8 spot = 256 == 0x0100 
    ori     $t4, $t4, 0x0100    # This stops program input &
                                # allows for the program to process the
                                # input that has already been given
    # move to coprocessor 0
    mtc0    $t4, $12            #This moves the modified contents of $12 the interrupt enabled to 0
    # Check EXEC code
    mfc0    $t4, $13            # Loads register $13 contents
    andi    $t4, $t4, 0x007C    # EXEC code check for interrupt and not exeption
    bne		$t4, $zero, exit  	# Exit if it is an exception
    
    
    #####################################################
    # Save input character into the array
    # If counter $s1 == 4 then go to Adder code
    #####################################################

    lui     $t0, 0xFFFF         # $t0 holds address of controls
    lw      $t1, 4($t0)         # $t1 holds keyboard char
    sb      $t1, 0($s7)         # character in $t1 is now stored in myArray
    addi	$s1, $s1, 1         # i++
    addi	$s7, $s7, 1         # Increment myArray index + 1
    beq		$s1, 4, Adder	    # if $t9 =1t1 then target

    #####################################################
    # End of character input store code
    #####################################################
    
    ####### Clean Up $13 Cause Register
    li		$t8, 0
    mtc0    $t8, $13            # Set $13 Cause Register to all 0s
    
    ###### Enable the interrupt enable bit in $12 Status Register
    mfc0    $t4, $12            
    # Set interrupt enable bit = 1 for the $12 Status Register
    # The bit is located in the 2^8 spot = 256 == 0x0100 
    ori     $t4, $t4, 0x0100    # This will allow program input
    ori     $t4, $t4, 0x0002    # Set mode to user
    # move to coprocessor 0
    mtc0    $t4, $12            #This moves the modified contents of $12 the interrupt enabled to 1
    
    
    ###########################! END HANDLER CODE !###########################
    
    # Recover saved registers from memory
    lw		$at, k_save_at 
    lw		$t9, k_save_t9 
    lw		$t8, k_save_t8
    lw		$t7, k_save_t7
    lw		$t6, k_save_t6 
    lw		$t5, k_save_t5
    lw		$t4, k_save_t4 
    lw		$t3, k_save_t3
    lw		$t2, k_save_t2
    lw		$t1, k_save_t1 
    lw      $t0, k_save_t0
    
    eret

    ###########################################################################
    # Convert A and B inputs to integers
    # Add A + B
    # Check if result of addition is 1 or 2 digits
    # Convert result back to Ascii
    # Store result in array
    # Display the result

    Adder:
        # Reset $s7 back to index 0 by loading the address of myArray
        la      $s7, myArray
        lb      $a0, 0($s7)		        # $a0 holds the first character in myArray at index 0
        addi    $s7, $s7, 2             # $s7 now at index to of myArray, $s7=myArray[2]
                                        # this contains the 2nd number to  convert

        # Call char2num function to convert the first ascii character to integer
        jal     char2num
        # Returned integer value saved to $t7		
        move    $t7, $v0

        # Call char2num function to convert the 2nd ascii character to integer
        lb      $a0, 0($s7)             # $a0 holds the char @ myArray[2]
        jal	char2num
        move	$t6, $v0

        add     $t5, $t7, $t6		    # add input a and input b and put it in z. $t5 holds result     
        #####
        ###### when $s2 below was $t4 it printed but went the wrong path
        bgt     $t5, $s2, ConvertTwoDigitResultToAscii  # If result is two digit, jump to twoDigitResult
        j		ConvertResultToAscii                    # else jump to ConvertResultToAscii

        ConvertTwoDigitResultToAscii:
            # Need to handle the result one char at a time for the double digit of the ascii
            # We know if our result is two digit and since is a single digit adder, our first digit will be 1 
            li      $a0, 1
            jal     num2char
            move    $t3, $v0            # $t3 now has the char '1'           
            addi    $s7, $s7, 2           
            # Store the value of $t3 after the '=' character in myArray, myArray[5] = ($t3=1)
            sb      $t3, 0($s7)          
            # We can now subtract 10 from our result since our conversion handles a single digit
            subi	$t5, $t5, 10        # Result - 10, is a single digit value
            # myArray[i-1]  to compensate for the i+2 in ConvertResultToAscii 
            subi	$s7, $s7, 1         # myArray[i-1]

    # Convert sum result stored in $t5 to ascii
    ConvertResultToAscii:
        # Increment myArray pass the "=". Staging to store the result in $t5 into myArray[5]
        addi	$s7, $s7, 2 
        move	$a0, $t5
        # Call function to convert result number to char
        jal	num2char
        sb	$v0, 0($s7)                 # Store result in myArray[5]

    ########################## Display Polling Begin ##########################
    # Load Transceiver Control
    lui     $t0, 0xFFFF
    # Reset array index back to 0 by loading myArray
    la      $s7, myArray
    # Load first element in myArray for display
    lb      $t7, 0($s7)
    
    DisplayLoop:
        # Check for null character, if == null then we are done, exit
        beqz    $t7, exit
        # Store the character in myArray[i] representing characters of sum "a+b=z" into transmitter data
        sb      $t7, 12($t0)

	printToScreenLoop: 
        lw      $t1, 8($t0)         # $t1 holds content of Transmitter Control == 0xFFFF0008
        andi    $t2, $t1, 0x0001    # Bitwise operation to set ready bit
        beq     $t2, $zero, printToScreenLoop #If not ready loop again
		addi	$s7, $s7, 1         # increment array to next charmyArray[i++]
        lb      $t7, 0($s7)
        j DisplayLoop
    ########################## Display Polling End ##########################

    ##################### End of Adder and Display code #####################
    #########################################################################

exit:
    li      $v0, 10
    syscall
    
char2num:
	lb      $t0, asciiZero
	subu    $v0, $a0, $t0
	jr      $ra
    
num2char:
	lb      $t0, asciiZero
	addu    $v0, $a0, $t0
	jr      $ra