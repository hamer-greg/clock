//
//  TimeRemainingViewController.m
//  ChessClock2
//
//  Created by ghamer on 9/3/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import "TimeRemainingViewController.h"
#import  "ChessClockRootViewController.h"
#import "ChessClockModelController.h"
#import "ClockViewController.h"

@implementation TimeRemainingViewController

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(keyboardWasShown:)
        name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(keyboardWillBeHidden:)
        name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    aRect.size.height -= _scrollView.frame.origin.y;
    CGPoint fieldRect =_activeField.frame.origin;
    fieldRect.y += _activeField.bounds.size.height;
    if (!CGRectContainsPoint(aRect, fieldRect)) {
        CGPoint scrollPoint = CGPointMake(0.0, fieldRect.y - aRect.size.height );
        [_scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    [_scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
}

- (BOOL) shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

-(void) viewWillAppear: (BOOL) animated {
    [super viewWillAppear: animated];
     CGRect rect = self.parentViewController.view.frame;
    
    [self refresh];
}
//- (void) viewWillTransitionToSize:(CGSize)size
//                          withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
//    CGSize sz = size;
//    CGAffineTransform tr = [coordinator targetTransform];
//    //[self orientationFromTransform: tr];
//    CGAffineTransform invertedTr = CGAffineTransformIdentity;
//    CGAffineTransform  center = CGAffineTransformMakeTranslation( sz.width/4,sz.width/4);
//    invertedTr = CGAffineTransformMakeRotation(3 * M_PI / 2.0);
//    CGRect currentBounds = self.view.bounds;
//    self.view.transform = CGAffineTransformConcat(  center,invertedTr);
//}


- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect rect = self.parentViewController.view.frame;
    self.view.frame = rect;

	// Do any additional setup after loading the view.
    [self registerForKeyboardNotifications];
    [_toMoveButton addTarget:self action:@selector(toggleToMove)
            forControlEvents:(UIControlEventTouchUpInside)];
    [_whiteStepper addTarget:self action:@selector(alterWhiteTime) forControlEvents:(UIControlEventValueChanged)];
    [_blackStepper addTarget:self action:@selector(alterBlackTime) forControlEvents:(UIControlEventValueChanged)];
    [_toMoveButton setTitle: @"White to Move"  forState:UIControlStateNormal];
    [_toMoveButton setTitle: @"Black to Move"  forState:UIControlStateSelected];
}

-(void) refresh {
    _whiteTimeRemainingText.text = [[_model whiteClock] getTimeRemaining];
    _blackTimeRemainingText.text = [[_model blackClock] getTimeRemaining];
    int moveNumber =[[_model whiteClock] currentMove];
    _moveNumberText.text =[NSString stringWithFormat:@"%d",moveNumber];
    _toMoveButton.selected = moveNumber == [_model blackClock].currentMove ? NO: YES;
     _whiteStepper.value = (int) ([[_model whiteClock] timeRemaining] / 60);
    _blackStepper.value = (int) ([[_model blackClock] timeRemaining] / 60);
    
}

-(void) alterWhiteTime {
    int minutes = _whiteStepper.value;
    [self updateText:_whiteTimeRemainingText with:minutes];
}

-(void) alterBlackTime {
    int minutes = _blackStepper.value;
    [self updateText:_blackTimeRemainingText with:minutes];
}

-(void) updateText: (UITextField *) textField with:(int) minutes {
    NSString *value  = textField.text;
    NSString *remainingText = @":00";
    NSRange range = [value rangeOfString:@":"];
    if (range.length  != 0 && range.location != 0 && range.location < [value length] -1) {
        remainingText = [value substringFromIndex:(range.location)];
    }
    NSString * formatString = [@"%d" stringByAppendingString:remainingText];
    textField.text = [NSString stringWithFormat:formatString, minutes] ;
    [self textFieldShouldReturn: textField];
}

-(void) toggleToMove {
    int moveNumber = [_model whiteClock].currentMove;
    Boolean whiteToMove = moveNumber == [_model blackClock].currentMove;
    if (!whiteToMove) {
        [[_model blackClock] resetMove:moveNumber];
        _toMoveButton.selected = NO;
    } else {
        [[_model blackClock] resetMove:moveNumber - 1];
        _toMoveButton.selected = YES;
    }
}

-(NSTimeInterval) getTimeRemaining: (UITextField *) textField {
    NSString * value  = textField.text;
    NSRange range = [value rangeOfString:@":"];
    if (range.length  != 0 && range.location != 0 && range.location < [value length] -1) {
        NSString *secondsText = [value substringFromIndex:(range.location +1) ];
        
        int seconds = [secondsText intValue];
        if ([secondsText length] == 2 &&  seconds < 60 &&
            (seconds > 0 || [secondsText rangeOfString:@"00"].length == 2)) {
            NSString *minutesText = [value substringToIndex:range.location];
            int minutes = [minutesText intValue];
            if (minutes > 0 || [minutesText rangeOfString:@"0"].length == 1) {
                return minutes * 60 + seconds;
            }
        }
    }
    return -1;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _activeField = textField;
    [_activeField selectAll:self];
    [UIMenuController sharedMenuController].menuVisible = NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    _activeField = nil;
}

- (void)updateModel:(UITextField *) theTextField {
    if (theTextField == _blackTimeRemainingText) {
        NSTimeInterval timeRemaining = [self getTimeRemaining:_blackTimeRemainingText];
        if (timeRemaining == -1) {
            _blackTimeRemainingText.text = [[_model blackClock] getTimeRemaining];
            [self showErrorMessage:@"Time must be in the form m:ss"];
        } else {
            [_model blackClock].timeRemaining = timeRemaining;
            _blackStepper.value = (int) (timeRemaining / 60);
        }
    } else if (theTextField == _whiteTimeRemainingText) {
        NSTimeInterval timeRemaining = [self getTimeRemaining: _whiteTimeRemainingText];
        if (timeRemaining == -1) {
            _whiteTimeRemainingText.text = [[_model whiteClock] getTimeRemaining];
            [self showErrorMessage:@"Time must be in the form m:ss"];
        } else {
            [_model whiteClock].timeRemaining = timeRemaining;
            _whiteStepper.value = (int) (timeRemaining / 60);
        }
    } else if (theTextField == _moveNumberText) {
        int moveNumber = [_moveNumberText.text intValue];
        NSRange range = [_moveNumberText.text rangeOfString:@"0"];
        if (moveNumber > 0 || (range.length == 1 && range.location == 0)) {
            int blackMoveDiff = [_model whiteClock].currentMove - [_model blackClock].currentMove;
            [[_model whiteClock] resetMove:moveNumber];
            [[_model blackClock] resetMove:moveNumber - blackMoveDiff];
        } else {
            moveNumber = [_model whiteClock].currentMove;
            [self showErrorMessage:@"Move must be non negative number"];
        }
        _moveNumberText.text = [NSString stringWithFormat:@"%d", moveNumber];
    }
}

-(void) showErrorMessage: (NSString *) msg {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

-(BOOL) textFieldShouldBeginEditing:(UITextField *)textField {
    if (_activeField != nil) {
        [self updateModel: _activeField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *) theTextField {
    [self updateModel: theTextField];
    [theTextField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startNewGame:(id)sender {
    [_model reset];
    ChessClockRootViewController *ctrl = (ChessClockRootViewController *) self.parentViewController;
    UIViewController *clockController = (ClockViewController *)
    [ctrl.modelController viewControllerAtIndex:2 storyboard:ctrl.storyboard];
    [self presentViewController:clockController animated:YES completion:NULL];
}

- (IBAction)timeControlAction:(id)sender {
    [_model reset];
    ChessClockRootViewController *ctrl = (ChessClockRootViewController *) self.parentViewController;
    UIViewController *clockDataViewController = 
        [ctrl.modelController viewControllerAtIndex:0 storyboard:ctrl.storyboard];
    [ctrl addChild:clockDataViewController withChildToRemove:self];
}

- (IBAction)resumeGame:(id)sender {
    ChessClockRootViewController *ctrl = (ChessClockRootViewController *) self.parentViewController;
    UIViewController *clockController = (ClockViewController *)
        [ctrl.modelController viewControllerAtIndex:2 storyboard:ctrl.storyboard];
    [self updateModel: _moveNumberText];
    [self updateModel: _blackTimeRemainingText];
    [self updateModel: _whiteTimeRemainingText];
    [self presentViewController:clockController animated:YES completion:NULL];
}
@end
