//
//  ChessClockDataViewController.m
//  ChessClock2
//
//  Created by ghamer on 1/27/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import "ChessClockDataViewController.h"
#import "TimeControlCell.h"
#import "TimeControl.h"
#import "ChessClockRootViewController.h"
#import "ChessClockModelController.h"
#import "ChessClockDataModel.h"

@implementation ChessClockDataViewController


-(id) initWithCoder: encoder {
    if (self = [super initWithCoder:encoder]) {
        _mDelegate = [[MoveTextFieldDelegate  alloc] init];
        _tDelegate = [[MoveTextFieldDelegate  alloc] init];
        _mDelegate.controller = self;
        _tDelegate.controller = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_gameButton addTarget:self action:@selector(showClock:)
            forControlEvents:(UIControlEventTouchUpInside)];
    [_timeIntervalStepper addTarget:self action:@selector(alterTimeIntervals) forControlEvents:(UIControlEventValueChanged)];
    _timeIntervalStepper.value = [_model intervals].count;

    CGRect rect = self.parentViewController.view.frame;
    self.view.frame = rect;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) shouldAutorotate {
    return NO;
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return TRUE;
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return FALSE;
}


- (UIResponder *) nextResponder {
    UIResponder *r = [super nextResponder];
    return r;
}

- (NSString *) tableView:(UITableView *) tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0 ) {
        return @"Time Intervals";
    }
    return @"Increment";
}

