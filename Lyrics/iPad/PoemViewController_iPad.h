//
//  PoemViewController_iPad.h
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoemViewController_iPad : UIViewController {
    NSString *titleVal;
    NSString *contentVal;       
}

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UITextView *lblContent;

- (id)initWithPoem:(NSString *)title andContent:(NSString *)content;

@end
