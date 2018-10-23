//
//  NSString+LTExtension.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/18.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "NSString+LTExtension.h"

@implementation NSString (LTExtension)

- (unsigned long long)fileSize{
    /*** cachePath获取到Caches文件夹 ****/
//    NSString * cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    //    LTLog(@"%@",cachePath);
    
    /*** 拼接到MP3文件夹路径 ****/
//    NSString *dirpath = [cachePath stringByAppendingString:@"/default"];
    
    unsigned long long size = 0;
    /*** 文件管理者 ****/
    NSFileManager *mgr =[NSFileManager defaultManager];
    //文件属性
//    NSDictionary *attrs = [mgr attributesOfItemAtPath:self error:nil];
//    LTLog(@"%@",attrs);
    /*** 文件路径是否存在 ****/
//    BOOL isRes = [mgr fileExistsAtPath:self];
    
    /*** 是否为文件夹 ****/
    //[[mgr attributesOfItemAtPath:self error:nil].fileType isEqualToString: NSFileTypeDirectory]
    BOOL isDirectory = NO;
    /*** 路径是否存在 ****/
    BOOL isExists = [mgr fileExistsAtPath:self isDirectory:&isDirectory];
    if (!isExists) return size;
    if (isDirectory) {
        /*** 递归子路径 ****/
        //    NSArray * subPaths = [mgr subpathsAtPath:dirpath];
        /*** 遍历器或者迭代器  ****/
        NSDirectoryEnumerator *enumerator = [mgr enumeratorAtPath:self];
        /*** 两种方法都可以 ****/
        //    enumerator == subPaths
        for (NSString * subpath in enumerator) {
            //全路径
            NSString * fullPath = [self stringByAppendingPathComponent:subpath];
            //文件属性
            NSDictionary * attrs = [mgr attributesOfItemAtPath:fullPath error:nil];
            //累加文件
            //        size+= [attrs[NSFileSize] unsignedIntegerValue];
            size += attrs.fileSize;
        }
    }else{
        //文件
        size = [mgr attributesOfItemAtPath:self error:nil].fileSize;
    }
    
//    LTLog(@"%llu",size);
    return size;
}


@end
