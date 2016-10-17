//
//  XCWKWebView.m
//  WKWebView
//
//  Created by xuchao on 16/10/11.
//  Copyright © 2016年 none. All rights reserved.
//

#import "XCWKWebView.h"
#import <WebKit/WebKit.h>


@interface XCWKWebView ()<WKNavigationDelegate>

@property (nonatomic,retain)WKWebView *webView;
@property (nonatomic,retain)UIProgressView * progressView;

@end

@implementation XCWKWebView

- (void)viewDidLoad {
    [super viewDidLoad];
    /*

     */
    //网络风火轮显示  <br/>html的换行
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    // 创建WKWebView
   _webView = [[WKWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    // 设置访问的URL
    NSURL *url = [NSURL URLWithString:@"http://www.baidu.com"];
    // 根据URL创建请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    // WKWebView加载请求/Users/xuchao/Desktop/WKWebView/WKWebView
    //[_webView loadRequest:request];
    NSString * htmlString = @"<p style='font-size:25px;color:#666666'>尚未拥有维金荟账号？<br/>您可以通过以下两种方式进行注册：<br/>1.请访问维金荟官网www.vmoney.cn进行注册<br/>2.请访问维金荟<a href='https://itunes.apple.com/cn/app/wei-jin-hui/id1041303464?mt=8' style='color:#089aff;font-size:25px'>APP下载页</a>，登陆APP后进行注册</p>";
    [_webView loadHTMLString:htmlString baseURL:url];
    _webView.navigationDelegate = self;
    // 将WKWebView添加到视图
    [self.view addSubview:_webView];//@"estimatedProgress"
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    //打开左划回退功能
    self.webView.allowsBackForwardNavigationGestures=YES;
    
    
    
    self.progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    self.progressView.frame = CGRectMake(0, 100, self.view.frame.size.width, 2);
    self.progressView.progressTintColor = [UIColor redColor];
   // self.progressView.trackTintColor = [UIColor redColor];
    self.progressView.progress = 0;
    [self.view addSubview:self.progressView];
    
    
}
/**
 *  每当加载一个请求之前会调用该方法，通过该方法决定是否允许或取消请求的发送
 *
 *
 *  @param decisionHandler  请求处理的决定
 */
- (void)webView:(WKWebView*)webView decidePolicyForNavigationResponse:(WKNavigationResponse*)navigationResponse decisionHandler:(void(^)(WKNavigationResponsePolicy))decisionHandler{
    //decisionHandler 对响应的处理
    //WKNavigationActionPolicyCancel:取消响应
    //WKNavigationActionPolicyAllow:允许响应
    decisionHandler(WKNavigationResponsePolicyAllow);
}

- (void)webView:(WKWebView*)webView decidePolicyForNavigationAction:(WKNavigationAction*)navigationAction decisionHandler:(void(^)(WKNavigationActionPolicy))decisionHandler{
    // 获得协议头(可以自定义协议头，根据协议头判断是否要执行跳转)
    NSString *scheme = navigationAction.request.URL.scheme;
    if ([scheme isEqualToString:@"itheima"]) {
        // decisionHandler 对请求处理回调
        //WKNavigationActionPolicyCancel:取消请求
        //WKNavigationActionPolicyAllow:允许请求
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
/**
 *  当开始发送请求时调用
 */
- (void)webView:(WKWebView*)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    NSLog(@"%s", __FUNCTION__);
}
/**
 *  当请求过程中出现错误时调用
 */
- (void)webView:(WKWebView*)webView didFailNavigation:(WKNavigation*)navigation withError:(NSError *)error {
    NSLog(@"%@= %s",error, __FUNCTION__);
}
/**
 *  当开始发送请求时出错调用
 */
- (void)webView:(WKWebView*)webView didFailProvisionalNavigation:(WKNavigation*)navigation withError:(NSError *)error {
    NSLog(@"%@= %s",error, __FUNCTION__);
    
    
    
    /**
     *  每当接收到服务器返回的数据时调用，通过该方法可以决定是否允许或取消导航
     */

}

/**
 *  当收到服务器返回的受保护空间(证书)时调用
 *  @param challenge         安全质询-->包含受保护空间和证书
 *  @param completionHandler 完成回调-->告诉服务器如何处置证书
 */
- (void)webView:(WKWebView*)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *__nullablecredential))completionHandler {
    // 创建凭据对象
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    // 告诉服务器信任证书
    completionHandler(NSURLSessionAuthChallengeUseCredential,credential);
}
/**
 *  当网页加载完毕时调用：该方法使用最频繁
 */
- (void)webView:(WKWebView*)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    // js 代码
   // NSString*jsCode = [NSString stringWithFormat:@"window.location.href='#howtorecharge'"];
    // 可以在这个方法执行JS代码
//    [webView evaluateJavaScript:jsCode completionHandler:^(id _Nullable, NSError * _Nullable error) {
//        
//    }];
//    [webView evaluateJavaScript:jsCode completionHandler:^(id_Nullable result, NSError* _Nullable error) {
//        NSLog(@"执行完毕JS代码");
//    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id>*)change context:(void *)context{
    // 获得进度值
    CGFloat progress = [change[NSKeyValueChangeNewKey] floatValue];
    // 显示进度
    NSLog(@"%f",progress);
    self.progressView.progress = progress;
    if (self.progressView.progress == 1) {
        self.progressView.hidden = YES;
    }else {
        self.progressView.hidden = NO;
    }
   
}
- (void)dealloc {
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
