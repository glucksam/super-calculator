//
//  Tester.m
//  unsigned_calc
//
//  Created by Adi Glucksam on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Logger.h"
#import "Matrix.h"
#import "polymatrix.h"
#import "Polynom.h"
#import "Vector.h"
#import "VectorSpace.h"

@implementation Logger

static Logger* Log;

+(Logger*)getInstance{
	@synchronized(self){
		if (!Log){
			Log = [[Logger alloc] init];
		}
		return Log;
	}
}

-(id) init{
	m_bIsActive = true;
	return [super init];
}

-(void) setIsActive:(bool)bIsActive{
	m_bIsActive = bIsActive;
}

-(void) PrintToLog:(NSString*)sMsg:(typeID)type:(elementID)Id:(int)num_of_elemets,...{
	if (!m_bIsActive) {
		return;
	}
	NSMutableString* tempStr = [[NSMutableString alloc] init];
	int i;
	
	switch (type) {
		case ERROR:
			[tempStr appendFormat:@"ERROR: %@\n",sMsg];
			break;
		case WARNING:
			[tempStr appendFormat:@"WARNING: %@\n",sMsg];
			break;
		case INFO:
			[tempStr appendFormat:@"INFO: %@\n",sMsg];
			break;
		default:
			[tempStr appendFormat:@"%@\n",sMsg];
			break;
	}
	
	va_list args;
	va_start(args, num_of_elemets);
	Matrix* tempMat;
	polymatrix* tempPolyMat;
	Polynom* tempPoly;
	VectorSpace* tempVecSpace;
	Vector* tempVec;
	Vector** tempVecArray;
	float* tempFloat;
	
	switch (Id) {
		case MATRIX:
			for(i = 0;i<num_of_elemets; i++) {
				tempMat = va_arg(args, Matrix*);
				[tempStr appendFormat:@"matrix %d:\n%@\n",i,[tempMat toString]];
			}
			break;
		case POLYMATRIX:
			for(i = 0;i<num_of_elemets; i++) {
				tempPolyMat = va_arg(args, polymatrix*);
				[tempStr appendFormat:@"matrix %d:\n%@\n",i,[tempPolyMat toString]];
			}
			break;
		case POLYNOMIAL:
			for(i = 0;i<num_of_elemets; i++) {
				tempPoly = va_arg(args, Polynom*);
				[tempStr appendFormat:@"polynomial %d:\n%@\n",i,[tempPoly toString]];
			}
			break;
		case VECTOR_SPACE:
			for(i = 0;i<num_of_elemets; i++) {
				tempVecSpace = va_arg(args, VectorSpace*);
				[tempStr appendFormat:@"vector space %d:\n%@\n",i,[tempVecSpace toString]];
			}
			break;
		case VECTOR:
			for(i = 0;i<num_of_elemets; i++) {
				tempVec = va_arg(args, Vector*);
				[tempStr appendFormat:@"vector %d:\n%@\n",i,[tempVec toString]];
			}
			break;
		case VECTOR_ARRAY:
			tempVecArray = va_arg(args, Vector**);
			for(i = 0;i<num_of_elemets; i++) {
				[tempStr appendFormat:@"vector %d:\n%@\n",i,[tempVecArray[i] toString]];
			}
			break;	
			/*the first element is the number of elemets in the array*/
		case FLOAT:
			tempFloat = va_arg(args, float*);
			for(i = 1;i<= tempFloat[0] ; i++) {
				[tempStr appendFormat:@"%f ",tempFloat[i]];
			}
			break;
			
		default:
			break;
	}
	va_end(args);
	NSLog(@"%@",tempStr);
	[tempStr release];
}


@end
