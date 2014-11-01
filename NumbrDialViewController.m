//
//  NumbrDialViewController.m
//  chessclock2
//
//  Created by Greg Hamer on 8/12/14.
//  Copyright (c) 2014 ghamer. All rights reserved.
//

#import "NumbrDialViewController.h"

@interface NumbrDialViewController ()
- (IBAction)keyPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *keyDownLabel;
@property (nonatomic, weak) IBOutlet UIButton *button0;
@property (nonatomic, weak) IBOutlet UIButton *button1;
@property (nonatomic, weak) IBOutlet UIButton *button2;
@property (nonatomic, weak) IBOutlet UIButton *button3;
@property (nonatomic, weak) IBOutlet UIButton *button4;
@property (nonatomic, weak) IBOutlet UIButton *button5;
@property (nonatomic, weak) IBOutlet UIButton *button6;
@property (nonatomic, weak) IBOutlet UIButton *button7;
@property (nonatomic, weak) IBOutlet UIButton *button8;
@property (nonatomic, weak) IBOutlet UIButton *button9;
@property (nonatomic, weak) IBOutlet UIButton *buttonClose;
@property (nonatomic, weak) IBOutlet UIButton *buttonDelete;
@property (nonatomic, weak) IBOutlet UIButton *buttonDot;
@property (nonatomic, weak) IBOutlet UIButton *buttonNeg;
@property CGPoint origin;
@property (nonatomic, strong) IBOutlet UIPanGestureRecognizer *panRecognizer;
@property CGFloat baseRotation;
@property CGFloat currentRotation;


@end

@implementation NumbrDialViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
         self.currentRotation = 0.0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    SEL keyReleasedMethod = @selector(keyReleased:);
    [_button0 addTarget:self action:keyReleasedMethod
       forControlEvents:(UIControlEventTouchUpInside)];
    [_button1 addTarget:self action:keyReleasedMethod
       forControlEvents:(UIControlEventTouchUpInside)];
    [_button2 addTarget:self action:keyReleasedMethod
       forControlEvents:(UIControlEventTouchUpInside)];
    [_button3 addTarget:self action:keyReleasedMethod
       forControlEvents:(UIControlEventTouchUpInside)];
    [_button4 addTarget:self action:keyReleasedMethod
       forControlEvents:(UIControlEventTouchUpInside)];
    [_button5 addTarget:self action:keyReleasedMethod
       forControlEvents:(UIControlEventTouchUpInside)];
    [_button6 addTarget:self action:keyReleasedMethod
       forControlEvents:(UIControlEventTouchUpInside)];
    [_button7 addTarget:self action:keyReleasedMethod
       forControlEvents:(UIControlEventTouchUpInside)];
    [_button8 addTarget:self action:keyReleasedMethod
       forControlEvents:(UIControlEventTouchUpInside)];
    [_button9 addTarget:self action:keyReleasedMethod
       forControlEvents:(UIControlEventTouchUpInside)];
    [_buttonClose addTarget:self action:keyReleasedMethod
           forControlEvents:(UIControlEventTouchUpInside)];
    [_buttonDelete addTarget:self action:keyReleasedMethod
            forControlEvents:(UIControlEventTouchUpInside)];

}
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    return YES;
}
- (IBAction)keyReleased:(id)sender {
    UIButton * button = (UIButton *) sender;
    self.keyDownLabel.hidden = true;
    
    if (button == self.buttonClose) {
        [self.numberDelegate.textField resignFirstResponder];
        return;
    }
    UITextRange * selRange = self.numberDelegate.textField.selectedTextRange;
    if (button == self.buttonDelete) {
        UITextPosition *caretPos = selRange.start;
        if (!selRange.empty) {
            [self.numberDelegate.textField replaceRange:selRange withText: @""];
            return;
        }
        NSInteger minusOne = -1;
        UITextPosition *delPos = [self.numberDelegate.textField  positionFromPosition:caretPos offset:
                                  minusOne ] ;
        UITextRange * range =    [self.numberDelegate.textField textRangeFromPosition: delPos toPosition: selRange.start];
        [self.numberDelegate.textField replaceRange:range withText:@""];
        return;
    }
    if (selRange != nil) {
        [self.numberDelegate.textField replaceRange:selRange withText: button.titleLabel.text];
    }
}
- (IBAction)keyPressed:(id)sender {
    UIButton * button = (UIButton *) sender;
    self.keyDownLabel.text = button.titleLabel.text;
    CGPoint center =  button.center;
    
    self.keyDownLabel.center = CGPointMake(center.x, center.y - 64);
    self.keyDownLabel.hidden = false;
    
}
/*
 In response to a rotation gesture, show the image view at the rotation given by the recognizer. At the end of the gesture, make the image fade out in place while rotating back to horizontal.
 */
