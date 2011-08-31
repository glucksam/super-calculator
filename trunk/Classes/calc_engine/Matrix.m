//
//  matrix.m
//  HelloWorld
//
//  Created by Adi Glucksam on 13/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathObject.h"
#import "Matrix.h"


@implementation Matrix
@synthesize m_fTrace;
@synthesize m_fdet;
@synthesize m_iSize;

+(void) multiplyMatrix:(Matrix*) A:(Matrix*)B:(Matrix*)mRes{
	int i,j,k, size;
	float fTemp;
	if(A.m_iSize != B.m_iSize)
		return;
	size = A.m_iSize;
	[mRes initNewMatrix:size];
	for(i = 0; i<size; i++){
		for(k = 0; k<size; k++){
			fTemp = 0;
			for(j = 0; j < size; j++){
				fTemp += [A getElement:i :j]*[B getElement:j :k];
			}
			[mRes set:i :k :fTemp];
		}
	}
	[mRes update];
}
/**********************************************************************************************/
+(void) multiply:(float) constant:(Matrix*)A:(Matrix*)mRes{
	[mRes initNewMatrix:A.m_iSize];
	int i,j;
	for(i = 0; i<A.m_iSize; i++){
		for(j = 0; j < A.m_iSize; j++){
			[mRes set:i :j :constant*[A getElement:i :j]];
		}
	}
	[mRes update];
}
/**********************************************************************************************/
+(bool) compare:(Matrix*) A:(Matrix*) B{
	if(A.m_iSize != B.m_iSize)
		return false;
	int i,j;
	for(i = 0; i<A.m_iSize; i++){
		for(j = 0; j < A.m_iSize; j++){
			if([A getElement:i:j] != [B getElement:i:j])
				return false;
		}
	}	
	return true;
}
/**********************************************************************************************/

