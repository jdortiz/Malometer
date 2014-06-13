//
//  JOFDetailViewController.h
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 02/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOFAgentEditViewControllerDelegate.h"

@class Agent;
@class JOFImageMapper;


@interface JOFAgentEditViewController : UIViewController <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) Agent *agent;
@property (weak, nonatomic) id<JOFAgentEditViewControllerDelegate> delegate;
@property (strong, nonatomic) JOFImageMapper *imageMapper;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *assessmentLabel;
@property (weak, nonatomic) IBOutlet UIStepper *destroyPowerStepper;
@property (weak, nonatomic) IBOutlet UILabel *destroyPowerLabel;
@property (weak, nonatomic) IBOutlet UIStepper *motivationStepper;
@property (weak, nonatomic) IBOutlet UILabel *motivationLabel;

@end
