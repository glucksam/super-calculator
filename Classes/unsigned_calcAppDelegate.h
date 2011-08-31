//
//  unsigned_calcAppDelegate.h
//  unsigned_calc
//
//  Created by Adi Glucksam on 22/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class unsigned_calcViewController;

@interface unsigned_calcAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    unsigned_calcViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet unsigned_calcViewController *viewController;

@end

