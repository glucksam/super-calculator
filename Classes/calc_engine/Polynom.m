//
//  Polynom.m
//  HelloWorld
//
//  Created by Adi Glucksam on 15/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Polynom.h"
#import "Operations.h"


@implementation Polynom
@synthesize m_iRank;

+(void) constMultiply:(Polynom*) p:(float) constant:(Polynom*) pRes{
	int i;
	int deg = p.m_iRank;
	float* coeffs;
	[Polynom initCoefficiant:&coeffs :deg];
	for (i = 0; i <= deg; i++) {
		coeffs [i] = [p getCoefficiant:i]*constant;
	}
	[pRes initNewPolinomWithCoeffs:deg :coeffs];
	free(coeffs);
}
/**********************************************************************************************/
+(void) multiply:(Polynom*) p:(Polynom*) q:(Polynom*) prod{
	int i,j;
	int deg = p.m_iRank + q.m_iRank;
	float* coeffs;
	[Polynom initCoefficiant:&coeffs :deg];
	for (i = 0; i <= p.m_iRank; i++) {
		for (j = 0; j <= q.m_iRank; j++){
			coeffs [i+j] += [p getCoefficiant:i]*[q getCoefficiant:j];
		}
	}

	[prod initNewPolinomWithCoeffs:deg :coeffs];
	if([Polynom isZeroPoly: prod]){
		[prod zerofy];
	}
	free(coeffs);
}
/**********************************************************************************************/
+(void) add:(Polynom*) p:(Polynom*) q:(Polynom*) pSum{
	int deg, i;
	if(p.m_iRank>q.m_iRank){
		deg = p.m_iRank;
	}else {
		deg = q.m_iRank;
	}
	float* coeffs;
	[Polynom initCoefficiant:&coeffs :deg];
	for (i = 0; i <= deg; i++) {
		coeffs[i] = [p getCoefficiant:i]+[q getCoefficiant:i];
	}
	[pSum initNewPolinomWithCoeffs:deg :coeffs];
	free(coeffs);
}
/**********************************************************************************************/
+(bool) isZeroPoly:(Polynom*)p{
	int i;
	for (i = 0; i<=[p getRank]; i++) {
		if([p getCoefficiant:i] != 0)
			return false;
	}
	return true;
}
/**********************************************************************************************/
/*
 since f(p/q) = a0+a1p/q+...+anp^n/q^n if p/q is a root, then f(p/q) = 0 = a0+a1p/q+...+anp^n/q^n
 therefore 0 = a0q^n+a1q^(n-1)p+...+anp^n then q is a devisor of an. Similarily p is a devisor of a0 
 */
