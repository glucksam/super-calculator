//
//  Operations.m
//  unsigned_calc
//
//  Created by Adi Glucksam on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Operations.h"


@implementation Operations

const int NUM_OF_PRIMES = 30;
const int Primes[30] = {2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 
								53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113};
/**********************************************************************************************/
+(bool) isPrime:(int)number{
	int i;
	for (i = 0; i<NUM_OF_PRIMES; i++) {
		if(number == Primes[i])
			return true;
	}
	return false;
}
/**********************************************************************************************/
+(bool) isDevidedByPrime:(int)number:(int)primeIndex{
	if(Primes[primeIndex]>number)
		return false;
	float fNum = (float)number;
	float fRes = fNum/Primes[primeIndex];
	if(fRes == number/Primes[primeIndex])
		return true;
	return false;
}
/**********************************************************************************************/
+(bool) isDevided:(int)number:(int)devider{
	if(devider>number)
		return false;
	float fNum = (float)number;
	float fRes = fNum/devider;
	if(fRes == number/devider)
		return true;
	return false;
}
/**********************************************************************************************/
/*p[0],q[0] are expected to have number of elements in p,q
 f_combinations[0] will have the number of combinations generated*/
+(void) getCombinations:(int*)p:(int*)q:(float**)f_combinations{
	int i,j;
	*f_combinations = (float*) malloc((p[0]*q[0]+1)* sizeof(float));
	(*f_combinations)[0] = 0;
	for (i = 1; i<=p[0]; i++)
		for (j = 1; j<=q[0]; j++){
			/*to make sure combinations are unique*/
			if(!([Operations isInArray:*f_combinations :((float)p[i])/q[j]])){
				(*f_combinations)[0] += 1;
				(*f_combinations)[(int)((*f_combinations)[0])] = ((float)p[i])/q[j];
			}
		}
}
/**********************************************************************************************/
+(void) getFactors:(int) number:(int**)factors{/*in the first spot it will be written 
												how many elements are there*/
	*factors = (int*) malloc(sqrt(number)*2 * sizeof(int));
	int i, iNumOfFactors = 0;
	for (i = 1; i<=sqrt(number); i++) {
		if([self isDevided:number:i]){
			iNumOfFactors+=2;
			(*factors)[iNumOfFactors-1] = i;
			(*factors)[iNumOfFactors] = number/i;
		}
	}
	(*factors)[0] = iNumOfFactors;
}
/**********************************************************************************************/
/*expecting array[0] will have the number of elements in array*/
+(bool) isInArray:(float*)array:(float)element{
	int i;
	for (i = 1; i<=array[0]; i++) {
		if(array[i] == element){
			return true;
		}
	}
	return false;
}
/**********************************************************************************************/
+(void) printMatrixToLog:(float**)mat:(int)size{
	int i,j;
	NSMutableString *print = [[NSMutableString alloc] init];
	for(i = 0; i<size; i++){
		NSMutableString *line =  [[NSMutableString alloc] init];
		for(j = 0; j < size; j++){
			[line appendFormat:@"%0.3f ", mat[i][j]];
		}
		[line appendFormat:@"\n"];
		[print appendString:line];
		[line release];
	}
	NSLog(@"\n%@",print);
	[print release];
}

@end
