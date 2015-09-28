//
//  AddingViewController.m
//  My Weight
//
//  Created by Александр Карцев on 9/15/15.
//  Copyright (c) 2015 Alex Kartsev. All rights reserved.
//

#import "AddingViewController.h"

@interface AddingViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@end

@implementation AddingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.datePicker.maximumDate = [NSDate date];
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    UITapGestureRecognizer *touch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchEndEditing)];
    [self.view addGestureRecognizer:touch];
    [self buttonSwitchOff:self.saveButton];
    if (self.isDetail) {
        [self buttonSwitchOn:self.deleteButton];
        self.textField.text = self.weightInfo;
        [self performSelector:@selector(setDatePickerWithAnimation) withObject:nil afterDelay:0.5];
        self.firstEventPicker = self.eventPicker;
        self.firstWeightInfo = self.weightInfo;
    }
    else
    {
        [self buttonSwitchOff:self.deleteButton];
        self.eventPicker = self.datePicker.date;
    }
    [self.datePicker addTarget:self action:@selector(dateChanged) forControlEvents:UIControlEventValueChanged];
    [self.deleteButton addTarget:self action:@selector(deleting) forControlEvents:UIControlEventTouchUpInside];
    [self.saveButton addTarget:self action:@selector(saving) forControlEvents:UIControlEventTouchUpInside];
}

-(void)dateChanged
{
    self.eventPicker = self.datePicker.date;
    if (self.isDetail) {
        [self buttonSwitchOn:self.saveButton];
    }
}

- (void) setDatePickerWithAnimation
{
    [self.datePicker setDate:self.eventPicker animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) buttonSwitchOff:(UIButton*) button
{
    button.userInteractionEnabled=NO;
    button.alpha=0.5;
}

- (void) buttonSwitchOn:(UIButton*) button
{
    button.userInteractionEnabled=YES;
    button.alpha=1;
}

- (void) touchEndEditing{
    if (self.textField.text.length!=0 && !([self.textField.text isEqualToString:self.firstWeightInfo])) {
        [self buttonSwitchOn:self.saveButton];
        [self.view endEditing:YES];
    }
    else
    {
        if ([self.textField isFirstResponder] && (self.textField.text.length==0)) {
            [self showAlertViewWithMessage:@"Please, enter your weight"];
        }
        else
        {
            [self.view endEditing:YES];
        }
    }
}

- (void) showAlertViewWithMessage:(NSString *) message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Attention!" message: message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}

-(NSDate*)setTime:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear) fromDate:date];
    [dateComponents setHour:00];
    [dateComponents setMinute:00];
    NSDate *newDate = [calendar dateFromComponents:dateComponents];
    return newDate;
}



- (void) saving
{
    NSError *error = nil;
    NSString *eventInfo = self.textField.text;
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    NSNumber *myNumber = [f numberFromString:eventInfo];
    
    //finding elements with equal date at datePicker and parse.com
    NSDate *date = [self setTime:self.datePicker.date];
    
    MyWeightCoreData *weight = [[DataManager sharedManager] anObjectEntityForName:@"MyWeightCoreData" withValue:date forKeyPath:@"date"];
    if ([self.firstEventPicker isEqualToDate:self.datePicker.date])
    {
        //if we only change weight
        weight.weight = myNumber;
        if (![[[DataManager sharedManager] managedObjectContext] save:&error]) {
            NSLog(@"%@", [error localizedDescription]);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Weights Array Should Be Updated" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        [[DataManager sharedManager] editObjectAtParse:weight forDate:date];
    }
    else
    {
        if (!weight)
        {
            if (self.isDetail)
            {
                //editing object
                NSDate* tempDate = [self setTime:self.firstEventPicker];
                MyWeightCoreData *tempObject = [[DataManager sharedManager] anObjectEntityForName:@"MyWeightCoreData" withValue:tempDate forKeyPath:@"date"];
                tempObject.date = date;
                tempObject.weight = myNumber;
                if (![[[DataManager sharedManager] managedObjectContext] save:&error]) {
                    NSLog(@"%@", [error localizedDescription]);
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Weights Array Should Be Updated" object:nil];
                [self.navigationController popViewControllerAnimated:YES];
                [[DataManager sharedManager] editObjectAtParse:tempObject forDate:tempDate];
            }
            else
            {
                //adding new object
                MyWeightCoreData* temp =
                [NSEntityDescription insertNewObjectForEntityForName:@"MyWeightCoreData"
                                              inManagedObjectContext:[[DataManager sharedManager] managedObjectContext]];
                temp.weight = myNumber;
                temp.date = date;
                
                if (![[[DataManager sharedManager] managedObjectContext] save:&error]) {
                    NSLog(@"%@", [error localizedDescription]);
                }
                [self.navigationController popViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"Weights Array Should Be Updated" object:nil];
                [[DataManager sharedManager] addingNewObjectToParse:temp];
            }
        }
        else
        {
            [self showAlertViewWithMessage:@"You already have a record for this date"];
        }
    }
}

- (void) deleting
{
    //deleting element
    NSDate *date = [self setTime:self.firstEventPicker];
    MyWeightCoreData *weight = [[DataManager sharedManager] anObjectEntityForName:@"MyWeightCoreData" withValue:date forKeyPath:@"date"];
    [[[DataManager sharedManager] managedObjectContext] deleteObject:weight];
    NSError *error=nil;
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"Weights Array Should Be Updated" object:nil];
    DataManager *manager;
    [manager deleteObjectFromParse:weight];
    if (![[[DataManager sharedManager] managedObjectContext] save:&error]) {
        NSLog(@"%@", [error localizedDescription]);
    }
}

@end
