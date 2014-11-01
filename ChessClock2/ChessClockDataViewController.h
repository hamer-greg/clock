//
//  ChessClockDataViewController.h
//  ChessClock2
//
//  Created by ghamer on 1/27/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/NSCoder.h>
#import "MoveTextFieldDelegate.h"
#import "TimeDelayDataSource.h"
#import "ChessClockDataModel.h"
#import "IncrementViewController.h"
@class MoveTextFieldDelegate;
@interface ChessClockDataViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIStepper *timeIntervalStepper;
@property (strong, nonatomic) IBOutlet UILabel *dataLabel;
@property (strong, nonatomic) ChessClockDataModel * model;
@property (nonatomic, strong) IBOutlet UITableView *timeControlTable;
@property (nonatomic, strong) IBOutlet  UIButton *gameButton;
//- (id)initWith: (ChessClockDataModel *) model;
- (IBAction)addTimeControlInterval:(id)sender;
- (IBAction)showAdjustmentsView:(id)sender;
-(BOOL) updateIntervalIndex ;
-(BOOL)textFieldPassesEdit:(UITextField *) theTextField;
@property (weak, nonatomic) IBOutlet UIButton *addRowButton;
@property (weak, nonatomic) NSIndexPath * intervalIndex;
@property MoveTextFieldDelegate *mDelegate ;
@property MoveTextFieldDelegate *tDelegate ;
@end
