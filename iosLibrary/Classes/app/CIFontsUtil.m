//
//  UnifiedUtil.m
//  ryb
//
//  Created by liu on 16/5/23.
//  Copyright © 2016年 ljh. All rights reserved.
//

#import "CIFontsUtil.h"
#import <CoreText/CTFontManager.h>

@interface CIFontsUtil()
{
    //NSMutableArray<UIFont *> * fontSet;
    BOOL isLoadDefault;
}
@end

@implementation CIFontsUtil

singleton_implementation(CIFontsUtil)

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _fontSet = ONEW(NSMutableArray);
    }
    return self;
}

-(UIFont*)customFontWithPath:(NSString*)path size:(CGFloat)size
{
    NSBundle * mb = [NSBundle bundleForClass:[self class]];
    NSBundle * rb = [NSBundle bundleWithPath:[mb pathForResource:@"ljhLibrary" ofType:@"bundle"]];
    if (rb == nil)
    {
        rb = mb;
    }
    NSString * p = [rb pathForResource:path ofType:@"ttf"];
    NSData * cfData = [NSData dataWithContentsOfFile:p];
    if (cfData == nil)return nil;
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithCFData((__bridge CFDataRef)cfData);
    CGFontRef fontRef = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(fontRef, NULL);
    NSString *fontName = CFBridgingRelease(CGFontCopyPostScriptName(fontRef));
    UIFont *font = [UIFont fontWithName:fontName size:size];
    CGFontRelease(fontRef);
    return font;
}

-(BOOL)loadDefault
{
    if (isLoadDefault) return YES;
    [_fontSet removeAllObjects];
    isLoadDefault = [self addFonts:@[@"fz",@"fzyx",@"ht",@"jhc",@"jqs"]];
    return isLoadDefault;
}

-(BOOL)addFonts:(NSArray<NSString *> *)fontPath
{
    UIFont * fnt;
    for (NSString * f in fontPath)
    {
        fnt = [self customFontWithPath:f size:1];
        if (fnt)
        {
            [_fontSet addObject:fnt];
        }
    }
    return _fontSet.count == fontPath.count;
}

-(UIFont *)getFontWithSize:(CGFloat)size fontIndex:(NSUInteger)index
{
    if (index < _fontSet.count)
    {
        return [_fontSet[index] fontWithSize:size];
    }
    return nil;
}

/*
+(UIFont *) getTitleFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"FZQKBYSJW--GB1-0" size:size];
}

+(UIFont *) getSubTitleFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"FZQKBYSJW--GB1-0" size:size];
}

+(NSUInteger) getCustFontCount
{
    return 6;
}

+(UIFont *) getCustFontWithIndex:(NSUInteger)index fontSize:(CGFloat)size
{
    NSArray * fs = [NSArray arrayWithObjects:@"经典黑体简",@"FZYouXian-Z09S",@"GJJHuangCao-S09S",@"Futura",@"Optima",@"FZQKBYSJW--GB1-0",nil];
    return [UIFont fontWithName:fs[index] size:size];
}*/

@end
