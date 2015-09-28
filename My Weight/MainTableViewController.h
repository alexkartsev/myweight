//
//  MainTableViewController.h
//  My Weight
//
//  Created by Александр Карцев on 9/15/15.
//  Copyright (c) 2015 Alex Kartsev. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "AddingViewController.h"
#import "GraphViewController.h"
#import "DataManager.h"
#import "MyWeightCoreData.h"

@interface MainTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
