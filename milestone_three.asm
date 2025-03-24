#################################################
# Milestone Three Logic
#################################################
        .data
displayaddress:     .word 0x10008000
block_array:       .space 16        # Array of a subset of values (s, u, d, l) in the grid array
                                    # Because of how this code is implemented, v, 0, r are not needed
grid:               .word 0:456     # Array of all pixels in the bottle
                                    # 24 row * 19 column grid = 456 elements
                                    # Values: 0 empty spot,         In Memory:  0x0
                                    #         l pair block at left              0x6c
                                    #         r pair block at right             0x72
                                    #         u pair block up                   0x75
                                    #         d pair block below                0x64
                                    #         s single block (no pair)          0x73
                                    #         v virus                           0x76
        
ADDR_DSPL:
    .word 0x10008000
    
    # Padding to give enough space for the display
    .space 262144    # 256 x 256 x 4 = 262144

    .text
	.globl main

main:
    # Initializing variables
    la $s2, block_array # Holds address of block_array
    li $t1, 0x73 # $t1 = 's'
    li $t2, 0x75 # $t2 = 'u'
    li $t3, 0x64 # $t3 = 'd'
    sw $t1, 0($s2) # block_array[0] = 's'
    sw $t3, 4($s2) # block_array[1] = 'u'
    sw $t4, 8($s2) # block_array[2] = 'd'
    sw $t5, 12($s2) # block_array[3] = 'l'
                
    #########################################################
    # VARIABLES:
    #########################################################
    # $s0 base address for display
    # $s1 address for grid array
    # $s2 address for block_array
    # $t0 i: index of current element in the grid array. Start at end of second-last row: 1748 and i - 4 each iteration
    # $t1 bitmap address: the adress of i in the bitmap (used to get the colour of the current pixel)
    # $t2 value of grid[i]
    # $t3 value of block from block_array we are comparing $t2 to
    #########################################################
    lw $s0, displayaddress # $s0 = base address for display
    la $s1, grid            # $s1 holds the address of grid
    add $t0, $s1, 1748        # Max i is 456 - 24 (since we start on the second last row) elements * 4 = 1748 + bitmap address
    add $t1, $s0, 12136     # This is the bitmap address of the pixel at the bottom right of the bottle
    
update_matrix:
    jal bring_down  # Simulates gravity
    jal delete_consecutive_blocks # clear blocks if four or more are next to each other
    j exit  # Ends program

                                    #######################################################
                                    # bring_down: implements gravity
                                    #######################################################
# --------------
# Python Code
# --------------

# def bring_down():
# rows = len(matrix)
# cols = len(matrix[0])

# Start from the second-to-last row and work upwards
    # for r in range(rows - 2, -1, -1):
        # for c in range(cols - 1, -1, -1):
            # if (matrix[r][c] in {"s", "u", "d", "l", "r"}) and matrix[r + 1][c] == 0:
                # # Move the block down
                # matrix[r + 1][c] = matrix[r][c]
                # matrix[r][c] = 0
            # if (matrix[r][c] == "l" and matrix[r][c] == 0 and matrix[r][c - 1] == 0):
                # # Move the block down
                # matrix[r + 1][c] = matrix[r][c]
                # matrix[r][c] = 0

bring_down: # Used to symbolyze that everything below is for the gravity function
    
bring_down_loop:
    beq $t0, $s1, exit_row_loop     # $t0 is at first index, so loop must terminate
    
    # Conditionals to check if we can/should bring down a pixel
    # If bitmap pixel is 's', 'u', 'd', 'l' and 'r',
    # AND if column below is empty,
    # THEN bring them down
    lw $t2, 0($t0)  # loads the value of the grid array at the current index
check_s:
    lw $t3, 0($s2)  # loads first block value from block_array: 's'
    beq $t2, $t3, check_below_row
check_u:
    lw $t3, 4($s2)  # loads second block value from block_array: 'u'
    beq $t2, $t3, check_below_row
check_d:
    lw $t3, 8($s2)  # loads first block value from block_array: 'd'
    beq $t2, $t3, check_below_row
check_l:
    lw $t3, 12($s2)  # loads first block value from block_array: 'l'
    beq $t2, $t3, check_bottom_left
    
# READ BELOW NOTES
####################################
# Why check_r is not needed:
    # This gravity algorithm traverses the array from the bottom right of the bottle to the top left
    # Because of how the letters are set up in the grid array, if we are traversing this way we are
    # GUARANTEED to find 'l' first, as 'l' means the current block's pair is to the LEFT. 
    # Thus, we will never run into 'r' before 'l'.
    # When we find an 'l', this algo brings BOTH the left and right blocks down, so in the next iteration
    # of the loop the location where we previously had 'r' is now empty.
    # Because of this, check_r is never going to be used, so there is no reason to create it.
