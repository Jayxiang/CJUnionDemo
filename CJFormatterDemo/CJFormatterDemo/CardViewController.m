//
//  CardViewController.m
//  CJFormatterDemo
//
//  Created by tet-cjx on 2019/7/31.
//  Copyright © 2019 hyd-cjx. All rights reserved.
//

#import "CardViewController.h"

@interface CardViewController ()
@property (weak, nonatomic) IBOutlet UILabel *cardLabel;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSPersonNameComponentsFormatter *formatter = [[NSPersonNameComponentsFormatter alloc] init];
    NSPersonNameComponents *p = [[NSPersonNameComponents alloc] init];
    p.givenName = @"名字";
    p.familyName = @"姓C";
    p.nameSuffix = @"后缀";
    p.namePrefix = @"前缀";
    p.nickname = @"昵称";
    p.middleName = @"中间符号";
    NSString *outputString1 =[formatter stringFromPersonNameComponents:p];
    formatter.style = NSPersonNameComponentsFormatterStyleLong;
    NSString *outputString2 =[formatter stringFromPersonNameComponents:p];
    NSLog(@"%@---%@",outputString1,outputString2);
    self.cardLabel.text = [NSString stringWithFormat:@"%@",outputString2];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
