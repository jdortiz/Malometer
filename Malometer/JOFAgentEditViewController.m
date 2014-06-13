//
//  JOFDetailViewController.m
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 02/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "JOFAgentEditViewController.h"
#import "Agent+Model.h"
#import "UIImage+AgentAdjust.h"
#import "JOFImageMapper.h"

typedef NS_ENUM(NSInteger, actionSheetButtons) {
    actionSheetTakePicture = 0, // actionSheet.firstOtherButtonIndex
    actionSheetLibrary,
    actionSheetEditPicture
};

typedef NS_ENUM(NSInteger, ImageStatus) {
    ImageStatusDoNothing = 0,
    ImageStatusPreserveNew,
    ImageStatusDelete
};


@interface JOFAgentEditViewController () {
    ImageStatus imageStatus;
}

@property (strong, nonatomic) UIImage *agentPicture;

@end



@implementation JOFAgentEditViewController

NSArray *assessmentValues;
NSArray *destroyPowerValues;
NSArray *motivationValues;

#pragma mark - Constants & Parameters

static const CGFloat pictureSide = 200.0;

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
    [self initializePictureView];
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


- (void) initializePictureView {
    [self loadAgentPicture];
    [self displayAgentPicture];
}


- (void)loadAgentPicture {
    if (self.agent.pictureUUID) {
        self.agentPicture = [self.imageMapper retrieveImageWithUUID:self.agent.pictureUUID];
    }
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

- (IBAction) editImage:(id)sender {
    [self offerImageActions];
}


- (void) offerImageActions {
    NSString *deleteButtonTitle = nil;
    if ((imageStatus == ImageStatusPreserveNew) || (self.agent.pictureUUID != nil)) {
        deleteButtonTitle = @"Delete Image";
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"Cancel"
                                  destructiveButtonTitle:deleteButtonTitle
                                  otherButtonTitles:@"Take Photo", @"Choose From Library", nil];
    [actionSheet showInView:self.navigationController.view];
}


- (IBAction) cancel:(id)sender {
    [self.delegate dismissAgentEditViewController:self modifiedData:NO];
}


- (IBAction) save:(id)sender {
    [self assignDataToAgent];
    [self persistImageChanges];
    [self.delegate dismissAgentEditViewController:self modifiedData:YES];
}


- (void) assignDataToAgent {
    self.agent.name = self.nameTextField.text;
}


- (void) persistImageChanges {
    if (imageStatus == ImageStatusPreserveNew) {
        if (self.agent.pictureUUID == nil) {
            self.agent.pictureUUID = [self.agent generatePictureUUID];
        }
        [self.imageMapper storeImage:self.agentPicture withUUID:self.agent.pictureUUID];
    } else if (imageStatus == ImageStatusDelete) {
        [self.imageMapper deleteImageWithUUID:self.agent.pictureUUID];
        self.agent.pictureUUID = nil;
    }
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


- (void) displayAgentPicture {
    [self.imageButton setImage:self.agentPicture forState:UIControlStateNormal];
}


#pragma mark - Lazy instantiantion for dependency injection

- (JOFImageMapper *) imageMapper {
    if (_imageMapper == nil) {
        _imageMapper = [[JOFImageMapper alloc] init];
    }
    return _imageMapper;
}


#pragma mark - Action Sheet Delegate Methods

- (void) actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        [self deletePicture];
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex) {
        [self obtainPictureFromCamera:YES];
    } else if (buttonIndex == actionSheet.firstOtherButtonIndex + actionSheetLibrary) {
        [self obtainPictureFromCamera:NO];
    }
}


- (void) obtainPictureFromCamera:(BOOL)useCamera {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if (useCamera &&
        [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}


- (void) deletePicture {
    imageStatus = ImageStatusDelete;
    self.agentPicture = nil;
    [self displayAgentPicture];
}


#pragma mark - Image picker view controller delegate

- (void) imagePickerController:(UIImagePickerController *)imagePickerController
 didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.agentPicture = [info[UIImagePickerControllerEditedImage] imageSquaredWithSide:pictureSide];
    // AgentPicture is not observed, because it changes while this controller is hidden.
    [self displayAgentPicture];
    imageStatus = ImageStatusPreserveNew;
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
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
