//
//  MoveTextFieldDelegate.m
//  chessclock2
//
//  Created by Greg Hamer on 6/5/14.
//  Copyright (c) 2014 ghamer. All rights reserved.
//

#import "MoveTextFieldDelegate.h"
#import "TimeControlCell.h"

@implementation MoveTextFieldDelegate

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    UIView * cellParent = [[textField superview ]superview] ;//superview];
    TimeControlCell * cell = nil;
    if ([cellParent isMemberOfClass:[TimeControlCell class]]) {
        cell = (TimeControlCell *) cellParent;
    } else {
        cell = (TimeControlCell *)[cellParent superview];
    }
    NSIndexPath * path = [_controller.timeControlTable indexPathForCell: cell];
    [_controller updateIntervalIndex];
    [_controller.timeControlTable selectRowAtIndexPath:path animated: NO scrollPosition :UITableViewScrollPositionNone];
    _controller.intervalIndex = path;
    if ([[textField restorationIdentifier] isEqual: @"1"]  && path.row == [[_controller.model intervals] count] -1) {
        self.min = 0;
    } else {
        self.min = 1;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *) theTextField {
    [theTextField resignFirstResponder];
    [_controller textFieldPassesEdit: theTextField];
    return YES;
}

-(id) init {
    self =[super initWithMin: 1 max:999  revolutionIncrement: 60.0 format: @"%3.0f"];
    return self;
}



@end