+(void) addMatrix:(Matrix*) A: (Matrix*) B: (Matrix*) mRes{
	int i,j;
	int size = A.m_iSize;
	[mRes initNewMatrix:size];
	for(i = 0; i<size; i++){
		for(j = 0; j < size; j++){
			[mRes set:i :j :[A getElement:i :j]+[B getElement:i :j]];
		}
	}
	[mRes update];
}
/**********************************************************************************************/
-(NSString*) toString{
	NSMutableString *print = [[NSMutableString alloc] init];
	int i,j;
	for(i = 0; i<m_iSize; i++){
		NSMutableString *line =  [[NSMutableString alloc] init];
		for(j = 0; j < m_iSize; j++){
			[line appendFormat:@"%0.3f ", m_aMatrix[i][j]];
		}
		[line appendFormat:@"\n"];
		[print appendString:line];
		[line release];
	}
	NSString* res = [NSString stringWithString: print];
	[print release];
	return res;
}
/**********************************************************************************************/
-(NSString*) triagonalMatrixToString{
	int i,j;
	NSMutableString *print = [[NSMutableString alloc] init];
	for(i = 0; i<m_iSize; i++){
		NSMutableString *line =  [[NSMutableString alloc] init];
		for(j = 0; j < m_iSize; j++){
			[line appendFormat:@"%0.3f ", m_aTriangMat[i][j]];
		}
		[line appendFormat:@"\n"];
		[print appendString:line];
		[line release];
	}
	NSString* res = [NSString stringWithString: print];
	[print release];
	return res;	
}
/**********************************************************************************************/
-(NSString*) inverseMatrixToString{
	int i,j;
	if (nil == m_aInvMat) {
		return @"No inverse exist";
	}
	NSMutableString *print = [[NSMutableString alloc] init];
	for(i = 0; i<m_iSize; i++){
		NSMutableString *line =  [[NSMutableString alloc] init];
		for(j = 0; j < m_iSize; j++){
			[line appendFormat:@"%0.3f ", m_aInvMat[i][j]];
		}
		[line appendFormat:@"\n"];
		[print appendString:line];
		[line release];
	}
	NSString* res = [NSString stringWithString: print];
	[print release];
	return res;	
}
/**********************************************************************************************/
-(void) triagonalizeAndInverse{
	int i,j,k;
	float fTemp,fInvTemp, fCurMult;
	m_aTriangMat = (float **)malloc(m_iSize * sizeof(float*));
	m_aInvMat = (float **)malloc(m_iSize * sizeof(float*));
	for (i = 0; i < m_iSize; i++) { /*go over the lines*/
		m_aTriangMat[i] = (float *)malloc(m_iSize * sizeof(float));
		m_aInvMat[i] = (float *)malloc(m_iSize * sizeof(float));
		for (k = 0; k < m_iSize; k++){
			m_aTriangMat[i][k] = m_aMatrix[i][k];
			m_aInvMat[i][k] = 0;
		}
		m_aInvMat[i][i] = 1;
		if(0 != i) {
			for (j = 0; j < i; j++) { /*for each line we already*/
				/*TODO*/
				if (m_aTriangMat[j][j] != 0) { /*otherwise there's a problem*/
					fCurMult = m_aTriangMat[i][j]/m_aTriangMat[j][j];
					for (k = 0; k < m_iSize; k++) { /*multiply every element andreduce it*/
						fTemp = m_aTriangMat[i][k] - fCurMult*m_aTriangMat[j][k];
						fInvTemp = m_aInvMat[i][k] - fCurMult*m_aInvMat[j][k];
						m_aTriangMat[i][k] = fTemp;
						m_aInvMat[i][k] = fInvTemp;
					}
				}
			}
		}
	}
	[self det];
	if(0 == m_fdet){
		for (i = 0; i < m_iSize; i++) {
			free(m_aInvMat[i]);
		}
		free(m_aInvMat);
		m_aInvMat = nil;
		return;
	}
	float** mDiag = (float **)malloc(m_iSize * sizeof(float*));
	for (i = 0; i < m_iSize; i++) { /*go over the lines*/
		mDiag[i] = (float *)malloc(m_iSize * sizeof(float));
		for (k = 0; k < m_iSize; k++){
			mDiag[i][k] = m_aTriangMat[i][k];
		}
	}
	
	/*finish diagonalizing for inverse if det != 0*/
	for (i = m_iSize -1 ; i >= 0; i--) { /*go over the lines*/
		if(m_iSize-1 != i) {
			for (j = m_iSize-1; j > i; j--) { /*for each line we already*/
				/*TODO*/
				if (mDiag[j][j] != 0) { /*otherwise there's a problem*/
					fCurMult = mDiag[i][j]/mDiag[j][j];
					for (k = 0; k < m_iSize; k++) { /*multiply every element andreduce it*/
						fTemp = mDiag[i][k] - fCurMult*mDiag[j][k];
						fInvTemp = m_aInvMat[i][k] - fCurMult*m_aInvMat[j][k];
						mDiag[i][k] = fTemp;
						m_aInvMat[i][k] = fInvTemp;
					}
				}
			}
		}
		/*TODO*/
		if(0 != mDiag[i][i] && 1 != mDiag[i][i]){
			fCurMult = 1.0/mDiag[i][i];
			for (k = 0; k < m_iSize; k++) {
				mDiag[i][k] *= fCurMult;
				m_aInvMat[i][k] *= fCurMult;
			}
		}
	}
	
	for (i = 0; i < m_iSize; i++) {
		free(mDiag[i]);
	}
	free(mDiag);
}

