#Polling for keyboard input for 4 characters in the form "a+b="
#Performs addition operation of "a" & "b" and saves it in z
#Polls for Display ouput to print out the result "a+b=z" 
.data
	# myArray is an array of 6 integers
	# The size of the space is given by n * 4
	# Where n is size of array and 4 is the number of bytes per index
	asciiZero:	.byte '0'
	myArray: 	.space 30 		

.text
.globl	main
main:	
    ### Set interrup bit to 1
    ori     $k0, 0x0001
    ## s7 = myArray address 
    la	$s7, myArray
    # $t8 = 4, 4 is the number of characters to read in from keyboard to perform our addition operation
    li	$t8, 4
    # $t9 represents "i" counter for reading input
    li	$t9, 0
    
    ######################## Keyboard Polling Begin ########################
    lui $t0, 0xFFFF                 #$t0 holds address of Receiver Control == 0xFFFF0000

    
    InputLoop:
    	bge, $t9, $t8, Adder
    
    	KeyLoop:
	        lw		$t1, 0($t0)		    # $t1 holds content of Receiver Control
        	andi    $t2, $t1, 0x0001 	   # Bitwise operation that holds the ready bit
                                	    # Logic: If the result of the bitwise and operation
                        	            # == 1, then it is the case that the Receiver Control is ready,
                	                    # else if the results of the bitwise and operation is == 0 then
        	                            # it is not the case that the Receiver Control is ready
                                    
	        beq		$t2, $zero, KeyLoop	# If $t2 == zero, that is, if Receiver Control is NOT ready
                                    # Loop: again.
        	lw      $t1, 4($t0)         # $t1 holds keyboard char
	        sb	$t1, 0($s7)   	     # character in $t1 is now stored in myArray
	       	addi	$t9, $t9, 1		# i++
       		addi	$s7, $s7, 1	     # Increment myArray index + 1
	        j	InputLoop
       
 


    ######################## Keyboard Polling End ########################
    
    Adder:
    	# Reset $s7 back to index 0 by loading the address of myArray
	la	$s7, myArray
	lb	$a0, 0($s7)		# $a0 holds the first character in myArray at index 0
	addi	$s7, $s7, 2		# $s7 now at index to of myArray, $s7=myArray[2]
	
	# Call char2num function to conver the ascii character to integer
	jal	char2num		
	move	$t7, $v0
	
	# Call char2num function to conver the ascii character to integer
	lb	$a0, 0($s7)		# $a0 holds the first character in myArray at index 0
	jal	char2num
	move	$t6, $v0
	
	add	$t7, $t6, $t5		# add input a and input b and put it in z. $t5 holds result
	
	# Increment myArray pass the "=". Staging to store the result
	addi	$s7, $s7, 2
	
	# Convert sum result stored in $t5 to ascii
	ConvertResultToAscii:
		move	$a0, $t5
		# Call function to convert result number to char
		jal	num2char
		sb	$v0, 0($s7)	# Store result in myArray[5]
		
    ######################## Display Polling Begin #######End#################
	
    # SHOULD NOT NEED THE LINE BELOW!
    #lui	$t0, 0xFFFF
    # Reset array index back to 0 by loading myArray
    la $s7, myArray
    
    # load first element in myArray for display
    lb $t7, 0($s7)
    
    li	$t9, 0			#reset "i" counter to zero i=0
       
    DisLoop:
	# Check for null character, if == null then we are done, exit
	    beqz $t7, exit
       	    # Store the character in myArray[i] representing characters of sum "a+b=z"
	    # into transmitter data
	    sb	$t7, 12($t0)

	printToScreenLoop: 
	    
        	lw      $t1, 8($t0)         # $t1 holds content of Transmitter Control == 0xFFFF0008
      		andi    $t2, $t1, 0x0001    # Bitwise operation to set ready bit
      		
      		# increment array to next char, myArray{i++]
      		addi	$s7, $s7, 1
      		
       		 beq     $t2, $zero, printToScreenLoop# If not ready loop again
		
       		 lb	$t7, 0($s7)
       		 # Might swap this once I get it working!
       		 #sw		$s0, 12($t0)		# $s0 holds the char to display
                                    # +12 is address 0xFFFF0000
                 j DisLoop

    ######################## Display Polling End ########################
   
  	exit:
  		li	$v0, 10
  		syscall
   
char2num:
	lb $t0, asciiZero
	subu $v0, $a0, $t0
	jr $ra

num2char:
	lb $t0, asciiZero
	addu $v0, $a0, $t0
	jr $ra

