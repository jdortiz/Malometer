//
//  Agent.m
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 07/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "Agent.h"


@implementation Agent

@dynamic destructionPower;
@dynamic motivation;
@dynamic name;
@dynamic assessment;

#pragma mark - Model logic

+ (NSSet *) keyPathsForValuesAffectingAssessment {
    return [NSSet setWithArray:@[@"destructionPower", @"motivation"]];
}


- (NSNumber *) assessment {
    [self willChangeValueForKey:@"assessment"];
    NSUInteger destroyPower = [self.destructionPower unsignedIntegerValue];
    NSUInteger motivation = [self.motivation unsignedIntegerValue];
    NSUInteger assessment = (destroyPower + motivation) / 2;
    return @(assessment);
    [self didChangeValueForKey:@"assessment"];
}

@end
