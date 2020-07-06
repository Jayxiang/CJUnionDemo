//
//  ViewController.m
//  CJXAlertView
//
//  Created by cjxjay on 2017/3/20.
//  Copyright © 2017年 cjxjay. All rights reserved.
//

#import "ViewController.h"
#import "CJXAlertView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)popView:(id)sender {
    CJXAlertView *cjxView = [[CJXAlertView alloc]initWithTitle:@"提示" messages:@"注意啦注意啦啊⚠️的发呆发呆如果同时重写了getter和setter方法，那么系统就不会帮你自动生成这个成员变量，所以当然报错说不认识这个成员变量。先手动生成成员变量，然后再同时重写了getter和setter方法。"cancelButtonTitle:@"确定"];
    [cjxView show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
