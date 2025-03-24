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

    # Padding to give enough space for the display
    .space 262144    # 256 x 256 x 4 = 262144

    .text
	.globl main
    
main:
    #######################################################
    # Draws Container
    #######################################################
    li $t2, 0xff0000        # $t1 = red
    li $t3, 0x00ff00        # $t2 = green
    li $t4, 0x0000ff        # $t3 = blue
    lw $s0, ADDR_DSPL      # $t0 = base address for display
    
    # Calculating colours, setting them to regs
    add $t5, $t2, $t3 #yellow
    addi $t6, $zero, 0xffffff #white
    
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
    la $s1, pill_array
    la $s2, color_array #Initializing the color array
    sw $t2, 0($s2) #color_array[0] = red
    sw $t4, 4($s2) #color_array[1] = blue
    sw $t5, 8($s2) #color_array[2] = yellow
    jal GENERATE_RANDOM_COLOR
    #sw $v0, 0($s1) 
    sw $v0, 2628($s0) #display the first pixel
    addi $a2, $s0, 2628 #assigns the location of the first byte to be passed as an argument
    jal GENERATE_RANDOM_COLOR
    #sw $v0, 8($s1)
    sw $v0, 2884($s0) #display the second pixel
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
  	li 		$v0, 32
  	li 		$a0, 1
  	syscall
  
    lw $t0, ADDR_KBRD               # $t0 = base address for keyboard
    lw $t8, 0($t0)                  # Load first word from keyboard
    beq $t8, 1, keyboard_input      # If first word 1, key is pressed
    b detect_keyboard_input
  
  keyboard_input:                     # A key is pressed
    lw $a0, 4($t0)                  # Load second word from keyboard
    beq $a0, 0x71, respond_to_Q     # Check if key q was pressed ---> Can add the upper letters as an extension (maybe giving them special functions?)
    beq $a0, 0x61, respond_to_A     # Check if key a is pressed
    beq $a0, 0x64, respond_to_D     # Check if key d is pressed
    beq $a0, 0x77, respond_to_W     # Check if key w is pressed
    beq $a0, 0x65, respond_to_E     # Check if key e is pressed
    beq $a0, 0x73, respond_to_S     # Check if key s is pressed
  
    li $v0, 1                       # ask system to print $a0
    syscall
  
    b detect_keyboard_input
  
  respond_to_Q: #Should quit the game
  	li $v0, 10                      # Quit gracefully
  	syscall
  
  respond_to_A: #Should move the capsule to the left
    lw $t1, 0($a2) #Store the color value in the first pixel
    sw $t1, -4($a2) #Paint the pixel on the left of first pixel
    sw $zero, 0($a2) #Paint the first pixel to black
  
    lw $t1, 256($a2) #change the 256/252 values accordingly
    beq $t1, $zero, rpixel_lmove
    sw $t1, 252($a2)
    sw $zero, 256($a2)
    addi $a2, $a2, -4
    j detect_keyboard_input
  
  rpixel_lmove:
    lw $t1, 4($a2) #Store the color value in the first pixel
    sw $t1, 0($a2) #Paint the pixel on the left of first pixel
    sw $zero, 4($a2) #Paint the first pixel to black
    addi $a2, $a2, -4
    j detect_keyboard_input
  
  respond_to_D: #Should move the capsule to the right
    lw $t1, 256($a2) #change the 256/252 values accordingly
    beq $t1, $zero, rpixel_rmove
    sw $t1, 260($a2)
    sw $zero, 256($a2)
  
  lpixel_rmove:
    lw $t1, 0($a2) #Store the color value in the second pixel
    sw $t1, 4($a2) #Paint the pixel on the right of second pixel
    sw $zero, 0($a2) #Paint the second pixel to black
    addi $a2, $a2, 4
    j detect_keyboard_input
  
  rpixel_rmove:
    lw $t1, 4($a2)
    sw $t1, 8($a2)
    sw $zero, 4($a2) 
    j lpixel_rmove
  
  respond_to_E: #Should rotate the capsule by 90 degrees anti-clockwise
    lw $t1, 4($a2) #stores the color value of the pixel to the right of the first pixel
    beq $t1, $zero, bpixel_rotate_anti
    sw $t1, -256($a2)
    sw $zero, 4($a2)
    addi $a2, $a2, -256
    j detect_keyboard_input
  
  bpixel_rotate_anti:
    lw $t1, 0($a2)
    sw $t1, 252($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 252
    j detect_keyboard_input
  
  respond_to_W: #Should rotate capsule by 90 degrees clockwise
    lw $t1, 4($a2) #stores the color value of the pixel to the right of the first pixel
    beq $t1, $zero, bpixel_rotate_clock
    lw $t1, 0($a2)
    sw $t1, -252($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, -252
    j detect_keyboard_input
  
  bpixel_rotate_clock:
    lw $t1, 0($a2)
    sw $t1, 260($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 256
    j detect_keyboard_input
  
  respond_to_S: #Should move the capsule to the bottom
    lw $t1, 4($a2)
    beq $t1, $zero, bpixel_down
    sw $t1, 260($a2)
    sw $zero, 4($a2)
  
  fpixel_down:
    lw $t1, 0($a2)
    sw $t1, 256($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 256
    j detect_keyboard_input
  
  bpixel_down:
    lw $t1, 256($a2)
    sw $t1, 512($a2)
    sw $zero, 256($a2)
    j fpixel_down
  
    

exit:
    li $v0, 10              # terminate the program gracefully
    syscall
