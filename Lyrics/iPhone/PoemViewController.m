//
//  PoemViewController.m
//  PoeziiRomanesti
//
//  Created by Daniel Cristolovean on 2/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PoemViewController.h"

@implementation PoemViewController

@synthesize lblTitle, lblContent;

- (id)initWithPoem:(NSString *)title andContent:(NSString *)content {
    self = [super initWithNibName:@"PoemViewController" bundle:nil];
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
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