- (IBAction)showGestureForPanRecognizer:(UIPanGestureRecognizer *)recognizer {
    if([recognizer state] == UIGestureRecognizerStateEnded) {
        return;
    }
    NumberTextFieldDelegate * delegate = self.numberDelegate;
	
    UIView *view = self.imageView.superview;
	CGPoint touchLocation = [recognizer locationInView:view];
    CGPoint center = self.imageView.center;
    CGFloat x = touchLocation.x - center.x;
    CGFloat y = -(touchLocation.y - center.y);
    CGFloat radius =  sqrt((x * x) + ( y * y));
    if (radius < 5) {
        return;
    }
    CGFloat sin = y / radius;
    CGFloat cos = x / radius;
    
    CGFloat angleS = asinf(sin);
    CGFloat angleC = acosf(cos);
    //[recognizer
    CGFloat angle = angleS > 0 ? angleC : (M_PI * 2.0) - angleC;
    if([recognizer state] == UIGestureRecognizerStateBegan) {
        //setup prevRotation based on text field value
        float num = [self.numberDelegate.textField.text floatValue];
        float relRotation = num - self.numberDelegate.min;
        int rotations = 0;
        while (relRotation > self.numberDelegate.revolution) {
            rotations++;
            relRotation -= self.numberDelegate.revolution;
        }
        relRotation = (relRotation * M_PI * 2.0)/self.numberDelegate.revolution;
        [self.numberDelegate setRotation: rotations*(M_PI * 2.0)];
        
        
        [self.numberDelegate setBaseAngle:angle + relRotation];
        [self.numberDelegate setPrevAngle:angle ];
        self.numberDelegate.statusLabel.text = [NSString stringWithFormat:@"rotations=%3.1d relRotation=%6.2f  angle=%6.2f",rotations,relRotation,angle];
        self.baseRotation = relRotation -self.currentRotation;
        return;
    }
    //rotation and relrotation are in  radians
    //rotation is 0, 2pi, 4 pi etc.
    //rotation + relrotaion = the spin, so spin * amount per revolution / (2pi) is the number for the text field
    CGFloat diffAngle =  self.numberDelegate.prevAngle - angle;
    CGFloat rotation = self.numberDelegate.rotation;
    if (diffAngle > M_PI) {
        rotation = rotation - (M_PI * 2.0);
        [self.numberDelegate setRotation: rotation];
    } else if (diffAngle < -M_PI) {
        rotation = rotation + (M_PI * 2.0);
        [self.numberDelegate setRotation: rotation];
    }
    [self.numberDelegate setPrevAngle: angle];
    CGFloat relRotation = self.numberDelegate.baseAngle - angle;
    CGFloat val = relRotation  + rotation;
    CGFloat adjustedVal = [delegate setTextFromValue: val];
    if (adjustedVal != val) {
        relRotation =  adjustedVal - rotation;
        [self.numberDelegate setBaseAngle:angle + relRotation];
        [self.numberDelegate setPrevAngle:angle ];
    }
    CGAffineTransform transform = CGAffineTransformMakeRotation(relRotation);
    self.imageView.transform = transform;
    self.currentRotation = relRotation - self.baseRotation;
    self.currentRotation = relRotation ;
    self.numberDelegate.statusLabel.text = [NSString stringWithFormat:@"rotations=%6.2f relRotation=%6.2f  angle=%6.2f",rotation,relRotation,angle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
