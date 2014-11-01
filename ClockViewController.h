//
//  ClockViewController.h
//  ChessClock2
//
//  Created by ghamer on 6/25/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessClockDataModel.h"

@interface ClockViewController : UIViewController <UIGestureRecognizerDelegate>
@property  (atomic, strong) ChessClockDataModel *model;
-(void) updateRunningClock: (NSTimer *) timer;
-(void)dismissClocks;
@end
