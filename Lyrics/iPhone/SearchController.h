//
//  SearchController.h
//  rPoezie
//
//  Created by Daniel Cristolovean on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate> {
 
    NSMutableArray *searchData;
}

@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;
@property (unsafe_unretained, nonatomic) IBOutlet UISearchBar *searchBar;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblInfo;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblNoInfo;

@end
