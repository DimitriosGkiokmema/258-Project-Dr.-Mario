##############################################################################
# Draws lines + pixels
# Given x, y, length, and a direction, this draws the line
# If given length 1, a single pixel is drawn
# 256x256 --> 2x2
##############################################################################
    .data
color_array:        .space      12
pill_array:         .space      16
ADDR_KBRD:          .word 0xffff0000
game_over:          .word 0, 1, 1, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1
                          1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0
                          1, 1, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0
                          1, 1, 0, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 0, 1, 1, 1, 1, 1
                          1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0
                          1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0
                          0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1
                          0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
                          0, 1, 1, 1, 0, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0
                          1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1
                          1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1
                          1, 0, 0, 0, 1, 0, 1, 1, 0, 0, 0, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 1, 1
                          1, 0, 0, 0, 1, 0, 0, 1, 1, 0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 0
                          1, 0, 0, 0, 1, 0, 0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0, 1, 1, 1, 0
                          0, 1, 1, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 1, 1, 1
dr_mario:           .word 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0
                          0, 0, 0, 1, 1, 1, 1, 8, 6, 1, 0, 0
                          0, 0, 4, 4, 4, 4, 4, 8, 6, 0, 0, 0
                          0, 0, 1, 1, 1, 2, 2, 3, 2, 0, 0, 0
                          0, 1, 2, 1, 2, 2, 2, 3, 2, 2, 2, 0
                          0, 1, 2, 1, 1, 2, 2, 2, 3, 2, 2, 2
                          0, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 0
                          0, 0, 0, 2, 2, 2, 2, 2, 2, 2, 0, 0
                          0, 0, 6, 6, 7, 6, 5, 5, 0, 0, 0, 0
                          0, 6, 6, 6, 6, 7, 5, 6, 6, 6, 0, 0
                          6, 6, 6, 6, 6, 6, 7, 6, 6, 6, 6, 6
                          7, 7, 6, 6, 6, 6, 7, 7, 6, 6, 7, 7
                          8, 8, 8, 6, 6, 6, 6, 6, 6, 8, 8, 8
                          8, 8, 6, 6, 6, 6, 6, 6, 6, 6, 8, 8
                          0, 0, 4, 4, 4, 0, 0, 4, 4, 4, 0, 0
                          0, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 0
                          1, 1, 1, 1, 0, 0, 0, 0, 1, 1, 1, 1
block_array:        .space 24
grid:               .word 0:456     # Array of all pixels in the bottle
                                    # 24 row * 19 column grid = 456 elements
                                    # Values: 0 empty spot,         In Memory:  0x0
                                    #         l pair block at left              0x6c
                                    #         r pair block at right             0x72
                                    #         u pair block up                   0x75
                                    #         d pair block below                0x64
                                    #         s single block (no pair)          0x73
                                    #         v virus                           0x76
                                    
ADDR_DSPL:          .word 0x10008000 # The address of the bitmap display.
    # Padding to give enough space for the display
    .space 262144    # 256 x 256 x 4 = 262144

    .text
	.globl main
    
main:

    #DON'T CHANGE:
      #-Any s registers
      
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

    sw $s3, 0($s2) #color_array[0] = red
    sw $s4, 4($s2) #color_array[1] = blue
    sw $s5, 8($s2) #color_array[2] = yellow
    
#############################
# Draws Dr Mario
#############################
DR_MARIO:
    li $t1, 48  # column number
    li $t5, 17  # row number
    la $s0, dr_mario       # Load address of image data
    jal DRAW_ARRAY
    
    # Reseting initial values, as DRAW_ARRAY Changed them
    lw $s0, ADDR_DSPL      # $t0 = base address for display
    la $s1, pill_array
    la $s2, color_array #Initializing the color array
    li $s3, 0xff0000        # $t1 = red
    li $t3, 0x00ff00        # $t2 = green
    li $s4, 0x0000ff        # $t3 = blue

    la $s7, block_array
    li $t1, 0x73 # $t1 = 's'
    li $t2, 0x75 # $t2 = 'u'
    li $t3, 0x64 # $t3 = 'd'
    sw $t1, 0($s7) # block_array[0] = 's'
    sw $t2, 4($s7) # block_array[1] = 'u'
    sw $t3, 8($s7) # block_array[2] = 'd'
    
    li $t1, 0x6c # $t1 = 'l'
    li $t2, 0x72 # $t1 = 'r'
    li $t3, 0x76 # $t1 = 'v'
    sw $t1, 12($s7)
    sw $t2, 16($s7)
    sw $t3, 20($s7)
    
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

    add $a2, $zero, 0
    jal Generate_Random_Virus
    add $a2, $zero, 4
    jal Generate_Random_Virus
    add $a2, $zero, 8
    jal Generate_Random_Virus
    
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

