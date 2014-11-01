//
//  TimeDelay.m
//  ChessClock2
//
//  Created by ghamer on 7/6/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import "TimeDelay.h"

@implementation TimeDelay

- (id)initWith: (DelayType) delayType
{
    self = [super init];
    if (self) {
        _type = delayType;
    }
    return self;
}
-(NSString *) hint{
    switch (_type) {
        case Simple:
            return @"Delays the start of the clock by the Increment amount.";
        case Fischer:
            return @"Adds the Increment amount to the time remaining as a bonus at the begining of the move.";
        case FischerAfter:
            return @"Adds the Increment amount to the time remaining as a bonus at the end of the move.";
        case Bronstein:
            return @"Adds back the Increment amount at the end of the move, but never more than the time taken to make the move.";
        default:
            return @"??";
    }
}

-(int) startDelay {
    switch (_type) {
        case Simple:
            return [self delaySeconds];
        case Fischer:
        case FischerAfter:
        case Bronstein:
            return 0;
    }
}

-(int) endDelay {
    switch (_type) {
        case Bronstein:
            return [self delaySeconds];
        case Fischer:
        case FischerAfter:
        case Simple:
            return 0;
    }
}

-(int) startBonus {
    switch (_type) {
        case Fischer:
            return [self delaySeconds];
        case Simple:
        case FischerAfter:
        case Bronstein:
            return 0;
    }
}

-(int) endBonus {
    switch (_type) {
        case FischerAfter:
            return [self delaySeconds];
        case Simple:
        case Fischer:
        case Bronstein:
            return 0;
    }
}

-(NSString *) name {
    switch (_type) {
        case Simple:
            return @"Simple";
        case Fischer:
            return @"Fischer";
        case FischerAfter:
            return @"FischerAfter";
        case Bronstein:
            return @"Bronstein";
    }
}
  
@end
