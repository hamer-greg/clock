//
//  ClockViewController.m
//  ChessClock2
//
//  Created by ghamer on 6/25/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//
#import <UIKit/UIKit.h>

#import "ClockViewController.h"
#import "ChessClockRootViewController.h"
#import "ChessClockModelController.h"
#import "ChessClockDataModel.h"
#import "TimeRemainingViewController.h"

@interface ClockViewController ()
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) IBOutlet UITapGestureRecognizer *doubleTouchRecognizer;
@property (nonatomic, strong)  IBOutlet UILabel *left;
@property (nonatomic, strong)  IBOutlet UILabel *right;
@property (nonatomic, strong)  UILabel *white;
@property (nonatomic, strong)  UILabel *black;
@property (nonatomic, strong)  IBOutlet UILabel *leftDelay;
@property (nonatomic, strong)  IBOutlet UILabel *rightDelay;
@property (nonatomic, strong)  UILabel *whiteDelay;
@property (nonatomic, strong)  UILabel *blackDelay;

@end

@implementation ClockViewController

- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
            return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    return self;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL) shouldAutorotate {
    return YES;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
    toInterfaceOrientation == UIInterfaceOrientationLandscapeRight;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationLandscapeLeft;
}
- (void)orientationChanged:(NSNotification *)notification{
    [self adjustViewsForOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
}
- (void) adjustViewsForOrientation:(UIInterfaceOrientation) orientation {

//- (void) viewWillTransitionToSize:(CGSize)size
 //                          withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
//}
   // [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
//- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    NSString *whiteText = _white.text;
    NSString *blackText = _black.text;
    NSString *whiteDelayText = _whiteDelay.text;
    NSString *blackDelayText = _blackDelay.text;
    UIColor *whiteBackground =  _white.backgroundColor;
    UIColor *blackBackground =  _black.backgroundColor;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        self.white = self.left;
        self.black = self.right;
        self.whiteDelay = self.leftDelay;
        self.blackDelay = self.rightDelay;
    } else if (orientation == UIInterfaceOrientationLandscapeRight) {
        self.white = self.right;
        self.whiteDelay = self.rightDelay;
        self.black = self.left;
        self.blackDelay = self.leftDelay;
        
    }
    _white.text = whiteText;
    _black.text = blackText;
    _blackDelay.text = blackDelayText;
    _whiteDelay.text = whiteDelayText;
    _white.backgroundColor = whiteBackground;
    _black.backgroundColor = blackBackground;
    //return [super viewDidLayoutSubviews];
}

- (void) viewWillAppear:(BOOL) animated
{
    [super viewWillAppear:animated];
     [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(orientationChanged:)    name:UIDeviceOrientationDidChangeNotification  object:nil];
    if ([ChessClockDataModel isFirstUse]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pause"
                                                      message:@"Press both clocks to pause and return to the adjustments screen"
                                                   delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
        [alert show];
    }
}


- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
     [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer == self.tapRecognizer)  {
        return NO;
    }

    return  YES;
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([_model isValidPress: [_model whiteClock]] ) {
        _white.backgroundColor = [UIColor whiteColor];
        _black.backgroundColor = [UIColor lightGrayColor];
    } else {
        _white.backgroundColor = [UIColor lightGrayColor];
        _black.backgroundColor = [UIColor whiteColor];
    }
}
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    NSSet *allTouches = [event allTouches];
    UITouch *touch = [allTouches anyObject];
    if ([allTouches count] > 1) {
        return;
    }
    
    //CGPoint point = [touch locationInView: [touch view]];
    CGPoint point2 = [touch locationInView: [self view]];
    CClock *clock = [_model whiteClock];
    CGRect blackFrame = _black.frame;
    if (point2.x >= blackFrame.origin.x && point2.x <= blackFrame.origin.x + blackFrame.size.width) {
    //if ([[self view] bounds].size.width < point2.x * 2) {
        
        
        clock = [_model blackClock];
    }
    if ([_model isValidPress: clock]) {
        [_model pressClock: clock];
        if (clock == [_model whiteClock]) {
            _white.text = [clock getTimeRemaining ];
            _whiteDelay.text = @"";
            _white.backgroundColor = [UIColor orangeColor];
            //_white.backgroundColor = [UIColor lightGrayColor];
            _black.backgroundColor = [UIColor whiteColor];
            
        } else {
            _black.text = [clock getTimeRemaining ];
            _blackDelay.text = @"";
            _white.backgroundColor = [UIColor whiteColor];
            //_black.backgroundColor = [UIColor lightGrayColor];
            _black.backgroundColor = [UIColor orangeColor];
        }
        [self updateRunningClock: nil];
    }
}

