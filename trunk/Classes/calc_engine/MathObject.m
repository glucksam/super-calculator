//
//  MathObject.m
//  HelloWorld
//
//  Created by Adi Glucksam on 13/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MathObject.h"


@implementation MathObject

-(NSString*) vecToString:(int*) vec:(int)size{
	int i;
	NSMutableString *line =  [NSMutableString stringWithCapacity:(2*size-1)];
	for (i = 0; i < size; i++) {
		[line appendFormat:@"%i ", vec[i]];
	}
	NSString* res = [NSString stringWithString:line];
	[line release];
	return res;
}
/**********************************************************************************************/
-(void) setObjName:(NSString*) i_sName{
	m_sObjName = i_sName;
}
/**********************************************************************************************/
-(NSString*) getObjName{
	return m_sObjName;
}


@end