Generate_Random_Virus:
    li $v0 , 42
    li $a0 , 0
    li $a1 , 366 #generates a random number from (0,3034), stores in $a0
    syscall #needs to store the value in the bitmap/display and the array

    addi $a0, $a0, 90
    addi $t5, $s0, 3356 #access the top left block
    addi $t6, $zero, 19 #original 19
    div $a0, $t6
    mflo $t6 #row
    mfhi $t8 #column
    beq $t8, $zero, change_values_virus
  continue_generating_virus:
    sll $t8, $t8, 2 #multiply by 4
    sll $t6, $t6, 8 #multiply by 256
    addi $t8, $t8, 256 
    add $t5, $t5, $t8
    add $t5, $t5, $t6
    add $t7, $a2, $s2
    lw $t6, 0($t7) #needs to store color
    lw $t8, 0($t5)
    bne $t8, $zero, Generate_Random_Virus 
    sw $t6, 0($t5)

    addi $t5, $zero, 4
    mult $a0, $t5
    mflo $t5
    add $t5, $t5, $s6
    lw $t6, 20($s7)
    sw $t6, 0($t5)

    jr $ra

  change_values_virus:
    addi $t8, $zero, 19 
    addi $t6, $t6, -1
    j continue_generating_virus
    

#############################
# Draws 'GAME OVER' and gives option to exit/restart game
#############################
GAME_OVER:
    addi $t1, $zero, 116 #column number
    addi $t5, $zero, 15 #row number
    la $s0, game_over       # Load address of image data
    jal DRAW_ARRAY
    jal RESTART_GAME
    j exit

DRAW_ARRAY: # lw $s3, 8($s2)          # Load the colour red to $s3
    lw $s1, ADDR_DSPL       # Framebuffer base address
    la $s2, color_array     # Load address of colour array

    addi $t2, $zero, 0 #index 
    addi $t7, $zero, 4 #number to increment by

    add $v1, $s1 11332     # Address to bottom of bitmap
    j Loop
    
Loop:
    div $t2, $t1 #find which row and column we are
    mfhi $t8 #remainder
    mflo $t4 #result
    beq $t4, $zero, Inside #If column == 0, continue to inside of the loop
    beq $t8, $zero, increment_y #if row == 0, increment y by 1 (address by 256)

Inside:
    add $t9, $v1, $t8 # t9 = display address[i] in the current row
    add $t3, $t2, $s0 # t3 = image[i]
    lw $t3, 0($t3) #Load the value at index image[i]
    addi $t2, $t2, 4 #Increment i by 4
    beq $t3, 0, Loop #Check if value at image[i] is 0, if yes then skip
    sw $s3, 0($t9) #Draw a colored pixel at index display_address[i]
    j Loop #continue looping

increment_y:
    addi $v1, $v1, 256 #increment address by 1 row
    beq $t4, $t5, end_drawing #Check if we have reached the 15th row, end the program if we have
    j Inside #jump to where you were called

end_drawing:
  jr $ra
  
RESTART_GAME:                       # A key is pressed
    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x72, restart          # Check if key s is pressed
    beq $a0, 0x71, exit             # Check if key q is pressed, exit if so
    j RESTART_GAME                  # Infinite loop until user restarts/ends game

restart:
    lw $a1, ADDR_DSPL
    addi $a0, $a1, 16380
    j paint_it_black
paint_it_black:
    beq $a0, $a1, main
    sw $zero, 0($a0)
    addi $a0, $a0, -4
    j paint_it_black