- (NSInteger)tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return  [[_model intervals] count];
    } else {
        return 1;
    }
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL rc = [self updateIntervalIndex];
    if (indexPath.section == 1) {
        //switch views
        if (rc) {
            ChessClockRootViewController *ctrl = (ChessClockRootViewController *) self.parentViewController;
            IncrementViewController *incrController = (IncrementViewController *)
            [ctrl.modelController viewControllerAtIndex:3 storyboard:ctrl.storyboard];
            [ctrl addChild:incrController withChildToRemove:self];
        }
    } else {
        _intervalIndex = indexPath;
    }
}
-(BOOL) updateIntervalIndex {
    BOOL rc = YES;
    if (_intervalIndex != nil) {
        TimeControlCell *cell = (TimeControlCell *)[_timeControlTable cellForRowAtIndexPath:_intervalIndex];
        TimeControl *tc = (TimeControl *)[[_model intervals] objectAtIndex:_intervalIndex.row];
        if([self textFieldPassesEdit:cell.moves]) {
            [tc setMoveCount:cell.moves.text];
            
        } else {
            rc = NO;
        }
        if ([self textFieldPassesEdit:cell.durationMinutes]) {
            [tc setDurationMinutes:cell.durationMinutes.text];
        } else {
            rc = NO;
        }
        //cell.durationMinutes.enabled = false;
        //cell.moves.enabled = false;
        _intervalIndex = nil;
    }
    return rc;
}
-(BOOL)textFieldPassesEdit:(UITextField *) theTextField {
    BOOL rc = YES;
    NSString * title = @"Invalid Moves";
    NSString * msg = @"The number of moves must be a positive number, except for the last interval where it may be zero";
    if (_intervalIndex != nil) {
        long rowSub = _intervalIndex.row;
        if ([[theTextField restorationIdentifier] isEqual: @"1"]) {
            TimeControlCell *cell = (TimeControlCell *)[_timeControlTable cellForRowAtIndexPath:_intervalIndex];
            TimeControl *tc = (TimeControl *)[[_model intervals] objectAtIndex:rowSub];
            int moves = [cell.moves.text intValue];
            if (moves == 0) {
                if (rowSub +1 < [[_model intervals] count]) {
                    cell.moves.text = [tc getMoveCount];
                    rc = NO;
                } else {
                    cell.moves.text = @"Game";
                }
            } else if (moves < 0) {
                cell.moves.text = [tc getMoveCount];
                rc = NO;
            }
        } else if ([[theTextField restorationIdentifier]  isEqual: @"2"]) {
            TimeControlCell *cell = (TimeControlCell *)[_timeControlTable cellForRowAtIndexPath:_intervalIndex];
            TimeControl *tc = (TimeControl *)[[_model intervals] objectAtIndex:rowSub];
            int dur = [cell.durationMinutes.text intValue];
            if (dur <= 0) {
                long minutes = tc.durationSeconds /60;
                cell.durationMinutes.text = [NSString stringWithFormat:@"%.2ld", minutes ];
                rc =  NO;
                title = @"Invalid Minutes";
                msg = @"The number of minutes in the interval must be a positive number";
            }
        }
    }
    if (!rc) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:msg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    return rc;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 ) {
        TimeControlCell * cell = (TimeControlCell *)[tableView dequeueReusableCellWithIdentifier:@"TimeControl"];
        if (cell == nil) {
            cell = [[TimeControlCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TimeControl"];
        
        }
        //id<UITextFieldDelegate> delegate = cell.moves.delegate;
        long index = indexPath.row;
        TimeControl *tc = (TimeControl *)[[_model intervals] objectAtIndex:index];
        cell.moves.text = [tc getMoveCount];
        cell.durationMinutes.enabled = true;
        cell.moves.delegate = _mDelegate;
        cell.moves.inputView = _mDelegate.getInputView;
        _mDelegate.min = [[_model intervals]count  ] -1 == index ? 0.0 : 1.0;
        cell.durationMinutes.delegate = _tDelegate;
        cell.durationMinutes.inputView = _tDelegate.getInputView;
        cell.moves.enabled = true;
        long minutes = tc.durationSeconds /60;
        cell.durationMinutes.text = [NSString stringWithFormat:@"%.2ld", minutes ];
        return cell;
    } else {
        UITableViewCell * incrementCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"Increment"];
        if (incrementCell == nil) {
            incrementCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Increment"];
            incrementCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //incrementCell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        }
        NSMutableString * delayText = [NSMutableString stringWithCapacity: 50];
        int delay = [[_model delay] delaySeconds];
        if (delay > 0) {
            [delayText appendString: [[_model  delay] name]];
            [delayText appendFormat: @", %.d seconds", delay];
         } else {
             [delayText appendString: @"None"];
         }
        incrementCell.textLabel.text = delayText;
        return incrementCell;
    }
    return nil;
}

- (IBAction)showAdjustmentsView:(id)sender {
    if ([self updateIntervalIndex]) {
        [_model reset];
        ChessClockRootViewController *ctrl = (ChessClockRootViewController *) self.parentViewController;//. parentViewController;
        UIViewController *adjustmentController = [ctrl.modelController viewControllerAtIndex:1 storyboard:ctrl.storyboard];
        [ctrl addChild:adjustmentController withChildToRemove:self];
    }
}

- (IBAction)showClock:(id)sender {
    if ([self updateIntervalIndex]) {;
        [_model reset];
        ChessClockRootViewController *ctrl = (ChessClockRootViewController *) self.parentViewController;//. parentViewController;
        UIViewController *adjustmentController = [ctrl.modelController viewControllerAtIndex:1 storyboard:ctrl.storyboard];
        [ctrl addChild:adjustmentController withChildToRemove:self];
    
        UIViewController *clockController =
        [ctrl.modelController viewControllerAtIndex:2 storyboard:ctrl.storyboard];
    //[ctrl addChild:clockController withChildToRemove:self];
        [adjustmentController presentViewController:clockController animated:YES completion:NULL];
    }
}

-(void)alterTimeIntervals {
    long count = _timeIntervalStepper.value;
    long intervals = [_model intervals].count;
    if (count >  intervals) {
        [self addTimeControlInterval: self];
    } else if (count < intervals) {
        NSIndexPath * index = [_timeControlTable indexPathForSelectedRow];
        if (index != nil && index.section == 0) {
            count = index.row;
        }
        [_model deleteTimeInterval: count];
        NSArray * indexPath = [NSArray arrayWithObjects:
                               
                               [NSIndexPath  indexPathForRow:count inSection:0] ,nil];
        [_timeControlTable deleteRowsAtIndexPaths: indexPath withRowAnimation:UITableViewRowAnimationFade];
        _intervalIndex = nil;
    }
}

- (IBAction)addTimeControlInterval:(id)sender {
    [self updateIntervalIndex];
    NSInteger newRow = [_model intervals].count;
    TimeControl * previousLast = [[_model intervals] objectAtIndex:newRow - 1];
    //If last time interval is 'game' then add the new interval before the last
    //otherwise add at end
    NSString * moves = @"G";
    if ([previousLast moves] == 0) {
        newRow--;
        moves = @"40";
    }
    TimeControl * newInterval =[[TimeControl alloc ]initWith: moves I: @"5"];
    [ _model insertTimeInterval: newInterval atIndex: newRow];
    NSArray * indexPath = [NSArray arrayWithObjects:
         
    [NSIndexPath  indexPathForRow:newRow inSection:0] ,nil];
    [ _timeControlTable insertRowsAtIndexPaths:indexPath withRowAnimation:UITableViewRowAnimationTop];
}
@end
