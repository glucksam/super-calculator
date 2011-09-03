//
//  Operations.h
//  unsigned_calc
//
//  Created by Adi Glucksam on 2/9/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Operations : NSObject {

}
+(Operations*)_instance;

+(Operations*) getInstance;
+(void) getFactors:(int) number:(int**)factors;
+(void) getCombinations:(int*)p:(int*)q:(float**)f_combinations;
+(bool) isInArray:(float*)array:(float)element;
@end
