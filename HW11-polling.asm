#Polling for keyboard in put for two numbers and prints out the result

.text
.globl	main
main:	
    
    ######################## Keyboard Polling Begin ########################
    lui $t0, 0xFFFF                 #$t0 holds address of Receiver Control

    KeyLoop:
        lw		$t1, 0($t0)		    # $t1 holds content of Receiver Control
        andi    $t2, $t1, 0x0001    # Bitwise operation that holds the ready bit
                                    # Logic: If the result of the bitwise and operation
                                    # == 1, then it is the case that the Receiver Control is ready,
                                    # else if the results of the bitwse and operation is == 0 then
                                    # it is not the case that the Receiver Control is ready
                                    
        beq		$t2, $zero, KeyLoop	# If $t2 == zero, that is, if Receiver Control is NOT ready
                                    # Loop: again.

        lw      $t1, 4($t0)         # $t1 holds keyboard char
    ######################## Keyboard Polling End ########################

    ######################## Display Polling Begin #######End#################
    DisLoop:
        lw      $t1, 8($t0)         # $t1 holds content of Transmitter Control
        andi    $t2, $t1, 0x0001    # $t2 holds ready bit
        beq     $t2, $zero, DisLoop # If not ready loop again

        sw		$s0, 12($t0)		# $s0 holds the char to display
                                    # +12 is address 0xFFFF0000

    ######################## Display Polling End ########################




.ktext