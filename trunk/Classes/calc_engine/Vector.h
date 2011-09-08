//
//  Vector.h
//  unsigned_calc
//
//  Created by Adi Glucksam on 8/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathObject.h"


@interface Vector : MathObject {
	double* m_dElements;
	int m_iNumOfElements;
}
@property (readonly) int m_iNumOfElements;
/*public functions*/
-(NSString*) toString;
-(void)initNewVector:(int) count, ...;
-(void)initNewVectorWithSring:(NSString*) input;
-(double) getElement:(int)index;
/*static functions*/
+(void) add:(Vector*) v:(Vector*) u:(Vector*)res;
+(double) inner_prod:(Vector*) v:(Vector*) u;
+(void) multiply:(Vector*) v:(double) con:(Vector*)res;
@end
