//
//  CJXTimer.m
//  CJXTimer
//
//  Created by cjxjay on 2017/3/20.
//  Copyright © 2017年 cjxjay. All rights reserved.
//

#import "CJXTimer.h"

@interface CJXTimer()

@end

@implementation CJXTimer

+ (void)initWithGCD:(int)timeValue beginState:(void (^)(NSInteger seconds))begin endState:(void (^)(void))end {
    __block NSInteger time = timeValue;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (time <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (end) {
                    end();
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (begin) {
                    begin(time);
                }
            });
            time--;
        }
    });
    dispatch_resume(timer);
}
@end
