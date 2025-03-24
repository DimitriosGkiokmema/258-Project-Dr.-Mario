#################################################
# Milestone Three Logic
#################################################
        .data
displayaddress:     .word 0x10008000
block_array:       .space 12
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
    sw $t1, 0($s1) # block_array[0] = 's'
    sw $t3, 4($s1) # block_array[1] = 'u'
    sw $t4, 8($s1) # block_array[2] = 'd'
                
    #########################################################
    # VARIABLES:
    #########################################################
    # $s0 base address for display
    # $s1 address for grid array
    # $t0 i: index of current element in the grid array. Start at end of second-last row: 1748 and i - 4 each iteration
    # $t1 bitmap address: the adress of i in the bitmap (used to get the colour of the current pixel)
    # $t2 value of grid[i]
    # $t3 value of block from block_array we are comparing $t2 to
    #########################################################
    lw $s0, displayaddress # $s0 = base address for display
    la $s1, grid            # $s1 holds the address of grid
    add $t1, $s0, 12136      # Address of bottom right pixel in container
    
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

# # Start from the second-to-last row and work upwards
# for r in range(rows - 2, -1, -1):
    # for c in range(cols):
        # if (matrix[r][c] == "s" or matrix[r][c] == "u" or matrix[r][c] == "d") and matrix[r + 1][c] == 0:
            # # Move the block down
            # matrix[r + 1][c] = matrix[r][c]
            # matrix[r][c] = 0

bring_down:
    add $t0, $zero, 1748      # Max i is 456 - 24 (since we start on the second last row) elements * 4 = 1748 + bitmap address
    
bring_down_loop:
    beq $t0, $zero, exit_row_loop     # $t0 is at first index, so loop must terminate
    
    # Conditionals to check if we can/should bring down a pixel
    # If bitmap pixel is 's', 'u', or 'd'
    # If column below is empty
    lw $t2, 0($t0)  # loads the value in the grid array at the current index
check_s:
    lw $t3, 0($s2)  # loads first block value from block_array: 's'
    beq $t2, $t3, check_below_row
check_u:
    lw $t3, 4($s2)  # loads second block value from block_array: 'u'
    beq $t2, $t3, check_below_row
check_d:
    lw $t3, 8($s2)  # loads first block value from block_array: 'd'
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
    sw $t2, 76($t0)     # Stores the value of [r][c] to [r + 1][c]
    sw $zero, 0($t0)    # Clears the value of [r][c] as we just moved it
    
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
    # for r in range(rows):
        # count = 1
        # for c in range(1, cols):
            # if matrix[r][c - 1] != 0 and matrix[r][c] != 0:
                # count += 1
                # if count >= 4:
                    # # Delete the blocks for the current match
                    # for k in range(count):
                        # matrix[r][c - k] = 0
            # else:
                # count = 1

    # # Check for vertical matches
    # for c in range(cols):
        # count = 1
        # for r in range(1, rows):
            # if matrix[r - 1][c] != 0 and matrix[r][c] != 0:
                # count += 1
                # if count >= 4:
                    # # Delete the blocks for the current match
                    # for k in range(count):
                        # matrix[r - k][c] = 0
            # else:
                # count = 1
delete_consecutive_blocks:
    add $t0, $zero, 1748      # Max i is 456 - 24 (since we start on the second last row) elements * 4 = 1748 + bitmap address


exit:
    li $v0, 10              # terminate the program gracefully
    syscall