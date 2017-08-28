//
//  WYAlert.m
//  ABC
//
//  Created by WY on 2017/8/5.
//  Copyright © 2017年 重庆远歌信息科技有限公司. All rights reserved.
//

#import "WYAlert.h"
#import "WYModel.h"

static WYAlert *alert;
static dispatch_once_t onceToken;



@interface WYAlert (){
    UIFont *font;
    
    UIView *alertView;//视图
    
    UILabel *av_Msg;
    
    UILabel *lineA;
    UILabel *lineB;
    
    UIButton *av_Determine;
    UIButton *av_Cancel;
    
    WYAlertBlock myWYAlertBlock;
}

@end

@implementation WYAlert

+ (WYAlert *)alert{
    
    dispatch_once(&onceToken, ^{
        alert = [[self alloc] initWithFramePhotoVideo];
        [WYMODEL.wymNavigation.view addSubview:alert];
    });
    return alert;
}

- (id)initWithFramePhotoVideo{
    self = [super initWithFrame:CGRectMake(0, 0, WYMSIZE.width, WYMSIZE.height)];
    if (self) {
        self.backgroundColor = WYMRGB(0, 0, 0, 0.3);
        
        float width = WYMFONTSIZE * 13 + 40;
        
        alertView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width - width) / 2, 0, width, 100)];
        alertView.layer.cornerRadius = 10;
        alertView.layer.masksToBounds = YES;
        alertView.backgroundColor = WYMWHITECOLOR;
        [self addSubview:alertView];
        
        
        
        font = WYMFONTH(WYMFONTSIZE);
        av_Msg = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, alertView.width - 40, WYMFONTSIZE)];
        av_Msg.font = font;
        av_Msg.textColor = WYMRGB(0, 0, 0, 0.85);
        av_Msg.textAlignment = NSTextAlignmentCenter;
        av_Msg.lineBreakMode = NSLineBreakByCharWrapping;//以字符为显示单位显
        av_Msg.numberOfLines = 0;
        [alertView addSubview:av_Msg];
        
        
        UIColor *lineColor = WYMRGB(218.0, 202.0, 154.0, 1);
        
        lineA = [[UILabel alloc] initWithFrame:CGRectMake(0, av_Msg.frame.size.height + av_Msg.frame.origin.y + 20, alertView.frame.size.width, WYMLINE)];
        lineA.backgroundColor = lineColor;
        [alertView addSubview:lineA];
        
        
        UIColor *btnColor = WYMRGB(10.0, 115.0, 255.0, 1);
        UIColor *selectBtnColor = WYMRGB(200.0, 200.0, 200.0, 1);
        UIFont *btnFont = WYMFONTH(WYMFONTSIZE - 1);
        
        
        av_Cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, lineA.frame.origin.y + WYMLINE, (alertView.frame.size.width - WYMLINE) / 2, WYMFONTSIZE + 25)];
        av_Cancel.titleLabel.font = btnFont;
        [av_Cancel setTitleColor:btnColor forState:UIControlStateNormal];
        [av_Cancel setTitleColor:selectBtnColor forState:UIControlStateHighlighted];
        av_Cancel.tag = 0;
        [alertView addSubview:av_Cancel];
        
        lineB = [[UILabel alloc] initWithFrame:CGRectMake(av_Cancel.frame.size.width, av_Cancel.frame.origin.y, WYMLINE, av_Cancel.frame.size.height)];
        lineB.backgroundColor  = lineColor;
        [alertView addSubview:lineB];
        
        av_Determine = [[UIButton alloc] initWithFrame:CGRectMake(av_Cancel.frame.size.width + WYMLINE, av_Cancel.frame.origin.y, av_Cancel.frame.size.width, av_Cancel.frame.size.height)];
        av_Determine.titleLabel.font = btnFont;
        [av_Determine setTitleColor:btnColor forState:UIControlStateNormal];
        [av_Determine setTitleColor:selectBtnColor forState:UIControlStateHighlighted];
        av_Determine.tag = 1;
        [alertView addSubview:av_Determine];
        
        [av_Determine addTarget:self action:@selector(alertBtnEvent:) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return self;
}

- (void)changeLayout:(NSString *)tit determine:(NSString *)determine cancel:(NSString *)cancel block:(WYAlertBlock)block{
    
    [WYMODEL.wymView endEditing:YES];
    
    myWYAlertBlock = block;
    
    
    
    if ([tit isEqualToString:@""]) {
        return;
    }
    
    if ([determine isEqualToString:@""]){
        determine = @"确定";
    }
    
    float msgHeight = WYMFONTSIZE - 3;
    float y = av_Msg.frame.origin.y + 20 + msgHeight;
    
    
    CGSize size = [WYMODEL wymGetFontSize:av_Msg.frame.size.width font:font str:tit];
    msgHeight = size.height + 1;
    y = av_Msg.frame.origin.y + 30 + msgHeight;
    
    
    av_Msg.frame = CGRectMake(av_Msg.frame.origin.x, av_Msg.frame.origin.y, av_Msg.frame.size.width, msgHeight);
    
    lineA.frame = CGRectMake(lineA.frame.origin.x, y, lineA.frame.size.width, lineA.frame.size.height);
    
    if ([cancel isEqualToString:@""]) {
        av_Cancel.hidden = YES;
        lineB.hidden = YES;
        
        av_Determine.frame = CGRectMake(0, lineA.frame.origin.y + lineA.frame.size.height, alertView.frame.size.width, av_Determine.frame.size.height);
    }else{
        av_Cancel.hidden = NO;
        lineB.hidden = NO;
        
        [av_Cancel setTitle:cancel forState:UIControlStateNormal];
        
        av_Cancel.frame = CGRectMake(0, lineA.frame.origin.y + lineA.frame.size.height, av_Cancel.frame.size.width, av_Cancel.frame.size.height);
        
        lineB.frame = CGRectMake(av_Cancel.frame.size.width, av_Cancel.frame.origin.y, lineB.frame.size.width, av_Cancel.frame.size.height);
        
        av_Determine.frame = CGRectMake(lineB.frame.size.width + lineB.frame.size.width, av_Cancel.frame.origin.y, av_Cancel.frame.size.width, av_Determine.frame.size.height);
    }
    
    y = av_Determine.frame.origin.y + av_Determine.frame.size.height;
    
    alertView.frame = CGRectMake(alertView.frame.origin.x, (self.frame.size.height - y ) / 2 - 10, alertView.frame.size.width, y);
    
    av_Msg.text = tit;
    [av_Determine setTitle:determine forState:UIControlStateNormal];
    
    self.hidden = NO;
}

/**
 *显示alert 自定义确定按钮文字
 */
- (void)show:(NSString *)tit determine:(NSString *)determine block:(WYAlertBlock)block{
    
    [self changeLayout:tit determine:determine cancel:@"" block:block];
    
}

/**
 *显示alert 自定义确定和取消按钮文字
 */
- (void)show:(NSString *)tit determine:(NSString *)determine cancel:(NSString *)cancel block:(WYAlertBlock)block{
    [self changeLayout:tit determine:determine cancel:cancel block:block];
}

/**
 *显示alert 只定义描述
 */
- (void)show:(NSString *)tit block:(WYAlertBlock)block{
    [self changeLayout:tit determine:@"" cancel:@"" block:block];
}


#pragma 点击事件
- (void)alertBtnEvent:(UIButton *)btn{
    if (myWYAlertBlock) {
        myWYAlertBlock(btn.tag);
    }
    
//    if ([_status isEqualToString:@"1"]) {
//        self.hidden = YES;
//    }
}

@end
