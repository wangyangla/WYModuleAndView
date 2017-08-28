//
//  WYLoad.m
//  ABC
//
//  Created by WY on 2017/8/24.
//  Copyright © 2017年 重庆远歌信息科技有限公司. All rights reserved.
//

#import "WYLoad.h"
#import "WYModel.h"

static WYLoad *loading;
static dispatch_once_t onceToken;


#define HTTPS @"http://api.domii.top/v2/"

@interface WYLoad (){
    
    float maxWidth;
    
    UIFont *font;
    
    UIView *loadView;
    UIActivityIndicatorView *act;
    UILabel *msg;
    
    AFHTTPSessionManager *manager;
    
}

@end

@implementation WYLoad

+ (WYLoad *)loading{
    dispatch_once(&onceToken, ^{
        loading = [[self alloc] initWithFrameLoad:CGRectMake(0, 0, WYMSIZE.width, WYMSIZE.height)];
        [WYMODEL.wymNavigation.view addSubview:loading];
    });
    loading.hidden = YES;
    return loading;
}

- (id)initWithFrameLoad:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        maxWidth = WYMFONTSIZE * 10 + 40;
        
        self.backgroundColor = [UIColor greenColor];
        loadView = [[UIView alloc] init];
        loadView.layer.cornerRadius = 10;
        loadView.layer.masksToBounds = YES;
        loadView.backgroundColor = WYMRGB(0, 0, 0, 0.85);
        [self addSubview:loadView];
        
        act = [[UIActivityIndicatorView alloc] init];
        act.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [act setHidesWhenStopped:NO];
        act.color = WYMWHITECOLOR;
        [loadView addSubview:act];
        
        font = WYMFONTH(WYMFONTSIZE);
        msg = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, WYMFONTSIZE - 2)];
        msg.font = WYMFONTH(WYMFONTSIZE - 2);
        msg.lineBreakMode = NSLineBreakByCharWrapping;//以字符为显示单位显
        msg.numberOfLines = 0;
        msg.textColor = WYMWHITECOLOR;
        msg.textAlignment = NSTextAlignmentCenter;
        [loadView addSubview:msg];
        
        
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return self;
}


- (void)setFrameLv_View:(NSString *)str status:(NSString *)status{
    
    if ([status isEqualToString:@"1"]) {
        self.frame = CGRectMake(0, 0, self.frame.size.width, WYMSIZE.height);
    }else if ([status isEqualToString:@"2"]){
        self.frame = CGRectMake(0, WYMNAVHEIGHT, self.frame.size.width, WYMSIZE.height - WYMNAVHEIGHT);
    }else{
        self.frame = CGRectMake(0, WYMNAVHEIGHT, self.frame.size.width, WYMSIZE.height - WYMNAVHEIGHT - WYMTABHEIGHT);
    }
    
    if ([str isEqualToString:@""]) {
        msg.hidden = YES;
        
        float w = 77;
        
        loadView.frame = CGRectMake((self.frame.size.width - w) / 2, (self.frame.size.height - w) / 2 - 10, w, w);
        
        act.frame = CGRectMake(20, 20, 37, 37);
    }else{
        msg.hidden = NO;
        
        CGSize size = [WYMODEL wymGetFontSize:maxWidth font:font str:str];
        
        float w = 0;
        float h = 0;
        if (size.width <= 60) {
            h = 87 + (WYMFONTSIZE - 2);
            w = h;
        }else{
           w = size.width + 40;
            h = size.height + 87;
        }
        
        loadView.frame = CGRectMake((self.frame.size.width - w) / 2, (self.frame.size.height - h) / 2, w, h);
        act.frame = CGRectMake((w - 37) / 2, 20, 37, 37);

        msg.frame = CGRectMake(20, act.frame.origin.y + act.frame.size.height + 10, loadView.frame.size.width - 40, loadView.frame.size.height - 87);

        msg.text = str;
    }
    [act startAnimating];
    
}

