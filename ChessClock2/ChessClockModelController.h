//
//  ChessClockModelController.h
//  ChessClock2
//
//  Created by ghamer on 1/27/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessClockDataModel.h"

@class ChessClockDataViewController;
@interface ChessClockModelController : NSObject <UIPageViewControllerDataSource, UIGestureRecognizerDelegate>
@property (readonly, strong, nonatomic) ChessClockDataModel *model;
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(UIViewController *)viewController;
@end
