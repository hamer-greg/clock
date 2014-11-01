//
//  ChessClockRootViewController.m
//  ChessClock2
//
//  Created by ghamer on 1/27/13.
//  Copyright (c) 2013 ghamer. All rights reserved.
//

#import "ChessClockRootViewController.h"
#import "ChessClockModelController.h"
#import "ChessClockDataViewController.h"


@implementation ChessClockRootViewController
@synthesize modelController = _modelController;

- (void)viewDidLoadd
{
    [super viewDidLoad];
    //[[UIDevice currentDevice] beginDe]
	// Do any additional setup after loading the view, typically from a nib.
    // Configure the page view controller and add it as a child view controller.
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;

    ChessClockDataViewController *startingViewController = (ChessClockDataViewController *)
    [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];

    self.pageViewController.dataSource = self.modelController;

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
    CGRect pageViewRect = self.view.bounds;
    self.pageViewController.view.frame = pageViewRect;

    [self.pageViewController didMoveToParentViewController:self];

    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily.
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CGRect pageViewRect = self.view.frame;
    ChessClockDataViewController *startingViewController = (ChessClockDataViewController *)
        [self.modelController viewControllerAtIndex:0 storyboard:self.storyboard];
    [self addChild: startingViewController withChildToRemove:nil];
    
    self.view.frame = pageViewRect;
}

-(void) addChild:(UIViewController *) childToAdd withChildToRemove:(UIViewController *) childToRemove{
    if (_viewController )
        _viewController = childToAdd;
    if (childToRemove != nil) {
        [childToRemove.view removeFromSuperview];
    }
    [self addChildViewController:childToAdd];
    [self.view addSubview:childToAdd.view];
    [childToAdd didMoveToParentViewController:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (ChessClockModelController *)modelController
{
    // Return the model controller object, creating it if necessary.
    // In more complex implementations, the model controller may be passed to the view controller.
    if (!_modelController) {
        _modelController = [[ChessClockModelController alloc] init];
    }
    return _modelController;
}

- (BOOL) shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    NSInteger rc = UIInterfaceOrientationMaskPortrait; //[super supportedInterfaceOrientations];
    long rcInt = rc;
    if (_viewController != nil) {
        rc = [_viewController supportedInterfaceOrientations];
    }
    return rc;
}

#pragma mark - UIPageViewController delegate methods
- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController *)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    // Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to YES, so set it to NO here.
    UIViewController *currentViewController = self.pageViewController.viewControllers[0];
    NSArray *viewControllers = @[currentViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:NULL];

    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
}

@end
