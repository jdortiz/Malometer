//
//  JOFDetailViewController.m
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 02/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "JOFAgentEditViewController.h"

@interface JOFAgentEditViewController ()
- (void)configureView;
@end

@implementation JOFAgentEditViewController

NSArray *assessmentValues;
NSArray *destroyPowerValues;
NSArray *motivationValues;

#pragma mark - Initialization of the views

- (void) viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void) configureView {
    [self initializeAssesmentView];
    [self initializeDestroyPowerViews];
    [self initializeMotivationViews];
}


- (void) initializeAssesmentView {
    assessmentValues = @[@"No way", @"Better not", @"Maybe", @"Yes", @"A must"];
    [self displayAssessmentLabel];
}


- (void) initializeDestroyPowerViews {
    destroyPowerValues = @[@"Soft", @"Weak", @"Potential", @"Destroyer", @"Nuke"];
    [self displayDestroyPowerLabel];
}


- (void) initializeMotivationViews {
    motivationValues = @[@"Doesn't care", @"Would like to", @"Quite focused", @"Interested", @"Goal"];
    [self displayMotivationLabel];
}


#pragma mark - UI actions

- (IBAction) cancel:(id)sender {
    [self.delegate dismissAgentEditViewController:self modifiedData:NO];
}


- (IBAction) save:(id)sender {
    [self assignDataToAgent];
    [self.delegate dismissAgentEditViewController:self modifiedData:YES];
}


- (void) assignDataToAgent {
    [self.agent setValue:self.nameTextField.text forKey:@"name"];
}


- (IBAction) changeDestroyPower:(id)sender {
    [self updateDestroyPowerValue];
    [self updateDestroyPowerViews];
}


- (IBAction) changeMotivation:(id)sender {
    [self updateMotivationValue];
    [self updateMotivationViews];
}


- (void) updateDestroyPowerValue {
    NSUInteger newDestroyPower = (NSUInteger)(self.destroyPowerStepper.value + 0.5);
    [self.agent setValue:@(newDestroyPower)
                  forKey:@"destructionPower"];
}


- (void) updateMotivationValue {
    NSUInteger newMotivation = (NSUInteger)(self.motivationStepper.value + 0.5);
    [self.agent setValue:@(newMotivation)
                  forKey:@"motivation"];
}


- (void) updateDestroyPowerViews {
    [self displayDestroyPowerLabel];
    [self displayAssessmentLabel];
}


- (void) updateMotivationViews {
    [self displayMotivationLabel];
    [self displayAssessmentLabel];
}


#pragma mark - Presentation

- (void) displayDestroyPowerLabel {
    NSUInteger destroyPower = [[self.agent valueForKey:@"destructionPower"] unsignedIntegerValue];
    self.destroyPowerLabel.text = [destroyPowerValues objectAtIndex:destroyPower];
}


- (void) displayMotivationLabel {
    NSUInteger motivation = [[self.agent valueForKey:@"motivation"] unsignedIntegerValue];
    self.motivationLabel.text = [motivationValues objectAtIndex:motivation];
}


- (void) displayAssessmentLabel {
    NSUInteger destroyPower = [[self.agent valueForKey:@"destructionPower"] unsignedIntegerValue];
    NSUInteger motivation = [[self.agent valueForKey:@"motivation"] unsignedIntegerValue];
    NSUInteger assessment = (destroyPower + motivation) / 2;
    self.assessmentLabel.text = [assessmentValues objectAtIndex:assessment];
}

@end
