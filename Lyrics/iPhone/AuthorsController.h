//
//  AuthorsController.h
//  rPoezie
//
//  Created by Daniel Cristolovean on 1/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorsController : UIViewController <UITableViewDataSource, UITableViewDelegate> {

    NSMutableArray *authors;
}

@property (unsafe_unretained, nonatomic) IBOutlet UITableView *authorsTable;
@property (strong, nonatomic) IBOutlet UIView *viewAds;

- (IBAction)search:(id)sender;
- (IBAction)favorites:(id)sender;
- (IBAction)info:(id)sender;

@end
