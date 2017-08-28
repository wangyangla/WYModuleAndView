//
//  WYModel.m
//  ABC
//
//  Created by WY on 2017/8/5.
//  Copyright © 2017年 重庆远歌信息科技有限公司. All rights reserved.
//

#import "WYModel.h"

@interface WYModel (){
    NSDecimalNumberHandler *roundUp;
    NSMutableDictionary *dictionary;
}

@end



@implementation WYModel

+ (WYModel *)model{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initPhotosVideoManager];
    });
    return instance;
}

- (id)initPhotosVideoManager{
    self = [super init];
    if (self) {
        
        roundUp = [NSDecimalNumberHandler
                   decimalNumberHandlerWithRoundingMode:NSRoundBankers
                   scale:2
                   raiseOnExactness:NO
                   raiseOnOverflow:NO
                   raiseOnUnderflow:NO
                   raiseOnDivideByZero:YES];
        
        dictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        _wymSize = [UIScreen mainScreen].bounds.size;
        _wymnavHeight = 64;
        _wymtabHeight = 50;
        CGFloat scale;
        
        
        //导航栏标题 17 - 21  标签栏 10 - 24  正文14 - 18
        if (WYMJUDGEDEVICE) {
            scale =  [self wymRoundFloat:((_wymSize.height > 568) ? _wymSize.height / 568 : 1)];
            _wymnavFontSize = 18 * scale;
            _wymtabFontSize = 15 * scale;
            _wymtextFontSize = 16 * scale;
            _wymLine = 1;
        }else{
            scale =  [self wymRoundFloat:((_wymSize.height > 1024) ? _wymSize.height / 1024 : 1)];
            _wymnavFontSize = 20 * scale;
            _wymtabFontSize = 17 * scale;
            _wymtextFontSize = 18 * scale;
            _wymLine = 2;
        }
        
        
        _wymWhiteColor = [UIColor whiteColor];
        
        _wymBlackColor = [UIColor blackColor];
    }
    return self;
}


/**
 *获取字体的高宽
 *maxWidth 最大宽度
 *font 字体大小
 *str 内容
 *返回字体的高宽
 */
- (CGSize)wymGetFontSize:(float)maxWidth font:(UIFont *)font str:(NSString *)str{
    CGSize sizes = CGSizeMake(maxWidth,MAXFLOAT);
    
    [dictionary removeAllObjects];
    [dictionary setValue:font forKey:NSFontAttributeName];
    
    //实际尺寸
    CGSize size = [str boundingRectWithSize:sizes options:NSStringDrawingUsesLineFragmentOrigin attributes:dictionary context:nil].size;
    
    return size;
}

/**
 *四舍五入
 */
- (CGFloat)wymRoundFloat:(CGFloat)price{
    
    NSString *temp = [NSString stringWithFormat:@"%.7f",price];
    NSDecimalNumber *numResult = [NSDecimalNumber decimalNumberWithString:temp];
    
    return [[numResult decimalNumberByRoundingAccordingToBehavior:roundUp] floatValue];
}

/**
 *获取UINavigationController
 */
- (UINavigationController *)wymNavigation{
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    UIViewController *appRootVC = window.rootViewController;
    
    id  nextResponder = nil;
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    }else{
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    if ([nextResponder isKindOfClass:[UITabBarController class]]){
        UITabBarController * tabbar = (UITabBarController *)nextResponder;
        UINavigationController * nav = tabbar.selectedViewController; //上下两种写法都行
        return nav;
    }else if ([nextResponder isKindOfClass:[UINavigationController class]]){
        return nextResponder;
    }
    return nil;
}

/**
 *获取到当前的父视图 top
 *返回当前view
 */
- (UIView *)wymView{
    UIViewController* topViewController = self.wymNavigation.childViewControllers.lastObject;
    return topViewController.view;
}

/**
 *生成随机数
 */
- (NSString *)wymGenerateTradeNO:(int)num{
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < num; i++) {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

@end
