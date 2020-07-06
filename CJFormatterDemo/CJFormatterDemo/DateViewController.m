//
//  DateViewController.m
//  CJFormatterDemo
//
//  Created by tet-cjx on 2019/7/31.
//  Copyright © 2019 hyd-cjx. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end

@implementation DateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setDate];
    [self setISO8601Date];
    [self setInterval];
    [self setComponents];
}
//比较时间
- (void)setComponents {
    NSDateComponentsFormatter *componentsFormatter = [NSDateComponentsFormatter new];
    componentsFormatter.unitsStyle = NSDateComponentsFormatterUnitsStyleFull;
    //比较结果显示格式
    componentsFormatter.allowedUnits = (NSCalendarUnitHour | NSCalendarUnitMinute|NSCalendarUnitSecond);
    
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [NSDate dateWithTimeInterval:86450 sinceDate:startDate];
    
    NSString *outputString = [componentsFormatter stringFromDate:startDate toDate:endDate];
    NSLog(@"%@",outputString);
}

//两个日期范围格式化
- (void)setInterval {
    NSDateIntervalFormatter *formatter = [[NSDateIntervalFormatter alloc] init];
    
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    formatter.dateStyle = NSDateIntervalFormatterMediumStyle;
    formatter.timeStyle = NSDateIntervalFormatterMediumStyle;
    
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [NSDate dateWithTimeInterval:86400 sinceDate:startDate];
    
    NSString *outputString = [formatter stringFromDate:startDate toDate:endDate];
    NSLog(@" %@ ",outputString);
}
//ISO8601格式
- (void)setISO8601Date {
    NSISO8601DateFormatter *formatter = [[NSISO8601DateFormatter alloc] init];
    formatter.formatOptions = NSISO8601DateFormatWithInternetDateTime;
    NSString* outputString = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@",outputString);
}
- (void)setDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //系统自带的几种格式
//    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
//    dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
    //自定义格式
    [dateFormatter setDateFormat:@"GGGyyyy年MM月dd日 EEE HH:mm:ss.SSS"];
    NSString *str = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@" %@ ",str);
    self.dateLabel.text = [NSString stringWithFormat:@"现在是：%@",str];
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
