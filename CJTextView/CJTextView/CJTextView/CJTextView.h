//
//  CJTextView.h
//  CJTextView
//
//  Created by tet-cjx on 2017/9/15.
//  Copyright © 2017年 hyd-cjx. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CJTextViewDelegate<NSObject>

- (void)cjTextDidChange:(UITextView *)textView;

@end
@interface CJTextView : UITextView
/** 占位符 */
@property (nonatomic, copy) NSString *placeholder;
/** 最大字数 */
@property (nonatomic, assign) NSUInteger maxLength;
/** 是否允许复制粘贴 */
@property (nonatomic, assign, getter = isCanPerformAction) BOOL canPerformAction;
/** 是否允许undo操作 */
@property (nonatomic, assign, getter = isCanUndoAction) BOOL canUndoAction;
/** 是否允许表情输入 */
@property (nonatomic, assign, getter = isCanEmojiAction) BOOL canEmojiAction;

@property (nonatomic, copy) void (^getTextView)(UITextView *textView);

@property (nonatomic, weak) id<CJTextViewDelegate> cjDelegate;

@end
