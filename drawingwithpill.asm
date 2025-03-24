##############################################################################
# Draws lines + pixels
# Given x, y, length, and a direction, this draws the line
# If given length 1, a single pixel is drawn
# 256x256 --> 2x2
##############################################################################
    .data
color_array:        .space      12
pill_array:         .space      16
ADDR_DSPL:          .word 0x10008000 # The address of the bitmap display.
ADDR_KBRD:          .word 0xffff0000
block_array:        .space 12
grid:               .word 0:456     # Array of all pixels in the bottle
                                    # 24 row * 19 column grid = 456 elements
                                    # Values: 0 empty spot,         In Memory:  0x0
                                    #         l pair block at left              0x6c
                                    #         r pair block at right             0x72
                                    #         u pair block up                   0x75
                                    #         d pair block below                0x64
                                    #         s single block (no pair)          0x73
                                    #         v virus                           0x76

    # Padding to give enough space for the display
    .space 262144    # 256 x 256 x 4 = 262144

    .text
	.globl main
    
main:

    #DON'T CHANGE:
      #-Any s registers
      #-t0
      
    #######################################################
    # Draws Container
    #######################################################
    lw $s0, ADDR_DSPL      # $t0 = base address for display
    la $s1, pill_array
    la $s2, color_array #Initializing the color array
    li $s3, 0xff0000        # $t1 = red
    li $t3, 0x00ff00        # $t2 = green
    li $s4, 0x0000ff        # $t3 = blue
    
    # Calculating colours, setting them to regs
    add $s5, $s3, $t3 #yellow
    addi $t6, $zero, 0xffffff #white

    la $s7, block_array
    li $t1, 0x73 # $t1 = 's'
    li $t2, 0x75 # $t2 = 'u'
    li $t3, 0x64 # $t3 = 'd'
    sw $t1, 0($s7) # block_array[0] = 's'
    sw $t2, 4($s7) # block_array[1] = 'u'
    sw $t3, 8($s7) # block_array[2] = 'd'
    la $s6, grid            # $s1 holds the address of grid
    
    
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
    addi $a3, $zero, 256 # determines directions of line. 128 for vertical, 4 for horizontal
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

    j GENERATE_PILL    # Skips the line function, so it doesn't get called accidentally
    
    # Main line drawing loop
    initialize_and_draw:
    sll $a0, $a0, 2     # add the horizontal offset to the offset to the previous location, to get to the starting point for the line.
    sll $a1, $a1, 8      # add the vertical offset to the previous location, to get to the correct starting row. 2**7 = 128
    add $a0, $a0, $a1    # add vertical and horizontal offsets to $a0
    add $a0, $a0, $s0    # add starting address of bitmap
    
    draw_line:      # the starting label for the pixel drawing loop
    beq $a2, $zero, draw_line_end # break out of loop if stop cond is met
    # The below line ACTS LIKE MULT, by shifting the results. Mult would have needed another line of code
    sw $t6, 0( $a0 )     # paint the current bitmap location white
    addi $a2, $a2, -1    # decrement loop var
    add $a0, $a0, $a3     # move to next pixel in row
    j draw_line   # jump to the top of the loop
    draw_line_end:      # end for loop
    jr $ra

