//
//  PoemsController_iPad.h
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Song.h"
#import "Band.h"
#import "SA_OAuthTwitterController.h"
#import "SA_OAuthTwitterEngine.h"
#import <MessageUI/MessageUI.h>

@interface PoemsController_iPad : UIViewController <UIScrollViewDelegate, SA_OAuthTwitterControllerDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
    
    NSMutableArray *pages;
    NSArray *poems;
    Band *writer;
    int requestedPoemNumber;    
    NSMutableDictionary *fbParams;    
    SA_OAuthTwitterEngine  *_engine;    
    UIPopoverController *mainPopOver;
    BOOL isPortrait;
}

@property (nonatomic) int requestedPoemNumber;
@property (nonatomic, strong) Band *writer;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIButton *addToFavs;

- (IBAction)addToFavorites:(id)sender;

@end