-(void) updateRunningClock: (NSTimer *) timer{
    if (_model != nil) {
        CClock * clock = [_model getRunningClock];
        if (clock != nil && clock.isRunning) {
            if (clock == [_model whiteClock]) {
                _white.text = [clock getTimeRemaining ];
                _whiteDelay.text = [clock getDelayRemaining];

            } else {
                _black.text = [clock getTimeRemaining ];
                _blackDelay.text = [clock getDelayRemaining];
            }
            NSTimeInterval interval = [ clock suggestedInterval];
            SEL sel = @selector(updateRunningClock:);
            NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:sel userInfo: clock repeats:FALSE];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        }
    }
}

// double tap, stop the clock and show the time remaining view
- (IBAction)showGestureForTapRecognizer:(UITapGestureRecognizer *) recognizer {
       // UITouch *firstTouch = (UITouch *)[touches  firstObject];
       // UITouch *lastTouch = (UITouch *)[touches  lastObject];
    //CGPoint point0 = [recognizer locationInView: [self view]];
    CGPoint point1 = [recognizer locationOfTouch: 1 inView: [self view]];
    CGPoint point2 = [recognizer locationOfTouch: 0 inView: [self view]];
        CGRect blackFrame = _black.frame;
        bool point2isBlack = point2.x >= blackFrame.origin.x && point2.x <= blackFrame.origin.x + blackFrame.size.width;
        bool point1isBlack = point1.x >= blackFrame.origin.x && point1.x <= blackFrame.origin.x + blackFrame.size.width;
        if (point1isBlack ^ point2isBlack){
            [self dismissClocks];
        } else {
            [self touchesEnded: nil withEvent: nil];
          //  UIView *view = _black.superview;
          //  _white.backgroundColor = view.backgroundColor;
          //  _black.backgroundColor = view.backgroundColor;

        }
    
    //[self dismissClocks ];
}

-(void) dismissClocks {
    //CGPoint location = [recognizer locationInView:self.view];
    [_model stopClocks];
        ChessClockRootViewController *ctrl = (ChessClockRootViewController *) self.presentingViewController;
    UIView * viewController = self.view.superview;
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    [ctrl dismissViewControllerAnimated:YES completion:NULL];
  //  [viewController removeFromSuperview];
   // UIViewController *adjustmentController = [ctrl.modelController viewControllerAtIndex:1 storyboard:ctrl.storyboard];
   // [ctrl addChild:adjustmentController withChildToRemove:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _white = _left;
    _black = _right;
    _whiteDelay = _leftDelay;
    _blackDelay = _rightDelay;

    ChessClockRootViewController *ctrl = (ChessClockRootViewController *) self.presentingViewController;
    if (ctrl != nil) {
        _model = [[ctrl modelController ]model];
        
    }
    [self.view addGestureRecognizer:self.tapRecognizer];
    //[self.view addGestureRecognizer:self.doubleTouchRecognizer];
    _black.text = [[_model blackClock] getTimeRemaining];
    _white.text = [[_model whiteClock] getTimeRemaining];
    
    _blackDelay.text =  @"Black";//[[_model blackClock] getDelayRemaining];
    _whiteDelay.text = @"White";//[[_model whiteClock] getDelayRemaining];
    if ([_model isValidPress: [_model whiteClock]] ) {
        _white.backgroundColor = [UIColor whiteColor];
        _black.backgroundColor = [UIColor lightGrayColor];
    } else {
        _white.backgroundColor = [UIColor lightGrayColor];
        _black.backgroundColor = [UIColor whiteColor];
    }

	// Do any additional setup after loading the view.
    [UIApplication sharedApplication].idleTimerDisabled = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
