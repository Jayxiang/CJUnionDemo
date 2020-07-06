//
//  ViewController.m
//  CJXTimer
//
//  Created by cjxjay on 2017/3/20.
//  Copyright © 2017年 cjxjay. All rights reserved.
//

#import "ViewController.h"
#import "CJXTimer.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *nstimerBtn;
@property (weak, nonatomic) IBOutlet UIButton *gcdBtn;
@property (weak, nonatomic) IBOutlet UIButton *cadBtn;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger count1;
@property (nonatomic, strong) CADisplayLink *displaylink;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)nsClick:(id)sender {
    _count = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
//    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
- (void)updateTimer {
    _count--;
    NSLog(@"%ld",(long)_count);
    if (_count <= 0) {
        [self.nstimerBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        self.nstimerBtn.userInteractionEnabled = YES;
        [self.timer invalidate];
        self.timer = nil;
    } else {
        [self.nstimerBtn setTitle:[NSString stringWithFormat:@"%ld秒后开始",(long)_count] forState:UIControlStateNormal];
        self.nstimerBtn.userInteractionEnabled = NO;
    }
}

- (IBAction)gcdClick:(id)sender {
    [CJXTimer initWithGCD:60 beginState:^(NSInteger seconds){
        [self.gcdBtn setTitle:[NSString stringWithFormat:@"%ld秒后开始",(long)seconds] forState:UIControlStateNormal];
        self.gcdBtn.userInteractionEnabled = NO;
        NSLog(@"%ld",(long)seconds);
    } endState:^() {
        [self.gcdBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        self.gcdBtn.userInteractionEnabled = YES;
    }];
}
- (IBAction)cadClick:(id)sender {
    _count1 = 60;
    self.displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateC)];
    self.displaylink.preferredFramesPerSecond = 2;
    [self.displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}
- (void)updateC {
    _count1--;
    
    if (_count1 <= 0) {
        [self.cadBtn setTitle:@"重新发送" forState:UIControlStateNormal];
        self.cadBtn.userInteractionEnabled = YES;
        [self.displaylink invalidate];
    } else {
        [self.cadBtn setTitle:[NSString stringWithFormat:@"%ld秒后开始",(long)_count1] forState:UIControlStateNormal];
        self.cadBtn.userInteractionEnabled = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
