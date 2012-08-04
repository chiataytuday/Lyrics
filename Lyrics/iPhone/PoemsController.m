//
//  PoemsController.m
//  rPoezie
//
//  Created by Daniel Cristolovean on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PoemsController.h"
#import "PoemViewController.h"
#import "FacebookManager.h"
#import "SettingsManager.h"
#import "StorageManager.h"
#import "Additions.h"
#import "WebViewController.h"
#import "FavoritesController.h"
#import "SearchController.h"
#import "InfoController.h"
#import <QuartzCore/QuartzCore.h>

#define POEM_WIDTH 320

@implementation PoemsController

@synthesize addToFavs, scrollView, pageControl, writer, requestedPoemNumber;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *youTube = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"youtube.png"] style:UIBarButtonItemStylePlain target:self action:@selector(searchYouTube)];
        self.navigationItem.rightBarButtonItem = youTube;
    }
    return self;
}

- (void)loadScrollViewWithPage:(int)page {
    
    if (page < 0) 
        return;
    if (page > [pages count] - 1) 
        return;
    
    PoemViewController *currentPage = [pages objectAtIndex:page];
    if ((NSNull *)currentPage == [NSNull null]) {
        Song *poetry = [poems objectAtIndex:page];
        currentPage = [[PoemViewController alloc] initWithPoem:poetry.title andContent:poetry.content];                
        [pages replaceObjectAtIndex:page withObject:currentPage];
    }
    
    if (currentPage.view.superview == nil) {
        
        CGRect frame;
        frame.origin.x = POEM_WIDTH * page;
        frame.origin.y = 0;
        frame.size.width = POEM_WIDTH;
        frame.size.height = 350;
        currentPage.view.frame = frame;
        currentPage.lblContent.font = [UIFont systemFontOfSize:[[SettingsManager current] getTextFontSize]];
        
        [self.scrollView addSubview:currentPage.view];
    }    
}

- (void)initScrollView {
    self.scrollView.pagingEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(POEM_WIDTH * poems.count, 350);
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
    frame.origin.x = POEM_WIDTH * requestedPoemNumber;
    frame.origin.y = 0;
       
    [self.scrollView scrollRectToVisible:frame animated:NO];
}

- (void)searchYouTube {
    CGFloat pageWidth = POEM_WIDTH;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    Song *p = [poems objectAtIndex:page];
       
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://www.youtube.com/results?search_query=%@+%@", [writer.name stringByReplacingOccurrencesOfString:@" " withString:@"+"] , [[p.title stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];;
    
    WebViewController *webController = [[WebViewController alloc] init];
    webController.url = url;
    webController.title = @"Videos";
    [self.navigationController pushViewController:webController animated:YES];
}

#pragma mark - ScrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat pageWidth = POEM_WIDTH;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
    
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = POEM_WIDTH;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth)+ 1;
    Song *p = [poems objectAtIndex:page];
    addToFavs.hidden = [[StorageManager current] favoriteExists:writer.name andSong:p.title];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];  
       
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
    
    [[SettingsManager current] setTextFontSize:14];
    
    [self initScrollView];
    
    Song *p = [poems objectAtIndex:0];
    addToFavs.hidden = [[StorageManager current] favoriteExists:writer.name andSong:p.title];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setAddToFavs:nil];
    [super viewDidUnload];
}

- (IBAction)home:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)cmdFavoritesTouchUpInside:(id)sender {
    
    CGFloat pageWidth = POEM_WIDTH;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    Song *p = [poems objectAtIndex:page];
    [[StorageManager current] addFavoriteFor:writer.name andSong:p.title];
        
    PoemViewController *currentPage = [pages objectAtIndex:page];
    
    UIGraphicsBeginImageContext(currentPage.view.bounds.size);
    [currentPage.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *tempImage = [[UIImageView alloc] initWithImage:viewImage];
    tempImage.frame = CGRectMake(scrollView.frame.origin.x, scrollView.frame.origin.y, POEM_WIDTH, 300);    
    [self.view addSubview:tempImage];
    
    [UIView animateWithDuration:1.5f
                          delay:0.0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{                              
                              tempImage.frame = CGRectMake(250, 10, 0, 0);
                          }
                     completion:^(BOOL finished) {
                         if (finished) { 
                             tempImage.image = nil;
                         }
                     }];
    
    addToFavs.hidden = YES;
}

- (IBAction)share:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Share Lyrics" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Email", @"SMS", @"Facebook", @"Twitter", nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (IBAction)favorites:(id)sender {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    FavoritesController *favorites = [[FavoritesController alloc] init];
    [self.navigationController pushViewController:favorites animated:YES];
}

- (IBAction)search:(id)sender {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    SearchController *search = [[SearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

- (IBAction)info:(id)sender {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    InfoController *info = [[InfoController alloc] init];
    [self.navigationController pushViewController:info animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    CGFloat pageWidth = POEM_WIDTH;
    int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    PoemViewController *currentPage = [pages objectAtIndex:page];
    
    NSString *textToPost = currentPage.lblContent.text;
    if (currentPage.lblContent.selectedRange.location != NSNotFound && currentPage.lblContent.selectedRange.length > 0) {
        textToPost = [textToPost substringWithRange:currentPage.lblContent.selectedRange];
    }
    
    if (buttonIndex == 2) {
        
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
    
    if (buttonIndex == 3) {
        
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
    
    if (buttonIndex == 1) {
        if ([MFMessageComposeViewController canSendText]) {
            MFMessageComposeViewController *smsController = [[MFMessageComposeViewController alloc] init];
            smsController.messageComposeDelegate = self;
            smsController.body = [NSString stringWithFormat:@"%@ %@ \n%@",[[SettingsManager current] getTwitterTitle], [NSString stringWithFormat:@"%@ - %@", writer.name, currentPage.lblTitle.text], textToPost];
            [self presentModalViewController:smsController animated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Feature not available" message:@"SMS is not available on this device" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }
    
    if (buttonIndex == 0) {
        if ([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc] init];
            mailController.mailComposeDelegate = self;
            [mailController setSubject:[[SettingsManager current] getFacebookName]];
            [mailController setMessageBody:[NSString stringWithFormat:@"%@ %@ \n\n%@",[[SettingsManager current] getTwitterTitle], [NSString stringWithFormat:@"%@ - %@", writer.name, currentPage.lblTitle.text], textToPost] isHTML:NO] ;
            [self presentModalViewController:mailController animated:YES];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Feature not available" message:@"Email is not available on this device" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    }

}

#pragma mark - Mail and SMS delegate

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissModalViewControllerAnimated:YES];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
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
    PoemViewController *currentPage = [pages objectAtIndex:page];
    
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
