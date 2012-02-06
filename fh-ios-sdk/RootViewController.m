//
//  RootViewController.m
//  fh-ios-sdk
//
//  Created by Craig Brookes on 31/01/2012.
//  Copyright (c) 2012 Feedhenry. All rights reserved.
//

#import "RootViewController.h"
#import "LoginController.h"
#import "EventsViewController.h"
#import "PersistView.h"
@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.tabBarItem.tag == 100) {
        LoginController * viewController = [[LoginController alloc]init];
        [self pushViewController:viewController animated:NO];
        [viewController release];
    }else if(self.tabBarItem.tag == 101){
        EventsViewController * eventsController = [[EventsViewController alloc]init];
        [self pushViewController:eventsController animated:NO];
        [eventsController release];
    }else if(self.tabBarItem.tag == 102){
        PersistView * persist = [[PersistView alloc]initWithNibName:nil bundle:nil];
        [self pushViewController:persist animated:NO];
        [persist release];
    }
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end