//
//  MainViewController.h
//  DealsCentralSG
//
//  Created by Feng Jianxiang on 7/1/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"

@class DataModel;

@interface MainViewController : UITableViewController {
    NSMutableArray *outputArray;
}

@property (nonatomic, assign) DataModel* dataModel;

@end
