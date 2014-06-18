//
//  FreakType+Model.m
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 16/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "FreakType+Model.h"

NSString *const freakTypeEntityName = @"FreakType";
NSString *const freakTypePropertyName = @"name";


@implementation FreakType (Model)

+ (instancetype) freakTypeInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    FreakType *freakType = [NSEntityDescription insertNewObjectForEntityForName:freakTypeEntityName
                                                         inManagedObjectContext:moc];
    freakType.name = name;
    return freakType;
}


+ (FreakType *) fetchInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:freakTypeEntityName];
    fetchRequest.predicate = [NSPredicate predicateWithFormat:@"%K == %@", freakTypePropertyName, name];
    
    NSError *error;
    NSArray *results = [moc executeFetchRequest:fetchRequest error:&error];

    return [results lastObject];
}

@end
