//
//  TimeControlCell.m
//  ChessClock2
//
//  Created by ghamer on 7/7/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import "TimeControlCell.h"
#import "MoveTextFieldDelegate.h"

@implementation TimeControlCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //_mDelegate = [[MoveTextFieldDelegate  alloc] init];
        //_tDelegate = [[MoveTextFieldDelegate  alloc] init];
        //_moves.delegate = _mDelegate;
        //_durationMinutes.delegate = _tDelegate;
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
