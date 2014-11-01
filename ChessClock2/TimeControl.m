//
//  TimeControl.m
//  ChessClock2
//
//  Created by ghamer on 3/10/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import "TimeControl.h"
//holds one time control period
@implementation TimeControl
-(id) initWith:(NSString *) moveCount I: (NSString *) minutes {
    if (self = [super init]) {
        _moves = [moveCount intValue];
        _durationSeconds = [minutes intValue] * 60L;
    }
    return self;
}

- (void) setDurationMinutes: (NSString *) minutes {
   _durationSeconds = [minutes intValue] * 60L;
}

- (void) setMoveCount: (NSString *) moveCount {
    _moves = [moveCount intValue];
}

-(NSString *) getMoveCount {
    if (_moves == 0) {
        return @"Game";
    } else {
        return [NSString stringWithFormat:@"%.2d", _moves ];
    }

}
@end
