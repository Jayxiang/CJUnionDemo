//
//  ViewController.h
//  runtimeDemo
//
//  Created by tet-cjx on 2019/4/26.
//  Copyright © 2019 hyd-cjx. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JXProtocol <NSObject>
//协议测试
- (void)jxProtocolTest;
- (void)jxProtocolOne:(NSString *)str;

@end
@interface ViewController : UIViewController

+ (void)classMethodTest;

@end
