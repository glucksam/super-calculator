//
//  Vector.m
//  unsigned_calc
//
//  Created by Adi Glucksam on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Vector.h"
#import "VectorSpace.h"


@implementation Vector
@synthesize m_iNumOfElements;

-(NSString*) toString{
	int i;
	NSMutableString *print = [[NSMutableString alloc] init];
	bool bIsFirst = true;
	for (i = 0; i<m_iNumOfElements; i++) {
		if(bIsFirst){
			[print appendFormat:@"[%f",m_dElements[i]];
			bIsFirst = false;
		}else {
			[print appendFormat:@",%f",m_dElements[i]];
		}
	}
	[print appendFormat:@"]"];
	NSString* res = [NSString stringWithString: print];
	[print release];	
	return res;
}
/**********************************************************************************************/
+(void) add:(Vector*) v:(Vector*) u:(Vector*)res{
	int i;
	NSMutableString *ms_res = [[NSMutableString alloc] init];
	bool bIsFirst = true;
	for (i = 1; i<=[v m_iNumOfElements]; i++) {
		if(bIsFirst){
			[ms_res appendFormat:@"[%f",[v getElement:i]+[u getElement:i]];
			bIsFirst = false;
		}else {
			[ms_res appendFormat:@",%f",[v getElement:i]+[u getElement:i]];
		}
	}
	[ms_res appendFormat:@"]"];
	[res initNewVectorWithSring:ms_res];
	[ms_res release];	
}
/**********************************************************************************************/
+(double) inner_prod:(Vector*) v:(Vector*) u{
	int i;
	double inRes = 0.0;
	for (i = 1; i<=[v m_iNumOfElements]; i++) {
		inRes+=[v getElement:i]*[u getElement:i];
	}
	return inRes;
}
/**********************************************************************************************/
+(void) multiply:(Vector*) v:(double) con:(Vector*)res{
	NSMutableString *ms_res = [[NSMutableString alloc] init];
	bool bIsFirst = true;
	int i;
	for (i = 1; i<=[v m_iNumOfElements]; i++) {
		if(bIsFirst){
			[ms_res appendFormat:@"[%f",[v getElement:i]*con];
			bIsFirst = false;
		}else {
			[ms_res appendFormat:@",%f",[v getElement:i]*con];
		}
	}
	[ms_res appendFormat:@"]"];
	[res initNewVectorWithSring:ms_res];
	[ms_res release];
}
/**********************************************************************************************/
-(double) getNorm{
	double dNorm = [Vector inner_prod:self :self];
	return sqrt(dNorm);
}
/**********************************************************************************************/
-(void) clean{
	m_iNumOfElements = 0;
	free(m_dElements);
	m_dElements = nil;
}
/**********************************************************************************************/
-(double) getElement:(int)index{
	if(index > m_iNumOfElements){
		return 0;
	}else {
		return m_dElements[index-1];
	}
}
/**********************************************************************************************/
-(void)initNewVector:(int) count, ...{
	[super init];
	[super setObjName:@"Vector"];

	va_list args;
	va_start(args, count);
	m_iNumOfElements = count;
	m_dElements = (double *)malloc(m_iNumOfElements * sizeof(double));
	double value;
	int i;
	for(i = 0;i<count; i++) {
		value = va_arg(args, double);
		m_dElements[i] = value;
	}
	va_end(args);
}
/**********************************************************************************************/
-(void)initNewVectorWithSring:(NSString*) input{
	[super init];
	[super setObjName:@"Vector"];

	NSMutableString *mutableString = [NSMutableString stringWithString:input];
	[mutableString deleteCharactersInRange:[mutableString rangeOfString: @"]"]];
	[mutableString deleteCharactersInRange:[mutableString rangeOfString: @"["]];
	NSString *string = mutableString;
	int i;
	NSArray *chunks = [string componentsSeparatedByString: @","];
	m_iNumOfElements = [chunks count];
	m_dElements = (double *)malloc(m_iNumOfElements * sizeof(double));

	for(i = 0;i<m_iNumOfElements; i++){
		m_dElements[i] = [[chunks objectAtIndex: i] doubleValue];
	}
}
/**********************************************************************************************/
-(void) dealloc {
    NSLog(@"Deallocing Vector\n" );
	if (m_dElements!= nil) {
		free(m_dElements);
	}
	[super dealloc];
}
/**********************************************************************************************/
/*+(void) testVectorTest{
	int i_subspace_rank = 4;
	int i_space_rank = 4;
	Vector** vBasis = (Vector**)malloc(i_subspace_rank * sizeof(Vector*));
	vBasis[0] = [Vector alloc];
	[vBasis[0] initNewVectorWithSring:@"[1,2,0,0]"];
	vBasis[1] = [Vector alloc];
	[vBasis[1] initNewVectorWithSring:@"[1,0,1,0]"];
	vBasis[2] = [Vector alloc];
	[vBasis[2] initNewVectorWithSring:@"[1,0,0,0]"];
	vBasis[3] = [Vector alloc];
	[vBasis[3] initNewVectorWithSring:@"[0,0,0,1]"];
	Vector** uBasis = (Vector**)malloc(i_subspace_rank * sizeof(Vector*));
	uBasis[0] = [Vector alloc];
	[uBasis[0] initNewVectorWithSring:@"[1,0,0,0]"];
	uBasis[1] = [Vector alloc];
	[uBasis[1] initNewVectorWithSring:@"[0,1,0,0]"];
	uBasis[2] = [Vector alloc];
	[uBasis[2] initNewVectorWithSring:@"[0,0,1,0]"];
	uBasis[3] = [Vector alloc];
	[uBasis[3] initNewVectorWithSring:@"[0,0,0,1]"];
	VectorSpace* vSpace = [VectorSpace alloc];
	[vSpace initVectorSpace:i_space_rank :i_subspace_rank :vBasis];
	VectorSpace* uSpace = [VectorSpace alloc];
	[uSpace initVectorSpace:i_space_rank :i_subspace_rank :uBasis];

	if ([VectorSpace isEqual:vSpace	:uSpace]) {
		NSLog(@"Vector spaces are equal!!!");
	}else {
		NSLog(@"Vector space are NOT equal!!!");
	}

	Vector* v = [Vector alloc];
	[v initNewVectorWithSring:@"[1,2,2,0]"];
	if ([vSpace isInSpace:v]) {
		NSLog(@"Vector in space!!!");
	}else {
		NSLog(@"Vector is NOT in space!!!");
	}

	for(int i = 0;i<i_subspace_rank; i++) {
		[vBasis[i] release];
	}
	free(vBasis);
	NSLog(@"%@",[vSpace toString]);
	[vSpace release];
}*/
@end
