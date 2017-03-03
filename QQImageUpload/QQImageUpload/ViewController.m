//
//  ViewController.m
//  QQImageUpload
//
//  Created by Frank-Lee on 17/3/3.
//  Copyright © 2017年 Frank-Lee. All rights reserved.
//

#import "ViewController.h"
#import "XWPublishController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"发布" forState:normal];
    [button setTitleColor:[UIColor whiteColor] forState:normal];
    button.backgroundColor = [UIColor purpleColor];
    [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    button.frame = CGRectMake(100, 100, 100, 50);
    
    
}
-(void)buttonClick {
    XWPublishController *publishVC = [[XWPublishController alloc] init];
    [self presentViewController:publishVC animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
