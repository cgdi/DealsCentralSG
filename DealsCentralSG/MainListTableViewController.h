//
//  MainListTableViewController.h
//  DealsCentralSG
//
//  Created by Feng Jianxiang on 7/1/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataModel;

@interface MainListTableViewController : UITableViewController {
    NSMutableArray *dealsList;
    UISegmentedControl *segment;
}

@property (nonatomic, assign) DataModel* dataModel;

@end
