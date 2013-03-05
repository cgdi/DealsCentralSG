@class Deal;

// The main data model object
@interface DataModel : NSObject
{
}
@property (nonatomic, retain) NSMutableArray* deals;
@property (nonatomic, retain) NSMutableArray* categoryURLs;

- (NSString*)websiteName;
- (void)setWebsiteName:(NSString*)name;

- (NSURL*)website;
- (void)setWebsite:(NSURL*)url;

- (int)addMessage:(Deal*)deal;

@end
