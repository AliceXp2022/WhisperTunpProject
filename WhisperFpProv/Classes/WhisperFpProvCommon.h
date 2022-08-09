#import <Foundation/Foundation.h>
#import "UIView+WhisperFpProvEmpty.h"
#import "UIColor+UIColor_WhisperFpProv.h"
#import "WhisperFpProvURLProtocol.h"
#define WhisperFpProvCommonInstance [WhisperFpProvCommon sharedInstance]
@interface WhisperFpProvCommon : NSObject


+ (instancetype)sharedInstance;


- (void)setBorderWithView:(UIView *_Nullable)view top:(BOOL)top left:(BOOL)left bottom:(BOOL)bottom right:(BOOL)right borderColor:(UIColor *_Nullable)color borderWidth:(CGFloat)width;

- (NSString *_Nonnull)aes256Decrypt:(NSString *_Nullable)params key:(NSString *_Nullable)keyStr iv:(NSString *_Nullable)ivStr;
- (NSData *_Nonnull)aes256DecryptDaTa:(NSString *_Nullable)params key:(NSString *_Nullable)keyStr iv:(NSString *_Nullable)ivStr;
- (NSString *_Nonnull)aes256Encrypt:(NSString *_Nullable)params key:(NSString *_Nullable)keyStr iv:(NSString *_Nullable)ivStr;


- (BOOL)getProxyWhisperTunpStatus:(NSString *_Nullable)suls;
@end
