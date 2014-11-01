//
//  NumberTextFieldDelegate.h
//  SimpleGestureRecognizers
//
//  Created by ghamer on 3/29/14.
//
//

#import <UIKit/UIKit.h>

@interface NumberTextFieldDelegate : NSObject <UITextFieldDelegate>
-(UIView *) getInputView;
@property UITextField * textField;
@property NSString * format;
@property CGFloat min;
@property CGFloat max;
@property CGFloat revolution;
@property CGFloat baseAngle;
@property CGFloat prevAngle;
@property CGFloat rotation;
@property CGFloat relRotation;
@property UILabel * statusLabel;

- (CGFloat) setTextFromValue: (CGFloat) value;
- (CGFloat) getClippedValue: (CGFloat) value;
/**
 * min: the minimum allowable number
 * max: the maximum allowable number
 * revolutionIncrement: the amount to increment per one complete revolution of the dial
 */
- (NumberTextFieldDelegate *) initWithMin: (CGFloat) min max: (CGFloat) max revolutionIncrement: (CGFloat) range format: (NSString *) formatString;
@end
