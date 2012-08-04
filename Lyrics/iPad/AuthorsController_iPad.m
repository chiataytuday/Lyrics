//
//  AuthorsController_iPad.m
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthorsController_iPad.h"
#import "AuthorCell.h"
#import "Song.h"
#import "Band.h"
#import "StorageManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation AuthorsController_iPad

@synthesize authorsTable;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Bands";
    }
    return self;
}

- (void)authorSelected:(id)sender {
    NSNotification *notification = (NSNotification *)sender;
    if (notification) {
        Band *writer = (Band *)notification.object;
        int index = 0;
        for (Band *w in authors) {
            if ([w.name isEqualToString:writer.name]) {
                break;
            }
            index++;
        }
        
        [authorsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthorSelected" object:[authors objectAtIndex:index]];
    }
}

- (void)poemSelected:(id)sender {
    NSNotification *notification = (NSNotification *)sender;
    if (notification) {
        Song *poem = (Song *)notification.object;
        Band *writer = poem.band;
        int index = 0;
        for (Band *w in authors) {
            if ([w.name isEqualToString:writer.name]) {
                break;
            }
            index++;
        }
        
        [authorsTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];      
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(authorSelected:) name:@"FavoriteAuthorSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(poemSelected:) name:@"FavoritePoemSelected" object:nil];
    
    authors = [[StorageManager current] getBands];
       
}

- (void)viewWillAppear:(BOOL)animated {    
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.authorsTable deselectRowAtIndexPath:[self.authorsTable indexPathForSelectedRow] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [self setAuthorsTable:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthorSelected" object:[authors objectAtIndex:indexPath.row]];
}

@end
