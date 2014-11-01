//
//  IncrementViewController.h
//  ChessClock2
//
//  Created by ghamer on 9/29/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessClockModelController.h"
#import "TimeDelayDataSource.h"
#import "NumberTextFieldDelegate.h"

@interface IncrementViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
- (IBAction)updateIncrement:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *styleLabel;
@property (weak, nonatomic) IBOutlet UITextField *delayText;
@property (strong, nonatomic) IBOutlet TimeDelayDataSource *timeDelaySource;
@property (nonatomic, strong) IBOutlet UIPickerView *delayPicker;
@property (strong, nonatomic) ChessClockDataModel * model;
@property (strong, nonatomic) NumberTextFieldDelegate * _mDelegate ;

@end
