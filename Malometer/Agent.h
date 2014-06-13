//
//  Agent.h
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 12/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Agent : NSManagedObject

@property (nonatomic, retain) NSNumber * assessment;
@property (nonatomic, retain) NSNumber * destructionPower;
@property (nonatomic, retain) NSNumber * motivation;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pictureUUID;

@end
