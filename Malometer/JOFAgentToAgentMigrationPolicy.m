//
//  JOFAgentToAgentMigrationPolicy.m
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 29/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "JOFAgentToAgentMigrationPolicy.h"
#import "Power+Model.h"


@implementation JOFAgentToAgentMigrationPolicy

- (BOOL) createDestinationInstancesForSourceInstance:(NSManagedObject *)srcInstance
                                       entityMapping:(NSEntityMapping *)mapping
                                             manager:(NSMigrationManager *)manager
                                               error:(NSError *__autoreleasing *)error {
    NSManagedObject *dstInstance = [NSEntityDescription insertNewObjectForEntityForName:mapping.destinationEntityName
                                                                 inManagedObjectContext:manager.destinationContext];
    [self transferAttributesFromInstance:srcInstance toInstance:dstInstance];
    [self extractPowerInstanceWithName:[srcInstance valueForKey:@"power"]
                   relatedWithInstance:dstInstance];
    [manager associateSourceInstance:srcInstance
             withDestinationInstance:dstInstance forEntityMapping:mapping];
    

    return YES;
}


- (void) transferAttributesFromInstance:(NSManagedObject *)srcInstance
                             toInstance:(NSManagedObject *)dstInstance {
    NSArray *dstAttributeKeys = [dstInstance.entity.attributesByName allKeys];
    for (NSString *key in dstAttributeKeys) {
        id value = [srcInstance valueForKey:key];
        
        if (value && ![value isEqual:[NSNull null]]) {
            [dstInstance setValue:value forKey:key];
        }
    }
}


- (void) extractPowerInstanceWithName:(NSString *)name relatedWithInstance:(NSManagedObject *)dstInstance {
    if (name) {
        Power *power = [Power fetchPowerInMOC:dstInstance.managedObjectContext withName:name];
        if (!power) {
            power = [NSEntityDescription insertNewObjectForEntityForName:powerEntityName
                                                  inManagedObjectContext:dstInstance.managedObjectContext];
            power.name = name;
        }
        [power addAgentsObject:(Agent *)dstInstance];
    }
}

@end
