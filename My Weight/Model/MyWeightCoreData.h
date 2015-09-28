//
//  MyWeightCoreData.h
//  My Weight
//
//  Created by Александр Карцев on 9/22/15.
//  Copyright (c) 2015 Alex Kartsev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MyWeightCoreData : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * weight;

@end
