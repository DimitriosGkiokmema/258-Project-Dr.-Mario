.data
displayaddress:     .word       0x10008000

# ...

.text
# ...
li $t1, 0xff0000 # $t1 = red
li $t2, 0x00ff00 # $t2 = green
li $t3, 0x0000ff # $t3 = blue
lw $t0, displayaddress # $t0 = base address for display
sw $t1, 0( $t0 ) # paint the first unit (i.e., top−left) red
sw $t2, 4( $t0 ) # paint the second unit on the first row green
sw $t3, 128( $t0 ) # paint the first unit on the second row blue

########################################################################
###  Everything above this line was provided in the project handout  ###
########################################################################

add $t4, $t1, $t2     # Create yellow by adding red and green, store in $t4
sw $t4, 8( $t0 )      # paint the third unit on the first row yellow
add $t5, $t1, $t3     # Create magenta by adding red and blue, store in $t5
sw $t5, 12( $t0 )      # paint the fourth unit on the first row magenta
add $t6, $t2, $t3     # Create cyan by adding blue and green, store in $t6
sw $t6, 16( $t0 )      # paint the fifth unit on the first row cyan
add $t7, $t1, $t6     # Create yellow by adding all three colours together, store in $t7
sw $t7, 20( $t0 )      # paint the sixth unit on the first row white

## Draw a line ##

add $t5, $zero, $zero # initialize the loop variable $t5 to zero
addi $t6, $zero, 10   # initialize $t6 to the final value for the loop variable.
addi $t7, $t0, 400    # set the starting address for the line
# Main lin drawing loop
pixel_draw_start:     # the starting label for the pixel drawing loop     
sw $t4, 0( $t7 )      # paint the current bitmap location yellow.
addi $t5, $t5, 1      # increment the loop variable
addi $t7, $t7, 4      # move to the next pixel in the row.
beq $t5, $t6, pixel_draw_end    # break out of the loop if you hit the stop condition
j pixel_draw_start    # jump to the top of the loop
pixel_draw_end:       # the end label for the pixel drawing loop