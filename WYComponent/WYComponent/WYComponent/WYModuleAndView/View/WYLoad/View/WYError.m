//
//  WYError.m
//  ABC
//
//  Created by WY on 2017/8/22.
//  Copyright © 2017年 重庆远歌信息科技有限公司. All rights reserved.
//

#import "WYError.h"
#import "WYModel.h"

static WYError *error;
static dispatch_once_t onceToken;


@interface WYError (){
    CAKeyframeAnimation * animation;
    NSTimer *timer;
    
    UIImage *failureImage;
    UIImage *successfulImage;
    
    UILabel *line;
    UILabel *msg;
    
    UIButton *rightBtn;
    
    UIImageView *leftImage;
    
}

@end

@implementation WYError

+ (WYError *)error{
    dispatch_once(&onceToken, ^{
        error = [[self alloc] initWithFrameError:CGRectMake(0, -(WYMNAVHEIGHT + 30), WYMSIZE.width, WYMNAVHEIGHT + 30)];
        [WYMODEL.wymNavigation.view addSubview:error];
    });
    return error;
}

- (id)initWithFrameError:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        failureImage = WYMPNG(@"error_failure");
        successfulImage = WYMPNG(@"error_successful");
        self.backgroundColor = WYMWHITECOLOR;
        
        line = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - WYMLINE, frame.size.width, WYMLINE)];
        line.backgroundColor = WYMRGB(200.0, 200.0, 200.0, 1);
        [self addSubview:line];
        
        float width = WYMFONTSIZE + 10;
        float y = ((frame.size.height - 50) - width) / 2 + 50;
        
        leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, y, width, width)];
        [self addSubview:leftImage];
        
        width = frame.size.height - 50;
        
        rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width - width, 50, width, width)];
        [rightBtn setImageEdgeInsets:UIEdgeInsetsMake(14, 18, 14, 10)];
        [rightBtn setImage:WYMPNG(@"error_fork") forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(chickEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:rightBtn];
        
        
        y = leftImage.frame.origin.x + leftImage.frame.size.width + 10;
        msg = [[UILabel alloc] initWithFrame:CGRectMake(y, 50, rightBtn.frame.origin.x - y, rightBtn.frame.size.height)];
        msg.numberOfLines = 2;
        msg.textColor = WYMBLACKCOLOR;
        msg.font = WYMFONTH(WYMFONTSIZE - 1);
        [self addSubview:msg];
        
        CGFloat duration = .5f;
        CGFloat height =  10.f;
        
        animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
        CGFloat currentTy = self.transform.ty;
        animation.duration = duration;
        animation.values =
        @[@(currentTy),
          @(currentTy - height/5),
          @(currentTy-height/4*2),
          @(currentTy-height/4*3),
          @(currentTy-height/4*4),
          @(currentTy - height),
          @(currentTy-height/4*4),
          @(currentTy -height/4*3),
          @(currentTy-height/4*2),
          @(currentTy - height/5),
          @(currentTy)];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        animation.repeatCount = 1;
        
    }
    return self;
}

/**
 *失败
 */
- (void)failure:(NSString *)str{
    leftImage.image = failureImage;
    [self show:str];
}

/**
 *成功
 */
- (void)successful:(NSString *)str{
    leftImage.image = successfulImage;
    [self show:str];
}

- (void)show:(NSString *)str{
    
    [WYMODEL.wymView endEditing:YES];
    
    [timer invalidate];
    timer = nil;
    
    msg.text = str;
    [UIView animateWithDuration:0.3 animations:^{
        self.y = -30;
    } completion:^(BOOL finished) {
        [self.layer  addAnimation:animation forKey:@"kViewShakerAnimationKey"];
        
        timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(hiddenErrorView) userInfo:nil repeats:NO];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }];
}

- (void)hiddenErrorView{
    
    if (self.y >= - 30) {
        [timer invalidate];
        timer = nil;
        [UIView animateWithDuration:0.3 animations:^{
            self.y = -self.frame.size.height;
        } completion:nil];
    }
}

#pragma 取消点击事件
- (void)chickEvent{
    [self hiddenErrorView];
}

@end
