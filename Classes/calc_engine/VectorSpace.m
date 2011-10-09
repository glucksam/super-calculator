//
//  VectorSpace.m
//  unsigned_calc
//
//  Created by Adi Glucksam on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "VectorSpace.h"
#import "Matrix.h"
#import "Logger.h"

@implementation VectorSpace
@synthesize m_iSubspaceRank;
@synthesize m_iSpaceRank;

/**********************************************************************************************/
-(NSString*) toString{
	NSMutableString *print = [[NSMutableString alloc] init];
	int i;
	bool bIsFirst = true;
	[print appendString:@"{"];
	for(i = 0; i<m_iSubspaceRank; i++){
		if (bIsFirst) {
			[print appendString:[m_vBasis[i] toString]];
			bIsFirst = false;
		}else {
			[print appendFormat:@";%@",[m_vBasis[i] toString]];
		}
	}
	[print appendString:@"}"];
	NSString* res = [NSString stringWithString: print];
	[print release];
	return res;
}
/**********************************************************************************************/
-(BOOL) initVectorSpace:(int)space_size:(int)subspace_size:(Vector**) vector_list{
	[super init];
	[super setObjName:@"Vector Space"];
	int i;
	if(space_size < subspace_size){
		[[Logger getInstance] PrintToLog:@"subspace bigger then space- impossible for basis to be independent":
					ERROR :VECTOR_SPACE :0];
		return FALSE;
	}else if (![VectorSpace isIndependentGroup:subspace_size:vector_list]) {
		[[Logger getInstance] PrintToLog:@"basis is not independent!!!":ERROR :VECTOR_ARRAY:
		 subspace_size,vector_list];
		return FALSE;
	}else {
		m_iSpaceRank = space_size;
		m_iSubspaceRank = subspace_size;
		m_vBasis = (Vector**)malloc(m_iSubspaceRank * sizeof(Vector*));
		for (i = 0; i<subspace_size; i++) {
			m_vBasis[i] = [Vector alloc];
			[m_vBasis[i] initNewVectorWithSring:[vector_list[i] toString]];
		}
		[[Logger getInstance] PrintToLog:@"New vector space":INFO :VECTOR_SPACE:1,self];
		return TRUE;
	}
}
/**********************************************************************************************/
-(BOOL) initVectorSpaceMultiple:(int)space_size:(int) subspace_size,...{
	va_list args;
	va_start(args, subspace_size);
	Vector* value;
	Vector** vector_list = (Vector**)malloc(subspace_size * sizeof(Vector*));
	int i;
	for(i = 0;i<subspace_size; i++) {
		value = va_arg(args, Vector*);
		vector_list[i] = value;
	}
	va_end(args);
	return [self initVectorSpace:space_size :subspace_size :vector_list];
}
/**********************************************************************************************/
-(void) getVectorAtIndex:(int)index:(Vector*)res{
	if(index < m_iSubspaceRank){
		[res initNewVectorWithSring:[m_vBasis[index] toString]];
	}
}
/**********************************************************************************************/
-(BOOL) isInSpace:(Vector*)v{
	Vector** vSpace = (Vector**)malloc((m_iSubspaceRank+1) * sizeof(Vector*));
	int i;
	for(i = 0;i<m_iSubspaceRank; i++) {
		vSpace[i] = [Vector alloc];
		[vSpace[i] initNewVectorWithSring:[m_vBasis[i] toString]];
	}
	vSpace[m_iSubspaceRank] = [Vector alloc];
	[vSpace[m_iSubspaceRank] initNewVectorWithSring:[v toString]];
	/*if with this vector the system is dependent, meaning the vector was in space
	 Otherwise it wasn't, which means the answer is not is independent*/
	BOOL bRes = [VectorSpace isIndependentGroup:m_iSubspaceRank+1 :vSpace];
	for(i = 0;i<m_iSubspaceRank+1; i++) {
		[vSpace[i] release];
	}
	free(vSpace);
	return !bRes;
}
/**********************************************************************************************/
+(BOOL) isIndependent:(int) num_of_vectors, ...{
	va_list args;
	va_start(args, num_of_vectors);
	Vector** vSpace = (Vector**)malloc(num_of_vectors * sizeof(Vector*));
	Vector* value;
	int i;
	for(i = 0;i<num_of_vectors; i++) {
		value = va_arg(args, Vector*);
		vSpace[i] = [Vector alloc];
		[vSpace[i] initNewVectorWithSring:[value toString]];
	}
	va_end(args);
	BOOL bRes = [VectorSpace isIndependentGroup:num_of_vectors :vSpace];
	for(i = 0;i<num_of_vectors; i++) {
		[vSpace[i] release];
	}
	free(vSpace);
	return bRes;
}
/**********************************************************************************************/
+(NSString*) getZerolineString:(int) iSize{
	int i;
	bool bIsFirst = true;
	NSMutableString *mutableString = [[NSMutableString alloc] init];
	for (i = 0; i < iSize; i++) {
		if (bIsFirst) {
			bIsFirst = false;
			[mutableString appendFormat:@"%f",0.0];
		}else {
			[mutableString appendFormat:@" %f"];
		}
	}
	NSString* res = [NSString stringWithString: mutableString];
	[mutableString release];
	return res;
}
/**********************************************************************************************/
/*we'll make a matrix out of this group, adding 0 lines where there are no more vectors
 next we will look at it's tridiagonolized matrix and count 0 entries.
 If the rank of the matrix is less then the number of vectors, they are dependent group.*/
