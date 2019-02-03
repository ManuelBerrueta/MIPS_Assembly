# Requirements:
    # Task a. Read a string from keyboad whose length is at most 64.
    # Task b. Delete the last appearance of character 'a' from the string (assume that the string always contains at least an 'a').
    # Task c. Print the string to terminal.

.data
    buffer:     .space  64 # Allocates memory space for string size 64 bytes
    newStr:     .space  64 # Allocates memory space for string without last 'a'
    char_a:     .asciiz "a"
    notNull:    .asciiz "buffer is not null\n"


.text
.globl main

main:
        # Task a.
        # Read string from io with max lenght of 64 byte
        # and save into buffer

                            # $a0 is an argument register for function calls
        la      $a0, buffer # Load address of buffer in to argument register $a0
        li      $a1, 64     # Allocate space of 64 bytes max in io for input string
        li		$v0, 8		# 8 = opcode to read string from keyboard                            
		syscall				# Systemcall of prior instruction(8) and arguments($a0,$a1)
                            # Stored input string in $a0

        #Test code prints input string
        #li      $v0, 4
        #syscall

        la      $t1, char_a   # Loads memory address of char_a into $t1
        lbu     $t0, 0($t1)   # Loads 'a' from memory into $t0
        
        la      $s0, buffer   # Load address of buffer in to register $s0
        la		$s2, newStr   # Load address of newStr in to register $s2
        

        # Test code to verify 'a' loaded
        #la      $a0, 0($t1)
        #li      $v0, 4
        #syscall

        # Test code to verify $s0 holds string loaded
        #la      $a0, 0($s0)
        #li      $v0, 4
        #syscall

        # PASSED TEST UP TO HERE

        # Task b.
        # Delete the last appearance of character 'a' from the string.
        # (assume that the string always contains at least an 'a').

        # Loop to count number of 'a' in the string
        # 
        # 2nd Loop when 'a' is found and counter = Number of 'a' found
        # delete 'a', mean that reg = $zero

        # $t0 -------> 'a'
        # $s0 -------> buffer address
        # $s2 -------> address of newStr
        # $t1 -------> contents of buffer[i]
        # $t9 -------> sizeOfStrCounter
        
        li		$t9, 0		# $t9 = 0 
        li		$s1, 0		# $ts1 = 0

        # CountaLoop traverses through string, finds how many 'a's there is, & counts size of string
        CountaLoop:
            lbu     $t1, 0($s0)         # Loads contents of buffer[i] element
            
            # Checks if the string is null
            beq		$t1, $zero, deleteFunc	# if $t1 == null char then deleteFunc
            addi    $t9, $t9, 1         # Counter for size of string
            bne     $t0, $t1, Else      # If a != $t1 then Else
            addi	$s1, $s1, 1 		# s1++ counter of 'a' in string
        
            #
            Else:
                # Test code to check string index moving
                la      $a0, 0($s0)
                li      $v0, 4
                syscall

                addi    $s0, $s0, 1     # Shifts index of string by 1
                j		CountaLoop	    # jump to CountaLoop
        

        deleteFunc:
                addi	$t9, $t9, -1	 # $t9 size counter -1
                la      $s0, buffer   # Load address of buffer in to register $s0
                la		$s2, newStr   # Load address of newStr in to register $s2
        # $s1 -----> count of 'a' in string
        # #s0 -----> buffer
        # $s2 -----> newString
        # $t9 -----> size of newStr

        # Loop going through buffer string 2nd time
        # Starts copying old string to new string
        # Then jumps to skip copying the last 'a'
        # hence "deleting" it, and jumpts to print when done
        findLastaLoop:
                # Checks if the string is null

                beq		$t9, $zero, Print	# if $t19 == 0, copying is done, Print newStr
                lbu     $t1, 0($s0)         # Loads contents of current index
                beq		$t1, $zero, Print	# if $t1 == null char Print
                
                beq     $t0, $t1, delete_a_Loop      # If a == $t1 then delete_a_loop

        Checked_a:
                sb      $t1, 0($s2)        # Store contents of $s0 elementf into s2
                
                # Test code to check string index moving backwards
                la      $a0, 0($s0)
                li      $v0, 4
                syscall
                
                #if newCounter == #s1 counter, remove a from string
                addi    $s0, $s0, 1    # Shifts index of buffer 1
                addi    $s2, $s2, 1     # Shift index of newStr 1
                addi	$t9, $t9, -1	 # $newStr size counter -1
                
                j       findLastaLoop


        # Loop for when an 'a' is found, if is the last/only 'a'  then
        # jump to delete_a to skip over that a ("delete")
        # Else jump back into loop
        delete_a_Loop:
                addi	$s1, $s1, -1    # 'a' counter -1
                beq		$s1, $zero, deleted_a	#if counter ==0 then this must be last 'a'
                                                # jump to delete 'a' at deleted_a
                j Checked_a

        # skip copying the last 'a'
        deleted_a:
                addi    $s0, $s0, 1     #move index of $s0 + 1 to "delete" the a
                j findLastaLoop

        # Task c - Print new string with deleted last 'a'
        Print:
                la $a0, newStr
                li $v0, 4	# 4 to print out strings & char
                syscall
        Exit:
                li		$v0, 10	  #exit code
                syscall