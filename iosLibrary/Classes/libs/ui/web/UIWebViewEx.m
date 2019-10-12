//
//  UIWebViewEx.m
//  masterlive
//
//  Created by liu on 15/10/30.
//  Copyright (c) 2015年 liu. All rights reserved.
//

#import "UIWebViewEx.h"
#import "UIView+UIViewHelper.h"
#import "NSString+NSStringHelper.h"

@implementation AbsWebJsInterfaceImpl

-(void)procJsCallWithFunName:(NSString *)fn params:(NSArray *)params
{
    [self doesNotRecognizeSelector:_cmd];
}

-(void)procJson:(NSString *)json
{
}

@end

@interface UIWebViewEx()
{
    NSString                        * lastUrl;
    UIActivityIndicatorView         * loadingView;
}
@end

@implementation UIWebViewEx

@synthesize webDelegate,jsDelegate,isWebLoadErr;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.delegate = self;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        loadingView = [[UIActivityIndicatorView alloc] init];
        loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        loadingView.hidesWhenStopped = YES;
        [self addSubview:loadingView];
    }
    return self;
}

-(void)loadRequest:(NSURLRequest *)request
{
    [super loadRequest:request];
    self.isWebLoadErr = [request.URL.absoluteString hasSuffix:@"error.html"];
    if (!self.isWebLoadErr)
    {
        lastUrl = request.URL.absoluteString;
    }
}

-(void)loadUrl:(NSString *)url
{
    [self loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]]];
}

-(void)runJs:(NSString *)js
{
    [self stringByEvaluatingJavaScriptFromString:js];
}

-(void)reloadEx
{
    self.isWebLoadErr = NO;
    [self loadUrl:lastUrl];
}

-(id)getWebView
{
    return self;
}

-(NSInteger)getWebType
{
    return WEB_TYPE_UI;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    loadingView.frame = CGRectMake((self.width - 50) / 2, (self.height - 50) / 2, 50, 50);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString * scheme = request.URL.absoluteString;
    scheme = scheme.decoded;
    if ([scheme hasPrefix:@"ios:"])
    {
        NSLog(@"%@",scheme);
        scheme = [scheme substringFromIndex:4];
        NSRange nr = [scheme rangeOfString:@":"];
        if (nr.location != NSNotFound)
        {
            NSString * fn = [scheme substringToIndex:nr.location];
            scheme = [scheme substringFromIndex:nr.location + 1];
            NSArray * ps = [scheme componentsSeparatedByString:@"!"];
            if ([fn isEqualToString:@"reload"])
            {
                if (self.isWebLoadErr)
                {
                    [self reloadEx];
//                    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:lastUrl]]];
                }else
                {
                    [self reload];
                }
            }else
            {
                [self.jsDelegate procJsCallWithFunName:fn params:ps];
            }
        }else
        {
            [self.jsDelegate procJson:scheme];
        }
        return NO;
    }else if ([self.webDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)])
    {
        [self.webDelegate webView:self shouldStartLoadWithUrl:request.URL webViewType:WEB_TYPE_UI];
    }else if (![scheme hasPrefix:@"http"])//不是http开始
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:scheme]];
        return NO;
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (!loadingView.isAnimating)
    {
        [loadingView startAnimating];
    }
    if ([self.webDelegate respondsToSelector:@selector(webView:didStartLoadWithWebViewType:)])
    {
        [self.webDelegate webView:self didStartLoadWithWebViewType:WEB_TYPE_UI];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loadingView stopAnimating];
    self.isWebLoadErr = [webView.request.URL.absoluteString hasSuffix:@"error.html"];
    if ([self.webDelegate respondsToSelector:@selector(webView:didFinishLoadWithWebViewType:)])
    {
        [self.webDelegate webView:self didFinishLoadWithWebViewType:WEB_TYPE_UI];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [loadingView stopAnimating];
    if ([error code] != NSURLErrorCancelled)
    {
        self.isWebLoadErr = YES;
        NSString* path = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"html"];
        NSURL* url = [NSURL fileURLWithPath:path];
        NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
        [webView loadRequest:request];
    }
    if ([self.webDelegate respondsToSelector:@selector(webView:didFailLoadWithError:webViewType:)])
    {
        [self.webDelegate webView:self didFailLoadWithError:error webViewType:WEB_TYPE_WK];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [super scrollViewDidEndDecelerating:scrollView];
    if([self.webDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)])
    {
        [self.webDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [super scrollViewDidScroll:scrollView];
    if([self.webDelegate respondsToSelector:@selector(scrollViewDidScroll:)])
    {
        [self.webDelegate scrollViewDidScroll:scrollView];
    }
}

@end
