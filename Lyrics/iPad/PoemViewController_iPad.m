//
//  PoemViewController_iPad.m
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PoemViewController_iPad.h"

@implementation PoemViewController_iPad

@synthesize lblTitle, lblContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithPoem:(NSString *)title andContent:(NSString *)content {
    self = [super initWithNibName:@"PoemViewController_iPad" bundle:nil];
    if (self) {
        titleVal = title;
        contentVal = content;
    }
    
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    lblTitle.text = titleVal;
    lblContent.text = contentVal;
}

- (void)viewDidUnload {
    [self setLblTitle:nil];
    [self setLblContent:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

@end
