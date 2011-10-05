//
//  MatrixTester.m
//  unsigned_calc
//
//  Created by Adi Glucksam on 5/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MatrixTester.h"


@implementation MatrixTester

static NSString* ID4 = @"[1.000 0.000 0.000 0.000;0.000 1.000 0.000 0.000;0.000 0.000 1.000 0.000;0.000 0.000 0.000 1.000]";
static NSString* Sing3 = @"[1.000 2.000 3.000;4.000 5.000 6.000;7.000 8.000 9.000]";
static NSString* Huge5 = @"[1.000 2.000 4.000 0.000 0.000;0.000 1.000 2.000 4.000 0.000;0.000 0.000 2.000 4.000 0.000;0.000 0.000 0.000 2.000 4.000;0.000 0.000 0.000 0.000 1.000]";
/**********************************************************************************************/
/*should be tested after tridiagonalizeAndInverse*/
+(bool) testDet:(Matrix*)mat{
	float fDet = mat.m_fdet;
	if (YES == [[mat toStringForInit] isEqualToString:ID4]) {
		return (fDet == 1);
	}else if (YES == [[mat toStringForInit] isEqualToString:Sing3]) {
		return (fDet == 0);
	}else if (YES == [[mat toStringForInit] isEqualToString:Huge5]) {
		return (fDet == 4);
	}else {/*this part will use wolfram for future tests*/
		return true;
	}
}
/**********************************************************************************************/
+(bool) testTridiagonal:(Matrix*) mat{
	if (YES == [[mat toStringForInit] isEqualToString:ID4]) {
		return (YES == [[mat toString] isEqualToString:[mat triagonalMatrixToString]]);
	}else if (YES == [[mat toStringForInit] isEqualToString:Sing3]) {
		return (YES == [[mat triagonalMatrixToString] isEqualToString:@"1.000 2.000 3.000 \n0.000 -3.000 -6.000 \n0.000 0.000 0.000 \n"]);
	}else if (YES == [[mat toStringForInit] isEqualToString:Huge5]) {
		return (YES == [[mat toString] isEqualToString:[mat triagonalMatrixToString]]);
	}else {/*this part will use wolfram for future tests*/
		return true;
	}	
}
/**********************************************************************************************/
+(bool) testInverse:(Matrix*) mat{
	if (YES == [[mat toStringForInit] isEqualToString:ID4]) {
		return (YES == [[mat toString] isEqualToString:[mat inverseMatrixToString]]);
	}else if (YES == [[mat toStringForInit] isEqualToString:Sing3]) {
		return (YES == [[mat inverseMatrixToString] isEqualToString:@"No inverse exist"]);
	}else if (YES == [[mat toStringForInit] isEqualToString:Huge5]) {
		return (YES == [[mat inverseMatrixToString] isEqualToString:
				 @"1.000 -2.000 0.000 4.000 -16.000 \n0.000 1.000 -1.000 0.000 0.000 \n0.000 0.000 0.500 -1.000 4.000 \n0.000 0.000 0.000 0.500 -2.000 \n0.000 0.000 0.000 0.000 1.000 \n"]);
	}else {/*this part will use wolfram for future tests*/
		return true;
	}	
}
/**********************************************************************************************/
+(void)PrintError:(NSString*)sError:(Matrix*)mat{
	NSLog(@"Error: matrix:\n%@\n%@",[mat toStringForInit],sError);
}
/**********************************************************************************************/
+(bool) TestWith:(Matrix*) mat{
	if ([MatrixTester testTridiagonal:mat]){
		if ([MatrixTester testInverse:mat]){
			if([MatrixTester testDet:mat]){
				return true;
			}else {
				[MatrixTester PrintError:@"det test failed" :mat];
			}
		}else {
			[MatrixTester PrintError:@"inverse test failed" :mat];
		}
	}else {
		[MatrixTester PrintError:@"triagonal test failed" :mat];
	}
	return false;
}
/**********************************************************************************************/
+(bool) RandomTests{
	return true;
}
/**********************************************************************************************/
+(bool) SanityTest{
	Matrix* mId = [Matrix alloc];
	Matrix* mSing = [Matrix alloc];
	Matrix* mHuge = [Matrix alloc];
	[mId initNewMatrixWithString:ID4];
	[mSing initNewMatrixWithString:Sing3];
	[mHuge initNewMatrixWithString:Huge5];
	bool bRes =  (	[MatrixTester TestWith:mId] &&
					[MatrixTester TestWith:mSing] &&
					[MatrixTester TestWith:mHuge]);
	
	[mId release];
	[mSing release];
	[mHuge release];
	
	return bRes;
}

@end
