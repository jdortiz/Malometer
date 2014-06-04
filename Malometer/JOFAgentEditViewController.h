//
//  JOFDetailViewController.h
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 02/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JOFAgentEditViewControllerDelegate.h"

@interface JOFAgentEditViewController : UIViewController

@property (strong, nonatomic) id agent;
@property (weak, nonatomic) id<JOFAgentEditViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *assessmentLabel;
@property (weak, nonatomic) IBOutlet UIStepper *destroyPowerStepper;
@property (weak, nonatomic) IBOutlet UILabel *destroyPowerLabel;
@property (weak, nonatomic) IBOutlet UIStepper *motivationStepper;
@property (weak, nonatomic) IBOutlet UILabel *motivationLabel;

@end
