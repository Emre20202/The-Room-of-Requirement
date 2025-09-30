>EE-242 EMRE ÇİFÇİ First Project<

My code takes
two command-line arguments as its
inputs. First one is the A.txt <any
file name of a text file includes an 
(n x n) matrix> and b.txt <any file
name of a text file includes an 
(n x 1) matrix>. My code first finds
the number of lines that the b.txt file has
in total, then accepts this value as
"n" and continues all other algorithms.
So, input matrices must obey the initial
conditions. Otherwise, some undesired
results can be observed.

In this code, elements of matrices and
the output file (x.txt) are accepted in
the type "float". Because of this, min.
value accepted is chosen according to "min 
float value". In order to avoid some 
undesired problems, all float numbers 
in the matrices (abs) below 1.2e-38 are 
set equal to 0.

What is more, in the case of n=2, 
the code is required to find the condition
numbers of 1 and inf, and to print them.
The importance of high condition numbers
is proven by an example:

>Example<
A:
1.000 1.000
1.000 1.001
b1: b2:
2.000 2.000
2.000 2.001

When the code takes this matrix and vectors
as its inputs, the following results appear:
for b1: x becomes:
2
0
for b2: x becomes:
1.00012
0.999881

Where the condition number of norm 1 and 
norm inf are both equal to 4003.81, which 
is a relatively big number. Because of
this big number, x result changes a lot
when the b vector changes slightly.

The reason behind this is hidden in the way 
we compute the condition number. Actually,
condition number is to measure the ratio of
max. stretching to max. shrinking that the 
matrix does to any nonzero vectors. Since
A matrix is so close to being singular (elements
are so close to each other-0.1% diff) and
condition number of a singular matrix is inf,
A comes up with a large condition number.
This means a limited change in the vector we
muliply by A results in a large change in the
x vector(result).


