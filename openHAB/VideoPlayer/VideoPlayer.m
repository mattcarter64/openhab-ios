//
//  DLVideoPlayer.m
//  DigitalLife
//
//  Created by Jay Zisch on 6/9/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import "VideoPlayer.h"
#import "Reachability.h"

@implementation VideoPlayer
{
    NSInteger _playTime;
    NSTimer* _playTimer;
}
- (id) init
{
    if(self=[super init])
    {
        _playerStatus = playerStateStop;
        _playTime = 0;
    }
    return self;
}

- (void)restart:(UIView *)view withCamera:(NSString *)camera andFeedVC:(UIViewController *)feedVC onfailure:(void (^)(void))failureblock
{
    // Immediately trigger failure by default
    failureblock();
}

-(void)setUrlFetchCallback:(URLFetchBlock)urlFetchBlock {
    
}

-(void)precharge:(NSArray<NSString*> *)cameraIds {
    
}

- (void)start:(NSURL*)URL onView:(UIView*) view withCamera:(NSString*) camera andFeedVC:(UIViewController *)feedVC;
{
    if (_playTimer) {
        _playTime = 0;
        [_playTimer invalidate];
        _playTimer = nil;
    }
    self.currentCamera = camera;
    self.playView = view;
    self.playView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    //Commented out for now, not being used to show alert - unnecessary timer _playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerSelector:) userInfo:nil repeats:YES];
    self.currentVCPlaying = feedVC;
}

- (void) zoomIn
{
    
}

- (void) zoomOut
{
    
}

- (void)resetToZoomDefault
{
    
}

-(void) discharge
{
    
}

-(void)changeView:(UIView*)view andPresentingVC: (UIViewController*)vc{
    [self.playView removeFromSuperview];
    [view addSubview:self.playView];
    self.playView.bounds = view.bounds;
    self.playView.center = view.center;
    //    [_motionJpegImageView removeFromSuperview];
    //    self.playView = view;
    //    //self.playView.autoresizingMask=(UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    //    self.currentVCPlaying = vc;
    //    _motionJpegImageView.frame = view.bounds;
    //    [view insertSubview:_motionJpegImageView atIndex:0];
}

- (void)stop
{
    self.currentCamera = nil;
    _playTime = 0;
    [_playTimer invalidate];
    _playTimer = nil;
    _currentVCPlaying = nil;
}

- (void)pause
{
    // by default call stop
    [self stop];
}

- (int)resume
{
    NSAssert(false, @"override");
    return 0;
}
- (int)suspend
{
    NSAssert(false, @"override");
    return 0;
}
+ (VideoPlayer*) sharedVideoPlayer
{
    NSAssert(false, @"override");
    return nil;
}

-(void) timerSelector:(NSTimer*) timer
{
    _playTime++;
    
    NetworkStatus currentStatus =[[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    
    if(_playTime >= 540 && (currentStatus == ReachableViaWWAN)){  // 9 min * 60 sec = 540 sec timeout
        [_playTimer invalidate];
        _playTimer = nil;
        _playTime = 0;
        _currentVCPlaying = nil;
        [self setPlayerStatus:playerStateError];
        [self setErrorType:@"9minPlay"];
        [self stop];
    }
}

- (void)enableAudioStream { }

- (void)disableAudioStream { }

-(void)setKeepChargedTimeout:(int)val {
    
}

-(int)keepChargedTimeout {
    return 0;
}


@end