#####################################

    # If this is reached, ALL above beq were false (meaning we are at 'v' or 0, so check_below_row should be skipped
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
    sw $t2, 76($t0)     # Stores the value of [r][c] to [r + 1][c]
    sw $zero, 0($t0)    # Clears the value of [r][c] as we just moved it
    addi $t0, $t0, -4   # Moves index to the left so that we can move the left block down
                        # Thus, we are now at [r][c - 1]
    sw $t2, 76($t0)     # Stores the value of [r][c - 1] to [r + 1][c - 1]
    sw $zero, 0($t0)    # Clears the value of [r][c - 1] as we just moved it
    addi $t0, $t0, 4    # Moves index back to its original position
    j decrement         # The horizontal pill has moved down

check_below_row:
    lw $t2, 76($t0) # Loads the value in the grid array right below the current index
                      # [r + 1][c] in this case is #t0 + 19 * 4 = $t0 + 76
    beq $t2, $zero, move_down   # row below is empty, so we can move down the block
    
    # If this is reached, the above beq were false, so move_down should be skipped
    j decrement
move_down:
    sw $t2, 76($t0)     # Stores the value of [r][c] to [r + 1][c]
    sw $zero, 0($t0)    # Clears the value of [r][c] as we just moved it
    
    # Removes block from BITMAP
    sw $zero, 0($t1)        # Resets the value at bitmap[i]
    
decrement:
    # Decrimenting loop variables
    # This is preparing the index value for the next iteration of the loop
    add $t0, $t0, -4        # Decrimenting array address
    
    # Loop again
    j bring_down_loop               # calls the next iteration of the outer loop
    
exit_row_loop:
    jr $ra      # Jumps to update_matrix
    
    
                                    #######################################################
                                    # delete_consecutive_blocks: deletes consecutive blocks
                                    #######################################################
# --------------
# Python Code
# --------------
# def delete():
    # rows = len(matrix)
    # cols = len(matrix[0])

    # # Check for horizontal matches
    # for r in range(rows - 1, -1, -1):
        # count = 0
        # for c in range(cols - 1, -1, -1):
            # if matrix[r][c] != 0: # AND COLOURS SAME
                # count += 1
                # if count >= 4:
                    # # Delete the blocks for the current match
                    # matrix[r][c + 3] = 0
                    # matrix[r][c + 2] = 0
                    # matrix[r][c + 1] = 0
                    # matrix[r][c] = 0
            # else:
                # count = 0
                
    # # Check for vertical matches
    # for c in range(cols - 1, -1, -1):
        # count = 0
        # for r in range(rows - 1, -1, -1):
            # if matrix[r][c] != 0: # AND COLOURS SAME
                # count += 1
                # if count >= 4:
                    # # Delete the blocks for the current match
                    # matrix[r + 3][c] = 0
                    # matrix[r + 2][c] = 0
                    # matrix[r + 1][c] = 0
                    # matrix[r][c] = 0
            # else:
                # count = 0
                
#########################################################
# VARIABLES:
#########################################################
# $s0 base address for display
# $s1 address for grid array
# $s2 address for block_array

# $t0 i: index of current element in the grid array. Start at end of second-last row: 1748 and i - 4 each iteration
# $t1 bitmap address: the adress of i in the bitmap (used to get the colour of the current pixel)
# $t2 value of grid[i]
# $t3 value of block from block_array we are comparing $t2 to
# $t4 count: counts the amount of consecutives blocks found * 4
#               Used for both horizontal and vertical checks, so less registers are used
# $t5 current bitmap colour: colour of the current pixel in the bitmap
# $t6 previous bitmap colour: The colour of the previous block that was checked
# $t7 column count: used to tell the index of the current column
#########################################################
############################################
# Loop to find and delete HORIZONTAL blocks
############################################
delete_consecutive_blocks:  # Used to symbolyze that everything below is for the delete function
    add $t0, $s1, 1824      # Max i is 456 elements * 4 = 1824 + bitmap address
    add $t1, $s0, 12136     # This is the bitmap address of the pixel at the bottom right of the bottle
    lw $t5, 0($t1)          # Loads the colour of the pixel on the bitmap at the current index
    add $t6, $t5, $zero     # Setting the previous colour equal to the current colour, as this is required for the first loop iteration
    li $t7, 18              # Sets max col index, as we start and the end of a row. A column has 19 elements, so max index is 18
    j horizontal_loop                 # Jumps to code that finds and deletes consecutive horizontal blocks
    
