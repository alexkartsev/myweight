//
//  DataManager.h
//  My Weight
//
//  Created by Александр Карцев on 9/22/15.
//  Copyright (c) 2015 Alex Kartsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import "MyWeightCoreData.h"


@interface DataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void) deleteAllObjects;
- (void) retrieveFromParse;
+ (DataManager*) sharedManager;
-(void)editObjectAtParse:(MyWeightCoreData *)object forDate:(NSDate *)date;
-(void)addingNewObjectToParse:(MyWeightCoreData *)object;
-(void)deleteObjectFromParse:(MyWeightCoreData *)object;
- (MyWeightCoreData *)anObjectEntityForName:(NSString *)entityName withValue:(NSDate *)value forKeyPath:(NSString *)keyPath;

@end
