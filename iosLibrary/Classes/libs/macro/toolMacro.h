//
//  toolMacro.h
//  iosLibrary
//
//  Created by liu on 2017/7/27.
//  Copyright © 2017年 liu. All rights reserved.
//

#ifndef toolMacro_h
#define toolMacro_h

// object macro
#define ONEW(cls)               [[[cls class] alloc] init]
#define OIV_STR(imgStr)         [[UIImageView alloc] initWithImage:[UIImage imageNamed:(imgStr)]]
#define OIV_IMG(img)            [[UIImageView alloc] initWithImage:img]
#define OIMG_STR(imgStr)        [UIImage imageNamed:(imgStr)]

//calc
#define ITOS(value)             [NSString stringWithFormat:@"%d",value]
#define LTOS(value)             [NSString stringWithFormat:@"%ld",value]
#define SAFESTR(str)            (str) == nil ? @"" : str

//info
#define SYSTEM_NAV_HEIGHT       44
#define IS_IPHONEX              (SCREEN_WIDTH == 375) && (SCREEN_HEIGHT == 812)
#define IS_IPAD                 [[UIDevice currentDevice].model isEqualToString:@"iPad"]
#define SYSTEM_STATUS_HEIGHT    ([[UIApplication sharedApplication] statusBarFrame].size.height)
#define TITLE_VIEW_HEIGHT       (SYSTEM_STATUS_HEIGHT + SYSTEM_NAV_HEIGHT);
#define APP_VERSION             [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define PROJ_NAME               [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey]
#define IOS_VERSION             [[[UIDevice currentDevice] systemVersion] floatValue]
#define GETCLASSNAME(cls)       NSStringFromClass([cls class])
#define FRMSTR(format,...)      [NSString stringWithFormat:format,##__VA_ARGS__]
//skin
#define SCREEN_WIDTH            [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT           [[UIScreen mainScreen] bounds].size.height
#define PXTO6SW(px)             (px) / 3.0 / 414.0 * SCREEN_WIDTH
#define PXTO6SH(px)             (px) / 3.0 / 736.0 * SCREEN_HEIGHT
#define PTTO6SW(pt)             (pt) / 414.0 * SCREEN_WIDTH
#define PTTO6SH(pt)             (pt) / 736.0 * SCREEN_HEIGHT
#define PTTO6SIZE(size)         CGSizeMake(PTTO6SW(size.width), PTTO6SW(size.height))
#define PXTO6SIZE(size)         CGSizeMake(PXTO6SW(size.width), PXTO6SW(size.height))
#define CUR_TIME_MS             (long)(CFAbsoluteTimeGetCurrent() * 1000)
//color
#define RGBA(r,g,b,a)            [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
#define UIColorFromRGBA(rgbaValue) \
[UIColor colorWithRed:((float)((rgbaValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbaValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbaValue & 0x0000FF))/255.0 \
alpha:((float)((rgbaValue & 0xFF000000) >> 24))/255.0]

//fun
#define WEAKOBJ(type)         __weak typeof(type)weak_##type = type
#define STRONGOBJ(type)       __strong typeof(type)type = weak_##type

#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

/** .h create singleton defin **/
#define singleton_interface +(instancetype)sharedInst;
/** .m impl singleton fun **/
#define singleton_implementation(class) \
static class *_instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
\
return _instance; \
} \
\
+ (instancetype)sharedInst{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc] init];\
});\
return _instance;\
}\

#endif /* toolMacro_h */
