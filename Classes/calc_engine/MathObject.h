//
//  MathObject.h
//  HelloWorld
//
//  Created by Adi Glucksam on 13/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/NSObject.h>


@interface MathObject : NSObject {
	@private
	NSString* m_sObjName;

}
/*public functions*/
-(NSString*) toString;
-(NSString*) getObjName;
-(NSString*) vecToString:(int*) vec:(int)size;
/*private functions*/
-(void) setObjName:(NSString*) i_sName;


@end
