"""
Loop through array, bottom up looking at two rows at once
Check:
- if there is "s" or "u" on the top row, and 0 on the bottom, bring them down
- if >4 block together on a row or col, delete that row/col
"""
def update_matrix():
    print("\noriginal")
    printGrid()
    bring_down() #
    print("\ngravity")
    printGrid()
    delete() #
    print("\ngravity")
    bring_down() #
    printGrid()
    delete() #

def bring_down():
    rows = len(matrix)
    cols = len(matrix[0])

    # Start from the second-to-last row and work upwards
    for r in range(rows - 2, -1, -1):
        for c in range(cols - 1, -1, -1):
            if (matrix[r][c] in {"s", "u", "d", "l", "r"}) and matrix[r + 1][c] == 0:
                # Move the block down
                matrix[r + 1][c] = matrix[r][c]
                matrix[r][c] = 0
            if (matrix[r][c] == "l" and matrix[r][c] == 0 and matrix[r][c - 1] == 0):
                # Move the block down
                matrix[r + 1][c] = matrix[r][c]
                matrix[r][c] = 0
            

def delete():
    rows = len(matrix)
    cols = len(matrix[0])

    # Check for horizontal matches
    for r in range(rows - 1, -1, -1):
        count = 0
        for c in range(cols - 1, -1, -1):
            if matrix[r][c] != 0: # AND COLOURS SAME
                count += 1
                if count >= 4:
                    # Delete the blocks for the current match
                    matrix[r][c + 3] = 0
                    matrix[r][c + 2] = 0
                    matrix[r][c + 1] = 0
                    matrix[r][c] = 0
            else:
                count = 0
    print("\nhorizontal delete")
    printGrid()
    # Check for vertical matches
    for c in range(cols - 1, -1, -1):
        count = 0
        for r in range(rows - 1, -1, -1):
            if matrix[r][c] != 0: # AND COLOURS SAME
                count += 1
                if count >= 4:
                    # Delete the blocks for the current match
                    matrix[r + 3][c] = 0
                    matrix[r + 2][c] = 0
                    matrix[r + 1][c] = 0
                    matrix[r][c] = 0
            else:
                count = 0
    print("\nvertical delete")
    printGrid()

def printGrid():
    for row in matrix:
        print(row)

# Example matrix
matrix = [["s", 0, 0, 0, 0],
          ["s", 0, 0, 0, 0],
          ["s", "s", 0, 0, 0],
          ["d", "s", "d", "v", "v"],
          ["u", 0, "u", 0, 0]]

# Update the matrix in place
update_matrix()

# Another example
matrix = [["s", 0, 0, 0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
          ["v", 0, 0, 0, 0, 0, 0, 0, 0, 0],
          ["s", 0, 0, 0, 0, 0, 0, 0, 0, 0],
          ["v", 0, 0, 0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
          ["r", "l", "s", 0, 0, 0, 0, 0, 0, 0],
          [0, 0, 0, "v", 0, 0, 0, 0, 0, 0],
          ["v", 0, 0, 0, 0, 0, 0, 0, 0, 0],
          ["v", 0, 0, 0, 0, 0, 0, 0, 0, 0],
          ["v", 0, 0, 0, 0, 0, 0, 0, 0, 0],
          ["v", 0, 0, 0, 0, 0, 0, 0, 0, 0],
          ["v", 0, 0, 0, 0, 0, "s", 0, 0, 0],
          [0, 0, 0, 0, 0, 0, 0, "v", "r", "l"]]

# Update the matrix in place
update_matrix()
