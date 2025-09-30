#include <iostream>
#include <fstream>
#include <string>
#include <typeinfo>
#include <sstream>
#include <math.h>
#include <limits>
#include <stdio.h>
#include <cmath>
using namespace std;

// Emre Çifçi-2019401012-First Project cpp Code
// How to compile and run this code is explicitly explained
// in the Readme.txt file. 

int main(int argc, char *argv[]){
	
	// We assume that we have two file name inputs, the first one is
	// for the A matrix, the second one is for the b vector. Since
	// our file name is also accepted as an input, we wait 
	// three inputs in total.
	
	if(argc != 3){
	cout << "Please be sure that you have two file name inputs";
		exit(0);
    }
    
    // We should first find the n number where A(n x n) and b(n x 1).
    // For this, we might read b vector and count the lines using number_n.
    // line_b variable is for the lines of b vector.
    
	string line_b;
	int number_n=0;
	
	// float**A is for A matrix float*b is for b vector, float**M is for
	// a matrix where A is the left part and b is the rightmost part.
	// So M is (n x n+1). Finally float*X is x vector where Ax=b.
	// We use dynamically allocated memory here. The reason why we use
	// ** for A and M is because they are two dimensional arrays and they
	// need first to have dyn. allocated memory for their rows and then
	// for their columns.
	
	float **A;
	float *b;
	float **M;
	float *X;

	// We open the b.txt file first and count the lines and store this
	// in number_n integer.
	
	ifstream myfile(argv[2]);
	if(myfile.is_open()){
		while(getline(myfile,line_b)){
			number_n=number_n+1;
		}
	}
	else{
		cout << "Error while reading/trying to read b.txt file!"<<"\n";
		exit(0);
	}
	
	// We now allocate their array sizes.
	
	A=new float*[number_n];
	b=new float[number_n];
	M=new float*[number_n];
	X=new float[number_n];
	
	// For the matrices A and M, we allocate their columns sizes.
	// A becomes (n x n) and M becomes (n x n+1).
	
	for(int aa=0; aa <number_n;aa++){
		A[aa]=new float[number_n];
	}
    for(int aa=0; aa <=number_n;aa++){
		M[aa]=new float[number_n+1];
	}

    // Now; we read A.txt file and store its values in our A matrix.
	
	ifstream myfileA(argv[1]);
	if(myfileA.is_open()){
		for(int i=0;i<number_n;i++){
			for(int j=0;j<number_n;j++){
			   myfileA >> A[i][j];
		    }
		}
	myfileA.close();
	}
	else{
		cout << "Error  while reading/trying to open A.txt file! ";
		exit(0);
	}
	
	// We have not closed b.txt file yet, but we have read it once.
	// With the help of the following lines, we can read it again 
	// from the beginning.
	
	myfile.clear();
	myfile.seekg(0);
	
	if(myfile.is_open()){
		for(int i=0;i<number_n;i++){
			myfile >> b[i];
		}
	myfile.close();
	}
	else{
		cout << "Error while reading/trying to open b.txt again!";
		exit(0);
	}
	
	// Finally we have to consider the machine precision fact.
	// We use floats in this code and min. float we can write is
	// 1.17549e-38. If we choose a close number to this min value
	// and make the ones (abs values) smaller than this number become
	// zero, this will help us a lot to avoid some mistakes when
	// we want to find x vector and to detect singularity of A.
	// Arbitrarily chosen min. limit: 1.2e-38
	
	for(int i=0;i<number_n;i++){
		for(int j=0;j<number_n;j++){
			if(fabs(A[i][j])<1.2e-38){
				A[i][j]=0;
		  	}
	    }
     } 
	
	for(int j=0;j<number_n;j++){
			if(fabs(b[j])<1.2e-38){
				b[j]=0;
			 }
     }

	// Now, we have A matrix and b vector. We can fill M matrix
	// where its (n+1)th column is b vector and the rest is A matrix.
	
	for(int i=0;i<number_n;i++){
		for(int j=0;j<=number_n;j++){
			if(j==number_n){
				M[i][j]=b[i];
			}
			else{
				M[i][j]=A[i][j];
			}
		}
	}
	
	//---------------------------------------------------------------------//
	// This part is the one where we start working on our main algorithm.
	// First, we need ton find the biggest number in the first column of M.
	// We would like this max. number to be our first pivot. For the first
	// column, increment=0, we start from the M[n-1][0] and compare it with
	// M[n-2][0] and so on. If above number is greater than the below, then
	// we completely swap these rows oF M. After some other operations, we
	// increment our incremenet value by one and compare the next columns's
	// numbers starting from M[n-1][x] to M[increment][x].
	
	// For this purpose mentioned, xx is to hold M[i][j] value to swap it
	// with M[i-1][j] value (when above>below) / This method provides us to
	// have a nonzero pivot (if the matrix is not singular), in other words, 
	// this is a row-exchange operation.
	
	float xx;
	float divider;
    int increment=0;
	
	while(increment < number_n){
	
	
	for(int i = number_n-1 ; i>increment ;i--){
		if(fabs(M[i][increment]) > fabs(M[i-1][increment])){
			for(int j=increment;j<=number_n;j++){
				xx=M[i][j];
				M[i][j]=M[i-1][j];
				M[i-1][j]=xx;
			}
		}
	 }
	//  We have the max. number as our pivot values with the help of the 
	//  previous algorithm. By saying max. we mean:
	//  col=0-->max(row=o to row=n-1) for col=1--> max(row=1 to row=n-1)
	//  Now, we need to find a divider which corresponds to the ratio
	//  of any value below the pivot and the pivot. Then we can multiply
	//  divider by the pivot row and subtract it from the row below.
	//  For n=increment, this work corresponds to make all elements below
	//  the pivot become 0. This algorithm is called the "Gaussian Elimination"
	 
	// Of course, when we detect one of our pivots equals to zero, we can
	// immediately say that A is a singular matrix.
	
	if(M[increment][increment]==0){
		cout <<"Error of singularity! \n";
		exit(0);
		}
	
	for(int i=increment;i<number_n-1;i++){
			for(int j=i;j<number_n-1;j++){
			   divider=M[j+1][increment]/M[increment][increment];
			    for(int n=0;n<=number_n;n++){
			   		M[j+1][n]=M[j+1][n]-divider*M[i][n];
			   }
		    }
		}
		
	for(int i=0;i<number_n;i++){
		for(int j=0;j<=number_n;j++){
			if(fabs(M[i][j])<1.2e-38){
				M[i][j]=0;
			}
	     }
	}
	
	 increment++;
     }

    //---------------------------------------------------------------------// 
    // Now, our purpose is to find X vector. For this, we first make each 
    // element of X become zero. For the following part, let us assume that n=4.
    // At the beginning, i=3 j can only become 3, num is 0 because X is full of zeros
    // so M[3][4]/M[3][3] is equal to X[3], which is correct. When i becomes 2
    // j becomes 2 and 3 in order. When j=2 num is zero since X[2]=0 and when
    // j=3 num becomes M[2][3]*X[3]. Then X[2] becomes (M[2][4]-M[2][3]*X[3])/M[2][2].
    // We can see that this is correct when we look at matrix multiplication.
    
    for(int i=0;i<number_n;i++){
   	    X[i]=0;
    }
    float num;  
    for(int i=number_n-1;i>=0;i--){
   	    num=0;
   	    for(int j=i;j<=number_n-1;j++){
   	    	num=num+M[i][j]*X[j];
		   }
		X[i]=(M[i][number_n]-num)/M[i][i];
    }
    
    //---------------------------------------------------------------------//
	// Here, we create a text file called "x.txt" and write X vector's values
	// on its first n-1 lines.
	
	cout << "x vector :\n";
	for(int i=0; i<number_n;i++){
		cout << X[i]<<"\n";
	}
	
	ofstream myfile_x;
	myfile_x.open("x.txt");
	for(int i=0; i<number_n;i++){
		myfile_x << X[i] << "\n";
	}
	myfile_x.close();
    
    //---------------------------------------------------------------------//
    // This is the part where we find condition numbers of matrix A if n=2 only.
    // To do that, we find A's columns and rows' absolute summations first and
    // question which one is bigger. Then, we need to find A inverse and do the
    // same operation one more time. Since we know n=2 as default, we do not
    // need to have a complex algorithm but we can find all entities one by one
    // using determinant. After finding all its norm_1s and norm_infs, we can
    // print its condition_number_1 and condition_number_inf.
    
    
    if(number_n == 2){
    	float col_1=fabs(A[0][0])+fabs(A[1][0]);
    	float col_2=fabs(A[0][1])+fabs(A[1][1]);
    	float row_1=fabs(A[0][0])+fabs(A[0][1]);
    	float row_2=fabs(A[1][0])+fabs(A[1][1]);
    	float A_norm_1,A_norm_inf;
    	
    	col_1 > col_2 ? A_norm_1=col_1 : A_norm_1=col_2;
    	row_1 > row_2 ? A_norm_inf=row_1 :A_norm_inf=row_2;
    	
    	float **A_inv;
    	A_inv = new float*[number_n];
    	
    	for(int r=0; r <number_n;r++){
		    A_inv[r]=new float[number_n];
	     }
	     
    	float det_A = A[0][0]*A[1][1]-A[0][1]*A[1][0];
    	
    	A_inv[0][0]=  A[1][1]/det_A;
    	A_inv[0][1]= -(A[0][1]/det_A);
    	A_inv[1][0]= -(A[1][0]/det_A);
    	A_inv[1][1]=  A[0][0]/det_A;
    	
    	float col_1_inv=fabs(A_inv[0][0])+fabs(A_inv[1][0]);
    	float col_2_inv=fabs(A_inv[0][1])+fabs(A_inv[1][1]);
    	float row_1_inv=fabs(A_inv[0][0])+fabs(A_inv[0][1]);
    	float row_2_inv=fabs(A_inv[1][0])+fabs(A_inv[1][1]);
    	float A_inv_norm_1,A_inv_norm_inf;
    	
    	col_1_inv > col_2_inv ? A_inv_norm_1=col_1_inv : A_inv_norm_1=col_2_inv;
    	row_1_inv > row_2_inv ? A_inv_norm_inf=row_1_inv :A_inv_norm_inf=row_2_inv;
    	
    
    	float condition_number_1 = A_norm_1*A_inv_norm_1;
    	float condition_number_inf = A_norm_inf*A_inv_norm_inf;
    	
    	cout << "\n";
    	cout << "A is (2 x 2) and its condition_number_1 ="<< condition_number_1 << "\n condition_number_inf =" << condition_number_inf;
	}
	

return 0;
}

//End of the code
