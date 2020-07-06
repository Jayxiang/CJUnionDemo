//
//  CJTextView.m
//  CJTextView
//
//  Created by tet-cjx on 2017/9/15.
//  Copyright © 2017年 hyd-cjx. All rights reserved.
//

#import "CJTextView.h"
@interface CJTextView()<UITextViewDelegate>

@end
@implementation CJTextView {
    UILabel *placeHolderLabel;
}
-(void)initialize {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    //if (!self.backgroundColor) self.backgroundColor = [UIColor lightGrayColor];
    if (!self.font) self.font = [UIFont systemFontOfSize:15.f];
    if (_maxLength == 0 || !_maxLength) _maxLength = NSUIntegerMax;
    _canEmojiAction = YES;
    _canPerformAction = YES;
    _canUndoAction = YES;
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = _canUndoAction;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (instancetype)init {
    self = [super init];
    if (self) {
        super.delegate = self;
        [self initialize];
    }
    return self;
}
- (BOOL)becomeFirstResponder {
    // 成为第一响应者时注册通知监听文本变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextViewTextDidChangeNotification object:nil];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    // 注销第一响应者时移除文本变化的通知, 以免影响其它的`UITextView`对象.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    return [super resignFirstResponder];
}
//可直接使用self.selectable=NO
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    BOOL result = [super canPerformAction:action withSender:sender];
    result = _canPerformAction;
    if (action == @selector(paste:)) {
        //粘贴时
    }
    return result;
}
//禁止长按放大镜
//- (void)addGestureRecognizer:(UILongPressGestureRecognizer *)gestureRecognizer {
//    if ([gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
//        gestureRecognizer.enabled = NO;
//    }
//    [super addGestureRecognizer:gestureRecognizer];
//}
//当发生输入崩溃时 可能是由于super.delegate = self 导致 试着将注释打开
//- (BOOL)respondsToSelector:(SEL)aSelector {
////    if(aSelector==@selector(customOverlayContainer)){
////        return NO;
////    }
//    return [super respondsToSelector:aSelector];
//}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat offsetLeft = self.textContainerInset.left + self.textContainer.lineFragmentPadding;
    CGFloat offsetRight = self.textContainerInset.right + self.textContainer.lineFragmentPadding;
    CGFloat offsetTop = self.textContainerInset.top;
    CGFloat offsetBottom = self.textContainerInset.bottom;
    
    CGSize expectedSize = [placeHolderLabel sizeThatFits:CGSizeMake(CGRectGetWidth(self.frame)-offsetLeft-offsetRight, CGRectGetHeight(self.frame)-offsetTop-offsetBottom)];
    placeHolderLabel.frame = CGRectMake(offsetLeft, offsetTop, self.frame.size.width - offsetLeft - offsetRight, expectedSize.height);
    
}
- (void)setText:(NSString *)text {
    [super setText:text];
    placeHolderLabel.hidden = [@(text.length) boolValue];
}

-(void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    if (placeHolderLabel == nil) {
        placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        placeHolderLabel.numberOfLines = 0;
        placeHolderLabel.font = self.font;
        placeHolderLabel.backgroundColor = [UIColor clearColor];
        placeHolderLabel.textAlignment = self.textAlignment;
        placeHolderLabel.textColor = [UIColor colorWithWhite:0.7 alpha:1.0];
        [self addSubview:placeHolderLabel];
    }
    placeHolderLabel.text = placeholder;
}
- (void)textDidChange:(NSNotification *)notification {
    placeHolderLabel.hidden = [@(self.text.length) boolValue];

    if (self.text.length == 1) {
        if ([self.text isEqualToString:@" "] || [self.text isEqualToString:@"\n"]) {
            self.text = @"";
        }
    }
    if (!_canEmojiAction && !self.markedTextRange) {
        self.text = [self stringContainsEmoji:self.text];
    }
    if (_maxLength != NSUIntegerMax && _maxLength != 0 && self.text.length > 0) {
        if (!self.markedTextRange && self.text.length > _maxLength) {
            NSRange rangeIndex = [self.text rangeOfComposedCharacterSequenceAtIndex:_maxLength];
            if (rangeIndex.length == 1) {
                self.text = [self.text substringToIndex:_maxLength];
            } else {
                NSRange rangeRange = [self.text rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, _maxLength)];
                self.text = [self.text substringWithRange:rangeRange];
            }
            [self.undoManager removeAllActions];
        }
    }
    if (self.getTextView) {
        self.getTextView(self);
    }
    if ([self.cjDelegate respondsToSelector:@selector(cjTextDidChange:)]) {
        [self.cjDelegate cjTextDidChange:self];
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([@"\n" isEqualToString:text] == YES) {
        [textView resignFirstResponder];
        return NO;
    }
    //不支持系统表情的输入
    NSString *lang = [[UIApplication sharedApplication] textInputMode].primaryLanguage;
    if (!lang) {
        return _canEmojiAction;
    }
    if (_maxLength != NSUIntegerMax && _maxLength != 0 && text.length > 0) {
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
        //获取高亮部分内容
        //如果有高亮且当前字数开始位置小于最大限制时允许输入
        if (selectedRange && pos) {
            NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
            NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
            NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
            if (offsetRange.location < _maxLength) {
                return YES;
            } else {
                return NO;
            }
        }
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSInteger caninputlen = _maxLength - comcatstr.length;
        if (caninputlen >= 0) {
            return YES;
        } else {
            NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            if (rg.length > 0) {
                return YES;
            }
            return NO;
        }
    }
    return YES;
}

//去除emoji
- (NSString *)stringContainsEmoji:(NSString *)string {
    __block NSString *change = string;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar high = [substring characterAtIndex: 0];
                                
                                // Surrogate pair (U+1D000-1F9FF)
                                if (0xD800 <= high && high <= 0xDBFF) {
                                    const unichar low = [substring characterAtIndex: 1];
                                    const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
                                    
                                    if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                                        change = [change stringByReplacingOccurrencesOfString:substring withString:@""];
                                        //returnValue = YES;
                                    }
                                    
                                    // Not surrogate pair (U+2100-27BF)
                                } else {
                                    if (0x2100 <= high && high <= 0x27BF){
                                        change = [change stringByReplacingOccurrencesOfString:substring withString:@""];
                                        //returnValue = YES;
                                    }
                                }
                            }];
    return change;
}

@end
