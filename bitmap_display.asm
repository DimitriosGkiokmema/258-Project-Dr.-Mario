##############################################################################
# Example: Displaying Pixels
#
# This file demonstrates how to draw pixels with different colours to the
# bitmap display.
##############################################################################

######################## Bitmap Display Configuration ########################
# - Unit width in pixels: 8
# - Unit height in pixels: 8
# - Display width in pixels: 256
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
##############################################################################
    .data
ADDR_DSPL:
    .word 0x10008000

    .text
	.globl main

main:
    li $t1, 0xff0000        # $t1 = red
    li $t2, 0x00ff00        # $t2 = green
    li $t3, 0x0000ff        # $t3 = blue

    lw $t0, ADDR_DSPL       # $t0 = base address for display
    sw $t1, 0($t0)          # paint the first unit (i.e., top-left) red
    sw $t2, 4($t0)          # paint the second unit on the first row green
    sw $t3, 128($t0)        # paint the first unit on the second row blue
    
    #####################################
    # Everything above is starter code
    #####################################
    # Drawing pixels
    add $t4, $t1, $t2
    sw $t4, 8( $t0 )
    add $t5, $t2, $t3
    sw $t5, 12( $t0 )
    add $t6, $t1, $t3
    sw $t6, 16( $t0 )
    add $t7, $t6, $t2
    
    ########### Loops   ##########
    # Draw left wall
    add $t5, $zero, $zero # Initilaize loop variable to 0. $zero is always zero
    addi $t6, $zero, 26 # set $t6 as the final value of the loop var
    addi $t7, $t0, 624 #calculate the starting position of the line
    
    draw_left_wall: # the beginning of the line drawing loop
    sw $t4, 20( $t7 ) # draw a white pixel at the location specified by $t7
    addi $t5, $t5, 1 # increment $t5 (loop var) by one
    addi $t7, $t7, 128 # move $t7 to next row
    beq $t5, $t6, draw_bottom_wall # breaks loop and calls draw_loop_end
    j draw_left_wall
    
    # Draw bottom wall
    add $t5, $zero, $zero # Initilaize loop variable to 0. $zero is always zero
    addi $t6, $zero, 26 # set $t6 as the final value of the loop var
    addi $t7, $t0, 4048 #calculate the starting position of the line
    
    draw_bottom_wall:
    sw $t4, 0( $t7 ) # draw a white pixel at the location specified by $t0
    addi $t5, $t5, 1 # increment $t5 (loop var) by one
    addi $t7, $t7, 1 # move $t7 to next pixel in the row
    beq $t5, $t6, draw_right_wall # breaks loop and calls draw_loop_end
    j draw_bottom_wall
    
    # Draw right wall
    draw_right_wall:
    
exit:
    li $v0, 10              # terminate the program gracefully
    syscall
