//
//  ChessClockDataModel.h
//  ChessClock2
//
//  Created by ghamer on 8/30/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "TimeControl.h"
#import "TimeControlCell.h"
#import "TimeDelay.h"
#import "CClock.h"

@interface ChessClockDataModel : NSObject
@property (nonatomic, strong) CClock *whiteClock;
@property (nonatomic, strong) NSMutableArray *intervals;
@property (nonatomic, strong) CClock *blackClock;
@property (nonatomic, strong) TimeDelay *delay;
-(id) init;
-(void) reset;
-(void) stopClocks;
-(TimeControl *) getTimeControl : (NSInteger )interval;
-(void) removeTimeControl : (NSInteger )interval;
-(void) setTimeControl : (TimeControlCell *) cell atIndex: (NSInteger) index;
-(void) setTimeInterval : (TimeControl *) interval atIndex: (NSInteger) index;
-(void) insertTimeInterval : (TimeControl *) interval atIndex: (NSInteger) index;
-(void) deleteTimeInterval : (NSInteger) index;
-(void) pressClock : (CClock *) clock ;
-(CClock *) getRunningClock;
-(Boolean) isValidPress:(CClock *)clock;
+(Boolean) isFirstUse;
@end
