//
//  PolynomialTester.h
//  unsigned_calc
//
//  Created by Adi Glucksam on 6/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Polynom.h"

@interface PolynomialTester : NSObject {

}
/*private functions*/
+(bool) testMultiply:(Polynom*)p:(Polynom*)q;
+(bool) testDivide:(Polynom*)p:(Polynom*)q;
+(bool) testAdd:(Polynom*)p:(Polynom*)q;
+(bool) testCompare:(Polynom*)p:(Polynom*)q;
+(bool) testGetRationalRoots:(Polynom*)p;
+(void) CreateRandomPolynomail:(Polynom*)p;
/*public functions*/
+(bool) TestWith:(Polynom*)p:(Polynom*)q;
+(bool) RandomTest;
+(bool) SanityTest;
@end
