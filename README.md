# Prolog-Puzzle-Solver
A program in prolog that solves a certain type of sudoku-like puzzle. The rules of the puzzle are as below:
- The puzzle is an nxn grid of squares each to be filled in with a single digit from 1 to 9
- Each row and column contains no repeated digits
- All squares on the diagonal line contain the same value
- Each row and column has a header and they (leftmost square in a row and topmost square in a column) hold either the sum or the product of all the digits in that row/column

An example of this puzzle is in example.png.

Predicate puzzle_solution(+Puzzle) holds when Puzzle is the representation of a solved puzzle.
An example input is:
?- Puzzle=[[0,14,10,35],[14,_,_,_],[15,_,_,_],[28,_,1,_]],
|   puzzle_solution(Puzzle).
Puzzle = [[0, 14, 10, 35], [14, 7, 2, 1], [15, 3, 7, 5], [28, 4, 1, 7]] ;
false.
