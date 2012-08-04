//
//  PoemViewController.h
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoemViewController : UIViewController {
 
    NSString *titleVal;
    NSString *contentVal;
}

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *lblTitle;
@property (unsafe_unretained, nonatomic) IBOutlet UITextView *lblContent;

- (id)initWithPoem:(NSString *)title andContent:(NSString *)content;

@end
