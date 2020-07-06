//
//  NumberViewController.m
//  CJFormatterDemo
//
//  Created by tet-cjx on 2019/7/30.
//  Copyright © 2019 hyd-cjx. All rights reserved.
//

#import "NumberViewController.h"

@interface NumberViewController ()
@property (weak, nonatomic) IBOutlet UITextField *numberText;
@property (weak, nonatomic) IBOutlet UILabel *afterLabel;

@end

@implementation NumberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)createClick:(id)sender {
    NSNumber *num1 = [NSNumber numberWithDouble:[self.numberText.text doubleValue]];
    NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    //一种方式直接使用setPositiveFormat
    //如果不用.00的样式整数格式化后不会保留小数
//    [numberFormatter setPositiveFormat:@"#,###.00元"];
//    NSString *theAmount = [numberFormatter stringFromNumber:num1];
//    NSLog(@"定制化：%@",theAmount);
//    self.afterLabel.text = theAmount;
    
    
    // 缩放因子,你可以将一个数缩放指定比例,然后给其添加后缀,如传入一个3000,你希望表示为3千,就要用到这个属性

    //    numberFormatter.multiplier = @1000;
    
    //    NSLog(@"%@千",[numberFormatter numberFromString:@"1000"]);  // 1千
    
    //    numberFormatter.multiplier     = @0.001;
    //    numberFormatter.positiveSuffix = @"千";
    //    NSLog(@"%@",[numberFormatter stringFromNumber:@10000]);    // 10千
    
    // 指定符号,与我们在前面类方法中说明的一致
    NSLog(@"货币代码%@",numberFormatter.currencyCode);                     // 货币代码USD
    NSLog(@"货币符号%@",numberFormatter.currencySymbol);                   // 货币符号$
    NSLog(@"国际货币符号%@",numberFormatter.internationalCurrencySymbol);   // 国际货币符号USD
    NSLog(@"百分比符号%@",numberFormatter.percentSymbol);                   // 百分比符号%
    NSLog(@"千分号符号%@",numberFormatter.perMillSymbol);                   // 千分号符号‰
    NSLog(@"减号符号%@",numberFormatter.minusSign);                         // 减号符号-
    NSLog(@"加号符号%@",numberFormatter.plusSign);                          // 加号符号+
    NSLog(@"指数符号%@",numberFormatter.exponentSymbol);                    // 指数符号E
    
    // 小数点样式
    numberFormatter.decimalSeparator = @".";
    
    // 零的样式
    numberFormatter.zeroSymbol       = @"-";
    
    // 正前缀和后缀
    numberFormatter.positivePrefix = @"!";
    numberFormatter.positiveSuffix = @"元";
    // 负前缀和后缀
    numberFormatter.negativePrefix = @"@";
    numberFormatter.negativeSuffix = @"钱";
    // 整数最多位数
    numberFormatter.maximumIntegerDigits = 10;
    
    // 整数最少位数
    numberFormatter.minimumIntegerDigits = 2;
    
    // 小数位最多位数
    numberFormatter.maximumFractionDigits = 3;
    
    // 小数位最少位数
    numberFormatter.minimumFractionDigits = 1;
    
    // 数字分割的尺寸
    numberFormatter.groupingSize = 4;
    
    // 除了groupingSize决定的尺寸外,其他数字位分割的尺寸
    numberFormatter.secondaryGroupingSize = 2;
    
    // 最大有效数字个数
    numberFormatter.maximumSignificantDigits = 12;
    
    // 最少有效数字个数
    numberFormatter.minimumSignificantDigits = 3;
    // 四色五入方式
    numberFormatter.roundingMode = kCFNumberFormatterRoundHalfUp;
    
    self.afterLabel.text = [numberFormatter stringFromNumber:num1];
}
- (IBAction)formatterClick:(id)sender {
    NSNumber *num1 = [NSNumber numberWithDouble:[self.numberText.text doubleValue]];
    
    // 四舍五入的整数
    NSString *numberNoStyleStr = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterNoStyle];
    // 小数形式
    NSString *numberDecimalStyleStr = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterDecimalStyle];
    // 货币形式 -- 本地化
    NSString *numberCurrencyStyleStr = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterCurrencyStyle];
    // 百分数形式
    NSString *numberPercentStyleStr = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterPercentStyle];
    // 科学计数
    NSString *numberScientificStyleStr = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterScientificStyle];
    // 朗读形式 -- 本地化
    NSString *numberSpellOutStyleStr = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterSpellOutStyle];
    // 序数形式 -- 本地化
    NSString *numberOrdinalStyleStr = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterOrdinalStyle];
    // 货币形式 -- 本地化
    NSString *numberCurrencyISOStyleStr = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterCurrencyISOCodeStyle];
    // 货币形式 -- 本地化
    NSString *numberCurrencyPluralStyleStr = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterCurrencyPluralStyle];
    // 会计计数 -- 本地化
    NSString *numberCurrencyAccountingStyleStr = [NSNumberFormatter localizedStringFromNumber:num1 numberStyle:NSNumberFormatterCurrencyAccountingStyle];
    NSLog(@"No Style                  = %@",numberNoStyleStr);
    NSLog(@"Decimal Style             = %@",numberDecimalStyleStr);
    NSLog(@"Currency Style            = %@",numberCurrencyStyleStr);
    NSLog(@"Percent Style             = %@",numberPercentStyleStr);
    NSLog(@"Scientific Style          = %@",numberScientificStyleStr);
    NSLog(@"Spell Out Style           = %@",numberSpellOutStyleStr);
    NSLog(@"Ordinal Style             = %@",numberOrdinalStyleStr);
    NSLog(@"Currency ISO Style        = %@",numberCurrencyISOStyleStr);
    NSLog(@"Currency plural Style     = %@",numberCurrencyPluralStyleStr);
    NSLog(@"Currency accounting Style = %@",numberCurrencyAccountingStyleStr);
    NSString *after = [NSString stringWithFormat:@"四舍五入取整数：%@\n小数形式：%@\n货币形式：%@\n百分数形式：%@\n科学计数：%@\n朗读形式：%@\n序数形式：%@\n货币形式：%@\n货币形式：%@\n会计计数：%@\n",numberNoStyleStr,numberDecimalStyleStr,numberCurrencyStyleStr,numberPercentStyleStr,numberScientificStyleStr,numberSpellOutStyleStr,numberOrdinalStyleStr,numberCurrencyISOStyleStr,numberCurrencyPluralStyleStr,numberCurrencyAccountingStyleStr];
    self.afterLabel.text = after;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
