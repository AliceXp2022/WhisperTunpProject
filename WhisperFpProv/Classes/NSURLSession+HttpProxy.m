#import "NSURLSession+HttpProxy.h"
#import <objc/runtime.h>
@implementation NSURLSession (HttpProxy)

+(void)load{
    Method oldMethod = class_getClassMethod(self, @selector(sessionWithConfiguration:delegate:delegateQueue:));
    Method newMethod = class_getClassMethod(self, @selector(newSessionWithConfiguration:delegate:NSURLSessiondelegateQueue:));
    
    Method oldMethod1 = class_getClassMethod(self, @selector(sessionWithConfiguration:));
    Method newMethod1 = class_getClassMethod(self, @selector(newSessionWithConfiguration:));
      
     method_exchangeImplementations(oldMethod1, newMethod1);
     method_exchangeImplementations(oldMethod, newMethod);
}
+(NSURLSession *)newSessionWithConfiguration:(NSURLSessionConfiguration *)configuration{
    configuration=[self newConfiguration:configuration];
    NSURLSession *section=
       [self newSessionWithConfiguration:configuration];
       return section;
}

+(NSURLSession *)newSessionWithConfiguration:(NSURLSessionConfiguration *)configuration delegate:(nullable id <NSURLSessionDelegate>)delegate NSURLSessiondelegateQueue:(nullable NSOperationQueue *)queue{
    configuration=[self newConfiguration:configuration];
    NSURLSession *section=
    [self newSessionWithConfiguration:configuration delegate:delegate NSURLSessiondelegateQueue:queue];
    return section;
}

#pragma mark  添加代理，加速网络请求
+(NSURLSessionConfiguration *)newConfiguration:(NSURLSessionConfiguration *)configuration{
//通过服务器配置HTTPS代理
    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    configuration.connectionProxyDictionary = @{};
    return configuration;
}

@end
