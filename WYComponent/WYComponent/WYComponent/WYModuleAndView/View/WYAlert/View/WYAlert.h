//
//  WYAlert.h
//  ABC
//
//  Created by WY on 2017/8/5.
//  Copyright © 2017年 重庆远歌信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WYAlertBlock)(NSInteger idx);

@interface WYAlert : UIView

@property (nonatomic) NSString *status;

+ (WYAlert *)alert;

/**
 *显示alert 自定义确定按钮文字
 */
- (void)show:(NSString *)tit determine:(NSString *)determine block:(WYAlertBlock)block;

/**
 *显示alert 自定义确定和取消按钮文字
 */
- (void)show:(NSString *)tit determine:(NSString *)determine cancel:(NSString *)cancel block:(WYAlertBlock)block;

/**
 *显示alert 只定义描述
 */
- (void)show:(NSString *)tit block:(WYAlertBlock)block;

@end
