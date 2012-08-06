//
//  PoemsListController_iPad.m
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PoemsListController_iPad.h"
#import "PoemCell.h"
#import "StorageManager.h"
#import "PoemsController_iPad.h"
#import "InfoController_iPad.h"
#import "FavoritesController_iPad.h"
#import "SearchController_iPad.h"
#import "WebViewController_iPad.h"
#import <QuartzCore/QuartzCore.h>

@implementation PoemsListController_iPad
@synthesize addToFavs;

@synthesize viewIntro, viewPoems, authorImage, authorName, authorYears, tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray array]];
        segmentedControl.frame = CGRectMake(150, 5, 150, 30);
        [segmentedControl setMomentary:YES];
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"search.png"] atIndex:0 animated:NO];
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"favorites.png"] atIndex:1 animated:NO];        
        [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"settings.png"] atIndex:2 animated:NO];
        segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        [segmentedControl addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
        
        UIBarButtonItem *segmentBarItem = [[UIBarButtonItem alloc] initWithCustomView: segmentedControl];
        self.navigationItem.rightBarButtonItem = segmentBarItem;
        
        self.title = @"Lyrics";

    }
    return self;
}

#pragma mark - Actions & Selectors

- (void)updateLayout {
   
    poems = [[NSArray alloc] init];
    
    if (writer) {
        authorName.text = writer.name;
        authorImage.image = [UIImage imageWithData:writer.picture];
        NSMutableArray *poemsUnsorted = [[NSMutableArray alloc] init];
        
        addToFavs.hidden = [[StorageManager current] favoriteExists:writer.name andSong:@" "];
        
        for (Song *p in writer.songs)
            [poemsUnsorted addObject:p];
        
        poems = [poemsUnsorted sortedArrayUsingComparator:^(id a, id b) {
            NSString *first = [(Song *)a title];
            NSString *second = [(Song *)b title];
            return [first compare:second];
        }];
        
        [tableView reloadData];
    }
}

- (void)authorSelected:(id)sender {

    [self.navigationController popToRootViewControllerAnimated:YES];
    
    viewIntro.hidden = YES;
    viewPoems.hidden = NO;
    
    NSNotification *notification = (NSNotification *)sender;
    if (notification) {
        writer = (Band *)notification.object;
        self.title = writer.name;
        [self updateLayout];
        [tableView setContentOffset:CGPointMake(0, 0) animated:NO];
    }
    
    [popOver dismissPopoverAnimated:YES];   
    if (mainPopOver)
        [mainPopOver dismissPopoverAnimated:YES];
    
    segmentedControl.frame = CGRectMake(130, 5, 230, 30);
    [segmentedControl insertSegmentWithImage:[UIImage imageNamed:@"info.png"] atIndex:3 animated:NO];

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
        [self seeInformation:nil];
    }
}

- (void)dismissPopup {
    if (mainPopOver)
        [mainPopOver dismissPopoverAnimated:YES];
}

- (void)poemSelected:(id)sender {
    [popOver dismissPopoverAnimated:YES];
    [self dismissPopup];
    
    viewIntro.hidden = YES;
    viewPoems.hidden = NO;
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    NSNotification *notification = (NSNotification *)sender;
    if (notification) {
        Song *poem = (Song *)notification.object;
        writer = poem.band;
        [self updateLayout];
        
        PoemsController_iPad *poemsController = [[PoemsController_iPad alloc] init];
        poemsController.writer = writer;
        poemsController.requestedPoemNumber = [[StorageManager current] getPositionForSong:poem];
        [self.navigationController pushViewController:poemsController animated:YES];         
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return poems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 39.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    PoemCell *cell = (PoemCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PoemCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (PoemCell *)currentObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }
    
    Song *poem = [poems objectAtIndex:indexPath.row];
    cell.poemName.text = poem.title;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
#ifdef RO
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Înapoi" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
#endif
    
#ifdef DE    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"zurück" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
#endif
    
    PoemsController_iPad *poemsController = [[PoemsController_iPad alloc] init];
    poemsController.writer = writer;
    poemsController.requestedPoemNumber = indexPath.row;
    [self.navigationController pushViewController:poemsController animated:YES];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad]; 
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorSelected:) name:@"AuthorSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissPopup) name:@"FavoriteAuthorSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(poemSelected:) name:@"FavoritePoemSelected" object:nil];
}

- (void)viewDidUnload {
    [self setViewIntro:nil];
    [self setViewPoems:nil];
    [self setAuthorImage:nil];
    [self setAuthorName:nil];
    [self setAuthorYears:nil];
    [self setTableView:nil];
    [self setAddToFavs:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - UISplitViewController delegate

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    //[barButtonItem setTitle:[[SettingsManager current] getAuthorsTitle]];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    self.navigationItem.leftBarButtonItem = nil; 
}

- (void)splitViewController:(UISplitViewController *)svc popoverController:(UIPopoverController *)pc willPresentViewController:(UIViewController *)aViewController {
    popOver = pc;
}

- (IBAction)addToFavorites:(id)sender {
    [[StorageManager current] addFavoriteFor:writer.name andSong:@" "];
    
    UIImageView *tempImage = [[UIImageView alloc] initWithImage:[authorImage image]];
    tempImage.frame = authorImage.frame;
    tempImage.contentMode = authorImage.contentMode;
    CALayer *la2 = [tempImage layer];
    [la2 setMasksToBounds:YES];
    [la2 setCornerRadius:10.0f];
    [la2 setBorderColor:[UIColor colorWithRed:45.0 / 255.0 green:45.0 / 255.0 blue:45.0 / 255.0 alpha:1.0].CGColor];
    [la2 setBorderWidth:1.0];
    [self.view addSubview:tempImage];
    
    [UIView animateWithDuration:1.5f
                          delay:0.0 options:UIViewAnimationCurveLinear | UIViewAnimationOptionAllowUserInteraction animations:^{                              
                              tempImage.frame = CGRectMake(self.view.frame.size.width - 50, 0, 0, 0);                              
                          }
                     completion:^(BOOL finished) {
                         if (finished) { 
                             tempImage.image = nil;
                         }
                     }];
    addToFavs.hidden = YES;
    
}

- (IBAction)seeInformation:(id)sender {
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    if ([writer.info hasPrefix:@"http"] || [writer.info hasPrefix:@"www"]) {
        NSURL *url = [NSURL URLWithString:writer.info];
        WebViewController_iPad *webController = [[WebViewController_iPad alloc] init];
        webController.url = url;
        webController.title = @"Wiki";
        [self.navigationController pushViewController:webController animated:YES];
    }
}

@end
