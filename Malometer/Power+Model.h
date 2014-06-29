//
//  Power+Model.h
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 29/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import "Power.h"

extern NSString *const powerEntityName;


@interface Power (Model)

+ (Power *) fetchPowerInMOC:(NSManagedObjectContext *)moc withName:(NSString *)name;

@end
