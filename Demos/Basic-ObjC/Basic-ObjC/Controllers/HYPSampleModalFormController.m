//
//  HYPSampleModalFormController.m
//  Basic-ObjC
//
//  Created by Martin Oppetit on 17/04/2015.
//  Copyright (c) 2015 Hyper. All rights reserved.
//

#import "HYPSampleModalFormController.h"

@interface HYPSampleModalFormController ()

@end

@implementation HYPSampleModalFormController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureNavigationTitle];
}

- (void)configureNavigationTitle
{
    self.navigationItem.title = @"MODAL FORM";
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self hideModalFormButton];
    [self configureCloseButton];
}

- (void)hideModalFormButton
{
    self.navigationItem.rightBarButtonItem = nil;
}

- (void)configureCloseButton
{
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(closeButtonTapped:)];
    self.navigationItem.leftBarButtonItem = closeButtonItem;
}

- (void)closeButtonTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
