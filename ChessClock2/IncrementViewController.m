//
//  IncrementViewController.m
//  ChessClock2
//
//  Created by ghamer on 9/29/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import "IncrementViewController.h"
#import "ChessClockRootViewController.h"

@interface IncrementViewController ()
@end

@implementation IncrementViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self._mDelegate == nil){
        self._mDelegate = [[NumberTextFieldDelegate  alloc]  initWithMin: 0 max:999  revolutionIncrement: 20.0 format: @"%3.0f"];
        self.delayText.delegate = self._mDelegate;
        self.delayText.inputView = self._mDelegate.getInputView;
    }

	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.timeDelaySource = [[TimeDelayDataSource alloc] init];
    self.timeDelaySource.hintText =  _styleLabel ;
    self.timeDelaySource.model = _model ;
    _styleLabel.text = _model.delay.hint;
    self.delayText.text =  [NSString stringWithFormat:@"%2d",_model.delay.delaySeconds];
    self.stepper.value = _model.delay.delaySeconds;
    self.delayPicker.dataSource = self.timeDelaySource;
    self.delayPicker.delegate = self.timeDelaySource;
    [self.delayPicker selectRow: _model.delay.type inComponent: 0 animated: NO];
    [_stepper addTarget:self action:@selector(alterIncrement) forControlEvents:(UIControlEventValueChanged)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *) theTextField {
    //if (theTextField == self.delayText) {
    //    _dataObject.delay.delaySeconds = [theTextField.text intValue];
    //}
    [theTextField resignFirstResponder];
    _stepper.value = [theTextField.text intValue];
    return YES;
}

-(void) alterIncrement {
    int seconds = _stepper.value;
    self.delayText.text =  [NSString stringWithFormat:@"%2d",seconds];
    _model.delay.delaySeconds = seconds;
}

- (IBAction)updateIncrement:(id)sender {
    int seconds = [self.delayText.text intValue];
    _model.delay.delaySeconds = seconds;
    _stepper.value = seconds;
    ChessClockRootViewController *ctrl = (ChessClockRootViewController *) self.parentViewController;
    UIViewController *clockDataViewController = 
    [ctrl.modelController viewControllerAtIndex:0 storyboard:ctrl.storyboard];
    [ctrl addChild:clockDataViewController withChildToRemove:self];
}
@end
