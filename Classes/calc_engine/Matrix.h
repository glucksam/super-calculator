//
//  Matrix.h
//  HelloWorld
//
//  Created by Adi Glucksam on 13/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathObject.h"
#import "Polynom.h"
#import "VectorSpace.h"

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
-(void)inverse;
-(void) getCharacteristicPolynomailAndEigenvalues;
-(BOOL) isZeroLineInMat:(int) index;
-(NSString*) EigenSpaceToString:(float)fEigenValue;
-(void)createEigenTransformationMatrix:(float)fEigenValue:(Matrix*)mat;
-(void) initNewMatrixWithFloatMatrix:(int)size:(float**)baseMatrix;
-(void) fixTrigiagonalMatrix;
-(int)findFirstNonZeroEntryInLine:(int)line;
-(int)findFirstNonZeroEntryInRow:(int)row;
-(void)swapLines:(int)i:(int)j;
/*public functions*/
-(void) initNewMatrixWithString:(NSString*) input;
-(void) initNewMatrix:(int) size;
-(float) getElement: (int) i:(int) j;
-(void) transpose:(Matrix*) transposeMat;
-(void) adjMat:(Matrix*)adj;
-(NSString*) triagonalMatrixToString;
-(NSString*) inverseMatrixToString;
-(NSString*) CharacteristicPolynomailandEigenvaluesToString;
-(NSString*) toStringForInit;
-(NSString*) toString;
-(int) getMatrixRank;
-(void) getTridiagonalMatrix:(Matrix*)triMat;
-(void) getCharacteristicPolynomail:(Polynom*)p;
-(float*) getEigenValues;
-(void)getKernel:(VectorSpace*) vec_space;
/*static*/ 
+(bool) compare:(Matrix*) A: (Matrix*) B;
+(void) multiplyMatrix:(Matrix*) A: (Matrix*) B: (Matrix*) mRes;
+(void) multiply:(float) constant: (Matrix*) A: (Matrix*) mRes;
+(void) addMatrix:(Matrix*) A: (Matrix*) B: (Matrix*) mRes;
+(bool) areLinesDependent:(Matrix*)mat:(int)iLine:(int)jLine;
+(void) copyMatrix:(Matrix*)original:(Matrix*)copy;

@end
