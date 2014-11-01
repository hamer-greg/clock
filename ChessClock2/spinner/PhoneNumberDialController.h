//
//  NumberDialViewController.h
//  
//
//  Created by ghamer on 3/16/14.
//
//

#import <UIKit/UIKit.h>
#import "NumberTextFieldDelegate.h"

@interface PhoneNumberDialController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic, weak) IBOutlet UITextField *txtFld;
@property NumberTextFieldDelegate * numberDelegate;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
- (IBAction)keyReleased:(id)sender;
@end