+(void) getRationalRoots:(Polynom*)p:(float**)roots{
	int* a_factors;
	int* z_factors;
	float* optional_roots;
	if([p getCoefficiant:0] == 0){
		*roots = (float*) malloc(1* sizeof(float));
		(*roots)[0] = 0;
		return;
	}
	[Operations getFactors:abs([p getCoefficiant:0]):&a_factors];
	[Operations getFactors:abs([p getCoefficiant:[p getRank]]):&z_factors];
	[Operations getCombinations:a_factors:z_factors:&optional_roots];
	int i, ammount = 0;
	*roots = (float*) malloc((optional_roots[0]+1)* sizeof(float));
	for (i = 1; i<=optional_roots[0]; i++) {
		if ([Polynom isRoot:p:optional_roots[i]]) {
			ammount++;
			(*roots)[ammount] = optional_roots[i];
		}
		if ([Polynom isRoot:p:((-1)*optional_roots[i])]) {
			ammount++;
			(*roots)[ammount] = ((-1)*optional_roots[i]);
		}
		
	}
	(*roots)[0] = ammount;
	free(a_factors);
	free(z_factors);
	free(optional_roots);
}
/**********************************************************************************************/
+(bool) isRoot:(Polynom*)p:(float)x{
	if([p getValue:x] == 0)
		return true;
	return false;
}
/**********************************************************************************************/
-(float) getValue:(float) x
{
	int i;
	float fRes = 0.0;
	for (i = 0; i<=m_iRank; i++) {
		fRes += m_fCoefficients[i]*pow(x, i);
	}
	return fRes;
}
/**********************************************************************************************/
-(void) zerofy{
	[self clean];
	[Polynom initCoefficiant:&m_fCoefficients :m_iRank];
}
/**********************************************************************************************/
-(void) clean{
	m_iRank = 0;
	free(m_fCoefficients);
	m_fCoefficients = nil;
}
/**********************************************************************************************/
-(NSString*) toString{
	int i;
	[super init];
	[super setObjName:@"Polynom"];	NSMutableString *print = [[NSMutableString alloc]initWithString:@""];
	bool bIsFirst = true;
	[print appendFormat:@"["];
	for(i = 0; i <= m_iRank ; i++){
		if(m_iRank != 0 && m_fCoefficients[i] == 0)
			continue;
		if(bIsFirst){
			bIsFirst = false;
		}else {
			[print appendFormat:@" + "];
		}

		if(0 == i){
			[print appendFormat:@"%.3f", m_fCoefficients[i]];
			continue;
		}
		if (m_fCoefficients[i] == 1) {
			[print appendFormat:@"x^%d",i];
		}else{
			[print appendFormat:@"%.3f*x^%d", m_fCoefficients[i],i];
		}
	}
	[print appendFormat:@"]"];
	NSString* res = [NSString stringWithString: print];
	[print release];
	return res;
}
/**********************************************************************************************/
-(int) getRank{
	return m_iRank;
}
/**********************************************************************************************/
-(float) getCoefficiant:(int)index{
	if(index <= m_iRank){
		return m_fCoefficients[index];
	}
	else {
		return 0;
	}
}
/**********************************************************************************************/
-(void) setCoefficiant:(int)index: (float) value{
	if(index <= m_iRank){
		m_fCoefficients[index] = value;
	}
}
/**********************************************************************************************/
-(void) initNewPolinomWithCoeffs: (int) rank: (float*) coeffs{
	[super init];
	[super setObjName:@"Polynom"];
	m_iRank = rank;
	[Polynom initCoefficiant:&m_fCoefficients :m_iRank];
	int i;
	for (i = 0; i <= m_iRank; i++) {
		m_fCoefficients[i] = coeffs [i];
	}
}
/**********************************************************************************************/
+(void) initCoefficiant:(float**) coef: (int) size{
	*coef = (float*) malloc((size + 1) * sizeof(float));
	memset(*coef, 0, (size + 1) * sizeof(float));
}
/**********************************************************************************************/
/*input must be given with + even if the coefficiants are negative for instance 1x^2+-5x^1+-7x^0*/
-(void) initNewPolinomWithString:(NSString*) input{
	[super init];
	[super setObjName:@"Polynom"];
	
	int iMaxDeg, iTemp;
	float fPrev;
	Boolean isFirst = true;
	iMaxDeg = 0;
	NSArray* chunks = [input componentsSeparatedByString: @"^"];
	for(NSString* string in chunks){
		if(isFirst){
			isFirst = false;
			continue;
		}
		NSArray* subChunks = [string componentsSeparatedByString: @"+"];
		iTemp = [[subChunks objectAtIndex:0] intValue];
		if(iTemp > iMaxDeg){
			iMaxDeg = iTemp;
		}
	}
	m_iRank = iMaxDeg;
	[Polynom initCoefficiant:&m_fCoefficients :m_iRank];
	isFirst = true;
	for(NSString* string in chunks){
		if(isFirst){
			isFirst = false;
			fPrev = [string floatValue];
			continue;
		}
		NSArray* subChunks = [string componentsSeparatedByString: @"+"];
		iTemp = [[subChunks objectAtIndex:0] intValue];
		m_fCoefficients [iTemp] = fPrev;
		if (2 == [subChunks count]) {
			fPrev = [[subChunks objectAtIndex:1] floatValue];
		}
	}
}
/**********************************************************************************************/
-(void) dealloc {
    NSLog(@"Deallocing Polynom\n" );
	if (m_fCoefficients!= nil) {
		free(m_fCoefficients);
	}
	[super dealloc];
}

@end
