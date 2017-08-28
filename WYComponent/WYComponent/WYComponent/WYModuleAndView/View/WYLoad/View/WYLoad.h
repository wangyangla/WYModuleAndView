//
//  WYLoad.h
//  ABC
//
//  Created by WY on 2017/8/24.
//  Copyright © 2017年 重庆远歌信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface WYLoad : UIView
+ (WYLoad *)loading;

- (void)showOne:(NSString *)str;

- (void)showTwo:(NSString *)str;

- (void)showThree:(NSString *)str;

- (void)dismiss;













/**
 *正则 是不是网址
 */
- (BOOL)urlValidation:(NSString *)string;

/**
 *数组不可变转可变
 */
- (NSMutableArray *)loopMutableArray:(id)array;

/**
 *字典不可变转可变
 */
- (NSMutableDictionary *)loopMutableDictionary:(id)dictionary;

- (void)error:(NSError *)error dictionary:(NSMutableDictionary *)dictionary;

/**
 *请求 get
 */
- (void)requestGet:(NSString *)url urlSplice:(NSString *)urlSplice loadType:(NSString *)loadType tit:(NSString *)tit parameter:(NSMutableDictionary *)parameter success:(void (^)(NSMutableDictionary *data))success failure:(void (^)(NSMutableDictionary *error))failure;

/**
 *请求 post
 */
- (void)requestPost:(NSString *)url urlSplice:(NSString *)urlSplice loadType:(NSString *)loadType tit:(NSString *)tit parameter:(NSMutableDictionary *)parameter success:(void (^)(NSMutableDictionary *data))success failure:(void (^)(NSMutableDictionary *error))failure;

/**
 *请求 Delete
 */
- (void)requestDelete:(NSString *)url urlSplice:(NSString *)urlSplice loadType:(NSString *)loadType tit:(NSString *)tit parameter:(NSMutableDictionary *)parameter success:(void (^)(NSMutableDictionary *data))success failure:(void (^)(NSMutableDictionary *error))failure;

/**
 *请求 Put
 */
- (void)requestPut:(NSString *)url urlSplice:(NSString *)urlSplice loadType:(NSString *)loadType tit:(NSString *)tit parameter:(NSMutableDictionary *)parameter success:(void (^)(NSMutableDictionary *data))success failure:(void (^)(NSMutableDictionary *error))failure;
@end
