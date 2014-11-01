//
//  Clock.h
//  ChessClock2
//
//  Created by ghamer on 3/3/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ChessClockDataModel;
@interface CClock : NSObject
@property (nonatomic, copy) ChessClockDataModel *model;
@property (nonatomic, copy) NSDate *moveStartTime;
@property (readonly, nonatomic) Boolean isRunning;
@property (readonly, nonatomic) Boolean isDelay;
@property (readonly, nonatomic) int currentMove;
@property NSTimeInterval timeRemaining;
@property NSTimeInterval delayRemaining;
@property int intervalSubscript;
@property NSTimeInterval ts;
-(id) initWithController:(ChessClockDataModel *) model;
-(void) reset;
-(void) startClock:(NSDate *) timestamp;
-(void) stopClock: (Boolean) pause timestamp:(NSDate *) stamp;
-(Boolean) isEndOfInterval;
-(NSString *) formatTime: (NSTimeInterval) seconds;
-(NSTimeInterval) getTimeRemainingSeconds;
-(NSString *) getTimeRemaining;
-(NSString *) getDelayRemaining;
-(NSTimeInterval) suggestedInterval;
-(void) resetMove: (int) move;
@end
