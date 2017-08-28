//
//  WYNav.m
//  ABC
//
//  Created by WY on 2017/8/5.
//  Copyright © 2017年 重庆远歌信息科技有限公司. All rights reserved.
//

#import "WYNav.h"
#import "WYModel.h"
@interface WYNav (){
    UIFont *btnFont;
    
    WYNavBlock myWYNavBlock;
    
    UIView *navigationBarView;//导航栏视图
    UIButton *nbv_Back;//返回按钮
    UILabel *nbv_Tit;//标题
    UIButton *nbv_RightOne;
    UIButton *nbv_RightTwo;
}

@end
@implementation WYNav

@synthesize tit = _tit,titColor = _titColor,rightOneText = _rightOneText,rightOneImage = _rightOneImage,rightTwoText = _rightTwoText,rightTwoImage = _rightTwoImage,hiddenBack = _hiddenBack,hiddenRightOne = _hiddenRightOne,hiddenRightTwo = _hiddenRightTwo;

- (id)initWithFrameNav{
    self = [super initWithFrame:CGRectMake(0, 0, WYMSIZE.width, WYMNAVHEIGHT)];
    if (self) {
        self.backgroundColor = WYMRGB(250.0, 88.0, 124.0, 1);
        
        float x = (self.frame.size.height - 20) * 2;
        
        nbv_Tit = [[UILabel alloc] initWithFrame:CGRectMake(x, 20, self.frame.size.width - x * 2, self.frame.size.height - 20)];
        nbv_Tit.textAlignment = NSTextAlignmentCenter;
        nbv_Tit.font = WYMFONTH(WYMAVFONTSIZE);
        _titColor = WYMWHITECOLOR;
        nbv_Tit.textColor = _titColor;
        [self addSubview:nbv_Tit];
        
        
        btnFont = WYMFONTH(WYMTABFONTSIZE);
    }
    return self;
}

/**
 *设置返回按钮的文字和图片
 */
- (void)setBackBtn:(NSString *)str image:(id)image{
    if ([str isEqualToString:@""] || image == nil) {
        if (nbv_Back != nil) {
            nbv_Back.hidden = YES;
        }
        return;
    }
    if(nbv_Back == nil){
        
        nbv_Back = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, nbv_Tit.frame.origin.x, self.frame.size.height - 20)];
        nbv_Back.titleLabel.font = btnFont;
        float width = nbv_Back.frame.size.height - 20;
        [nbv_Back setTitleColor:_titColor forState:UIControlStateNormal];
        nbv_Back.imageEdgeInsets = UIEdgeInsetsMake(10, 0, 10, nbv_Back.frame.size.width - width);
        //button标题的偏移量，这个偏移量是相对于图片的
        nbv_Back.titleEdgeInsets = UIEdgeInsetsMake(0, -(nbv_Back.frame.size.width + width), 0, 0);
        [nbv_Back addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        nbv_Back.tag = 0;
        [self addSubview:nbv_Back];
    }else{
        nbv_Back.hidden = NO;
    }
    
    [nbv_Back setTitle:str forState:UIControlStateNormal];
    
    if ([image isKindOfClass:[UIImage class]]) {
        [nbv_Back setImage:image forState:UIControlStateNormal];
    }else if ([image isKindOfClass:[NSString class]]){
        [nbv_Back setImage:WYMPNG(@"wym_back") forState:UIControlStateNormal];
    }
    
    
}

/*设置右边第一个按钮的文字*/
- (void)setRightOneText:(NSString *)rightOneText{
    if ([rightOneText isEqualToString:@""]) {
        if (nbv_RightOne != nil) {
            nbv_RightOne.hidden = YES;
        }
        return;
    }
    _rightOneText = rightOneText;
    [self createRightOne:rightOneText image:nil];
}

- (NSString *)rightOneText{
    return _rightOneText;
}

/*设置右边第一个按钮的图片*/
- (void)setRightOneImage:(UIImage *)rightOneImage{
    if (rightOneImage == nil) {
        if (nbv_RightOne != nil) {
            nbv_RightOne.hidden = YES;
        }
        return;
    }
    _rightOneImage = rightOneImage;
    [self createRightOne:@"" image:rightOneImage];
}

- (UIImage *)rightOneImage{
    return _rightOneImage;
}

#pragma 创建右边第一个按钮
- (void)createRightOne:(NSString *)str image:(UIImage *)image{
    
    if (nbv_RightOne == nil) {
        nbv_RightOne = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 0, self.frame.size.height - 20)];
        nbv_RightOne.titleLabel.font = btnFont;
        [nbv_RightOne setTitleColor:_titColor forState:UIControlStateNormal];
        nbv_RightOne.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        nbv_RightOne.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [nbv_RightOne addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        nbv_RightOne.tag = 1;
        [self addSubview:nbv_RightOne];
    }else{
        nbv_RightOne.hidden = NO;
    }
    
    [nbv_RightOne setTitle:@"" forState:UIControlStateNormal];
    [nbv_RightOne setImage:nil forState:UIControlStateNormal];
    if (![str isEqualToString:@""]){
        
        CGSize size = [WYMODEL wymGetFontSize:100 font:btnFont str:str];
        nbv_RightOne.frame = CGRectMake(self.frame.size.width - (size.width + 10), 20, size.width + 10, nbv_RightOne.frame.size.height);
        [nbv_RightOne setTitle:str forState:UIControlStateNormal];
    }
    
    if (image != nil) {
        float height = self.frame.size.height - 20;
        nbv_RightOne.frame = CGRectMake(self.frame.size.width - height, 20, height, height);
        [nbv_RightOne setImage:image forState:UIControlStateNormal];
    }
}


