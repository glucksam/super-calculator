//
//  Tester.h
//  unsigned_calc
//
//  Created by Adi Glucksam on 8/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
	MATRIX,
	POLYMATRIX,
	POLYNOMIAL,
	VECTOR,
	VECTOR_ARRAY,
	VECTOR_SPACE,
	FLOAT
}elementID;

typedef enum{
	INFO,
	ERROR,
	WARNING
}typeID;

@interface Logger : NSObject {
	bool m_bIsActive;
}
-(void) PrintToLog:(NSString*)sMsg:(typeID)type:(elementID)Id:(int)num_of_elemets,...;
-(void) setIsActive:(bool) bIsActive;
-(id) init;
+ (Logger*)getInstance;

@end
