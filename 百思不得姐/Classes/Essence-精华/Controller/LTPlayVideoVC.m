//
//  LTPlayVideoVC.m
//  百思不得姐
//
//  Created by 李霆 on 2018/9/28.
//  Copyright © 2018年 李霆. All rights reserved.
//

#import "LTPlayVideoVC.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "DALabeledCircularProgressView.h"

@interface LTPlayVideoVC ()
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progress;
@property (weak,nonatomic)NSProgress *ltProgress;
@end

@implementation LTPlayVideoVC{
    AVPlayer *_player;
    AVPlayerItem *_playItem;
    AVPlayerLayer *_playerLayer;
    AVPlayerLayer *_fullPlayer;
    BOOL _isPlaying;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.progress.roundedCorners = 5;
    self.progress.backgroundColor = [UIColor grayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:)name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self create];
}

- (void)create
{
    _playItem = [AVPlayerItem playerItemWithURL:self.videoUrl];
    _player = [AVPlayer playerWithPlayerItem:_playItem];
    _playerLayer =[AVPlayerLayer playerLayerWithPlayer:_player];
    _playerLayer.frame = CGRectMake(0, 0, iPhone_Width, iPhone_Height-300*HeightScale);
    _playerLayer.videoGravity=AVLayerVideoGravityResizeAspectFill;//视频填充模式
    [self.view.layer addSublayer:_playerLayer];
    [_player play];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!_isPlaying) {
        _playerLayer.frame = [UIScreen mainScreen].bounds;
    }else{
        _playerLayer.frame = CGRectMake(0, 0, iPhone_Width, iPhone_Height-300*HeightScale);
    }
    _isPlaying = !_isPlaying;
}

-(void)playbackFinished:(NSNotification *)notification
{
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}


//-----下载视频--
- (void)playerDownload:(NSURL *)url{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString  *fullPath = [NSString stringWithFormat:@"%@/%@.mp4", documentsDirectory, url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSessionDownloadTask * task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        self.ltProgress = downloadProgress;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.ltProgress addObserver:self forKeyPath:@"fractionCompleted" options:NSKeyValueObservingOptionNew context:nil];
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self saveVideo:fullPath];
    }];
    
    [task resume];
    
}

//videoPath为视频下载到本地之后的本地路径
- (void)saveVideo:(NSString *)videoPath{
    
    if (videoPath) {
        NSURL *url = [NSURL URLWithString:videoPath];
        BOOL compatible = UIVideoAtPathIsCompatibleWithSavedPhotosAlbum([url path]);
        if (compatible)
        {
            //保存相册核心代码
            UISaveVideoAtPathToSavedPhotosAlbum([url path], self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
        }
    }
}


//保存视频完成之后的回调
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存视频失败"];
    }
    else {
        [SVProgressHUD showSuccessWithStatus:@"保存视频成功"];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_player pause];
    _player = nil;
}

- (IBAction)saveBtnCiled:(id)sender {
    [self playerDownload:self.videoUrl];
}

- (IBAction)backCiled:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)setVideoUrl:(NSURL *)videoUrl{
    _videoUrl = videoUrl;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger per = self.ltProgress.fractionCompleted*100;
        NSLog(@"%ld%%",(long)per);
        CGFloat progress = 1.0 * per / 100;
        self.progress.progress = progress;
        self.progress.progressLabel.textColor = [UIColor redColor];
        self.progress.progressLabel.text = [NSString stringWithFormat:@"%ld%%",per];
    });
}



@end
