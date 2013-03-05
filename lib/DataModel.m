
#import "DataModel.h"
#import "Deal.h"

// We store our settings in the NSUserDefaults dictionary using these keys
static NSString* const NicknameKey = @"Nickname";
static NSString* const UserIDKey = @"UserID";
static NSString* const RoomTopicKey = @"RoomTopic";
static NSString* const JoinedChatKey = @"JoinedChat";
static NSString* const DeviceTokenKey = @"DeviceToken";
static NSString* const WebsiteName = @"WebsiteName";
static NSString* const WebsiteURL = @"WebsiteURL";

@implementation DataModel

@synthesize deals;
@synthesize categoryURLs;

- (id)init {
    self = [super init];
    if (self) {
        self.deals = [NSMutableArray array];
        self.categoryURLs = [NSMutableArray array];
    }
    return self;
}

+ (void)initialize
{
	if (self == [DataModel class])
	{
	}
}

- (int)addMessage:(Deal*)deal
{
	[self.deals addObject:deal];
	return self.deals.count - 1;
}

- (NSString*)websiteName
{
	return [[NSUserDefaults standardUserDefaults] stringForKey:WebsiteName];
}

- (void)setWebsiteName:(NSString*)name
{
	[[NSUserDefaults standardUserDefaults] setObject:name forKey:WebsiteName];
}

- (NSURL*)website {
    return [[NSUserDefaults standardUserDefaults] URLForKey:WebsiteURL];
}

- (void)setWebsite:(NSURL*)url {
    [[NSUserDefaults standardUserDefaults] setURL:url forKey:WebsiteURL];
}

- (void)dealloc
{
    [categoryURLs release];
    [deals release];
	[super dealloc];
}

@end
