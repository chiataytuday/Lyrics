//
//  PoemsController_iPad.m
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PoemsController_iPad.h"
#import "FacebookManager.h"
#import "PoemViewController_iPad.h"
#import "Additions.h"
#import "StorageManager.h"
#import "SettingsManager.h"
#import "InfoController_iPad.h"
#import "FavoritesController_iPad.h"
#import "SearchController_iPad.h"
#import "WebViewController_iPad.h"
#import <QuartzCore/QuartzCore.h>

#define POEM_WIDTH 728
#define POEM_HEIGHT 920
#define POEM_WIDTH_LANDSCAPE 663
#define POEM_HEIGHT_LANDSCAPE 650

@implementation PoemsController_iPad

@synthesize addToFavs, scrollView, pageControl,  writer, requestedPoemNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray array]];
        segmentedControl.frame = CGRectMake(150, 5, 220, 30);
        [segmentedControl setMomentary:YES];
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"search.png"] atIndex:0 animated:NO];
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"favorites.png"] atIndex:1 animated:NO];
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"settings.png"] atIndex:2 animated:NO];
        [segmentedControl insertSegmentWithTitle:@"Share" atIndex:3 animated:NO];
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"youtube.png"] atIndex:4 animated:NO];
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        [segmentedControl addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
        
        UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView: segmentedControl];
        self.navigationItem.rightBarButtonItem = segmentBarItem;

    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPopup) name:@"FavoriteAuthorSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPopup) name:@"FavoritePoemSelected" object:nil];
       
    if (writer) {        
        NSMutableArray *poemsUnsorted = [[NSMutableArray alloc] init];
        self.title = writer.name;
        for (Song *p in writer.songs)
            [poemsUnsorted addObject:p];
        
        poems = [poemsUnsorted sortedArrayUsingComparator:^(id a, id b) {
            NSString *first = [(Song *)a title];
            NSString *second = [(Song *)b title];
            return [first compare:second];
        }];
    }
       
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
        self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        isPortrait = YES;
    } else 
        isPortrait = NO;
    
    [self initScrollView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait ||
        self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        isPortrait = YES;
    } else {
        isPortrait = NO;
    }
    
    [self restartScroll];
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    if (mainPopOver)
        [mainPopOver dismissPopoverAnimated:YES];
    
    if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        isPortrait = YES;
    } else {
        isPortrait = NO;
    }
    
    [self restartScroll];
}

#pragma mark - Actions & Selectors

- (void)dismissPopup {
    if (mainPopOver)
        [mainPopOver dismissPopoverAnimated:YES];
}

