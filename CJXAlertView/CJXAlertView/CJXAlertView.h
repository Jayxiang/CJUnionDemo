//
//  CJXAlertView.h
//  CJXAlertView
//
//  Created by cjxjay on 2017/3/20.
//  Copyright © 2017年 cjxjay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CJXAlertView : UIView
- (instancetype)initWithTitle:(NSString *)title messages:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle;
/**
 *  视图显示
 */
-(void)show;
/**
 *  视图隐藏
 */
-(void)dismiss;

@end
