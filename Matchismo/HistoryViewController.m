//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Michael Jacob Focshaner on 13/08/2018.
//  Copyright © 2018 Michael Focshaner. All rights reserved.
//

#import "HistoryViewController.h"

@interface HistoryViewController ()

@property (strong, nonatomic) IBOutlet UITextView *historyLabel;

@end

@implementation HistoryViewController

- (void)viewDidLoad {
    _historyLabel.attributedText = self.historyString;
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation*/


@end
