//
//  Agent+Model.h
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 08/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent.h"

extern NSString *const agentEntityName;
// Strings of the attributes/properties
extern NSString *const agentPropertyName;
extern NSString *const agentPropertyDestructionPower;
extern NSString *const agentPropertyMotivation;
extern NSString *const agentPropertyAssessment;
extern NSString *const agentPropertyPictureUUID;

@interface Agent (Model)

+ (NSFetchRequest *) fetchAllAgentsByName;
+ (NSFetchRequest *) fetchAllAgentsWithSortDescriptors:(NSArray *)sortDescriptors;
+ (NSFetchRequest *) fetchAllAgentsByNameWithPredicate:(NSPredicate *)predicate;
- (NSString *) generatePictureUUID;

@end