GENERATE_PILL:
    addi $t9,$s0, 3652  # Location on bitmap of bottle mouth
    lw $t9, 0($t9)
    bne $t9, $zero, GAME_OVER # If bottle mouth is not empty, game ends
    # The above is true, even when the pixel is empty! Why?
    
    jal GENERATE_RANDOM_COLOR
    #sw $v0, 0($s1) 
    sw $v0, 2628($s0) #display the first pixel
    addi $a2, $s0, 2628 #assigns the location of the first byte to be passed as an argument
    jal GENERATE_RANDOM_COLOR
    #sw $v0, 8($s1)
    sw $v0, 2884($s0) #display the second pixel
    add $t6, $zero, 0 #counter for the S key
    add $a3, $zero, 0
    add $t5, $zero, 0
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
    
  	# li 		$v0, 32  #sleep for 250ms --> 0.25s
  	# li 		$a0, 450
  	# syscall
  
    
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input      # If first word 1, key is pressed
  
  implement_gravity:
    jal Gravity  # Simulates gravity
  continue_gravity:
    blez $t5, loop_keyboard_detect
    blez $t1, GENERATE_PILL
  loop_keyboard_detect:
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
    beq $a0, 0x70, respond_to_P     # Check if key p is pressed
  
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
    lw $a1, 0($a3) #r or d?
    lw $t2, 16($s7) #load r
    beq $a1, $t2, check_ll_empty
    lw $t2, 8($s7) #load d
    beq $a1, $t2, check_dl_empty
    j implement_gravity

   continue_A: 
    lw $t1, 0($a2) #Store the color value in the first pixel
    sw $t1, -4($a2) #Paint the pixel on the left of first pixel
    sw $zero, 0($a2) #Paint the first pixel to black

    lw $t1, 0($a3)
    sw $t1, -4($a3)
    sw $zero, 0($a3) #change the value of the first pixel in the grid array
    
    lw $t1, 256($a2) #change the 256/252 values accordingly
    lw $t2, 16($s7) #load r
    beq $a1, $t2, rpixel_lmove
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

  check_ll_empty:
    lw $t1, -4($a2)
    bne $t1, $zero, implement_gravity
    j continue_A
  check_dl_empty:
    lw $t1, 252($a2)
    bne $t1, $zero, implement_gravity
    lw $t1, -4($a2)
    bne $t1, $zero, implement_gravity
    j continue_A
  
  respond_to_D: #Should move the capsule to the right
    lw $a1, 0($a3) #r or d?
    lw $t2, 16($s7) #load r
    beq $a1, $t2, check_rr_empty
    lw $t2, 8($s7) #load d
    beq $a1, $t2, check_dr_empty
    j implement_gravity
    
  continue_D:
    lw $t1, 256($a2) #change the 256/252 values accordingly
    lw $t2, 16($s7) #load r
    beq $a1, $t2, rpixel_rmove
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

  check_rr_empty:
    lw $t1, 8($a2)
    bne $t1, $zero, implement_gravity
    j continue_D
  
  check_dr_empty:
    lw $t1, 260($a2)
    bne $t1, $zero, implement_gravity
    lw $t1, 4($a2)
    bne $t1, $zero, implement_gravity
    j continue_D
    
  
  respond_to_E: #Should rotate the capsule by 90 degrees anti-clockwise
    lw $a1, 0($a3) #r or d?
    lw $t2, 16($s7) #load r
    beq $a1, $t2, check_ra_empty
    lw $t2, 8($s7) #load d
    beq $a1, $t2, check_da_empty
    j implement_gravity
    
  continue_E:
    lw $t1, 4($a2) #stores the color value of the pixel to the right of the first pixel
    lw $t2, 8($s7) #load d
    beq $a1, $t2, bpixel_rotate_anti
    sw $t1, -256($a2)
    sw $zero, 4($a2)
    addi $a2, $a2, -256


    sw $zero, 4($a3)
    li $t1, 0x64 #'d'
    sw $t1, -76($a3)
    li $t1, 0x75 #'u'
    sw $t1, 0($a3)
    
    addi $a3, $a3, -76
    
    j implement_gravity
  
  bpixel_rotate_anti:
    lw $t1, 0($a2)
    sw $t1, 252($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 252


    sw $zero, 0($a3)
    li $t1, 0x6c #'l'
    sw $t1, 76($a3)
    li $t1, 0x72
    sw $t1, 72($a3)
    addi $a3, $a3, 72
    
    j implement_gravity

  check_ra_empty:
    lw $t1, -256($a2)
    bne $t1, $zero, implement_gravity
    j continue_E
  check_da_empty:
    lw $t1, 252($a2)
    bne $t1, $zero, implement_gravity
    j continue_E
  
  
  respond_to_W: #Should rotate capsule by 90 degrees clockwise
    lw $a1, 0($a3) #r or d?
    lw $t2, 16($s7) #load r
    beq $a1, $t2, check_rc_empty
    lw $t2, 8($s7) #load d
    beq $a1, $t2, check_dc_empty
    j implement_gravity
    
  continue_W:
    lw $t1, 4($a2) #stores the color value of the pixel to the right of the first pixel
    lw $t2, 8($s7) #load d
    beq $t2, $a1 bpixel_rotate_clock
    lw $t1, 0($a2)
    sw $t1, -252($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, -252

    sw $zero, 0($a3)
    li $t1, 0x75 # 'u'
    sw $t1, 4($a3)
    li $t1, 0x64 # 'd'
    sw $t1, -72($a3)
    addi $a3, $a3, -72
    
    j implement_gravity
  
  bpixel_rotate_clock:
    lw $t1, 0($a2)
    sw $t1, 260($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 256

    sw $zero, 0($a3)
    li $t1, 0x72 # 'r'
    sw $t1, 76($a3)
    li $t1, 0x6c # 'l'
    sw $t1, 80($a3)
    addi $a3, $a3, 76
    
    j implement_gravity

  check_rc_empty:
    lw $t1, -252($a2)
    bne $t1, $zero, implement_gravity
    j continue_W
  check_dc_empty:
    lw $t1, 260($a2)
    bne $t1, $zero, implement_gravity
    j continue_W
  
  respond_to_S: #Should move the capsule to the bottom
    beq $a3, $zero, continue_S
    lw $a1, 0($a3) #r or d?
    lw $t2, 16($s7) #load r
    beq $a1, $t2, check_rd_empty
    lw $t2, 8($s7) #load d
    beq $a1, $t2, check_dd_empty
    j implement_gravity
    
  continue_S:
    lw $t1, 4($a2)
    lw $t2, 8($s7) #load d
    beq $t2, $a1, bpixel_down
    beq $t1, $zero, bpixel_down
    sw $t1, 260($a2)
    sw $zero, 4($a2)

    lw $t2, 16($s7) #load r
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

  check_rd_empty:
    lw $t1, 256($a2)
    bne $t1, $zero, implement_gravity
    lw $t1, 260($a2)
    bne $t1, $zero, implement_gravity
    j continue_S
  check_dd_empty:
    lw $t1, 512($a2)
    bne $t1, $zero, implement_gravity
    j continue_S

  respond_to_P:
    lw $a0, 0($t0)
    bne $a0, $zero, check_p
    j respond_to_P
  check_p:
    lw $a0, 4($t0)                  # Load first word from keyboard
    beq $a0, 0x70, unpause_game             # Check if key q is pressed, exit if so
    j respond_to_P                  # Infinite loop until user restarts/ends game
    
  unpause_game:
    j implement_gravity

Gravity:

    addi $t1, $zero, 0
  
  bring_down:
    add $t4, $zero, 1748      # Max i is 456 - 24 (since we start on the second last row) elements * 4 = 1748 + bitmap address
    
  bring_down_loop:
    add $t0, $t4, $s6
    beq $t4, $zero, exit_row_loop     # $t0 is at first index, so loop must terminate
    
    # Conditionals to check if we can/should bring down a pixel
    # If bitmap pixel is 's', 'u', 'd', or 'l'
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

  check_l:
    lw $t3, 12($s7)  # loads first block value from block_array: 'l'
    beq $t2, $t3, check_bottom_left
    
    # If this is reached, the above beq were false, so check_below_row should be skipped
    j decrement

  check_bottom_left:
    lw $t2, 72($t0) # Loads the value in the grid array at [r + 1][c - 1]
                      # [r + 1][c - 1] in this case is #t0 + 18 * 4 = $t0 + 72
    beq $t2, $zero, check_right   # [r + 1][c - 1] is empty, so we check [r + 1][c]

    # If this is reached, the above beq were false, so check_right should be skipped
    j decrement
  check_right:
    lw $t2, 76($t0) # Loads the value in the grid array at [r + 1][c]
                      # [r + 1][c] in this case is #t0 + 19 * 4 = $t0 + 76
    beq $t2, $zero, move_down_horizontal_pill   # [r + 1][c] is also empty, so we can move down the piece

    # If this is reached, the above beq were false, so move_down_horizontal_pill should be skipped
    j decrement
  move_down_horizontal_pill:
    lw $t2, 0($t0)
    sw $t2, 76($t0)     # Stores the value of [r][c] to [r + 1][c]
    sw $zero, 0($t0)    # Clears the value of [r][c] as we just moved it
    addi $t0, $t0, -4   # Moves index to the left so that we can move the left block down
                        # Thus, we are now at [r][c - 1]
    lw $t2, 0($t0)
    sw $t2, 76($t0)     # Stores the value of [r][c - 1] to [r + 1][c - 1]
    sw $zero, 0($t0)    # Clears the value of [r][c - 1] as we just moved it
    addi $t0, $t0, 4    # Moves index back to its original position

    addi $t5, $s0, 3356 #it does access the top left block 
    addi $t6, $zero, 4
    div $t4, $t6
    mflo $t7
    addi $t6, $zero, 19 #original 19
    div $t7, $t6
    mflo $t6 #row
    mfhi $t8 #column
    beq $t8, $zero, change_values_horizontal
  continue_move_horizontal:
    sll $t8, $t8, 2 #multiply by 4
    sll $t6, $t6, 8 #multiply by 256
    addi $t8, $t8, 256 #check sometime --> why we don't need to add 4 sideways as well
    add $t5, $t5, $t8
    add $t5, $t5, $t6

    addi $t1, $t1, 2
    jal change_as_horizontal

   continue_bring_down_for_horizontal:
    lw $t6, 0($t5)
    sw $t6, 256($t5)
    sw $zero, 0($t5)

    lw $t6, -4($t5)
    sw $t6, 252($t5)
    sw $zero, -4($t5)
    
    j decrement         # The horizontal pill has moved down
    
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
    
    #sub $t5, $zero, $t4 
    #add $t6, $t5, 1748 #index of element
    #add $t6, $t6, $s0
    #lw $t7, 0($t6)
    #sw $t7, 256($t6) 60 + 2560
    addi $t5, $s0, 3356 #access the top left block 
    addi $t6, $zero, 4
    div $t4, $t6
    mflo $t7
    addi $t6, $zero, 19 #original 19
    div $t7, $t6
    mflo $t6 #row
    mfhi $t8 #column
    beq $t8, $zero, change_values
  continue_move:
    sll $t8, $t8, 2 #multiply by 4
    sll $t6, $t6, 8 #multiply by 256
    addi $t8, $t8, 256 #check sometime --> why we don't need to add 4 sideways as well
    add $t5, $t5, $t8
    add $t5, $t5, $t6

    addi $t1, $t1, 1
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
    j continue_gravity      # Jumps to update_matrix

  change_as:
    addi $a2, $a2, 256
    beq $a3, $zero, continue_bring_down
    addi $a3, $a3, 76
    j continue_bring_down


  change_as_horizontal:
    addi $a2, $a2, 256
    beq $a3, $zero, continue_bring_down_for_horizontal
    addi $a3, $a3, 76
    jr $ra

  change_values:
    addi $t8, $zero, 19 
    addi $t6, $t6, -1
    j continue_move  
    
  change_values_horizontal:
    addi $t8, $zero, 19 
    addi $t6, $t6, -1
    j continue_move_horizontal 

exit:
    li $v0, 10              # terminate the program gracefully
    syscall
