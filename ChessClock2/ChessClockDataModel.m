//
//  ChessClockDataModel.m
//  ChessClock2
//
//  Created by ghamer on 8/30/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import "ChessClockDataModel.h"

@implementation ChessClockDataModel
static Boolean firstUse = true;
-(id) init {
    self = [super init];
    _delay = [[ TimeDelay alloc] initWith: Simple];
    _delay.delaySeconds = 5;
    if (_intervals == nil) {
        _intervals = [NSMutableArray arrayWithObjects:
                         [[TimeControl alloc ]initWith: @"G" I: @"5"],
                         nil];
    }
    _blackClock = [[CClock alloc] initWithController:self];
    _whiteClock= [[CClock alloc] initWithController:self];
    firstUse = true;
    return self;
    
}

+(Boolean) isFirstUse {
    Boolean result = firstUse;
    firstUse = false;
    return result;
    
}

-(void) pressClock : (CClock *) clock {
    NSDate *now = [NSDate date];
    CClock *otherClock = _whiteClock;
    if (clock == _whiteClock) {
        otherClock = _blackClock;
    }
    if ([clock isRunning]) {
        [clock stopClock: FALSE timestamp: now];
        
    }
    [otherClock startClock:  now];
}

-(Boolean) isValidPress:(CClock *) clock {
    if ([clock isRunning] ) {
        return TRUE;
    } if (clock == _blackClock) {
        if (![_whiteClock isRunning]  && [_whiteClock currentMove] == [_blackClock currentMove]) {
            return TRUE;
        }
    } else if (![_blackClock isRunning] && [_whiteClock currentMove] != [_blackClock currentMove]) {
        return TRUE;
    }
    return FALSE;
}

-(void) resetIntervals {
    int initialMoveNum = 0;
    for (NSInteger i=0; i < _intervals.count; i++) {
        TimeControl * tc = [self getTimeControl: i];
        tc.initialMoveNumber = initialMoveNum;
        initialMoveNum += tc.moves;
    }
}

-(void) reset {
    [_whiteClock reset ];
    [_blackClock reset ];
    [self resetIntervals];
    
}

-(CClock *) getRunningClock {
    if ([_whiteClock isRunning]) {
        return _whiteClock;
    } else if ([_blackClock isRunning]){
        return _blackClock;
    }
    return nil;
    
}

-(void) stopClocks {
    
    CClock * runningClock = [self getRunningClock ];
    if (runningClock != nil) {
        NSDate * ts = [NSDate date];
        [runningClock stopClock: TRUE timestamp: ts];
    }
}

-(TimeControl *) getTimeControl : (NSInteger )interval {
    return [_intervals objectAtIndex:interval];
}

-(void) setTimeInterval : (TimeControl *) interval atIndex: (NSInteger) index {
    [_intervals setObject:interval atIndexedSubscript:index ];
}

-(void) deleteTimeInterval : (NSInteger) index {
    [_intervals removeObjectAtIndex:index];
}

-(void) insertTimeInterval : (TimeControl *) interval atIndex: (NSInteger) index {
    [_intervals insertObject:interval atIndex:index ];
}

-(void) setTimeControl : (TimeControlCell *) cell atIndex: (NSInteger) interval {
    TimeControl * tc = [self getTimeControl: interval];
    if (tc == nil) {
        tc = [[TimeControl alloc  ]initWith:[[cell moves] text]I: [[cell durationMinutes]text]];
        [ _intervals addObject: tc];
    } else {
        [tc setDurationMinutes:[[cell durationMinutes]text]];
        [tc setMoveCount:[[cell moves] text]];
    }
    
}

-(void) removeTimeControl : (NSInteger )interval {
    [_intervals  removeObjectAtIndex: interval];
}
@end
