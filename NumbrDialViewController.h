//
//  NumbrDialViewController.h
//  chessclock2
//
//  Created by Greg Hamer on 8/12/14.
//  Copyright (c) 2014 ghamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NumberTextFieldDelegate.h"

@interface NumbrDialViewController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet UITextField *txtFld;
@property NumberTextFieldDelegate * numberDelegate;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
- (IBAction)keyReleased:(id)sender;


@end
