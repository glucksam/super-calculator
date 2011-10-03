//
//  Matrix.h
//  HelloWorld
//
//  Created by Adi Glucksam on 13/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathObject.h"
#import "Polynom.h"

@interface Matrix : MathObject {
	@private
	float** m_aMatrix;
	Matrix* m_aTriangMat;
	Matrix* m_aInvMat;
	Polynom* m_pCharPol;
	float* m_fEigenValues;
	int m_iSize;
	float m_fdet;
	float m_fTrace;
}
@property (readonly) float m_fdet;
@property (readonly) float m_fTrace;
@property (readonly) int m_iSize;
/*private functions*/
-(void) det;
-(float) det:(int*) row:(int*) column:(int) size;
-(void) trace;
-(void) set:(int)i:(int)j:(float)val;
-(float) calcAdj:(int)i:(int)j;
-(void) triagonalizeAndInverse;
-(void) getCharacteristicPolynomailAndEigenvalues;
-(BOOL) isZeroLineInTriangMat:(int) index;
-(int)findFirstNonZeroEntry:(int)i:(int)j:(float**)fMat:(int)size;
-(NSString*) EigenSpaceToString:(float)fEigenValue;
-(void)createEigenTransformationMatrix:(float)fEigenValue:(Matrix*)mat;
-(void) initNewMatrixWithFloatMatrix:(int)size:(float**)baseMatrix;
/*public functions*/
-(void) initNewMatrixWithString:(NSString*) input;
-(void) initNewMatrix:(int) size;
-(float) getElement: (int) i:(int) j;
-(void) transpose:(Matrix*) transposeMat;
-(void) adjMat:(Matrix*)adj;
-(NSString*) triagonalMatrixToString;
-(NSString*) inverseMatrixToString;
-(NSString*) CharacteristicPolynomailandEigenvaluesToString;
-(int) getMatrixRank;
-(void) getTridiagonalMatrix:(Matrix*)triMat;
/*static*/  
+(bool) compare:(Matrix*) A: (Matrix*) B;
+(void) multiplyMatrix:(Matrix*) A: (Matrix*) B: (Matrix*) mRes;
+(void) multiply:(float) constant: (Matrix*) A: (Matrix*) mRes;
+(void) addMatrix:(Matrix*) A: (Matrix*) B: (Matrix*) mRes;

@end
