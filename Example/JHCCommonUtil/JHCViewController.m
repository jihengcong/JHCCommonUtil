//
//  JHCViewController.m
//  JHCCommonUtil
//
//  Created by jihengcong on 01/13/2022.
//  Copyright (c) 2022 jihengcong. All rights reserved.
//

#import "JHCViewController.h"
#import "JHCCommonUtil.h"


@interface JHCViewController ()

@end

@implementation JHCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"测试: %@", [JHCCommonUtil getTimestampSince1970]);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
