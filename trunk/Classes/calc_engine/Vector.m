//
//  Vector.m
//  unsigned_calc
//
//  Created by Adi Glucksam on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Vector.h"


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
		NSLog(@"now geting %f\n", value);
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
	free(m_dElements);
	[super dealloc];
}

@end
