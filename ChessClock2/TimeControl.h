//
//  TimeControl.h
//  ChessClock2
//
//  Created by ghamer on 3/10/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeControl : NSObject
@property int moves;
@property long durationSeconds;
@property int initialMoveNumber;
- (id)initWith: (NSString *) moveCount I: (NSString *) minutes ;
- (void) setDurationMinutes: (NSString *) minutes;
- (void) setMoveCount: (NSString *) moveCount;
- (NSString *) getMoveCount;
@end
