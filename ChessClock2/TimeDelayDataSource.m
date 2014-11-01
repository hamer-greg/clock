//
//  TimeDelayDataSource.m
//  ChessClock2
//
//  Created by ghamer on 7/6/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import "TimeDelayDataSource.h"
#import "TimeDelay.h"


@implementation TimeDelayDataSource
- (id)init
{
    self = [super init];
    if (self) {
        _timeDelays = [NSArray arrayWithObjects:
                       [[TimeDelay alloc ]initWith: Simple],
                       [[TimeDelay alloc ]initWith: Fischer],
                       [[TimeDelay alloc ]initWith: FischerAfter],
                       [[TimeDelay alloc ]initWith: Bronstein],
                       nil];
    }
    return self;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _model.delay = _timeDelays[row];
    if (_hintText != nil) {
        _hintText.text = _model.delay.hint;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 200;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[_timeDelays  objectAtIndex:row] name];
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
        return 4;
 
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

@end
