//
//  ViewController.m
//  WKWebView
//
//  Created by xuchao on 16/10/11.
//  Copyright © 2016年 none. All rights reserved.
//

#import "ViewController.h"
#import "XCWKWebView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)click:(id)sender {
    XCWKWebView * web = [[XCWKWebView alloc] init];
    [self.navigationController pushViewController:web animated:YES];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
