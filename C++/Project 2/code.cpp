#include <iostream>
#include <math.h>
#include <iostream>
#include <fstream>
#include <string>
using namespace std;

//EMRE ÇİFÇİ 2019401012
//In this project, object oriented
//programming was used for simplicity
//To do that, a class named "Matrix"
//was built with some "fields" and
//"attributes".

//As shown below, class "Matrix" has
//two integers holding the size of A
//matrix, one double pointer holding
//A matrix itself using dynamic memory,
//build function that allocates the 
//entries of A matrix, tranpose function,
//constructor with two integers that
//builds the matrix and assign its
//row number and column number and another
//constructor with one integer that 
//creates a matrix (same size with A)
//at which all its entries equal to 0.

class Matrix{
	public:
		int numofrows, numofcols;
		double **mat;
		void build();
		Matrix transpose_func();
		Matrix(int numofrows,int numofcols);
};

//create the matrix
void Matrix::build(){
	mat = new double*[numofrows];
	for(int i =0;i< numofrows;i++){
		mat[i]=new double[numofcols];
	}
}

//assign the values
Matrix::Matrix(int rows, int cols): numofrows(rows),numofcols(cols){build();}


//tranpose function
Matrix transpose_func(Matrix matr){
	Matrix transposed(matr.numofcols,matr.numofrows);
	for(int i=0;i< matr.numofrows;i++){
		for(int j=0;j< matr.numofcols;j++){
			transposed.mat[j][i]=matr.mat[i][j];
		}
	}
	return transposed;
}

//In the main code, we will be using 
//the operator below:

//matrix plus another matrix with same size
Matrix operator+(const Matrix& mat1,const Matrix& mat2){
	Matrix temp(mat1.numofrows,mat1.numofcols);
	for(int i=0;i<mat1.numofrows;i++){
		for(int j=0;j<mat1.numofcols;j++){
			temp.mat[i][j]=mat1.mat[i][j] + mat2.mat[i][j];
		}
	}
	return temp;
}

//matrix minus another matrix with same size
Matrix operator-(const Matrix& mat1,const Matrix& mat2){
	Matrix temp(mat1.numofrows,mat1.numofcols);
	for(int i=0;i<mat1.numofrows;i++){
		for(int j=0;j<mat1.numofcols;j++){
			temp.mat[i][j]=mat1.mat[i][j] - mat2.mat[i][j];
		}
	}
	return temp;
}

//matrix times another matrix
Matrix operator*(const Matrix& mat1,const Matrix& mat2){
	Matrix temp(mat1.numofrows,mat2.numofcols);
	for(int i=0;i<mat1.numofrows;i++){
		for(int j=0;j<mat2.numofcols;j++){
			for(int k=0;k<mat2.numofrows;k++){
				temp.mat[i][j]=temp.mat[i][j] + (mat1.mat[i][k]*mat2.mat[k][j]);
			}
		}
	}
	return temp;
}

//matrix times a number
Matrix operator*(const Matrix& mat1,double multiplier){
	Matrix temp(mat1.numofrows,mat1.numofcols);
	for(int i=0;i<mat1.numofrows;i++){
		for(int j=0;j<mat1.numofcols;j++){
			temp.mat[i][j]=mat1.mat[i][j]*multiplier;
		}
	}
	return temp;
}

//This is a function that finds the
//infinity norm of a matrix:
double inf_norm(Matrix mat1){
	double norm_inf=0;
	double sum=0;
	for (int i = 0; i < mat1.numofrows; i++) {
        sum = 0;
        for (int j = 0; j < mat1.numofcols; j++) {
            sum = sum + fabs(mat1.mat[i][j]); 
        }
        if (sum > norm_inf) { 
            norm_inf = sum;
        }
    }
    return norm_inf; 
}

//main function has three inputs:
//name of the matrix A file, tolerance
//value and name of the output file.