/*设置右边第二个按钮的文字*/
- (void)setRightTwoText:(NSString *)rightTwoText{
    if (nbv_RightOne == nil) {
        return;
    }
    
    if ([rightTwoText isEqualToString:@""]) {
        if (nbv_RightTwo != nil) {
            nbv_RightTwo.hidden = YES;
        }
        return;
    }
    _rightTwoText = rightTwoText;
    [self createRightTwo:rightTwoText image:nil];
}

- (NSString *)rightTwoText{
    return _rightTwoText;
}

/*设置右边第一个按钮的图片*/
- (void)setRightTwoImage:(UIImage *)rightTwoImage{
    if (nbv_RightOne == nil) {
        return;
    }
    if (rightTwoImage == nil) {
        if (nbv_RightTwo != nil) {
            nbv_RightTwo.hidden = YES;
        }
        return;
    }
    _rightTwoImage = rightTwoImage;
    [self createRightTwo:@"" image:rightTwoImage];
}

- (UIImage *)rightTwoImage{
    return _rightTwoImage;
}

#pragma 创建右边第二个按钮
- (void)createRightTwo:(NSString *)str image:(UIImage *)image{
    
    if (nbv_RightTwo == nil) {
        nbv_RightTwo = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 0, self.frame.size.height - 20)];
        nbv_RightTwo.titleLabel.font = btnFont;
        [nbv_RightTwo setTitleColor:_titColor forState:UIControlStateNormal];
        nbv_RightTwo.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        nbv_RightTwo.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
        [nbv_RightTwo addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        nbv_RightTwo.tag = 2;
        [self addSubview:nbv_RightTwo];
    }else{
        nbv_RightTwo.hidden = NO;
    }
    
    [nbv_RightTwo setTitle:@"" forState:UIControlStateNormal];
    [nbv_RightTwo setImage:nil forState:UIControlStateNormal];
    if (![str isEqualToString:@""]){
        
        CGSize size = [WYMODEL wymGetFontSize:100 font:btnFont str:str];
        nbv_RightTwo.frame = CGRectMake(nbv_RightOne.frame.origin.x - (size.width + 10), 20, size.width + 10, nbv_RightOne.frame.size.height);
        [nbv_RightTwo setTitle:str forState:UIControlStateNormal];
    }
    
    if (image != nil) {
        float height = self.frame.size.height - 20;
        nbv_RightTwo.frame = CGRectMake(nbv_RightOne.frame.origin.x - height, 20, height, height);
        [nbv_RightTwo setImage:image forState:UIControlStateNormal];
    }
}

#pragma 按钮点击事件
- (void)backClick:(UIButton *)btn{
    if (myWYNavBlock != nil) {
        myWYNavBlock(btn,btn.tag);
    }
}

/**
 *导航栏事件回调
 *0 是返回按钮   1是右边第一个按钮  2是右边第二个按钮
 */
- (void)navBarEventBlock:(WYNavBlock)block{
    myWYNavBlock = block;
}

#pragma 设置背景颜色
- (void)setChatBackgroundColor:(id)chatBackgroundColor{
    if (chatBackgroundColor != nil) {
        if ([chatBackgroundColor isKindOfClass:[UIColor class]]) {
            self.backgroundColor = chatBackgroundColor;
        }else if([chatBackgroundColor isKindOfClass:[UIImage class]]){
            self.backgroundColor = [UIColor colorWithPatternImage:chatBackgroundColor];
        }else{
            self.backgroundColor = nil;
        }
    }else{
        self.backgroundColor = nil;
    }
}

#pragma 设置标题文字
- (void)setTit:(NSString *)tit{
    _tit = tit;
    nbv_Tit.text = _tit;
}
- (NSString *)tit{
    return _tit;
}

#pragma 设置标题文字颜色
- (void)setTitColor:(UIColor *)titColor{
    _titColor = titColor;
    nbv_Tit.textColor = _titColor;
}
- (UIColor *)titColor{
    return _titColor;
}

- (void)setHiddenBack:(BOOL)hiddenBack{
    _hiddenBack = hiddenBack;
    nbv_Back.hidden = _hiddenBack;
}

- (BOOL)hiddenBack{
    return _hiddenBack;
}

- (void)setHiddenRightOne:(BOOL)hiddenRightOne{
    _hiddenRightOne = hiddenRightOne;
    nbv_RightOne.hidden = _hiddenRightOne;
}

- (BOOL)hiddenRightOne{
    return _hiddenRightOne;
}

- (void)setHiddenRightTwo:(BOOL)hiddenRightTwo{
    _hiddenRightTwo = hiddenRightTwo;
    nbv_RightTwo.hidden = _hiddenRightTwo;
}

- (BOOL)hiddenRightTwo{
    return _hiddenRightTwo;
}

@end
