//
//  MoveTextFieldDelegate.h
//  chessclock2
//
//  Created by Greg Hamer on 6/5/14.
//  Copyright (c) 2014 ghamer. All rights reserved.
//

#import "NumberTextFieldDelegate.h"
#import "ChessClockDataViewController.h"
@class ChessClockDataViewController;
@interface MoveTextFieldDelegate : NumberTextFieldDelegate  <UITextFieldDelegate>
@property ChessClockDataViewController *controller;
@end
