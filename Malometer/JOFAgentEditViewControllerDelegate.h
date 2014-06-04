//
//  JOFAgentEditViewControllerDelegate.h
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 02/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <Foundation/Foundation.h>

@class JOFAgentEditViewController;


@protocol JOFAgentEditViewControllerDelegate <NSObject>

- (void) dismissAgentEditViewController:(JOFAgentEditViewController *)agentEditVC
                           modifiedData:(BOOL)modifiedData;

@end