horizontal_loop:
    beq $t0, $s1, init_vertical_loop     # $t0 is at first index, so loop must terminate
    lw $t5, 0($t1)                    # Loads the current bitmap colour in $t5
    
    lw $t2, 0($t0)  # loads the value in the grid array at the current index
    # Conditionals to check if we can/should increase the counter
    # If bitmap pixel is not empty
    # AND if colour on the bitmap is the same as the current colour
    # THEN increment the counter
    beq $t2, $zero, reset_horizontal_counter     # Checks if spot IS empty
    bne $t5, $t6, reset_horizontal_counter       # Checks if current colour is NOT the same as the colour of the previous block checked
    
    # If this section is reached, then the current block is not empty and has the same colour as the previous block
    addi $t4, $t4, 1        # Since the conditions are met, we found another consecutive colour, so count is increased
    
    # Check is count > 4
    # If so, clear the last four blocks
    addi $t4, $t4, -3       # Subtractring 3 from counter. If still > 0, then it was >=4
    bgtz $t4, reset_horizontal_blocks   # checks to see if count >= 4
    addi $t4, $t4, 3        # Reverting the counter to its previous value
    j reset_horizontal_counter  # If this is reached, then counter < 4 so move on to check next block
    
reset_horizontal_blocks:    # Resets the last four blocks
    addi $t4, $t4, 3        # Reverting the counter to its previous value
    
    # Removes blocks from GRID ARRAY
    sw $zero, 0($t0)        # Resets the value at grid[r][c]
    sw $zero, 4($t0)        # Resets the value at grid[r][c+ 1]
    sw $zero, 8($t0)        # Resets the value at grid[r][c + 2]
    sw $zero, 12($t0)       # Resets the value at grid[r][c + 3]
    
    # Removes blocks from BITMAP
    sw $zero, 0($t1)        # Resets the value at bitmap[r][c]
    sw $zero, 4($t1)        # Resets the value at bitmap[r][c + 1]
    sw $zero, 8($t1)        # Resets the value at bitmap[r][c + 2]
    sw $zero, 12($t1)       # Resets the value at bitmap[r][c + 3]
    
    j horizontal_decrement  # We do not want to trigger the next piece of code
                            # If triggered, only four consecutive blocks will be removed at a time
                            # However, if we skip over it now, then we allow the game to remove > 4 at a time (since counter isn't reset)
reset_horizontal_counter:
    li $t4, 0       # Resets the counter to 0, as current spot in the grid array is empty
    j horizontal_decrement  # There is no block at the current index, reset count and move on to next spot in the playing field
    
horizontal_decrement:
    # Decrimenting loop variables for the delete funciton (delete_consecutive_blocks)
    # This is preparing the index value for the next iteration of the loop
    # If col = 0, the bitmap address needs to be at the end of the above row
    beq $t7, $zero, horizontal_special_decrement 
    addi $t7, $t7, -1       # Decriments column index
    add $t0, $t0, -4        # Decrimenting array address
    j horizontal_save_colour
horizontal_special_decrement:
    li $t7, 18          # Reseting the column index
    add $t1, $t1, -4    # Moves bitmap index to the left block
    add $t1, $t1, -184    # Decrimenting bitmap address so that the next location is at the end of the row above in the bottle
    li $t4, 0        # Sets the counter to 0. This is incremented each time we find a non-empty spot on the grid
                     # As this is the end of the row, this count must be reset
    
horizontal_save_colour:   # This will be called at EACH loop iteration, as $t0 and $t4 must always be decrimented
    add $t6, $zero, $t5     # Stores the colour of this iteration in $t6 to be used in the next iteration
    
    # Loop again
    j horizontal_loop       # calls the next iteration of the outer loop

#########################################################
# VARIABLES:
#########################################################
# $s0 base address for display
# $s1 address for grid array
# $s2 address for block_array

