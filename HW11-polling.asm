# Memory mapped I/O Polling
# Two single digits adder
# Polling for keyboard input for 4 characters in the form "a+b="
# Converts 'a' & 'b' Ascii values to Integers
# Performs addition operation of "a" & "b" and saves it in z
# Check if result of addition is single or two digits
# Converts z integer value to Ascii
# Polls for Display ouput to print out the result "a+b=z"

.data
	asciiZero:	.byte '0'
	myArray: 	.space 30 		

.text
.globl	main
main:	
    ### Set interrup bit to 1
    ori     $k0, 0x0001
    ## s7 = myArray address 
    la	    $s7, myArray
    # $t8 = 4, 4 is the number of characters to read in from keyboard to perform our addition operation
    li	    $t8, 4
    # $t9 represents "i" counter for reading input
    li	    $t9, 0

    # $t4 = 9 is to check to see if the result is two digits
    li      $t4, 9
    
    ######################## Keyboard Polling Begin ########################
    lui $t0, 0xFFFF                     #$t0 holds address of Receiver Control == 0xFFFF0000
    
    InputLoop:
        bge, $t9, $t8, Adder            # If i counter is >= 4, done getting input from user

        KeyLoop:
            lw      $t1, 0($t0)         # $t1 holds content of Receiver Control
            andi    $t2, $t1, 0x0001    # Bitwise operation that holds the ready bit
                                        # Logic: If the result of the bitwise and operation
                                        # == 1, then it is the case that the Receiver Control is ready,
                                        # else if the results of the bitwise and operation is == 0 then
                                        # it is not the case that the Receiver Control is ready

            beq		$t2, $zero, KeyLoop # If $t2 == zero, that is, if Receiver Control is NOT ready
                                        # Loop: again.
            lw      $t1, 4($t0)         # $t1 holds keyboard char
            sb      $t1, 0($s7)         # character in $t1 is now stored in myArray
            addi	$t9, $t9, 1         # i++
            addi	$s7, $s7, 1         # Increment myArray index + 1
            j	InputLoop
    ######################## Keyboard Polling End ########################
    
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
        bgt     $t5, $t4, ConvertTwoDigitResultToAscii  # If result is two digit, jump to twoDigitResult
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

    ######################## Display Polling Begin ########################
    # Load Transceiver Control
    lui     $t0, 0xFFFF
    # Reset array index back to 0 by loading myArray
    la      $s7, myArray
    # Load first element in myArray for display
    lb      $t7, 0($s7)
    
    DisLoop:
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
        j DisLoop
    ######################## Display Polling End ########################

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