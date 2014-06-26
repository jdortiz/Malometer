//
//  JOFAppDelegateTests.m
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 26/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//


#import <XCTest/XCTest.h>
//#import <OCMock/OCMock.h>
#import "JOFAppDelegate.h"


@interface MocFake : NSManagedObjectContext

@property (assign) BOOL saveWasCalled;

@end

@implementation MocFake

- (BOOL) hasChanges {
    return YES;
}

- (BOOL) save:(NSError *__autoreleasing *)error {
    self.saveWasCalled = YES;
    return YES;
}

@end


@interface JOFAppDelegateTests : XCTestCase {
    // Object to test.
    JOFAppDelegate *sut;
}

@end


@implementation JOFAppDelegateTests

#pragma mark - Set up and tear down

- (void) setUp {
    [super setUp];

    [self createSut];
}


- (void) createSut {
    sut = [[JOFAppDelegate alloc] init];
}


- (void) tearDown {
    [self releaseSut];

    [super tearDown];
}


- (void) releaseSut {
    sut = nil;
}


#pragma mark - Basic test

- (void) testObjectIsNotNil {
    // Prepare

    // Operate

    // Check
    XCTAssertNotNil(sut, @"The object to test must be created in setUp.");
}


#pragma mark - Core Data stack

- (void) testManagedObjectContextIsCreatedInAccessor {
    // Operate
    NSManagedObjectContext *moc = [sut managedObjectContext];

    // Check
    XCTAssertNotNil(moc, @"Managed object context must be created in accessor.");
}


- (void) testSaveContextTellsMocToSave {
    // Prepare
    MocFake *mocFake = [[MocFake alloc] init];
    [sut setValue:mocFake forKeyPath:@"managedObjectContext"];

    // Operate
    [sut saveContext];

    XCTAssertTrue(mocFake.saveWasCalled, @"Data must be saved using the managed object context.");
}

@end
