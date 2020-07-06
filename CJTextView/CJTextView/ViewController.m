//
//  ViewController.m
//  CJTextView
//
//  Created by tet-cjx on 2017/9/15.
//  Copyright © 2017年 hyd-cjx. All rights reserved.
//

#import "ViewController.h"
#import "CJTextView.h"
@interface ViewController ()<CJTextViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *textViewTableView;
@property (nonatomic, strong) UIView *headerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self setTextView];
}

- (void)setTextView {
    _textViewTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _textViewTableView.delegate = self;
    _textViewTableView.dataSource = self;
    _textViewTableView.tableHeaderView = self.headerView;
    _textViewTableView.tableFooterView = [UIView new];
    [self.view addSubview:_textViewTableView];
    
}
- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        _headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 88);
        _headerView.backgroundColor = [UIColor whiteColor];
        CJTextView *text = [[CJTextView alloc] init];
        text.frame = _headerView.bounds;
        text.placeholder = @"头视图";
        text.canEmojiAction = NO;
        text.getTextView = ^(UITextView *textView) {
            NSLog(@"头输入:%@",textView.text);
        };
        [_headerView addSubview:text];
    }
    return _headerView;
}
#pragma mark - tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    CJTextView *text = [[CJTextView alloc] init];
    text.scrollEnabled = NO;
    if (indexPath.row == 2) {
        text.textAlignment = NSTextAlignmentRight;
        text.canPerformAction = NO;
    }
    text.cjDelegate = self;
    text.frame = cell.bounds;
    text.placeholder = [NSString stringWithFormat:@"第%ld行输入",(long)indexPath.row];
    text.maxLength = indexPath.row + 10;
    [cell.contentView addSubview:text];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)cjTextDidChange:(UITextView *)textView {
    UITableViewCell *cell = (UITableViewCell *)textView.superview.superview;
    NSIndexPath *indexPath = [self.textViewTableView indexPathForCell:cell];
    NSLog(@"%@->%@",textView.text,indexPath);
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
