//
//  Agent+Model.m
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 08/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent+Model.h"

NSString *const agentEntityName = @"Agent";
// Strings of the attributes/properties
NSString *const agentPropertyName = @"name";
NSString *const agentPropertyDestructionPower = @"destructionPower";
NSString *const agentPropertyMotivation = @"motivation";
NSString *const agentPropertyAssessment = @"assessment";
NSString *const agentPropertyPictureUUID = @"pictureUUID";



@implementation Agent (Model)

#pragma mark - Model logic

- (NSNumber *) assessment {
    NSNumber *assessmentValue;
    if ([self primitiveValueForKey:agentPropertyAssessment] == nil) {
        [self updateAssessmentValue];
    }
    [self willAccessValueForKey:agentPropertyAssessment];
    assessmentValue = [self primitiveValueForKey:agentPropertyAssessment];
    [self didAccessValueForKey:agentPropertyAssessment];
    return assessmentValue;
}


- (void) setDestructionPower:(NSNumber *)destructionPower {
    [self willChangeValueForKey:agentPropertyDestructionPower];
    [self setPrimitiveValue:destructionPower forKey:agentPropertyDestructionPower];
    [self didChangeValueForKey:agentPropertyDestructionPower];
    [self updateAssessmentValue];
}


- (void) setMotivation:(NSNumber *)motivation {
    [self willChangeValueForKey:agentPropertyMotivation];
    [self setPrimitiveValue:motivation forKey:agentPropertyMotivation];
    [self didChangeValueForKey:agentPropertyMotivation];
    [self updateAssessmentValue];
}


- (void) updateAssessmentValue {
    [self willChangeValueForKey:agentPropertyAssessment];
    NSUInteger destroyPower = [self.destructionPower unsignedIntegerValue];
    NSUInteger motivation = [self.motivation unsignedIntegerValue];
    NSUInteger assessment = (destroyPower + motivation) / 2;
    [self setPrimitiveValue:@(assessment) forKey:agentPropertyAssessment];
    [self didChangeValueForKey:agentPropertyAssessment];
    
}

#pragma mark - Picture logic

- (NSString *) generatePictureUUID {
    CFUUIDRef     fileUUID;
    CFStringRef   fileUUIDString;
    fileUUID = CFUUIDCreate(kCFAllocatorDefault);
    fileUUIDString = CFUUIDCreateString(kCFAllocatorDefault, fileUUID);
    CFRelease(fileUUID);
    return (__bridge_transfer NSString *)fileUUIDString;
}


#pragma mark - Fetch requests

+ (NSFetchRequest *) fetchAllAgentsByName {
    NSSortDescriptor *nameSortDescriptor = [[NSSortDescriptor alloc] initWithKey:agentPropertyName
                                                                       ascending:YES];
    NSFetchRequest *fetchRequest = [Agent fetchAllAgentsWithSortDescriptors:@[nameSortDescriptor]];

    return fetchRequest;
}


+ (NSFetchRequest *) fetchAllAgentsWithSortDescriptors:(NSArray *)sortDescriptors {
    NSFetchRequest *fetchRequest = [Agent baseFetchRequest];
    fetchRequest.sortDescriptors = sortDescriptors;
    
    return fetchRequest;
}


+ (NSFetchRequest *) fetchAllAgentsByNameWithPredicate:(NSPredicate *)predicate {
    NSFetchRequest *fetchRequest = [Agent fetchAllAgentsByName];
    fetchRequest.predicate = predicate;

    return fetchRequest;
}


+ (NSFetchRequest *) baseFetchRequest {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:agentEntityName];
    fetchRequest.fetchBatchSize = 20;

    return fetchRequest;
}

@end
