//
//  WYModel.h
//  ABC
//
//  Created by WY on 2017/8/5.
//  Copyright © 2017年 重庆远歌信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#define WYMODEL [WYModel model]

/*判断是iphone还是ipad*/
#define WYMJUDGEDEVICE (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? YES : NO)

#define WYMIOS9LATER ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)

#define WYMSIZE WYMODEL.wymSize//获取屏幕高宽
#define WYMNAVHEIGHT WYMODEL.wymnavHeight//获取导航栏高度
#define WYMTABHEIGHT WYMODEL.wymtabHeight
#define WYMAVFONTSIZE WYMODEL.wymnavFontSize//获取导航栏标题字体大小
#define WYMTABFONTSIZE WYMODEL.wymtabFontSize//获取标签字体大小
#define WYMFONTSIZE WYMODEL.wymtextFontSize//获取文字字体大小


#define WYMLINE WYMODEL.wymLine

#define WYMRGB(r ,g ,b ,a) [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a]//计算三色
#define WYMRGB16(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0green:(((s &0xFF00) >>8))/255.0blue:((s &0xFF))/255.0alpha:1.0]//计算三色16进制
/*
 *白色
 */
#define WYMWHITECOLOR WYMODEL.wymWhiteColor

/*
 *黑色
 */
#define WYMBLACKCOLOR WYMODEL.wymBlackColor

#define WYMPATH(name,suffix) [[NSBundle mainBundle] pathForResource:name ofType:suffix]

#define WYMPNG(name) [UIImage imageWithContentsOfFile:WYMPATH(name,@"png")]

#define WYMJPG(name) [UIImage imageWithContentsOfFile:WYMPATH(name,@"jpg")]

/**
 *粗体
 */
#define WYMFONTHB(fs) [UIFont fontWithName:@"Helvetica-Bold" size:fs]

/**
 *Helvetica
 */
#define WYMFONTH(fs) [UIFont fontWithName:@"Helvetica" size:fs]







#import "WYNav.h"
#import "WYAlert.h"
#import "WYLoad.h"
#import "WYError.h"
#import "UIView+Extension.h"




@interface WYModel : NSObject





@property (nonatomic) CGSize wymSize;
@property (nonatomic) CGFloat wymnavHeight;
@property (nonatomic) CGFloat wymtabHeight;
@property (nonatomic) CGFloat wymnavFontSize;
@property (nonatomic) CGFloat wymtabFontSize;
@property (nonatomic) CGFloat wymtextFontSize;


@property (nonatomic) CGFloat wymLine;


@property (nonatomic) UIColor *wymWhiteColor;
@property (nonatomic) UIColor *wymBlackColor;


/**
 *获取UINavigationController
 */
@property (nonatomic) UINavigationController *wymNavigation;

/**
 *获取到当前的父视图 top
 *返回当前view
 */
@property (nonatomic) UIView *wymView;

+ (WYModel *)model;

/**
 *获取字体的高宽
 *maxWidth 最大宽度
 *font 字体大小
 *str 内容
 *返回字体的高宽
 */
- (CGSize)wymGetFontSize:(float)maxWidth font:(UIFont *)font str:(NSString *)str;

/**
 *四舍五入
 */
- (CGFloat)wymRoundFloat:(CGFloat)price;

/**
 *生成随机数
 */
- (NSString *)wymGenerateTradeNO:(int)num;
@end