- (void)showOne:(NSString *)str{
    if ([str isEqualToString:@"0"]) {
        [self dismiss];
        return;
    }
    [self setFrameLv_View:str status:@"1"];
    self.hidden = NO;
    loadView.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        loadView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showTwo:(NSString *)str{
    if ([str isEqualToString:@"0"]) {
        [self dismiss];
        return;
    }
    [self setFrameLv_View:str status:@"2"];
    self.hidden = NO;
    loadView.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        loadView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)showThree:(NSString *)str{
    if ([str isEqualToString:@"0"]) {
        [self dismiss];
        return;
    }
    [self setFrameLv_View:str status:@"3"];
    self.hidden = NO;
    loadView.alpha = 0;
    
    [UIView animateWithDuration:0.2 animations:^{
        loadView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)dismiss{
    [act stopAnimating];
    [UIView animateWithDuration:0.2 animations:^{
        loadView.alpha = 0;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}














/********************************* 网络请求 *********************************/

/**
 *下载文件
 *url 链接
 *urlSplice url拼接的字符串
 *tit 标题  0是不显示加载视图
 *loadType 加载的类型 1.全遮  2.导航栏不遮   3.导航栏和tab不遮
 *path 保存路径
 */
- (void)downloadFile:(NSString *)url urlSplice:(NSString *)urlSplice loadType:(NSString *)loadType tit:(NSString *)tit path:(NSString *)path success:(void (^)(NSMutableDictionary *data))success failure:(void (^)(NSMutableDictionary *error))failure{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    [self requestBeforeSetting:url urlSplice:urlSplice loadType:loadType tit:tit success:^(NSString *requestUrl) {
        
        manager.requestSerializer.timeoutInterval = MAXFLOAT;
        //2.确定请求的URL地址
        NSURL *fileUrl = [NSURL URLWithString:requestUrl];
        
        //3.创建请求对象
        NSURLRequest *request = [NSURLRequest requestWithURL:fileUrl];
        
        //下载任务
        NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            //打印下下载进度
            NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            return [NSURL fileURLWithPath:path];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            if (error) {
                [dic setValue:@"失败" forKey:@"msg"];
                [dic setValue:@"0" forKey:@"status"];
                if (failure) {
                    failure(dic);
                }
            }else{
                [dic setValue:@"成功" forKey:@"msg"];
                [dic setValue:@"1" forKey:@"status"];
                if (success) {
                    success(dic);
                }
            }
        }];
        
        //开始启动任务
        [task resume];
    } failure:^{
        [dic setValue:@"请求地址为空" forKey:@"msg"];
        [dic setValue:@"10000" forKey:@"status"];
        if (failure) {
            failure(dic);
        }
    }];
}

/**
 *请求 get
 */
- (void)requestGet:(NSString *)url urlSplice:(NSString *)urlSplice loadType:(NSString *)loadType tit:(NSString *)tit parameter:(NSMutableDictionary *)parameter success:(void (^)(NSMutableDictionary *data))success failure:(void (^)(NSMutableDictionary *error))failure{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self requestBeforeSetting:url urlSplice:urlSplice loadType:loadType tit:tit success:^(NSString *requestUrl) {
        manager.requestSerializer.timeoutInterval = 10;
        
        [manager GET:requestUrl parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self formattingData:responseObject dataDic:dic success:^(NSMutableDictionary *data) {
                if (success) {
                    success(data);
                }
            } failure:^(NSMutableDictionary *error) {
                if (failure) {
                    failure(error);
                }
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                [self error:error dictionary:dic];
                failure(dic);
            }
        }];
        
    } failure:^{
        [dic setValue:@"请求地址为空" forKey:@"msg"];
        [dic setValue:@"10000" forKey:@"status"];
        if (failure) {
            failure(dic);
        }
    }];
}

/**
 *请求 post
 */
- (void)requestPost:(NSString *)url urlSplice:(NSString *)urlSplice loadType:(NSString *)loadType tit:(NSString *)tit parameter:(NSMutableDictionary *)parameter success:(void (^)(NSMutableDictionary *data))success failure:(void (^)(NSMutableDictionary *error))failure{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self requestBeforeSetting:url urlSplice:urlSplice loadType:loadType tit:tit success:^(NSString *requestUrl) {
        manager.requestSerializer.timeoutInterval = 10;
        
        [manager POST:requestUrl parameters:parameter progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self formattingData:responseObject dataDic:dic success:^(NSMutableDictionary *data) {
                if (success) {
                    success(data);
                }
            } failure:^(NSMutableDictionary *error) {
                if (failure) {
                    failure(error);
                }
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                [self error:error dictionary:dic];
                failure(dic);
            }
        }];
        
    } failure:^{
        [dic setValue:@"请求地址为空" forKey:@"msg"];
        [dic setValue:@"10000" forKey:@"status"];
        if (failure) {
            failure(dic);
        }
    }];
}