+(BOOL) isIndependentGroup:(int) num_of_vectors:(Vector**) vector_list{
	NSMutableString *sMat = [[NSMutableString alloc] init];
	int i,iRank;
	int iSpaceRank = vector_list[0].m_iNumOfElements;
	if (iSpaceRank < num_of_vectors) {
		[sMat release];
		return FALSE;
	}
	bool bIsFirst = true;
	[sMat appendFormat:@"["];
	for(i = 0; i<num_of_vectors; i++){
		NSMutableString *mutableString =  [NSMutableString stringWithString:[vector_list[i] toString]];
		[mutableString deleteCharactersInRange:[mutableString rangeOfString: @"]"]];
		[mutableString deleteCharactersInRange:[mutableString rangeOfString: @"["]];
		[mutableString setString: [mutableString stringByReplacingOccurrencesOfString:@"," withString:@" "]];

		if (bIsFirst) {
			bIsFirst = false;
			[sMat appendFormat:@"%@",mutableString];
		}else {
			[sMat appendFormat:@";%@",mutableString];
		}
	}
	for (i = num_of_vectors; i<iSpaceRank; i++) {
		[sMat appendFormat:@";%@",[self getZerolineString: iSpaceRank]];
	}
	[sMat appendFormat:@"]"];
	Matrix* M = [Matrix alloc];
	[M initNewMatrixWithString:sMat];
	iRank = [M getMatrixRank];
	[sMat release];
	[M release];
	return (num_of_vectors == iRank);
}
/**********************************************************************************************/
+(BOOL) isEqual:(VectorSpace*) v:(VectorSpace*)u{
	if((v.m_iSpaceRank != u.m_iSpaceRank) ||
	   (v.m_iSubspaceRank != u.m_iSubspaceRank))
		return FALSE;
	int i, count = v.m_iSubspaceRank;
	Vector* vec = [Vector alloc];
	for (i = 0; i<count; i++) {
		[u getVectorAtIndex:i:vec];
		if(![v isInSpace:vec]){
			[vec release];
			return FALSE;
		}
		[vec clean];
	}
	[vec release];
	return TRUE;
}
/**********************************************************************************************/
-(void) dealloc{
	int i;
	for(i = 0;i<m_iSubspaceRank; i++) {
		[m_vBasis[i] release];
	}
	free(m_vBasis);
	[super dealloc];
}
@end
