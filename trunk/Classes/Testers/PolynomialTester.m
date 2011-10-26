//
//  PolynomialTester.m
//  unsigned_calc
//
//  Created by Adi Glucksam on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


#import "PolynomialTester.h"
#import "Logger.h"

#define MAX_RANK 5
#define MAX_COEFF 10
#define NUM_OF_RANDOM_TESTS 100
#define  MAX(a,b)  ( ((a) > (b)) ? (a):(b))
@implementation PolynomialTester
/*this is going to be the following test-
 we know a polynomial of rank n has at most n roots.
 We shall then test (rank p)*(rank q) different numbers 1,2,...,(rank p)*(rank q)
 choose. If p(x)*q(x)-(p*q)(x) = 0 for them all then this is the 0 polynomial*/

+(bool) testMultiply:(Polynom*)p:(Polynom*)q{
	Polynom* pProd = [Polynom alloc];
	[Polynom multiply:p :q :pProd];
	[[Logger getInstance] PrintToLog:@"testMultiply\nresult:\n" :INFO :POLYNOMIAL :1,pProd];
	int i;
	bool res = true;
	for (i = 0; i<MAX(p.m_iRank,q.m_iRank); i++) {
		if (0 != ([p getValue:i]*[q getValue:i] - [pProd getValue:i])) {
			NSString* tempStr = [NSString stringWithFormat:@"failed due to %i",i];
			[[Logger getInstance] PrintToLog:tempStr :ERROR :POLYNOMIAL :0];
			res = false;
			break;
		}
		if (0 != ([p getValue:(-1)*i]*[q getValue:(-1)*i] - [pProd getValue:(-1)*i])) {
			NSString* tempStr = [NSString stringWithFormat:@"failed due to %-i",i];
			[[Logger getInstance] PrintToLog:tempStr :ERROR :POLYNOMIAL :0];
			res = false;
			break;
		}
	}
	[pProd release];
	return res;
}
/**********************************************************************************************/
+(bool) testDivide:(Polynom*)p:(Polynom*)q{
	Polynom* pResult = [Polynom alloc];
	Polynom* pResidue = [Polynom alloc];
	Polynom* pMultRes = [Polynom alloc];
	Polynom* pFinalRes = [Polynom alloc];
	[Polynom divide:p :q :pResult :pResidue];
	[Polynom multiply:q :pResult :pMultRes];
	[Polynom add:pMultRes :pResidue :pFinalRes];
	bool res = false;
	[[Logger getInstance] PrintToLog:@"testDivide\nresult and residue are" :INFO :POLYNOMIAL :2,pResult,pResidue];
	if ([Polynom compare:p :pFinalRes]) {
		res = true;
	}
	[pResult release];
	[pResidue release];
	[pMultRes release];
	[pFinalRes release];
	return res;
}
/**********************************************************************************************/
/*c testMult for explanation*/
+(bool) testAdd:(Polynom*)p:(Polynom*)q{
	Polynom* pAdd = [Polynom alloc];
	[Polynom add:p :q :pAdd];
	[[Logger getInstance] PrintToLog:@"testAdd\nresult:" :INFO :POLYNOMIAL :1,pAdd];
	int i;
	bool res = true;
	for (i = 0; i<MAX(p.m_iRank,q.m_iRank); i++) {
		if (0 != ([p getValue:i]+[q getValue:i] - [pAdd getValue:i])) {
			NSString* tempStr = [NSString stringWithFormat:@"failed due to %i",i];
			[[Logger getInstance] PrintToLog:tempStr :ERROR :POLYNOMIAL :0];
			res = false;
			break;
		}
	}
	[pAdd release];
	return res;
}
/**********************************************************************************************/
+(bool) testCompare:(Polynom*)p:(Polynom*)q{
	bool bSameRank = (p.m_iRank == q.m_iRank);
	bool bSameCoeefs = true;
	int i;
	for (i = 0; i<=p.m_iRank; i++) {
		if ([p getCoefficiant:i] != [q getCoefficiant:i]) {
			bSameCoeefs = false;
			break;
		}
	}
	return ((bSameRank && bSameCoeefs) == [Polynom compare:p :q]);
}
/**********************************************************************************************/
+(bool) testGetRationalRoots:(Polynom*)p{
	return true;
}
/**********************************************************************************************/
+(bool) TestWith:(Polynom*)p:(Polynom*)q{
	[[Logger getInstance]  PrintToLog:@"testing polynomials:" :INFO :POLYNOMIAL :2,p,q];
	if ([PolynomialTester testMultiply:p :q]){
		if ([PolynomialTester testDivide :p :q]){
			if([PolynomialTester testAdd:p :q]){
				if ([PolynomialTester testCompare :p :q]) {
					if ([PolynomialTester testGetRationalRoots:p]) {
						return true;
					}else {
						[[Logger getInstance] PrintToLog:@"rational roots test failed":ERROR:POLYNOMIAL:0];
					}
				}else {
					[[Logger getInstance] PrintToLog:@"compare test failed":ERROR:POLYNOMIAL:0];
				}
			}else {
				[[Logger getInstance] PrintToLog:@"add test failed" :ERROR:POLYNOMIAL:0];
			}
		}else {
			[[Logger getInstance] PrintToLog:@"divide test failed" :ERROR:POLYNOMIAL:0];
		}
	}else {
		[[Logger getInstance] PrintToLog:@"multiply test failed" :ERROR:POLYNOMIAL:0];
	}
	return false;
}
/**********************************************************************************************/
+(void) CreateRandomPolynomail:(Polynom*)p{
	int iRank = arc4random()%MAX_RANK;/*choose rank*/
	int i;
	float fTemp;
	float* coeffs = (float*)malloc((iRank+1)*sizeof(float));
	for (i = 0; i<=iRank; i++) {
		fTemp = (arc4random()%MAX_COEFF);/*randomly choose coefficiants*/
		while (0 == fTemp) {
			fTemp = (arc4random()%MAX_COEFF);/*randomly choose coefficiants*/
		}
		coeffs[i] = fTemp;
	}
	[p initNewPolinomWithCoeffs:iRank:coeffs];
	free(coeffs);
}
/**********************************************************************************************/
+(bool) RandomTest{
	Polynom* p = [Polynom alloc];
	Polynom* q = [Polynom alloc];
	
	[PolynomialTester CreateRandomPolynomail:p];
	[PolynomialTester CreateRandomPolynomail:q];
	
	bool bRes = [PolynomialTester TestWith:p :q];
	[p release];
	[q release];
	return bRes;
}
/**********************************************************************************************/
+(bool) SanityTest{
	Polynom* p = [Polynom alloc];
	Polynom* q = [Polynom alloc];
	[p initNewPolinomWithString:@"1x^3+2x^2+1x^1"];
	[q initNewPolinomWithString:@"1x^2+-2x^1+3x^0"];
	bool res = [PolynomialTester TestWith:p :q];
	[p release];
	[q release];
	NSString* sMsg;
	int i;
	bool bTempRes;
	for (i = 0; i<NUM_OF_RANDOM_TESTS; i++) {
		bTempRes = [PolynomialTester RandomTest];
		if (bTempRes) {
			sMsg = [NSString stringWithFormat:
					@"\n*******************Test number %d Succeeded*******************",i];
		}else {
			sMsg = [NSString stringWithFormat:@"\n*******************Test number %d failed*******************",i];
		}
		res = res && bTempRes;
		[[Logger getInstance]PrintToLog:sMsg:INFO :POLYNOMIAL :0];
	}
	return res;
}
@end
