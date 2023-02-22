/*  Author: Bi Ho Shin
    Email: redream2010@hotmail.com

    proj1.pl contains predicate 'puzzle_solution(Puzzle)' that takes a maths puzzle 
    and produces the solution via propagation and labelling using the CLP(FD) library. 

    The rules of the puzzle are explained below:

    The puzzle consists of a square grid of squares, each to be filled in with a single digit 1-9 (zero is excluded) satisfying the following constraints:
        - Each row and column contains no repeated digits.
        - All sqaures on the diagonal line contain the same value
        - The heading of each row and column (leftmost square in a row and topmost square in a column) holds either the sum or the product of all the digits in that row/column.
*/

:- ensure_loaded(library(clpfd)).


%% puzzle_solution(+Puzzle)
%
%  Takes in a maths puzzle as defined above as a list of lists and produces the solution.

puzzle_solution(Puzzle) :-

    % Constructs an NxN square matrix, including the headers
    length(Puzzle, N), maplist(same_length(Puzzle), Puzzle), 
    % Pigeonhole Principle ensures that the maximum size of a puzzle is 10x10, including the headers
    N in 1..10, 

    % Construct a square matrix with only the non-header elements
    less_header(Puzzle, ColHeader, RowHeader, NoHeaders),

    % Every non-header value must lie between 1 and 9
    append(NoHeaders, Vals), Vals ins 1..9,

    % Ensure all diagonal entries are the same
    same_diagonal(NoHeaders, 0, _), 

    % Applying row constraints
    maplist(all_distinct, NoHeaders), % each row contains no repeated digits
    rowConstraintEnforce(NoHeaders, RowHeader),
    
    % Applying column constraints
    transpose(NoHeaders, NoHeadersTranspose),
    maplist(all_distinct, NoHeadersTranspose),
    rowConstraintEnforce(NoHeadersTranspose, ColHeader),

    % Unify back with the original matrix
    transpose(NoHeadersTranspose, NoHeaders),

    labeling([],Vals),

    % Checks if a propagation step is required again after labelling
(   \+ ground(Puzzle) 
->  puzzle_solution(Puzzle)
;   ground(Puzzle)
).
% (   puzzle_solution(Puzzle)
% ->  
% ;   \+ puzzle_solution(Puzzle)
% ).


%% rowConstraintEnforce(+NxNMatrix, +Header)
%
%  Imposes the constraint that the header of a row must be equal to 
%  either the sum or the product of all the digits in that row.
%  We can impose the similar column constraints by passing in the 
%  matrix transpose as an argument to this predicate.

rowConstraintEnforce([],[]).
rowConstraintEnforce([Row|Rest], [Target|Tail]) :-
    list_sum(Row, Sum),
    list_product(Row, Product),

    (Sum #= Target #\/ Product #= Target), % Enforcing constraint
    rowConstraintEnforce(Rest, Tail).


%% same_diagonal(+Matrix, +Index, -Value)
%
%  Constrains the diagonal of an NxN matrix to all have the same value.

same_diagonal([], _, _).
same_diagonal([Row|Rest], Index, Value) :-
    nth0(Index, Row, Value),
    NextIndex #= Index + 1,
    same_diagonal(Rest, NextIndex, Value).


%% less_header(+Puzzle, -ColHeader, -RowHeader, -NoHeaders)
%
%  Extracts the Header rows for the maths puzzle and outputs them into their respective parameters.
%  Creates a list of lists/matrix for all the non-header elements.

less_header([Header|Rows], ColHeader, RowHeader, NoHeaders) :-
    Header = [_|ColHeader], % removing the top left nil element
    transpose(Rows, Columns),
    Columns = [RowHeader|NoHeadersTranspose],
    transpose(NoHeadersTranspose, NoHeaders).


%% list_sum(+List, -Sum)
%
%  Sums a list of numbers. Uses Tail recursion via an accumulator.

list_sum([Head|Tail], Sum) :-
    list_sum([Head|Tail], 0, Sum).
list_sum([], Sum, Sum).
list_sum([Head|Tail], Sum0, Sum) :-
    Sum1 #= Head + Sum0,
    list_sum(Tail, Sum1, Sum).


%% list_product(+List, -Product)
%
%  Finds the Product of a list of numbers. Uses Tail recursion via an accumulator.

list_product([Head|Tail], Product) :-
    list_product([Head|Tail], 1, Product).
list_product([], Product, Product).
list_product([Head|Tail], Prod0, Product) :-
    Prod1 #= Prod0 * Head,
    list_product(Tail, Prod1, Product).
