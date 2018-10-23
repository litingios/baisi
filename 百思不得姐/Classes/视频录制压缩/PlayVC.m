//
//  PlayVC.m
//  iOSCamera
//
//  Created by BWF-HHW on 16/8/16.
//  Copyright © 2016年 HHW. All rights reserved.
//

#import "PlayVC.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface PlayVC (){
    AVPlayer *_player;
    AVPlayerItem *_playItem;
    AVPlayerLayer *_playerLayer;
    AVPlayerLayer *_fullPlayer;
    BOOL _isPlaying;
}

@property (strong, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UILabel *CommonLable;
@property (weak, nonatomic) IBOutlet UILabel *MoreLable;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end

@implementation PlayVC

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_player pause];
    _player = nil;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self create];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:)name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    
    //时间差
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       // self.saveBtn.enabled = YES;
    });
    
}


- (void)create
{
    _playItem = [AVPlayerItem playerItemWithURL:self.videoUrl];
    _player = [AVPlayer playerWithPlayerItem:_playItem];
    _playerLayer =[AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 0, iPhone_Width, iPhone_Height-500*HeightScale);
    _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
    [self.view.layer addSublayer:_playerLayer];
    [_player play];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_isPlaying) {
        _playerLayer.frame = [UIScreen mainScreen].bounds;
    }else{
        _playerLayer.frame = CGRectMake(0, 0, iPhone_Width, iPhone_Height-500*HeightScale);
    }
    _isPlaying = !_isPlaying;
}

-(void)playbackFinished:(NSNotification *)notification
{
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}


#pragma mark 保存压缩
//- (NSURL *)compressedURL
//{
//    //NSLog(@"时间戳----%ld", time(NULL));
//
//    return [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"%ld_compressed.mp4", time(NULL)]]];
//}


- (CGFloat)fileSize:(NSURL *)path
{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}

// 压缩视频
- (IBAction)compressVideo:(id)sender{
    NSLog(@"开始压缩,压缩前大小 %f MB",[self fileSize:self.videoUrl]);
    
    self.saveBtn.enabled = NO;
    NSURL *newVideoUrl ; //一般.mp4
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];//用时间给文件全名，以免重复，在测试的时候其实可以判断文件是否存在若存在，则删除，重新生成文件即可
    [formater setDateFormat:@"yyyy-MM-dd-HH:mm:ss"];
    newVideoUrl = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents/output-%@.mp4", [formater stringFromDate:[NSDate date]]]] ;//这个是保存在app自己的沙盒路径里，后面可以选择是否在上传后删除掉，减少空间。

    [self convertVideoQuailtyWithInputURL:self.videoUrl outputURL:(NSURL *)newVideoUrl completeHandler:nil];
//    //为了创建一个由URL标识的代表任何资源的assert对象，可以使用AVURLAssert，最简单的是从文件里创建一个assert对象：
//    AVURLAsset *avAsset = [[AVURLAsset alloc] initWithURL:self.videoUrl options:nil];
//
//    //你可以对视频进行转码、裁剪，通过使用AVAssetExportSession对象。
//    /**
//     *  一个export session是一个控制对象，可以异步的生成一个asset。可以用你需要生成的asset和presetName来初始化一个session，presetName指明你要生成的asset的属性。接下来你可以配置export session，比如可以指定输出的URL和文件类型，以及其他的设置，比如metadata等等。
//        你可以先检测设置的preset是否可用，通过使用exportPresetsCompatibleWithAsset:方法。
//     */
//    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
//
//    if ([compatiblePresets containsObject:AVAssetExportPresetLowQuality]) {
//
//        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPreset640x480];
//        exportSession.outputURL = [self compressedURL];
//        //优化网络
//        exportSession.shouldOptimizeForNetworkUse = true;
//        //转换后的格式
//        exportSession.outputFileType = AVFileTypeMPEG4;
//        //异步导出
//        [exportSession exportAsynchronouslyWithCompletionHandler:^{
//            // 如果导出的状态为完成
//            if ([exportSession status] == AVAssetExportSessionStatusCompleted) {
//                NSLog(@"压缩完毕,压缩后大小 %f MB",[self fileSize:[self compressedURL]]);
//                [self saveVideo:[self compressedURL]];
//            }else{
//                NSLog(@"当前压缩进度:%f",exportSession.progress);
//            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                self.saveBtn.enabled = YES;
//            });
//        }];
    
