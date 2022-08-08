#import "UIView+WhisperFpProvEmpty.h"

//屏幕高
#define kSCREENH [UIScreen mainScreen].bounds.size.height
//屏幕宽
#define kSCREENW [UIScreen mainScreen].bounds.size.width

@interface UIView ()

@property (nonatomic,copy) void(^reloadAction)();

@end

@implementation UIView (WhisperFpProvEmpty)

- (void)setReloadAction:(void (^)())reloadAction{
    objc_setAssociatedObject(self, @selector(reloadAction), reloadAction, OBJC_ASSOCIATION_COPY);
}
- (void (^)())reloadAction{
    return objc_getAssociatedObject(self, _cmd);
}

//CDMNetErrorPageView
- (void)setNetErrorPageView:(CDMNetErrorPageView *)netErrorPageView{
    [self willChangeValueForKey:NSStringFromSelector(@selector(netErrorPageView))];
    objc_setAssociatedObject(self, @selector(netErrorPageView), netErrorPageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:NSStringFromSelector(@selector(netErrorPageView))];
}
- (CDMNetErrorPageView *)netErrorPageView{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)configReloadAction:(void (^)())block{
    self.reloadAction = block;
    if (self.netErrorPageView && self.reloadAction) {
        self.netErrorPageView.didClickReloadBlock = self.reloadAction;
    }
}

- (void)showNetErrorPageView{
    
    if (!self.netErrorPageView) {
        self.netErrorPageView = [[CDMNetErrorPageView alloc]initWithFrame:self.bounds];
        if (self.reloadAction) {
            self.netErrorPageView.didClickReloadBlock = self.reloadAction;
        }
    }
    [self addSubview:self.netErrorPageView];
    [self bringSubviewToFront:self.netErrorPageView];
}
- (void)hideNetErrorPageView{
    if (self.netErrorPageView) {
        [self.netErrorPageView removeFromSuperview];
        self.netErrorPageView = nil;
    }
}



@end


#pragma mark ---  CDMNetErrorPageView
@interface CDMNetErrorPageView ()
@property (nonatomic,weak) UIImageView* errorImageView;
@property (nonatomic,weak) UILabel* errorTipLabel;
@property (nonatomic,weak) UIButton* reloadButton;

@end
@implementation CDMNetErrorPageView
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView* errorImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"wuwifi"]];
        _errorImageView = errorImageView;
        _errorImageView.frame=CGRectMake(kSCREENW/2-15, kSCREENH/2-30, 30, 30);
        [self addSubview:_errorImageView];
        
        UIButton* reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reloadButton setTitle:@"  网络好像有点问题请点击重试~" forState:UIControlStateNormal];
        reloadButton.titleLabel.font =[UIFont systemFontOfSize:15];
        [reloadButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [reloadButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
        [reloadButton addTarget:self action:@selector(_clickReloadButton:) forControlEvents:UIControlEventTouchUpInside];
        _reloadButton = reloadButton;
        _reloadButton.frame=CGRectMake(15, kSCREENH/2+10, kSCREENW-30, 20);
        [self addSubview:_reloadButton];
        
       
        
        
        

    }
    return self;
}
- (void)_clickReloadButton:(UIButton* )btn{
    if (_didClickReloadBlock) {
        _didClickReloadBlock();
    }
}

@end
