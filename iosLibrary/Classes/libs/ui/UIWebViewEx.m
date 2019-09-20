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

@interface UIWebViewEx ()<UIWebViewDelegate>
{
    NSString                        * lastUrl;
    UIActivityIndicatorView         * loading_view;
}
@end

@implementation UIWebViewEx

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.delegate = self;
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        loading_view = [[UIActivityIndicatorView alloc] init];
        loading_view.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        loading_view.hidesWhenStopped = YES;
        [self addSubview:loading_view];
    }
    return self;
}

-(void)loadRequest:(NSURLRequest *)request
{
    [super loadRequest:request];
    if (!self.bWebLoadErr)
    {
        lastUrl = request.URL.absoluteString;
    }
}

-(void)setUrl:(NSString *)url
{
    [self loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]]];
}

-(void)execJs:(NSString *)js
{
    [self stringByEvaluatingJavaScriptFromString:js];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    loading_view.frame = CGRectMake((self.width - 50) / 2, (self.height - 50) / 2, 50, 50);
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
                if (self.bWebLoadErr)
                {
                    [webView loadRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:lastUrl]]];
                }else
                {
                    [webView reload];
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
        [self.webDelegate webView:self shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (!loading_view.isAnimating)
    {
        [loading_view startAnimating];
    }
    [self.webDelegate webViewDidStartLoad:webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [loading_view stopAnimating];
    self.bWebLoadErr = [webView.request.URL.absoluteString hasSuffix:@"error.html"];
    [self.webDelegate webViewDidFinishLoad:webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [loading_view stopAnimating];
    if ([error code] != NSURLErrorCancelled)
    {
        self.bWebLoadErr = YES;
        NSString* path = [[NSBundle mainBundle] pathForResource:@"error" ofType:@"html"];
        NSURL* url = [NSURL fileURLWithPath:path];
        NSURLRequest* request = [NSURLRequest requestWithURL:url] ;
        [webView loadRequest:request];
    }
    [self.webDelegate webView:webView didFailLoadWithError:error];
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

-(void)reloadEx
{
    self.bWebLoadErr = NO;
    [self setUrl:lastUrl];
}

@end
