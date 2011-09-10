//
//  VectorSpace.h
//  unsigned_calc
//
//  Created by Adi Glucksam on 10/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathObject.h"
#import "Vector.h"

@interface VectorSpace : MathObject {
	Vector** m_vBasis;
}
@property (readonly) int m_iSubspaceRank;	/*number of vectors to represent the subspace*/
@property (readonly) int m_iSpaceRank;		/*number of vectors to represent the whole space*/

/*private functions*/
/*public functions*/
-(BOOL) isInSpace:(Vector*)v;
-(NSString*) toString;
-(BOOL) initVectorSpace:(int)space_size:(int)subspace_size:(Vector**) vector_list;
-(void) getVectorAtIndex:(int)index:(Vector*)res;
/*static functions*/
+(NSString*) getZerolineString:(int) iSize;
+(BOOL) isIndependent:(int) num_of_vectors, ...;
+(BOOL) isEqual:(VectorSpace*) v:(VectorSpace*)u;
+(BOOL) isIndependentGroup:(int) num_of_vectors:(Vector**) vector_list;
@end
