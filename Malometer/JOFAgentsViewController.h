//
//  JOFMasterViewController.h
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 02/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "JOFAgentEditViewControllerDelegate.h"


@interface JOFAgentsViewController : UITableViewController <NSFetchedResultsControllerDelegate, JOFAgentEditViewControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
