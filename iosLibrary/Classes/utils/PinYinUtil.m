//
//  PinYinUtil.m
//  yuyee
//
//  Created by liu on 15/5/15.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "PinYinUtil.h"
#import "PinYin4Objc.h"

static PinYinUtil   * inst;

@interface PinYinUtil()
{
    HanyuPinyinOutputFormat * _of;
    NSMutableDictionary     * mutilDict;
}
@end

@implementation PinYinUtil

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _of = [[HanyuPinyinOutputFormat alloc] init];
        [_of setToneType:ToneTypeWithoutTone];
        [_of setVCharType:VCharTypeWithV];
        [_of setCaseType:CaseTypeLowercase];
    }
    return self;
}

+ (PinYinUtil *)getInst
{
    @synchronized(self)
    {
        if (inst == nil)
        {
            inst = [[super allocWithZone:NULL] init];
        }
    }
    return inst;
}

-(void) genWithTokens:(NSMutableArray *)tokens index:(int)index count:(NSUInteger)count qpStr:(NSString *)qpStr jpStr:(NSString *)jpStr
qpBuf:(NSMutableString *)qpBuf jpBuf:(NSMutableString *)jpBuf
{
    NSArray * token = tokens[index];
    if (index + 1 == count)
    {
        for (NSString * vl in token)
        {
            [qpBuf appendFormat:@"-%@%@",vl,qpStr];
            [jpBuf appendFormat:@"-%C%@",[vl characterAtIndex:0],jpStr];
        }
    }else
    {
        for (NSString * vl in token)
        {
            [qpBuf appendFormat:@"-%@%@",vl,qpStr];
            [self genWithTokens:tokens index:index + 1 count:count qpStr:[NSString stringWithFormat:@"%@%@",vl,qpStr] jpStr:[NSString stringWithFormat:@"%C%@",[vl characterAtIndex:0],jpStr]  qpBuf:qpBuf jpBuf:jpBuf];
        }
    }
}

- (NSArray *)getPinYin:(NSString *)name
{
    NSString * firstLetter = @"#";
    NSMutableArray * tokens = [PinyinHelper toHanyuPinyinStringWithNSString:name withHanyuPinyinOutputFormat:_of];
    NSString * qpStr = @"", *jpStr = @"";
    NSMutableString * qpBuf = [[NSMutableString alloc] init];
    NSMutableString * jpBuf = [[NSMutableString alloc] init];
    [self genWithTokens:tokens index:0 count:tokens.count qpStr:qpStr jpStr:jpStr qpBuf:qpBuf jpBuf:jpBuf];
    firstLetter = [[NSString stringWithFormat:@"%C",[jpBuf characterAtIndex:1]] uppercaseString];
    return [NSArray arrayWithObjects:qpBuf, [PinYinUtil toNumber:qpBuf], jpBuf, [PinYinUtil toNumber:jpBuf], firstLetter, nil];
}

//- (NSArray *)getPinYin:(NSString *)name
//{
//    //
//    NSUInteger len = [name length];
//    NSString * firstLetter = @"",* fl;
//    int start = 0;
//    unichar uc;
//    NSString * sigChar;
//    NSMutableString * qps = [[NSMutableString alloc] init];
//    NSMutableString * jps = [[NSMutableString alloc] init];
//    NSMutableArray * qslist = [[NSMutableArray alloc] init];
//    BOOL isFirstZh = false;
//    for (NSUInteger i = 0;i < len; i++)
//    {
//        uc = [name characterAtIndex:i];
//        sigChar = [NSString stringWithFormat:@"%C", uc];
//        if(uc >= 0x4e00 && uc <= 0x9fff)
//        {
//            sigChar = [PinyinHelper toHanyuPinyinStringWithNSString:sigChar withHanyuPinyinOutputFormat:_of withNSString:@""];
//            fl = [sigChar substringToIndex:1];
//            [jps appendString:fl];
//            [qslist addObject:sigChar];
//            if (i == 0)
//            {
//                isFirstZh = true;
//            }
//            continue;
//        }
//        if (i == 0)
//        {
//            if ((uc >= 0x41 && uc <= 0x5a) || (uc >= 0x61 && uc <= 0x7a))
//            {
//                firstLetter = [[[NSString alloc] initWithString:sigChar] uppercaseString];
//            }else
//            {
//                firstLetter = @"#";
//            }
//        }
//        if (start == 0)
//        {
//            fl = [sigChar substringToIndex:1];
//            [jps appendString: fl];
//            start++;
//        }
//        [qslist addObject:sigChar];
//    }
//    if (isFirstZh)
//    {
//        firstLetter = [[[qslist objectAtIndex:0] substringToIndex:1] uppercaseString];
//    }
//    NSMutableString * qt = [[NSMutableString alloc] init];
//    for (NSInteger i = qslist.count - 1; i > -1; i--)
//    {
//        [qt insertString:((NSString*)[qslist objectAtIndex:i]) atIndex:0];
//        [qps appendFormat:@"%@%@",@"-",qt];
//    }
//    NSString * lqps = [qps lowercaseString];
//    NSString * ljps = [jps lowercaseString];
//    return [NSArray arrayWithObjects:qps, [PinYinUtil toNumber:lqps], jps, [PinYinUtil toNumber:ljps], firstLetter, nil];
//}

+ (NSString *) toNumber:(NSString *)str
{
    NSMutableString * sn = [[NSMutableString alloc] init];
    NSUInteger len = [str length];
    unichar uc;
    for (NSUInteger i = 0; i < len; i++)
    {
        uc = [str characterAtIndex:i];
        switch (uc)
        {
            case 'a':
            case 'b':
            case 'c':
                [sn appendString:@"2"];
                break;
            case 'd':
            case 'e':
            case 'f':
                [sn appendString:@"3"];
                break;
            case 'g':
            case 'h':
            case 'i':
                [sn appendString:@"4"];
                break;
            case 'j':
            case 'k':
            case 'l':
                [sn appendString:@"5"];
                break;
            case 'm':
            case 'n':
            case 'o':
                [sn appendString:@"6"];
                break;
            case 'p':
            case 'q':
            case 'r':
            case 's':
                [sn appendString:@"7"];
                break;
            case 't':
            case 'u':
            case 'v':
                [sn appendString:@"8"];
                break;
            case 'w':
            case 'x':
            case 'y':
            case 'z':
                [sn appendString:@"9"];
                break;
            default:
                [sn appendFormat:@"%c",uc];
                break;
        }
    }
    return sn;
}


@end
