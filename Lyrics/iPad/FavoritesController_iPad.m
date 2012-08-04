//
//  FavoritesController_iPad.m
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoritesController_iPad.h"
#import "AuthorCell.h"
#import "PoemCellFavorites.h"
#import "StorageManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation FavoritesController_iPad
@synthesize lbl1;
@synthesize lbl2;

@synthesize editButton, tableView, navBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Favorites";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
       
    favorites = [[StorageManager current] getFavorites];
    [self.tableView reloadData];

    editButton.title = @"Edit";
    
    lbl1.hidden = favorites && favorites.count > 0;
    lbl2.hidden = lbl1.hidden;
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setNavBar:nil];
    [self setEditButton:nil];
    [self setLbl1:nil];
    [self setLbl2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - Table view data source

- (void)editTable:(id)sender {
    
    [self.tableView setEditing:!self.tableView.isEditing];
    
    if (self.tableView.isEditing)
        editButton.title = @"Done";
    else {
        
        editButton.title = @"Edit";
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSObject *obj = [favorites objectAtIndex:indexPath.row];
        
        if ([obj isKindOfClass:[Band class]]) {
            Band *writer = (Band *)obj;
            [[StorageManager current] removeFavorite:writer.name andSong:@" "];
        }
        
        if ([obj isKindOfClass:[Song class]]) {
            Song *poetry = (Song *)obj;
            [[StorageManager current] removeFavorite:poetry.band.name andSong:poetry.title];
        }
        
        [favorites removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return favorites.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 61.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSObject *obj = [favorites objectAtIndex:indexPath.row];
    
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
        cell.authorPoems.text = @"";
        
        return cell;
    }
    
    if ([obj isKindOfClass:[Song class]]) {
        
        Song *poem = (Song *)obj;
        
        static NSString *CellIdentifier = @"Cell";
        
        PoemCellFavorites *cell = (PoemCellFavorites *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"PoemCellFavorites" owner:nil options:nil];
            for (id currentObject in topLevelObjects) {
                if ([currentObject isKindOfClass:[UITableViewCell class]]) {
                    cell = (PoemCellFavorites *)currentObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }
        
        cell.lblPoemName.text = poem.title;
        cell.lblAuthor.text = poem.band.name;
        
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
      
    NSObject *obj = [favorites objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[Band class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FavoriteAuthorSelected" object:obj]; 
    }
    
    if ([obj isKindOfClass:[Song class]]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"FavoritePoemSelected" object:obj];        
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

@end
