//
//  Deal.m
//  DealsCentralSG
//
//  Created by Feng Jianxiang on 7/1/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "Deal.h"

@implementation Deal

@synthesize title, websiteURL;

- (void)dealloc {
    [title release];
    [websiteURL release];
    [super dealloc];
}

@end
