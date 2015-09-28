//
//  GraphView.h
//  My Weight
//
//  Created by Александр Карцев on 9/17/15.
//  Copyright (c) 2015 Alex Kartsev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface GraphView : UIView

@property (nonatomic) NSMutableArray *arrayOfPoints;
@property (nonatomic) NSMutableArray *arrayOfStringsDate;


@end
