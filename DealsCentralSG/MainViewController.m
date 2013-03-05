//
//  MainViewController.m
//  DealsCentralSG
//
//  Created by Feng Jianxiang on 7/1/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "MainViewController.h"
#import "ASIHTTPRequest.h"
#import "MainListTableViewController.h"
#import "DataModel.h"

@implementation MainViewController

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

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSError *error;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:[request responseData] options:0 error:&error];
    
    if (document == nil) {
        NSLog(@"Failed to parse %@", request.url);
    } else {
        GDataXMLElement *rootNode = [document rootElement];
        
        //        NSLog(@"%@", [rootNode XMLString]);
        NSString *xpathQueryString =
        @"//div[@class='deal-content']/div/div[@class='c']/div/a";
        NSArray *newItemsNodes = [rootNode nodesForXPath:xpathQueryString error:&error];
        //        NSLog(@"%@", newItemsNodes);
        
        outputArray = [[NSMutableArray alloc] init];
        for (GDataXMLElement *item in newItemsNodes) {
            NSString *itemString = [[item stringValue] stringByReplacingOccurrencesOfString:@"\t" withString:@""];
            itemString = [itemString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            [outputArray addObject:itemString];
        }
        [self.tableView reloadData];
        NSLog(@"%@", outputArray);
    }
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"All Websites";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    outputArray = [[NSMutableArray alloc] initWithObjects:@"Deal.com.sg", nil];
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
    return [outputArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    cell.textLabel.text = [outputArray objectAtIndex:indexPath.row];
    
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
    NSURL* url = [NSURL URLWithString:@"http://www.deal.com.sg/deals/singapore"];
    __block ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:url];
	[request setDelegate:self];
    
    [request setCompletionBlock:^{
        NSLog(@"request passed");
        NSError *error;
        GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:[request responseData] options:0 error:&error];
        
        if (document == nil) {
            NSLog(@"Failed to parse %@", request.url);
        } else {
            GDataXMLElement *rootNode = [document rootElement];
            
            //        NSLog(@"%@", (NSString*)[request url]);
            NSString *xpathQueryString =
            @"//div[@id='block-deal-deal-categories-list']//ul/li/a/@href";
            //        @"//span[@class='today-deal-high']/ul/li/text() | //span[@class='today-deal-high']/ul/li/ul/li";
            NSArray *newItemsNodes = [rootNode nodesForXPath:xpathQueryString error:&error];
            xpathQueryString = @"//div[@id='block-deal-deal-categories-list']//ul/li/a";
            NSArray *websiteTitleNodes = [rootNode nodesForXPath:xpathQueryString error:&error];
            
            self.dataModel = nil;
            dataModel = [[DataModel alloc] init];
            dataModel.websiteName = @"Deal.com.sg";
//            NSURL *url1 = [NSURL URLWithString:@"http://www.deal.com.sg/deals/singapore"];
            dataModel.website = url;
            
            NSMutableArray *websites = [NSMutableArray array];
            NSMutableArray *websiteTitles = [NSMutableArray array];
            for (GDataXMLElement *website in newItemsNodes) {
                
                NSString *websiteString = [[website stringValue] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                
                NSString *rootSite = [NSString stringWithFormat:@"%@://%@", [dataModel.website scheme], [dataModel.website host]];
                websiteString = [rootSite stringByAppendingFormat:websiteString];
                [websites addObject:websiteString];
                
//                [dataModel.categoryURLs addObject:websiteString];
            }
            for (GDataXMLElement *websiteTitle in websiteTitleNodes) {
                NSString *websiteTitleString = [[websiteTitle stringValue] capitalizedString];
                [websiteTitles addObject:websiteTitleString];
            }
            for (int i=0; i<[websites count]; i++) {
                NSDictionary *dictionary = [NSDictionary dictionaryWithObject:[websiteTitles objectAtIndex:i] forKey:[websites objectAtIndex:i]];
                [dataModel.categoryURLs addObject:dictionary];
            }
            
            MainListTableViewController *detailViewController = [[MainListTableViewController alloc] initWithStyle:UITableViewStylePlain];
            detailViewController.dataModel = dataModel;
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
        
    }];
    [request setFailedBlock:^{
        
    }];
    [request startAsynchronous];
    /*
     MainListTableViewController *detailViewController = [[MainListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    self.dataModel = nil;
    dataModel = [[DataModel alloc] init];
    dataModel.websiteName = @"Deal.com.sg";
    NSURL *url1 = [NSURL URLWithString:@"http://www.deal.com.sg/deals/singapore?category=travel"];
    dataModel.website = url1;
    detailViewController.dataModel = dataModel;
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)dealloc {
    [outputArray release];
    [super dealloc];
}

@end
