EE-242 EMRE ÇİFÇİ Third Project<
        >2019401012<

My code (project3.cpp) takes
n+5 command line arguments as its
inputs where n can be any integer
value determined by the user.

n+5=proejct3's file name(1)+
coefficients(n+1)+initial guesses(2)+
tolerance value(1)

Using the coefficients and number n
(n=argc-5 as mentioned before), we 
can build our function and use it 
in our algorithm.

Totally, three ways are represented 
in this code to find three solutions:
secant method, bisection method and
hybrid method which is the one that we 
use both secant and bisection methods.

In this code all three solutions and
number of increments needed for them
are printed in order.

In this code, input coefficients are
assumed to be float numbers. So, for
different cases there might be some
differences in number of increment
between this code and the same with 
"double" coefficients. This can be
modified easily.