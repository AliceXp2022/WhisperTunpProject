#import "WhisperFpProvCommon.h"
#include <CommonCrypto/CommonCrypto.h>
#import "GTMBase64.h"
/** AES加密位数 */
static NSInteger const kEHIAESMode = 16;

@implementation WhisperFpProvCommon
- (void)setBorderWithView:(UIView *)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *)color borderWidth:(CGFloat)width
{
    if (top) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (left) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (bottom) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, view.frame.size.height - width, view.frame.size.width, width);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
    if (right) {
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(view.frame.size.width - width, 0, width, view.frame.size.height);
        layer.backgroundColor = color.CGColor;
        [view.layer addSublayer:layer];
    }
}





/** AES解密：CFB模式 */
- (NSData *)aes256ByCFBModeWithOperation:(CCOperation)operation key:(NSString *)keyStr iv:(NSString *)ivStr NSDataParam:(NSData *)params{
    NSData *originData = params;
    if (operation == kCCEncrypt) {
        // 加密:位数不够的补全
        originData = [self fullData:originData mode:kEHIAESMode];
    }
    
    const char *iv = [[ivStr dataUsingEncoding:NSUTF8StringEncoding] bytes];
    const char *key = [[keyStr dataUsingEncoding:NSUTF8StringEncoding] bytes];
    
    // 加密/解密
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = CCCryptorCreateWithMode(operation,
                                                     kCCModeCBC,
                                                     kCCAlgorithmAES,
                                                     ccNoPadding,
                                                     iv,
                                                     key,
                                                     keyStr.length,
                                                     NULL,
                                                     0,
                                                     0,
                                                     0,
                                                     &cryptor);
    if (status != kCCSuccess) {
        NSLog(@"AES加密/解密失败 error: %@", @(status));
        return nil;
    }
    
    // 输出加密/解密数据
    NSUInteger inputLength = originData.length;
    char *outData = malloc(inputLength);
    memset(outData, 0, inputLength);
    
    size_t outLength = 0;
    CCCryptorUpdate(cryptor, originData.bytes, inputLength, outData, inputLength, &outLength);
    NSData *resultData = [NSData dataWithBytes:outData length:outLength];
    
    CCCryptorRelease(cryptor);
    free(outData);
    
    if (operation == kCCDecrypt) {
        // 解密:位数多的删除
        resultData = [self deleteData:resultData mode:kEHIAESMode];
    }
    return resultData;
}

/** 加密:位数不够的补全
    补位规则：1.length=13,补5位05
            2.length=16,补16位ff */
- (NSData *)fullData:(NSData *)originData mode:(NSUInteger)mode {
    NSMutableData *tmpData = [[NSMutableData alloc] initWithData:originData];
    // 确定要补全的个数
    NSUInteger shouldLength = mode * ((tmpData.length / mode) + 1);
    NSUInteger diffLength = shouldLength - tmpData.length;
    uint8_t *bytes = malloc(sizeof(*bytes) * diffLength);
    for (NSUInteger i = 0; i < diffLength; i++) {
        // 补全缺失的部分
        bytes[i] = diffLength;
    }
    [tmpData appendBytes:bytes length:diffLength];
    return tmpData;
}

/** 解密:位数多的删除
    删位规则：最后一位数字在1-16之间,且连续n位相同n数字 */
- (NSData *)deleteData:(NSData *)originData mode:(NSUInteger)mode {
    NSMutableData *tmpData = [[NSMutableData alloc] initWithData:originData];
    Byte *bytes = (Byte *)tmpData.bytes;
    Byte lastNo = bytes[tmpData.length - 1];
    if (lastNo >= 1 && lastNo <= mode) {
        NSUInteger count = 0;
        // 确定多余的部分正确性
        for (NSUInteger i = tmpData.length - lastNo; i < tmpData.length; i++) {
            if (lastNo == bytes[i]) {
                count ++;
            }
        }
        if (count == lastNo) {
            // 截取正常的部分
            NSRange replaceRange = NSMakeRange(0, tmpData.length - lastNo);
            return [tmpData subdataWithRange:replaceRange];
        }
    }
    return originData;
}

/** AES解密 */
- (NSString *)aes256Decrypt:(NSString *)params key:(NSString *)keyStr iv:(NSString *)ivStr{
    // 1.Base64 Decode
    NSData *base64DecodeData = [GTMBase64 decodeString:params];
    // 1.Aes256 解密
    NSData *decodeData = [self aes256ByCFBModeWithOperation:kCCDecrypt key:keyStr iv:ivStr NSDataParam:base64DecodeData];
    NSString *decodeStr = [[NSString alloc] initWithData:decodeData encoding:NSUTF8StringEncoding];
    if (!decodeStr) {
        // 解密失败
        return nil;
    }
    return decodeStr;
}

- (NSData *)aes256DecryptDaTa:(NSString *)params key:(NSString *)keyStr iv:(NSString *)ivStr{
    // 1.Base64 Decode
    NSData *base64DecodeData = [GTMBase64 decodeString:params];
    // 1.Aes256 解密
    NSData *decodeData = [self aes256ByCFBModeWithOperation:kCCDecrypt key:keyStr iv:ivStr NSDataParam:base64DecodeData];
    if (!decodeData) {
        // 解密失败
        return nil;
    }
    return decodeData;
}

/** AES加密 */
- (NSString *)aes256Encrypt:(NSString *)params key:(NSString *)keyStr iv:(NSString *)ivStr {
    NSData *originData = [params dataUsingEncoding:NSUTF8StringEncoding];
    // 1.Aes256 加密
    NSData *encodeData = [self aes256ByCFBModeWithOperation:kCCEncrypt key:keyStr iv:ivStr NSDataParam:originData];
    // 2.Base64 Encode
    NSString *base64EncodeStr = [GTMBase64 encodeBase64Data:encodeData];
    return base64EncodeStr;
}


- (BOOL)getProxyWhisperTunpStatus:(NSString *)suls{
    NSDictionary *proxySettings = (__bridge NSDictionary *)CFNetworkCopySystemProxySettings();
    NSArray *proxies = (__bridge NSArray *)(CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)([NSURL URLWithString:suls]),(__bridge CFDictionaryRef _Nonnull)(proxySettings)));
    NSDictionary *settings = [proxies objectAtIndex:0];
 if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
        return NO;
    }else {
        return YES;
    }
}




@end
