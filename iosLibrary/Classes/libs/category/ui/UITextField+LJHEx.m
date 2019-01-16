//
//  UITextField+LJHEx.m
//  iosLibrary
//
//  Created by liu on 2017/11/9.
//  Copyright © 2017年 liu. All rights reserved.
//

#import "UITextField+LJHEx.h"
#import <objc/runtime.h>

static NSString *kLimitTextLengthKey = @"kLimitTextLengthKey";

@implementation UITextField (LJHEx)

- (void)limitTextLength:(int)length
{
    objc_setAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey), [NSNumber numberWithInt:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

    [self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];

}
- (void)textFieldTextLengthLimit:(id)sender
{
    NSNumber *lengthNumber = objc_getAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey));
    int length = [lengthNumber intValue];
        //下面是修改部分
    bool isChinese;//判断当前输入法是否是中文
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
        //[[UITextInputMode currentInputMode] primaryLanguage]，废弃的方法
    if ([current.primaryLanguage isEqualToString: @"en-US"])
    {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }

    if(sender == self)
    {
            // length是自己设置的位数
        NSString *str = [[self text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
        if (isChinese)
        { //中文输入法下
            UITextRange *selectedRange = [self markedTextRange];
                //获取高亮部分
            UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
                // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position)
            {
                if ( str.length>=length)
                {
                    NSString *strNew = [NSString stringWithString:str];
                    [self setText:[strNew substringToIndex:length]];
                }
            }
            else
            {
                    // NSLog(@"输入的");

            }
        }else
        {
            if ([str length]>=length)
            {
                NSString *strNew = [NSString stringWithString:str];
                [self setText:[strNew substringToIndex:length]];
            }
        }
    }
}

- (void)setMyLeftView:(UIView *)leftView width:(CGFloat)width height:(CGFloat)height
{
    self.leftViewMode = UITextFieldViewModeAlways;
    leftView.frame = CGRectMake(0, 0, width, height);
    self.leftView = leftView;
}

-(void)setMyLeftViewWidth:(CGFloat)width height:(CGFloat)height
{
    self.leftViewMode = UITextFieldViewModeAlways;
    UIView * v = [[UIView alloc] init];
    v.frame = CGRectMake(0, 0, width, height);
    self.leftView = v;
}

- (void)setPlaceholderColor:(UIColor *)pc placeholder:(NSString *)ph
{
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:ph attributes:@{NSForegroundColorAttributeName: pc}];
        //        [tf setValue:opt.placeHolderColor forKeyPath:@"_placeholderLabel.textColor"];
        //        [tf setValue:opt.textFont forKeyPath:@"_placeholderLabel.font"];
}

+(UITextField *)createPHText:(NSString *)pht phtColor:(UIColor *)phtColor tag:(NSInteger)tag limitLen:(int)len keyBoardType:(NSInteger)kbt textColor:(UIColor *)tc textFont:(UIFont *)tf
{
    UITextField * field = [[UITextField alloc] init];
    if (pht)
    {
        [field setPlaceholderColor:phtColor placeholder:pht];
    }
    field.tag = tag;
    if (len > 0)
    {
        [field limitTextLength:len];
    }
    field.keyboardType = kbt;
    field.textColor = tc;
    field.font = tf;
    return field;
}

@end
