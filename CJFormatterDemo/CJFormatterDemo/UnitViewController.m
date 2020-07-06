//
//  UnitViewController.m
//  CJFormatterDemo
//
//  Created by tet-cjx on 2019/7/30.
//  Copyright © 2019 hyd-cjx. All rights reserved.
//

#import "UnitViewController.h"

@interface UnitViewController ()
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *byteLabel;

@end

@implementation UnitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setMeasurement];
    [self setByte];
    [self setOther];
}
//其他的一些转换
- (void)setOther {
    //能量格式化(卡cal)
    NSEnergyFormatter *formatter = [[NSEnergyFormatter alloc] init];
    formatter.forFoodEnergyUse = YES;
    NSString *outputString = [formatter stringFromJoules:1000.0];
    NSLog(@"%@",outputString);
    
    //质量格式化
    NSMassFormatter *massFormatter = [[NSMassFormatter alloc] init];
//    [massFormatter.numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh"]];
    massFormatter.unitStyle = NSFormattingUnitStyleLong;
    /// 输出 200克
    NSString *outputString1 = [massFormatter stringFromValue:200 unit:NSMassFormatterUnitGram];
    /// 输出 200千克
    NSString *outputString2 = [massFormatter stringFromKilograms:200];
    /// 输出 kilograms
    NSString *outputString3 = [massFormatter unitStringFromValue:1111 unit:NSMassFormatterUnitKilogram];
    
    NSMassFormatterUnit uko = NSMassFormatterUnitKilogram;
    NSString *outputString4 = [massFormatter unitStringFromKilograms:200 usedUnit:&uko];
    NSLog(@"%@-%@-%@-%@",outputString1,outputString2,outputString3,outputString4);
    
    //长度单位
    NSLengthFormatter  *lengthFormatter = [[NSLengthFormatter alloc] init];
    [lengthFormatter.numberFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh"]];
    lengthFormatter.unitStyle = NSFormattingUnitStyleLong;
    /// 输出 200米
    NSString *lengthOutputString1 = [lengthFormatter stringFromValue:200 unit:NSLengthFormatterUnitMeter];
    /// 输出 30米
    NSString *lengthOutputString2 = [lengthFormatter stringFromMeters:30];
    /// 输出 meters
    NSString *lengthOutputString3 = [lengthFormatter unitStringFromValue:33333.2 unit:NSLengthFormatterUnitMeter];
    
    NSLengthFormatterUnit lengthUko = NSLengthFormatterUnitMeter;
    NSString *lengthOutputString4 = [lengthFormatter unitStringFromMeters:222 usedUnit:&lengthUko];
    NSLog(@"%@-%@-%@-%@",lengthOutputString1,lengthOutputString2,lengthOutputString3,lengthOutputString4);
}
//文件大小
- (void)setByte {
    NSByteCountFormatter *format = [[NSByteCountFormatter alloc] init];
     //以MB输出
    format.allowedUnits = NSByteCountFormatterUseMB;
    //1024字节为1KB
    format.countStyle = NSByteCountFormatterCountStyleBinary;
    // 输出结果显示单位
    format.includesUnit =  YES;
    // 输出结果显示数据
    format.includesCount = YES;
    //是否显示完整的字节
    format.includesActualByteCount = YES;
    NSString *str = [format stringFromByteCount:1024*1024];
    NSLog(@"1024*1024字节=%@",str);
    self.byteLabel.text = [NSString stringWithFormat:@"1024*1024字节=%@",str];
}
//物理单位换算
- (void)setMeasurement {
    NSMeasurementFormatter *formatter = [[NSMeasurementFormatter alloc] init];
    
    [formatter setUnitOptions:NSMeasurementFormatterUnitOptionsProvidedUnit];
    
    //    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh"]];
    NSMeasurement *measurement1 = [[NSMeasurement alloc] initWithDoubleValue:12 unit:NSUnitAcceleration.metersPerSecondSquared];
    NSMeasurement *measurement2 = [[NSMeasurement alloc] initWithDoubleValue:12 unit:NSUnitAcceleration.gravity];
    
    NSLog(@"%@",[formatter stringFromMeasurement:measurement1]);  // 12米/秒²
    NSLog(@"%@",[formatter stringFromMeasurement:measurement2]);  // 12 G
    self.unitLabel.text = [NSString stringWithFormat:@"12单位转换\n%@\n%@\n",[formatter stringFromMeasurement:measurement1],[formatter stringFromMeasurement:measurement2]];
    
    NSMeasurement *measurement = [[NSMeasurement alloc] initWithDoubleValue:600 unit:NSUnitDuration.seconds];
    NSMeasurement *measurement11 = [measurement measurementByConvertingToUnit:NSUnitDuration.minutes];
    NSLog(@"%@",[formatter stringFromMeasurement:measurement11]); //10分
    self.unitLabel.text = [self.unitLabel.text stringByAppendingString:[NSString stringWithFormat:@"600秒=%@",[formatter stringFromMeasurement:measurement11]]];
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
