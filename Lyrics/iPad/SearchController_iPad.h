//
//  SearchController_iPad.h
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchController_iPad : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
    
    NSMutableArray *searchData;
}

@property (strong, nonatomic) IBOutlet UILabel *lblNoInfo;
@property (strong, nonatomic) IBOutlet UILabel *lblInfo;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
