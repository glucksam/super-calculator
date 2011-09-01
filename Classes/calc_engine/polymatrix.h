//
//  polymatrix.h
//  unsigned_calc
//
//  Created by Adi Glucksam on 31/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathObject.h"
#import "Polynom.h"
#import "Matrix.h"

@interface polymatrix : MathObject {
	Polynom*** m_aMatrix;
}
@property (readonly) int m_iSize;
/*private functions*/
-(void) set:(int)i:(int)j:(NSString*) sPol;
-(void) det:(int*) row:(int*) column: (int) size:(Polynom*) pDet;
/*public functions*/
-(void) initNewPolymatrix:(int) size;
-(void) initPolymatrixWithMatrix:(Matrix*) A;
-(void) det:(Polynom*) pDet;
-(NSString*) triagonalMatrixToString;
-(NSString*) toString;
@end