/**
 *请求 Delete
 */
- (void)requestDelete:(NSString *)url urlSplice:(NSString *)urlSplice loadType:(NSString *)loadType tit:(NSString *)tit parameter:(NSMutableDictionary *)parameter success:(void (^)(NSMutableDictionary *data))success failure:(void (^)(NSMutableDictionary *error))failure{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self requestBeforeSetting:url urlSplice:urlSplice loadType:loadType tit:tit success:^(NSString *requestUrl) {
        manager.requestSerializer.timeoutInterval = 10;
        
        [manager DELETE:requestUrl parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self formattingData:responseObject dataDic:dic success:^(NSMutableDictionary *data) {
                if (success) {
                    success(data);
                }
            } failure:^(NSMutableDictionary *error) {
                if (failure) {
                    failure(error);
                }
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                [self error:error dictionary:dic];
                failure(dic);
            }
        }];
        
    } failure:^{
        [dic setValue:@"请求地址为空" forKey:@"msg"];
        [dic setValue:@"10000" forKey:@"status"];
        if (failure) {
            failure(dic);
        }
    }];
}

/**
 *请求 Put
 */
- (void)requestPut:(NSString *)url urlSplice:(NSString *)urlSplice loadType:(NSString *)loadType tit:(NSString *)tit parameter:(NSMutableDictionary *)parameter success:(void (^)(NSMutableDictionary *data))success failure:(void (^)(NSMutableDictionary *error))failure{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithCapacity:0];
    [self requestBeforeSetting:url urlSplice:urlSplice loadType:loadType tit:tit success:^(NSString *requestUrl) {
        manager.requestSerializer.timeoutInterval = 10;
        
        [manager PUT:requestUrl parameters:parameter success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [self formattingData:responseObject dataDic:dic success:^(NSMutableDictionary *data) {
                if (success) {
                    success(data);
                }
            } failure:^(NSMutableDictionary *error) {
                if (failure) {
                    failure(error);
                }
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                [self error:error dictionary:dic];
                failure(dic);
            }
        }];
        
    } failure:^{
        [dic setValue:@"请求地址为空" forKey:@"msg"];
        [dic setValue:@"10000" forKey:@"status"];
        if (failure) {
            failure(dic);
        }
    }];
}

/**
 *请求前设置
 */
- (void)requestBeforeSetting:(NSString *)url urlSplice:(NSString *)urlSplice loadType:(NSString *)loadType tit:(NSString *)tit success:(void (^)(NSString *requestUrl))success failure:(void (^)(void))failure{
    if ([loadType isEqualToString:@"1"]) {
        [self showOne:tit];
    }else if ([loadType isEqualToString:@"2"]){
        [self showTwo:tit];
    }else{
        [self showThree:tit];
    }
    
    NSString *getUrl = @"";
    if ([self urlValidation:url]) {
        getUrl = url;
    }else{
        getUrl = [self getUrl:url];
        if ([getUrl isEqualToString:@""]) {
            if (failure) {
                failure();
            }
            return;
        }
    }
    
    if (![urlSplice isEqualToString:@""]) {
        getUrl = [NSString stringWithFormat:@"%@/%@",getUrl,urlSplice];
    }
    
    //设置请求头
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"toke"]];
    if (![token isEqualToString:@"(null)"] && ![token isEqualToString:@""]) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"token"];
    }
    
    if (success) {
        success(getUrl);
    }
}

- (void)formattingData:(id _Nullable)responseObject dataDic:(NSMutableDictionary *)dataDic success:(void (^)(NSMutableDictionary *data))success failure:(void (^)(NSMutableDictionary *error))failure{
        
    NSError *err;
    NSMutableDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&err];
        
    NSLog(@"GET JSON    %@",jsonDic);
    [self dismiss];
        if (err) {
            [dataDic removeAllObjects];
            [dataDic setValue:@"数据出错,请重新请求!!!" forKey:@"msg"];
            [dataDic setValue:@"10001" forKey:@"status"];
            [dataDic setValue:@"10001" forKey:@"result"];
            failure(dataDic);
        }else{
            NSString *str = [NSString stringWithFormat:@"%@",jsonDic[@"status"]];
            
            if ([str isEqualToString:@"1"]) {
                NSString *result = [NSString stringWithFormat:@"%@",jsonDic[@"result"]];
                
                if ([result isEqualToString:@"<null>"] || [result isEqualToString:@""]) {
                    [dataDic removeAllObjects];
                    [dataDic setValue:@"没有获取到数据!!!" forKey:@"msg"];
                    [dataDic setValue:@"10002" forKey:@"status"];
                    [dataDic setValue:@"10002" forKey:@"result"];
                    failure(dataDic);
                }else{
                    success([self loopMutableDictionary:jsonDic]);
                }
            }else{
                failure(jsonDic);
            }
        }
}

