//
//  SearchController_iPad.m
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SearchController_iPad.h"
#import "AuthorCell.h"
#import "PoemCell.h"
#import "StorageManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation SearchController_iPad

@synthesize lblNoInfo, lblInfo, tableView, searchBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [self setLblNoInfo:nil];
    [self setLblInfo:nil];
    [self setTableView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
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
        cell.authorName.text = writer.name;
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
      
    if ([obj isKindOfClass:[Band class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FavoriteAuthorSelected" object:obj]; 
    }
    
    if ([obj isKindOfClass:[Song class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FavoritePoemSelected" object:obj];        
    }
}

@end
