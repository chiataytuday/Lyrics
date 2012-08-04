//
//  FavoritesController_iPad.h
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesController_iPad : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray *favorites;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;
@property (strong, nonatomic) IBOutlet UILabel *lbl1;
@property (strong, nonatomic) IBOutlet UILabel *lbl2;

- (IBAction)editTable:(id)sender;

@end
