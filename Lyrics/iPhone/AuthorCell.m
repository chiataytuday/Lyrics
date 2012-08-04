//
//  AuthorCell.m
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 2/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AuthorCell.h"

@implementation AuthorCell
@synthesize authorImage;
@synthesize authorName;
@synthesize authorYears;
@synthesize authorPoems;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
//    if (selected) {
//        authorName.textColor = [UIColor blackColor];
//        authorYears.textColor = [UIColor blackColor];
//        self.backgroundColor = [UIColor colorWithRed:180.0 / 255.0 green:131.0f / 255.0 blue:44.0f / 255.0 alpha:1.0];
//        self.alpha = 0.5f;
//    } else {
//        authorName.textColor = [UIColor colorWithRed:114.0 / 255.0 green:72.0f / 255.0 blue:40.0f / 255.0 alpha:1.0];
//        authorYears.textColor = [UIColor colorWithRed:179.0 / 255.0 green:144.0f / 255.0 blue:111.0f / 255.0 alpha:1.0];
//        self.backgroundColor = [UIColor clearColor];
//        self.alpha = 1.0f;
//    }

    // Configure the view for the selected state
}

@end
