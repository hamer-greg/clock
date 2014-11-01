//
//  ChessClockModelController.m
//  ChessClock2
//
//  Created by ghamer on 1/27/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import "ChessClockModelController.h"

#import "ChessClockDataViewController.h"
#import "TimeRemainingViewController.h"
#import "ClockViewController.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


@implementation ChessClockModelController

- (id)init
{
    self = [super init];
    if (self) {
        // Create the data model.
        _model = [[ChessClockDataModel alloc] init];
    }
    return self;
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard
{   
    if (index == 0) {
        // Create a new view controller and pass suitable data.
        ChessClockDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"ChessClockDataViewController"];
        dataViewController.model = _model;
        return dataViewController;
    } else if (index == 1) {
        TimeRemainingViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"TimeRemainingViewController"];
        viewController.model = _model;
        return viewController;
    }  else if (index == 2) {
        ClockViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"ClockViewController"];
        //viewController.wantsFullScreenLayout = YES;
        viewController.model = _model;
        return viewController;
    }  else if (index == 3) {
        IncrementViewController * viewController = [storyboard instantiateViewControllerWithIdentifier:@"IncrementViewController"];
        //viewController.wantsFullScreenLayout = YES;
        viewController.model = _model;
        return viewController;
    }
    return nil;
}

- (NSUInteger)indexOfViewController:(ChessClockDataViewController *)viewController
{   
     // Return the index of the given data view controller.
     // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
    return 0;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(UIViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = 0;
    index++;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
