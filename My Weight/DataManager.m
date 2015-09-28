//
//  DataManager.m
//  My Weight
//
//  Created by Александр Карцев on 9/22/15.
//  Copyright (c) 2015 Alex Kartsev. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


+ (DataManager*) sharedManager {
    
    static DataManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
    });
    
    return manager;
}

-(void)editObjectAtParse:(MyWeightCoreData *)object forDate:(NSDate *)date
{
    PFQuery *query = [PFQuery queryWithClassName:@"myWeight"];
    [query whereKey:@"Date" equalTo:date];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error)
     {
         if (!error) {
             [obj setObject:object.date forKey:@"Date"];
             [obj setObject:object.weight forKey:@"Weight"];
             [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                 if (!error) {
                 } else {
                     NSLog(@"%@",error.description);
                 }
             }];
         }
     }];
}

-(void)addingNewObjectToParse:(MyWeightCoreData *)object
{
    PFObject *obj = [[PFObject alloc]initWithClassName:@"myWeight"] ;
    [obj setObject:object.weight forKey:@"Weight"];
    PFUser *user = [PFUser currentUser];
    obj[@"user"] = user;
    [obj setObject:object.date forKey:@"Date"];
    [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
        } else {
            NSLog(@"%@",error.description);
        }
    }];
}

-(void)deleteObjectFromParse:(MyWeightCoreData *)object
{
    PFQuery *query = [PFQuery queryWithClassName:@"myWeight"];
    [query whereKey:@"Date" equalTo:object.date];
    PFUser *user = [PFUser currentUser];
    [query whereKey:@"user" equalTo:user];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *obj, NSError *error)
     {
         [obj deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
             if (!error) {
             } else {
                 NSLog(@"%@",error.description);
             }
             
         }];
     }];

}

- (NSArray*) allObjects {
    
    NSFetchRequest* request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription* description =
    [NSEntityDescription entityForName:@"MyWeightCoreData"
                inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:description];
    
    NSError* requestError = nil;
    NSArray* resultArray = [self.managedObjectContext executeFetchRequest:request error:&requestError];
    if (requestError) {
        NSLog(@"%@", [requestError localizedDescription]);
    }
    
    return resultArray;
}


- (void) deleteAllObjects {
    
    NSArray* allObjects = [self allObjects];
    for (id object in allObjects) {
        [self.managedObjectContext deleteObject:object];
    }
    [self.managedObjectContext save:nil];
}

-(void) retrieveFromParse
{
    //parsing elements
    PFQuery *retrieveWeight = [PFQuery queryWithClassName:@"myWeight"];
    PFUser *user = [PFUser currentUser];
    [retrieveWeight whereKey:@"user" equalTo:user];
    [retrieveWeight findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        NSArray *temp = [[NSMutableArray alloc] initWithArray:objects];
        
        NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                            sortDescriptorWithKey:@"Date"
                                            ascending:NO];
        NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
        temp = [temp sortedArrayUsingDescriptors:sortDescriptors];
        for (int i=0;i<temp.count;i++) {
            PFObject *object = [temp objectAtIndex:i];
            MyWeightCoreData* weight =
            [NSEntityDescription insertNewObjectForEntityForName:@"MyWeightCoreData"
                                          inManagedObjectContext:self.managedObjectContext];
            weight.weight = [object valueForKey:@"Weight"];
            weight.date = [object valueForKey:@"Date"];
        }
        [self.managedObjectContext save:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Weights Array Should Be Updated" object:nil];
        });
    }];
}


- (NSURL *)applicationDocumentsDirectory {

    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyWeight" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MyWeight.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (MyWeightCoreData *)anObjectEntityForName:(NSString *)entityName withValue:(NSDate *)value forKeyPath:(NSString *)keyPath{
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"%K == %@", keyPath, value]];
    
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    
    if (!mutableFetchResults) {
        return nil;
    }
    if (mutableFetchResults.count ==0) {
        return nil;
    }
    id anObject = [mutableFetchResults objectAtIndex:0];
    
    return anObject;
}


- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
