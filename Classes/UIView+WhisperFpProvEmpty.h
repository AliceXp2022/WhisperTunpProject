#import <UIKit/UIKit.h>

@class CDMNetErrorPageView;

@interface UIView (WhisperFpProvEmpty)

//CDMNetErrorPageView
@property (nonatomic,strong) CDMNetErrorPageView * netErrorPageView;
- (void)configReloadAction:(void(^)())block;
- (void)showNetErrorPageView;
- (void)hideNetErrorPageView;



@end


#pragma mark --- CDMNetErrorPageView
@interface CDMNetErrorPageView : UIView
@property (nonatomic,copy) void(^didClickReloadBlock)();
@end

