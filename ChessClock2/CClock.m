//
//  Clock.m
//  ChessClock2
//
//  Created by ghamer on 3/3/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import "TimeControl.h"
#import "ChessClockDataModel.h"

@implementation CClock
BOOL paused;

-(id)initWithController:(ChessClockDataModel *)model {
    self = [super init];
    if (self) {
        _model = model;
        _isDelay = false;
        _isRunning = false;
        [self reset];
        return self;
    }
    return nil;
}

-(void) reset {
    _intervalSubscript = 0;
    _currentMove = 0;
    TimeControl *tc = (TimeControl *)[[_model intervals] objectAtIndex:((NSUInteger) _intervalSubscript)];
    _timeRemaining = [tc durationSeconds];
    _delayRemaining = 0;
    paused = FALSE;
}

-(void) resetMove: (int) move {
    _currentMove = move;
}

-(void) startClock: (NSDate *) ts {
    if (!paused) {
       _timeRemaining += [[_model delay] startBonus];
       _delayRemaining = [[_model delay] startDelay];
    }
    paused = FALSE;
    _moveStartTime = [ts  dateByAddingTimeInterval:(_delayRemaining)];
    _isRunning = true;
    _isDelay = _delayRemaining > 0;
}

-(void) incrementMove {
    _currentMove++;
    TimeControl *tc = [_model getTimeControl:_intervalSubscript];
    int presentIntervalCurrentMove = _currentMove -[tc initialMoveNumber];
    int tcMoveDuration = [tc moves];
    if (tcMoveDuration > 0) {
        if (presentIntervalCurrentMove % [tc moves] == 0){
            if ([[_model intervals] count] > _intervalSubscript +1) {
                _intervalSubscript ++;
            }
            _timeRemaining += [[_model getTimeControl:_intervalSubscript] durationSeconds];
        }
    }
}

-(NSTimeInterval) suggestedInterval{
    NSTimeInterval interval = [_moveStartTime timeIntervalSinceNow];
    int seconds = (int) interval;
    interval -= seconds;
    if (interval < .05) {
        return (NSTimeInterval)1.0;
    }
    return interval;
}

-(void) stopClock: (Boolean) pause timestamp:(NSDate *) ts{
    NSDate *now = ts;
    NSTimeInterval elapsedTime = [now  timeIntervalSinceDate:_moveStartTime];
    if (elapsedTime > 0) {
        _timeRemaining -= elapsedTime;
        if (_timeRemaining < 0) {
            _timeRemaining = 0;
        }
    }
    if (_timeRemaining > 0 && !pause) {
        _timeRemaining += [[_model delay] endBonus];
        int endDelayBonus = [[_model delay] endDelay];
        if (endDelayBonus > 0) {
            if (endDelayBonus > elapsedTime) {
                _timeRemaining += elapsedTime;
            } else {
                _timeRemaining += endDelayBonus;
            }
        }
    }
    _isRunning = false;
    _moveStartTime = now;
    paused = pause;
    if (!pause) {
        [self incrementMove];
    };
}

-(Boolean) isEndOfInterval{
    return FALSE;
}

-(NSString *) formatTime: (NSTimeInterval) ts {
    int seconds = (int) (ts + .999);
    int minutes = seconds / 60;
    int sec = seconds % 60;
    return  [NSString stringWithFormat:@"%d:%02d",minutes ,sec ];
}

-(NSString *) getDelayRemaining {
    if (_delayRemaining > 0.0) {
        int seconds = (int) (_delayRemaining + .999);
        int minutes = seconds / 60;
        int sec = seconds % 60;
        if (minutes > 0) {
            return  [NSString stringWithFormat:@"%d:%02d",minutes ,sec ];
        }
        return [NSString stringWithFormat:@":%02d",sec ];
    }
    return @" ";
}

-(NSTimeInterval) getTimeRemainingSeconds{
    return _timeRemaining;
    
}

-(NSString *) getTimeRemaining {
    NSTimeInterval time = _timeRemaining;
    if (_isRunning){
        NSDate *now = [NSDate date];
        NSTimeInterval elapsedTime = [_moveStartTime timeIntervalSinceDate:now];
        if (elapsedTime > 0) {
            _delayRemaining = elapsedTime;
        } else {
            _delayRemaining = 0;
            time += elapsedTime;
        }
        if (time<= 0) {
            [self stopClock: FALSE timestamp:now ];
            _timeRemaining = 0.0;
        }
    } 
    return  [self formatTime: time];
}

@end
