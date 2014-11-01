//
//  TimeControlCell.h
//  ChessClock2
//
//  Created by ghamer on 7/7/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MoveTextFieldDelegate.h"
@class MoveTextFieldDelegate;
@interface TimeControlCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UITextField *moves;
@property (nonatomic, weak) IBOutlet UITextField *durationMinutes;
//@property  (nonatomic, weak)IBOutlet MoveTextFieldDelegate *mDelegate;
//@property  (nonatomic, weak) IBOutlet MoveTextFieldDelegate *tDelegate;

@end