/**********************************************************************************************/
-(void) transpose: (Matrix*) transposeMat{
	int i,j;
	[transposeMat initNewMatrix:m_iSize];
	for (i = 0; i < m_iSize; i++) {
		for (j = 0; j < m_iSize; j++) {
			[transposeMat set:i :j : m_aMatrix[j][i]];
		}
	}
	[transposeMat update];
}
/**********************************************************************************************/
-(float) calcAdj:(int)i:(int)j{
	int* row = (int*)malloc(m_iSize * sizeof(int));
	int* column = (int*)malloc(m_iSize * sizeof(int));
	int k;
	for (k = 0; k < m_iSize; k++) {
		if(k < i){
			row[k] = k;
		} else if(k > i){
			row[k-1] = k;
		}
		if(k < j){
			column[k] = k;
		} else if(k > j){
			column[k-1] = k;
		}	
	}
	
	return pow((-1), i+j)*[self det: row: column: m_iSize-1];
}
/**********************************************************************************************/
-(void) adjMat:(Matrix*) adj{
	[adj initNewMatrix:m_iSize];
	int i,j;
	for(i = 0; i<m_iSize; i++){
		for(j = 0; j < m_iSize; j++){
			[adj set:i :j :[self calcAdj:i :j]];
		}
	}
	[adj update];
}
/**********************************************************************************************/
-(void) trace{
	int i;
	m_fTrace = 0;
	for(i = 0; i<m_iSize; i++){
		m_fTrace += m_aMatrix[i][i];
	}
}
/**********************************************************************************************/
-(void) update{
	[self triagonalizeAndInverse];

	[self trace];
}
/**********************************************************************************************/
-(void) det{
	int i;
	m_fdet = 1;
	for (i = 0; i < m_iSize; i++){
		m_fdet *= m_aTriangMat[i][i];
	}
}
/**********************************************************************************************/
-(float) det:(int*) row:(int*) column: (int) size{
	int i,j;
	float det = 0;
	if(1 == size){
		return m_aMatrix[row[0]][column[0]];
	}
	if(2 == size){
		float a = m_aMatrix[row[0]][column[0]];
		float b = m_aMatrix[row[0]][column[1]];
		float c = m_aMatrix[row[1]][column[0]];
		float d = m_aMatrix[row[1]][column[1]];
		return (a*d-b*c);
	}
	for (i = 0; i < size; i++) {
		int* n_row = (int*)malloc((size-1) * sizeof(int));
		int* n_column = (int*)malloc((size-1) * sizeof(int));
		for (j = 0; j < size; j++) {
			if(j > 0){
				n_row[j-1] = row[j];
			}
			if(j < i){
				n_column[j] = column[j];
			} else if(j > i){
				n_column[j-1] = column[j];
			}		
		}
		det += pow((-1), i)*m_aMatrix[row[0]][column[i]]*[self det: n_row: n_column: size-1];
		free(n_row);
		free(n_column);
	}
	return det;
}
/**********************************************************************************************/
-(float) getElement: (int) i:(int) j{
	return m_aMatrix[i][j];
}
/**********************************************************************************************/
-(void) set:(int)i:(int)j:(float)val{
	m_aMatrix[i][j] = val;
}
/**********************************************************************************************/
-(void) initNewMatrix:(int)size{
	[super init];
	[super setObjName:@"Matrix"];
	int i,j;
	m_iSize = size;
	m_aMatrix = (float **)malloc(m_iSize * sizeof(float*));
	for (i = 0; i < m_iSize; i++) {
		m_aMatrix[i] = (float *)malloc(m_iSize * sizeof(float));
		for (j = 0; j < m_iSize; j++) {
			[self set: i:j:0];
		}
	}
}
/**********************************************************************************************/
-(void) initNewMatrixWithString:(NSString*) input{
	NSMutableString *mutableString = [NSMutableString stringWithString:input];
	[mutableString deleteCharactersInRange:[mutableString rangeOfString: @"]"]];
	[mutableString deleteCharactersInRange:[mutableString rangeOfString: @"["]];
	NSString *string = mutableString;
	int i,j;
	NSArray *chunks = [string componentsSeparatedByString: @";"];
	[self initNewMatrix:[chunks count]];
	for (i = 0; i < m_iSize; i++) {
		NSArray *line = [[chunks objectAtIndex: i]	componentsSeparatedByString: @" "];
		for (j = 0; j < m_iSize; j++) {
			[self set: i:j:[[line objectAtIndex: j] floatValue]];
		}
	}
	NSLog(@"%@",[self toString]);
	[self update];
}
/**********************************************************************************************/
-(void) dealloc {
    NSLog(@"Deallocing Matrix\n" );
	int i;
	for (i = 0; i < m_iSize; i++) {
		free(m_aMatrix[i]);
		free(m_aTriangMat[i]);
		if (nil != m_aInvMat) { /*the matrix was uninvertible*/
			free(m_aInvMat[i]);
		}
	}
	free(m_aMatrix);
	free(m_aTriangMat);
	if (nil != m_aInvMat) { /*the matrix was uninvertible*/
		free(m_aInvMat);
	}
	[super dealloc];
}


@end
