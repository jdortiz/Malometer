//
//  Domain+Model.h
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 16/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Domain.h"


@interface Domain (Model)

+ (instancetype) domainInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;
+ (Domain *) fetchInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;
+ (NSFetchRequest *) fetchRequestControlledDomains;

@end
