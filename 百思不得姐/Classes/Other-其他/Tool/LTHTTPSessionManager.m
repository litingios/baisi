//
//  LTHTTPSessionManager.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/17.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTHTTPSessionManager.h"

@implementation LTHTTPSessionManager

- (instancetype)initWithBaseURL:(NSURL *)url
{
    if (self = [super initWithBaseURL:url]) {
        //        self.securityPolicy.validatesDomainName = NO;
        //        self.responseSerializer = nil;
        //        self.requestSerializer = nil;
    }
    return self;
}

@end
