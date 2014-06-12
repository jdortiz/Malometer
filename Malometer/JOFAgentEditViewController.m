//
//  JOFDetailViewController.m
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 02/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "JOFAgentEditViewController.h"
#import "Agent.h"


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
    [self configureView];
}


- (void) configureView {
    [self displayAgentName];
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
    [self initializeDestroyPowerStepper];
    [self displayDestroyPowerLabel];
}


- (void) initializeDestroyPowerStepper {
    self.destroyPowerStepper.value = [self.agent.destructionPower doubleValue];
}


- (void) initializeMotivationViews {
    motivationValues = @[@"Doesn't care", @"Would like to", @"Quite focused", @"Interested", @"Goal"];
    [self initializeMotivationStepper];
    [self displayMotivationLabel];
}


- (void) initializeMotivationStepper {
    self.motivationStepper.value = [self.agent.motivation doubleValue];
}


#pragma mark - Things to do while the view controller is shown

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self addObserverForProperties];
}


- (void) addObserverForProperties {
    [self addObserver:self forKeyPath:@"agent.destructionPower"
              options:0 context:NULL];
    [self addObserver:self forKeyPath:@"agent.motivation"
              options:0 context:NULL];
    [self addObserver:self forKeyPath:@"agent.assessment"
              options:0 context:NULL];
}


- (void) viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self removeObserverForProperties];
}


- (void) removeObserverForProperties {
    [self removeObserver:self forKeyPath:@"agent.destructionPower"];
    [self removeObserver:self forKeyPath:@"agent.motivation"];
    [self removeObserver:self forKeyPath:@"agent.assessment"];
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
    self.agent.name = self.nameTextField.text;
}


- (IBAction) changeDestroyPower:(id)sender {
    NSUInteger newDestroyPower = (NSUInteger)(self.destroyPowerStepper.value + 0.5);
    self.agent.destructionPower = @(newDestroyPower);
}


- (IBAction) changeMotivation:(id)sender {
    NSUInteger newMotivation = (NSUInteger)(self.motivationStepper.value + 0.5);
    self.agent.motivation = @(newMotivation);
}


#pragma mark - Observations

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                         change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"agent.destructionPower"]){
        [self displayDestroyPowerLabel];
    } else if ([keyPath isEqualToString:@"agent.motivation"]){
        [self displayMotivationLabel];
    } else if ([keyPath isEqualToString:@"agent.assessment"]){
        [self displayAssessmentLabel];
    }

}


#pragma mark - Presentation

- (void) displayAgentName {
    self.nameTextField.text = self.agent.name;
}


- (void) displayDestroyPowerLabel {
    NSUInteger destroyPower = [self.agent.destructionPower unsignedIntegerValue];
    self.destroyPowerLabel.text = [destroyPowerValues objectAtIndex:destroyPower];
}


- (void) displayMotivationLabel {
    NSUInteger motivation = [self.agent.motivation unsignedIntegerValue];
    self.motivationLabel.text = [motivationValues objectAtIndex:motivation];
}


- (void) displayAssessmentLabel {
    self.assessmentLabel.text = [assessmentValues objectAtIndex:[self.agent.assessment unsignedIntegerValue]];
}


#pragma mark - Text Field Delegate Methods

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    BOOL shouldReturn = YES;
    if (textField == self.nameTextField) {
        [textField resignFirstResponder];
        shouldReturn = NO;
    }
    
    return shouldReturn;
}
@end
