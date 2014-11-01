//
//  ChessClockRootViewController.h
//  ChessClock2
//
//  Created by ghamer on 1/27/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessClockDataModel.h"
@class ChessClockModelController;
@interface ChessClockRootViewController : UIViewController <UIPageViewControllerDelegate>
@property (strong, nonatomic) UIViewController *viewController;
@property (strong, nonatomic) UIPageViewController *pageViewController;
@property ( readonly, strong, nonatomic) ChessClockModelController *modelController;
-(void) addChild:(UIViewController *) childToAdd withChildToRemove:(UIViewController *) childToRemove;
@end
