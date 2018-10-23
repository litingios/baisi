//
//  Https.m
//  DYStudent
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Https.h"
#import "AFNetworking.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

@implementation Https

static AFHTTPSessionManager *manager;

+ (void)getDataWithURL:(NSString *)path parameter:(id)parameter success:(void(^)(id data))success failure:(void (^)(NSError * errorMessage))failure{
    NSString *scrJoinStr=[Https stirngWithjoinDic:parameter removelatitude:YES];
    //添加网络监听
    NSArray *pathcaches=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesPath  = [pathcaches objectAtIndex:0];
    NSString *mutableSting=[[NSMutableString alloc]initWithString:path];
    NSString *lastStr = [mutableSting stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSString *dispath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.text",lastStr,scrJoinStr]];
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    if(!manager){
        manager=[AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"text/json",@"text/javascript", nil]];
        manager.requestSerializer.timeoutInterval=30.f;
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    if (!parameter) {
        parameter=  [NSMutableDictionary  dictionary];
    }
    //    NSMutableDictionary * tempparameter=[(NSMutableDictionary *)parameter AddPublicParameter:parameter];
    //    NSString *jionStr=[Https stirngWithjoinDic:tempparameter removelatitude:NO];
    //    tempparameter[@"sign"] =[CJMD5 md5:[NSString stringWithFormat:@"%@aaaa876a",[CJMD5 md5:jionStr]]];
    //
    //    if(isNOLoadingAnimate)[[LoadIngVC shareVC] showloadingView];
    //    [[LoadIngVC shareVC] dissmissNoNetworkBgView];
    [manager GET:path parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //调试使用
        NSString *jionStr=[Https stirngWithjoinDic:parameter removelatitude:NO];
        jionStr=[NSString stringWithFormat:@"%@?%@",path,jionStr];
        NSLog(@"\n拼接好的测试地址：\n%@",jionStr);
        NSLog(@"\n接口------->%@\n参数------->%@结果----->\n%@",path,parameter,dic);
        
        if ([jionStr containsString:@"nextPage"]) {
            //            isNOLoadingAnimate = 0;
        }
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        if (![jionStr containsString:@"homemomo"]) {
            //            [[LoadIngVC shareVC] dissmissloadingView];
        }
        success(dic);
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            //缓存数据
//            BOOL isSave = [jsonStr writeToFile:dispath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            if(isSave){
//                NSLog(@"缓存数据成功");
//            }
//        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [Https showPastMyInfo:error path:path parameter:parameter success:success Failure:failure];
        //调试使用
        NSString *jionStr=[Https stirngWithjoinDic:parameter removelatitude:NO];
        jionStr=[NSString stringWithFormat:@"%@?%@",path,jionStr];
        NSLog(@"请求失败---->拼接好的测试地址：\n%@",jionStr);
    }];
}


+ (void)getDataJSonWithURL:(NSString *)path parameter:(id)parameter success:(void(^)(id data))success failure:(void (^)(NSError * errorMessage))failure{
    
    NSString *scrJoinStr=[Https stirngWithjoinDic:parameter removelatitude:YES];
    NSArray *pathcaches=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesPath  = [pathcaches objectAtIndex:0];
    NSString *mutableSting=[[NSMutableString alloc]initWithString:path];
    NSString *lastStr = [mutableSting stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSString *dispath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.text",lastStr,scrJoinStr]];
    // 1.获得网络监控的管理者
//    if(reach.currentReachabilityStatus==0){
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSString *str = [NSString stringWithContentsOfFile:dispath encoding:NSUTF8StringEncoding error:nil];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if(str){
//                    NSDictionary * dic2 = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//                    success(dic2);
//                }else{
//                    failure(nil);
//                }
//            });
//        });
//        return;
//    }
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];
    if(!manager){
        manager=[AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"text/json",@"text/javascript", nil]];
        manager.requestSerializer.timeoutInterval=30.f;
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    if (!parameter) {
        parameter=  [NSMutableDictionary  dictionary];
    }
//    NSString * picStr = [jjjjStr stringByReplacingOccurrencesOfString:@"," withString:@""];
    [manager GET:path parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //调试使用
        NSString *jionStr=[Https stirngWithjoinDic:parameter removelatitude:NO];
        jionStr=[NSString stringWithFormat:@"%@?%@",path,jionStr];
        NSLog(@"\n拼接好的测试地址：\n%@",jionStr);
        NSLog(@"\n接口------->%@\n参数------->%@结果----->\n%@",path,parameter,dic);
        
        if ([jionStr containsString:@"nextPage"]) {
        }
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        if (![jionStr containsString:@"homemomo"]) {
        }
        
        success(dic);
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            //缓存数据
//            BOOL isSave = [jsonStr writeToFile:dispath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            if(isSave){
//                NSLog(@"缓存数据成功");
//            }
//        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //调试使用
        NSString *jionStr=[Https stirngWithjoinDic:parameter removelatitude:NO];
        jionStr=[NSString stringWithFormat:@"%@?%@",path,jionStr];
        NSLog(@"请求失败---->拼接好的测试地址：\n%@",jionStr);
    }];
}

