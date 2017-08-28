//
//  WYNav.h
//  ABC
//
//  Created by WY on 2017/8/5.
//  Copyright © 2017年 重庆远歌信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^WYNavBlock)(UIButton *btn,NSInteger idx);
@interface WYNav : UIView

@property (nonatomic,strong) id chatBackgroundColor;

@property (nonatomic) NSString *tit;
@property (nonatomic) UIColor *titColor;

/*设置右边第一个按钮的文字*/
@property (nonatomic) NSString *rightOneText;

/*设置右边第一个按钮的图片*/
@property (nonatomic) UIImage *rightOneImage;


/*设置右边第二个按钮的文字*/
@property (nonatomic) NSString *rightTwoText;

/*设置右边第二个按钮的图片*/
@property (nonatomic) UIImage *rightTwoImage;


@property (nonatomic) BOOL hiddenBack;

@property (nonatomic) BOOL hiddenRightOne;

@property (nonatomic) BOOL hiddenRightTwo;






- (id)initWithFrameNav;

/**
 *设置返回按钮的文字和图片
 */
- (void)setBackBtn:(NSString *)str image:(id)image;


/**
 *导航栏事件回调
 *0 是返回按钮   1是右边第一个按钮  2是右边第二个按钮
 */
- (void)navBarEventBlock:(WYNavBlock)block;

@end
