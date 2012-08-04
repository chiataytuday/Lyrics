//
//  PoemCellFavorites.m
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PoemCellFavorites.h"

@implementation PoemCellFavorites
@synthesize lblPoemName;
@synthesize lblAuthor;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
//    if (selected) {
//        lblPoemName.textColor = [UIColor blackColor];     
//        lblAuthor.textColor = [UIColor blackColor];    
//        self.backgroundColor = [UIColor colorWithRed:180.0 / 255.0 green:131.0f / 255.0 blue:44.0f / 255.0 alpha:1.0];
//        self.alpha = 0.5f;
//    } else {
//        lblPoemName.textColor = [UIColor colorWithRed:114.0 / 255.0 green:72.0f / 255.0 blue:40.0f / 255.0 alpha:1.0];
//        lblAuthor.textColor = [UIColor colorWithRed:114.0 / 255.0 green:72.0f / 255.0 blue:40.0f / 255.0 alpha:1.0];
//        self.backgroundColor = [UIColor clearColor];
//        self.alpha = 1.0f;
//    }
    
}

@end
