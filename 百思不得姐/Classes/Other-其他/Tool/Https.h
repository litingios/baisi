//
//  Https.h
//  DYStudent
//
//  Created by apple on 16/6/3.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void(^Success)(NSDictionary * responseObject);
typedef void (^Failure)(NSError * errorMessage);

@interface Https : NSObject


+ (void)getDataWithURL:(NSString *)path parameter:(id)parameter success:(void(^)(id data))success failure:(void (^)(NSError * errorMessage))failure;
+ (void)postDataWithURL:(NSString *)path parameter:(id)parameter success:(void(^)(id data))success failure:(void (^)(NSError * errorMessage))failure;
//Json串
+ (void)getDataJSonWithURL:(NSString *)path parameter:(id)parameter success:(void(^)(id data))success failure:(void (^)(NSError * errorMessage))failure;

@end


@interface NSDictionary (addPunlic)
-(NSMutableDictionary *)AddPublicParameter:(NSMutableDictionary *)parameter;
@end

