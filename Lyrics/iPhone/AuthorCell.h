//
//  AuthorCell.h
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorCell : UITableViewCell

@property (unsafe_unretained, nonatomic) IBOutlet UIImageView *authorImage;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *authorName;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *authorYears;
@property (unsafe_unretained, nonatomic) IBOutlet UILabel *authorPoems;

@end
