//
//  CJXTimer.h
//  CJXTimer
//
//  Created by cjxjay on 2017/3/20.
//  Copyright © 2017年 cjxjay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CJXTimer : NSObject

+ (void)initWithGCD:(int)timeValue beginState:(void (^)(NSInteger seconds))begin endState:(void (^)(void))end;

@end
