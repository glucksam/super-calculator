//
//  Polynom.h
//  HelloWorld
//
//  Created by Adi Glucksam on 15/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathObject.h"


@interface Polynom : MathObject {
	@private
	float*	m_fCoefficients;
	int			m_iRank;
}
@property (readonly) int m_iRank;
/*private functions- internal functions*/
-(float) getCoefficiant:(int)index;
-(void) setCoefficiant:(int)index: (float) value;
-(int) getRank;
-(void) zerofy;
-(void) clean;
-(void) resetRank;
/*public functions*/
-(void) initNewPolinomWithString:(NSString*) input;
-(void) initNewPolinomWithCoeffs:(int) rank:(float*) coeffs;
-(float) getValue:(float) x;
-(bool) isZeroPoly;
-(bool) isRoot:(float)x;
-(void) getRationalRoots:(float**)roots;
-(NSString*) toStringForInit;
-(NSString*) toString;
/*static functions*/
+(void) initCoefficiant:(float**) coef: (int) size;

+(void) constMultiply:(Polynom*) p:(float) constant:(Polynom*) pRes;
+(void) multiply:(Polynom*) p:(Polynom*) q:(Polynom*) prod;
+(void) add:(Polynom*) p:(Polynom*) q:(Polynom*) pSum;
+(void) divide:(Polynom*) p:(Polynom*) q:(Polynom*) result:(Polynom*)residue;
+(bool) compare:(Polynom*) p:(Polynom*) q;
+(void) copyPolynom:(Polynom*)original:(Polynom*)copy;
@end
