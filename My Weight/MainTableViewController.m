//
//  MainTableViewController.m
//  My Weight
//
//  Created by Александр Карцев on 9/15/15.
//  Copyright (c) 2015 Alex Kartsev. All rights reserved.
//

#import "MainTableViewController.h"
#import "AddingViewController.h"


@interface MainTableViewController ()

@property (nonatomic,strong) NSArray * arrayMyWeight;
@property (unsafe_unretained, nonatomic) IBOutlet UIBarButtonItem *logOutBarButtonItem;

@end

@implementation MainTableViewController

- (void) viewDidLoad
{
    [self.tabBarController.viewControllers[1] performSelector:@selector(view)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTable) name:@"Weights Array Should Be Updated" object:nil];
    [[DataManager sharedManager] retrieveFromParse];

}

- (void)reloadTable
{
    NSManagedObjectContext *managedObjectContext = [[DataManager sharedManager] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"MyWeightCoreData"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"date"
                                                                   ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    self.arrayMyWeight = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"DataFromServer" object:self.arrayMyWeight];
    [self.tableView reloadData];
}

- (IBAction)logOutBarButtonItem:(id)sender {
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayMyWeight.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddingViewController *detailView = [self.storyboard instantiateViewControllerWithIdentifier:@"addingViewController"];
    detailView.isDetail = YES;
    [self.navigationController pushViewController:detailView animated:YES];
    MyWeightCoreData *tempObject = [self.arrayMyWeight objectAtIndex:indexPath.row];
    detailView.weightInfo = [NSString stringWithFormat:@"%@",tempObject.weight];
    detailView.eventPicker = tempObject.date;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *tempObject = [self.arrayMyWeight objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ kg",[tempObject valueForKey:@"Weight"]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd MMMM yyyy";
    NSString *eventDate = [formatter stringFromDate:[tempObject valueForKey:@"Date"]];
    cell.detailTextLabel.text = eventDate;
    return cell;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
