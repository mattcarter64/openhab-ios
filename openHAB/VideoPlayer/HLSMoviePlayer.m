//
//  HLSMoviePlayer.m
//  DigitalLife
//
//  Created by Jay Zisch on 6/9/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import "HLSMoviePlayer.h"
@import MediaPlayer;

@implementation HLSMoviePlayer
{
    MPMoviePlayerController* _hlsMoviePlayer;
}

- (id) init
{
    if(self=[super init])
    {
        _hlsMoviePlayer = [[MPMoviePlayerController alloc] init];
        [_hlsMoviePlayer setControlStyle:MPMovieControlStyleNone];
        [_hlsMoviePlayer.view setUserInteractionEnabled:NO];
        [_hlsMoviePlayer setInitialPlaybackTime:1];
        [_hlsMoviePlayer setMovieSourceType:MPMovieSourceTypeStreaming];
        [_hlsMoviePlayer beginSeekingForward];
        //[_hlsMoviePlayer setCurrentPlaybackRate:.1];
    }
    return self;
}


+(VideoPlayer *)sharedVideoPlayer
{
    static HLSMoviePlayer* player;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        player = [[HLSMoviePlayer alloc] init];
    });
    return player;
}

- (void)start:(NSURL*)URL onView:(UIView*) view withCamera:(NSString*) camera andFeedVC:(UIViewController *)feedVC;
{
    [super start:URL onView:view withCamera:camera andFeedVC:feedVC];
   
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(_hlsMoviePlaybackStateChanged:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:_hlsMoviePlayer];
    
    [_hlsMoviePlayer setContentURL:URL];
    [_hlsMoviePlayer prepareToPlay];
    [_hlsMoviePlayer.view setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
    [view insertSubview:_hlsMoviePlayer.view atIndex:0];
    
    [_hlsMoviePlayer play];
}


- (void)stop
{
    [super stop];
    [_hlsMoviePlayer stop];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:_hlsMoviePlayer];
    [_hlsMoviePlayer.view removeFromSuperview];
    
}

- (int)resume
{
    [_hlsMoviePlayer play];
    [_hlsMoviePlayer.view removeFromSuperview];
    return 0;
}

- (int)suspend
{
    [_hlsMoviePlayer pause];
    [_hlsMoviePlayer.view removeFromSuperview];
    return 0;
}

-(void) _hlsMoviePlaybackStateChanged:(NSNotification*) hlsPlayerNotification
{
    
    MPMoviePlayerController* _hlsPlayer = [hlsPlayerNotification object];
    NSLog(@"%f",_hlsMoviePlayer.currentPlaybackTime);
    MPMoviePlaybackState playbackState = _hlsPlayer.playbackState;
    if(playbackState == MPMoviePlaybackStateStopped) {
        NSLog(@"MPMoviePlaybackStateStopped");
        [self setPlayerStatus:playerStateStop];
    } else if(playbackState == MPMoviePlaybackStatePlaying) {
        NSLog(@"MPMoviePlaybackStatePlaying");
        [self setPlayerStatus:playerStatePlay];
    } else if(playbackState == MPMoviePlaybackStatePaused) {
        NSLog(@"MPMoviePlaybackStatePaused");
    } else if(playbackState == MPMoviePlaybackStateInterrupted) {
        NSLog(@"MPMoviePlaybackStateInterrupted");
        [self setPlayerStatus:playerStateError];
    } else if(playbackState == MPMoviePlaybackStateSeekingForward) {
        NSLog(@"MPMoviePlaybackStateSeekingForward");
    } else if(playbackState == MPMoviePlaybackStateSeekingBackward) {
        NSLog(@"MPMoviePlaybackStateSeekingBackward");
    }
    
}

@end
