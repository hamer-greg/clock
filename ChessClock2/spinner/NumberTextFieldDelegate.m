//
//  NumberTextFieldDelegate.m
//  SimpleGestureRecognizers
//
//  Created by ghamer on 3/29/14.
//
//

#import "NumberTextFieldDelegate.h"
#import "NumbrDialViewController.h"

@implementation NumberTextFieldDelegate
static NumbrDialViewController * keyboard;
- (NumberTextFieldDelegate *) initWithMin: (CGFloat) min max: (CGFloat) max revolutionIncrement: (CGFloat) revolution format: (NSString *) formatString {
    self.format = formatString;
    self.min = min;
    self.max = max;
    self.revolution = revolution;
    //self.textField = fld;
    //fld.inputView = self.getInputView;
    //fld.delegate = self;
    return self;
    
}

- (UIView *) getInputView {
    if (keyboard == nil) {
        keyboard = [[NumbrDialViewController alloc]  initWithNibName:@"NumbrDialViewController" bundle:nil];
    }
    CGRect rect =keyboard.view.frame;
    //CGSize size = rect.size;
    //size.height = 230;
    //rect.size = size;
    
    keyboard.view.frame = rect;
    return keyboard.view;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    keyboard.numberDelegate = self;
    self.textField = textField;
    float num = [textField.text floatValue];
    float relRotation = num - self.min;
    int rotations = 0;
    while (relRotation > self.revolution) {
        rotations++;
        relRotation -= self.revolution;
    }
    relRotation = (relRotation * M_PI * 2.0)/self.revolution;
    CGAffineTransform transform = CGAffineTransformMakeRotation(relRotation );
    keyboard.imageView.transform = transform;

}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    keyboard.numberDelegate = nil;
}
- (CGFloat) getClippedValue:(CGFloat) value {
    CGFloat val = value * self.revolution /(M_PI *2) +self.min;
    if (val < self.min) {
        val = self.min;
    }
    if (val > self.max) {
        val = self.max;
    }
    return (val - self.min)* (M_PI * 2) / self.revolution;
}
- (CGFloat) setTextFromValue:(CGFloat) value {
    CGFloat clippedVal = [self getClippedValue:value];
    CGFloat val = clippedVal * self.revolution /(M_PI *2) +self.min;
    
    NSString * fmt = [self format];
    NSString * textt = [NSString stringWithFormat:fmt,val];
    
    self.textField.text = textt;
    return clippedVal;
}
@end