//    }
}


//ALAssetsLibrary提供了我们对iOS设备中的相片、视频的访问。
//- (void)saveVideo:(NSURL *)outputFileURL
//{
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library writeVideoAtPathToSavedPhotosAlbum:outputFileURL
//                                completionBlock:^(NSURL *assetURL, NSError *error) {
//                                    if (error) {
//                                        NSLog(@"保存视频失败:%@",error);
//                                    } else {
//                                        NSLog(@"保存视频到相册成功");
//                                    }
//                                }];
//}


- (void)saveVideo:(NSURL *)videoPath{
    if (videoPath) {
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([videoPath path])) {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([videoPath path], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}
//保存视频完成之后的回调
- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        NSLog(@"保存视频失败%@", error.localizedDescription);
    }
    else {
        NSLog(@"保存视频成功");
    }
    
}



-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



/**
 压缩完成调用上传
 
 @param inputURL 输入url
 @param outputURL 输出url
 @param handler AVAssetExportSession转码
 */
- (void) convertVideoQuailtyWithInputURL:(NSURL*)inputURL
                               outputURL:(NSURL*)outputURL
                         completeHandler:(void (^)(AVAssetExportSession*))handler
{
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:avAsset presetName:AVAssetExportPresetMediumQuality];
    
    exportSession.outputURL = outputURL;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse= YES;
    
    [exportSession exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (exportSession.status) {
             case AVAssetExportSessionStatusCancelled:
                 NSLog(@"AVAssetExportSessionStatusCancelled");
                 break;
             case AVAssetExportSessionStatusUnknown:
                 NSLog(@"AVAssetExportSessionStatusUnknown");
                 break;
             case AVAssetExportSessionStatusWaiting:
                 NSLog(@"AVAssetExportSessionStatusWaiting");
                 break;
             case AVAssetExportSessionStatusExporting:
                 NSLog(@"AVAssetExportSessionStatusExporting");
                 break;
             case AVAssetExportSessionStatusCompleted:{
                 //                 NSLog(@"AVAssetExportSessionStatusCompleted");
                 //UISaveVideoAtPathToSavedPhotosAlbum([outputURL path], self, nil, NULL);//这个是保存到手机相册
                 
                 dispatch_async(dispatch_get_global_queue(0, 0), ^{
                     CGFloat length = [self getVideoLength:outputURL];
                     CGFloat bigSize = [self getVideoLength:inputURL];
                     CGFloat size = [self getFileSize:[outputURL path]];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         self.CommonLable.text = [NSString stringWithFormat:@"视频时长:%.2f s 原本大小: %.2f M ",length,bigSize];
                         self.MoreLable.text = [NSString stringWithFormat:@"压缩后大小为：%.2f M",size];
                         NSLog(@"-------inturl%@-------",inputURL);
                         NSLog(@"-------outurl%@-------",outputURL);
                         [self saveVideo:outputURL];
                     });
                 });
                 
                 
//                 __weak __typeof(self) weakSelf = self;
//                 // Get center frame image asyncly
//                 [self centerFrameImageWithVideoURL:outputURL completion:^(UIImage *image) {
//                     weakSelf.FrameImageView.image = image;
//                 }];
//
//                 self.finalURL = outputURL;
//                 [self uploadVideo:outputURL];
             }
                 
                 break;
             case AVAssetExportSessionStatusFailed:
                 NSLog(@"AVAssetExportSessionStatusFailed");
                 break;
         }
         
     }];
}

/**
 获取视频时长
 
 @param url url
 @return s
 */
- (CGFloat)getVideoLength:(NSURL *)url{
    AVURLAsset *avUrl = [AVURLAsset assetWithURL:url];
    CMTime time = [avUrl duration];
    int second = ceil(time.value/time.timescale);
    return second;
}

/**
 获取文件大小
 
 @param path 路径
 @return M
 */
- (CGFloat)getFileSize:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size/1024/1024;
    }else{
        NSLog(@"找不到文件");
    }
    return filesize;
}

- (IBAction)backBtnCiled:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
