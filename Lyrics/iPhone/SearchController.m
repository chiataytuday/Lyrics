//
//  SearchController.m
//  rPoezie
//
//  Created by Daniel Cristolovean on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchController.h"
#import "Band.h"
#import "Song.h"
#import "AuthorCell.h"
#import "PoemCell.h"
#import "PoemsController.h"
#import "PoemsListController.h"
#import "StorageManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation SearchController

@synthesize lblInfo, lblNoInfo;

@synthesize tableView, searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //self.title = @"Cautare";
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Search band or song";
    //[searchBar becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = YES;
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Search delegates

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        searchData = [[StorageManager current] getSearchData:searchText];
        lblInfo.hidden = searchData && searchData.count > 0;
        lblNoInfo.hidden = searchData && searchData.count > 0;
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
    self.searchBar.showsCancelButton = NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return searchData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *obj = [searchData objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[Band class]]) {
        return 61.0f;
    }
    
    if ([obj isKindOfClass:[Song class]]) {
        return 39.0f;
    }
    
    return 44.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *obj = [searchData objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[Band class]]) {
        
        Band *writer = (Band *)obj;
        
        static NSString *CellIdentifier = @"Cell";
        AuthorCell *cell = (AuthorCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"AuthorCell" owner:nil options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = (AuthorCell *)currentObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }
        
        cell.authorImage.image = [UIImage imageWithData:writer.picture];
        
        CALayer *l = [cell.authorImage layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:5.0f];
        [l setBorderColor:[UIColor colorWithRed:166.0 / 255.0 green:166.0 / 255.0 blue:166.0 / 255.0 alpha:1.0].CGColor];
        [l setBorderWidth:1.0];
        
        cell.authorName.text = writer.name;
        //cell.authorYears.text = [NSString stringWithFormat:@"%@-%@", writer.birthYear, writer.deathYear];
        
        cell.authorPoems.text = [NSString stringWithFormat:@"%i songs", writer.songs.count];
        return cell;
    }
    
    if ([obj isKindOfClass:[Song class]]) {
        
        Song *poem = (Song *)obj;
        
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
        
        cell.poemName.text = poem.title;
        
        return cell;
    }
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *obj = [searchData objectAtIndex:indexPath.row];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];

    self.navigationItem.backBarButtonItem = backButton;
    
    if ([obj isKindOfClass:[Band class]]) {
        
        PoemsListController *poemsList = [[PoemsListController alloc] init];
        poemsList.writer = (Band *)obj;
        [self.navigationController pushViewController:poemsList animated:YES];
    }
    
    if ([obj isKindOfClass:[Song class]]) {
        
        PoemsController *poemsController = [[PoemsController alloc] init];
        poemsController.writer = [[StorageManager current] getBandForSong:(Song *)obj];
        poemsController.requestedPoemNumber = [[StorageManager current] getPositionForSong:(Song *)obj];
        [self.navigationController pushViewController:poemsController animated:YES];
    }
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setSearchBar:nil];
    [self setLblInfo:nil];
    [self setLblNoInfo:nil];
    [super viewDidUnload];
}

@end