+ (void)postDataWithURL:(NSString *)path parameter:(id)parameter success:(void(^)(id data))success failure:(void (^)(NSError * errorMessage))failure{
    
    NSString *scrJoinStr=[Https stirngWithjoinDic:parameter removelatitude:YES];
    NSArray *pathcaches=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* cachesPath  = [pathcaches objectAtIndex:0];
    NSString *mutableSting=[[NSMutableString alloc]initWithString:path];
    NSString *lastStr = [mutableSting stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSString *dispath = [cachesPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%@.text",lastStr,scrJoinStr]];
    // 1.获得网络监控的管理者
//    if(reach.currentReachabilityStatus==0){
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            NSString *str = [NSString stringWithContentsOfFile:dispath encoding:NSUTF8StringEncoding error:nil];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if(str){
//                    NSDictionary * dic2 = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
//                    success(dic2);
//                }else{
//                    failure(nil);
//                }
//            });
//        });
//        return;
//    }
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:YES];    if(!manager){
        manager=[AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html",@"text/plain",@"text/json",@"text/javascript", nil]];
        manager.requestSerializer.timeoutInterval=30.f;
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
//    NSMutableDictionary *srcDic=[parameter copy];
//    NSMutableDictionary * tempparameter=[(NSMutableDictionary *)parameter AddPublicParameter:parameter];
//    NSString *jionStr=[Https stirngWithjoinDic:tempparameter removelatitude:NO];
//    tempparameter[@"sign"] =[CJMD5 md5:[NSString stringWithFormat:@"%@aaaa876a",[CJMD5 md5:jionStr]]];
//
//    if(isNOLoadingAnimate)[[LoadIngVC shareVC] showloadingView];
//    [[LoadIngVC shareVC] dissmissNoNetworkBgView];
    //字典转json
//    NSString * jsonStr = [DynamicClass UIUtilsFomateJsonWithDictionary:parameter];
    
//    NSString * jjjjStr = [NSString stringWithFormat:@"json=%@",jsonStr];
    //字符串转二进制
//    NSMutableData * data=[NSMutableData dataWithData:[jsonStr dataUsingEncoding:NSUTF8StringEncoding]];

    [manager POST:path parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *jsonStr=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        //调试使用
        NSString *jionStr=[Https stirngWithjoinDic:parameter removelatitude:NO];
        jionStr=[NSString stringWithFormat:@"%@?%@",path,jionStr];
        NSLog(@"\n拼接好的测试地址：\n%@",jionStr);
        if ([jionStr containsString:@"nextPage"]) {

        }
        //调试使用
        NSString *jionStrNOPublic=[Https stirngWithjoinDic:parameter removelatitude:NO];
        jionStrNOPublic=[NSString stringWithFormat:@"%@?%@",path,jionStrNOPublic];
        NSLog(@"\n拼接好的测试地址不加公共参数：\n%@",jionStrNOPublic);
        
        NSLog(@"\npath------->%@\n参数------->%@结果----->%@",path,parameter,dic);
        
        [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
        success(dic);
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            //缓存数据
//            BOOL isSave = [jsonStr writeToFile:dispath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            if(isSave){
//                NSLog(@"缓存数据成功");
//            }
//        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [Https showPastMyInfo:error path:path parameter:parameter success:success Failure:failure];
        //调试使用
        NSString *jionStr=[Https stirngWithjoinDic:parameter removelatitude:NO];
        jionStr=[NSString stringWithFormat:@"%@?%@",path,jionStr];
        NSLog(@"请求失败---->拼接好的测试地址：\n%@",jionStr);
    }];
}

#pragma mark------------拼接字符串
+(NSString *)stirngWithjoinDic:(NSDictionary *)tempparameter removelatitude:(BOOL) isRemove{

    NSArray*keys = [tempparameter allKeys];
    NSArray*sortedArray =  [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return[obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString *str=@"";
    
    for(NSString*categoryId in sortedArray) {
        
        id value = [tempparameter objectForKey:categoryId];

        if([str length] !=0) {
            
            str = [str stringByAppendingString:@"&"];
            
        }
        str = [str stringByAppendingFormat:@"%@=%@",categoryId,value];
        
    }
    
    return str;

   
}
-(NSString*)stringWithDict:(NSDictionary*)dict{
    
    NSArray*keys = [dict allKeys];
    NSArray*sortedArray =  [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
           return[obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSString *str=@"";
   
    for(NSString*categoryId in sortedArray) {
        
        id value = [dict objectForKey:categoryId];
        
        if([value isKindOfClass:[NSDictionary class]]) {
            
            value = [self stringWithDict:value];
            
        }
        
   
        
        if([str length] !=0) {
            
            str = [str stringByAppendingString:@";"];
            
        }
            str = [str stringByAppendingFormat:@"%@=%@",categoryId,value];
        
    }
    
    return str;
    
}

+(void)showPastMyInfo:(NSError * _Nonnull) error path:(NSString *)path parameter:(NSDictionary *)parameter success:(void(^)(id data))success Failure:(Failure)failure {

    
    if([error.localizedDescription isEqualToString:@"Request failed: forbidden (403)"]){
//        [Https relogin];
        
    }else{
        [Https getDataWithURL:path parameter:parameter success:success failure:failure];
        failure(error);
        NSLog(@"\npath------->%@\n参数------->%@结果失败----->%@",path,parameter,error);
    }
    [[UIApplication sharedApplication]setNetworkActivityIndicatorVisible:NO];
}
@end

/**
 *  增加公共参数签名
 */
@implementation NSDictionary (addPunlic)

//-(NSMutableDictionary *)AddPublicParameter:(NSMutableDictionary *)parameter {
//    NSString *nonceStr = [CJMD5 md5:[NSString stringWithFormat:@"%d",arc4random()%1000000+1000000]];
//    NSString *timestamp =[NSString stringWithFormat:@"%ld",(long)time(NULL)];
//
//    UserCenterInfo *info=[UserCenterInfo shareUsrcenterInfo];
//    NSString *token=nil;
//    if(info.last_time){
//        token=[CJMD5 md5:info.last_time];
//
//    }else{
//            token=@"mytest";
//    }
//
//    NSString *signature=[[NSString stringWithFormat:@"noncestr=%@&timestamp=%@&token=%@",nonceStr,timestamp,token] sha1];
//    if(info.mobile&&info.mobile.length==11){
//        parameter[@"phone"]=info.mobile;
//
//    }
//
//    static NSString *currentVersion;
//    if(!currentVersion){
//        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//        currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
//
//    }
//    parameter[@"version"] =  currentVersion;
//    parameter[@"terminal"]=@"1601";
//    parameter[@"nonceStr"]=nonceStr;
//    parameter[@"timestamp"]=timestamp;
//    parameter[@"signature"]=signature;
//    parameter[@"os"] =@"1502";
//
//    return parameter;
//
//}

@end


