//
//  FavoritesController.m
//  rPoezie
//
//  Created by Daniel Cristolovean on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FavoritesController.h"
#import "AuthorCell.h"
#import "PoemCellFavorites.h"
#import "Band.h"
#import "Song.h"
#import "StorageManager.h"
#import "PoemsController.h"
#import "PoemsListController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FavoritesController

@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Favorites";
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editTable:)];
        self.navigationItem.rightBarButtonItem = editButton;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    
    favorites = [[StorageManager current] getFavorites];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (void)editTable:(id)sender {

    [self.tableView setEditing:!self.tableView.isEditing];
    
    if (self.tableView.isEditing)
        self.navigationItem.rightBarButtonItem.title = @"Done";
    else {
        self.navigationItem.rightBarButtonItem.title = @"Edit";
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
    
#ifdef RO    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Înapoi" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
#endif  
    
#ifdef DE    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"zurück" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
#endif
    
    NSObject *obj = [favorites objectAtIndex:indexPath.row];
    
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
    [super viewDidUnload];
}

@end
