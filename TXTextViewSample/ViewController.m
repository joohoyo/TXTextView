//
//  ViewController.m
//  TXTextViewSample
//
//  Created by Jang Jooho on 2014. 1. 29..
//  Copyright (c) 2014년 Jang Jooho. All rights reserved.
//

#import "ViewController.h"
#import "TXTextView.h"

@interface ViewController ()
@property (strong, nonatomic) TXTextView *textView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    self.textView = [[TXTextView alloc] init];
    self.textView.frame = self.view.bounds;
    self.textView.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    
    self.textView.lineSpacing = 10.0;
    
    self.textView.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:self.textView];
}

@end
