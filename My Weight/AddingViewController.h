//
//  AddingViewController.h
//  My Weight
//
//  Created by Александр Карцев on 9/15/15.
//  Copyright (c) 2015 Alex Kartsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataManager.h"
#import "MyWeightCoreData.h"

@interface AddingViewController : UIViewController

@property (nonatomic,assign) BOOL isDetail;
@property (strong, nonatomic) NSDate *eventPicker;
@property (strong, nonatomic) NSDate *firstEventPicker;
@property (strong, nonatomic) NSString *weightInfo;
@property (strong, nonatomic) NSString *firstWeightInfo;


@end
