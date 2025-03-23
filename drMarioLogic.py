"""
Loop through array, bottom up looking at two rows at once
Check:
- if there is "s" or "u" on the top row, and 0 on the bottom, bring them down
- if >4 block together on a row or col, delete that row/col
"""
def update_matrix():
    print("\noriginal")
    printGrid()
    bring_down()
    print("\ngravity")
    printGrid()
    delete()

def bring_down():
    rows = len(matrix)
    cols = len(matrix[0])

    # Start from the second-to-last row and work upwards
    for r in range(rows - 2, -1, -1):
        for c in range(cols):
            if matrix[r][c] in {"s", "u"} and matrix[r + 1][c] == 0:
                # Move the block down
                matrix[r + 1][c] = matrix[r][c]
                matrix[r][c] = 0

def delete():
    rows = len(matrix)
    cols = len(matrix[0])
    to_delete = set()  # Keep track of coordinates to delete

    # Check for horizontal matches
    for r in range(rows):
        count = 1
        for c in range(1, cols):
            if matrix[r - 1][c] != 0 and matrix[r][c] != 0:
                count += 1
                if count >= 4:
                    for k in range(count):
                        to_delete.add((r, c - k))
            else:
                count = 1

    # Check for vertical matches
    for c in range(cols):
        count = 1
        for r in range(1, rows):
            if matrix[r - 1][c] != 0 and matrix[r][c] != 0:
                count += 1
                print(f"Elements the same on ({r}, {c}) and ({r - 1}, {c})")
                if count >= 4:
                    for k in range(count):
                        to_delete.add((r - k, c))
            else:
                count = 1

    # Delete the blocks by setting them to 0
    for r, c in to_delete:
        matrix[r][c] = 0

def printGrid():
    for row in matrix:
        print(row)

# Example matrix
matrix = [["s", 0, 0, 0],
          [0, 0, 0, 0],
          ["s", "s", 0, 0],
          ["d", 0, "d", 0],
          ["u", 0, "u", 0]]

# Update the matrix in place
update_matrix()
print("\nfinal")

# Print the updated matrix
for row in matrix:
    print(row)