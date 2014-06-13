//
//  JOFImageMapper.h
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 12/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface JOFImageMapper : NSObject

- (void) storeImage:(UIImage *)image withUUID:(NSString *)uuid;
- (void) deleteImageWithUUID:(NSString *)uuid;
- (UIImage *) retrieveImageWithUUID:(NSString *)uuid;

@end