- (NSMutableArray *)loopMutableArray:(id)array{
    NSMutableArray *newArray = [[NSMutableArray alloc] initWithCapacity:0];
    if ([array isKindOfClass:[NSArray class]] || [array isKindOfClass:[NSMutableArray class]]) {
        for (int i = 0; i < [array count]; i++) {
            id value = array[i];
            NSString *str = [NSString stringWithFormat:@"%@",value];
            
            if ([str isEqualToString:@"<null>"] || [str isEqualToString:@""]) {
                [newArray addObject:@""];
            }else{
                if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableDictionary class]]) {
                    [newArray addObject:[self loopMutableDictionary:value]];
                }else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSMutableArray class]]){
                    [newArray addObject:[self loopMutableArray:value]];
                }else{
                    [newArray addObject:[NSString stringWithFormat:@"%@",value]];
                }
            }
        }
    }
    return newArray;
}

- (NSMutableDictionary *)loopMutableDictionary:(id)dictionary{
    NSMutableDictionary *newDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    if ([dictionary isKindOfClass:[NSDictionary class]] || [dictionary isKindOfClass:[NSMutableDictionary class]]) {
        for (NSString *key in [dictionary allKeys]) {
            id value = dictionary[key];
            NSString *str = [NSString stringWithFormat:@"%@",value];
            
            if ([str isEqualToString:@"<null>"] || [str isEqualToString:@""]) {
                [newDictionary setValue:@"" forKey:key];
            }else{
                if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSMutableDictionary class]]) {
                    [newDictionary setValue:[self loopMutableDictionary:value] forKey:key];
                }else if ([value isKindOfClass:[NSMutableArray class]] || [value isKindOfClass:[NSArray class]]){
                    [newDictionary setValue:[self loopMutableArray:value] forKey:key];
                }else{
                    [newDictionary setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
                }
            }
        }
    }
    return newDictionary;
}

- (void)error:(NSError *)error dictionary:(NSMutableDictionary *)dictionary{
    NSLog(@"ERROR      %@",error);
    NSString *msg = [NSString stringWithFormat:@"%i",(int)error.code];
    
    if ([msg isEqualToString:@"-1001"]) {
        [dictionary setValue:@"请求超时!!!" forKey:@"msg"];
        [dictionary setValue:@"0" forKey:@"status"];
        [dictionary setValue:@"1001" forKey:@"result"];
    }else if([msg isEqualToString:@"-1009"]){
        [dictionary setValue:@"没有连接网络!!!" forKey:@"msg"];
        [dictionary setValue:@"0" forKey:@"status"];
        [dictionary setValue:@"1009" forKey:@"result"];
    }else if([msg isEqualToString:@"-1004"]){
        [dictionary setValue:@"没有网络" forKey:@"msg"];
        [dictionary setValue:@"0" forKey:@"status"];
        [dictionary setValue:@"1004" forKey:@"result"];
    }else{
        [dictionary setValue:@"请求出错!!!" forKey:@"msg"];
        [dictionary setValue:@"0" forKey:@"status"];
        [dictionary setValue:@"1000" forKey:@"result"];
    }
}

/**
 *正则 是不是网址
 */
- (BOOL)urlValidation:(NSString *)string{
    if([string isEqualToString:@""]){
        return NO;
    }
    NSString *urlRegex = @"http(s)?:\\/\\/([\\w-]+\\.)+[\\w-]+(\\/[\\w- .\\/?%&=]*)?";
    NSPredicate* urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegex];
    return [urlTest evaluateWithObject:string];
}

/**
 *
 */
- (NSString *)getUrl:(NSString *)url{
    int urlNum = [url intValue];
    if (urlNum == 1) {
        return @"https://api.weixin.qq.com/sns/";
    }else if (urlNum == 2){
        return [NSString stringWithFormat:@"%@uploadFiles",HTTPS];
    }else if (urlNum == 3){
        //修改头像
        return [NSString stringWithFormat:@"%@change/changeHeadImg",HTTPS];
    }
    return @"";
}

@end
