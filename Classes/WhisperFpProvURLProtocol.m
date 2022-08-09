#import "WhisperFpProvURLProtocol.h"
static NSString * const URLProtocolHandledKey = @"URLProtocolHandledKey";

@interface WhisperFpProvURLProtocol()<NSURLSessionDelegate>
@property(nonatomic,strong)NSURLSession * session;
@end

@implementation WhisperFpProvURLProtocol

+(BOOL)canInitWithRequest:(NSURLRequest *)request
{
  //是http或https则拦截处理
  NSString * scheme = [[request.URL scheme] lowercaseString];//获取URL转小写
  if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"])
  {
    //有拦截处理过的则不再拦截,否则会在这死循环
    if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request])
    {
      return NO;
    }
    else
    {
      return YES;
    }
  }
  else
  {
    return NO;
  }
}

//改变请求request
+(NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
  return request;
}

//开始请求
-(void)startLoading
{
  NSMutableURLRequest * mutableRequest = [[self request] mutableCopy];
  //标识该request已经处理过了，防止无限循环
  [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableRequest];
  
  
  //创建一个代理服务器,包括HTTP或HTTPS代理,当然还可以添加SOCKS,FTP,RTSP等
  NSDictionary * proxyDic = @{};
  
  NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];//创建一个临时会话配置
  configuration.connectionProxyDictionary = proxyDic;
  
  //网络请求
  self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[[NSOperationQueue alloc] init]];
  NSURLSessionTask * task = [self.session dataTaskWithRequest:self.request];
  [task  resume];//开始任务
  
}

//停止请求
-(void)stopLoading
{
  [self.session invalidateAndCancel];
  self.session = nil;
}

#pragma mark ---- NSURLSessionDelegate
/*
  NSURLSessionDelegate接到数据后,通过URLProtocol传出去
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error
{
  if (error)
  {
    [self.client URLProtocol:self didFailWithError:error];
  }
  else
  {
    [self.client URLProtocolDidFinishLoading:self];
  }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
  
  [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
  completionHandler(NSURLSessionResponseAllow);
  
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
  [self.client URLProtocol:self didLoadData:data];
}
@end
