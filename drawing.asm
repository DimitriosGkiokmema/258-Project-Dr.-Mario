    .data
ADDR_DSPL:
    .word 0x10008000 # The address of the bitmap display.
    
    # Padding to give enough space for the display
    .space 262144    # 256 x 256 x 4 = 262144

    .text
	.globl main

main:
    li $t1, 0xff0000        # $t1 = red
    li $t2, 0x00ff00        # $t2 = green
    li $t3, 0x0000ff        # $t3 = blue
    lw $t0, ADDR_DSPL       # $t0 = base address for display
    
    # Calculating colours, setting them to regs
    add $t4, $t1, $t2
    add $t5, $t2, $t3
    add $t6, $t1, $t3
    add $t7, $t6, $t2
    
    ########### Functions ##########
    ## The line drawing function ##
    # Args:
    # - $a0: X cord
    # - $a1: Y cord
    # - $a2: Length of the line
    # - $a3: direction of line
    
    ## Call below function to draw container ##
    # left entry wall
    addi $a0, $zero, 15   # X
    addi $a1, $zero, 10   # Y
    addi $a2, $zero, 3  # Length
    addi $a3, $zero, 256 # determines directions of line. 256 for vertical, 4 for horizontal
    jal initialize_and_draw
    
    # top left wall
    # No need to reset x and y, since we want them to stay the same
    addi $a2, $zero, 8  # Length
    addi $a3, $zero, -4 # direction
    jal draw_line
    
    # left wall
    addi $a2, $zero, 25  # Length
    addi $a3, $zero, 256 # direction
    jal draw_line
    
    # bottom wall
    addi $a2, $zero, 20  # Length
    addi $a3, $zero, 4   # direction
    jal draw_line
    
    # right wall
    addi $a2, $zero, 25  # Length
    addi $a3, $zero, -256 # direction
    jal draw_line
    
    # top right wall
    addi $a2, $zero, 8  # Length
    addi $a3, $zero, -4 # direction
    jal draw_line
    
    # right entry wall
    addi $a2, $zero, 4  # Length
    addi $a3, $zero, -256 # direction
    jal draw_line

    j exit     # Skips the line function, so it doesn't get called accidentally
    
    # Main line drawing loop
    initialize_and_draw:
    sll $a0, $a0, 2     # add the horizontal offset to the offset to the previous location, to get to the starting point for the line.
    sll $a1, $a1, 8      # add the vertical offset to the previous location, to get to the correct starting row. 2**7 = 128
    add $a0, $a0, $a1    # add vertical and horizontal offsets to $a0
    add $a0, $a0, $t0    # add starting address of bitmap
    
    draw_line:      # the starting label for the pixel drawing loop
    beq $a2, $zero, draw_line_end # break out of loop if stop cond is met
    # The below line ACTS LIKE MULT, by shifting the results. Mult would have needed another line of code
    sw $t7, 0( $a0 )     # paint the current bitmap location yellow
    addi $a2, $a2, -1    # decrement loop var
    add $a0, $a0, $a3     # move to next pixel in row
    j draw_line   # jump to the top of the loop
    draw_line_end:      # end for loop
    jr $ra

exit:
    li $v0, 10              # terminate the program gracefully
    syscall