# $t0 i: index of current element in the grid array. Start at end of second-last row: 1748 and i - 4 each iteration
# $t1 bitmap address: the adress of i in the bitmap (used to get the colour of the current pixel)
# $t2 value of grid[i]
# $t3 value of block from block_array we are comparing $t2 to
# $t4 count: counts the amount of consecutives blocks found * 4
#               Used for both horizontal and vertical checks, so less registers are used
# $t5 current bitmap colour: colour of the current pixel in the bitmap
# $t6 previous bitmap colour: The colour of the previous block that was checked
# $t7 row count: used to tell the index of the current row
#########################################################
############################################
# Loop to find and delete VERTICAL blocks
############################################
init_vertical_loop:
    add $t0, $s1, 1824      # Max i is 456 elements * 4 = 1824 + bitmap address
    add $t1, $s0, 12136     # This is the bitmap address of the pixel at the bottom right of the bottle
    lw $t5, 0($t1)          # Loads the colour of the pixel on the bitmap at the current index
    add $t6, $t5, $zero     # Setting the previous colour equal to the current colour, as this is required for the first loop iteration
    li $t7, 23              # Sets max row index, as we start and the end of a row. A column has 24 rows, so max index is 23

vertical_loop:
    beq $t0, $s1, exit_vertical_loop     # $t0 is at first index, so loop must terminate
    lw $t5, 0($t1)                    # Loads the current bitmap colour in $t5
    
    lw $t2, 0($t0)  # loads the value in the grid array at the current index
    # Conditionals to check if we can/should increase the counter
    # If bitmap pixel is not empty
    # AND if colour on the bitmap is the same as the current colour
    # THEN increment the counter
    beq $t2, $zero, reset_vertical_counter     # Checks if spot IS empty
    bne $t5, $t6, reset_vertical_counter       # Checks if current colour is NOT the same as the colour of the previous block checked
    
    # If this section is reached, then the current block is not empty and has the same colour as the previous block
    addi $t4, $t4, 1        # Since the conditions are met, we found another consecutive colour, so count is increased
    
    # Check is count > 4
    # If so, clear the last four blocks
    addi $t4, $t4, -3       # Subtractring 3 from counter. If still > 0, then it was >=4
    bgtz $t4, reset_vertical_blocks   # checks to see if count >= 4
    addi $t4, $t4, 3        # Reverting the counter to its previous value
    j reset_vertical_counter  # If this is reached, then counter < 4 so move on to check next block
    
reset_vertical_blocks:    # Resets the last four blocks
    addi $t4, $t4, 3        # Reverting the counter to its previous value
    
    # Removes blocks from GRID ARRAY
    sw $zero, 0($t0)           # Resets the value at grid[r][c]
    sw $zero, -76($t0)        # Resets the value at grid[r + 1][c]
    sw $zero, -152($t0)        # Resets the value at grid[r + 2][c]
    sw $zero, -228($t0)        # Resets the value at grid[r + 3][c]
    
    # Removes blocks from BITMAP
    sw $zero, 0($t1)        # Resets the value at bitmap[r][c]
    sw $zero, -256($t1)        # Resets the value at bitmap[r + 1][c]
    sw $zero, -512($t1)        # Resets the value at bitmap[r + 2][c]
    sw $zero, -778($t1)       # Resets the value at bitmap[r + 3][c]
    
    j vertical_decrement  # We do not want to trigger the next piece of code
                            # If triggered, only four consecutive blocks will be removed at a time
                            # However, if we skip over it now, then we allow the game to remove > 4 at a time (since counter isn't reset)
reset_vertical_counter:
    li $t4, 0       # Resets the counter to 0, as current spot in the grid array is empty
    j vertical_decrement  # There is no block at the current index, reset count and move on to next spot in the playing field
    
vertical_decrement:
    # Decrimenting loop variables for the delete funciton (delete_consecutive_blocks)
    # If row = 0, the bitmap address needs to be at the end of the above row
    beq $t7, $zero, vertical_special_decrement 
    addi $t7, $t7, -1       # Decriments column index
    add $t1, $t1, -256       # Decrimenting the bitmap index to [r][c - 1]
    add $t0, $t0, -76        # Decrimenting array address to be at [r][c -1]
    j vertical_default_decrement
vertical_special_decrement:
    li $t7, 23               # Reset the row counter
    add $t1, $t1, 5884    # Incrementing bitmap address to be at [r + 1][c]
    add $t0, $t0, -76     # Incrementing array address to be at [r + 1][c]
    li $t4, 0        # Sets the counter to 0. This is incremented each time we find a non-empty spot on the grid
                     # As this is the end of the row, this count must be reset
    
vertical_default_decrement:   # This will be called at EACH loop iteration, as $t0 and $t4 must always be decrimented
    # This is preparing the index value for the next iteration of the loop
    add $t6, $zero, $t5     # Stores the colour of this iteration in $t6 to be used in the next iteration
    
    # Loop again
    j vertical_loop       # calls the next iteration of the outer loop
    
exit_vertical_loop:
    jr $ra

exit:
    li $v0, 10              # terminate the program gracefully
    syscall
