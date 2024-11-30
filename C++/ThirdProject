#include <iostream>
#include <cmath>
#include <stdlib.h>
using namespace std;
//Emre Çifçi: 2019401012 EE242 PROJECT 3

//This function find the value of f(x) for
//any x using the coef array and integer n
//which holds the size of the array
float find(float* coef,float x, int n){
	float sum=0;
	for(int i=n,j=0;i>=0;i--,j++){
		sum=sum+coef[j]*pow(x,i);
	}
	return sum;
}

//In this code, we are given n+1 coefficient,
//2 initial values and the tolerance value
int main(int argc,char** argv){
	
	//max loop is to avoid infinite while loops
	int max_loop = 100;
	int max=0;
	
	//We have totally n+1 coefficient values,
	//2 initial values and 1 tolerance value
	//after argv[0] (file name), which means
	//n+5 values. If argc=n+5, n= argc-5
	
	int n=argc-5;
	
	//We use dynamically allocated memory here
	float *coef;
	coef=new float[n+1];
	
	//coefficient starts from argv[1]
	for(int i=1;i<=n+1;i++){
		coef[i-1]=atof(argv[i]);
	}
	
	float x0=atof(argv[n+2]);
	float x1=atof(argv[n+3]);
	float tolerance=atof(argv[n+4]);
	
	//iteration array holds the total # iterations
	//for each method: iteration[0]: secant method,
	//iteration[1]: bisection method, iteration[2]:
	//hybrid method
	float iteration[]={0,0,0};
	
	// secant method:-------------------------------------------------------------------------------//
	float sec_x0=x0;
	float sec_x1=x1;
	float sec_x2;
	
	//if x1 and x0 get close enough (convergence) or the loop 
	//works more than 100 times(arbitrarily chosen),
	//loop is broken, else it continues
	while((fabs(sec_x1-sec_x0)> tolerance)&& max<=max_loop){
		
		//x2 for this method is found using x2=x1-f(x1)*(x1-x0)/(f(x1)-f(x0)) 
		sec_x2= sec_x1-find(coef,sec_x1,n)*(sec_x1-sec_x0)/(find(coef,sec_x1,n)-find(coef,sec_x0,n));
		
		//This is exactly what we want to find: f(x)=0
		if(find(coef,sec_x2,n)==0){
			break;
		}
		//then x0 x1 and x2 shifts to the left and new x2 is found in the 
		//next turn
		sec_x0=sec_x1;
		sec_x1=sec_x2;
		iteration[0]++;
		max++;
	}
	
	// bisection method:----------------------------------------------------------------------------//
	float bis_x0=x0;
	float bis_x1=x1;
	float bis_x2;
	//max is initialized
	max=0;
	
	//We should now check whether f(x0) and f(x1) have the same sign
	//if they have, we cannot apply this method and we should exit
	//and wait for a better pair of initial guesses.
	if(not((find(coef,bis_x0,n)>0)xor(find(coef,bis_x1,n)>0))){
		cout<< "f(x0) and f(x1) have the same sign, please change your initial guesses! \n";
		exit(0);        	
    }
    
	while((max <=max_loop) && ((bis_x1-bis_x0)>tolerance) ){  
	    //x2 is now the mid point, we pay attention possible errors
		//that might come from floating point arithmetic: that's why
		//we find mid point using x0+(x1-x0)/2 instead of (x0+x1)/2           
		        
		bis_x2=bis_x0+fabs(bis_x1-bis_x0)/2;
		
		//We can end the loop if f(x2) is zero since it is exactly
		//what we want to find or the difference between x1 and x0
		//is satisfactory.
		if((find(coef,bis_x2,n)==0)){
			break;
		}

		//Now, we should check whether f(x0) and f(x2) have the same
		//sign or not. If so, x0 becomes x2 else x1 becomes x2
		if((find(coef,bis_x0,n)>0) xor (find(coef,bis_x2,n)>0)){
			bis_x1=bis_x2;
		}
		else{
			bis_x0=bis_x2;
		}
		
		max++;
		iteration[1]++;
	}
	//hybrid method:
	float hyb_x0=x0;
	float hyb_x1=x1;
	float hyb_x2;
	
	//for first two iterations, we use bisection method
	//and repeat the same steps yet we do not need to add any
	//max_loop since we only apply this method for 2 iterations

	for(int i=0;i<2;i++){
		hyb_x2=hyb_x0+fabs(hyb_x1-hyb_x0)/2;
		if((find(coef,hyb_x2,n)==0) || ((hyb_x1-hyb_x0)<=tolerance)){
			break;
		}
		if((find(coef,hyb_x0,n)>0) xor (find(coef,hyb_x2,n)>0)){
			hyb_x1=hyb_x2;
		}
		else{
			hyb_x0=hyb_x2;
		}
		iteration[2]++;
	}
	max=0;
	 

	while((max<=max_loop) && (fabs(hyb_x1-hyb_x0)> tolerance)){
		hyb_x2= hyb_x1-find(coef,hyb_x1,n)*(hyb_x1-hyb_x0)/(find(coef,hyb_x1,n)-find(coef,hyb_x0,n));
		hyb_x0=hyb_x1;
		hyb_x1=hyb_x2;
		iteration[2]++;
		max=max+1;
	}
	cout << "Secant Method Solution: "<< sec_x2 << "  with iteration: "<< iteration[0] <<"\n";
	cout << "Bisection Method Solution:  "<< bis_x2 <<"  with iteration: "<< iteration[1] <<"\n";
	cout << "Hybrid Method Solution:  "<< hyb_x2 << "  with iteration: "<< iteration[2]<<"\n";
	return 0;
}
