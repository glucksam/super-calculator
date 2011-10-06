//
//  MatrixTester.h
//  unsigned_calc
//
//  Created by Adi Glucksam on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Matrix.h"

@interface MatrixTester : NSObject {

}
/*private functions*/
+(bool) testDet:(Matrix*)mat;
+(bool) testTridiagonal:(Matrix*) mat;
+(bool) testInverse:(Matrix*) mat;
+(bool) testAdjoint:(Matrix*)mat;
+(bool) testRank:(Matrix*)mat;
+(bool) testCharacteristicPolynomailandEigenvalues:(Matrix*) mat;
+(void) PrintError:(NSString*)sError:(Matrix*)mat;
/*public functions*/
+(bool) TestWith:(Matrix*) mat;
+(bool) RandomTests;
+(bool) SanityTest;

@end
