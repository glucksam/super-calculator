//
//  Matrix.h
//  HelloWorld
//
//  Created by Adi Glucksam on 13/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathObject.h"

@interface Matrix : MathObject {
	@private
	float** m_aMatrix;
	float** m_aTriangMat;
	float** m_aInvMat;
	int m_iSize;
	float m_fdet;
	float m_fTrace;
}
@property (readonly) float m_fdet;
@property (readonly) float m_fTrace;
@property (readonly) int m_iSize;;
/*private functions*/
-(void) det;
-(float) det:(int*) row:(int*) column:(int) size;
-(void) trace;
-(void) update;
-(void) set:(int)i:(int)j:(float)val;
-(float) calcAdj:(int)i:(int)j;
-(void) triagonalizeAndInverse;
/*public functions*/
-(void) initNewMatrixWithString:(NSString*) input;
-(void) initNewMatrix:(int) size;
-(float) getElement: (int) i:(int) j;
-(void) transpose:(Matrix*) transposeMat;
-(void) adjMat:(Matrix*)adj;
-(NSString*) triagonalMatrixToString;
-(NSString*) inverseMatrixToString;
/*static*/  
+(bool) compare:(Matrix*) A: (Matrix*) B;
+(void) multiplyMatrix:(Matrix*) A: (Matrix*) B: (Matrix*) mRes;
+(void) multiply:(float) constant: (Matrix*) A: (Matrix*) mRes;
+(void) addMatrix:(Matrix*) A: (Matrix*) B: (Matrix*) mRes;

@end
