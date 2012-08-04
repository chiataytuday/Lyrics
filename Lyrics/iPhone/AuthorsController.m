//
//  AuthorsController.m
//  rPoezie
//
//  Created by Daniel Cristolovean on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthorsController.h"
#import "AuthorCell.h"
#import "Band.h"
#import "StorageManager.h"
#import "PoemsListController.h"
#import "FavoritesController.h"
#import "SearchController.h"
#import "SettingsManager.h"
#import "InfoController.h"
#import <QuartzCore/QuartzCore.h>

@implementation AuthorsController

@synthesize authorsTable;
@synthesize viewAds;

#pragma mark - ADS

- (NSString *)adWhirlApplicationKey {
    return AdWhirlAPI;
}

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Speed Metal & Thrash";
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];      
    authors = [[StorageManager current] getBands];
//    AdWhirlView *adWhirlView = [AdWhirlView requestAdWhirlViewWithDelegate:self];
//    adWhirlView.frame = viewAds.frame;
//    [self.viewAds addSubview:adWhirlView];
}

- (void)viewWillAppear:(BOOL)animated {    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.authorsTable deselectRowAtIndexPath:[self.authorsTable indexPathForSelectedRow] animated:YES];
}

- (void)viewDidUnload {
    [self setAuthorsTable:nil];
    [self setViewAds:nil];
    [super viewDidUnload];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [authors count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    AuthorCell *cell = (AuthorCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AuthorCell" owner:nil options:nil];
        for (id currentObject in topLevelObjects) {
            if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                cell = (AuthorCell *)currentObject;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }
    }
    
    Band *writer = [authors objectAtIndex:indexPath.row];
    
    cell.authorImage.image = [UIImage imageWithData:writer.picture];
    cell.authorName.text = writer.name;   
    cell.authorPoems.text = [NSString stringWithFormat:@"%i songs", writer.songs.count];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
           
    PoemsListController *poemsList = [[PoemsListController alloc] init];
    poemsList.writer = [authors objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:poemsList animated:YES];
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];
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

@end