GENERATE_PILL:
    sw $s3, 0($s2) #color_array[0] = red
    sw $s4, 4($s2) #color_array[1] = blue
    sw $s5, 8($s2) #color_array[2] = yellow
    jal GENERATE_RANDOM_COLOR
    #sw $v0, 0($s1) 
    sw $v0, 2628($s0) #display the first pixel
    addi $a2, $s0, 2628 #assigns the location of the first byte to be passed as an argument
    jal GENERATE_RANDOM_COLOR
    #sw $v0, 8($s1)
    sw $v0, 2884($s0) #display the second pixel
    add $t6, $zero, 0 #counter for the S key
    add $a3, $zero, 0
    j detect_keyboard_input
    
  
  GENERATE_RANDOM_COLOR:
    li $v0 , 42
    li $a0 , 0
    li $a1 , 3 #generates a random number from (0,2), stores in $a0
    syscall 
    li $t6, 4
    mult $a0, $t6 #multiplies i by 4
    mflo $t7 #Stores 4i
    add $t8, $t7, $s2
    lw $v0, 0($t8) 
    jr $ra
  
  detect_keyboard_input:
    add $t1, $s0, 12136      # Address of bottom right pixel in container +
    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    
  	li 		$v0, 32  #sleep for 250ms --> 0.25s
  	li 		$a0, 450
  	syscall
  
    
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input      # If first word 1, key is pressed
  
  implement_gravity:
    jal Gravity  # Simulates gravity
    b detect_keyboard_input
  
  keyboard_input:                     # A key is pressed
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x73, respond_to_S     # Check if key s is pressed
    addi $t5, $t6, -3
    blez $t5, implement_gravity
    beq $a0, 0x71, respond_to_Q     # Check if key q was pressed ---> Can add the upper letters as an extension (maybe giving them special functions?)
    beq $a0, 0x61, respond_to_A     # Check if key a is pressed
    beq $a0, 0x64, respond_to_D     # Check if key d is pressed
    beq $a0, 0x77, respond_to_W     # Check if key w is pressed
    beq $a0, 0x65, respond_to_E     # Check if key e is pressed
  
    li $v0, 1                       # ask system to print $a0
    syscall
  
    b implement_gravity

  add_pill_to_array:
    lw $t1, 8($s7)
    sw $t1, 40($s6)

    lw $t1, 4($s7)
    sw $t1, 116($s6)
    addi $a3, $s6, 40 #pass the value of the index in the grid array
    j implement_gravity
  
  respond_to_Q: #Should quit the game
  	li $v0, 10                      # Quit gracefully
  	syscall
  
  respond_to_A: #Should move the capsule to the left
    lw $t1, 0($a2) #Store the color value in the first pixel
    sw $t1, -4($a2) #Paint the pixel on the left of first pixel
    sw $zero, 0($a2) #Paint the first pixel to black

    lw $t1, 0($a3)
    sw $t1, -4($a3)
    sw $zero, 0($a3) #change the value of the first pixel in the grid array
    
    lw $t1, 256($a2) #change the 256/252 values accordingly
    beq $t1, $zero, rpixel_lmove
    sw $t1, 252($a2)
    sw $zero, 256($a2)
    addi $a2, $a2, -4

    lw $t1, 76($a3)
    sw $t1, 72($a3)
    sw $zero, 76($a3)
    addi $a3, $a3, -4
    
    j implement_gravity
  
  rpixel_lmove:
    lw $t1, 4($a2) #Store the color value in the first pixel
    sw $t1, 0($a2) #Paint the pixel on the left of first pixel
    sw $zero, 4($a2) #Paint the first pixel to black
    addi $a2, $a2, -4

    lw $t1, 4($a3)
    sw $t1, 0($a3)
    sw $zero, 4($a3) #change the value of the second pixel in the grid array
    addi $a3, $a3, -4 #fix the a3 value
    
    j implement_gravity
  
  respond_to_D: #Should move the capsule to the right
    lw $t1, 256($a2) #change the 256/252 values accordingly
    beq $t1, $zero, rpixel_rmove
    sw $t1, 260($a2) #move bottom pixel
    sw $zero, 256($a2)

    lw $t1, 76($a3)
    sw $t1, 80($a3)
    sw $zero, 76($a3)
  
  lpixel_rmove:
    lw $t1, 0($a2) #Store the color value in the second pixel
    sw $t1, 4($a2) #Paint the pixel on the right of second pixel
    sw $zero, 0($a2) #Paint the second pixel to black
    addi $a2, $a2, 4

    lw $t1, 0($a3)
    sw $t1, 4($a3)
    sw $zero, 0($a3)
    addi $a3, $a3, 4
    
    j implement_gravity
  
  rpixel_rmove:
    lw $t1, 4($a2)
    sw $t1, 8($a2)
    sw $zero, 4($a2) 

    lw $t1, 4($a3)
    sw $t1, 8($a3)
    sw $zero, 4($a3)
    
    j lpixel_rmove
  
  respond_to_E: #Should rotate the capsule by 90 degrees anti-clockwise
    lw $t1, 4($a2) #stores the color value of the pixel to the right of the first pixel
    beq $t1, $zero, bpixel_rotate_anti
    sw $t1, -256($a2)
    sw $zero, 4($a2)
    addi $a2, $a2, -256

    lw $t1, 4($a3)
    sw $t1, -76($a3)
    sw $zero, 4($a3)
    addi $a3, $a3, -76
    
    j implement_gravity
  
  bpixel_rotate_anti:
    lw $t1, 0($a2)
    sw $t1, 252($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 252

    lw $t1, 0($a3)
    sw $t1, 72($a3)
    sw $zero, 0($a3)
    addi $a3, $a3, 72
    
    j implement_gravity
  
  respond_to_W: #Should rotate capsule by 90 degrees clockwise
    lw $t1, 4($a2) #stores the color value of the pixel to the right of the first pixel
    beq $t1, $zero, bpixel_rotate_clock
    lw $t1, 0($a2)
    sw $t1, -252($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, -252

    lw $t1, 0($a3)
    sw $t1, -72($a3)
    sw $zero, 0($a3)
    addi $a3, $a3, -72
    
    j implement_gravity
  
  bpixel_rotate_clock:
    lw $t1, 0($a2)
    sw $t1, 260($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 256

    lw $t1, 0($a3)
    sw $t1, 80($a3)
    sw $zero, 0($a3)
    addi $a3, $a3, 76
    
    j implement_gravity
  
  respond_to_S: #Should move the capsule to the bottom
    lw $t1, 4($a2)
    beq $t1, $zero, bpixel_down
    sw $t1, 260($a2)
    sw $zero, 4($a2)

    beq $a3, $zero, fpixel_down
    lw $t1, 4($a3)
    sw $t1, 80($a3)
    sw $zero, 4($a3)
  
  fpixel_down:
    lw $t1, 0($a2)
    sw $t1, 256($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 256

    beq $a3, $zero, end_of_S_loop
    lw $t1, 0($a3)
    sw $t1, 76($a3)
    sw $zero, 0($a3)
    addi $a3, $a3, 76

  end_of_S_loop:  
    add $t6, $t6, 1
    beq $t6, 4, add_pill_to_array
    j implement_gravity
  
  bpixel_down:
    lw $t1, 256($a2)
    sw $t1, 512($a2)
    sw $zero, 256($a2)

    beq $a3, $zero, fpixel_down
    lw $t1, 76($a3)
    sw $t1, 152($a3)
    sw $zero, 76($a3)
    j fpixel_down


Gravity:
  
  bring_down:
    add $t4, $zero, 1748      # Max i is 456 - 24 (since we start on the second last row) elements * 4 = 1748 + bitmap address
    
  bring_down_loop:
    add $t0, $t4, $s6
    beq $t4, $zero, exit_row_loop     # $t0 is at first index, so loop must terminate
    
    # Conditionals to check if we can/should bring down a pixel
    # If bitmap pixel is 's', 'u', or 'd'
    # If column below is empty
    lw $t2, 0($t0)  # loads the value in the grid array at the current index
    
  check_s:
    lw $t3, 0($s7)  # loads first block value from block_array: 's'
    beq $t2, $t3, check_below_row
    
  check_u:
    lw $t3, 4($s7)  # loads second block value from block_array: 'u'
    beq $t2, $t3, check_below_row
    
  check_d:
    lw $t3, 8($s7)  # loads first block value from block_array: 'd'
    beq $t2, $t3, check_below_row
    
    # If this is reached, the above beq were false, so check_below_row should be skipped
    j decrement
    
  check_below_row:
    lw $t2, 76($t0) # Loads the value in the grid array right below the current index
                      # [r + 1][c] in this case is #t0 + 19 * 4 = $t0 + 76
    beq $t2, $zero, move_down   # row below is empty, so we can move down the block
    
    # If this is reached, the above beq were false, so move_down should be skipped
    j decrement
    
  move_down:
    lw $t2, 0($t0)
    sw $t2, 76($t0)     # Stores the value of [r][c] to [r + 1][c]
    sw $zero, 0($t0)    # Clears the value of [r][c] as we just moved it
    
    #sub $t5, $zero, $t4 #Something wrong with the draw function --> fix it
    #add $t6, $t5, 1748 #index of element
    #add $t6, $t6, $s0
    #lw $t7, 0($t6)
    #sw $t7, 256($t6) 60 + 2560
    addi $t5, $s0, 3356 #it does access the top left block 
    addi $t6, $zero, 4
    div $t4, $t6
    mflo $t7
    addi $t6, $zero, 19
    div $t7, $t6
    mflo $t6 #row
    mfhi $t8 #column
    sll $t8, $t8, 2 #multiply by 4
    sll $t6, $t6, 8 #multiply by 256
    addi $t8, $t8, 256 #check sometime --> why we don't need to add 4 sideways as well
    add $t5, $t5, $t8
    add $t5, $t5, $t6

    beq $t5, $a2, change_as

   continue_bring_down:
    lw $t6, 0($t5)
    sw $t6, 256($t5)
    sw $zero, 0($t5)
     
    
  decrement:
    # Decrimenting loop variables
    # This is preparing the index value for the next iteration of the loop
    add $t4, $t4, -4        # Decrimenting array address
    
    # Loop again
    j bring_down_loop               # calls the next iteration of the outer loop
    
  exit_row_loop:
    jr $ra      # Jumps to update_matrix

   change_as:
    addi $a2, $a2, 256
    beq $a3, $zero, continue_bring_down
    addi $a3, $a3, 76
    j continue_bring_down
    

exit:
    li $v0, 10              # terminate the program gracefully
    syscall
