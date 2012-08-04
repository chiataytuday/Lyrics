//
//  FavoritesController.h
//  rPoezie
//
//  Created by Daniel Cristolovean on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoritesController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray *favorites;
}

@property (unsafe_unretained, nonatomic) IBOutlet UITableView *tableView;

@end
