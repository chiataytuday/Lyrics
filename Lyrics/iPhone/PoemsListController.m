//
//  PoemsListController.m
//  rPoezie
//
//  Created by Daniel Cristolovean on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PoemsListController.h"
#import "Song.h"
#import "PoemCell.h"
#import "PoemsController.h"
#import "StorageManager.h"
#import "WebViewController.h"
#import "FavoritesController.h"
#import "SearchController.h"
#import "InfoController.h"
#import <QuartzCore/QuartzCore.h>

@implementation PoemsListController
@synthesize addToFavs;

@synthesize authorName, authorImage, tableView, writer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Songs";
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad]; 
       
    poems = [[NSArray alloc] init];
        
    if (writer) {
              
        authorName.text = writer.name;
        authorImage.image = [UIImage imageWithData:writer.picture];
        
        addToFavs.hidden = [[StorageManager current] favoriteExists:writer.name andSong:@" "];
        
        NSMutableArray *poemsUnsorted = [[NSMutableArray alloc] init];
 
        for (Song *p in writer.songs)
            [poemsUnsorted addObject:p];
               
        poems = [poemsUnsorted sortedArrayUsingComparator:^(id a, id b) {
            NSString *first = [(Song *)a title];
            NSString *second = [(Song *)b title];
            return [first compare:second];
        }];
        
        [tableView reloadData];
    }
    
    authorName.adjustsFontSizeToFitWidth = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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

    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
      
    PoemsController *poemsController = [[PoemsController alloc] init];
    poemsController.writer = writer;
    poemsController.requestedPoemNumber = indexPath.row;
    [self.navigationController pushViewController:poemsController animated:YES];
    
}

- (void)viewDidUnload {
    [self setAuthorImage:nil];
    [self setAuthorName:nil];
    [self setTableView:nil];
    [self setAddToFavs:nil];
    [super viewDidUnload];
}

- (IBAction)cmdFavTouchUpInside:(id)sender {
    
    [[StorageManager current] addFavoriteFor:writer.name andSong:@" "];
    
    UIImageView *tempImage = [[UIImageView alloc] initWithImage:[authorImage image]];
    tempImage.frame = authorImage.frame;
    tempImage.contentMode = authorImage.contentMode;
    CALayer *la2 = [tempImage layer];
    [la2 setMasksToBounds:YES];
    [la2 setCornerRadius:10.0f];
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
}

- (IBAction)cmdInfoTouchUpInside:(id)sender {
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;

    if ([writer.info hasPrefix:@"http"] || [writer.info hasPrefix:@"www"]) {
        NSURL *url = [NSURL URLWithString:writer.info];
        WebViewController *webController = [[WebViewController alloc] init];
        webController.url = url;
        webController.title = @"Wiki";
        [self.navigationController pushViewController:webController animated:YES];
    }
}

- (IBAction)home:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)search:(id)sender {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    SearchController *search = [[SearchController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

- (IBAction)favorites:(id)sender {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    FavoritesController *favorites = [[FavoritesController alloc] init];
    [self.navigationController pushViewController:favorites animated:YES];
}

- (IBAction)info:(id)sender {
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];    
    self.navigationItem.backBarButtonItem = backButton;
    
    InfoController *info = [[InfoController alloc] init];
    [self.navigationController pushViewController:info animated:YES];
}

- (IBAction)infoBand:(id)sender {
    [self cmdInfoTouchUpInside:sender];
}

@end
