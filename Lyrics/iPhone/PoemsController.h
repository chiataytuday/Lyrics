//
//  PoemsController.h
//  rPoezie
//
//  Created by Daniel Cristolovean on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "Band.h"
#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"
#import <MessageUI/MessageUI.h>

@interface PoemsController : UIViewController <UIScrollViewDelegate, SA_OAuthTwitterControllerDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
        
    NSMutableArray *pages;
    NSArray *poems;
    Band *writer;
    int requestedPoemNumber;
    NSMutableDictionary *fbParams;
    SA_OAuthTwitterEngine  *_engine;
}

@property (nonatomic) int requestedPoemNumber;
@property (nonatomic, strong) Band *writer;
@property (unsafe_unretained, nonatomic) IBOutlet UIScrollView *scrollView;
@property (unsafe_unretained, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *addToFavs;

- (IBAction)home:(id)sender;
- (IBAction)cmdFavoritesTouchUpInside:(id)sender;
- (IBAction)share:(id)sender;
- (IBAction)favorites:(id)sender;
- (IBAction)search:(id)sender;
- (IBAction)info:(id)sender;

@end