- (void)segmentedAction:(id)sender {
    
    if (mainPopOver)
        [mainPopOver dismissPopoverAnimated:YES];
    
    UISegmentedControl *segment = (UISegmentedControl *)sender;
    
    if (segment.selectedSegmentIndex == 0) {
        SearchController_iPad *searchController = [[SearchController_iPad alloc] init];
        mainPopOver = [[UIPopoverController alloc] initWithContentViewController:searchController];
        mainPopOver.popoverContentSize = CGSizeMake(600, 600);
        [mainPopOver presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    if (segment.selectedSegmentIndex == 1) {
        FavoritesController_iPad *favController = [[FavoritesController_iPad alloc] init];
        mainPopOver = [[UIPopoverController alloc] initWithContentViewController:favController];
        mainPopOver.popoverContentSize = CGSizeMake(600, 600);
        [mainPopOver presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];

    }
    
    if (segment.selectedSegmentIndex == 2) {
        InfoController_iPad *infoController = [[InfoController_iPad alloc] init];
        mainPopOver = [[UIPopoverController alloc] initWithContentViewController:infoController];
        mainPopOver.popoverContentSize = CGSizeMake(600, 600);
        [mainPopOver presentPopoverFromBarButtonItem:self.navigationItem.rightBarButtonItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }
    
    if (segment.selectedSegmentIndex == 3) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share Lyrics" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email", @"Facebook", @"Twitter", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showFromBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];
    }
    
    if (segment.selectedSegmentIndex == 4) {
        CGFloat pageWidth = isPortrait ? POEM_WIDTH : POEM_WIDTH_LANDSCAPE;
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        Song *p = [poems objectAtIndex:page];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/results?search_query=%@+%@", [writer.name stringByReplacingOccurrencesOfString:@" " withString:@"+"] , [[p.title stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];;
        
        WebViewController_iPad *webController = [[WebViewController_iPad alloc] init];
        webController.url = url;
        webController.title = @"Videos";
        [self.navigationController pushViewController:webController animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    CGFloat pageWidth = POEM_WIDTH;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    PoemViewController_iPad *currentPage = [pages objectAtIndex:page];
    
    NSString *textToPost = currentPage.lblContent.text;
    if (currentPage.lblContent.selectedRange.location != NSNotFound && currentPage.lblContent.selectedRange.length > 0) {
        textToPost = [textToPost substringWithRange:currentPage.lblContent.selectedRange];
    }
    
    if (buttonIndex == 0) {
        CGFloat pageWidth = (isPortrait ? POEM_WIDTH : POEM_WIDTH_LANDSCAPE);
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        PoemViewController_iPad *currentPage = [pages objectAtIndex:page];
        
        NSString *textToPost = currentPage.lblContent.text;
        if (currentPage.lblContent.selectedRange.location != NSNotFound && currentPage.lblContent.selectedRange.length > 0) {
            textToPost = [textToPost substringWithRange:currentPage.lblContent.selectedRange];
        }
        
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            mailController.mailComposeDelegate = self;
            [mailController setSubject:[NSString stringWithFormat:@"%@ - %@", writer.name, currentPage.lblTitle.text]];
            [mailController setMessageBody:[NSString stringWithFormat:@"%@ %@ \n\n%@",[[SettingsManager current] getTwitterTitle], [NSString stringWithFormat:@"%@ - %@", writer.name, currentPage.lblTitle.text], textToPost] isHTML:NO] ;
            [self presentModalViewController:mailController animated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Feature not available" message:@"Email is not available on this device" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    if (buttonIndex == 1) {
        CGFloat pageWidth = (isPortrait ? POEM_WIDTH : POEM_WIDTH_LANDSCAPE);
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        PoemViewController_iPad *currentPage = [pages objectAtIndex:page];
        
        NSString *textToPost = currentPage.lblContent.text;
        if (currentPage.lblContent.selectedRange.location != NSNotFound && currentPage.lblContent.selectedRange.length > 0) {
            textToPost = [textToPost substringWithRange:currentPage.lblContent.selectedRange];
        }
        
        //textToPost = [textToPost stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"];
        
        fbParams = [NSMutableDictionary  dictionaryWithObjectsAndKeys:
                    @"Share on Facebook",  @"user_message_prompt",
                    [[SettingsManager current] getFacebookURL], @"link",
                    [NSString stringWithFormat:@"%@ - %@", writer.name, currentPage.lblTitle.text], @"name",
                    [[SettingsManager current] getFacebookImageURL], @"picture",
                    textToPost, @"description",
                    nil];
        
        [FacebookManager current].delegate = self;
        [[FacebookManager current] facebookLogin];
    }

    if (buttonIndex == 2) {
        CGFloat pageWidth = (isPortrait ? POEM_WIDTH : POEM_WIDTH_LANDSCAPE);
        int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        PoemViewController_iPad *currentPage = [pages objectAtIndex:page];
        
        NSString *textToPost = currentPage.lblContent.text;
        if (currentPage.lblContent.selectedRange.location != NSNotFound && currentPage.lblContent.selectedRange.length > 0) {
            textToPost = [textToPost substringWithRange:currentPage.lblContent.selectedRange];
        }
        
        if (!_engine){
            _engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
            _engine.consumerKey    = kOAuthConsumerKey;
            _engine.consumerSecret = kOAuthConsumerSecret;
        }
        
        if (![_engine isAuthorized]){
            UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];
            if (controller) {
                [self presentModalViewController: controller animated: YES];
            }
        } else {
            NSString *title = [NSString stringWithFormat:@"%@ %@ \n%@",[[SettingsManager current] getTwitterTitle], [NSString stringWithFormat:@"%@ - %@", writer.name, currentPage.lblTitle.text], textToPost];
            [_engine sendUpdate:title];
        }
    }
}

- (IBAction)addToFavorites:(id)sender {
    CGFloat pageWidth = (isPortrait ? POEM_WIDTH : POEM_WIDTH_LANDSCAPE);
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    Song *p = [poems objectAtIndex:page];
    [[StorageManager current] addFavoriteFor:writer.name andSong:p.title];
    
    PoemViewController_iPad *currentPage = [pages objectAtIndex:page];
    
    UIGraphicsBeginImageContext(currentPage.view.bounds.size);
    [currentPage.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *tempImage = [[UIImageView alloc] initWithImage:viewImage];
    tempImage.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, (isPortrait ? POEM_WIDTH : POEM_WIDTH_LANDSCAPE), (isPortrait ? POEM_HEIGHT : POEM_HEIGHT_LANDSCAPE));    
    [self.view addSubview:tempImage];
    
    [UIView animateWithDuration:1.5f
                          delay:0.0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{                              
                              tempImage.frame = CGRectMake(self.view.frame.size.width - 140, 0, 0, 0);
                          }
                     completion:^(BOOL finished) {
                         if (finished) { 
                             tempImage.image = nil;
                         }
                     }];     

}

- (void)loadScrollViewWithPage:(int)page {
    
    if (page < 0) 
        return;
    if (page > [pages count] - 1) 
        return;
    
    PoemViewController_iPad *currentPage = [pages objectAtIndex:page];
    if ((NSNull *)currentPage == [NSNull null]) {
        Song *poetry = [poems objectAtIndex:page];
        currentPage = [[PoemViewController_iPad alloc] initWithPoem:poetry.title andContent:poetry.content];                
        [pages replaceObjectAtIndex:page withObject:currentPage];
    }
    
    if (currentPage.view.superview == nil) {
        
        CGRect frame;
        frame.origin.x = (isPortrait ? POEM_WIDTH : POEM_WIDTH_LANDSCAPE) * page;
        frame.origin.y = 0;
        frame.size.width = (isPortrait ? POEM_WIDTH : POEM_WIDTH_LANDSCAPE);
        frame.size.height = (isPortrait ? POEM_HEIGHT : POEM_HEIGHT_LANDSCAPE);
        currentPage.view.frame = frame;      
        
        [self.scrollView addSubview:currentPage.view];
    }    
}

- (void)initScrollView {
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake((isPortrait ? POEM_WIDTH : POEM_WIDTH_LANDSCAPE) * poems.count, (isPortrait ? POEM_HEIGHT : POEM_HEIGHT_LANDSCAPE));
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < poems.count; i++)
        [controllers addObject:[NSNull null]];
    
    pages = controllers;
    
    self.pageControl.numberOfPages = poems.count;
    self.pageControl.currentPage = requestedPoemNumber;
    
    [self loadScrollViewWithPage:requestedPoemNumber - 1];
    [self loadScrollViewWithPage:requestedPoemNumber];
    [self loadScrollViewWithPage:requestedPoemNumber + 1];
    
    CGRect frame = scrollView.frame;        
    frame.origin.x = (isPortrait ? POEM_WIDTH : POEM_WIDTH_LANDSCAPE) * requestedPoemNumber;
    frame.origin.y = 0;
    
    [self.scrollView scrollRectToVisible:frame animated:NO];
    
}

- (void)restartScroll {
    for (PoemViewController_iPad *p in pages) {
        if ((NSNull *)p != [NSNull null]) {
            [p.view removeFromSuperview];            
        }
    }
    
    pages = nil;
    
    [self initScrollView];
}

#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = (isPortrait ? POEM_WIDTH : POEM_WIDTH_LANDSCAPE);
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = (isPortrait ? POEM_WIDTH : POEM_WIDTH_LANDSCAPE);
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth)+ 1;
    requestedPoemNumber = page;
    Song *p = [poems objectAtIndex:page];
    addToFavs.hidden = [[StorageManager current] favoriteExists:writer.name andSong:p.title];
}

