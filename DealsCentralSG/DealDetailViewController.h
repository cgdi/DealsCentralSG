//
//  DealDetailViewController.h
//  DealsCentralSG
//
//  Created by Feng Jianxiang on 8/1/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Deal;

@interface DealDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate> {
    UITableView *theTableView;
    UIWebView *webView1;
//    NSString *output;
}

@property (nonatomic, assign) Deal *deal;
@property (nonatomic, retain) UITextView *textView;
@property (nonatomic, retain) NSString *output;
@property (nonatomic, retain) NSString *text;

@end
