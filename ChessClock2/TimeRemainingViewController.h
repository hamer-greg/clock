//
//  TimeRemainingViewController.h
//  ChessClock2
//
//  Created by ghamer on 9/3/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessClockDataModel.h"

@interface TimeRemainingViewController : UIViewController <UITextFieldDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIStepper *whiteStepper;
@property (weak, nonatomic) IBOutlet UIStepper *blackStepper;
@property  (atomic, strong) ChessClockDataModel *model;
@property (nonatomic, strong) IBOutlet  UITextField *blackTimeRemainingText;
@property (nonatomic, strong) IBOutlet  UITextField *whiteTimeRemainingText;
@property (nonatomic, strong) IBOutlet  UITextField *moveNumberText;
@property (nonatomic, strong) IBOutlet  UIButton *toMoveButton;
@property (nonatomic, strong) IBOutlet  UIBarButtonItem *resumeButton;
@property (nonatomic, strong) IBOutlet  UIBarButtonItem *gameButton;
@property (nonatomic, strong) IBOutlet  UIBarButtonItem *timeControlButton;
@property (nonatomic, strong) IBOutlet  UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *activeField;
- (IBAction)resumeGame:(id)sender;
- (IBAction)timeControlAction:(id)sender;
- (IBAction)startNewGame:(id)sender;
@end
