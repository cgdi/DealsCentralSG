//
//  DealDetailViewController.m
//  DealsCentralSG
//
//  Created by Feng Jianxiang on 8/1/12.
//  Copyright (c) 2012 -. All rights reserved.
//

#import "DealDetailViewController.h"
#import "ASIHTTPRequest.h"
#import "GDataXMLNode.h"
#import "DataModel.h"
#import "Deal.h"

@implementation DealDetailViewController

@synthesize deal;
@synthesize textView;
@synthesize output;
@synthesize text;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.title = [deal title];
    self.textView = [[UITextView alloc] init];
    self.textView.font = [UIFont systemFontOfSize:14];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[deal websiteURL]];
    [request setDelegate:self];
    [request startAsynchronous];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)print:(NSString *)string {
    self.textView.text = [self.textView.text stringByAppendingString:string];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    NSError *error;
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithHTMLData:[request responseData] options:0 error:&error];
    
    if (document == nil) {
        NSLog(@"Failed to parse %@", request.url);
    } else {
        GDataXMLElement *rootNode = [document rootElement];

//        NSLog(@"%@", (NSString*)[request url]);
        NSString *xpathQueryString =
        @"//span[@class='today-deal-high']/ul/li";
//        @"//span[@class='today-deal-high']/ul/li/text() | //span[@class='today-deal-high']/ul/li/ul/li";
        NSArray *newItemsNodes = [rootNode nodesForXPath:xpathQueryString error:&error];
        
//        text = [NSString string];
        for (GDataXMLElement *item in newItemsNodes) {
            NSString *xml = [item XMLString];
            [self print:xml];
            
//            NSString *itemString = [[item stringValue] stringByReplacingOccurrencesOfString:@"\r" withString:@""];
//            itemString = [itemString substringFromIndex:3];
//            
//            itemString = [itemString stringByReplacingOccurrencesOfString:@"\n\t\t\t\n\t\t\t\t" withString:@"\n\t-  "];
//            itemString = [itemString stringByReplacingOccurrencesOfString:@"\n\t\t\n\t\t\t\t" withString:@"\n\t-  "];
//            itemString = [itemString stringByReplacingOccurrencesOfString:@"\n\t\t" withString:@""];
//            itemString = [NSString stringWithFormat:@"%C\t%@", 0x2022, itemString];
//            itemString = [itemString stringByAppendingFormat:@"\n"];
//            
//            self.text = [text stringByAppendingString:itemString];
        }
        CGSize textSize = [textView.text sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:CGSizeMake(self.view.bounds.size.width - 30, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];
        webView1 = [[UIWebView alloc] initWithFrame:CGRectMake(10, 20 + 5, self.view.bounds.size.width - 10*3, textSize.height)];
        webView1.delegate = self;
        [webView1 loadHTMLString:textView.text baseURL:[NSURL URLWithString:@""]];
        self.output = [webView1 stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
        
        theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height ) style:UITableViewStyleGrouped];
        theTableView.dataSource = self;
        theTableView.delegate = self;
        theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        theTableView.backgroundColor = [UIColor clearColor];
        
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 80)];
        headerView.backgroundColor = [UIColor blueColor];
        theTableView.tableHeaderView = headerView;
        [self.view addSubview:theTableView];
    }
    
}

#pragma mark - tableview datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    const NSInteger TOP_LABEL_TAG = 1001;
	const NSInteger BOTTOM_LABEL_TAG = 1002;
	UILabel *topLabel;
    UIWebView *webView;
    CGSize textSize = [textView.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(theTableView.frame.size.width - 30, FLT_MAX) lineBreakMode:UILineBreakModeWordWrap];

    static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [aTableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil)
	{
        cell =
        [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
        topLabel = [[[UILabel alloc] initWithFrame:CGRectMake(cell.indentationWidth, 5, aTableView.bounds.size.width - 2*cell.indentationWidth, 20)]autorelease];
		[cell.contentView addSubview:topLabel];
        
        topLabel.tag = TOP_LABEL_TAG;
		topLabel.backgroundColor = [UIColor clearColor];
		topLabel.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
		topLabel.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		topLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        
        /*
        bottomTextView = [[[UITextView alloc] initWithFrame:CGRectMake(cell.indentationWidth, topLabel.bounds.size.height + 5, aTableView.bounds.size.width - 20, textSize.height)] autorelease];
        [cell.contentView addSubview:bottomTextView];
        
        bottomTextView.tag = BOTTOM_LABEL_TAG;
		bottomTextView.backgroundColor = [UIColor clearColor];
		bottomTextView.textColor = [UIColor colorWithRed:0.25 green:0.0 blue:0.0 alpha:1.0];
//		bottomTextView.highlightedTextColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.9 alpha:1.0];
		bottomTextView.font = [UIFont systemFontOfSize:[UIFont labelFontSize] - 2];
        bottomTextView.scrollEnabled = NO;
        */
        
        webView = [[[UIWebView alloc] initWithFrame:CGRectMake(cell.indentationWidth, topLabel.bounds.size.height + 5, aTableView.bounds.size.width - cell.indentationWidth*3, textSize.height)] autorelease];
//        webView.contentMode = UIViewContentModeScaleAspectFit;
        
//        webView.delegate = self;
        [cell.contentView addSubview:webView];
        
        webView.tag = BOTTOM_LABEL_TAG;
		webView.backgroundColor = [UIColor clearColor];
        webView.opaque = NO;
//        webView.scalesPageToFit = YES;
//        webView.scrollView.scrollEnabled = NO;
    }
    else
	{
		topLabel = (UILabel *)[cell viewWithTag:TOP_LABEL_TAG];
		webView = (UIWebView *)[cell viewWithTag:BOTTOM_LABEL_TAG];
	}

    topLabel.text = @"Highlight";
//    bottomTextView.font = [UIFont systemFontOfSize:10];
//	bottomTextView.text = text;
//    webView = webView1;
	[webView loadHTMLString:textView.text baseURL:[NSURL URLWithString:@""]];
//    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.webkitTextSizeAdjust= 50"];
//    output = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    UIWebView *webView = (UIWebView *)[cell viewWithTag:1002];
//    NSString *output1 = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"];
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;

    CGFloat height = fittingSize.height + 20;
    return height;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    // catch all link pressed and push to webview 
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    CGRect frame = webView.frame;
    frame.size.height = 1;
    webView.frame = frame;
    CGSize fittingSize = [webView sizeThatFits:CGSizeZero];
    frame.size = fittingSize;
    webView.frame = frame;
//    theTableView.rowHeight = fittingSize.height;
//    [theTableView reloadData];
}

- (void)dealloc {
    [webView1 release];
    [theTableView release];
    [textView release];
    [super dealloc];
}
@end
