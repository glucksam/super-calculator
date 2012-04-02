//
//  matrix.m
//  HelloWorld
//
//  Created by Adi Glucksam on 13/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathObject.h"
#import "Matrix.h"
#import "polymatrix.h"
#import "Operations.h"
#import "Vector.h"
#import "VectorSpace.h"
#import "Logger.h"

@implementation Matrix
@synthesize m_fTrace;
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
	[[Logger getInstance] PrintToLog:@"multiplying matrixes" :INFO :MATRIX :3,A,B,mRes];
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
	NSString* temp = [NSString stringWithFormat:@"multiplying by const %f",constant];
	[[Logger getInstance] PrintToLog:temp:INFO :MATRIX :2,A,mRes];
}
/**********************************************************************************************/
+(bool) compare:(Matrix*) A:(Matrix*) B{
	if(A.m_iSize != B.m_iSize){
		[[Logger getInstance] PrintToLog:@"trying to compare matrixes with different sizes" :INFO :MATRIX :2,A,B];
		return false;
	}
	int i,j;
	for(i = 0; i<A.m_iSize; i++){
		for(j = 0; j < A.m_iSize; j++){
			if([A getElement:i:j] != [B getElement:i:j]){
				NSString* temp = [NSString	stringWithFormat:@"trying to compare matrixes with different entry [%i][%j]",i,j];
				[[Logger getInstance] PrintToLog:temp:INFO :MATRIX :2,A,B];
				return false;
			}
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
	[[Logger getInstance] PrintToLog:@"adding matrixes" :INFO :MATRIX :3,A,B,mRes];
}
/**********************************************************************************************/
+(void) copyMatrix:(Matrix*)original:(Matrix*)copy{
	[copy initNewMatrix:original.m_iSize];
	int i,j;
	for (i = 0; i < original.m_iSize; i++) {
		for (j = 0; j < original.m_iSize; j++) {
			[copy set: i:j:[original getElement:i :j]];
		}
	}
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
-(NSString*) toStringForInit{
	NSMutableString *print = [[NSMutableString alloc] init];
	int i,j;
	[print appendString:@"["];
	for(i = 0; i<m_iSize; i++){
		NSMutableString *line =  [[NSMutableString alloc] init];
		for(j = 0; j < m_iSize; j++){
			if (j == m_iSize-1) {
				[line appendFormat:@"%f", m_aMatrix[i][j]];
			}else{
				[line appendFormat:@"%f ", m_aMatrix[i][j]];
			}
		}
		if (i < m_iSize-1) {
			[line appendFormat:@";"];
		}
		[print appendString:line];
		[line release];
	}
	[print appendString:@"]"];
	NSString* res = [NSString stringWithString: print];
	[print release];
	return res;	
}
/**********************************************************************************************/
-(NSString*) triagonalMatrixToString{
	if (nil == m_aTriangMat) {
		[self triagonalizeAndInverse];
	}
	return [m_aTriangMat toString];
}
/**********************************************************************************************/
-(NSString*) inverseMatrixToString{
	if (nil == m_aTriangMat) {/*if this one was calculated- so was the inverse, if exists...*/
		[self triagonalizeAndInverse];
	}
	if (nil == m_aInvMat) {
		return @"No inverse exist";
	}
	return [m_aInvMat toString];
}
/**********************************************************************************************/
-(NSString*) CharacteristicPolynomailandEigenvaluesToString{
	[self getCharacteristicPolynomailAndEigenvalues];
	if(nil == m_pCharPol)
		return @"";
	NSMutableString* mutStr = [[NSMutableString alloc] init];
	[mutStr appendFormat:@"%@\n",[m_pCharPol toString]];
	int i;
	for (i = 1; i<= m_fEigenValues[0]; i++) {
		[self EigenSpaceToString:m_fEigenValues[i]];
		[mutStr appendFormat:@"eigenvalue %i = %0.3f\n",i,m_fEigenValues[i]];
	}
	NSString* res = [NSString stringWithString: mutStr];
	[mutStr release];
	return res;
}
/**********************************************************************************************/
-(void)inverse{
	Matrix* tempMat = [Matrix alloc];
	float fCurMult;
	int i,j,k,line;
	[Matrix copyMatrix:m_aTriangMat :tempMat];
	/*finish diagonalizing for inverse if det != 0*/
	for (i = m_iSize -1 ; i >= 0; i--) { /*go over the lines*/
		if(m_iSize-1 != i) {
			for (j = m_iSize-1; j > i; j--) {
				if ([tempMat getElement:j:j]!= 0) { /*otherwise there's a problem*/
					fCurMult = [tempMat getElement:i:j]/[tempMat getElement:j:j];
					for (k = 0; k < m_iSize; k++) { /*multiply every element andreduce it*/
						[m_aInvMat set:i :k :
							[m_aInvMat getElement:i :k]-fCurMult*[m_aInvMat getElement:j :k]];
						[tempMat set:i :k :
							[tempMat getElement:i :k]-fCurMult*[tempMat getElement:j :k]];
					}
				}else {
					line = [tempMat findFirstNonZeroEntryInRow:j];
					if(line != 0){/*switch lines and re-do it*/
						[tempMat swapLines:line :j];
						[m_aInvMat swapLines:line :j];
						j--;
					}/*otherwise matrix is not invertible!!!*/
				}
			}
		}
		if(0 != [tempMat getElement:i:i]){/*just in case to prevent crushing, though it doesn't happen
							  (as it's not supposed to happen)*/
			if(1 != [tempMat getElement:i:i]){
				fCurMult = 1.0/[tempMat getElement:i:i];
				for (k = 0; k < m_iSize; k++) {
					[m_aInvMat set:i :k :[m_aInvMat getElement:i :k]*fCurMult];
					[tempMat set:i :k :[tempMat getElement:i :k]*fCurMult];
				}
			}
		}else {
			[[Logger getInstance] PrintToLog:@"Issue with matrix while trying to inverse- insufficient rank!!!":
						ERROR :MATRIX :0];
			[m_aInvMat release];
			m_aInvMat = nil;
		}
	}
	[tempMat release];
	[[Logger getInstance] PrintToLog:@"result of inverse" :INFO :MATRIX :1,m_aInvMat];
}
/**********************************************************************************************/
-(void) triagonalizeAndInverse{
	int i,j,k,line;
	float fCurMult;
	m_aTriangMat = [Matrix alloc];
	[m_aTriangMat initNewMatrix:m_iSize];
	m_aInvMat = [Matrix alloc];
	[m_aInvMat initNewMatrix:m_iSize];	
	for (i = 0; i < m_iSize; i++) { /*go over the lines*/
		for (k = 0; k < m_iSize; k++){
			[m_aTriangMat set:i :k :m_aMatrix[i][k]];
			[m_aInvMat set:i :k :0];
		}
		[m_aInvMat set:i :i :1];
	}
	for (i = 0; i < m_iSize; i++) { /*go over the lines*/
		for (j = 0; j < i; j++) {
			if ([m_aTriangMat getElement:j:j]!= 0) { /*otherwise there's a problem*/
				fCurMult = [m_aTriangMat getElement:i:j]/[m_aTriangMat getElement:j:j];
				for (k = 0; k < m_iSize; k++) { /*multiply every element and reduce it*/
					[m_aInvMat set:i :k :
						[m_aInvMat getElement:i :k]-fCurMult*[m_aInvMat getElement:j :k]];
					[m_aTriangMat set:i :k :
						[m_aTriangMat getElement:i :k]-fCurMult*[m_aTriangMat getElement:j :k]];
				}
			}else{
				line = [m_aTriangMat findFirstNonZeroEntryInRow:j];
				if(line != 0){/*switch lines and re-do it*/
					[m_aTriangMat swapLines:line :j];
					[m_aInvMat swapLines:line :j];
					j--;
				}/*otherwise there's nothing to do*/
			}
		}
	}
	[self det];
	if(0 == m_fdet){
		[m_aInvMat release];
		m_aInvMat = nil;
	}else {
		[self inverse];
	}
	[self fixTridiagonalMatrix];
	[[Logger getInstance] PrintToLog:@"result of tridiagonal" :INFO :MATRIX :1,m_aTriangMat];
}
/**********************************************************************************************/
-(void) getCharacteristicPolynomailAndEigenvalues{
	polymatrix* p = [polymatrix alloc];
	[p initPolymatrixWithMatrix:self];
	m_pCharPol = [Polynom alloc];
	[p det:(Polynom *)m_pCharPol];
	[p release];
	[[Logger getInstance] PrintToLog:@"characteristic polynomial" :INFO :POLYNOMIAL:1,m_pCharPol];
	[m_pCharPol getRationalRoots:&m_fEigenValues];
}
/**********************************************************************************************/
-(void)createEigenTransformationMatrix:(float)fEigenValue:(Matrix*)mat{
	int i,j;
	[mat initNewMatrix:m_iSize];
	for (i = 0; i < m_iSize; i++) {
		for (j = 0; j < m_iSize; j++) {
			if (i == j) {
				[mat set:i:i:m_aMatrix[i][i]-fEigenValue];
			}else {
				[mat set:i:j:m_aMatrix[i][j]];
			}
		}
	}
	NSString* temp = [NSString stringWithFormat:@"creating A-%fI",fEigenValue];
	[[Logger getInstance] PrintToLog:temp :INFO :MATRIX :1,mat];
}
/**********************************************************************************************/
/*returns 0 if no such line exists, othewise return the first k>i such that mat[k][j]!=0*/
-(int)findFirstNonZeroEntryInRow:(int)row{
	int i;
	for (i = 0; i < m_iSize; i++) {
		if(m_aMatrix[i][row]!= 0){
			return i;
		}
	}
	return 0;
}
/**********************************************************************************************/
-(int)findFirstNonZeroEntryInLine:(int)line{
	int j;
	for (j = 0; j < m_iSize; j++) {
		if (m_aMatrix[line][j] != 0) {
			return j;
		}
	}
	return -1; /*no non zero entry exists*/
}
/**********************************************************************************************/
/*this makes sure the number of non zero lines is inded the rank of the matrix, hence called by
 tridiagonalizeAndInverse function*/
-(void) unifyTridiagonalEntries{
	int i,j,iTempIndex;
	int iLastEntry = -2;
	float fCurrMult;
	for (i = 0; i < m_iSize; i++) {
		iTempIndex = [m_aTriangMat findFirstNonZeroEntryInLine:i];
		if (iTempIndex == iLastEntry){
			/*one should remove first entry in new line*/
			fCurrMult = [m_aTriangMat getElement:i :iLastEntry]/
			[m_aTriangMat getElement:i-1 :iLastEntry];
			for (j = i; j < m_iSize; j++) { /*multiply every element andreduce it*/
				[m_aTriangMat set:i:j :[m_aTriangMat getElement:i :j]-
				 fCurrMult*[m_aTriangMat getElement:i-1 :j]];
			}				
			iTempIndex = [m_aTriangMat findFirstNonZeroEntryInLine:i];
		}
		iLastEntry = iTempIndex;
		if (-1 == iLastEntry) {
			break;
		}
	}
}
/**********************************************************************************************/
-(void) fixTridiagonalMatrix{
	int i,j,index,iMove;
	[self unifyTridiagonalEntries];
	for (i = 0; i<m_iSize; i++) {
		index = [m_aTriangMat findFirstNonZeroEntryInLine:i];
		if(index == i){/*this line is ok*/
			continue;
		}else if(index == -1){/*the rest is zero lines we're done*/
			return;
		}else{
		/*otherwise- this line should be in index and the line above it should be zero lines*/
		/*this function is based on the fact that all the zero lines are at the bottom*/
			iMove = index-i;
			for (j = m_iSize-iMove-1; j >= i; j--) {
				[m_aTriangMat swapLines:j :j+iMove];
			}
		}
	}
}
/**********************************************************************************************/
-(NSString*) EigenSpaceToString:(float)fEigenValue{
	Matrix* kernelMatrix = [Matrix alloc];
	VectorSpace* vec_space = [VectorSpace alloc];
	[self createEigenTransformationMatrix:fEigenValue:kernelMatrix];
	[kernelMatrix getKernel:vec_space];
	NSString* sMsg = [NSString stringWithFormat:@"eigen space of eigen value %f",fEigenValue];
	[[Logger getInstance] PrintToLog:sMsg :INFO :VECTOR_SPACE :1,vec_space];
	NSString* res = [vec_space toString];
	[kernelMatrix release];
	[vec_space release];
	return res;
}
/**********************************************************************************************/
-(void)getKernel:(VectorSpace*)vec_space{
	Matrix* ker = [Matrix alloc];
	int i,j,size_counter = 0,zeros_counter;
	float fTempSum;
	[self triagonalizeAndInverse];
	[self getTridiagonalMatrix:ker];
	int subspace_size = m_iSize - [self getMatrixRank];
	Vector** vecs = (Vector**) malloc(subspace_size*sizeof(Vector*));
	double* sol = (double *)malloc(m_iSize * sizeof(double));
	for (size_counter = 0; size_counter < subspace_size; size_counter++) {
		zeros_counter = 0;
		for (i = m_iSize-1 ; i >= 0 ; i--) { /*populate sol with one solution*/
			fTempSum = 0;
			for (j = i+1; j < m_iSize; j++){/*summing what we have so far, to calculate sol[i]*/
				fTempSum += [ker getElement:i:j]*sol[j];
			}
			if (fTempSum == 0) {
				if ([ker getElement:i:i] == 0) {
					if (zeros_counter <= size_counter) {
						sol[i] = 1;
						zeros_counter++;
					}else{
						sol[i] = 0;
					}
				}else {
					sol[i] = 0;
				}
			}else if ([ker getElement:i:i] != 0) { /*if it's 0, there's a problem in algorithm*/
				sol[i] = fTempSum/[ker getElement:i:i]*(-1);
			}else {
				[[Logger getInstance] PrintToLog:@"A problem in retrieving the kernel of this matrix!!!" :
							 ERROR :MATRIX :1,ker];
				break;
			}
		}
		vecs[size_counter] = [Vector alloc];
		[vecs[size_counter] initNewVectorWithArray:m_iSize :sol];
	}
	[vec_space initVectorSpace:m_iSize :subspace_size :vecs];
	free(sol);
	for (i = 0; i<subspace_size; i++) {
		[vecs[i] release];
	}
	free(vecs);
	[ker release];
	NSString* sMsg = [NSString stringWithFormat:@"kerner of\n%@",[self toString]];
	[[Logger getInstance] PrintToLog:sMsg :INFO :VECTOR_SPACE :1,vec_space];
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
	[[Logger getInstance] PrintToLog:@"transpose matrix" :INFO :MATRIX :1,transposeMat];
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
	[[Logger getInstance] PrintToLog:@"adjoint matrix" :INFO :MATRIX :1,adj];
}
/**********************************************************************************************/
-(void) trace{
	int i;
	m_fTrace = 0;
	for(i = 0; i<m_iSize; i++){
		m_fTrace += m_aMatrix[i][i];
	}
	NSString* sMsg = [NSString stringWithFormat:@"trace is %f",m_fTrace];
	[[Logger getInstance] PrintToLog:sMsg :INFO :MATRIX :0];
}
/**********************************************************************************************/
-(void) det{
	int i;
	if (nil == m_aTriangMat) {
		[self triagonalizeAndInverse];
	}
	m_fdet = 1;
	for (i = 0; i < m_iSize; i++){
		m_fdet *= [m_aTriangMat getElement:i :i];
	}
	NSString* sMsg = [NSString stringWithFormat:@"det is %f",m_fdet];
	[[Logger getInstance] PrintToLog:sMsg :INFO :MATRIX :0];
}
/**********************************************************************************************/
-(float) getDet{
	if (-1 == m_fdet) {
		[self det];
	}
	return m_fdet;
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
-(BOOL) isZeroLineInMat:(int) index{
	int j;
	for (j = 0; j<m_iSize; j++) {
		if ([self getElement:index :j]!= 0) {
			return FALSE;
		}
	}
	return TRUE;
}
/**********************************************************************************************/
-(int) getMatrixRank{
	if(m_aTriangMat == nil){
		[self triagonalizeAndInverse];
	}
	int iRank = 0;
	for (int i = 0; i<m_iSize; i++) {
		if (![m_aTriangMat isZeroLineInMat:i]) {
			iRank++;
		}
	}
	NSString* sMsg = [NSString stringWithFormat:@"matrix rank is %d",iRank];
	[[Logger getInstance] PrintToLog:sMsg :INFO :MATRIX :0];
	return iRank;
}
/**********************************************************************************************/
-(void)swapLines:(int)i:(int)j{
	float* temp;
	temp = m_aMatrix[i];
	m_aMatrix[i] = m_aMatrix[j];
	m_aMatrix[j] = temp;
}
/**********************************************************************************************/
-(void) getTridiagonalMatrix:(Matrix*)triMat{
	if(m_aTriangMat == nil){
		[self triagonalizeAndInverse];
	}
	[Matrix copyMatrix:m_aTriangMat :triMat];
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
-(void) getCharacteristicPolynomail:(Polynom*)p{
	if (m_pCharPol == nil) {
		[self getCharacteristicPolynomailAndEigenvalues];
	}
	[Polynom copyPolynom:m_pCharPol :p];
}
/**********************************************************************************************/
/*return the copy we have does not(!!!) duplicate it*/
-(float*) getEigenValues{
	return m_fEigenValues;
}
/**********************************************************************************************/
-(void) initNewMatrix:(int)size{
	[super init];
	[super setObjName:@"Matrix"];
	m_aTriangMat = nil;
	m_aInvMat = nil;
	m_pCharPol = nil;
	m_fdet = -1;
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
-(void) initNewMatrixWithFloatMatrix:(int)size:(float**)baseMatrix{
	[self initNewMatrix:size];
	int i,j;
	for (i = 0; i < m_iSize; i++) {
		for (j = 0; j < m_iSize; j++) {
			[self set: i:j:baseMatrix[i][j]];
		}
	}
	[[Logger getInstance] PrintToLog:@"new matrix" :INFO :MATRIX :1,self];
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
	[[Logger getInstance] PrintToLog:@"new matrix" :INFO :MATRIX :1,self];
}
/**********************************************************************************************/
-(void) dealloc {
	int i;
	for (i = 0; i < m_iSize; i++) {
		free(m_aMatrix[i]);
	}
	free(m_aMatrix);
	[m_aInvMat release];
	[m_aTriangMat release];
	[m_pCharPol release];
	[super dealloc];
}

@end
