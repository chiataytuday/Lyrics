//
//  AuthorsController_iPad.h
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Band.h"

@interface AuthorsController_iPad : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSMutableArray *authors;
}

@property (strong, nonatomic) IBOutlet UITableView *authorsTable;

@end
