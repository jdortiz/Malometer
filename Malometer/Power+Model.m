//
//  Power+Model.m
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 29/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Power+Model.h"

NSString *const powerEntityName = @"Power";
NSString *const powerPropertyName = @"name";


@implementation Power (Model)

+ (Power *) fetchPowerInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:powerEntityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", powerPropertyName, name];
    NSError *error;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];

    return [results firstObject];
}

@end
