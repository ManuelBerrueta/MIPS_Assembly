#Print out dube root of 3
# Newton's Method For cube root of 3:
#      [(2*f(k) + (3/F^2(k))] /3
# $f0 ----> m, in this case m = 3
# $f1 ----> 3.0 #square root
# $f2 ----> F(k) = 1 @ start
# $f4 ----> computation holder
# $f5 ---> precision of 1*10^-3
# $f6 ---> Divisor
# $f7 ---> 2.0 for multiplication

.data
    precision: .float 0.001  # 1*10^-3

.text
.globl main

main:

Precision_Control:
    l.s         $f5, precision	# Precision to 10^-3

    li          $s0, 3          # m = 2
    mtc1        $s0, $f0
    cvt.s.w     $f0, $f0        # f0 = 2.0

    li          $s1, 3          # Squareroot
    mtc1        $s1, $f1
    cvt.s.w     $f1, $f1        # f1 = 2.0  
    
    li          $s2, 1          # F(k) = 1
    mtc1        $s2, $f2
    cvt.s.w     $f2, $f2        # $f2 = 1.0
    
    li          $s3, 2          # F(k) = 1
    mtc1        $s3, $f7
    cvt.s.w     $f7, $f7        # $f2 = 1.0

Loop:
    mul.s	$f4, $f2, $f2
    div.s       $f4, $f0, $f4   # $f4 = 3 / F(k)^2
    mul.s	$f6, $f7, $f2	 # $F6 = 2* F(k)
    
    add.s       $f4, $f4, $f6   # $f4 = 2 * F(k) +  3/F(k)^2
    div.s       $f4, $f4, $f1   # $f3 holds F(K+1) = 2 * F(k) + 3/F(k)^2) / 3

    sub.s       $f6, $f4, $f2   # Subtracts: F(k+1) - 3
    abs.s       $f6, $f6        # | F(k+1) - 3 |
    c.le.s      $f6, $f5
    bc1t        done
    mov.s	 $f2, $f4		
    j           Loop

done:
    mov.s $f12, $f4   # Move contents of $f4 to register $f12
    li $v0, 2
    syscall

    li $v0, 10
    syscall
