##############################################################################
# Example: Keyboard Input
#
# This file demonstrates how to read the keyboard to check if the keyboard
# key q was pressed.
##############################################################################
    .data
color_array:        .space      12
pill_array:         .space      16
displayaddress:     .word       0x10008000

ADDR_KBRD:  
    .word 0xffff0000
    
    # Padding to give enough space for the display
    .space 262144    # 256 x 256 x 4 = 262144

    .text
	.globl main

#DONT USE: t0, s0, s1 again
main:
  lw $s0, displayaddress # $s0 = base address for display
  la $s1, pill_array
  la $t5, color_array #Initializing the color array
  li $t1, 0xff0000 # $t1 = red
  li $t2, 0x00ff00 # $t2 = green
  li $t3, 0x0000ff # $t3 = blue
  add $t4, $t1, $t2 # Create yellow by adding red and green, store in $t4
  sw $t1, 0($t5) #color_array[0] = red
  sw $t3, 4($t5) #color_array[1] = blue
  sw $t4, 8($t5) #color_array[2] = yellow
  jal GENERATE_RANDOM_COLOR
  #sw $v0, 0($s1) 
  sw $v0, 1088($s0) #display the first pixel
  addi $a2, $s0, 1088 #assigns the location of the first byte to be passed as an argument
  jal GENERATE_RANDOM_COLOR
  #sw $v0, 8($s1)
  sw $v0, 1600($s0) #display the second pixel
  j detect_keyboard_input
  

GENERATE_RANDOM_COLOR:
  li $v0 , 42
  li $a0 , 0
  li $a1 , 3 #generates a random number from (0,2), stores in $a0
  syscall 
  li $t6, 4
  mult $a0, $t6 #multiplies i by 4
  mflo $t7 #Stores 4i
  add $t8, $t7, $t5
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

    lw $t1, 512($a2) #change the 256/252 values accordingly
    beq $t1, $zero, rpixel_lmove
    sw $t1, 508($a2)
    sw $zero, 512($a2)
    addi $a2, $a2, -4
    j detect_keyboard_input

rpixel_lmove:
    lw $t1, 4($a2) #Store the color value in the first pixel
    sw $t1, 0($a2) #Paint the pixel on the left of first pixel
    sw $zero, 4($a2) #Paint the first pixel to black
    addi $a2, $a2, -4
    j detect_keyboard_input

respond_to_D: #Should move the capsule to the right
    lw $t1, 512($a2) #change the 256/252 values accordingly
    beq $t1, $zero, rpixel_rmove
    sw $t1, 516($a2)
    sw $zero, 512($a2)

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
    sw $t1, -512($a2)
    sw $zero, 4($a2)
    addi $a2, $a2, -512
    j detect_keyboard_input

bpixel_rotate_anti:
    lw $t1, 0($a2)
    sw $t1, 508($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 508
    j detect_keyboard_input

respond_to_W: #Should rotate capsule by 90 degrees clockwise
    lw $t1, 4($a2) #stores the color value of the pixel to the right of the first pixel
    beq $t1, $zero, bpixel_rotate_clock
    lw $t1, 0($a2)
    sw $t1, -508($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, -508
    j detect_keyboard_input

bpixel_rotate_clock:
    lw $t1, 0($a2)
    sw $t1, 516($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 512
    j detect_keyboard_input

respond_to_S: #Should move the capsule to the bottom
    lw $t1, 4($a2)
    beq $t1, $zero, bpixel_down
    sw $t1, 516($a2)
    sw $zero, 4($a2)

fpixel_down:
    lw $t1, 0($a2)
    sw $t1, 512($a2)
    sw $zero, 0($a2)
    addi $a2, $a2, 512
    j detect_keyboard_input

bpixel_down:
    lw $t1, 512($a2)
    sw $t1, 1024($a2)
    sw $zero, 512($a2)
    j fpixel_down
