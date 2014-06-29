//
//  Agent.h
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 29/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Domain, FreakType, Power;

@interface Agent : NSManagedObject

@property (nonatomic, retain) NSNumber * assessment;
@property (nonatomic, retain) NSNumber * destructionPower;
@property (nonatomic, retain) NSNumber * motivation;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pictureUUID;
@property (nonatomic, retain) FreakType *category;
@property (nonatomic, retain) NSSet *domains;
@property (nonatomic, retain) NSSet *powers;
@end

@interface Agent (CoreDataGeneratedAccessors)

- (void)addDomainsObject:(Domain *)value;
- (void)removeDomainsObject:(Domain *)value;
- (void)addDomains:(NSSet *)values;
- (void)removeDomains:(NSSet *)values;

- (void)addPowersObject:(Power *)value;
- (void)removePowersObject:(Power *)value;
- (void)addPowers:(NSSet *)values;
- (void)removePowers:(NSSet *)values;

@end
