//
//  Agent+Model.h
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 08/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent.h"

// Strings of the attributes/properties
extern NSString *const agentPropertyDestructionPower;
extern NSString *const agentPropertyMotivation;
extern NSString *const agentPropertyAssessment;
extern NSString *const agentPropertyPictureUUID;

@interface Agent (Model)

- (NSString *) generatePictureUUID;

@end
