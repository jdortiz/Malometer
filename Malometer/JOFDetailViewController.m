//
//  JOFDetailViewController.m
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 02/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "JOFDetailViewController.h"

@interface JOFDetailViewController ()
- (void)configureView;
@end

@implementation JOFDetailViewController

NSArray *assessmentValues;
NSArray *destroyPowerValues;
NSArray *motivationValues;

#pragma mark - Managing the detail item

- (void)setAgent:(id)newDetailItem
{
    if (_agent != newDetailItem) {
        _agent = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void) configureView {
    [self initializeAssesmentView];
    [self initializeDestroyPowerViews];
}


- (void) initializeAssesmentView {
    assessmentValues = @[@"No way", @"Better not", @"Maybe", @"Yes", @"A must"];
    self.assessmentLabel.text = [assessmentValues objectAtIndex:0];
}


- (void) initializeDestroyPowerViews {
    destroyPowerValues = @[@"Soft", @"Weak", @"Potential", @"Destroyer", @"Nuke"];
    self.destroyPowerLabel.text = [destroyPowerValues objectAtIndex:0];
}


- (void) initializeMotivationViews {
    motivationValues = @[@"Doesn't care", @"Would like to", @"Quite focused", @"Interested", @"Goal"];
    self.motivationLabel.text = [motivationValues objectAtIndex:0];
}


#pragma mark - UI actions

- (IBAction) cancel:(id)sender {
    [self.delegate dismissAgentEditViewController:self modifiedData:NO];
}


- (IBAction) save:(id)sender {
    [self.delegate dismissAgentEditViewController:self modifiedData:YES];
}

@end
