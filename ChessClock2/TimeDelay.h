//
//  TimeDelay.h
//  ChessClock2
//
//  Created by ghamer on 7/6/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum { Simple, Fischer, FischerAfter, Bronstein } DelayType;
@interface TimeDelay : NSObject
@property DelayType type;
@property int delaySeconds;
-( int) startBonus;
-( int) startDelay;
-( int) endDelay;
-( int) endBonus;
-(NSString *) name;
- (id)initWith: (DelayType) delayType;
-(NSString *) hint;
@end

