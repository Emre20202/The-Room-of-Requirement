EE-242 EMRE ÇİFÇİ Second Project<
        >2019401012<

My code (project2.cpp) takes
three command line arguments as its
inputs. First one is A.txt <any file 
name of a text file includes an 
(n x n) matrix> ,second one is the
tolerance value (1e-6 for this project.)
and the third one is o.txt <any text file
to write our results for eigenvalues and
eigenvector>

This code is written for the case where
matrix A is square. But in any case, for
a matrix (mxn), my code first finds m and
assumes that A is (mxm). So, it is crucial to 
have appropriate inputs:

1:File name of a text file with a matrix (nxn)
inside
2:tolerance value
3:File name of a text file

Algorithm:
This code first finds the dominant eigenvalue
and then find the other one. To do this:
It first creates a vector (nx1) and multiplies it
with matrix A, then finds this vector's infinity 
norm divide eigenvector by this result. While
following these steps, it also checks the tolerance
interval for the eigenvalue results. In other words,
the same process mentioned above is repeated unless
current eigenvalue and the previous one are close
"enough". And this "enough" corresponds to tolerance
number which is also the second input.
For the second eigenvalue, norm of the eigenvector
is found and then deflation matrix is found by 
first multiplying unit eigenvector times its transpose
and multiplying it with the first eigenvalue. After
doing this, deflation is subtracted from matrix A and
the same steps are followed just like it did for the
dominant one using matrix "deflation".