int main(int argc, char** argv) {
	char* inp_matrix_file; 
    char* out_vector_file; 
    double tolerance; 
    if (argc != 4) { 
        cout << "There must be three inputs!";
        return 0;
    }
    
    inp_matrix_file = argv[1]; 
    tolerance = atof(argv[2]); 
    out_vector_file = argv[3]; 

    
    //first, open the file with matrix A
    
    ifstream readfile(inp_matrix_file);
    if (readfile.is_open() == 0) { 
        cout << "Input file cannot be opened.";
        return 0;
    }
    
    string line; 
    
    //integer "l" is used to hold
    //size n for matrix A(nxn)
    
    int l = 0;
    
    while (getline(readfile, line)) {
        l++; 
    }
    
    //clear and seekg functions are
    //used to set the cursor to the
    //beginning of the file
    
    readfile.clear(); 
    readfile.seekg(0); 
  
    Matrix matrix_A(l,l); 

    //then we read the file and allocate
    //its entries using the other constructor
    
    for (int i = 0; i < l; i++) { 
		for (int j = 0; j < l; j++) {
            readfile >> matrix_A.mat[i][j];
        }
    }

    readfile.close(); 
    
    Matrix eigenvector(l, 1); 
    
    //then make each entry equal to 1.
    for (int i = 0; i < eigenvector.numofrows; i++) {
        eigenvector.mat[i][0] = 1;      
    }
    //eigenvalue_1 is the dominant one
    double eigenvalue1 = 0; 
    double temp = 0; 
    
    //first we multipliy matrix A with 
    //vector named eigenvector which has
    //all entries equal to 1, this is our
    //starting point. Then we divide 
    //eigenvector by its infinity norm and
    //find the next eigenvector. After that,
    //we check whether the difference between
	//the previous eigenvalue and the current
	//one is bigger than the tolerance. So,
	//our aim is to get close enough to
	//make a good approximation for the 
	//dominant eigenvalue of this matrix.
	
    while(true){
        eigenvector = matrix_A * eigenvector; 
        temp = eigenvalue1;
        eigenvalue1 = inf_norm(eigenvector); 
        eigenvector = eigenvector * (1/eigenvalue1); 
        if(fabs(eigenvalue1 - temp) < tolerance){
			break;
		}
    } 
    
    //If first elements of eigenvector and the matrix
    //are different, eigenvalue must change sign
    Matrix sign = matrix_A * eigenvector; 
    if ((sign.mat[0][0] * eigenvector.mat[0][0]) < 0) {
        eigenvalue1 = eigenvalue1 * (-1);
    }

    ofstream writefile(out_vector_file); 
    
    if (writefile.is_open() == 0) { 
        cout << "Output file cannot be opened.";
        return 0;
    }
    writefile<<"Eigenvalue1:"<<eigenvalue1<<"\n"; 
    for(int i=0;i<l;i++){
        writefile<<eigenvector.mat[i][0]<<"\n";       
    }

	//second part of the code:
	//first we find the sum of the squared entries 
	//of the eigenvector
    double x = 0;
    for (int i = 0; i < eigenvector.numofrows;i++) {
        x = x + eigenvector.mat[i][0] * eigenvector.mat[i][0];
    } 
    //then find its norm
    x = sqrt(x); 
    
    //create a copy of the eigenvector named
    //"unitvec" and then divide it by the norm
    Matrix unitvec(l, 1); 
    unitvec = eigenvector; 
    //"unitvec" becomes the unit vector of eigenvector
    unitvec = unitvec * (1/ x); 
    
    //create a matrix named "deflation" with same
    //dimensions and this matrix is found taking
    //the product of unit eigenvector and its transpose
    Matrix deflation(l, l); 
    deflation = unitvec * transpose_func(unitvec); 
    
    //then we multiply this with the dominant eigenvalue
    //and subtract it from matrix A and finally
    //repeat the steps just like we did for the
    //dominant eigenvalue:
    
    deflation = deflation * eigenvalue1; 
    deflation = matrix_A - deflation; 
    double eigenvalue2=0;
	double tempvalue2=0; 
    Matrix eigenvector2(l, 1); 
    for (int i = 0; i < eigenvector2.numofrows;i++) { 
        eigenvector2.mat[i][0] = 1;    
    }
    while(true){ 
        eigenvector2 = deflation * eigenvector2;
        tempvalue2 = eigenvalue2;
        eigenvalue2 =inf_norm(eigenvector2);
        eigenvector2 = eigenvector2 * (1/eigenvalue2);
        if(fabs(eigenvalue2 - tempvalue2) < tolerance){
        	break;
		}
    } 
    
    Matrix sign_2 = deflation * eigenvector2; 
    if ((sign_2.mat[0][0] * eigenvector2.mat[0][0]) < 0) {
        eigenvalue2 = eigenvalue2 * (-1);
    }
    writefile<<"Eigenvalue2:"<<eigenvalue2<<"\n"; 
    
    //the end
    return 0; 
}