#pragma mark - Mail and SMS delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissModalViewControllerAnimated:YES];
}

#pragma mark - Facebook delegate

- (void)fbLoaded:(NSString *)msg {
    
    if ([msg isEqualToString:@"fbDidLogin"]) {
        [[FacebookManager current] getfbName];
        return;
    } else if ([msg isEqualToString:@"logined"]) {
        [[FacebookManager current] publishStream:fbParams]; 
        return;
    } else if (msg != @"") {
        [[FacebookManager current] publishStream:fbParams];
        return;
    }
}

- (void)fbFailedWithError:(NSError *)error {
    
    NSString *errorDescription = [error localizedDescription];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook Connect Fail" message:errorDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark SA_OAuthTwitterEngineDelegate

- (void)storeCachedTwitterOAuthData:(NSString *)data forUsername:(NSString *)username {
    SettingsManager *sm = [SettingsManager current];	
    [sm setString:data keyString:@"twitterAuthData"];
    [sm setString:username keyString:@"twitterName"];    
	[sm saveToNSUserDefaults:@"MSGSettings"];
    
    [self performSelectorOnMainThread:@selector(postOnTwitter:) withObject:nil waitUntilDone:NO];        
}

- (void)postOnTwitter:(id)sender {
    
    CGFloat pageWidth = POEM_WIDTH;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;               
    PoemViewController_iPad *currentPage = [pages objectAtIndex:page];
    
    NSString *textToPost = currentPage.lblContent.text;
    if (currentPage.lblContent.selectedRange.location != NSNotFound && currentPage.lblContent.selectedRange.length > 0) {
        textToPost = [textToPost substringWithRange:currentPage.lblContent.selectedRange];
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %@ %@",[[SettingsManager current] getTwitterTitle], [[SettingsManager current] getFacebookURL], [NSString stringWithFormat:@"%@ - %@", writer.name, textToPost]];
    [_engine sendUpdate:title];
}

- (NSString *)cachedTwitterOAuthDataForUsername: (NSString *) username {
    SettingsManager *sm = [SettingsManager current];
	[[SettingsManager current] loadFromNSUserDefaults:@"MSGSettings"];
   	return [sm getString:@"twitterAuthData"];
}

#pragma mark TwitterEngineDelegate

- (void)requestSucceeded:(NSString *)requestIdentifier {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"The message has been sent to Twitter!" delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)requestFailed:(NSString *)requestIdentifier withError:(NSError *)error {
    NSString *errorDescription = [error localizedDescription];
    NSString *tweetExists = @"403";
    
    NSRange range = [errorDescription rangeOfString:tweetExists];
    if (range.location == NSNotFound) {    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail" message:errorDescription delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Fail" message:@"Tweet was already posted." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil, nil];
        [alert show];
    }
}

@end
