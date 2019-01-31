//
//  DLVideoPlayer.h
//  DigitalLife
//
//  Created by Jay Zisch on 6/9/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

//#import "openHAB-Swift.h"

//@class Device;
typedef enum : NSUInteger {
    playerStateUnknown,
    playerStateStop,
    playerStatePlay,
    playerStateError,
    playerStateBuffer,
    playerStateOpen,
    playerStatePrivacy,
    playerStateNoSignal,
    playerStateOffline,
    playerStateLoading,
    playerStateURLLoading
} playerState;


typedef void (*URLFetchCompletionFn)(void *,bool,bool,NSString*);
typedef void (^URLFetchBlock)(void *,NSString *, URLFetchCompletionFn);

@interface VideoPlayer : NSObject
@property (nonatomic,assign) UIViewContentMode viewContentMode;
@property (nonatomic, weak) UIView* playView;
@property (atomic) playerState playerStatus; // KVO this property to update the UI
@property (atomic,strong) NSString* errorType; // if this is an empty string then there is no error
@property (atomic,strong) NSString* currentCamera;
@property (atomic,weak) UIViewController* currentVCPlaying;

-(void)setUrlFetchCallback:(URLFetchBlock)urlFetchBlock;

-(void)precharge:(NSArray<NSString*> *)cameraIds;

-(void)setKeepChargedTimeout:(int)val;
-(int)keepChargedTimeout;

- (void)restart:(UIView *)view withCamera:(NSString *)camera andFeedVC:(UIViewController *)feedVC onfailure:(void (^)(void))failureblock;
- (void)start:(NSURL*)URL onView:(UIView*) view withCamera:(NSString*) camera andFeedVC:(UIViewController*) feedVC;
- (void)stop;
- (void)pause;
- (void)discharge;
- (int)resume;
- (int)suspend;
- (void)zoomIn;
- (void)zoomOut;
- (void)resetToZoomDefault;
+ (VideoPlayer*) sharedVideoPlayer;
-(void)changeView:(UIView*)view andPresentingVC: (UIViewController*)vc;
- (void)enableAudioStream;
- (void)disableAudioStream;
@end
