//
//  TimeDelayDataSource.h
//  ChessClock2
//
//  Created by ghamer on 7/6/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessClockDataModel.h"

@interface TimeDelayDataSource : NSObject   <UIPickerViewDataSource, UIPickerViewDelegate>
@property (readonly, strong, nonatomic) NSArray *timeDelays;
@property (strong, nonatomic) ChessClockDataModel * model;
@property (strong, nonatomic) UILabel * hintText;
@end
