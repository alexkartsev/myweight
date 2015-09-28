//
//  GraphViewController.m
//  My Weight
//
//  Created by Александр Карцев on 9/18/15.
//  Copyright (c) 2015 Alex Kartsev. All rights reserved.
//

#import "GraphViewController.h"

@interface GraphViewController ()
@property (weak, nonatomic) IBOutlet GraphView *viewWithGraph;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel1;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel2;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel3;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel4;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel5;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel6;


@end

@implementation GraphViewController
static int AVERAGE_NUMBER_OF_DAYS_IN_MONTH = 31;

- (void) viewDidLoad {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataFromServerHasUpdated:) name:@"DataFromServer" object:nil];
}


- (void)dataFromServerHasUpdated:(NSNotification *)notification
{
    if ([notification.object isKindOfClass:[NSArray class]])
    {
        NSNumber *tempNum=@-1;
        NSMutableArray *array=[[NSMutableArray alloc]init];
        NSDate *now = [NSDate date];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:now];
        [dateComponents setHour:00];
        [dateComponents setMinute:00];
        NSDate *temp = [calendar dateFromComponents:dateComponents];
        NSInteger day = [dateComponents day];
        day=day-AVERAGE_NUMBER_OF_DAYS_IN_MONTH;
        [dateComponents setDay:day];
        NSDate *thirtyDaysAgo = [calendar dateFromComponents:dateComponents];
        [self choosingDates:thirtyDaysAgo];
        
        //creating the array for GraphView for the last month
        for (MyWeightCoreData *tempObject in notification.object) {
            if ([tempObject.date compare:thirtyDaysAgo] == NSOrderedDescending) {
                while ([tempObject.date compare:temp]!=NSOrderedSame) {
                    [array addObject:tempNum];
                    NSCalendar *calendar = [NSCalendar currentCalendar];
                    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:temp];
                    NSInteger day = [dateComponents day];
                    day=day-1;
                    [dateComponents setDay:day];
                    temp = [calendar dateFromComponents:dateComponents];
                }
                [array addObject:tempObject.weight];
                NSCalendar *calendar = [NSCalendar currentCalendar];
                NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:temp];
                NSInteger day = [dateComponents day];
                day=day-1;
                [dateComponents setDay:day];
                temp = [calendar dateFromComponents:dateComponents];
            }
        }
        if (array.count<AVERAGE_NUMBER_OF_DAYS_IN_MONTH) {
            while (array.count!=AVERAGE_NUMBER_OF_DAYS_IN_MONTH) {
                [array addObject:tempNum];
            }
        }
        self.viewWithGraph.arrayOfPoints = array;
        [self.viewWithGraph setNeedsDisplay];
    }
    else
    {
        NSLog(@"Error, object not recognised.");
    }
}

-(void)choosingDates:(NSDate *) thirtyAgo
{
    //adding dates for dateLabels
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd.MM";
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:thirtyAgo];
    NSInteger day = [dateComponents day];
    day=day+1;
    [dateComponents setDay:day];
    thirtyAgo = [calendar dateFromComponents:dateComponents];
    self.dateLabel1.text = [formatter stringFromDate:thirtyAgo];
    day=day+6;
    [dateComponents setDay:day];
    thirtyAgo = [calendar dateFromComponents:dateComponents];
    self.dateLabel2.text = [formatter stringFromDate:thirtyAgo];
    day=day+6;
    [dateComponents setDay:day];
    thirtyAgo = [calendar dateFromComponents:dateComponents];
    self.dateLabel3.text = [formatter stringFromDate:thirtyAgo];
    day=day+6;
    [dateComponents setDay:day];
    thirtyAgo = [calendar dateFromComponents:dateComponents];
    self.dateLabel4.text = [formatter stringFromDate:thirtyAgo];
    day=day+6;
    [dateComponents setDay:day];
    thirtyAgo = [calendar dateFromComponents:dateComponents];
    self.dateLabel5.text = [formatter stringFromDate:thirtyAgo];
    day=day+6;
    [dateComponents setDay:day];
    thirtyAgo = [calendar dateFromComponents:dateComponents];
    self.dateLabel6.text = [formatter stringFromDate:thirtyAgo];
}

@end
