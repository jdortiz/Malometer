//
//  JOFMasterViewController.m
//  Malometer
//
//  Created by Jorge D. Ortiz Fuentes on 02/06/14.
//  Copyright (c) 2014 PoWWaU. All rights reserved.
//

#import "JOFAgentsViewController.h"
#import "JOFAgentEditViewController.h"
#import "Agent+Model.h"
#import "Domain+Model.h"


@interface JOFAgentsViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end



@implementation JOFAgentsViewController

#pragma mark - Parameters & constants

static NSString *const segueCreateAgent = @"CreateAgent";
static NSString *const segueEditAgent   = @"EditAgent";


#pragma mark - Initialization

- (void) viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    [self displayControlledDomainsInTitle];
}


#pragma mark - Display information

- (void) displayControlledDomainsInTitle {
    NSError *error;
    NSUInteger controlledDomains = [self.managedObjectContext countForFetchRequest:[Domain fetchRequestControlledDomains]
                                                                             error:&error];
    self.title = [NSString stringWithFormat:@"Controlled domains: %d", controlledDomains];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *categoryName = [[[self.fetchedResultsController sections] objectAtIndex:section] name];
    NSNumber *dpAvg = [[[[self.fetchedResultsController sections] objectAtIndex:section] objects] valueForKeyPath:@"@avg.destructionPower"];
    return [NSString stringWithFormat:@"%@ (%@)", categoryName, dpAvg];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }   
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

#pragma mark - Segues

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:segueCreateAgent]) {
        JOFAgentEditViewController *agentEditVC = (JOFAgentEditViewController *)[segue.destinationViewController topViewController];
        [self prepareAgentEditViewController:agentEditVC withAgent:nil];
    } else if ([[segue identifier] isEqualToString:segueEditAgent]) {
        JOFAgentEditViewController *agentEditVC = (JOFAgentEditViewController *)[segue.destinationViewController topViewController];
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        Agent *agent = [self.fetchedResultsController objectAtIndexPath:selectedIndexPath];
        [self prepareAgentEditViewController:agentEditVC withAgent:agent];
    }
}


- (void) prepareAgentEditViewController:(JOFAgentEditViewController *)agentEditVC
                              withAgent:(Agent *)agent {
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    [context.undoManager beginUndoGrouping];
    if (agent == nil) {
        Agent *newAgent = [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext:context];
        agentEditVC.agent = newAgent;
    } else {
        agentEditVC.agent = agent;
    }
    agentEditVC.delegate = self;
}


#pragma mark - Fetched results controller

- (NSFetchedResultsController *) fetchedResultsController {
    if (_fetchedResultsController == nil) {
        [NSFetchedResultsController deleteCacheWithName:@"Agents"];
        NSSortDescriptor *categoryNameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"category.name" ascending:YES];
        NSSortDescriptor *destPowSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:agentPropertyDestructionPower ascending:NO];
        NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:agentPropertyName ascending:YES];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:[Agent fetchAllAgentsWithSortDescriptors:@[categoryNameSortDescriptor, destPowSortDescriptor, nameSortDescriptor]]
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:@"category.name"
                                                                                   cacheName:@"Agents"];
        _fetchedResultsController.delegate = self;

        NSError *error = nil;
        if (![self.fetchedResultsController performFetch:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _fetchedResultsController;
}    


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
    [self displayControlledDomainsInTitle];
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Agent *agent = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = agent.name;
}


#pragma mark - Agent edit view controller delegate

- (void) dismissAgentEditViewController:(JOFAgentEditViewController *)agentEditVC
                           modifiedData:(BOOL)modifiedData {
    [self.managedObjectContext.undoManager setActionName:@"New agent"];
    [self.managedObjectContext.undoManager endUndoGrouping];
    if (modifiedData) {
        [self saveContext];
    } else {
        [self.managedObjectContext.undoManager undo];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) saveContext {
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

@end
