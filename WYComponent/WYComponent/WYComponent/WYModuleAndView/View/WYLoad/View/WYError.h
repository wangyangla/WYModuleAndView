//
//  WYError.h
//  ABC
//
//  Created by WY on 2017/8/22.
//  Copyright © 2017年 重庆远歌信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYError : UIView

+ (WYError *)error;

/**
 *失败
 */
- (void)failure:(NSString *)str;

/**
 *成功
 */
- (void)successful:(NSString *)str;

- (void)hiddenErrorView;
@end
