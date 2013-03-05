//
//  MainListTableViewController.m
//  DealsCentralSG
//
//  Created by Feng Jianxiang on 7/1/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "MainListTableViewController.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "DataModel.h"
#import "DealDetailViewController.h"
#import "Deal.h"

@implementation MainListTableViewController

@synthesize dataModel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)getList:(NSString *)websiteString {
    //    NSURL *url = [NSURL URLWithString:@"http://www.deal.com.sg/deals/singapore"];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:websiteString]];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)toggleWebsite:(id)sender {
    UISegmentedControl *segment1 = sender;
    NSString *websiteString = [[[dataModel.categoryURLs objectAtIndex:segment1.selectedSegmentIndex] allKeys] objectAtIndex:0];
    [self getList:websiteString];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [dataModel websiteName];
    
    NSLog(@"category array: %@", dataModel.categoryURLs);
    NSMutableArray *websiteTitles = [NSMutableArray array];
    NSDictionary *dictionary = [dataModel.categoryURLs objectAtIndex:0];
    NSString *firstWebsite = [[dictionary allKeys] objectAtIndex:0];
    for (NSDictionary *website in dataModel.categoryURLs) {
        [websiteTitles addObject:[[website allValues] objectAtIndex:0]];
    }
    segment = [[UISegmentedControl alloc] initWithItems:websiteTitles];    
    segment.segmentedControlStyle = UISegmentedControlStyleBar;
//    segment.tintColor = [UIColor darkTextColor];
    segment.selectedSegmentIndex = 0;
    segment.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [segment addTarget:self action:@selector(toggleWebsite:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *websiteButton = [[UIBarButtonItem alloc] initWithTitle:[websiteTitles objectAtIndex:0] style:UIBarButtonItemStyleBordered target:self action:@selector(websitePickerView)];
    websiteButton.width = self.view.frame.size.width - 20;
    UIBarButtonItem *segItem = [[UIBarButtonItem alloc] initWithCustomView:segment];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, segment.bounds.size.width + 20, 44)];
//    toolbar.tintColor = [UIColor blueColor];
    [toolbar setItems:[NSArray arrayWithObjects:flexibleSpace, segItem, flexibleSpace, nil]];
    [segItem release];
    [flexibleSpace release];
//    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 0)] autorelease];
//    [headerView setBackgroundColor:[UIColor lightGrayColor]];
//    [headerView addSubview:toolbar];
//    self.tableView.tableHeaderView = toolbar;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, 44)];
    UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, segment.bounds.size.width, 0)] autorelease];
    [headerView setBackgroundColor:[UIColor lightGrayColor]];
    [headerView addSubview:toolbar];
    scrollView.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:toolbar];
    [scrollView setContentSize:CGSizeMake(toolbar.bounds.size.width,44)];
    scrollView.bounces = YES;
    scrollView.scrollEnabled = YES;
    self.tableView.tableHeaderView = scrollView;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self getList:firstWebsite];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [dataModel.deals count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    cell.textLabel.text = [[dataModel.deals objectAtIndex:indexPath.row] title];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DealDetailViewController *detailViewController = [[DealDetailViewController alloc] init];
    detailViewController.deal = [dataModel.deals objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
     
}

#pragma mark - ASIHTTPRequest

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSError *error;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:[request responseData] options:0 error:&error];
    
    if (document == nil) {
        NSLog(@"Failed to parse %@", request.url);
    } else {
        GDataXMLElement *rootNode = [document rootElement];
        
        //        NSLog(@"%@", [rootNode XMLString]);
        NSString *xpathQueryString =
        @"//div[@class='deal-content']//div[@id='deal-title']/a";
        NSArray *newItemsNodes = [rootNode nodesForXPath:xpathQueryString error:&error];
        xpathQueryString = @"//div[@class='deal-content']//div[@id='deal-title']/a/@href";
        NSArray *websiteURLArray = [rootNode nodesForXPath:xpathQueryString error:&error];
        
        dealsList = [[NSMutableArray alloc] init];
        /*
        for (GDataXMLElement *item in newItemsNodes) {
            NSString *itemString = [[item stringValue] stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            itemString = [itemString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [dealsList addObject:itemString];
        }
        
        for (GDataXMLElement *website in websiteURLArray) {
            NSString *itemString = [[website stringValue] stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            itemString = [itemString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            Deal *deal = [[Deal alloc] init];
            deal.websiteURL = [NSURL URLWithString:itemString];
            [dataModel.deals addObject:deal];
            [deal release];
        }
        */
        
        [dataModel.deals removeAllObjects];
        for (int i=0; i<[newItemsNodes count]; i++) {
            GDataXMLElement *item = [newItemsNodes objectAtIndex:i];
            GDataXMLElement *website = [websiteURLArray objectAtIndex:i];
            NSString *websiteString = [[[website stringValue] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *itemString = [[[item stringValue] stringByReplacingOccurrencesOfString:@"\t" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            NSString *rootSite = [NSString stringWithFormat:@"%@://%@", [dataModel.website scheme], [dataModel.website host]];
            websiteString = [rootSite stringByAppendingFormat:websiteString];
            Deal *deal = [[Deal alloc] init];
            deal.websiteURL = [NSURL URLWithString:websiteString];
            deal.title = itemString;
            [dataModel.deals addObject:deal];
            [deal release];
        }
        
        
        [self.tableView reloadData];
    }
    
}

@end
